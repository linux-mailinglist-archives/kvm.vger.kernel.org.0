Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB8B79F89B
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbjINDHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbjINDHG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:07:06 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032D41BDC;
        Wed, 13 Sep 2023 20:07:02 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-570a432468bso1251860a12.0;
        Wed, 13 Sep 2023 20:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694660821; x=1695265621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UOWYxbVCvL9RWkXEOVGyf4zKH+zBEivSmNtr/th0mRw=;
        b=or913W0jJ69Z/tq2PAWT/9cBnUVj3SkWh9qpa1jm++l6COOSHckc/R9acgGXo8nSGI
         q2CFht0vjBOMqSqXNbJkzFpi1+TCYxdcPsakeLR1zVVN9XOwLo5f7OgE4WoYWRT3ieap
         B09QcoTvtn2WyKfCWh3bhpyH9ioZyfhyaBq2CBIbL8HpvJjH1SQYhYHvLNNlZ9MFgRHw
         Nk1hyjw9IhEW9sHQ9J4F/PIlJRTUT92DvWWXNnp5oLFtOKlMOF7EFUwl9BD+2cxQLNoy
         lk6o5PHMy3rVSmxbBk8SoOt206fbVMT4JFD6CRJqR+rghs21y0uS6u+FRa2EHkPqDfQE
         yHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694660821; x=1695265621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UOWYxbVCvL9RWkXEOVGyf4zKH+zBEivSmNtr/th0mRw=;
        b=FDyDvn8RXO5cvqZFY98zM2zWQq8mBjyjMR8zhFk5HYNBhpMnVQLmu5s2qvawTPkgg/
         eE6eNVvsVAefC+ymO2uirlYhOUmmdCwaFY0xb1M8MBQQudc4T03Qo8XyzMCd1ZI5Qkag
         tmADpXL7X63oVg8AFiYZrGFDUw9BWOplTKsKWKOkZ8GPSCrgHU7DsxyXGebBi8fIMQNF
         Hb3kMtssmTG2bVPddwvUbtxS7MNHQeDYCNizEYzbd8V8mNq8NBTqjMzO4YvIzxOXuLQ5
         9UPVxGPluRbvV955i7ufKbSR4+xKsCU5BeQh3n+WcqW491kRNH7tjtMFICX8huHfI4ZQ
         O1OQ==
X-Gm-Message-State: AOJu0YzG5kG9nh3ZL36twQ+9ENKfyFJh2/dsYIR5I4LFETy5c1dnsScg
        bf56gd/PWL19H1LcR2IBKc8=
X-Google-Smtp-Source: AGHT+IHUqvUiinRDYXoT71HhT52EiRo+uIIM6JtFoZOcoAkwJL6VLF1wmMUBMmrH3C7KBeBsQGAMNw==
X-Received: by 2002:a17:90a:bc46:b0:273:e1c9:89 with SMTP id t6-20020a17090abc4600b00273e1c90089mr891982pjv.20.1694660821428;
        Wed, 13 Sep 2023 20:07:01 -0700 (PDT)
Received: from pwon.ozlabs.ibm.com ([146.112.118.69])
        by smtp.gmail.com with ESMTPSA id w2-20020a170902904200b001b567bbe82dsm330521plz.150.2023.09.13.20.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 20:07:00 -0700 (PDT)
From:   Jordan Niethe <jniethe5@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM, mpe@ellerman.id.au, sachinp@linux.ibm.com,
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH v5 09/11] KVM: PPC: Book3s HV: Hold LPIDs in an unsigned long
Date:   Thu, 14 Sep 2023 13:05:58 +1000
Message-Id: <20230914030600.16993-10-jniethe5@gmail.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230914030600.16993-1-jniethe5@gmail.com>
References: <20230914030600.16993-1-jniethe5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LPID register is 32 bits long. The host keeps the lpids for each
guest in an unsigned word struct kvm_arch. Currently, LPIDs are already
limited by mmu_lpid_bits and KVM_MAX_NESTED_GUESTS_SHIFT.

The nestedv2 API returns a 64 bit "Guest ID" to be used be the L1 host
for each L2 guest. This value is used as an lpid, e.g. it is the
parameter used by H_RPT_INVALIDATE. To minimize needless special casing
it makes sense to keep this "Guest ID" in struct kvm_arch::lpid.

