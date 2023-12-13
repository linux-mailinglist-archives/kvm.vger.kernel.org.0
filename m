Return-Path: <kvm+bounces-4390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C6686811FA9
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 21:05:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DB5BB211F7
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 20:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1D07E548;
	Wed, 13 Dec 2023 20:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jJcnDy5b"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [IPv6:2001:41d0:203:375::ba])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9268DDB
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 12:05:38 -0800 (PST)
Date: Wed, 13 Dec 2023 20:05:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702497936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bs3RmWkkBEnHpfKuSLQmU1XdcllYwTl+oGw2E3qh8dc=;
	b=jJcnDy5bHbUQZ++rOn61pjWjrjxub6x7tQGxN6Q/n2e8x8QqbvQBN0WMjqMDzS9KbV0iYs
	wCgSpmwEUbVv6YEq3zCdtU1qGuTE6IwHyJzcoTRQw4SP/Qsfm9Sz/cIkb2d4mN4aAQUtts
	tgUEit1z6/gIrWV69f2FgtcachFAZYI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, ankita@nvidia.com,
	maz@kernel.org, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org, alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	gshan@redhat.com, linux-mm@kvack.org, lpieralisi@kernel.org,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	mochs@nvidia.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/2] kvm: arm64: set io memory s2 pte as normalnc for
 vfio pci devices
Message-ID: <ZXoOieQN7rBiLL4A@linux.dev>
References: <20231208164709.23101-1-ankita@nvidia.com>
 <20231208164709.23101-3-ankita@nvidia.com>
 <ZXicemDzXm8NShs1@arm.com>
 <20231212181156.GO3014157@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212181156.GO3014157@nvidia.com>
X-Migadu-Flow: FLOW_OUT

Hi,

Sorry, a bit late to the discussion :)

On Tue, Dec 12, 2023 at 02:11:56PM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 12, 2023 at 05:46:34PM +0000, Catalin Marinas wrote:
> > should know the implications. There's also an expectation that the
> > actual driver (KVM guests) or maybe later DPDK can choose the safe
> > non-cacheable or write-combine (Linux terminology) attributes for the
> > BAR.
> 
> DPDK won't rely on this interface

Wait, so what's the expected interface for determining the memory
attributes at stage-1? I'm somewhat concerned that we're conflating two
things here:

 1) KVM needs to know the memory attributes to use at stage-2, which
    isn't fundamentally different from what's needed for userspace
    stage-1 mappings.

 2) KVM additionally needs a hint that the device / VFIO can handle
    mismatched aliases w/o the machine exploding. This goes beyond
    supporting Normal-NC mappings at stage-2 and is really a bug
    with our current scheme (nGnRnE at stage-1, nGnRE at stage-2).

I was hoping that (1) could be some 'common' plumbing for both userspace
and KVM mappings. And for (2), any case where a device is intolerant of
mismatches && KVM cannot force the memory attributes should be rejected.

AFAICT, the only reason PCI devices can get the blanket treatment of
Normal-NC at stage-2 is because userspace has a Device-* mapping and can't
speculatively load from the alias. This feels a bit hacky, and maybe we
should prioritize an interface for mapping a device into a VM w/o a
valid userspace mapping.

I very much understand that this has been going on for a while, and we
need to do *something* to get passthrough working well for devices that
like 'WC'. I just want to make sure we don't paint ourselves into a corner
that's hard to get out of in the future.

-- 
Thanks,
Oliver

