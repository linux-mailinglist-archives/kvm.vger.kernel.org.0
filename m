Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3587B1C75E4
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgEFQLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:11:33 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47259 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730097AbgEFQK6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 12:10:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588781458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=mO2cbCNKcikCnw3F7MmMk3VRPD9PlPNFWjMwHjblbP0=;
        b=YU+G0bbeE54tb6rUvRIljziKtRQ5KihmOuStjxgHAMNnfTP7W962jG2HeMLGEfD10Ry+Ss
        8C/CXJTBWr3260HgZ9lur0xqoCTWMUOOevoh0d9EyTvWyPvkcrkuOPfp0Ig6pmXt996lgW
        ZiAlgXVdzfsPYk5JStM6UU9mfzJNp3s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-_1iY6fShO8WrymE-8YA11A-1; Wed, 06 May 2020 12:10:54 -0400
X-MC-Unique: _1iY6fShO8WrymE-8YA11A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6C4C100A8E7;
        Wed,  6 May 2020 16:10:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A1D6165F6;
        Wed,  6 May 2020 16:10:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, linxl3@wangsu.com,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH 2/7] KVM: X86: Introduce kvm_vcpu_exit_request() helper
Date:   Wed,  6 May 2020 12:10:43 -0400
Message-Id: <20200506161048.28840-3-pbonzini@redhat.com>
In-Reply-To: <20200506161048.28840-1-pbonzini@redhat.com>
References: <20200506161048.28840-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Introduce kvm_vcpu_exit_request() helper, we need to check some conditions
before enter guest again immediately, we skip invoking the exit handler and
go through full run loop if complete fastpath but there is stuff preventing
we enter guest again immediately.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1588055009-12677-5-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++--
 arch/x86/kvm/x86.h |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e7017c656311..999275795bba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1581,6 +1581,13 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
+bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
+{
+	return vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu) ||
+		need_resched() || signal_pending(current);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_exit_request);
+
 /*
  * The fast path for frequent and performance sensitive wrmsr emulation,
  * i.e. the sending of IPI, sending IPI early in the VM-Exit flow reduces
@@ -8365,8 +8372,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
 		kvm_x86_ops.sync_pir_to_irr(vcpu);
 
-	if (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
-	    || need_resched() || signal_pending(current)) {
+	if (kvm_vcpu_exit_request(vcpu)) {
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		smp_wmb();
 		local_irq_enable();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7b5ed8ed628e..e02fe28254b6 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -364,5 +364,6 @@ static inline bool kvm_dr7_valid(u64 data)
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
+bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
 
 #endif
-- 
2.18.2


