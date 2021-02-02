Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B9B30C6B1
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 17:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbhBBQzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 11:55:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236859AbhBBQxO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 11:53:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612284707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+no4pVcxK0Ryw/Cg28AE5hUfIMaqqpwblqhkZUu/y2g=;
        b=Z1c0UgywEa7c/47U7EI1Agf7hJmbDtKF5bAUtcQ++Xi4arVZfDCXFYKOax1J5HY98ilWm4
        kQeOiwA4n4paWaA4utAsiDQctZokj7B7TTNLa30u0YDyCMLWCoPwxiX9WkyKatHD03WrOg
        OoFwlApc5s2TYPCu/GyCMZt43mUVNy8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-oTTUywoSPkqb8lGd7mhkYA-1; Tue, 02 Feb 2021 11:51:45 -0500
X-MC-Unique: oTTUywoSPkqb8lGd7mhkYA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F11110074C3;
        Tue,  2 Feb 2021 16:51:43 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C2196EF46;
        Tue,  2 Feb 2021 16:51:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 3/3] KVM: x86: move kvm_inject_gp up from kvm_set_dr to callers
Date:   Tue,  2 Feb 2021 11:51:41 -0500
Message-Id: <20210202165141.88275-4-pbonzini@redhat.com>
In-Reply-To: <20210202165141.88275-1-pbonzini@redhat.com>
References: <20210202165141.88275-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Push the injection of #GP up to the callers, so that they can just use
kvm_complete_insn_gp. __kvm_set_dr is pretty much what the callers can use
together with kvm_complete_insn_gp, so rename it to kvm_set_dr and drop
the old kvm_set_dr wrapper.

This allows nested VMX code, which really wanted to use __kvm_set_dr, to
use the right function.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 14 +++++++-------
 arch/x86/kvm/vmx/vmx.c | 19 ++++++++++---------
 arch/x86/kvm/x86.c     | 19 +++++--------------
 3 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c0d41a6920f0..818cf3babef2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2599,6 +2599,7 @@ static int dr_interception(struct vcpu_svm *svm)
 {
 	int reg, dr;
 	unsigned long val;
+	int err;
 
 	if (svm->vcpu.guest_debug == 0) {
 		/*
@@ -2617,19 +2618,18 @@ static int dr_interception(struct vcpu_svm *svm)
 	reg = svm->vmcb->control.exit_info_1 & SVM_EXITINFO_REG_MASK;
 	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
 
+	if (!kvm_require_dr(&svm->vcpu, dr & 15))
+		return 1;
+
 	if (dr >= 16) { /* mov to DRn */
-		if (!kvm_require_dr(&svm->vcpu, dr - 16))
-			return 1;
 		val = kvm_register_read(&svm->vcpu, reg);
-		kvm_set_dr(&svm->vcpu, dr - 16, val);
+		err = kvm_set_dr(&svm->vcpu, dr - 16, val);
 	} else {
-		if (!kvm_require_dr(&svm->vcpu, dr))
-			return 1;
-		kvm_get_dr(&svm->vcpu, dr, &val);
+		err = kvm_get_dr(&svm->vcpu, dr, &val);
 		kvm_register_write(&svm->vcpu, reg, val);
 	}
 
-	return kvm_skip_emulated_instruction(&svm->vcpu);
+	return kvm_complete_insn_gp(&svm->vcpu, err);
 }
 
 static int cr8_write_interception(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a07fce6d0bbb..41a26d98fb95 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5099,6 +5099,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qualification;
 	int dr, dr7, reg;
+	int err = 1;
 
 	exit_qualification = vmx_get_exit_qual(vcpu);
 	dr = exit_qualification & DEBUG_REG_ACCESS_NUM;
@@ -5107,9 +5108,9 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	if (!kvm_require_dr(vcpu, dr))
 		return 1;
 
-	/* Do not handle if the CPL > 0, will trigger GP on re-entry */
-	if (!kvm_require_cpl(vcpu, 0))
-		return 1;
+	if (kvm_x86_ops.get_cpl(vcpu) > 0)
+		goto out;
+
 	dr7 = vmcs_readl(GUEST_DR7);
 	if (dr7 & DR7_GD) {
 		/*
@@ -5146,14 +5147,14 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	if (exit_qualification & TYPE_MOV_FROM_DR) {
 		unsigned long val;
 
-		if (kvm_get_dr(vcpu, dr, &val))
-			return 1;
+		err = kvm_get_dr(vcpu, dr, &val);
 		kvm_register_write(vcpu, reg, val);
-	} else
-		if (kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg)))
-			return 1;
+	} else {
+		err = kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg));
+	}
 
-	return kvm_skip_emulated_instruction(vcpu);
+out:
+	return kvm_complete_insn_gp(vcpu, err);
 }
 
 static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index edbeb162012b..b748bf0d6d33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1147,7 +1147,7 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
 	return fixed;
 }
 
-static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
+int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 {
 	size_t size = ARRAY_SIZE(vcpu->arch.db);
 
@@ -1160,13 +1160,13 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 	case 4:
 	case 6:
 		if (!kvm_dr6_valid(val))
-			return -1; /* #GP */
+			return 1; /* #GP */
 		vcpu->arch.dr6 = (val & DR6_VOLATILE) | kvm_dr6_fixed(vcpu);
 		break;
 	case 5:
 	default: /* 7 */
 		if (!kvm_dr7_valid(val))
-			return -1; /* #GP */
+			return 1; /* #GP */
 		vcpu->arch.dr7 = (val & DR7_VOLATILE) | DR7_FIXED_1;
 		kvm_update_dr7(vcpu);
 		break;
@@ -1174,15 +1174,6 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 
 	return 0;
 }
-
-int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
-{
-	if (__kvm_set_dr(vcpu, dr, val)) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-	return 0;
-}
 EXPORT_SYMBOL_GPL(kvm_set_dr);
 
 int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
@@ -6595,7 +6586,7 @@ static int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
 			   unsigned long value)
 {
 
-	return __kvm_set_dr(emul_to_vcpu(ctxt), dr, value);
+	return kvm_set_dr(emul_to_vcpu(ctxt), dr, value);
 }
 
 static u64 mk_cr_64(u64 curr_cr, u32 new_val)
@@ -8636,7 +8627,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	dt.address = dt.size = 0;
 	static_call(kvm_x86_set_idt)(vcpu, &dt);
 
-	__kvm_set_dr(vcpu, 7, DR7_FIXED_1);
+	kvm_set_dr(vcpu, 7, DR7_FIXED_1);
 
 	cs.selector = (vcpu->arch.smbase >> 4) & 0xffff;
 	cs.base = vcpu->arch.smbase;
-- 
2.26.2

