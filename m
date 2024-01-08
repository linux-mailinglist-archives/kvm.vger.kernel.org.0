Return-Path: <kvm+bounces-5798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FA25826C0D
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 12:05:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 755E71C22249
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 11:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 615F414277;
	Mon,  8 Jan 2024 11:04:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA691401A;
	Mon,  8 Jan 2024 11:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6B7C433C7;
	Mon,  8 Jan 2024 11:04:49 +0000 (UTC)
Date: Mon, 8 Jan 2024 11:04:47 +0000
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
Message-ID: <ZZvWzyNb1V29-H85@arm.com>
References: <20231208164709.23101-1-ankita@nvidia.com>
 <20231208164709.23101-3-ankita@nvidia.com>
 <ZXicemDzXm8NShs1@arm.com>
 <20231212181156.GO3014157@nvidia.com>
 <ZXoOieQN7rBiLL4A@linux.dev>
 <ZXsjv+svp44YjMmh@lpieralisi>
 <ZXszoQ48pZ7FnQNV@linux.dev>
 <ZYQ7VjApH1v1QwTW@arm.com>
 <ZZhpt8vdlnOP7i82@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZhpt8vdlnOP7i82@linux.dev>

On Fri, Jan 05, 2024 at 08:42:31PM +0000, Oliver Upton wrote:
> On Thu, Dec 21, 2023 at 01:19:18PM +0000, Catalin Marinas wrote:
> > > Apologies, I didn't mean to question what's going on here from the
> > > hardware POV. My concern was more from the kernel + user interfaces POV,
> > > this all seems to work (specifically for PCI) by maintaining an
> > > intentional mismatch between the VFIO stage-1 and KVM stage-2 mappings.
> > 
> > If you stare at it long enough, the mismatch starts to look fine ;).
> > Even if you have the VFIO stage 1 Normal NC, KVM stage 2 Normal NC, you
> > can still have the guest setting stage 1 to Device and introduce an
> > architectural mismatch. These aliases have some bad reputation but the
> > behaviour is constrained architecturally.
> > 
> > IMHO we should move on from this attribute mismatch since we can't fully
> > solve it anyway and focus instead on what the device, system can
> > tolerate, who's responsible for deciding which MMIO ranges can be mapped
> > as Normal NC.
> 
> Fair enough :) The other slightly unsavory part is that we're baking
> the mapping policy into KVM. I'd prefer it if this policy were kept in
> userspace somehow, but there's no actual usecase for userspace selecting
> memory attributes at this point.

If by policy you mean who's deciding the write-combining relaxation,
this series moved it to the vfio-pci host driver. KVM only picks the
appropriate memory type for stage 2 based on the vma flags. That's
Normal NC in the absence of anything better on arm64 and it does more
than just write-combining but we can describe what this new VM_* flag
allows.

If we want to keep this decision strictly in user space, we can do it
with some ioctl(). The downside is that the host kernel now puts more
trust in the user VMM, so my preference would be to keep this in the
vfio driver. Or we can do both, vfio-pci allows the relaxation, the VMM
tells KVM to go for a more relaxed stage 2 via an ioctl().

-- 
Catalin

