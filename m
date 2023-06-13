Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E559972ECEF
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 22:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbjFMUar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 16:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238613AbjFMUap (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 16:30:45 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB5B199E
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 13:30:43 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-543a25df980so2698714a12.3
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 13:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686688242; x=1689280242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=llQxiqazIrrY9ArKhlO1TXQJ0qyoGq6rPK40xWZQyKE=;
        b=yJsoSKyAWJRDzI9UPTdKJsFctH3IunKpYW1UI3rSvc6H8oUPWlMMAa7vhxqXbMrwXN
         tefqqxfGdZmH/utvcJSHGi2lMsHrS67YcTB3P+J9w7/owKNvcbvchvdVwfRiWRcFDDo3
         GP8RoaLqC8Fi4XsDHJlF43IHZyZpk+bLxroGMj6Na5LbMN0tOAqE3FBel4MTOASWJjim
         Fq5s2vnXG3Luw5VVpgrRoFmZ7yTkKRnqYcB5A762S5M1FGcdknnDUD+Uy7XzD6UirB2t
         J0cYhFmapln4+NlXNd+/qyhjSFwopByw9IFpZ7HcOIXzyRg6k5O2q6zo+PFrW5GFSw7T
         g8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686688242; x=1689280242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=llQxiqazIrrY9ArKhlO1TXQJ0qyoGq6rPK40xWZQyKE=;
        b=eTpnSw1uXKxyma2MBmVDhICJn3APrl8IaeH1/wkXsyunxFq+GMtq01lzvqFilJlkpo
         toxp8Aea4ZBADo89iwZIApFuIhmsP6DUC9x9q6LlUlMd+SNH9i18+CcRt4Zb3ucGolF7
         xo+/kXANCUDgnRy90NWqRuBDJkiuh7guWmRiain+BmqReIirJlsDcywkrtmkKVUV4DQp
         MO1XoKqQAE7PTvR0xdcvPq0CM9GjtibkQFzNTnmqpcOshwMGD3T3xzOfMDvhKYDQNPjV
         l+pEq6szPS63WvuuhSH/nzhTA4XPkV3db+2Yjz0bkgkYbYGMEjvnfwJ811HFnGduqNLN
         1bBw==
X-Gm-Message-State: AC+VfDwD7E/iWKIHv09AP9Meyo4uAtN3kfqZwhkn1Q3EGpzDhQtMz4vy
        uwabDi2bWqKVRK1NSYdPldPFZxsP7as=
X-Google-Smtp-Source: ACHHUZ74J91vNSRPtbLHJE21gAzSl457TXOtBSR9lOsI+WomFLwXYpoEO5OYTHops9G09hVfPesKeSvr1/A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:670e:0:b0:534:81e0:1d7a with SMTP id
 u14-20020a65670e000000b0053481e01d7amr1932621pgf.1.1686688242568; Tue, 13 Jun
 2023 13:30:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jun 2023 13:30:35 -0700
In-Reply-To: <20230613203037.1968489-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230613203037.1968489-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230613203037.1968489-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: x86: Disallow KVM_SET_SREGS{2} if incoming CR0 is invalid
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+5feef0b9ee9c8e9e5689@syzkaller.appspotmail.com,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reject KVM_SET_SREGS{2} with -EINVAL if the incoming CR0 is invalid,
e.g. due to setting bits 63:32, illegal combinations, or to a value that
isn't allowed in VMX (non-)root mode.  The VMX checks in particular are
"fun" as failure to disallow Real Mode for an L2 that is configured with
unrestricted guest disabled, when KVM itself has unrestricted guest
enabled, will result in KVM forcing VM86 mode to virtual Real Mode for
L2, but then fail to unwind the related metadata when synthesizing a
nested VM-Exit back to L1 (which has unrestricted guest enabled).

Opportunistically fix a benign typo in the prototype for is_valid_cr4().

Cc: stable@vger.kernel.org
Reported-by: syzbot+5feef0b9ee9c8e9e5689@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000f316b705fdf6e2b4@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 ++-
 arch/x86/kvm/svm/svm.c             |  6 ++++++
 arch/x86/kvm/vmx/vmx.c             | 28 ++++++++++++++++++------
 arch/x86/kvm/x86.c                 | 34 +++++++++++++++++++-----------
 5 files changed, 52 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 13bc212cd4bc..e3054e3e46d5 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -37,6 +37,7 @@ KVM_X86_OP(get_segment)
 KVM_X86_OP(get_cpl)
 KVM_X86_OP(set_segment)
 KVM_X86_OP(get_cs_db_l_bits)
+KVM_X86_OP(is_valid_cr0)
 KVM_X86_OP(set_cr0)
 KVM_X86_OP_OPTIONAL(post_set_cr3)
 KVM_X86_OP(is_valid_cr4)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 28bd38303d70..3bc146dfd38d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1566,9 +1566,10 @@ struct kvm_x86_ops {
 	void (*set_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
+	bool (*is_valid_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	void (*post_set_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
-	bool (*is_valid_cr4)(struct kvm_vcpu *vcpu, unsigned long cr0);
+	bool (*is_valid_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	int (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e265834fe859..b29d0650582e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1786,6 +1786,11 @@ static void sev_post_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	}
 }
 
+static bool svm_is_valid_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
+{
+	return true;
+}
+
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4815,6 +4820,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_segment = svm_set_segment,
 	.get_cpl = svm_get_cpl,
 	.get_cs_db_l_bits = svm_get_cs_db_l_bits,
+	.is_valid_cr0 = svm_is_valid_cr0,
 	.set_cr0 = svm_set_cr0,
 	.post_set_cr3 = sev_post_set_cr3,
 	.is_valid_cr4 = svm_is_valid_cr4,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ecf4be2c6af..355b0e8c9b00 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3037,6 +3037,15 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
 
+	/*
+	 * KVM should never use VM86 to virtualize Real Mode when L2 is active,
+	 * as using VM86 is unnecessary if unrestricted guest is enabled, and
+	 * if unrestricted guest is disabled, VM-Enter (from L1) with CR0.PG=0
+	 * should VM-Fail and KVM should reject userspace attempts to stuff
+	 * CR0.PG=0 when L2 is active.
+	 */
+	WARN_ON_ONCE(is_guest_mode(vcpu));
+
 	vmx_get_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_TR], VCPU_SREG_TR);
 	vmx_get_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_ES], VCPU_SREG_ES);
 	vmx_get_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_DS], VCPU_SREG_DS);
