Return-Path: <kvm+bounces-63720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C06B7C6F325
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 15:17:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E39EE50415C
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 13:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02B636402E;
	Wed, 19 Nov 2025 13:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOc+pw0S"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B823557FE;
	Wed, 19 Nov 2025 13:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763560453; cv=none; b=QzOdF5G13VqBmY4vjnUNid+aid26TsvEEkBNmECtPMqy3NqN6mPaz+rh0aE4/7p4b5TKGd0p8Ocw+9JGr1UpzUTmpEC1r1KG2jCbctyjNyKVVGfqs1Lh1sLX6OypoixUE1kXoIvk6/1sBeZIy/fBXiDOjZDtmhXWm/XEhFvKMEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763560453; c=relaxed/simple;
	bh=khDyF27Ua+YvAG563h+Mn5TVNwmjUpzwzSeY1s3ZrlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dHJGOzqvLrVDp5HA4s0CqGek0EQ7BvH6BbDejjkyTHgk5QxbmXDzDu3BKji5dLODdEHDlS5IRYWnQkNhwyx5xSD/yooWtvFMBi5ps3agUomSZIHSf/4yDUh95NQPvLKijjQFyDe5xQHnJpZBFKtqG0ayLVEwH5t60EkTJY+KMVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOc+pw0S; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4089C2BCB6;
	Wed, 19 Nov 2025 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763560452;
	bh=khDyF27Ua+YvAG563h+Mn5TVNwmjUpzwzSeY1s3ZrlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lOc+pw0SropUFqAbVYzMoWEHW1jJDTrt97jUDXz56yN0le/B+KOyXK6xnERbWqNdy
	 LBjMT4gf6zJ5xLQ64pQkqww1I8qSD+7y/IDRApuyDvzXjq9BFKkEOeCi8bxA/oo1gH
	 70+OJhKd6XWXCZEn57dkcHhMJy+/OipA/ho8GrlgsWfIHeiMPKdy6djUHim0G3aLYZ
	 Smu4HN5s73AeSqAjTtbTpkSpzB4YO7/XVcv9jfbhTGeKtpPOUqXybhXbJn04qeXgZf
	 DJ8SJ2zHpC/cN0o1khK2H92TSVtXxhG0/mnVCa20BOeZHJlnQ/YkrpnwOm6k6yFofi
	 vqwHi5UdKLC/g==
Date: Wed, 19 Nov 2025 15:54:07 +0200
From: Leon Romanovsky <leon@kernel.org>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Keith Busch <kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Alex Mastro <amastro@fb.com>, Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v8 09/11] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Message-ID: <20251119135407.GG18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-9-fd9aa5df478f@nvidia.com>
 <BN9PR11MB52767F78317AF3AB94A5B7D38CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRzUpmUkDy-qN5c1@kbusch-mbp>
 <BN9PR11MB52768D54FF42AB11C49202C98CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52768D54FF42AB11C49202C98CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>

On Wed, Nov 19, 2025 at 12:02:02AM +0000, Tian, Kevin wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > Sent: Wednesday, November 19, 2025 4:19 AM
> > 
> > On Tue, Nov 18, 2025 at 07:18:36AM +0000, Tian, Kevin wrote:
> > > > From: Leon Romanovsky <leon@kernel.org>
> > > > Sent: Tuesday, November 11, 2025 5:58 PM
> > > >
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > not required with only your own s-o-b
> > 
> > That's automatically appended when the sender and signer don't match.
> > It's not uncommon for developers to send from a kernel.org email but
> > sign off with a corporate account, or the other way around.
> 
> Good to know.

Yes, in addition, I used to separate between code authorship and my
open-source activity. Code belongs to my employer and this is why corporate
address is used as an author, but all emails and communications are coming from
my kernel.org account.

Thanks