This means that struct kvm_arch::lpid is too small so prepare for this
and make it an unsigned long. This is not a problem for the KVM-HV and
nestedv1 cases as their lpid values are already limited to valid ranges
so in those contexts the lpid can be used as an unsigned word safely as
needed.

In the PAPR, the H_RPT_INVALIDATE pid/lpid parameter is already
specified as an unsigned long so change pseries_rpt_invalidate() to
match that.  Update the callers of pseries_rpt_invalidate() to also take
an unsigned long if they take an lpid value.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
v3:
  - New to series
v4:
  - Use u64
  - Change format strings instead of casting
---
 arch/powerpc/include/asm/kvm_book3s.h     | 10 +++++-----
 arch/powerpc/include/asm/kvm_book3s_64.h  |  2 +-
 arch/powerpc/include/asm/kvm_host.h       |  2 +-
 arch/powerpc/include/asm/plpar_wrappers.h |  4 ++--
 arch/powerpc/kvm/book3s_64_mmu_hv.c       |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c    | 22 +++++++++++-----------
 arch/powerpc/kvm/book3s_hv_nested.c       |  4 ++--
 arch/powerpc/kvm/book3s_hv_uvmem.c        |  2 +-
 arch/powerpc/kvm/book3s_xive.c            |  4 ++--
 9 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 4c6558d5fefe..831c23e4f121 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -191,14 +191,14 @@ extern int kvmppc_mmu_radix_translate_table(struct kvm_vcpu *vcpu, gva_t eaddr,
 extern int kvmppc_mmu_radix_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 			struct kvmppc_pte *gpte, bool data, bool iswrite);
 extern void kvmppc_radix_tlbie_page(struct kvm *kvm, unsigned long addr,
-				    unsigned int pshift, unsigned int lpid);
+				    unsigned int pshift, u64 lpid);
 extern void kvmppc_unmap_pte(struct kvm *kvm, pte_t *pte, unsigned long gpa,
 			unsigned int shift,
 			const struct kvm_memory_slot *memslot,
-			unsigned int lpid);
+			u64 lpid);
 extern bool kvmppc_hv_handle_set_rc(struct kvm *kvm, bool nested,
 				    bool writing, unsigned long gpa,
-				    unsigned int lpid);
+				    u64 lpid);
 extern int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 				unsigned long gpa,
 				struct kvm_memory_slot *memslot,
@@ -207,7 +207,7 @@ extern int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 extern int kvmppc_init_vm_radix(struct kvm *kvm);
 extern void kvmppc_free_radix(struct kvm *kvm);
 extern void kvmppc_free_pgtable_radix(struct kvm *kvm, pgd_t *pgd,
-				      unsigned int lpid);
+				      u64 lpid);
 extern int kvmppc_radix_init(void);
 extern void kvmppc_radix_exit(void);
 extern void kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
@@ -300,7 +300,7 @@ void kvmhv_nested_exit(void);
 void kvmhv_vm_nested_init(struct kvm *kvm);
 long kvmhv_set_partition_table(struct kvm_vcpu *vcpu);
 long kvmhv_copy_tofrom_guest_nested(struct kvm_vcpu *vcpu);
-void kvmhv_set_ptbl_entry(unsigned int lpid, u64 dw0, u64 dw1);
+void kvmhv_set_ptbl_entry(u64 lpid, u64 dw0, u64 dw1);
 void kvmhv_release_all_nested(struct kvm *kvm);
 long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu);
 long kvmhv_do_nested_tlbie(struct kvm_vcpu *vcpu);
diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index d49065af08e9..572f9bbf1a25 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -624,7 +624,7 @@ static inline void copy_to_checkpoint(struct kvm_vcpu *vcpu)
 
 extern int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgtable, pte_t pte,
 			     unsigned long gpa, unsigned int level,