@@ -3226,6 +3235,17 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 #define CR3_EXITING_BITS (CPU_BASED_CR3_LOAD_EXITING | \
 			  CPU_BASED_CR3_STORE_EXITING)
 
+static bool vmx_is_valid_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
+{
+	if (is_guest_mode(vcpu))
+		return nested_guest_cr0_valid(vcpu, cr0);
+
+	if (to_vmx(vcpu)->nested.vmxon)
+		return nested_host_cr0_valid(vcpu, cr0);
+
+	return true;
+}
+
 void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -5364,18 +5384,11 @@ static int handle_set_cr0(struct kvm_vcpu *vcpu, unsigned long val)
 		val = (val & ~vmcs12->cr0_guest_host_mask) |
 			(vmcs12->guest_cr0 & vmcs12->cr0_guest_host_mask);
 
-		if (!nested_guest_cr0_valid(vcpu, val))
-			return 1;
-
 		if (kvm_set_cr0(vcpu, val))
 			return 1;
 		vmcs_writel(CR0_READ_SHADOW, orig_val);
 		return 0;
 	} else {
-		if (to_vmx(vcpu)->nested.vmxon &&
-		    !nested_host_cr0_valid(vcpu, val))
-			return 1;
-
 		return kvm_set_cr0(vcpu, val);
 	}
 }
@@ -8203,6 +8216,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_segment = vmx_set_segment,
 	.get_cpl = vmx_get_cpl,
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
+	.is_valid_cr0 = vmx_is_valid_cr0,
 	.set_cr0 = vmx_set_cr0,
 	.is_valid_cr4 = vmx_is_valid_cr4,
 	.set_cr4 = vmx_set_cr4,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e7186864542..2703eb734bca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -906,6 +906,22 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 }
 EXPORT_SYMBOL_GPL(load_pdptrs);
 
+static bool kvm_is_valid_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
+{
+#ifdef CONFIG_X86_64
+	if (cr0 & 0xffffffff00000000UL)
+		return false;
+#endif
+
+	if ((cr0 & X86_CR0_NW) && !(cr0 & X86_CR0_CD))
+		return false;
+
+	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
+		return false;
+
+	return static_call(kvm_x86_is_valid_cr0)(vcpu, cr0);
+}
+
 void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
 {
 	/*
@@ -952,21 +968,14 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
 
+	if (!kvm_is_valid_cr0(vcpu, cr0))
+		return 1;
+
 	cr0 |= X86_CR0_ET;
 
-#ifdef CONFIG_X86_64
-	if (cr0 & 0xffffffff00000000UL)
-		return 1;
-#endif
-
+	/* Write to CR0 reserved bits are ignored, even on Intel. */
 	cr0 &= ~CR0_RESERVED_BITS;
 
-	if ((cr0 & X86_CR0_NW) && !(cr0 & X86_CR0_CD))
-		return 1;
-
-	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
-		return 1;
-
 #ifdef CONFIG_X86_64
 	if ((vcpu->arch.efer & EFER_LME) && !is_paging(vcpu) &&
 	    (cr0 & X86_CR0_PG)) {
@@ -11459,7 +11468,8 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 			return false;
 	}
 
-	return kvm_is_valid_cr4(vcpu, sregs->cr4);
+	return kvm_is_valid_cr4(vcpu, sregs->cr4) &&
+	       kvm_is_valid_cr0(vcpu, sregs->cr0);
 }
 
 static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
-- 
2.41.0.162.gfafddb0af9-goog

