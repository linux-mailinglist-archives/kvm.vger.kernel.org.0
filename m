Return-Path: <kvm+bounces-3715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 10FD9807504
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:32:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5EF8B20ECA
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1420E47786;
	Wed,  6 Dec 2023 16:31:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7049F45975;
	Wed,  6 Dec 2023 16:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942DDC433CC;
	Wed,  6 Dec 2023 16:31:50 +0000 (UTC)
Date: Wed, 6 Dec 2023 16:31:48 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, lpieralisi@kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZXCh9N2xp0efHcpE@arm.com>
References: <20231205130517.GD2692119@nvidia.com>
 <ZW9OSe8Z9gAmM7My@arm.com>
 <20231205164318.GG2692119@nvidia.com>
 <86bkb4bn2v.wl-maz@kernel.org>
 <ZW9ezSGSDIvv5MsQ@arm.com>
 <86a5qobkt8.wl-maz@kernel.org>
 <ZW9uqu7yOtyZfmvC@arm.com>
 <868r67blwo.wl-maz@kernel.org>
 <ZXBlmt88dKmZLCU9@arm.com>
 <20231206151603.GR2692119@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206151603.GR2692119@nvidia.com>

On Wed, Dec 06, 2023 at 11:16:03AM -0400, Jason Gunthorpe wrote:
> On Wed, Dec 06, 2023 at 12:14:18PM +0000, Catalin Marinas wrote:
> > We could do with a pgprot_maybewritecombine() or
> > pgprot_writecombinenospec() (similar to Jason's idea but without
> > changing the semantics of pgprot_device()). For the user mapping on
> > arm64 this would be Device (even _GRE) since it can't disable
> > speculation but stage 2 would leave the decision to the guest since the
> > speculative loads aren't much different from committed loads done
> > wrongly.
> 
> This would be fine, as would a VMA flag. Please pick one :)
> 
> I think a VMA flag is simpler than messing with pgprot.

I guess one could write a patch and see how it goes ;).

> > If we want the VMM to drive this entirely, we could add a new mmap()
> > flag like MAP_WRITECOMBINE or PROT_WRITECOMBINE. They do feel a bit
> 
> As in the other thread, we cannot unconditionally map NORMAL_NC into
> the VMM.

I'm not suggesting this but rather the VMM map portions of the BAR with
either Device or Normal-NC, concatenate them (MAP_FIXED) and pass this
range as a memory slot (or multiple if a slot doesn't allow multiple
vmas).

> > The latter has some benefits for DPDK but it's a lot more involved
> > with
> 
> DPDK WC support will be solved with some VFIO-only change if anyone
> ever cares to make it, if that is what you mean.

Yeah. Some arguments I've heard in private and public discussions is
that the KVM device pass-through shouldn't be different from the DPDK
case. So fixing that would cover KVM as well, though we'd need
additional logic in the VMM. BenH had a short talk at Plumbers around
this - https://youtu.be/QLvN3KXCn0k?t=7010. There was some statement in
there that for x86, the guests are allowed to do WC without other KVM
restrictions (not sure whether that's the case, not familiar with it).

> > having to add device-specific knowledge into the VMM. The VMM would also
> > have to present the whole BAR contiguously to the guest even if there
> > are different mapping attributes within the range. So a lot of MAP_FIXED
> > uses. I'd rather leaving this decision with the guest than the VMM, it
> > looks like more hassle to create those mappings. The VMM or the VFIO
> > could only state write-combine and speculation allowed.
> 
> We talked about this already, the guest must decide, the VMM doesn't
> have the information to pre-predict which pages the guest will want to
> use WC on.

Are the Device/Normal offsets within a BAR fixed, documented in e.g. the
spec or this is something configurable via some MMIO that the guest
does.

-- 
Catalin