-			     unsigned long mmu_seq, unsigned int lpid,
+			     unsigned long mmu_seq, u64 lpid,
 			     unsigned long *rmapp, struct rmap_nested **n_rmap);
 extern void kvmhv_insert_nest_rmap(struct kvm *kvm, unsigned long *rmapp,
 				   struct rmap_nested **n_rmap);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 14ee0dece853..429b53bc1773 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -276,7 +276,7 @@ struct kvm_resize_hpt;
 #define KVMPPC_SECURE_INIT_ABORT 0x4 /* H_SVM_INIT_ABORT issued */
 
 struct kvm_arch {
-	unsigned int lpid;
+	u64 lpid;
 	unsigned int smt_mode;		/* # vcpus per virtual core */
 	unsigned int emul_smt_mode;	/* emualted SMT mode, on P9 */
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
diff --git a/arch/powerpc/include/asm/plpar_wrappers.h b/arch/powerpc/include/asm/plpar_wrappers.h
index fe3d0ea0058a..8d26f2537586 100644
--- a/arch/powerpc/include/asm/plpar_wrappers.h
+++ b/arch/powerpc/include/asm/plpar_wrappers.h
@@ -355,7 +355,7 @@ static inline long plpar_get_cpu_characteristics(struct h_cpu_char_result *p)
  * error recovery of killing the process/guest will be eventually
  * needed.
  */
-static inline long pseries_rpt_invalidate(u32 pid, u64 target, u64 type,
+static inline long pseries_rpt_invalidate(u64 pid, u64 target, u64 type,
 					  u64 page_sizes, u64 start, u64 end)
 {
 	long rc;
@@ -401,7 +401,7 @@ static inline long plpar_pte_read_4(unsigned long flags, unsigned long ptex,
 	return 0;
 }
 
-static inline long pseries_rpt_invalidate(u32 pid, u64 target, u64 type,
+static inline long pseries_rpt_invalidate(u64 pid, u64 target, u64 type,
 					  u64 page_sizes, u64 start, u64 end)
 {
 	return 0;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index fdfc2a62dd67..2b1f0cdd8c18 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -121,7 +121,7 @@ void kvmppc_set_hpt(struct kvm *kvm, struct kvm_hpt_info *info)
 	kvm->arch.hpt = *info;
 	kvm->arch.sdr1 = __pa(info->virt) | (info->order - 18);
 
-	pr_debug("KVM guest htab at %lx (order %ld), LPID %x\n",
+	pr_debug("KVM guest htab at %lx (order %ld), LPID %llx\n",
 		 info->virt, (long)info->order, kvm->arch.lpid);
 }
 
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index ab646f59afd7..175a8eb2681f 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -308,7 +308,7 @@ int kvmppc_mmu_radix_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 }
 
 void kvmppc_radix_tlbie_page(struct kvm *kvm, unsigned long addr,
-			     unsigned int pshift, unsigned int lpid)
+			     unsigned int pshift, u64 lpid)
 {
 	unsigned long psize = PAGE_SIZE;
 	int psi;
@@ -345,7 +345,7 @@ void kvmppc_radix_tlbie_page(struct kvm *kvm, unsigned long addr,
 		pr_err("KVM: TLB page invalidation hcall failed, rc=%ld\n", rc);
 }
 
-static void kvmppc_radix_flush_pwc(struct kvm *kvm, unsigned int lpid)
+static void kvmppc_radix_flush_pwc(struct kvm *kvm, u64 lpid)
 {
 	long rc;
 
@@ -418,7 +418,7 @@ static void kvmppc_pmd_free(pmd_t *pmdp)
 void kvmppc_unmap_pte(struct kvm *kvm, pte_t *pte, unsigned long gpa,
 		      unsigned int shift,
 		      const struct kvm_memory_slot *memslot,
-		      unsigned int lpid)
+		      u64 lpid)
 
 {
 	unsigned long old;
@@ -469,7 +469,7 @@ void kvmppc_unmap_pte(struct kvm *kvm, pte_t *pte, unsigned long gpa,
  * (or 4kB) mappings (of sub-pages of the same 2MB page).
  */
 static void kvmppc_unmap_free_pte(struct kvm *kvm, pte_t *pte, bool full,
-				  unsigned int lpid)
+				  u64 lpid)
 {
 	if (full) {
 		memset(pte, 0, sizeof(long) << RADIX_PTE_INDEX_SIZE);
@@ -490,7 +490,7 @@ static void kvmppc_unmap_free_pte(struct kvm *kvm, pte_t *pte, bool full,
 }
 
 static void kvmppc_unmap_free_pmd(struct kvm *kvm, pmd_t *pmd, bool full,
-				  unsigned int lpid)
+				  u64 lpid)
 {
 	unsigned long im;
 	pmd_t *p = pmd;
@@ -519,7 +519,7 @@ static void kvmppc_unmap_free_pmd(struct kvm *kvm, pmd_t *pmd, bool full,
 }
 
 static void kvmppc_unmap_free_pud(struct kvm *kvm, pud_t *pud,
-				  unsigned int lpid)
+				  u64 lpid)
 {
 	unsigned long iu;
 	pud_t *p = pud;
@@ -540,7 +540,7 @@ static void kvmppc_unmap_free_pud(struct kvm *kvm, pud_t *pud,
 	pud_free(kvm->mm, pud);
 }
 
-void kvmppc_free_pgtable_radix(struct kvm *kvm, pgd_t *pgd, unsigned int lpid)
+void kvmppc_free_pgtable_radix(struct kvm *kvm, pgd_t *pgd, u64 lpid)
 {
 	unsigned long ig;
 
@@ -567,7 +567,7 @@ void kvmppc_free_radix(struct kvm *kvm)
 }
 
 static void kvmppc_unmap_free_pmd_entry_table(struct kvm *kvm, pmd_t *pmd,
-					unsigned long gpa, unsigned int lpid)
+					unsigned long gpa, u64 lpid)
 {
 	pte_t *pte = pte_offset_kernel(pmd, 0);
 
@@ -583,7 +583,7 @@ static void kvmppc_unmap_free_pmd_entry_table(struct kvm *kvm, pmd_t *pmd,
 }
 
 static void kvmppc_unmap_free_pud_entry_table(struct kvm *kvm, pud_t *pud,
-					unsigned long gpa, unsigned int lpid)
+					unsigned long gpa, u64 lpid)
 {
 	pmd_t *pmd = pmd_offset(pud, 0);
 
@@ -609,7 +609,7 @@ static void kvmppc_unmap_free_pud_entry_table(struct kvm *kvm, pud_t *pud,
 
 int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgtable, pte_t pte,
 		      unsigned long gpa, unsigned int level,
-		      unsigned long mmu_seq, unsigned int lpid,
+		      unsigned long mmu_seq, u64 lpid,
 		      unsigned long *rmapp, struct rmap_nested **n_rmap)
 {
 	pgd_t *pgd;
@@ -786,7 +786,7 @@ int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgtable, pte_t pte,
 }
 
 bool kvmppc_hv_handle_set_rc(struct kvm *kvm, bool nested, bool writing,
-			     unsigned long gpa, unsigned int lpid)
+			     unsigned long gpa, u64 lpid)
 {
 	unsigned long pgflags;
 	unsigned int shift;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 377d0b4a05ee..9b63fae27eba 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -478,7 +478,7 @@ void kvmhv_nested_exit(void)
 	}
 }
 
-static void kvmhv_flush_lpid(unsigned int lpid)
+static void kvmhv_flush_lpid(u64 lpid)
 {
 	long rc;
 
@@ -500,7 +500,7 @@ static void kvmhv_flush_lpid(unsigned int lpid)
 		pr_err("KVM: TLB LPID invalidation hcall failed, rc=%ld\n", rc);
 }
 
-void kvmhv_set_ptbl_entry(unsigned int lpid, u64 dw0, u64 dw1)
+void kvmhv_set_ptbl_entry(u64 lpid, u64 dw0, u64 dw1)
 {
 	if (!kvmhv_on_pseries()) {
 		mmu_partition_table_set_entry(lpid, dw0, dw1, true);
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 709ebd578394..8aaef790a723 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -857,7 +857,7 @@ unsigned long kvmppc_h_svm_init_done(struct kvm *kvm)
 	}
 
 	kvm->arch.secure_guest |= KVMPPC_SECURE_INIT_DONE;
-	pr_info("LPID %d went secure\n", kvm->arch.lpid);
+	pr_info("LPID %lld went secure\n", kvm->arch.lpid);
 
 out:
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 24d8378824a2..29a382249770 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -884,10 +884,10 @@ int kvmppc_xive_attach_escalation(struct kvm_vcpu *vcpu, u8 prio,
 	}
 
 	if (single_escalation)
-		name = kasprintf(GFP_KERNEL, "kvm-%d-%d",
+		name = kasprintf(GFP_KERNEL, "kvm-%lld-%d",
 				 vcpu->kvm->arch.lpid, xc->server_num);
 	else
-		name = kasprintf(GFP_KERNEL, "kvm-%d-%d-%d",
+		name = kasprintf(GFP_KERNEL, "kvm-%lld-%d-%d",
 				 vcpu->kvm->arch.lpid, xc->server_num, prio);
 	if (!name) {
 		pr_err("Failed to allocate escalation irq name for queue %d of VCPU %d\n",
-- 
2.39.3

