Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D452445C3D9
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348058AbhKXNoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350776AbhKXNmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:42:47 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E2DC0698C8;
        Wed, 24 Nov 2021 04:21:13 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id y8so1716809plg.1;
        Wed, 24 Nov 2021 04:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=STRdUV4xca8x3wJvu+ZZqiNFhAIwyd24gouZ9h3TcH8=;
        b=UUg8jNBEMM0qjffXSW3kQDX7HIDDJSE99LULYxIeLUuBHqLt4EbPJYCNnpxxvFtHfg
         LwD8czq5vlec8oFae24B7ARrQUkTa+V3Wx3vQGvwLXp5g0W/0Xet+Ox2oQwa5G/KJ4th
         LBmtPPJY3pwVoZfVGAKJ/6ln70ChgBqZUQf12FhsXc8bSm+B3y1yQ6UYsJogaULeI5Zz
         kmdpDgDpxu2uQuM4n/qGa3ohNN+3Z1MkdcexEJ6yoX9kOhVX5PSGV5CgSr/+iGhYFLkg
         8bsGoBYVA/l/jZpWg0sJeScnslR7/acLHQFFjE2VwEpO3VS4Ha0+3FJ9GSF4JGedXU+m
         d3iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=STRdUV4xca8x3wJvu+ZZqiNFhAIwyd24gouZ9h3TcH8=;
        b=FJHzaD7Nnqxl6E7UVDZR7aesiU45qSG5KwhPsvNdEGy3kwArgk4FNO81u3MpzGzg+S
         1WrMKdujdqX3u3DDTqkCWEb7Y6E95ZgjQ/lkdcjFDNIYBTvciK6hP0XYem6r37BuCrGu
         FiDPwtNSezHrDwXxSvHBJ23HgWIRn++FhN+NtPFPsV/phujcbq7KpCqKMTvN1vjjFbzk
         xbcU25Dk0kCOii47rquIs4gDK4yce8pvJ8a0u6RP+gCbDnsUwRjsr3LmnTSt/0EZTBss
         Wvprk1lWufiCPlgRbt2iHks1b0fN3oN4p20gOzZOPoX+RY096pZM+p18NKYHb6VFmGJF
         fusA==
X-Gm-Message-State: AOAM5313cNJmH6ep3vksu+YImjkpYQUqOut2/r298wv9o2v/WzDkBhah
        CpZ/KohFn8T86NgsQVu7MHSKznoENVM=
X-Google-Smtp-Source: ABdhPJyx1ZaWqK2N97gNK+L56Rc48hSYyqU4Oxye8zkBTTFCMMsJ4rV2Ktvj3AQBC8f3oraH8bFlbQ==
X-Received: by 2002:a17:90a:df8d:: with SMTP id p13mr14552851pjv.197.1637756472888;
        Wed, 24 Nov 2021 04:21:12 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id oj11sm5094649pjb.46.2021.11.24.04.21.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 04:21:12 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 02/12] KVM: X86: Add parameter struct kvm_mmu *mmu into mmu->gva_to_gpa()
Date:   Wed, 24 Nov 2021 20:20:44 +0800
Message-Id: <20211124122055.64424-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211124122055.64424-1-jiangshanlai@gmail.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The mmu->gva_to_gpa() has no "struct kvm_mmu *mmu", so an extra
FNAME(gva_to_gpa_nested) is needed.

Add the parameter can simplify the code.  And it makes it explicit that
the walk is upon vcpu->arch.walk_mmu for gva and vcpu->arch.mmu for L2
gpa in translate_nested_gpa() via the new parameter.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h |  5 ++--
 arch/x86/kvm/mmu/mmu.c          | 24 +++++++------------
 arch/x86/kvm/mmu/paging_tmpl.h  | 41 ++++-----------------------------
 arch/x86/kvm/x86.c              | 39 ++++++++++++++++++++-----------
 4 files changed, 41 insertions(+), 68 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index eb6ef0209ee6..8419aff7136f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -426,8 +426,9 @@ struct kvm_mmu {
 	int (*page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
 				  struct x86_exception *fault);
-	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gpa_t gva_or_gpa,
-			    u32 access, struct x86_exception *exception);
+	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			    gpa_t gva_or_gpa, u32 access,
+			    struct x86_exception *exception);
 	gpa_t (*translate_gpa)(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
 			       struct x86_exception *exception);
 	int (*sync_page)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 701c67c55239..3e00a54e23b6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3728,21 +3728,13 @@ void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
 }
 
