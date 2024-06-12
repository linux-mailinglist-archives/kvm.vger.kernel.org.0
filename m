Return-Path: <kvm+bounces-19494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E10E905B92
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 20:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AABE1F21690
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 18:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC7F7E116;
	Wed, 12 Jun 2024 18:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k+VxNY9/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708525FB8A;
	Wed, 12 Jun 2024 18:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218567; cv=none; b=lxsfbZwwNHjdzY5iooeRc7uVN+Mz/kgz5z7jJ8PPpzIHW/mIuu0r2atYRAavg0bGI03inPZyuS668Y/mHkLrg6W0u4DpEc25cl09DZGOE72PlvOClfFMIbHVU1QU4fV8coL3jcnhgKnTMX1z2DyML3LA4VlqIUqBqlXgcjOC26k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218567; c=relaxed/simple;
	bh=fE9vto68Rt85S2SZXDTIB7EibUnpLIdueFbtiR5ca+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HsMGA5G+0b5eLQ0CoCK3pbMabyzI46XXcdrBQLp9U6itQ5V3ZyTnOueiO6zdlcCwWKddw0gUBL5tAIzNA43SojWrP0ey9v2zz8o8a9W/g+6a8C2OAe5mRJRGCK4rZlDZDTddS2SobNZ9lKrex+ZXJWUjk0MDxhePrdoaClMwBgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k+VxNY9/; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718218565; x=1749754565;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=fE9vto68Rt85S2SZXDTIB7EibUnpLIdueFbtiR5ca+s=;
  b=k+VxNY9/2qqOFeDODnqr5YFFkuQ4SmdsMnJYZUOG6P5EHMDrzXjSu/OU
   SzS5H7WCWcZadxts6khUyuSQYGwSvPyqLfMKpvqkohEMtNzpVz5Q0qK5h
   kLvOZ7IJd+vby2i7RIIUgC2825xgkL8jWjGQrnRRlhGSg6SIWNxIZsrSV
   SYOEbV20QvtjUngw0I5OxG/jSWjmmT8e7m7t8RZGLsEzIJ8W0HyqVb7w1
   V9v1ZJC44b3gEXOuvDTT7uQuuovWFpwH+e97zzjtqgIcLv7/u9tZ7tA70
   2AEIgtu7RSScNWdqvwng1I+o/ZFpoq3KQ1vARDrRaXDu8K5dRZJzu/wGm
   A==;
X-CSE-ConnectionGUID: ungPepIHQ3Wc9B/cj+yWnA==
X-CSE-MsgGUID: rUZUJ+6pQhOGqd7IDaN05w==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="17927199"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="17927199"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 11:56:04 -0700
X-CSE-ConnectionGUID: kAKJKxBhThSMMnn3RVpG1g==
X-CSE-MsgGUID: lQKMqU64TvaTvNOzQvS+Xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="40357216"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 11:56:04 -0700
Date: Wed, 12 Jun 2024 11:56:03 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 15/15] KVM: x86/tdp_mmu: Add a helper function to walk
 down the TDP MMU
Message-ID: <20240612185603.GK386318@ls.amr.corp.intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
 <20240530210714.364118-16-rick.p.edgecombe@intel.com>
 <CABgObfbpNN842noAe77WYvgi5MzK2SAA_FYw-=fGa+PcT_Z22w@mail.gmail.com>
 <af69a8359cd5edf892d68764789de7f357c58d5e.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af69a8359cd5edf892d68764789de7f357c58d5e.camel@intel.com>

