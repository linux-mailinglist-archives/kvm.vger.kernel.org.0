Return-Path: <kvm+bounces-70671-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Nw8K9ZrimnnKAAAu9opvQ
	(envelope-from <kvm+bounces-70671-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 00:20:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 29B291155EE
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 00:20:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DF1C4301DC0A
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 23:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6540432ABE1;
	Mon,  9 Feb 2026 23:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="29rPncKT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF3D240611
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 23:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770679243; cv=none; b=MQLz15sZZjb0FdYKDZKxi8hCs2TJdLUGJwvdt1SR0OcC7Ls+F08c4OA9A3o4VyniX9jR7pvMkP58cAlFJ3vt9B7A+ahzBXjiMjNnFULvXGr3XLCsVr4+HED5n2F/XK+1LM/a+RnotaQxxUD/0veTMQbHYHyVlTYKH3V3pboZ2aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770679243; c=relaxed/simple;
	bh=bn/UueIbCkCry1KDTN2ELb3EiaMqnSgE2L04L0oykBg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nMXZKYN+6eIlNpStyoDbmBRRfe9fhqylWNr/FTGyIZU37BJap//9vbGuxaXTX964i3sX04YPmzDRm0UvjJnrFgVg4dQl8BrDCtBJBc64o4P3KXh+uIqVNGUWjE6TKYueyhF0MRJ3ruHt01wSZRFpPtMSSucMOglh4pHMT905zJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=29rPncKT; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a8fc061ce1so125044495ad.0
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 15:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770679240; x=1771284040; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OGdS4aVfp/4Noa5EuN6UtGsxU49auEP4elM492S8F0E=;
        b=29rPncKTE9xtq+8xLCn3UCu/C46X4kL48YrjiihQw66c1uokj/eGetjeX/3L4HBMcF
         dHpESlIFoQbEOAqMuWOf7jzenzBDv2Ai8bD/qzuvRi0CImtcgB73I6WibpZnJhYl5DgU
         NCIj/RjPBi81Lm+zSAD7ox5YqhlZ6JiInhUtEIXWuC7MM4mYnnhyWobSCpyRhajihVvK
         Eiv+jPjB39k2VX32eFVUTCCB6fws/aMK5QdErzzZj7MBfWigKdID48jw7WHyhRsCDB95
         r7fLD8Psu7PqZ/jfl3QxVaUktsZQAvI+O+je6ojXwGZsELRc4V6NeIZ+CjBrBa8CZHeF
         V8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770679240; x=1771284040;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OGdS4aVfp/4Noa5EuN6UtGsxU49auEP4elM492S8F0E=;
        b=MGq201YOQQyi6rCsXrYLFvYb19wXzhpcQzFlCL0ri+XUW2JDyXweXqS8b/Qnibb/iy
         Ruz8oKW6hXLWRsy+vza/qaoHtRwcdMAH4t1ROpHc/4rtmeHbeczBR6RpqwCXzzER0d6o
         bBc2XpAtxO5ZoSpPhy1Pewhd79pDk+ceppIn+o6NF4Sn3t92rrbsb3hvmWLYtbvx94RJ
         Zh8c9JsHGaNA9xa0pZ7FssAORqBJYcpLY9wo11KP6Xr0U0VVay2qeuU+KMhD4iws0G5X
         OT6IjLElbTKLELqjypyK6Y35QQ6ac2QRquDl7HIskj/uY4idzNugMnO1PCSVvk6DIlNR
         2dcw==
X-Forwarded-Encrypted: i=1; AJvYcCVryUwJtGZmAw4RpG3MmCe0Oi2emp1ZndXGHLmEi59TOGTQrdghhMUu2/LKjPM8PSx2pmk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywooz7D3p4IXpl0rwdAQiVYqRdMJiuqgdoJ5zuQoi0JwSNybFxl
	ME1ph8Rxwwl5dsqVGjB3y8O5iFJnOrpJuxOpC/pRjXMLJ60biTMxkrTfG8WA+ZuLuc0Elcgve6c
	0pxhCtA==
X-Received: from plbcp16.prod.google.com ([2002:a17:902:e790:b0:27e:ed03:b5a5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ebc7:b0:2aa:e075:c914
 with SMTP id d9443c01a7336-2ab10575b1emr3409985ad.15.1770679240149; Mon, 09
 Feb 2026 15:20:40 -0800 (PST)
Date: Mon, 9 Feb 2026 15:20:38 -0800
In-Reply-To: <aYmoIaFwgR6+hnGp@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-21-seanjc@google.com>
 <aYW5CbUvZrLogsWF@yzhao56-desk.sh.intel.com> <aYYCOiMvWfSJR1AL@google.com> <aYmoIaFwgR6+hnGp@yzhao56-desk.sh.intel.com>
Message-ID: <aYprxnSHKHUtk7pt@google.com>
Subject: Re: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70671-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 29B291155EE
X-Rspamd-Action: no action

On Mon, Feb 09, 2026, Yan Zhao wrote:
> On Fri, Feb 06, 2026 at 07:01:14AM -0800, Sean Christopherson wrote:
> > @@ -2348,7 +2348,7 @@ void __tdx_pamt_put(u64 pfn)
> >         if (!atomic_dec_and_test(pamt_refcount))
> >                 return;
> >  
> > -       scoped_guard(spinlock, &pamt_lock) {
> > +       scoped_guard(raw_spinlock_irqsave, &pamt_lock) {
> >                 /* Lost race with tdx_pamt_get(). */
> >                 if (atomic_read(pamt_refcount))
> >                         return;
> 
> This option can get rid of the warning.
> 
> However, given the pamt_lock is a global lock, which may be acquired even in the
> softirq context, not sure if this irq disabled version is good.

FWIW, the SEAMCALL itself disables IRQs (and everything else), so it's not _that_
big of a change.  But yeah, waiting on the spinlock with IRQs disabled isn't
exactly idea.

> For your reference, I measured some test data by concurrently launching and
> destroying 4 TDs for 3 rounds:
> 
>                                t0 ---------------------
> scoped_guard(spinlock, &pamt_lock) {       |->T1=t1-t0 |
>                                t1 ----------           |
>  ...                                                   |
>                                t2 ----------           |->T3=t4-t0
>  tdh_phymem_pamt_add/remove()              |->T2=t3-t2 |
>                                t3 ----------           |
>  ...                                                   |
>                                t4 ---------------------
> }
> 
> (1) for __tdx_pamt_get()
> 
>        avg us   min us   max us
> ------|---------------------------
>   T1  |   4       0       69
>   T2  |   4       2       18
>   T3  |  10       3       83
> 
> 
> (2) for__tdx_pamt_put()
> 
>        avg us   min us   max us
> ------|---------------------------
>   T1  |   0        0       5
>   T2  |   2        1      11
>   T3  |   3        2      15
> 
>  
> > Option #2 would be to immediately free the page in tdx_sept_reclaim_private_sp(),
> > so that pages that freed via handle_removed_pt() don't defer freeing the S-EPT
> > page table (which, IIUC, is safe since the TDX-Module forces TLB flushes and exits).
> > 
> > I really, really don't like this option (if it even works).
> I don't like its asymmetry with tdx_sept_link_private_spt().
> 
> However, do you think it would be good to have the PAMT pages of the sept pages
> allocated from (*topup_private_mapping_cache) [1]?

Hrm, dunno about "good", but it's definitely not terrible.  To get the cache
management right, it means adding yet another use of kvm_get_running_vcpu(), which
I really dislike.

On the other hand, if we combine that with TDX freeing in-use S-EPT page tables,
unless I'm overly simplifying things, it would avoid having to extend
kvm_mmu_memory_cache with the page_{get,free}() hook, and would then eliminate
two kvm_x86_ops hooks, because the alloc/free of _unused_ S-EPT page tables is
no different than regular page tables.

As a bonus, we could keep the topup_external_cache() name and just clarify that
the parameter specifies the number of page table pages, i.e. account for the +1
for the mapping page in TDX code.

All in all, I'm kinda leaning in this direction, because as much as I dislike
kvm_get_running_vcpu(), it does minimize the number of kvm_x86_ops hooks.

Something like this?  Also pushed to 

  https://github.com/sean-jc/linux.git x86/tdx_huge_sept_alt

if it doesn't apply.

---
 arch/x86/include/asm/kvm-x86-ops.h |  6 +--
 arch/x86/include/asm/kvm_host.h    | 15 ++------
 arch/x86/kvm/mmu/mmu.c             |  3 --
 arch/x86/kvm/mmu/tdp_mmu.c         | 23 +++++++-----
 arch/x86/kvm/vmx/tdx.c             | 60 ++++++++++++++++++++----------
 5 files changed, 61 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 6083fb07cd3b..4b865617a421 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -94,11 +94,9 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
-KVM_X86_OP_OPTIONAL(alloc_external_sp)
-KVM_X86_OP_OPTIONAL(free_external_sp)
-KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
-KVM_X86_OP_OPTIONAL(reclaim_external_sp)
+KVM_X86_OP_OPTIONAL(reclaim_external_spt)
 KVM_X86_OP_OPTIONAL_RET0(topup_external_cache)
+KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cd3e7dc6ab9b..d3c31eaf18b1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1850,19 +1850,12 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
-	/*
-	 * Callbacks to allocate and free external page tables, a.k.a. S-EPT,
-	 * and to propagate changes in mirror page tables to the external page
-	 * tables.
-	 */
-	unsigned long (*alloc_external_sp)(gfp_t gfp);
-	void (*free_external_sp)(unsigned long addr);
+	void (*reclaim_external_spt)(struct kvm *kvm, gfn_t gfn,
+				     struct kvm_mmu_page *sp);
+	int (*topup_external_cache)(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				    int min_nr_spts);
 	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 				 u64 new_spte, enum pg_level level);
-	void (*reclaim_external_sp)(struct kvm *kvm, gfn_t gfn,
-				    struct kvm_mmu_page *sp);
-	int (*topup_external_cache)(struct kvm *kvm, struct kvm_vcpu *vcpu, int min);
-
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 62bf6bec2df2..f7cf456d9404 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6714,9 +6714,6 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.mmu_shadow_page_cache.init_value)
 		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
-	vcpu->arch.mmu_external_spt_cache.page_get = kvm_x86_ops.alloc_external_sp;
-	vcpu->arch.mmu_external_spt_cache.page_free = kvm_x86_ops.free_external_sp;
-
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index fef856323821..732548a678d8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -53,14 +53,18 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	rcu_barrier();
 }
 
-static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
+static void __tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
-	if (sp->external_spt)
-		kvm_x86_call(free_external_sp)((unsigned long)sp->external_spt);
 	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
+static void tdp_mmu_free_unused_sp(struct kvm_mmu_page *sp)
+{
+	free_page((unsigned long)sp->external_spt);
+	__tdp_mmu_free_sp(sp);
+}
+
 /*
  * This is called through call_rcu in order to free TDP page table memory
  * safely with respect to other kernel threads that may be operating on
@@ -74,7 +78,8 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 	struct kvm_mmu_page *sp = container_of(head, struct kvm_mmu_page,
 					       rcu_head);
 
-	tdp_mmu_free_sp(sp);
+	WARN_ON_ONCE(sp->external_spt);
+	__tdp_mmu_free_sp(sp);
 }
 
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
@@ -458,7 +463,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 	}
 
 	if (is_mirror_sp(sp))
-		kvm_x86_call(reclaim_external_sp)(kvm, base_gfn, sp);
+		kvm_x86_call(reclaim_external_spt)(kvm, base_gfn, sp);
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
@@ -1266,7 +1271,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * failed, e.g. because a different task modified the SPTE.
 		 */
 		if (r) {
-			tdp_mmu_free_sp(sp);
+			tdp_mmu_free_unused_sp(sp);
 			goto retry;
 		}
 
@@ -1461,7 +1466,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		goto err_spt;
 
 	if (is_mirror_sp) {
-		sp->external_spt = (void *)kvm_x86_call(alloc_external_sp)(GFP_KERNEL_ACCOUNT);
+		sp->external_spt = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
 		if (!sp->external_spt)
 			goto err_external_spt;
 
@@ -1472,7 +1477,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	return sp;
 
 err_external_split:
-	kvm_x86_call(free_external_sp)((unsigned long)sp->external_spt);
+	free_page((unsigned long)sp->external_spt);
 err_external_spt:
 	free_page((unsigned long)sp->spt);
 err_spt:
@@ -1594,7 +1599,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	 * installs its own sp in place of the last sp we tried to split.
 	 */
 	if (sp)
-		tdp_mmu_free_sp(sp);
+		tdp_mmu_free_unused_sp(sp);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ae7b9beb3249..b0fc17baa1fc 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1701,7 +1701,7 @@ static struct tdx_pamt_cache *tdx_get_pamt_cache(struct kvm *kvm,
 }
 
 static int tdx_topup_external_pamt_cache(struct kvm *kvm,
-					 struct kvm_vcpu *vcpu, int min)
+					 struct kvm_vcpu *vcpu, int min_nr_spts)
 {
 	struct tdx_pamt_cache *pamt_cache;
 
@@ -1712,7 +1712,11 @@ static int tdx_topup_external_pamt_cache(struct kvm *kvm,
 	if (!pamt_cache)
 		return -EIO;
 
-	return tdx_topup_pamt_cache(pamt_cache, min);
+	/*
+	 * Each S-EPT page tables requires a DPAMT pair, plus one more for the
+	 * memory being mapped into the guest.
+	 */
+	return tdx_topup_pamt_cache(pamt_cache, min_nr_spts + 1);
 }
 
 static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
@@ -1911,23 +1915,41 @@ static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn, u64 new_spte,
 				     enum pg_level level)
 {
+	struct tdx_pamt_cache *pamt_cache;
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 	struct page *external_spt;
+	int r;
 
 	external_spt = tdx_spte_to_external_spt(kvm, gfn, new_spte, level);
 	if (!external_spt)
 		return -EIO;
 
+	pamt_cache = tdx_get_pamt_cache(kvm, kvm_get_running_vcpu());
+	if (!pamt_cache)
+		return -EIO;
+
+	r = tdx_pamt_get(page_to_pfn(external_spt), PG_LEVEL_4K, pamt_cache);
+	if (r)
+		return r;
+
 	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, level, external_spt,
 			       &entry, &level_state);
-	if (unlikely(IS_TDX_OPERAND_BUSY(err)))
-		return -EBUSY;
+	if (unlikely(IS_TDX_OPERAND_BUSY(err))) {
+		r = -EBUSY;
+		goto err;
+	}
 
-	if (TDX_BUG_ON_2(err, TDH_MEM_SEPT_ADD, entry, level_state, kvm))
-		return -EIO;
+	if (TDX_BUG_ON_2(err, TDH_MEM_SEPT_ADD, entry, level_state, kvm)) {
+		r = -EIO;
+		goto err;
+	}
 
 	return 0;
+
+err:
+	tdx_pamt_put(page_to_pfn(external_spt), PG_LEVEL_4K);
+	return r;
 }
 
 static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -1995,8 +2017,8 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 	return tdx_sept_map_leaf_spte(kvm, gfn, new_spte, level);
 }
 