-static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gpa_t vaddr,
-				  u32 access, struct x86_exception *exception)
+static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+				  gpa_t vaddr, u32 access,
+				  struct x86_exception *exception)
 {
 	if (exception)
 		exception->error_code = 0;
-	return vaddr;
-}
-
-static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gpa_t vaddr,
-					 u32 access,
-					 struct x86_exception *exception)
-{
-	if (exception)
-		exception->error_code = 0;
-	return vcpu->arch.nested_mmu.translate_gpa(vcpu, vaddr, access, exception);
+	return mmu->translate_gpa(vcpu, vaddr, access, exception);
 }
 
 static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
@@ -4982,13 +4974,13 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	 * the gva_to_gpa functions between mmu and nested_mmu are swapped.
 	 */
 	if (!is_paging(vcpu))
-		g_context->gva_to_gpa = nonpaging_gva_to_gpa_nested;
+		g_context->gva_to_gpa = nonpaging_gva_to_gpa;
 	else if (is_long_mode(vcpu))
-		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
+		g_context->gva_to_gpa = paging64_gva_to_gpa;
 	else if (is_pae(vcpu))
-		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
+		g_context->gva_to_gpa = paging64_gva_to_gpa;
 	else
-		g_context->gva_to_gpa = paging32_gva_to_gpa_nested;
+		g_context->gva_to_gpa = paging32_gva_to_gpa;
 
 	reset_guest_paging_metadata(vcpu, g_context);
 }
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f87d36898c44..4e203fe703b0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -547,16 +547,6 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 					access);
 }
 
-#if PTTYPE != PTTYPE_EPT
-static int FNAME(walk_addr_nested)(struct guest_walker *walker,
-				   struct kvm_vcpu *vcpu, gva_t addr,
-				   u32 access)
-{
-	return FNAME(walk_addr_generic)(walker, vcpu, &vcpu->arch.nested_mmu,
-					addr, access);
-}
-#endif
-
 static bool
 FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		     u64 *spte, pt_element_t gpte, bool no_dirty_log)
@@ -999,50 +989,29 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 }
 
 /* Note, @addr is a GPA when gva_to_gpa() translates an L2 GPA to an L1 GPA. */
-static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gpa_t addr, u32 access,
+static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			       gpa_t addr, u32 access,
 			       struct x86_exception *exception)
 {
 	struct guest_walker walker;
 	gpa_t gpa = UNMAPPED_GVA;
 	int r;
 
-	r = FNAME(walk_addr)(&walker, vcpu, addr, access);
-
-	if (r) {
-		gpa = gfn_to_gpa(walker.gfn);
-		gpa |= addr & ~PAGE_MASK;
-	} else if (exception)
-		*exception = walker.fault;
-
-	return gpa;
-}
-
-#if PTTYPE != PTTYPE_EPT
-/* Note, gva_to_gpa_nested() is only used to translate L2 GVAs. */
-static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gpa_t vaddr,
-				      u32 access,
-				      struct x86_exception *exception)
-{
-	struct guest_walker walker;
-	gpa_t gpa = UNMAPPED_GVA;
-	int r;
-
 #ifndef CONFIG_X86_64
 	/* A 64-bit GVA should be impossible on 32-bit KVM. */
-	WARN_ON_ONCE(vaddr >> 32);
+	WARN_ON_ONCE((addr >> 32) && mmu == vcpu->arch.walk_mmu);
 #endif
 
-	r = FNAME(walk_addr_nested)(&walker, vcpu, vaddr, access);
+	r = FNAME(walk_addr_generic)(&walker, vcpu, mmu, addr, access);
 
 	if (r) {
 		gpa = gfn_to_gpa(walker.gfn);
-		gpa |= vaddr & ~PAGE_MASK;
+		gpa |= addr & ~PAGE_MASK;
 	} else if (exception)
 		*exception = walker.fault;
 
 	return gpa;
 }
-#endif
 
 /*
  * Using the cached information from sp->gfns is safe because:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04e8dabc187d..808786677b2b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6460,13 +6460,14 @@ void kvm_get_segment(struct kvm_vcpu *vcpu,
 gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
 			   struct x86_exception *exception)
 {
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gpa_t t_gpa;
 
 	BUG_ON(!mmu_is_nested(vcpu));
 
 	/* NPT walks are always user-walks */
 	access |= PFERR_USER_MASK;
