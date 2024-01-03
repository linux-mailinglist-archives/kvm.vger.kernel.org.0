Return-Path: <kvm+bounces-5529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6728C822E73
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 14:34:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05C5B1F242E7
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 13:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D3A1A70D;
	Wed,  3 Jan 2024 13:33:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49011A5B5;
	Wed,  3 Jan 2024 13:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E489CC433C8;
	Wed,  3 Jan 2024 13:33:17 +0000 (UTC)
Date: Wed, 3 Jan 2024 13:33:15 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>, ankita@nvidia.com,
	maz@kernel.org, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org, alex.williamson@redhat.com, kevin.tian@intel.com,
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
Message-ID: <ZZViG0Vu0EDMEuGD@arm.com>
References: <20231208164709.23101-1-ankita@nvidia.com>
 <20231208164709.23101-3-ankita@nvidia.com>
 <ZXicemDzXm8NShs1@arm.com>
 <20231212181156.GO3014157@nvidia.com>
 <ZXoOieQN7rBiLL4A@linux.dev>
 <ZXsjv+svp44YjMmh@lpieralisi>
 <ZXszoQ48pZ7FnQNV@linux.dev>
 <ZYQ7VjApH1v1QwTW@arm.com>
 <20240102170908.GG50406@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240102170908.GG50406@nvidia.com>

On Tue, Jan 02, 2024 at 01:09:08PM -0400, Jason Gunthorpe wrote:
> On Thu, Dec 21, 2023 at 01:19:18PM +0000, Catalin Marinas wrote:
> > If we really want to avoid any aliases (though I think we are spending
> > too many cycles on something that's not a real issue), the only way is
> > to have fd-based mappings in KVM so that there's no VMM alias. After
> > that we need to choose between (2) and (3) since the VMM may no longer
> > be able to probe the device and figure out which ranges need what
> > attributes.
> 
> If we use a FD then KVM will be invoking some API on the FD to get the
> physical memory addreses and we can have that API also return
> information on the allowed memory types.

I think the part with a VFIO WC flag wouldn't be any different. The
fd-based mapping only solves the mismatched alias, otherwise the
decision for Normal NC vs Device still lies with the guest driver.

> > > Kinda stinks to make the VMM aware of the device, but IMO it is a
> > > fundamental limitation of the way we back memslots right now.
> > 
> > As I mentioned above, the limitation may be more complex if the
> > intra-BAR attributes are not something readily available in the device
> > documentation. Maybe Jason or Ankit can shed some light here: are those
> > intra-BAR ranges configurable by the (guest) driver or they are already
> > pre-configured by firmware and the driver only needs to probe them?
> 
> Configured by the guest on the fly, on a page by page basis.
> 
> There is no way for the VMM to pre-predict what memory type the VM
> will need. The VM must be in control of this.

That's a key argument why the VMM cannot do this, unless we come up with
some para-virtualised interface and split the device configuration logic
between the VMM and the VM. I don't think that's feasible, too much
complexity.

-- 
Catalin

