Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED43C1C75D3
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbgEFQLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:11:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22656 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730105AbgEFQK7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 12:10:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588781458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=r4rhVilOhruX4XKG1ij307CAZ6f9s9Do/ND2GQqMS9Y=;
        b=hvGZ93OZF1DReioUBOb7y/fxCv5BLkf55t5I+sTMOXqaUJDK0X86KQ1zJAj6zBs4hfm3US
        0DZpt0teWbTE3oyZAUzWMYzzUj8y8yBy9Dqw0VUNYZFe6V8bE7ywtqpRgg9XXXbCvU6KaB
        jktXDQ2p/xr1CSQm6Mqg067gYqK83eE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-bBD4DxCrOTqO_mJt42tz8Q-1; Wed, 06 May 2020 12:10:56 -0400
X-MC-Unique: bBD4DxCrOTqO_mJt42tz8Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA65145F;
        Wed,  6 May 2020 16:10:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0A27165F6;
        Wed,  6 May 2020 16:10:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, linxl3@wangsu.com,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH 4/7] KVM: VMX: Optimize posted-interrupt delivery for timer fastpath
Date:   Wed,  6 May 2020 12:10:45 -0400
Message-Id: <20200506161048.28840-5-pbonzini@redhat.com>
In-Reply-To: <20200506161048.28840-1-pbonzini@redhat.com>
References: <20200506161048.28840-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

While optimizing posted-interrupt delivery especially for the timer
fastpath scenario, I measured kvm_x86_ops.deliver_posted_interrupt()
to introduce substantial latency because the processor has to perform
all vmentry tasks, ack the posted interrupt notification vector,
read the posted-interrupt descriptor etc.

This is not only slow, it is also unnecessary when delivering an
interrupt to the current CPU (as is the case for the LAPIC timer) because
PIR->IRR and IRR->RVI synchronization is already performed on vmentry
Therefore skip kvm_vcpu_trigger_posted_interrupt in this case, and
instead do vmx_sync_pir_to_irr() on the EXIT_FASTPATH_REENTER_GUEST
fastpath as well.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1588055009-12677-6-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 +++-
 virt/kvm/kvm_main.c    | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 215ae9682da1..b980481436e9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3928,7 +3928,8 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	if (pi_test_and_set_on(&vmx->pi_desc))
 		return 0;
 
-	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
+	if (vcpu != kvm_get_running_vcpu() &&
+	    !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
 		kvm_vcpu_kick(vcpu);
 
 	return 0;
@@ -6803,6 +6804,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 			 * but it would incur the cost of a retpoline for now.
 			 * Revisit once static calls are available.
 			 */
+			vmx_sync_pir_to_irr(vcpu);
 			goto reenter_guest;
 		}
 		exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 825d501df158..7f675d525981 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4638,6 +4638,7 @@ struct kvm_vcpu *kvm_get_running_vcpu(void)
 
 	return vcpu;
 }
+EXPORT_SYMBOL_GPL(kvm_get_running_vcpu);
 
 /**
  * kvm_get_running_vcpus - get the per-CPU array of currently running vcpus.
-- 
2.18.2


