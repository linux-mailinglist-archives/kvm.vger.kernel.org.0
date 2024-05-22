Return-Path: <kvm+bounces-17990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C2668CC919
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 00:34:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F19631F2164E
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 22:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92ACE14901C;
	Wed, 22 May 2024 22:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PuNpDrF+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76E4146A8F;
	Wed, 22 May 2024 22:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417256; cv=none; b=b2RrbxIr8PGOO7CVxvyKF9eMyqsON6IbYM6+9qYzbrmXItSkGjEBLX61H/8N6v0S+iS+Map+H3aDY1a/UFDISJxFUuE0sJMAxtU9zbQEg5nainRnrhq26GAJ7cBcR5a2kRXEudvtkEsscZxSnvQZoujU1Td1e3bINgnRDVmFdxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417256; c=relaxed/simple;
	bh=aiUWF0W+fkcFoGuBXNtJhg831bCWpYqqQKyyKx9t/7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e6PhFtcw6odv7biSxkOQSYWwu/l0EpvKdxU6UNoRtVj7uoNgS63ewONdZHR++NqfnYCLsD0iURDPlKTZm6ZJDvh50uDBYDBPwT/EytX8652R3sKEND/drRnucb0pzIMap5nNEbBuhS1p4mv8LZMi+lHMZ7J2kPOYXCatOI9ov2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PuNpDrF+; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716417255; x=1747953255;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=aiUWF0W+fkcFoGuBXNtJhg831bCWpYqqQKyyKx9t/7g=;
  b=PuNpDrF+AMQIdZe8Uchdzzo1UGG+PBQNQnqWcKOPr05WkFLKy4JfTRMw
   5xd976sZ3Z85vBuw1Gl/0utKv03+sHu0Dnyri/RA8WoOLNKUi2DrwkNvk
   VGh7HpvnrFxajKPGIXHAbaPty2bE4d3aBQwhtJv3JU2GNU9v5ZianFrxU
   HcBiuCCMZQdYl196WsVJiTzBUzMHJ6TKWtYy1pcX+q/ZeYFnPej4dqUE/
   n4g8BLjvKbDQQH4eFGFCeHFfvGqf4M6pQZFXgo6Laj/HaH+sLUcVIWsEz
   X9C+v4ESYMz+rZnTfbB7HtZ8KVJLoPX0gqTUfchl5n7V+Gbe3a70Irttp
   g==;
X-CSE-ConnectionGUID: afy44yKZS0+JJGlPwcWuNQ==
X-CSE-MsgGUID: 5Kd3evFPQGGaosAFBBgR3g==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="11654035"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="11654035"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 15:34:14 -0700
X-CSE-ConnectionGUID: FD5UQafBRx6JgOpdsCtOvw==
X-CSE-MsgGUID: UccWhruTQW61a893GY4rgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33551735"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 15:34:14 -0700
Date: Wed, 22 May 2024 15:34:13 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240522223413.GC212599@ls.amr.corp.intel.com>
References: <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
 <20240516194209.GL168153@ls.amr.corp.intel.com>
 <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
 <20240517090348.GN168153@ls.amr.corp.intel.com>
 <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
 <20240517191630.GC412700@ls.amr.corp.intel.com>
 <20240520233227.GA29916@ls.amr.corp.intel.com>
 <a071748328e5c0a85d91ea89bb57c4d23cd79025.camel@intel.com>
 <20240521161520.GB212599@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240521161520.GB212599@ls.amr.corp.intel.com>

On Tue, May 21, 2024 at 09:15:20AM -0700,
Isaku Yamahata <isaku.yamahata@intel.com> wrote:

