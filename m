Return-Path: <kvm+bounces-5070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACA0881B735
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 14:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D91981C23494
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 13:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3984674E35;
	Thu, 21 Dec 2023 13:19:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4327745CD;
	Thu, 21 Dec 2023 13:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA05C433C7;
	Thu, 21 Dec 2023 13:19:20 +0000 (UTC)
Date: Thu, 21 Dec 2023 13:19:18 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>, ankita@nvidia.com, maz@kernel.org,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	gshan@redhat.com, linux-mm@kvack.org, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	james.morse@arm.com
Subject: Re: [PATCH v3 2/2] kvm: arm64: set io memory s2 pte as normalnc for
 vfio pci devices
Message-ID: <ZYQ7VjApH1v1QwTW@arm.com>
References: <20231208164709.23101-1-ankita@nvidia.com>
 <20231208164709.23101-3-ankita@nvidia.com>
 <ZXicemDzXm8NShs1@arm.com>
 <20231212181156.GO3014157@nvidia.com>
 <ZXoOieQN7rBiLL4A@linux.dev>
 <ZXsjv+svp44YjMmh@lpieralisi>
 <ZXszoQ48pZ7FnQNV@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXszoQ48pZ7FnQNV@linux.dev>

Catching up on emails before going on holiday (again).

On Thu, Dec 14, 2023 at 04:56:01PM +0000, Oliver Upton wrote:
> On Thu, Dec 14, 2023 at 04:48:15PM +0100, Lorenzo Pieralisi wrote:
> > > AFAICT, the only reason PCI devices can get the blanket treatment of
> > > Normal-NC at stage-2 is because userspace has a Device-* mapping and can't
> > > speculatively load from the alias. This feels a bit hacky, and maybe we
> > > should prioritize an interface for mapping a device into a VM w/o a
> > > valid userspace mapping.
> > 
> > FWIW - I have tried to summarize the reasoning behind PCIe devices
> > Normal-NC default stage-2 safety in a document that I have just realized
> > now it has become this series cover letter, I don't think the PCI blanket
> > treatment is related *only* to the current user space mappings (ie
> > BTW, AFAICS it is also *possible* at present to map a prefetchable BAR through
> > sysfs with Normal-NC memory attributes in the host at the same time a PCI
> > device is passed-through to a guest with VFIO - and therefore we have a
> > dev-nGnRnE stage-1 mapping for it. Don't think anyone does that - what for -
> > but it is possible and KVM would not know about it).
> > 
> > Again, FWIW, we were told (source Arm ARM) mismatched aliases concerning
> > device-XXX vs Normal-NC are not problematic as long as the transactions
> > issued for the related mappings are independent (and none of the
> > mappings is cacheable).
> > 
> > I appreciate this is not enough to give everyone full confidence on
> > this solution robustness - that's why I wrote that up so that we know
> > what we are up against and write KVM interfaces accordingly.
> 
> Apologies, I didn't mean to question what's going on here from the
> hardware POV. My concern was more from the kernel + user interfaces POV,
> this all seems to work (specifically for PCI) by maintaining an
> intentional mismatch between the VFIO stage-1 and KVM stage-2 mappings.

If you stare at it long enough, the mismatch starts to look fine ;).
Even if you have the VFIO stage 1 Normal NC, KVM stage 2 Normal NC, you
can still have the guest setting stage 1 to Device and introduce an
architectural mismatch. These aliases have some bad reputation but the
behaviour is constrained architecturally.

IMHO we should move on from this attribute mismatch since we can't fully
solve it anyway and focus instead on what the device, system can
tolerate, who's responsible for deciding which MMIO ranges can be mapped
as Normal NC. There are a few options here (talking in the PCIe context
but it can be extended to other VFIO mappings):

1. The VMM is responsible for intra-BAR relaxation of the KVM stage 2:
   a) via the stage 1 VFIO mapping attributes - Device or Normal
   b) via other means (e.g. ioctl(<range>)) while the stage 1 VFIO stays
      Device

2. KVM decides the intra-BAR relaxation irrespective of the VFIO stage 1
   attributes (VMM mapping)

3. KVM decides the full-BAR relaxation with the guest responsible for
   the intra-BAR attributes. As with (2), that's irrespective of the
   VFIO stage 1 host mapping

Whichever option we pick, it won't be the host forcing the Normal NC
mapping, that's still a guest decision and the host only allowing it.

(1) needs specific device knowledge in the VMM or a VFIO-specific driver
(or both if the VMM isn't fully trusted to request the right
attributes). (2) moves the device-specific knowledge to KVM or a
combination of KVM and VFIO-specific driver. Things can get a lot worse
if the Device vs Normal ranges within a BAR are configurable and needs
some paravirtualised interface for the guest to agree with the host.

These patches aim for (3) but only if the host VFIO driver deems it safe
(hence PCIe only for now). I find this an acceptable compromise.

If we really want to avoid any aliases (though I think we are spending
too many cycles on something that's not a real issue), the only way is
to have fd-based mappings in KVM so that there's no VMM alias. After
that we need to choose between (2) and (3) since the VMM may no longer
be able to probe the device and figure out which ranges need what
attributes.

> If we add more behind-the-scenes tricks to get other MMIO mappings
> working in the future then this whole interaction will get even
> hairier. At least if we follow the stage-1 attributes (where possible)
> then we can document some sort of expected behavior in KVM. The VMM would
> need know if the device has read side-effects, as the only way to get a
> Normal-NC mapping in the guest would be to have one at stage-1.

I don't think KVM or the VMM should attempt to hand-hold the guest and
ensure that it maps an MMIO with read side-effects appropriately. The
guest driver can do this by itself or get incorrect hw behaviour. Such
hand-holding is only needed if the speculative loads have wider system
implications but we concluded that it's not the case for PCIe. Even with
a Device mapping, the guest can always issue random reads from an
assigned MMIO range and cause side-effects.

> Kinda stinks to make the VMM aware of the device, but IMO it is a
> fundamental limitation of the way we back memslots right now.

As I mentioned above, the limitation may be more complex if the
intra-BAR attributes are not something readily available in the device
documentation. Maybe Jason or Ankit can shed some light here: are those
intra-BAR ranges configurable by the (guest) driver or they are already
pre-configured by firmware and the driver only needs to probe them?

Anyway, about to go on the Christmas break, so most likely I'll follow
up in January. Happy holidays!

-- 
Catalin

