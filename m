Return-Path: <kvm+bounces-35849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BE88A1579B
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:53:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3912C3A342E
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 18:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51FBC1A4F0C;
	Fri, 17 Jan 2025 18:52:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0FA19E7D1;
	Fri, 17 Jan 2025 18:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737139967; cv=none; b=QO6Ctwsfl+nYtZymBCYdAO+5JUSMWS+oohrh+RbSJH0RQx6g3qkyVPUX20A1L782xQcFCEZYt9adokQVHojNrZPM8+BsgSU/thKfhpDn2bQkhUxph0oqOMgG3C+EHiyqe7wViFm7sc1fdGoavlKv7QjLlUJsRjX+WsDZwp3NNA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737139967; c=relaxed/simple;
	bh=BpLY2SA/+76tfThiWvylQLMIS5DqNIMLRKKDkAgNxuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHZ+GzYkkKWA4H3pI7V7y0401mmcHDi0w7fQ/WEIgaJpCkLR+SjDmLLg7JlsumwF2tF7+r9v+PwT9Ml+Vrpl5ifGIBIq/Cu0ExgB8YI08RpVdn1/QKpEpeY+K6lJJhJ04TzY+zIFFUBBscH9ok5uAbq4M/BXuJ7KV9KQTCy2k40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C46C4CEDD;
	Fri, 17 Jan 2025 18:52:41 +0000 (UTC)
Date: Fri, 17 Jan 2025 18:52:39 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, David Hildenbrand <david@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <Z4qm95LRizWiBPpT@arm.com>
References: <20250106165159.GJ5556@nvidia.com>
 <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
 <SA1PR12MB7199E3C81FDC017820773DE0B01C2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250113162749.GN5556@nvidia.com>
 <0743193c-80a0-4ef8-9cd7-cb732f3761ab@redhat.com>
 <20250114133145.GA5556@nvidia.com>
 <SA1PR12MB71998E1E70F3A03D5E30DE40B0182@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250115143213.GQ5556@nvidia.com>
 <Z4mIIA5UuFcHNUwL@arm.com>
 <20250117140050.GC5556@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250117140050.GC5556@nvidia.com>

On Fri, Jan 17, 2025 at 10:00:50AM -0400, Jason Gunthorpe wrote:
> On Thu, Jan 16, 2025 at 10:28:48PM +0000, Catalin Marinas wrote:
> > with FEAT_MTE_PERM (patches from Aneesh on the list). Or, a bigger
> > happen, disable MTE in guests (well, not that big, not many platforms
> > supporting MTE, especially in the enterprise space).
> 
> As above, it seems we already effectively disable MTE in guests to use
> VFIO.

That's fine. Once the NoTagAccess feature gets in, we could allow MTE
here as well.

> > A second problem, similar to relaxing to Normal NC we merged last year,
> > we can't tell what allowing Stage 2 cacheable means (SError etc).
> 
> That was a very different argument. On that series KVM was upgrading a
> VM with pgprot noncached to Normal NC, that upgrade was what triggered
> the discussions about SError.
> 
> For this case the VMA is already pgprot cache. KVM is not changing
> anything. The KVM S2 will have the same Normal NC memory type as the
> VMA has in the S1.  Thus KVM has no additional responsibility for
> safety here.

I agree this is safe. My point was more generic about not allowing
cacheable mappings without some sanity check. Ankit's patch relies on
the pgprot used on the S1 mapping to make this decision. Presumably the
pgprot is set by the host driver.

> > information. Checking vm_page_prot instead of a VM_* flag may work if
> > it's mapped in user space but this might not always be the case. 
> 
> For this series it is only about mapping VMAs. Some future FD based
> mapping for CC is going to also need similar metadata.. I have another
> thread about that :)

How soon would you need that and if you come up with a different
mechanism, shouldn't we unify them early rather than having two methods?

> > I don't see how VM_PFNMAP alone can tell us anything about the
> > access properties supported by a device address range. Either way,
> > it's the driver setting vm_page_prot or some VM_* flag. KVM has no
> > clue, it's just a memory slot.
> 
> I think David's point about VM_PFNMAP was to avoid some of the
> pfn_valid() logic. If we get VM_PFNMAP we just assume it is non-struct
> page and follow the VMA's pgprot.

Ah, ok, thanks for the clarification.

> > A third aspect, more of a simplification when reasoning about this, was
> > to use FWB at Stage 2 to force cacheability and not care about cache
> > maintenance, especially when such range might be mapped both in user
> > space and in the guest.
> 
> Yes, I thought we needed this anyhow as KVM can't cache invalidate
> non-struct page memory..

Looks good. I think Ankit should post a new series factoring out the
exec handling in a separate patch, dropping some of the pfn_valid()
assumptions and we take it from there.

I also think some sanity check should be done early in
kvm_arch_prepare_memory_region() like rejecting the slot if it's
cacheable and we don't have FWB. But I'll leave this decision to the KVM
maintainers. We are trying to relax some stuff here as well (see the
NoTagAccess thread).

-- 
Catalin

