Return-Path: <kvm+bounces-60807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB8E6BFA7B8
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 09:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBBB23B7CF5
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 07:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C14D2F531F;
	Wed, 22 Oct 2025 07:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VVVhrgk9"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13153594F;
	Wed, 22 Oct 2025 07:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761117124; cv=none; b=YBC0gfPMpgUoZoq4cBC8FYK/QnJW6o/0+QapjxInypUqWzL3B8HolhMrU0SGAmTZ1buRQkfzrc4rWGxPjxwVYADl8O8/wdUbntgBmWkwAorRyPKZtOegCDBHNz283IHRKl8nvHwI2D8dheaU4eH/pfgJojc3XgeEnKsFzJh/BgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761117124; c=relaxed/simple;
	bh=PGWypk/Ib9PELWvb1gHpl/x9gPfrBL9v0wo8RL9QRjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QhGXNUSpuHIpIY7LqCrcHGmaz/qQKBGs+CmbveEievyu2KVOnryjRNHV5Qisoub7xpZ2Iyn+iQGP9voblOTT7x4vvSAaXqddtbB3nxqcRa+KAFKk0bhYWTRoKvh3IHpaBCSjm33eswry0FqbCndt2B8BLI/RHDWjvp9zKvCUDD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VVVhrgk9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=woGYKU0fhDHlWGrEhCb0BMjPqCEf4r2LEen6eiYVH84=; b=VVVhrgk9hNUn21m1hiz7lbBuWA
	MansmTq4UMuIT1Zf1WbZiNJh+Du4uinvv1ec2hE8njqBAJdE55EDqXLj24iKTALEgZaU045dxuhhN
	05usKMhlfFTyMeVa3H2E/q23GPLoIiF5KRlcJjbFWEE+wrycbVEBZnJ1byJUQFfbKezeY1fCdsSBI
	P+n1phj70znd1yndi6JHLoRNGzEGjydBgB7jvlHCm4Ycp/YuFYPRhphGyy8l7jXHj8J1PvfIuHZnz
	K1Hy73en/3GcJeRIG8e67BO/HBw2Km5FKi8nSRfdm+UR2pDON2nshZ1GTU2VWVmyRcOVV5HE67yfa
	wY8Sj8pQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBT0r-00000001ouG-0hr8;
	Wed, 22 Oct 2025 07:12:01 +0000
Date: Wed, 22 Oct 2025 00:12:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>, intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	dri-devel@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukasz Laguna <lukasz.laguna@intel.com>
Subject: Re: [PATCH v2 26/26] vfio/xe: Add vendor-specific vfio_pci driver
 for Intel graphics
Message-ID: <aPiDwUn-D2_oyx2T@infradead.org>
References: <20251021224133.577765-1-michal.winiarski@intel.com>
 <20251021224133.577765-27-michal.winiarski@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021224133.577765-27-michal.winiarski@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There is absolutely nothing vendor-specific here, it is a device variant
driver.  In fact in Linux basically nothing is ever vendor specific,
because vendor is not a concept that does matter in any practical sense
except for tiny details like the vendor ID as one of the IDs to match
on in device probing.

I have no idea why people keep trying to inject this term again and
again.


