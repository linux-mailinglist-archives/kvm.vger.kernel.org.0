Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215FF30622C
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 18:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344028AbhA0RhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 12:37:06 -0500
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:51990 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1343711AbhA0Rgi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 12:36:38 -0500
X-Greylist: delayed 646 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2021 12:36:37 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave04.hostedemail.com (Postfix) with ESMTP id 725DB18006CC7
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 17:26:14 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 88848180A7FE0;
        Wed, 27 Jan 2021 17:25:07 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:1:41:69:355:379:599:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2637:2828:2901:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:3871:3872:3874:4250:4321:4605:5007:6117:6119:6737:7652:7903:9592:10004:10848:11026:11232:11473:11657:11658:11914:12043:12048:12296:12297:12438:12555:12679:12683:12740:12760:12895:12986:13439:14659:21080:21220:21324:21433:21451:21627:21990:30012:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: crib58_3207a3027598
X-Filterd-Recvd-Size: 12177
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Wed, 27 Jan 2021 17:25:05 +0000 (UTC)
Message-ID: <cfb3699fc03cff1e4c4ffe3c552dba7b7727fa09.camel@perches.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add '__func__' in rmap_printk()
From:   Joe Perches <joe@perches.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Stephen Zhang <stephenzhangzsd@gmail.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 27 Jan 2021 09:25:02 -0800
In-Reply-To: <244f1c7f-d6ca-bd7c-da5e-8da3bf8b5aee@redhat.com>
References: <1611713325-3591-1-git-send-email-stephenzhangzsd@gmail.com>
         <244f1c7f-d6ca-bd7c-da5e-8da3bf8b5aee@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-01-27 at 11:54 +0100, Paolo Bonzini wrote:
> On 27/01/21 03:08, Stephen Zhang wrote:
> > Given the common pattern:
> > 
> > rmap_printk("%s:"..., __func__,...)
> > 
> > we could improve this by adding '__func__' in rmap_printk().

Currently, the MMU_DEBUG control is not defined so this isn't used.

Another improvement would be to remove the macro altogether and
rename the uses to the more standard style using pr_debug.

arch/x86/kvm/mmu/mmu_internal.h-#undef MMU_DEBUG
arch/x86/kvm/mmu/mmu_internal.h-
arch/x86/kvm/mmu/mmu_internal.h-#ifdef MMU_DEBUG
arch/x86/kvm/mmu/mmu_internal.h-extern bool dbg;
arch/x86/kvm/mmu/mmu_internal.h-
arch/x86/kvm/mmu/mmu_internal.h-#define pgprintk(x...) do { if (dbg) printk(x); } while (0)
arch/x86/kvm/mmu/mmu_internal.h:#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
arch/x86/kvm/mmu/mmu_internal.h-#define MMU_WARN_ON(x) WARN_ON(x)
arch/x86/kvm/mmu/mmu_internal.h-#else
arch/x86/kvm/mmu/mmu_internal.h-#define pgprintk(x...) do { } while (0)
arch/x86/kvm/mmu/mmu_internal.h:#define rmap_printk(x...) do { } while (0)
arch/x86/kvm/mmu/mmu_internal.h-#define MMU_WARN_ON(x) do { } while (0)
arch/x86/kvm/mmu/mmu_internal.h-#endif
arch/x86/kvm/mmu/mmu_internal.h-

Also this define hasn't been set in quite awhile as there are
format/argument mismatches in the code that use gpa_t that need
to be converted from %lx to %llx with a cast to (u64)

So I think this would be better as:
---
 arch/x86/kvm/mmu/mmu.c          | 47 ++++++++++++++++++-----------------------
 arch/x86/kvm/mmu/mmu_internal.h | 10 +--------
 arch/x86/kvm/mmu/paging_tmpl.h  | 10 ++++-----
 arch/x86/kvm/mmu/spte.c         |  4 ++--
 4 files changed, 28 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..54987bd64647 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -105,11 +105,6 @@ enum {
 	AUDIT_POST_SYNC
 };
 
-#ifdef MMU_DEBUG
-bool dbg = 0;
-module_param(dbg, bool, 0644);
-#endif
-
 #define PTE_PREFETCH_NUM		8
 
 #define PT32_LEVEL_BITS 10
