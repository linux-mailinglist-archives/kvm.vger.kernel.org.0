Return-Path: <kvm+bounces-40042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FFE2A4E1FF
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 15:58:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C157F7A8A7F
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 14:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3FF025DCE6;
	Tue,  4 Mar 2025 14:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="trU6zHvY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62D6156C76;
	Tue,  4 Mar 2025 14:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741100073; cv=none; b=jAMU6ziyzwTagEvtzqVjJsUmUl6F4ygoPad3md3Ceq9ki6HuxZAlbcMlSbBaN2nnqg8X7i05Qp0S8bbERAu4jOjs6F2DDP4iLwhFXgEsCKiGUqJueqEzW2Nkt1MkcAdZjyHiNP34B39hHm1mXJnllSgGa8Mqmr5ckOePaUB9qFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741100073; c=relaxed/simple;
	bh=6QVcC4GPVMSItVqHqjY2/nKc5H0HnVp+/D7NkRyhohw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D9iI17YMwj4MLx0+ZT72l7zuo8u/Q8ekhXXqDz0A3aKzvrO3ftYSOX24WB/ba94Lm9OWXDZ1JvrRyxylSqkm61qfAt86VOWWT8Uly8qhrvsCUzljnWDHmUV65+pk5mnON3I4ycP1Due02N2q6m6fZf4dTSL5BsNholltZBjfCSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=trU6zHvY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793E0C4CEE7;
	Tue,  4 Mar 2025 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741100073;
	bh=6QVcC4GPVMSItVqHqjY2/nKc5H0HnVp+/D7NkRyhohw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=trU6zHvYUjZCBj8Ced0tD9DPJmg6FubXk0qnSnB3Kr0MtE0OzU47Sami3rZ+q1eL7
	 JJhqUbpYYPYAw5GMGVuGX8/z9p9S5okXMhsgtdVK4wxFBLWdQ6Pyg+gMziT00LPfRW
	 MB6DCpDlfQlpjhNa9JFOUA7XotD78kijgsNnNp+bEvqwfOFPPZuRlA+mLWOjbK0xrd
	 pXLatuDsXiVGd2vLHKpi3xL4Ea4UnmHaeasSnHHD8kMeXb0+QFK0BpdH4T1/fyEKUQ
	 bznCslahq2nqmlMavlh2prD6+UjZIQ3udYGsCtYQsMldhZ5sOrHi6cnLZGycFEBs0y
	 0k8wbdsqtT1jA==
Date: Tue, 4 Mar 2025 16:54:28 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	"Kasireddy, Vivek" <vivek.kasireddy@intel.com>,
	Wei Lin Guay <wguay@meta.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	Dag Moxnes <dagmoxnes@meta.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	Nicolaas Viljoen <nviljoen@meta.com>,
	Oded Gabbay <ogabbay@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Maor Gottlieb <maorg@nvidia.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 0/4] cover-letter: Allow MMIO regions to be exported
 through dmabuf
Message-ID: <20250304145428.GH1955273@unreal>
References: <20241216095920.237117-1-wguay@fb.com>
 <IA0PR11MB7185FDD56CFDD0A2B8D21468F83B2@IA0PR11MB7185.namprd11.prod.outlook.com>
 <924671F4-E8B5-4007-BE5D-29ED58B95F46@meta.com>
 <IA0PR11MB71858B2E59D3A9F58CEE83DCF8052@IA0PR11MB7185.namprd11.prod.outlook.com>
 <61DF4F0E-D947-436B-9160-A40079DB9085@meta.com>
 <IA0PR11MB7185E7DBB9E959A2F40D4170F8C22@IA0PR11MB7185.namprd11.prod.outlook.com>
 <20250226133822.GA28425@nvidia.com>
 <0d471fca-b64c-4392-88ee-d26dbfe3cf2d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d471fca-b64c-4392-88ee-d26dbfe3cf2d@amd.com>

On Tue, Mar 04, 2025 at 03:29:42PM +0100, Christian König wrote:
> Am 26.02.25 um 14:38 schrieb Jason Gunthorpe:
> > On Wed, Feb 26, 2025 at 07:55:07AM +0000, Kasireddy, Vivek wrote:
> >
> >>> Is there any update or ETA for the v3? Are there any ways we can help?
> >> I believe Leon's series is very close to getting merged. Once it
> >> lands, this series can be revived.
> > The recent drama has made what happens next unclear.
> >
> > I would like it if interested parties could contribute reviews to
> > Leon's v7 series to help it along.
> 
> I think demonstrating how any new interface would work with the existing importers/exporters would help.

Unfortunately, it is huge waste of time given current situation where
even basic building blocks are not merged yet [1].

We do see clear path to fix dmabuf, see this roadmap [2].

[1] https://lore.kernel.org/all/20250302085717.GO53094@unreal/
[2] https://lore.kernel.org/linux-rdma/20250122071600.GC10702@unreal/T/#u

Thanks

