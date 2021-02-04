Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6C530F83A
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 17:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbhBDQlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 11:41:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236997AbhBDO4T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 09:56:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612450492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8iBj0wuM07dI7iQONn5zv06J3XRXvw3wPfuXWUn8/9g=;
        b=dwzOJTdtiYjUJW0ucQz/kipc28HWwGVvznXpwIBmiy8regFnG2NiO+pjqt/Uw9u/8PAeEx
        nxlDGDlGaood07HDs2g4u2fvJ0ICwvbFlkAoAE6eExC5XlzDNbXvapYewoWGg5+LTt3Ny1
        fZTcn2+SAicKHzH0Buc65cvq66UW+Y8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-p7j8p1xbPkCObg9Myn3T9A-1; Thu, 04 Feb 2021 09:54:49 -0500
X-MC-Unique: p7j8p1xbPkCObg9Myn3T9A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45986107ACE4;
        Thu,  4 Feb 2021 14:54:35 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA49C60BE2;
        Thu,  4 Feb 2021 14:54:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 2/2] KVM: x86: move kvm_inject_gp up from kvm_set_dr to callers
Date:   Thu,  4 Feb 2021 09:54:33 -0500
Message-Id: <20210204145433.243806-3-pbonzini@redhat.com>
In-Reply-To: <20210204145433.243806-1-pbonzini@redhat.com>
References: <20210204145433.243806-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Push the injection of #GP up to the callers, since they can just use
kvm_complete_insn_gp and __kvm_set_dr pretty much returns what the
callers can pass to kvm_complete_insn_gp.

Therefore, rename __kvm_set_dr to kvm_set_dr and drop the kvm_set_dr
wrapper.  This also allows nested VMX code, which really wanted to use
__kvm_set_dr, to use the right function.

While at it, remove the kvm_require_dr() check from the SVM handler.
The APM states:

  All normal exception checks take precedence over the SVM intercepts.

and that includes the CR4.DE=1 #UD.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 13 +++++--------
 arch/x86/kvm/vmx/vmx.c | 17 ++++++++++-------
 arch/x86/kvm/x86.c     | 19 +++++--------------
 3 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4141caea857a..ea1bd96a9804 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2619,6 +2619,7 @@ static int dr_interception(struct vcpu_svm *svm)
 {
 	int reg, dr;
 	unsigned long val;
+	int err = 0;
 
 	if (svm->vcpu.guest_debug == 0) {
 		/*
@@ -2636,20 +2637,16 @@ static int dr_interception(struct vcpu_svm *svm)
 
 	reg = svm->vmcb->control.exit_info_1 & SVM_EXITINFO_REG_MASK;
 	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
-
 	if (dr >= 16) { /* mov to DRn */
-		if (!kvm_require_dr(&svm->vcpu, dr - 16))
-			return 1;
+		dr -= 16;
 		val = kvm_register_read(&svm->vcpu, reg);
-		kvm_set_dr(&svm->vcpu, dr - 16, val);
+		err = kvm_set_dr(&svm->vcpu, dr, val);
 	} else {
-		if (!kvm_require_dr(&svm->vcpu, dr))
-			return 1;
 		kvm_get_dr(&svm->vcpu, dr, &val);
 		kvm_register_write(&svm->vcpu, reg, val);
 	}
 
-	return kvm_skip_emulated_instruction(&svm->vcpu);
+	return kvm_complete_insn_gp(&svm->vcpu, err);
 }
 
 static int cr8_write_interception(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 049fbbd0aa1a..13898871e5b0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5095,6 +5095,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qualification;
 	int dr, dr7, reg;
+	int err = 1;
 
 	exit_qualification = vmx_get_exit_qual(vcpu);
 	dr = exit_qualification & DEBUG_REG_ACCESS_NUM;
@@ -5103,9 +5104,9 @@ static int handle_dr(struct kvm_vcpu *vcpu)
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
@@ -5144,11 +5145,13 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 
 		kvm_get_dr(vcpu, dr, &val);
 		kvm_register_write(vcpu, reg, val);
-	} else
-		if (kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg)))
-			return 1;
+		err = 0;
+	} else {
+		err = kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg));
+	}
 
-	return kvm_skip_emulated_instruction(vcpu);
+out:
+	return kvm_complete_insn_gp(vcpu, err);
 }
 
 static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dcb67429b75d..baa90ae76ba5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1143,7 +1143,7 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
 	return fixed;
 }
 
-static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
+int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 {
 	size_t size = ARRAY_SIZE(vcpu->arch.db);
 
@@ -1156,13 +1156,13 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
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
@@ -1170,15 +1170,6 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 
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
 
 void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
@@ -6619,7 +6610,7 @@ static int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
 			   unsigned long value)
 {
 
-	return __kvm_set_dr(emul_to_vcpu(ctxt), dr, value);
+	return kvm_set_dr(emul_to_vcpu(ctxt), dr, value);
 }
 
 static u64 mk_cr_64(u64 curr_cr, u32 new_val)
@@ -8664,7 +8655,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	dt.address = dt.size = 0;
 	static_call(kvm_x86_set_idt)(vcpu, &dt);
 
-	__kvm_set_dr(vcpu, 7, DR7_FIXED_1);
+	kvm_set_dr(vcpu, 7, DR7_FIXED_1);
 
 	cs.selector = (vcpu->arch.smbase >> 4) & 0xffff;
 	cs.base = vcpu->arch.smbase;
-- 
2.26.2

