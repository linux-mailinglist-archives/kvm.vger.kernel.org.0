Return-Path: <kvm+bounces-3571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EED3A8055E3
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2D2B1F21532
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3355D8EE;
	Tue,  5 Dec 2023 13:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fINV4e0s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E720B41747;
	Tue,  5 Dec 2023 13:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AB7C433C7;
	Tue,  5 Dec 2023 13:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701782901;
	bh=DN0Ck4V6T8maLKGy2DJScQ19aj0jXGmxo0qjkMgLuqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fINV4e0swP3QxF0ev7mBQAvzki1Es9fxlLKrYt4Ml5r6ebyNV47ZFG6KKJE58Sa0C
	 3zh32m3cDUj9V9aiRX6klfygHY7Zpag/nUR3YzCt09RaFofNMBfi6QGt0XDc7fBlvZ
	 YYHL4xNzxt56xHiSJqB7mte+HCJKJEYPM3/4y67n1Yu+swv5KT4LghhIlT0HhhLs31
	 KsBt+NMgbYuzWxiY1Ej3G1zN8rizq2crCh9Nzyb15ZhtgtZJFEPHxMtqV/PbiNc4yY
	 4X90gR8CZ55cZR0ozTQqIzuX3V77lEZhQWAI2x9K81K7qN1j6jcpTDu/AB1FujSAMz
	 s36dw6OW5eU+g==
Date: Tue, 5 Dec 2023 14:28:12 +0100
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	jgg@nvidia.com, oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	james.morse@arm.com
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZW8lbK88bgdmBgl9@lpieralisi>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW8MP2tDt4_9ROBz@arm.com>

[+James]

On Tue, Dec 05, 2023 at 11:40:47AM +0000, Catalin Marinas wrote:

[...]

> > - Will had unanswered questions in another part of the thread:
> > 
> >   https://lore.kernel.org/all/20231013092954.GB13524@willie-the-truck/
> > 
> >   Can someone please help concluding it?
> 
> Is this about reclaiming the device? I think we concluded that we can't
> generalise this beyond PCIe, though not sure there was any formal
> statement to that thread. The other point Will had was around stating
> in the commit message why we only relax this to Normal NC. I haven't
> checked the commit message yet, it needs careful reading ;).

1) Reclaiming the device: I wrote a section that was reported in this
   commit log hunk:

   "Relaxing S2 KVM device MMIO mappings to Normal-NC is not expected to
   trigger any issue on guest device reclaim use cases either (i.e.
   device MMIO unmap followed by a device reset) at least for PCIe
   devices, in that in PCIe a device reset is architected and carried
   out through PCI config space transactions that are naturally ordered
   with respect to MMIO transactions according to the PCI ordering
   rules."

   It is not too verbose on purpose - I thought it is too
   complicated to express the details in a commit log but
   we can elaborate on that if it is beneficial, probably
   in /Documentation, not in the log itself.

2) On FWB: I added a full section to the log I posted here:

   https://lore.kernel.org/all/ZUz78gFPgMupew+m@lpieralisi

   but I think Ankit trimmed it and I can't certainly blame anyone
   for that, it is a commit log, it is already hard to digest as it is.

I added James because I think that most of the points I made in the logs
are really RAS related (and without him I would not have understood half
of them :)). It would be very beneficial to everyone to have those
added to kernel documentation - especially to express in architectural
terms why this it is a safe change to make (at least for PCIe devices).

I am happy to work on the documentation changes - let's just agree what
should be done next.

Thanks,
Lorenzo

> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index d14504821b79..1cb302457d3f 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -1071,7 +1071,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> > >  	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
> > >  	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> > >  	struct kvm_pgtable *pgt = mmu->pgt;
> > > -	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
> > > +	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_NORMAL_NC |
> > >  				     KVM_PGTABLE_PROT_R |
> > >  				     (writable ? KVM_PGTABLE_PROT_W : 0);
> > 
> > Doesn't this affect the GICv2 VCPU interface, which is effectively a
> > shared peripheral, now allowing a guest to affect another guest's
> > interrupt distribution? If that is the case, this needs to be fixed.
> > 
> > In general, I don't think this should be a blanket statement, but be
> > limited to devices that we presume can deal with this (i.e. PCIe, and
> > not much else).
> 
> Based on other on-list and off-line discussions, I came to the same
> conclusion that we can't relax this beyond PCIe. How we do this, it's up
> for debate. Some ideas:
> 
> - something in the vfio-pci driver like a new VM_* flag that KVM can
>   consume (hard sell for an arch-specific thing)
> 
> - changing the vfio-pci driver to allow WC and NC mappings (x86
>   terminology) with additional knowledge about what it can safely map
>   as NC. KVM would mimic the vma attributes (it doesn't eliminate the
>   alias though, the guest can always go for Device while the VMM for
>   Normal)
> 
> - some per-SoC pfn ranges that are permitted as Normal NC. Can the arch
>   code figure out where these PCIe BARs are or is it only the vfio-pci
>   driver? I guess we can sort something out around the PCIe but I'm not
>   familiar with this subsystem. The alternative is some "safe" ranges in
>   firmware tables, assuming the firmware configures the PCIe BARs
>   location
> 
> -- 
> Catalin