On Fri, Jun 07, 2024 at 11:39:14PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Fri, 2024-06-07 at 11:31 +0200, Paolo Bonzini wrote:
> > > -int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> > > -                        int *root_level)
> > > +static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64
> > > *sptes,
> > > +                                 enum kvm_tdp_mmu_root_types root_type)
> > >   {
> > > -       struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
> > > +       struct kvm_mmu_page *root = tdp_mmu_get_root(vcpu, root_type);
> > 
> > I think this function should take the struct kvm_mmu_page * directly.
> > 
> > > +{
> > > +       *root_level = vcpu->arch.mmu->root_role.level;
> > > +
> > > +       return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, KVM_DIRECT_ROOTS);
> > 
> > Here you pass root_to_sp(vcpu->arch.mmu->root.hpa);
> 
> I see. It is another case of more indirection to try to send the decision making
> through the helpers. We can try to open code things more.
> 
> > 
> > > +int kvm_tdp_mmu_get_walk_mirror_pfn(struct kvm_vcpu *vcpu, u64 gpa,
> > > +                                    kvm_pfn_t *pfn)
> > > +{
> > > +       u64 sptes[PT64_ROOT_MAX_LEVEL + 1], spte;
> > > +       int leaf;
> > > +
> > > +       lockdep_assert_held(&vcpu->kvm->mmu_lock);
> > > +
> > > +       rcu_read_lock();
> > > +       leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, KVM_MIRROR_ROOTS);
> > 
> > and likewise here.
> > 
> > You might also consider using a kvm_mmu_root_info for the mirror root,
> > even though the pgd field is not used.
> 
> This came up on the last version actually. The reason against it was that it
> used that tiny bit of extra memory for the pgd. It does look more symmetrical
> though.
> 
> > 
> > Then __kvm_tdp_mmu_get_walk() can take a struct kvm_mmu_root_info * instead.
> 
> Ahh, I see. Yes, that's a good reason.
> 
> > 
> > kvm_tdp_mmu_get_walk_mirror_pfn() doesn't belong in this series, but
> > introducing __kvm_tdp_mmu_get_walk() can stay here.
> 
> Ok, we can split it.
> 
> > 
> > Looking at the later patch, which uses
> > kvm_tdp_mmu_get_walk_mirror_pfn(), I think this function is a bit
> > overkill. I'll do a pre-review of the init_mem_region function,
> > especially the usage of kvm_gmem_populate:
> > 
> > +    slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> > +    if (!kvm_slot_can_be_private(slot) || !kvm_mem_is_private(kvm, gfn)) {
> > +        ret = -EFAULT;
> > +        goto out_put_page;
> > +    }
> > 
> > The slots_lock is taken, so checking kvm_slot_can_be_private is unnecessary.
> > 
> > Checking kvm_mem_is_private perhaps should also be done in
> > kvm_gmem_populate() itself. I'll send a patch.
> > 
> > +    read_lock(&kvm->mmu_lock);
> > +
> > +    ret = kvm_tdp_mmu_get_walk_mirror_pfn(vcpu, gpa, &mmu_pfn);
> > +    if (ret < 0)
> > +        goto out;
> > +    if (ret > PG_LEVEL_4K) {
> > +        ret = -EINVAL;
> > +        goto out;
> > +    }
> > +    if (mmu_pfn != pfn) {
> > +        ret = -EAGAIN;
> > +        goto out;
> > +    }
> > 
> > If you require pre-faulting, you don't need to return mmu_pfn and
> > things would be seriously wrong if the two didn't match, wouldn't
> > they?
> 
> Yea, I'm not sure why it would be a normal condition. Maybe Isaku can comment on
> the thinking?

Sean suggested for KVM_TDX_INIT_MEM_REGION to check if the two pfn from TDP MMU
and guest_memfd match.  As pointed out, the two PFNs should match under
appropriate lock (or heavily broken).  Personally I'm fine to remove such check
and to avoid returning pfn.

https://lore.kernel.org/kvm/Ze-TJh0BBOWm9spT@google.com/

  Then KVM provides a dedicated TDX ioctl(), i.e. what is/was KVM_TDX_INIT_MEM_REGION,
  to do PAGE.ADD.  KVM_TDX_INIT_MEM_REGION wouldn't need to map anything, it would
  simply need to verify that the pfn from guest_memfd() is the same as what's in
  the TDP MMU.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

