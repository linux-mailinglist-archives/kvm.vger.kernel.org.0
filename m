Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07AC4D5BFB
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 08:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346965AbiCKHEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 02:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346944AbiCKHEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 02:04:20 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F6E517FC;
        Thu, 10 Mar 2022 23:03:16 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id b8so7390220pjb.4;
        Thu, 10 Mar 2022 23:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a8Y+gYOUTBCqlCXiUbWQd9E+I7AV2/ErDR4a02EZ9x4=;
        b=RAUOujRxnp4fokHxf+kEn2j+qZzw85QN8mPsg3L+Ly/DLC1/lyuw3SywOeZPZMiSE6
         L40EGLLQ7iBcGpGeu09DhnGo/NOuFkCM87FoolmeycUaZrsuXTOdx3G26cFwg/C4r5ZE
         wLjnQaFlQ/IjxXZoCerAYM/eLyXamJtqbtICE/tws5ui2Sw5oVKWlh/1G9RNg97PPlNz
         6GsD/5cAFyeXfOtV9ByVmNM1HP3ZCsJLk4AqAEmboTkaJar3iqMxx0guMZH+35Yf7WKD
         OAZV3UH62L0JgZ32yjmJ8dMOvIcWDW6CIncTh+Obf7n1MDZQ6yhRBDSQ0v/4BxvcEgzp
         t6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a8Y+gYOUTBCqlCXiUbWQd9E+I7AV2/ErDR4a02EZ9x4=;
        b=5k+cMEfX2PNr/w7lrq9+xfWp5e9NjLdbsma0m6Qj9wLcIiscEMNNBxgGtbOGFvqDVY
         40m14O6QQW7qozNj+q6YBEzFzyv5B1wKz8Z0JyGI4ZjtZ5h27rVxYcHx1a/i1GOELPVJ
         bOCcye6eXgG3SPhS5s2S72upv4nci5J0zOdyw1UYm4jMNNUbo0QGcuhIriUoCJs4T9df
         e1pGwUTC9nwnnItOmyoxlawAzkLBri4RKiOLWyqePwPHnHgBtMJhqF0ApI6roWwsBKgb
         5WQvC2B339Wk5kGJgZL/qJEt21dmTMwy1rhQ5cjP0V6Xvu8kZOIder2zdYxtlzZZug3V
         yrGg==
X-Gm-Message-State: AOAM530Wc5sNWQBNg80EPEhVz1MMjpjfgW2EHK5htNEoZlrciwfDYK6h
        zdJwsjqJroXnm4HfkxMUiXSLZWuxAD0=
X-Google-Smtp-Source: ABdhPJynhKchGr3xJTI7GLEQbJeSCXLh9mTAmQHoWDpRXOgvWG7Apg5ujNCF+mJu7XT8nIBNto5eYQ==
X-Received: by 2002:a17:902:b906:b0:14f:76a0:ad48 with SMTP id bf6-20020a170902b90600b0014f76a0ad48mr8777198plb.79.1646982195678;
        Thu, 10 Mar 2022 23:03:15 -0800 (PST)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id v24-20020a634818000000b0036407db4728sm7080186pga.26.2022.03.10.23.03.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Mar 2022 23:03:15 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH V2 1/5] KVM: X86: Change the type of access u32 to u64
Date:   Fri, 11 Mar 2022 15:03:41 +0800
Message-Id: <20220311070346.45023-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220311070346.45023-1-jiangshanlai@gmail.com>
References: <20220311070346.45023-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Change the type of access u32 to u64 for FNAME(walk_addr) and
->gva_to_gpa().

The kinds of accesses are usually combinations of UWX, and VMX/SVM's
nested paging adds a new factor of access: is it an access for a guest
page table or for a final guest physical address.

And SMAP relies a factor for supervisor access: explicit or implicit.

So @access in FNAME(walk_addr) and ->gva_to_gpa() is better to include
all these information to do the walk.

Although @access(u32) has enough bits to encode all the kinds, this
patch extends it to u64:
	o Extra bits will be in the higher 32 bits, so that we can
	  easily obtain the traditional access mode (UWX) by converting
	  it to u32.
	o Reuse the value for the access kind defined by SVM's nested
	  paging (PFERR_GUEST_FINAL_MASK and PFERR_GUEST_PAGE_MASK) as
	  @error_code in kvm_handle_page_fault().

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu.h              |  8 +++++---
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  8 ++++----
 arch/x86/kvm/x86.c              | 24 ++++++++++++------------
 5 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c45ab8b5c37f..edffcf7f9c2d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -429,7 +429,7 @@ struct kvm_mmu {
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
 				  struct x86_exception *fault);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			    gpa_t gva_or_gpa, u32 access,
+			    gpa_t gva_or_gpa, u64 access,
 			    struct x86_exception *exception);
 	int (*sync_page)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index bf8dbc4bb12a..74efeaefa8f8 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -214,8 +214,10 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
  */
 static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 				  unsigned pte_access, unsigned pte_pkey,
-				  unsigned pfec)
+				  u64 access)
 {
+	/* strip nested paging fault error codes */
+	unsigned int pfec = access;
 	int cpl = static_call(kvm_x86_get_cpl)(vcpu);
 	unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
 
@@ -317,12 +319,12 @@ static inline void kvm_update_page_stats(struct kvm *kvm, int level, int count)
 	atomic64_add(count, &kvm->stat.pages[level - 1]);
 }
 
-gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
+gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u64 access,
 			   struct x86_exception *exception);
 
 static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
 				      struct kvm_mmu *mmu,
-				      gpa_t gpa, u32 access,
+				      gpa_t gpa, u64 access,
 				      struct x86_exception *exception)
 {
 	if (mmu != &vcpu->arch.nested_mmu)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bd3625a875ef..c12133c3cf00 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3703,7 +3703,7 @@ void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu)
 }
 
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-				  gpa_t vaddr, u32 access,
+				  gpa_t vaddr, u64 access,
 				  struct x86_exception *exception)
 {
 	if (exception)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 252c77805eb9..8621188b46df 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -339,7 +339,7 @@ static inline bool FNAME(is_last_gpte)(struct kvm_mmu *mmu,
  */
 static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 				    struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-				    gpa_t addr, u32 access)
+				    gpa_t addr, u64 access)
 {
 	int ret;
 	pt_element_t pte;
@@ -347,7 +347,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	gfn_t table_gfn;
 	u64 pt_access, pte_access;
 	unsigned index, accessed_dirty, pte_pkey;
-	unsigned nested_access;
+	u64 nested_access;
 	gpa_t pte_gpa;
 	bool have_ad;
 	int offset;
@@ -540,7 +540,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 }
 
 static int FNAME(walk_addr)(struct guest_walker *walker,
-			    struct kvm_vcpu *vcpu, gpa_t addr, u32 access)
+			    struct kvm_vcpu *vcpu, gpa_t addr, u64 access)
 {
 	return FNAME(walk_addr_generic)(walker, vcpu, vcpu->arch.mmu, addr,
 					access);
@@ -988,7 +988,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 
 /* Note, @addr is a GPA when gva_to_gpa() translates an L2 GPA to an L1 GPA. */
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			       gpa_t addr, u32 access,
+			       gpa_t addr, u64 access,
 			       struct x86_exception *exception)
 {
 	struct guest_walker walker;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf17af4d6904..c85e48dc8310 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6705,7 +6705,7 @@ void kvm_get_segment(struct kvm_vcpu *vcpu,
 	static_call(kvm_x86_get_segment)(vcpu, var, seg);
 }
 
-gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
+gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u64 access,
 			   struct x86_exception *exception)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
@@ -6725,7 +6725,7 @@ gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 
-	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u64 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	return mmu->gva_to_gpa(vcpu, mmu, gva, access, exception);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_read);
@@ -6735,7 +6735,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_read);
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 
-	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u64 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	access |= PFERR_FETCH_MASK;
 	return mmu->gva_to_gpa(vcpu, mmu, gva, access, exception);
 }
@@ -6745,7 +6745,7 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 
-	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u64 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	access |= PFERR_WRITE_MASK;
 	return mmu->gva_to_gpa(vcpu, mmu, gva, access, exception);
 }
@@ -6761,7 +6761,7 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 }
 
 static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
-				      struct kvm_vcpu *vcpu, u32 access,
+				      struct kvm_vcpu *vcpu, u64 access,
 				      struct x86_exception *exception)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
@@ -6798,7 +6798,7 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
-	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u64 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	unsigned offset;
 	int ret;
 
@@ -6823,7 +6823,7 @@ int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
 			       gva_t addr, void *val, unsigned int bytes,
 			       struct x86_exception *exception)
 {
-	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u64 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 
 	/*
 	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
@@ -6842,7 +6842,7 @@ static int emulator_read_std(struct x86_emulate_ctxt *ctxt,
 			     struct x86_exception *exception, bool system)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	u32 access = 0;
+	u64 access = 0;
 
 	if (!system && static_call(kvm_x86_get_cpl)(vcpu) == 3)
 		access |= PFERR_USER_MASK;
@@ -6860,7 +6860,7 @@ static int kvm_read_guest_phys_system(struct x86_emulate_ctxt *ctxt,
 }
 
 static int kvm_write_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
-				      struct kvm_vcpu *vcpu, u32 access,
+				      struct kvm_vcpu *vcpu, u64 access,
 				      struct x86_exception *exception)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
@@ -6894,7 +6894,7 @@ static int emulator_write_std(struct x86_emulate_ctxt *ctxt, gva_t addr, void *v
 			      bool system)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	u32 access = PFERR_WRITE_MASK;
+	u64 access = PFERR_WRITE_MASK;
 
 	if (!system && static_call(kvm_x86_get_cpl)(vcpu) == 3)
 		access |= PFERR_USER_MASK;
@@ -6963,7 +6963,7 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 				bool write)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
-	u32 access = ((static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0)
+	u64 access = ((static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0)
 		| (write ? PFERR_WRITE_MASK : 0);
 
 	/*
@@ -12558,7 +12558,7 @@ void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_c
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 	struct x86_exception fault;
-	u32 access = error_code &
+	u64 access = error_code &
 		(PFERR_WRITE_MASK | PFERR_FETCH_MASK | PFERR_USER_MASK);
 
 	if (!(error_code & PFERR_PRESENT_MASK) ||
-- 
2.19.1.6.gb485710b

