Return-Path: <kvm+bounces-35697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F10F0A1447C
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 23:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E839167034
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 22:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218BF22BACC;
	Thu, 16 Jan 2025 22:28:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9417413B58C;
	Thu, 16 Jan 2025 22:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737066537; cv=none; b=YB2GgE3TighGNxwttKSMpxghBkn8ZqLiwolnaOxxmv1Jwn+QhkdOwyf+fOwl6m01wPiZMiJwbtp8PTE9PpOwLtjoMEiwgcA6NFeoWapYOugbHpeDsQJy34KWUwo23eeerDtiFluodIzpjeiIHSnKAF36pww+XP5qasKR0m5epDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737066537; c=relaxed/simple;
	bh=z4Z21kOLF9xnwI/o2ML1cm/gAlvjMWxEDrwbA9fs3D4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rNlCc1NufJp2A6p5lQWbktpZKVM1Jmr22pnYpOwMElWnDlyTtH78kzsSxEaA6gYyugQc52+cWfPc/2G6JaC/UlWeVe4jBA/rtd0V7Ef+ieILOOAmkh2WtUuHgxZWXzV6BudTMYzXqeLz+MXlOTKusDJ7Dp7s8maZH9gswfygkLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3862C4CED6;
	Thu, 16 Jan 2025 22:28:50 +0000 (UTC)
Date: Thu, 16 Jan 2025 22:28:48 +0000
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
Message-ID: <Z4mIIA5UuFcHNUwL@arm.com>
References: <20241118131958.4609-2-ankita@nvidia.com>
 <a2d95399-62ad-46d3-9e48-6fa90fd2c2f3@redhat.com>
 <20250106165159.GJ5556@nvidia.com>
 <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
 <SA1PR12MB7199E3C81FDC017820773DE0B01C2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250113162749.GN5556@nvidia.com>
 <0743193c-80a0-4ef8-9cd7-cb732f3761ab@redhat.com>
 <20250114133145.GA5556@nvidia.com>
 <SA1PR12MB71998E1E70F3A03D5E30DE40B0182@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250115143213.GQ5556@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115143213.GQ5556@nvidia.com>

On Wed, Jan 15, 2025 at 10:32:13AM -0400, Jason Gunthorpe wrote:
> On Tue, Jan 14, 2025 at 11:13:48PM +0000, Ankit Agrawal wrote:
> > > Do we really want another weirdly defined VMA flag? I'd really like to
> > > avoid this.. 
> > 
> > I'd let Catalin chime in on this. My take of the reason for his suggestion is
> > that we want to reduce the affected configs to only the NVIDIA grace based
> > systems. The nvgrace-gpu module would be setting the flag and the
> > new codepath will only be applicable there. Or am I missing something here?
> 
> We cannot add VMA flags that are not clearly defined. The rules for
> when the VMA creater should set the flag need to be extermely clear
> and well defined.
> 
> > > Can't we do a "this is a weird VM_PFNMAP thing, let's consult the VMA
> > > prot + whatever PFN information to find out if it is weird-device and
> > > how we could safely map it?"
> > 
> > My understanding was that the new suggested flag VM_FORCE_CACHED
> > was essentially to represent "whatever PFN information to find out if it is
> > weird-device". Is there an alternate reliable check to figure this out?
> 
> For instance FORCE_CACHED makes no sense, how will the VMA creator
> know it should set this flag?
> 
> > Currently in the patch we check the following. So Jason, is the suggestion that
> > we simply return error to forbid such condition if VM_PFNMAP is set?
> > +	else if (!mte_allowed && kvm_has_mte(kvm))
> 
> I really don't know enought about mte, but I would take the position
> that VM_PFNMAP does not support MTE, and maybe it is even any VMA
> without VM_MTE/_ALLOWED does not support MTE?
> 
> At least it makes alost more sense for the VMA creator to indicate
> positively that the underlying HW supports MTE.

Sorry, I didn't get the chance to properly read this thread. I'll try
tomorrow and next week.

Basically I don't care whether MTE is supported on such vma, I doubt
you'd want to enable MTE anyway. But the way MTE was designed in the Arm
architecture, prior to FEAT_MTE_PERM, it allows a guest to enable MTE at
Stage 1 when Stage 2 is Normal WB Cacheable. We have no idea what enable
MTE at Stage 1 means if the memory range doesn't support it. It could be
external aborts, SError or simply accessing data (as tags) at random
physical addresses that don't belong to the guest. So if a vma does not
have VM_MTE_ALLOWED, we either disable Stage 2 cacheable or allow it
with FEAT_MTE_PERM (patches from Aneesh on the list). Or, a bigger
happen, disable MTE in guests (well, not that big, not many platforms
supporting MTE, especially in the enterprise space).

A second problem, similar to relaxing to Normal NC we merged last year,
we can't tell what allowing Stage 2 cacheable means (SError etc). That's
why I thought this knowledge lies with the device, KVM doesn't have the
information. Checking vm_page_prot instead of a VM_* flag may work if
it's mapped in user space but this might not always be the case. I don't
see how VM_PFNMAP alone can tell us anything about the access properties
supported by a device address range. Either way, it's the driver setting
vm_page_prot or some VM_* flag. KVM has no clue, it's just a memory
slot.

A third aspect, more of a simplification when reasoning about this, was
to use FWB at Stage 2 to force cacheability and not care about cache
maintenance, especially when such range might be mapped both in user
space and in the guest.

-- 
Catalin

