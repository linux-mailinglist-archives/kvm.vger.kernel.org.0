Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1601C75D9
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgEFQLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:11:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51254 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730180AbgEFQLH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 12:11:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588781466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=lLoDUV9kJciFEwN3SeREjB95wIUd6dwGcflYwkY6iE0=;
        b=OEwCYDBVi+44CJ8o9LcSIf0PpyluAdfJ1h8eKO0FDcKOyH73065QCIJBuWxVJwoaIOR9Z2
        3LyDzvfecYP5Rlfw8bf5WZUdTFdR5gebaOQPOmDsssgq9OR3+kWxRNFV1bRxxWtbPacuBn
        U3Pc0SKf8CQaGGkN7jVTLyJyLy+vIuU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-BHHAx-5aNTyydbcvJV2p_g-1; Wed, 06 May 2020 12:10:58 -0400
X-MC-Unique: BHHAx-5aNTyydbcvJV2p_g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C56D80BE32;
        Wed,  6 May 2020 16:10:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1C17165F6;
        Wed,  6 May 2020 16:10:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, linxl3@wangsu.com,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH 7/7] KVM: VMX: Handle preemption timer fastpath
Date:   Wed,  6 May 2020 12:10:48 -0400
Message-Id: <20200506161048.28840-8-pbonzini@redhat.com>
In-Reply-To: <20200506161048.28840-1-pbonzini@redhat.com>
References: <20200506161048.28840-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch implements a fastpath for the preemption timer vmexit.  The vmexit
can be handled quickly so it can be performed with interrupts off and going
back directly to the guest.

Testing on SKX Server.

cyclictest in guest(w/o mwait exposed, adaptive advance lapic timer is default -1):

5540.5ns -> 4602ns       17%

kvm-unit-test/vmexit.flat:

w/o avanced timer:
tscdeadline_immed: 3028.5  -> 2494.75  17.6%
tscdeadline:       5765.7  -> 5285      8.3%

w/ adaptive advance timer default -1:
tscdeadline_immed: 3123.75 -> 2583     17.3%
tscdeadline:       4663.75 -> 4537      2.7%

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1588055009-12677-8-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 60065e01f1cd..d5f5a212f2b3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5575,14 +5575,22 @@ static int handle_pml_full(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int handle_preemption_timer(struct kvm_vcpu *vcpu)
+static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (!vmx->req_immediate_exit &&
-	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled))
+	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
 		kvm_lapic_expired_hv_timer(vcpu);
+		return EXIT_FASTPATH_REENTER_GUEST;
+	}
+
+	return EXIT_FASTPATH_NONE;
+}
 
+static int handle_preemption_timer(struct kvm_vcpu *vcpu)
+{
+	handle_fastpath_preemption_timer(vcpu);
 	return 1;
 }
 
@@ -6605,6 +6613,8 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	switch (to_vmx(vcpu)->exit_reason) {
 	case EXIT_REASON_MSR_WRITE:
 		return handle_fastpath_set_msr_irqoff(vcpu);
+	case EXIT_REASON_PREEMPTION_TIMER:
+		return handle_fastpath_preemption_timer(vcpu);
 	default:
 		return EXIT_FASTPATH_NONE;
 	}
-- 
2.18.2

