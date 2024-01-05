Return-Path: <kvm+bounces-5749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89ABF825BDE
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 21:44:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37A14283F48
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 20:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D15136AE7;
	Fri,  5 Jan 2024 20:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XqyiIYzj"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54770364DE
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 20:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Jan 2024 20:42:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704487358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YIgLwiupop3bcxFtQ1AH4pX9ofQaPh7Mzpc0S80SOXs=;
	b=XqyiIYzjEWK+lm3UJXl+Vepjb6r75wBWBi9XIOu99PHz4UoyFsf5hyJcpiTvig2PFZqfAa
	S8QYTaVvSX4WXvUncN3E9CeUPUh98X6eDHybtqCe7gwZPwEYwS8ILIbBFbc0Oq3mJLVPqB
	H5ExmHtEKBIoIc+f2+qjmPXgY/QWakI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>
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
Message-ID: <ZZhpt8vdlnOP7i82@linux.dev>
References: <20231208164709.23101-1-ankita@nvidia.com>
 <20231208164709.23101-3-ankita@nvidia.com>
 <ZXicemDzXm8NShs1@arm.com>
 <20231212181156.GO3014157@nvidia.com>
 <ZXoOieQN7rBiLL4A@linux.dev>
 <ZXsjv+svp44YjMmh@lpieralisi>
 <ZXszoQ48pZ7FnQNV@linux.dev>
 <ZYQ7VjApH1v1QwTW@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZYQ7VjApH1v1QwTW@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 21, 2023 at 01:19:18PM +0000, Catalin Marinas wrote:

[...]

> > Apologies, I didn't mean to question what's going on here from the
> > hardware POV. My concern was more from the kernel + user interfaces POV,
> > this all seems to work (specifically for PCI) by maintaining an
> > intentional mismatch between the VFIO stage-1 and KVM stage-2 mappings.
> 
> If you stare at it long enough, the mismatch starts to look fine ;).
> Even if you have the VFIO stage 1 Normal NC, KVM stage 2 Normal NC, you
> can still have the guest setting stage 1 to Device and introduce an
> architectural mismatch. These aliases have some bad reputation but the
> behaviour is constrained architecturally.
> 
> IMHO we should move on from this attribute mismatch since we can't fully
> solve it anyway and focus instead on what the device, system can
> tolerate, who's responsible for deciding which MMIO ranges can be mapped
> as Normal NC.

Fair enough :) The other slightly unsavory part is that we're baking
the mapping policy into KVM. I'd prefer it if this policy were kept in
userspace somehow, but there's no actual usecase for userspace selecting
memory attributes at this point.

> If we really want to avoid any aliases (though I think we are spending
> too many cycles on something that's not a real issue), the only way is
> to have fd-based mappings in KVM so that there's no VMM alias. After
> that we need to choose between (2) and (3) since the VMM may no longer
> be able to probe the device and figure out which ranges need what
> attributes.

These are the sorts of things I was more worried about. I completely
agree that the patches are fine for relaxing the 'simple' PCIe use
cases, I just don't want to establish the precedent that the kernel/KVM
will be on the hook to work out more complex use cases that may require
the composition of various mappings.

But I'm happy to table that discussion until the usecase arises :)

-- 
Thanks,
Oliver