> On Tue, May 21, 2024 at 03:07:50PM +0000,
> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:
> 
> > > 1.4.2 Guest Physical Address Translation
> > >   Transition to SEAM VMX non-root operation is formatted to require Extended
> > >   Page Tables (EPT) to be enabled. In SEAM VMX non-root operation, there
> > > should
> > >   be two EPTs active: the private EPT specified using the EPTP field of the
> > > VMCS
> > >   and a shared EPT specified using the Shared-EPTP field of the VMCS.
> > >   When translating a GPA using the shared EPT, an EPT misconfiguration can
> > > occur
> > >   if the entry is present and the physical address bits in the range
> > >   (MAXPHYADDR-1) to (MAXPHYADDR-TDX_RESERVED_KEYID_BITS) are set, i.e., if
> > >   configured with a TDX private KeyID.
> > >   If the CPU's maximum physical-address width (MAXPA) is 52 and the guest
> > >   physical address width is configured to be 48, accesses with GPA bits 51:48
> > >   not all being 0 can cause an EPT-violation, where such EPT-violations are
> > > not
> > >   mutated to #VE, even if the “EPT-violations #VE” execution control is 1.
> > >   If the CPU's physical-address width (MAXPA) is less than 48 and the SHARED
> > > bit
> > >   is configured to be in bit position 47, GPA bit 47 would be reserved, and
> > > GPA
> > >   bits 46:MAXPA would be reserved. On such CPUs, setting bits 51:48 or bits
> > >   46:MAXPA in any paging structure can cause a reserved bit page fault on
> > >   access.
> > 
> > In "if the entry is present and the physical address bits in the range
> > (MAXPHYADDR-1) to (MAXPHYADDR-TDX_RESERVED_KEYID_BITS) are set", it's not clear
> > to be if "physical address bits" is referring to the GPA or the "entry" (meaning
> > the host pfn). The "entry" would be my guess.
> > 
> > It is also confusing when it talks about "guest physical address". It must mean
> > 4 vs 5 level paging? How else is the shared EPT walker supposed to know the
> > guest maxpa. In which case it would be consistent with normal EPT behavior. But
> > the assertions around reserved bit page faults are surprising.
> > 
> > Based on those guesses, I'm not sure the below code is correct. We wouldn't need
> > to remove keyid bits from the GFN.
> > 
> > Maybe we should clarify the spec? Or are you confident reading it the other way?
> 
> I'll read them more closely. At least the following patch is broken.

I was confused with guest(virtual) maxphyaddr and host maxphyaddr. Here is the
outcome.  We have 5 potentially problematic points related to mmu max pfn.

Related operations
==================
- memslot creation or kvm_arch_prepare_memory_region()
  We can create the slot beyond virtual maxphyaddr without any change.  Although
  it's weird, it doesn't immediately harm.  If we prevent it, some potentially
  problematic case won't happen.

- TDP MMU iterator (including memslot deletion)
  It works fine without any change because it uses only necessary bits of GPA.
  It ignores upper bits of given GFN for start. it ends with the SPTE traverse
  if GPA > virtual maxphyaddr.

  For secure-EPT
  It may go beyond shared-bit if slots is huge enough to cross the boundary of
  private-vs-shared.  Because (we can make) tdp mmu fault handler doesn't
  populate on such entries, it essentially results in NOP.

- population EPT violation
  Because TDX EPT violation handler can filter out ept violation with GPA >
  virtual maxphyaddr, we can assume GPA passed to the fault handler is < virtual
  maxphyaddr.

- zapping (including memslot deletion)
  Because zapping not-populated GFN is nop, so zapping specified GFN works fine.

- pre_fault_memory
  KVM_PRE_FAULT_MEMORY calls the fault handler without virtual maxphyaddr
  Additional check is needed to prevent GPA > virtual maxphyaddr
  if virtual maxphyaddr < 47 or 52.


I can think of the following options.

options
=======
option 1. Allow per-VM kvm_mmu_max_gfn()
Pro: Conceptually easy to understand and it's straightforward to disallow
     memslot creation > virtual maxphyaddr
Con: overkill for the corner case? The diff is attached.  This is only when user
     space creates memlost > virtual maxphyaddr and the guest accesses GPA >
     virtual maxphyaddr)

option 2. Keep kvm_mmu_max_gfn() and add ad hock address check.
Pro: Minimal change?
     Modify kvm_handel_noslot_fault() or kvm_faultin_pfn() to reject GPA >
     virtual maxphyaddr.
Con: Conceptually confusing with allowing operation on GFN > virtual maxphyaddr.
     The change might be unnatural or ad-hoc because it allow to create memslot
     with GPA > virtual maxphyaddr.


The following is an experimental change for option 1.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 406effc613e5..dbc371071cb5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1558,6 +1558,7 @@ struct kvm_arch {
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
 
+	gfn_t mmu_max_gfn;
 	gfn_t gfn_shared_mask;
 };
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9cd83448e39f..7b7ecaf1c607 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -64,7 +64,7 @@ static __always_inline u64 rsvd_bits(int s, int e)
  */
 extern u8 __read_mostly shadow_phys_bits;
 
