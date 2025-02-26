Return-Path: <kvm+bounces-39309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7BFA468BA
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:59:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 055223A173B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 17:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512A222A7E0;
	Wed, 26 Feb 2025 17:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lXuwToHr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C02D2A8C1;
	Wed, 26 Feb 2025 17:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740592788; cv=none; b=fUXHEZvKjcK6mpF0m3XE75Go+I5QMaECfDZiEFsoHAUeQCuKsg/PJOoEpKgLHbt5GHNgwOWC+nBf2fdrDNUrpqgT7+P52KAtxgMd2fUSt10QaNCC390tvUEt9De0wzAJc2gppSS+RVVHu/ywxcpXrQt4mx3ELkghBDix/eHzir8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740592788; c=relaxed/simple;
	bh=FAao1ArBUjOSbdvK4PI/C2hB0X0+HSnv2BqKHijQvUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mRpW+kGdOD0dAkeao8pHsuCjAxDf28xO7fGQCHV5meuHbbE4xB08AJAsaOGYzxogjx3PF1GhGXYGyyfPjbFED90Acre6I/5F1J12c320nDC/Tsy4gJ2UMbnIaoxFnwx5ACF6DMrs9T9pe7fEbe89dYjmzef3y9kjtQH5JkKHHRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lXuwToHr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4D2C4CED6;
	Wed, 26 Feb 2025 17:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740592787;
	bh=FAao1ArBUjOSbdvK4PI/C2hB0X0+HSnv2BqKHijQvUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lXuwToHrVpustm5dMKnZy6IHuCei7nxBQxh4Do5n6sbZhL0ILxcycGb0e6rbASQyJ
	 LTKfuQBmeO0XPQbFJImzPOtJpPU/ugMFosDfNlEo/CvSXOz2+Qhu7E9vGMt56ZqCSX
	 s5WN6OVik4AwjnJpA1IbPd2rKHb4lD0SelvCMzRQUukQ+G0pLKaezRNL6Mo83iyYg1
	 d7GPML3+56SpbfdjR17O92bFhm2qU43vpCi+LO83FmiWCYtniF6AVvRY8veN79vWvy
	 QKHWp7GRMcFo+N16kxPqRZIU5uOku0shBij4WlAkuC/EhkiYPJG655s8Anbzzmg7+R
	 7aPPW6A9Ov1+A==
Date: Wed, 26 Feb 2025 19:59:43 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Kasireddy, Vivek" <vivek.kasireddy@intel.com>,
	Wei Lin Guay <wguay@meta.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	Dag Moxnes <dagmoxnes@meta.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	Nicolaas Viljoen <nviljoen@meta.com>,
	Oded Gabbay <ogabbay@kernel.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Maor Gottlieb <maorg@nvidia.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 0/4] cover-letter: Allow MMIO regions to be exported
 through dmabuf
Message-ID: <20250226175943.GL53094@unreal>
References: <20241216095920.237117-1-wguay@fb.com>
 <IA0PR11MB7185FDD56CFDD0A2B8D21468F83B2@IA0PR11MB7185.namprd11.prod.outlook.com>
 <924671F4-E8B5-4007-BE5D-29ED58B95F46@meta.com>
 <IA0PR11MB71858B2E59D3A9F58CEE83DCF8052@IA0PR11MB7185.namprd11.prod.outlook.com>
 <61DF4F0E-D947-436B-9160-A40079DB9085@meta.com>
 <IA0PR11MB7185E7DBB9E959A2F40D4170F8C22@IA0PR11MB7185.namprd11.prod.outlook.com>
 <20250226133822.GA28425@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226133822.GA28425@nvidia.com>

On Wed, Feb 26, 2025 at 09:38:22AM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 26, 2025 at 07:55:07AM +0000, Kasireddy, Vivek wrote:
> 
> > > Is there any update or ETA for the v3? Are there any ways we can help?
> 
> > I believe Leon's series is very close to getting merged. Once it
> > lands, this series can be revived.
> 
> The recent drama has made what happens next unclear.
> 
> I would like it if interested parties could contribute reviews to
> Leon's v7 series to help it along.

Link to v7 https://lore.kernel.org/all/cover.1738765879.git.leonro@nvidia.com/

Thanks

