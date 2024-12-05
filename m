Return-Path: <kvm+bounces-33165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 286429E5B71
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 17:30:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBE731883811
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 16:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F52222578;
	Thu,  5 Dec 2024 16:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0qCyaff"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BF521A446;
	Thu,  5 Dec 2024 16:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733416222; cv=none; b=RAb/dTVsQ+/eEiZNQzrlD/yJ7lAPjaiJrJG+SZVjayRZOuHI56cCybugFGrZBQX5kdQoygVcV/IK8YiTLu1XTcBYJYrnuivqm5IgJwY2bi9bnn4p6qeOCblcYRXJyyVLY+hjG8QfvrHhtsKbwUb8sljFdsU7LVCL1DjER6QyaE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733416222; c=relaxed/simple;
	bh=JZYjiXph0kgrFqxAOYCDp966omE7pEdIT+tPa7QheFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lz3mHq69ZAPdku36cAmz5GDF+GbNMzmZdYgLK3LeLPsXJv46xzCu06dTNtkLQK24i8bz7Imu4N1kVeo/wYn8PnQbdPxYsp8CuTDkWkBDxWJWrb4uM2+XPOvRM3quhJz1VyfEL9tNfMOBQ+m7gCSGKskvGwhd0Txm1WqchrsjWJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0qCyaff; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98490C4CEDD;
	Thu,  5 Dec 2024 16:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733416219;
	bh=JZYjiXph0kgrFqxAOYCDp966omE7pEdIT+tPa7QheFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J0qCyaffBKVSDWEcvjsgImXDsKVzMkCwi5JhpwQgK8fnXuUcKAwEZKjNz6N41+OYz
	 NwiJRPEJvo8vDuVcbp1XrLx2qKG1PhQCZMIWW+uvaDc2eb/NWrXWIB5Yu87+8i7HTL
	 JJu0NlX2AFqQ+H39LqMClRWhZYq9nZN8ASDp45/tKYJTIu3gSq1UHBFsfWiONs6KsW
	 W/HxApBbMjZmc7A4IvIvYm14tC9t54+lu8RO3tbiy/lbdb3RUK2Ra99DFyAYNklGTf
	 7YFRxgMc4Wfzo+uK+jXTZuNbdNETFpIk1/rFGmQGP4Qj7BkVHuXtluYWDO+txS6iGd
	 ea1MRs7+2IOhw==
Date: Thu, 5 Dec 2024 18:30:02 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com, peterz@infradead.org,
	tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
	mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
	dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
	isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
	sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v15 08/23] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Message-ID: <Z1HVCuvE7qSQpjYt@kernel.org>
References: <cover.1699527082.git.kai.huang@intel.com>
 <87e19d1931e33bfaece5b79602cfbd517df891f1.1699527082.git.kai.huang@intel.com>
 <Z1Fc8g47vfpz9EVW@kernel.org>
 <62539c75-8f4e-4e12-bcb4-55c46cdf646d@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62539c75-8f4e-4e12-bcb4-55c46cdf646d@suse.com>

On Thu, Dec 05, 2024 at 11:06:17AM +0200, Nikolay Borisov wrote:
> 
> 
> On 5.12.24 г. 9:57 ч., Mike Rapoport wrote:
> > Hi,
> > 
> > I've been auditing for_each_mem_pfn_range() users and it's usage in TDX is
> > dubious for me.
> > 
> > On Fri, Nov 10, 2023 at 12:55:45AM +1300, Kai Huang wrote:
> > > 
> > > As TDX-usable memory is a fixed configuration, take a snapshot of the
> > > memory configuration from memblocks at the time of module initialization
> > > (memblocks are modified on memory hotplug).  This snapshot is used to
> > 
> > AFAUI this could happen long after free_initmem() which discards all
> > memblock data on x86.
> > >> enable TDX support for *this* memory configuration only.  Use a memory
> > > hotplug notifier to ensure that no other RAM can be added outside of
> > > this configuration.
> > ...
> > 
> > > +/*
> > > + * Ensure that all memblock memory regions are convertible to TDX
> > > + * memory.  Once this has been established, stash the memblock
> > > + * ranges off in a secondary structure because memblock is modified
> > > + * in memory hotplug while TDX memory regions are fixed.
> > > + */
> > > +static int build_tdx_memlist(struct list_head *tmb_list)
> > > +{
> > > +	unsigned long start_pfn, end_pfn;
> > > +	int i, ret;
> > > +
> > > +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
> > 
> > Unles ARCH_KEEP_MEMBLOCK is defined this won't work after free_initmem()
> 
> TDX_HOST actually selects ARCH_KEEP_MEMBLOCK:

Oh, I've missed that, thanks!
 
>   6 config INTEL_TDX_HOST
>    5         bool "Intel Trust Domain Extensions (TDX) host support"
>    4         depends on CPU_SUP_INTEL
>    3         depends on X86_64
>    2         depends on KVM_INTEL
>    1         depends on X86_X2APIC
> 1980         select ARCH_KEEP_MEMBLOCK
>    1         depends on CONTIG_ALLOC
>    2         depends on !KEXEC_CORE
>    3         depends on X86_MCE
> 
> 
> <snip>
> 

-- 
Sincerely yours,
Mike.

