Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C2977047C
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 17:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjHDP0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 11:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjHDP0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 11:26:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD724C2F
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 08:25:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d20d99c03fbso2434726276.3
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 08:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691162727; x=1691767527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aR8D0fIoPoIFpwFxu77XAzwqicqZyfbYQ6tlR8sCTLM=;
        b=VB2vjCRjKu/M8EILnB2LknxCC3MRsvscHBiYxjGCZfU4CXGZs/aun9ZkDGLItrffno
         u/4xyaKIFT4iOE7WkNhsj+pHWZxCL0eTiWVNzV5IY2reU54oSXMtoDoI0Vpw8kv81s2H
         +vVmcdMXl2uMTLm/JPrNiX0NFBebcCVcssywEYeaOzEbpNa8u6T865k2ya4BnuOKTZ4g
         DcsovjcVAHPveM5Y7YitDoe97lPI8Yns/imCGOwmke5hxTTJBhtxyqfh42faTsci7IUS
         2YSVmxC22m3O9UBfoDDFllJBv6ik9KUtqryWjNFIKgXVMAL0RGdjuuvDoUD3BcT8cd8S
         N6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691162727; x=1691767527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aR8D0fIoPoIFpwFxu77XAzwqicqZyfbYQ6tlR8sCTLM=;
        b=dks6NDZsJHXhODFZ4YacFi4FHwYVHuKzHnA9N0UTZMSlmgMuUyzTBPa2WuIe3kG2cH
         ceoeQsGB+NXYUibgNcZZFAsjDauJq1+33YHgJ6pL3EgxtGMIscMIe5Fc7Y3n0dnQKWU+
         ynK+kLkndg7Eln4hbpxHMksR1pn9I8hDZwaF/YuXFW4CKpCHRAXfXL/+Z0iNfD3TValu
         /jYh8MTklGv8hUeBCMLz+N0mDdzYLcZkuthmEVZ01RbDFX6a9mZ3yNcIwaf4yUZ6bcXC
         rKccGbdoUExBnPVslXd/leQZCnsH2AlZfUQDrpFWgC905JLCy/6mPYeAyJoJCjH93L+F
         QQ0A==
X-Gm-Message-State: AOJu0Yzcrw1pQmQHXfGecJxo6u6RtITLkxjZ2utjQ51AK+ZTW1BElx4Y
        nL3VmFu74e2Gszx4cDPIWfGyuZ8ZyxA=
X-Google-Smtp-Source: AGHT+IHMWx3eXWNT0qtNfcgrK32d5hjxX5BhTOsw+KHqG5MOlcfDPMAyJUDgBk8XW3w0YDuBgzS0clYh098=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a2c6:0:b0:d0b:d8cd:e661 with SMTP id
 c6-20020a25a2c6000000b00d0bd8cde661mr8642ybn.12.1691162727571; Fri, 04 Aug
 2023 08:25:27 -0700 (PDT)
Date:   Fri, 4 Aug 2023 08:25:26 -0700
In-Reply-To: <ZMyueOBXMwPkVk6J@chao-email>
Mime-Version: 1.0
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-13-weijiang.yang@intel.com> <ZMyueOBXMwPkVk6J@chao-email>
Message-ID: <ZM0YZgFsYWuBFOze@google.com>
Subject: Re: [PATCH v5 12/19] KVM:x86: Save and reload SSP to/from SMRAM
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        peterz@infradead.org, john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
        binbin.wu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023, Chao Gao wrote:
> On Thu, Aug 03, 2023 at 12:27:25AM -0400, Yang Weijiang wrote:
> >Save CET SSP to SMRAM on SMI and reload it on RSM.
> >KVM emulates architectural behavior when guest enters/leaves SMM
> >mode, i.e., save registers to SMRAM at the entry of SMM and reload
> >them at the exit of SMM. Per SDM, SSP is defined as one of
> >the fields in SMRAM for 64-bit mode, so handle the state accordingly.
> >
> >Check is_smm() to determine whether kvm_cet_is_msr_accessible()
> >is called in SMM mode so that kvm_{set,get}_msr() works in SMM mode.
> >
> >Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> >---
> > arch/x86/kvm/smm.c | 11 +++++++++++
> > arch/x86/kvm/smm.h |  2 +-
> > arch/x86/kvm/x86.c | 11 ++++++++++-
> > 3 files changed, 22 insertions(+), 2 deletions(-)
> >
> >diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> >index b42111a24cc2..e0b62d211306 100644
> >--- a/arch/x86/kvm/smm.c
> >+++ b/arch/x86/kvm/smm.c
> >@@ -309,6 +309,12 @@ void enter_smm(struct kvm_vcpu *vcpu)
> > 
> > 	kvm_smm_changed(vcpu, true);
> > 
> >+#ifdef CONFIG_X86_64
> >+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
> >+	    kvm_get_msr(vcpu, MSR_KVM_GUEST_SSP, &smram.smram64.ssp))
> >+		goto error;
> >+#endif
> 
> SSP save/load should go to enter_smm_save_state_64() and rsm_load_state_64(),
> where other fields of SMRAM are handled.

+1.  The right way to get/set MSRs like this is to use __kvm_get_msr() and pass
%true for @host_initiated.  Though I would add a prep patch to provide wrappers
for __kvm_get_msr() and __kvm_set_msr().  Naming will be hard, but I think we
can use kvm_{read,write}_msr() to go along with the KVM-initiated register
accessors/mutators, e.g. kvm_register_read(), kvm_pdptr_write(), etc.