-	t_gpa  = vcpu->arch.mmu->gva_to_gpa(vcpu, gpa, access, exception);
+	t_gpa  = mmu->gva_to_gpa(vcpu, mmu, gpa, access, exception);
 
 	return t_gpa;
 }
@@ -6474,25 +6475,31 @@ gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
 gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 			      struct x86_exception *exception)
 {
+	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
+
 	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
-	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
+	return mmu->gva_to_gpa(vcpu, mmu, gva, access, exception);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_read);
 
  gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception)
 {
+	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
+
 	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	access |= PFERR_FETCH_MASK;
-	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
+	return mmu->gva_to_gpa(vcpu, mmu, gva, access, exception);
 }
 
 gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 			       struct x86_exception *exception)
 {
+	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
+
 	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	access |= PFERR_WRITE_MASK;
-	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
+	return mmu->gva_to_gpa(vcpu, mmu, gva, access, exception);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_write);
 
@@ -6500,19 +6507,21 @@ EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_write);
 gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception)
 {
-	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, 0, exception);
+	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
+
+	return mmu->gva_to_gpa(vcpu, mmu, gva, 0, exception);
 }
 
 static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
 				      struct kvm_vcpu *vcpu, u32 access,
 				      struct x86_exception *exception)
 {
+	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 	void *data = val;
 	int r = X86EMUL_CONTINUE;
 
 	while (bytes) {
-		gpa_t gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, addr, access,
-							    exception);
+		gpa_t gpa = mmu->gva_to_gpa(vcpu, mmu, addr, access, exception);
 		unsigned offset = addr & (PAGE_SIZE-1);
 		unsigned toread = min(bytes, (unsigned)PAGE_SIZE - offset);
 		int ret;
@@ -6540,13 +6549,14 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
 				struct x86_exception *exception)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	unsigned offset;
 	int ret;
 
 	/* Inline kvm_read_guest_virt_helper for speed.  */
-	gpa_t gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, addr, access|PFERR_FETCH_MASK,
-						    exception);
+	gpa_t gpa = mmu->gva_to_gpa(vcpu, mmu, addr, access|PFERR_FETCH_MASK,
+				    exception);
 	if (unlikely(gpa == UNMAPPED_GVA))
 		return X86EMUL_PROPAGATE_FAULT;
 
@@ -6605,13 +6615,12 @@ static int kvm_write_guest_virt_helper(gva_t addr, void *val, unsigned int bytes
 				      struct kvm_vcpu *vcpu, u32 access,
 				      struct x86_exception *exception)
 {
+	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 	void *data = val;
 	int r = X86EMUL_CONTINUE;
 
 	while (bytes) {
-		gpa_t gpa =  vcpu->arch.walk_mmu->gva_to_gpa(vcpu, addr,
-							     access,
-							     exception);
+		gpa_t gpa = mmu->gva_to_gpa(vcpu, mmu, addr, access, exception);
 		unsigned offset = addr & (PAGE_SIZE-1);
 		unsigned towrite = min(bytes, (unsigned)PAGE_SIZE - offset);
 		int ret;
@@ -6698,6 +6707,7 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 				gpa_t *gpa, struct x86_exception *exception,
 				bool write)
 {
+	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 	u32 access = ((static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0)
 		| (write ? PFERR_WRITE_MASK : 0);
 
@@ -6715,7 +6725,7 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 		return 1;
 	}
 
-	*gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
+	*gpa = mmu->gva_to_gpa(vcpu, mmu, gva, access, exception);
 
 	if (*gpa == UNMAPPED_GVA)
 		return -1;
@@ -12268,12 +12278,13 @@ EXPORT_SYMBOL_GPL(kvm_spec_ctrl_test_value);
 
 void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code)
 {
+	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 	struct x86_exception fault;
 	u32 access = error_code &
 		(PFERR_WRITE_MASK | PFERR_FETCH_MASK | PFERR_USER_MASK);
 
 	if (!(error_code & PFERR_PRESENT_MASK) ||
-	    vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, &fault) != UNMAPPED_GVA) {
+	    mmu->gva_to_gpa(vcpu, mmu, gva, access, &fault) != UNMAPPED_GVA) {
 		/*
 		 * If vcpu->arch.walk_mmu->gva_to_gpa succeeded, the page
 		 * tables probably do not match the TLB.  Just proceed
-- 
2.19.1.6.gb485710b

