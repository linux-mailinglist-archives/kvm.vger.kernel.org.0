Return-Path: <kvm+bounces-13404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99712895FE1
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 00:58:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0DAB0B2363B
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 22:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D553E487;
	Tue,  2 Apr 2024 22:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XIxUAIsf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB4045019;
	Tue,  2 Apr 2024 22:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712098724; cv=none; b=VNA99uRmaIKNYuA5rqLs3wQh7rzXzjLRiYOi19pWVy9wSuqnXyTQ/+gCdoLaB49Whj+wOCKFCUYdQzS31d0efDQZW+iOX0sX93JJ+Bu+Px4aIV17GFMcqd6vR+3ZJvBlRbdunkyug+oZ4B+tSv5bZBySx4jw2CMg/72HmabdcAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712098724; c=relaxed/simple;
	bh=n9PG5Gd9QCdKP+TIsy1Z2jPRkRgvC7X2SZe2L3r5+MM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f/CWpOr0L5hsGQxSZ6cFk80kqj8jJ32l2h7VsDf9yREDBhB0VUrYJclsUV/blmHxCWcOzCl/VbFOdxclX2XM3oTinPPplhmqyvggbqEVV+GFvUE2Ch+KbVBGW/Gn2L6x2ov0yi7tiAwNI0+rrXBoWAKz34nGx6+4ZkaOpeokXXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XIxUAIsf; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712098723; x=1743634723;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n9PG5Gd9QCdKP+TIsy1Z2jPRkRgvC7X2SZe2L3r5+MM=;
  b=XIxUAIsfwatXWsk4GUiREKxtgYU1ZlWAI+Ot0B3xiZSnfncipP0Le+jI
   WJihhgwX9UUFNgnayNk1CqGx5ncImsQks1bY3gYo1GdYrxJmrbs8R3xm9
   jhUmbmgV5cEg7oMzSbaFxpK03bl1Yov3paPYuKyWWZk9fpdTqroKbSean
   GSyWbgOAYO2aHiAsb1u/VN/LtCn5SqK2h9WXhQYIniKAh3bx9BMYEryN8
   kDg83tp48ZvCtsVSUQTMfZ8YE0P62Xhvpi+QnPUsxYUfPrU2ZtF/mMbkA
   F0gUShIPh5vHYMkPnsdTOf2X8Tolwahh2/QMB0pLcz7GWvUx9q5fsGoF0
   Q==;
X-CSE-ConnectionGUID: flQpB5klTSaYsqDzPd/27g==
X-CSE-MsgGUID: wHs1siJORuCL/0hwUmY5gw==
X-IronPort-AV: E=McAfee;i="6600,9927,11032"; a="18747114"
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="18747114"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 15:58:42 -0700
X-CSE-ConnectionGUID: G+hY9GcpQa2do2OYHO31bA==
X-CSE-MsgGUID: yZLG52nDTMerl9bXyvsizQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="22978988"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 15:58:41 -0700
Date: Tue, 2 Apr 2024 15:58:40 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com,
	Brijesh Singh <brijesh.singh@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v12 11/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Message-ID: <20240402225840.GB2444378@ls.amr.corp.intel.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-12-michael.roth@amd.com>
 <8c3685a6-833c-4b3c-83f4-c0bd78bba36e@redhat.com>
 <20240401222229.qpnpozdsr6b2sntk@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240401222229.qpnpozdsr6b2sntk@amd.com>

On Mon, Apr 01, 2024 at 05:22:29PM -0500,
Michael Roth <michael.roth@amd.com> wrote:

> On Sat, Mar 30, 2024 at 09:31:40PM +0100, Paolo Bonzini wrote:
> > On 3/29/24 23:58, Michael Roth wrote:
> 
> Cc'ing some more TDX folks.
> 
> > > +	memslot = gfn_to_memslot(kvm, params.gfn_start);
> > > +	if (!kvm_slot_can_be_private(memslot)) {
> > > +		ret = -EINVAL;
> > > +		goto out;
> > > +	}
> > > +
> > 
> > This can be moved to kvm_gmem_populate.
> 
> That does seem nicer, but I hadn't really seen that pattern for
> kvm_gmem_get_pfn()/etc. so wasn't sure if that was by design or not. I
> suppose in those cases the memslot is already available at the main
> KVM page-fault call-sites so maybe it was just unecessary to do the
> lookup internally there.
> 
> > 
> > > +	populate_args.src = u64_to_user_ptr(params.uaddr);
> > 
> > This is not used if !do_memcpy, and in fact src is redundant with do_memcpy.
> > Overall the arguments can be "kvm, gfn, src, npages, post_populate, opaque"
> > which are relatively few and do not need the struct.
> 
> This was actually a consideration for TDX that was discussed during the
> "Finalizing internal guest_memfd APIs for SNP/TDX" PUCK call. In that
> case, they have a TDH_MEM_PAGE_ADD seamcall that takes @src and encrypts
> it, loads it into the destination page, and then maps it into SecureEPT
> through a single call. So in that particular case, @src would be
> initialized, but the memcpy() would be unecessary.
> 
> It's not actually clear TDX plans to use this interface. In v19 they still
> used a KVM MMU hook (set_private_spte) that gets triggered through a call
> to KVM_MAP_MEMORY->kvm_mmu_map_tdp_page() prior to starting the guest. But
> more recent discussion[1] suggests that KVM_MAP_MEMORY->kvm_mmu_map_tdp_page()
> would now only be used to create upper levels of SecureEPT, and the
> actual mapping/encrypting of the leaf page would be handled by a
> separate TDX-specific interface.

I think TDX can use it with slight change. Pass vcpu instead of KVM, page pin
down and mmu_lock.  TDX requires non-leaf Secure page tables to be populated
before adding a leaf.  Maybe with the assumption that vcpu doesn't run, GFN->PFN
relation is stable so that mmu_lock isn't needed? What about punch hole?

The flow would be something like as follows.

- lock slots_lock

- kvm_gmem_populate(vcpu)
  - pin down source page instead of do_memcopy.
  - get pfn with __kvm_gmem_get_pfn()

  - read lock mmu_lock
  - in the post_populate callback
    - lookup tdp mmu page table to check if the table is populated.
      lookup only version of kvm_tdp_mmu_map().
      We need vcpu instead of kvm.
    - TDH_MEM_PAGE_ADD
  - read unlock mmu_lock

- unlock slots_lock

Thanks,

> With that model, the potential for using kvm_gmem_populate() seemed
> plausible to I was trying to make it immediately usable for that
> purpose. But maybe the TDX folks can confirm whether this would be
> usable for them or not. (kvm_gmem_populate was introduced here[2] for
> reference/background)
> 
> -Mike
> 
> [1] https://lore.kernel.org/kvm/20240319155349.GE1645738@ls.amr.corp.intel.com/T/#m8580d8e39476be565534d6ff5f5afa295fe8d4f7
> [2] https://lore.kernel.org/kvm/20240329212444.395559-3-michael.roth@amd.com/T/#m3aeba660fcc991602820d3703b1265722b871025)
> 
> 
> > 
> > I'll do that when posting the next version of the patches in kvm-coco-queue.
> > 
> > Paolo
> > 
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

