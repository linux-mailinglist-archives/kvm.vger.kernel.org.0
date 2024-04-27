Return-Path: <kvm+bounces-16098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C1B8B4437
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 07:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 594441F232EF
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 05:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222D23DBB3;
	Sat, 27 Apr 2024 05:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t1Fx/saU"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7B33D984;
	Sat, 27 Apr 2024 05:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714194346; cv=none; b=MpK0DMQmiwAdXPSKaqcb+QGO/vB2C54MkteY1dygrFEQoCCufCJje8TlT7Ckp5Q9vigKqHA6y9lkykXWHnp5Ebkswu7vXJFAVB+npvSamajJjXCGTJbyyG7pn/1AyX3+1C9N3PwFj9ydYois6z+jUzwIzJNmCc2Wq0dUTxMgf80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714194346; c=relaxed/simple;
	bh=aV03/J5L6wRTVpqXzZpjogDL29eKpBpFKjBKzlh6DQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qpLktUfKBFNTSPXXVhxBTW/9UFlZUkj40HfpTEJ7ac9XsnM3QXkB3K9f+yTfF3Q/tsJykl/P2q2Ih92XdxSVp6tBIxNSfQssdZHZq70+t1CmM+DosV8WfSzeJkDwC5virM91JtdyXvS0/SBgCk2rw7BIDlANx8XT36YPmdmC2/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t1Fx/saU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yj0ibZWO6upsf0Ur4Wa4n3wfBYe9wyP854L58KpwsgQ=; b=t1Fx/saUGWRhzioT0ZIHnAbE+T
	RpbewQHZ8zke+qwBeFJwU4FBsp2FPOpaGAVu6BstX2gvaLMAz1FoufoEeHvPJLzm3Hr5C96ibKVeF
	HXPkdDAECCeRZlx9GHbIGJ2MukGGCjSKvGwWH8NG/q6xB9j92Eo/mH/UkH+P8hOlfB48e8eFoJkGH
	r48pSy4DFQMImmW7mVicxnq4InVDISnuJS3Qa/w9vAh/P2aIhtoJE0VAeIxzSRvEfRil1cb57B6Jr
	gTKDeOY584LGFUz5egNYjPWreUrN7YiYm1SKN5JshqdlqRe4v/Cg00I5d5aebaPjwAPxBQ7ZrGCYo
	WNunu5PA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s0aFk-0000000EqQf-2NHi;
	Sat, 27 Apr 2024 05:05:36 +0000
Date: Fri, 26 Apr 2024 22:05:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?iso-8859-1?Q?C=E9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <ZiyHoFGpHppLRW2e@infradead.org>
References: <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <20240424122437.24113510.alex.williamson@redhat.com>
 <20240424183626.GT941030@nvidia.com>
 <20240424141349.376bdbf9.alex.williamson@redhat.com>
 <20240426141117.GY941030@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240426141117.GY941030@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Apr 26, 2024 at 11:11:17AM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 24, 2024 at 02:13:49PM -0600, Alex Williamson wrote:
> 
> > This is kind of an absurd example to portray as a ubiquitous problem.
> > Typically the config space layout is a reflection of hardware whether
> > the device supports migration or not.
> 
> Er, all our HW has FW constructed config space. It changes with FW
> upgrades. We change it during the life of the product. This has to be
> considered..

FYI, the same is true for just about any storage device I know.  Maybe
not all of the config space, but definitely parts of it.