-static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
-					struct kvm_mmu_page *sp)
+static void tdx_sept_reclaim_private_spt(struct kvm *kvm, gfn_t gfn,
+					 struct kvm_mmu_page *sp)
 {
 	/*
 	 * KVM doesn't (yet) zap page table pages in mirror page table while
@@ -2014,7 +2036,16 @@ static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
 	 */
 	if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm) ||
 	    tdx_reclaim_page(virt_to_page(sp->external_spt)))
-		sp->external_spt = NULL;
+		goto out;
+
+	/*
+	 * Immediately free the S-EPT page as the TDX subsystem doesn't support
+	 * freeing pages from RCU callbacks, and more importantly because
+	 * TDH.PHYMEM.PAGE.RECLAIM ensures there are no outstanding readers.
+	 */
+	tdx_free_control_page((unsigned long)sp->external_spt);
+out:
+	sp->external_spt = NULL;
 }
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
@@ -3869,17 +3900,8 @@ void __init tdx_hardware_setup(void)
 	 */
 	vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size, sizeof(struct kvm_tdx));
 
-	/*
-	 * TDX uses the external_spt cache to allocate S-EPT page table pages,
-	 * which (a) don't need to be initialized by KVM as the TDX-Module will
-	 * initialize the page (using the guest's encryption key), and (b) need
-	 * to use a custom allocator to be compatible with Dynamic PAMT.
-	 */
-	vt_x86_ops.alloc_external_sp = tdx_alloc_control_page;
-	vt_x86_ops.free_external_sp = tdx_free_control_page;
-
+	vt_x86_ops.reclaim_external_spt = tdx_sept_reclaim_private_spt;
 	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
-	vt_x86_ops.reclaim_external_sp = tdx_sept_reclaim_private_sp;
 
 	vt_x86_ops.gmem_convert = tdx_gmem_convert;
 

base-commit: 7adb9e428488cf7873a122043385a50dc1eebc8f
-- 


