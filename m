Return-Path: <kvm+bounces-30463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF969BAEC3
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 980E71F21E30
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C34601AE01C;
	Mon,  4 Nov 2024 08:56:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5991AC8AE;
	Mon,  4 Nov 2024 08:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730710608; cv=none; b=YSyCAsovwqtiVCziJHWAtUtmQNZoIuU8pBZea+GyC/YhJJQmq9woMVM9i/w/Nqh+vmFwv7T9Ud696YIdndU6XRZICUzcOGrYBIzFWCtv9DqonaDvWcMGfjihXpMIBukOIp/IP0yOPTHYawlEfzvJD+miC+7BOr/6smgm3mFPq14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730710608; c=relaxed/simple;
	bh=Cd7w1aJWj9RaW8qRI2u0FHF8/JEncSVlg+8XB/AbH78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shifGVCckSB2J28Ey9XntaLl6k9pehyg5u1iH/fv3D6mWG7sQYn5S/iktUWDop9MXGmeeiEajPxsge6nJp+0YZBhwin815ar6jqHiOw5t3/59Gvp08hffd7S1GEYLFNlC7W96A2UcMXS7cVns2UEevSshPDLHv4yE1QuCAsJ1oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 13FD4227AB3; Mon,  4 Nov 2024 09:56:43 +0100 (CET)
Date: Mon, 4 Nov 2024 09:56:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/7] block: don't merge different kinds of P2P
 transfers in a single bio
Message-ID: <20241104085642.GC24211@lst.de>
References: <cover.1730037261.git.leon@kernel.org> <34d44537a65aba6ede215a8ad882aeee028b423a.1730037261.git.leon@kernel.org> <f80e7b54-b897-4df2-a49d-bc6012640a8a@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f80e7b54-b897-4df2-a49d-bc6012640a8a@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Nov 02, 2024 at 08:39:35AM +0100, Zhu Yanjun wrote

<full quote delete>

If you have something useful to say, please quote the mail you are
replying to to the context required to make sense.

Ignored for now.