Then you don't need to wait until after kvm_smm_changed(), and kvm_cet_is_msr_accessible()
doesn't need the confusing (and broken) SMM waiver, e.g. as Chao points out below,
that would allow the guest to access the synthetic MSR.

Delta patch at the bottom (would need to be split up, rebased, etc.).

> > 	if (kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, &smram, sizeof(smram)))
> > 		goto error;
> > 
> >@@ -586,6 +592,11 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
> > 	if ((vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK) == 0)
> > 		static_call(kvm_x86_set_nmi_mask)(vcpu, false);
> > 
> >+#ifdef CONFIG_X86_64
> >+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
> >+	    kvm_set_msr(vcpu, MSR_KVM_GUEST_SSP, smram.smram64.ssp))
> >+		return X86EMUL_UNHANDLEABLE;
> >+#endif
> > 	kvm_smm_changed(vcpu, false);
> > 
> > 	/*
> >diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
> >index a1cf2ac5bd78..1e2a3e18207f 100644
> >--- a/arch/x86/kvm/smm.h
> >+++ b/arch/x86/kvm/smm.h
> >@@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
> > 	u32 smbase;
> > 	u32 reserved4[5];
> > 
> >-	/* ssp and svm_* fields below are not implemented by KVM */
> > 	u64 ssp;
> >+	/* svm_* fields below are not implemented by KVM */
> > 	u64 svm_guest_pat;
> > 	u64 svm_host_efer;
> > 	u64 svm_host_cr4;
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index 98f3ff6078e6..56aa5a3d3913 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -3644,8 +3644,17 @@ static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
> > 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> > 			return false;
> > 
> >-		if (msr->index == MSR_KVM_GUEST_SSP)
> >+		/*
> >+		 * This MSR is synthesized mainly for userspace access during
> >+		 * Live Migration, it also can be accessed in SMM mode by VMM.
> >+		 * Guest is not allowed to access this MSR.
> >+		 */
> >+		if (msr->index == MSR_KVM_GUEST_SSP) {
> >+			if (IS_ENABLED(CONFIG_X86_64) && is_smm(vcpu))
> >+				return true;
> 
> On second thoughts, this is incorrect. We don't want guest in SMM
> mode to read/write SSP via the synthesized MSR. Right?

It's not a guest read though, KVM is doing the read while emulating SMI/RSM.

> You can
> 1. move set/get guest SSP into two helper functions, e.g., kvm_set/get_ssp()
> 2. call kvm_set/get_ssp() for host-initiated MSR accesses and SMM transitions.

We could, but that would largely defeat the purpose of kvm_x86_ops.{g,s}et_msr(),
i.e. we already have hooks to get at MSR values that are buried in the VMCS/VMCB,
the interface is just a bit kludgy.
 
> 3. refuse guest accesses to the synthesized MSR.

---
 arch/x86/include/asm/kvm_host.h |  8 +++++++-
 arch/x86/kvm/cpuid.c            |  2 +-
 arch/x86/kvm/smm.c              | 10 ++++------
 arch/x86/kvm/x86.c              | 17 +++++++++++++----
 4 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f883696723f4..fe8484bc8082 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1939,7 +1939,13 @@ void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
-int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiated);
+
+/*
+ * kvm_msr_{read,write}() are KVM-internal helpers, i.e. for when KVM needs to
+ * get/set an MSR value when emulating CPU behavior.
+ */
+int kvm_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
+int kvm_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 *data);
 int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
 int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1a601be7b4fa..b595645b2af7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1515,7 +1515,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 		*edx = entry->edx;
 		if (function == 7 && index == 0) {
 			u64 data;
-		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
+		        if (!kvm_msr_read(vcpu, MSR_IA32_TSX_CTRL, &data) &&
 			    (data & TSX_CTRL_CPUID_CLEAR))
 				*ebx &= ~(F(RTM) | F(HLE));
 		} else if (function == 0x80000007) {
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index e0b62d211306..8db12831877e 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -275,6 +275,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
 	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
 
 	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
+
+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)
+		KVM_BUG_ON(kvm_msr_read(vcpu, MSR_KVM_GUEST_SSP,
+					&smram.smram64.ssp), vcpu->kvm));
 }
 #endif
 
@@ -309,12 +313,6 @@ void enter_smm(struct kvm_vcpu *vcpu)
 
 	kvm_smm_changed(vcpu, true);
 
-#ifdef CONFIG_X86_64
-	if (guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
-	    kvm_get_msr(vcpu, MSR_KVM_GUEST_SSP, &smram.smram64.ssp))
-		goto error;
-#endif
-
 	if (kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, &smram, sizeof(smram)))
 		goto error;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e200a5d00e9..872767b7bf51 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1924,8 +1924,8 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
-		  bool host_initiated)
+static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
+			 bool host_initiated)
 {
 	struct msr_data msr;
 	int ret;
@@ -1951,6 +1951,16 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	return ret;
 }
 
+int kvm_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+{
+	return __kvm_get_msr(vcpu, index, data, true);
+}
+
+int kvm_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+{
+	return __kvm_get_msr(vcpu, index, data, true);
+}
+
 static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 				     u32 index, u64 *data, bool host_initiated)
 {
@@ -4433,8 +4443,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
 		    msr == MSR_IA32_PL2_SSP) {
-			msr_info->data =
-				vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP];
+			msr_info->data = vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP];
 		} else if (msr == MSR_IA32_U_CET || msr == MSR_IA32_PL3_SSP) {
 			kvm_get_xsave_msr(msr_info);
 		}

base-commit: 82e95ab0094bf1b823a6f9c9a07238852b375a22
-- 