@@ -844,17 +839,17 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 	int i, count = 0;
 
 	if (!rmap_head->val) {
-		rmap_printk("pte_list_add: %p %llx 0->1\n", spte, *spte);
+		pr_debug("%p %llx 0->1\n", spte, *spte);
 		rmap_head->val = (unsigned long)spte;
 	} else if (!(rmap_head->val & 1)) {
-		rmap_printk("pte_list_add: %p %llx 1->many\n", spte, *spte);
+		pr_debug("%p %llx 1->many\n", spte, *spte);
 		desc = mmu_alloc_pte_list_desc(vcpu);
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
 		rmap_head->val = (unsigned long)desc | 1;
 		++count;
 	} else {
-		rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
+		pr_debug("%p %llx many->many\n", spte, *spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
 		while (desc->sptes[PTE_LIST_EXT-1]) {
 			count += PTE_LIST_EXT;
@@ -906,14 +901,14 @@ static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 		pr_err("%s: %p 0->BUG\n", __func__, spte);
 		BUG();
 	} else if (!(rmap_head->val & 1)) {
-		rmap_printk("%s:  %p 1->0\n", __func__, spte);
+		pr_debug("%p 1->0\n", spte);
 		if ((u64 *)rmap_head->val != spte) {
 			pr_err("%s:  %p 1->BUG\n", __func__, spte);
 			BUG();
 		}
 		rmap_head->val = 0;
 	} else {
-		rmap_printk("%s:  %p many->many\n", __func__, spte);
+		pr_debug("%p many->many\n", spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
 		prev_desc = NULL;
 		while (desc) {
@@ -1115,7 +1110,7 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	      !(pt_protect && spte_can_locklessly_be_made_writable(spte)))
 		return false;
 
-	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
+	pr_debug("spte %p %llx\n", sptep, *sptep);
 
 	if (pt_protect)
 		spte &= ~SPTE_MMU_WRITEABLE;
@@ -1142,7 +1137,7 @@ static bool spte_clear_dirty(u64 *sptep)
 {
 	u64 spte = *sptep;
 
-	rmap_printk("rmap_clear_dirty: spte %p %llx\n", sptep, *sptep);
+	pr_debug("spte %p %llx\n", sptep, *sptep);
 
 	MMU_WARN_ON(!spte_ad_enabled(spte));
 	spte &= ~shadow_dirty_mask;
@@ -1184,7 +1179,7 @@ static bool spte_set_dirty(u64 *sptep)
 {
 	u64 spte = *sptep;
 
-	rmap_printk("rmap_set_dirty: spte %p %llx\n", sptep, *sptep);
+	pr_debug("spte %p %llx\n", sptep, *sptep);
 
 	/*
 	 * Similar to the !kvm_x86_ops.slot_disable_log_dirty case,
@@ -1331,7 +1326,7 @@ static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
 	bool flush = false;
 
 	while ((sptep = rmap_get_first(rmap_head, &iter))) {
-		rmap_printk("%s: spte %p %llx.\n", __func__, sptep, *sptep);
+		pr_debug("spte %p %llx.\n", sptep, *sptep);
 
 		pte_list_remove(rmap_head, sptep);
 		flush = true;
@@ -1363,8 +1358,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 restart:
 	for_each_rmap_spte(rmap_head, &iter, sptep) {
-		rmap_printk("kvm_set_pte_rmapp: spte %p %llx gfn %llx (%d)\n",
-			    sptep, *sptep, gfn, level);
+		pr_debug("spte %p %llx gfn %llx (%d)\n",
+			 sptep, *sptep, gfn, level);
 
 		need_flush = 1;
 
@@ -1605,7 +1600,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 	return young;
 }
 
-#ifdef MMU_DEBUG
+#ifdef DEBUG
 static int is_empty_shadow_page(u64 *spt)
 {
 	u64 *pos;
@@ -2490,12 +2485,11 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	LIST_HEAD(invalid_list);
 	int r;
 
-	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
+	pr_debug("looking for gfn %llx\n", gfn);
 	r = 0;
 	spin_lock(&kvm->mmu_lock);
 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
-		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
-			 sp->role.word);
+		pr_debug("gfn %llx role %x\n", gfn, sp->role.word);
 		r = 1;
 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 	}
@@ -2614,7 +2608,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	int ret = RET_PF_FIXED;
 	bool flush = false;
 
-	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
+	pr_debug("spte %llx write_fault %d gfn %llx\n",
 		 *sptep, write_fault, gfn);
 
 	if (is_shadow_present_pte(*sptep)) {
@@ -2630,7 +2624,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			drop_parent_pte(child, sptep);
 			flush = true;
 		} else if (pfn != spte_to_pfn(*sptep)) {
-			pgprintk("hfn old %llx new %llx\n",
+			pr_debug("hfn old %llx new %llx\n",
 				 spte_to_pfn(*sptep), pfn);
 			drop_spte(vcpu->kvm, sptep);
 			flush = true;
@@ -2662,7 +2656,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		return RET_PF_SPURIOUS;
 	}
 
-	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
+	pr_debug("setting spte %llx\n", *sptep);
 	trace_kvm_mmu_set_spte(level, gfn, sptep);
 	if (!was_rmapped && is_large_pte(*sptep))
 		++vcpu->kvm->stat.lpages;
@@ -3747,7 +3741,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
 				u32 error_code, bool prefault)
 {
-	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
+	pr_debug("gva %llx error %x\n", (u64)gpa, error_code);
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
 	return direct_page_fault(vcpu, gpa & PAGE_MASK, error_code, prefault,
@@ -4904,8 +4898,7 @@ static bool detect_write_misaligned(struct kvm_mmu_page *sp, gpa_t gpa,
 {
 	unsigned offset, pte_size, misaligned;
 
-	pgprintk("misaligned: gpa %llx bytes %d role %x\n",
-		 gpa, bytes, sp->role.word);
+	pr_debug("gpa %llx bytes %d role %x\n", gpa, bytes, sp->role.word);
 
 	offset = offset_in_page(gpa);
 	pte_size = sp->role.gpte_is_8_bytes ? 8 : 4;
@@ -4990,7 +4983,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	remote_flush = local_flush = false;
 
-	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
+	pr_debug("gpa %llx bytes %d\n", gpa, bytes);
 
 	/*
 	 * No need to care whether allocation memory is successful
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index bfc6389edc28..095bdef63a03 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -6,17 +6,9 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_host.h>
 
-#undef MMU_DEBUG
-
-#ifdef MMU_DEBUG
-extern bool dbg;
-
-#define pgprintk(x...) do { if (dbg) printk(x); } while (0)
-#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
+#ifdef DEBUG
 #define MMU_WARN_ON(x) WARN_ON(x)
 #else
-#define pgprintk(x...) do { } while (0)
-#define rmap_printk(x...) do { } while (0)
 #define MMU_WARN_ON(x) do { } while (0)
 #endif
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50e268eb8e1a..ecbb4e469c1e 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -462,8 +462,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 			goto retry_walk;
 	}
 
-	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
+	pr_debug("pte %llx pte_access %x pt_access %x\n",
+		 (u64)pte, walker->pte_access, walker->pt_access);
 	return 1;
 
 error:
@@ -536,7 +536,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 		return false;
 
-	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
+	pr_debug("gpte %llx spte %p\n", (u64)gpte, spte);
 
 	gfn = gpte_to_gfn(gpte);
 	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
@@ -794,7 +794,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	bool map_writable, is_self_change_mapping;
 	int max_level;
 
-	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
+	pr_debug("addr %llx err %x\n", (u64)addr, error_code);
 
 	/*
 	 * If PFEC.RSVD is set, this is a shadow page fault.
@@ -811,7 +811,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	 * The page is not mapped by the guest.  Let the guest handle it.
 	 */
 	if (!r) {
-		pgprintk("%s: guest page fault\n", __func__);
+		pr_debug("guest page fault\n");
 		if (!prefault)
 			kvm_inject_emulated_page_fault(vcpu, &walker.fault);
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index c51ad544f25b..23adcb93f6cc 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -146,8 +146,8 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 			goto out;
 
 		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
-			pgprintk("%s: found shadow page for %llx, marking ro\n",
-				 __func__, gfn);
+			pr_debug("found shadow page for %llx, marking ro\n",
+				 gfn);
 			ret |= SET_SPTE_WRITE_PROTECTED_PT;
 			pte_access &= ~ACC_WRITE_MASK;
 			spte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);

