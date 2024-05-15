Return-Path: <kvm+bounces-17448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C5F8C6A83
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 18:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 856471F22135
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 16:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4A3156674;
	Wed, 15 May 2024 16:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h3qG4GvI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A83157483;
	Wed, 15 May 2024 16:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715790164; cv=none; b=t6ImHUbhP/zgtHfp8rx+6rKbG3MgUvJirD0Dt7CLYudm2/XC/S07AY6fjZjgz1OGYNCbtGDMRXcoc0uqn27Cq5UQxCl08mJdsPVg16AkXXebwrooliAr+YGUM60wExk5PA9Nknys/cQwpVNYyVqMOipOOixisnaqyfz4SQgcnQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715790164; c=relaxed/simple;
	bh=WN8DihRxARtwB0QXAI21QNZOgP69HIDQZiVNqspTz2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QoyfndEJHZOikyLwcl1kiudCnmuh+wTTALmdNmYpvYWKTQYj8Yd4o7OyOshxbxo35yRDGlIL8zz/vB+ApW8aXvREQAOANaft2Mml0XgvSls8KZFBySc9/DxOgVO0QIPstJ2XyPfMeZq5WENleYvmwBIlWvQtrvF05HTFrgJ4HLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h3qG4GvI; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715790162; x=1747326162;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WN8DihRxARtwB0QXAI21QNZOgP69HIDQZiVNqspTz2E=;
  b=h3qG4GvIuwuTznH6wbwC7SnVqSV4Uf5n/1u0MyRrDdNBVsArjhGZncY7
   P/p3ra1Nrvrdu7mpDO+cB61LYiKQcalpElZD2a64S/0ia9mjmIEj1BGrY
   77dK6XkKWQYsseR/T45w4UdcfGsaZWljhK9+5mmakTVJ7uRPZsKOsDOtU
   Z9oi72haWBW2fttfwUa5aCR/cfJG3B4LRVdr37MgNtkl6OXVLsmDqQIRc
   toqUSX8ePs79k3lG1hVTm0zk2vssB8C3NxiEhGNUA3CZZkujZ7i8kg5e2
   biNyruNa7fJmCzNDkGl77gEZfRmo7ga7PxT5xySpZM7MZhyFfIE9Cl6+T
   Q==;
X-CSE-ConnectionGUID: lIM9DzExRx2yK6XC8DZP4Q==
X-CSE-MsgGUID: qZL6PBzhT52bCd7hZzhftg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11725989"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11725989"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 09:22:42 -0700
X-CSE-ConnectionGUID: 5zjQutRqRQCGQhImpc8BMg==
X-CSE-MsgGUID: /1JC4d1CTfSCEMAzPJ34/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35655820"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 09:22:41 -0700
Date: Wed, 15 May 2024 09:22:40 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, erdemaktas@google.com, sagis@google.com,
	yan.y.zhao@intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Message-ID: <20240515162240.GC168153@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
 <ZkTWDfuYD-ThdYe6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZkTWDfuYD-ThdYe6@google.com>

On Wed, May 15, 2024 at 08:34:37AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index d5cf5b15a10e..808805b3478d 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6528,8 +6528,17 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
> >  
> >  	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
> >  
> > -	if (tdp_mmu_enabled)
> > +	if (tdp_mmu_enabled) {
> > +		/*
> > +		 * kvm_zap_gfn_range() is used when MTRR or PAT memory
> > +		 * type was changed.  TDX can't handle zapping the private
> > +		 * mapping, but it's ok because KVM doesn't support either of
> > +		 * those features for TDX. In case a new caller appears, BUG
> > +		 * the VM if it's called for solutions with private aliases.
> > +		 */
> > +		KVM_BUG_ON(kvm_gfn_shared_mask(kvm), kvm);
> 
> Please stop using kvm_gfn_shared_mask() as a proxy for "is this TDX".  Using a
> generic name quite obviously doesn't prevent TDX details for bleeding into common
> code, and dancing around things just makes it all unnecessarily confusing.
> 
> If we can't avoid bleeding TDX details into common code, my vote is to bite the
> bullet and simply check vm_type.

TDX has several aspects related to the TDP MMU.
1) Based on the faulting GPA, determine which KVM page table to walk.
   (private-vs-shared)
2) Need to call TDX SEAMCALL to operate on Secure-EPT instead of direct memory
   load/store.  TDP MMU needs hooks for it.
3) The tables must be zapped from the leaf. not the root or the middle.

For 1) and 2), what about something like this?  TDX backend code will set
kvm->arch.has_mirrored_pt = true; I think we will use kvm_gfn_shared_mask() only
for address conversion (shared<->private).

For 1), maybe we can add struct kvm_page_fault.walk_mirrored_pt
        (or whatever preferable name)?

For 3), flag of memslot handles it.

---
 arch/x86/include/asm/kvm_host.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aabf1648a56a..218b575d24bd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1289,6 +1289,7 @@ struct kvm_arch {
 	u8 vm_type;
 	bool has_private_mem;
 	bool has_protected_state;
+	bool has_mirrored_pt;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
 	struct list_head zapped_obsolete_pages;
@@ -2171,8 +2172,10 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_KVM_PRIVATE_MEM
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
+#define kvm_arch_has_mirrored_pt(kvm) ((kvm)->arch.has_mirrored_pt)
 #else
 #define kvm_arch_has_private_mem(kvm) false
+#define kvm_arch_has_mirrored_pt(kvm) false
 #endif
 
 static inline u16 kvm_read_ldt(void)
-- 
2.43.2
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