-static inline gfn_t kvm_mmu_max_gfn(void)
+static inline gfn_t __kvm_mmu_max_gfn(void)
 {
 	/*
 	 * Note that this uses the host MAXPHYADDR, not the guest's.
@@ -82,6 +82,11 @@ static inline gfn_t kvm_mmu_max_gfn(void)
 	return (1ULL << (max_gpa_bits - PAGE_SHIFT)) - 1;
 }
 
+static inline gfn_t kvm_mmu_max_gfn(struct kvm *kvm)
+{
+	return kvm->arch.mmu_max_gfn;
+}
+
 static inline u8 kvm_get_shadow_phys_bits(void)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 295c27dc593b..515edc6ae867 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3333,7 +3333,7 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	 * only if L1's MAXPHYADDR is inaccurate with respect to the
 	 * hardware's).
 	 */
-	if (unlikely(fault->gfn > kvm_mmu_max_gfn()))
+	if (unlikely(fault->gfn > kvm_mmu_max_gfn(vcpu->kvm)))
 		return RET_PF_EMULATE;
 
 	return RET_PF_CONTINUE;
@@ -6509,6 +6509,7 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
 
 void kvm_mmu_init_vm(struct kvm *kvm)
 {
+	kvm->arch.mmu_max_gfn = __kvm_mmu_max_gfn();
 	kvm->arch.shadow_mmio_value = shadow_mmio_value;
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 79c9b22ceef6..ee3456b2096d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -945,7 +945,7 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return iter->yielded;
 }
 
-static inline gfn_t tdp_mmu_max_gfn_exclusive(void)
+static inline gfn_t tdp_mmu_max_gfn_exclusive(struct kvm *kvm)
 {
 	/*
 	 * Bound TDP MMU walks at host.MAXPHYADDR.  KVM disallows memslots with
@@ -953,7 +953,7 @@ static inline gfn_t tdp_mmu_max_gfn_exclusive(void)
 	 * MMIO SPTEs for "impossible" gfns, instead sending such accesses down
 	 * the slow emulation path every time.
 	 */
-	return kvm_mmu_max_gfn() + 1;
+	return kvm_mmu_max_gfn(kvm) + 1;
 }
 
 static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
@@ -961,7 +961,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	struct tdp_iter iter;
 
-	gfn_t end = tdp_mmu_max_gfn_exclusive();
+	gfn_t end = tdp_mmu_max_gfn_exclusive(kvm);
 	gfn_t start = 0;
 
 	for_each_tdp_pte_min_level(iter, kvm, root, zap_level, start, end) {
@@ -1062,7 +1062,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	struct tdp_iter iter;
 
-	end = min(end, tdp_mmu_max_gfn_exclusive());
+	end = min(end, tdp_mmu_max_gfn_exclusive(kvm));
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 61715424629b..5c2afca59386 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2549,7 +2549,9 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	struct kvm_tdx_init_vm *init_vm = NULL;
 	struct td_params *td_params = NULL;
-	int ret;
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	int ret, idx, i, bkt;
 
 	BUILD_BUG_ON(sizeof(*init_vm) != 8 * 1024);
 	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
@@ -2611,6 +2613,25 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(51));
 	else
 		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(47));
+	kvm->arch.mmu_max_gfn = min(kvm->arch.mmu_max_gfn,
+				    kvm->arch.gfn_shared_mask - 1);
+	/*
+	 * As memslot can be created before KVM_TDX_INIT_VM, check whether the
+	 * existing memslot is equal or lower than mmu_max_gfn.
+	 */
+	idx = srcu_read_lock(&kvm->srcu);
+	write_lock(&kvm->mmu_lock);
+	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(slot, bkt, slots) {
+			if (slot->base_gfn + slot->npages > kvm->arch.mmu_max_gfn) {
+				ret = -ERANGE;
+				break;
+			}
+		}
+	}
+	write_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
 
 out:
 	/* kfree() accepts NULL. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5812cd1a4bc..9461cd4f540b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13029,7 +13029,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		return -EINVAL;
 
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
-		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn())
+		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn(kvm))
 			return -EINVAL;
 
 		return kvm_alloc_memslot_metadata(kvm, new);



-- 
Isaku Yamahata <isaku.yamahata@intel.com>

