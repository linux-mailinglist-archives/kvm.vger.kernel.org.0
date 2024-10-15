Return-Path: <kvm+bounces-28837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E3DA699DD05
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 05:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9735D1F22EBD
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 03:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A80F616B38B;
	Tue, 15 Oct 2024 03:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ff8ZAKBM"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B562412FF69
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 03:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728964196; cv=none; b=tc8wEGQ1cgmb3rl+ricrwmOaG4y2JknREbfS4Ma5Ja/tWSBNP1LhL+C+9a8fFNPH1CR8UOSUduI1ZHznC8uHR4q4xChuAdGBefi/MiOn/JTt4hEgWgx2dlxuoQjE3iJXgZiZwOlNdWX+QHRLltlznlIzhrSkcRywuAVUdCerBFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728964196; c=relaxed/simple;
	bh=46ZJVVDEh9STcXtcF0jzDhCc8/Jc2VbuXNe2cTlrfvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tzNPGJz9VpVNFGblKPewvbYKQG/lBxIKR8ktPsMZODZjpDpxYl6BCcrKBWVI5crcylA6a2TnTcecca7J9qmeTQlUJ18VsKUbhxND8OpxPDk+dMFbdtn9pgPOOXKGr5tzyItuRo+gcaQpdY4sRnLwe5NJWw5qJpzjziyUAh3iGjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ff8ZAKBM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WMrPAuZiquJTe8IjR47E8lscXQVdMQ4TT6Vykiu/a5o=; b=Ff8ZAKBMgb+DzV+uiJJSofO4Y4
	nTnBFhkkaywo9jYDkgCsZ3PvHziBcT+G32vAYV7376CoiEY01HbjAB1hhhojC+PIs2hk7fAij0HZR
	PRzkSElZqjWV+28+8TQ9B/XS6cm5tF5lPZ3qSX8uTQuEEV0ASUtKO0X758fckIcXzUWDgeTJ+VR+N
	wY+rkYnK1MiNpaBovFO4Nji9n51ykpFbabpcJuSGcur572SOLo8IlEZZSqQcUlt3cVYEPQATY8a5j
	Q6jM5ZwDd6VKzIVeCNx3GJWPpUJBBKXbsk0thoS1W6gxOWTzTyzK4eP7aLHC8gWbrIh3CGsP0abiu
	dI3iguCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0YZG-000000070jz-3KEd;
	Tue, 15 Oct 2024 03:49:54 +0000
Date: Mon, 14 Oct 2024 20:49:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zhi Wang <zhiw@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"airlied@gmail.com" <airlied@gmail.com>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>,
	Andy Currid <ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Surath Mitra <smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>,
	Aniket Agashe <aniketa@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 06/29] nvkm/vgpu: set RMSetSriovMode when NVIDIA vGPU is
 enabled
Message-ID: <Zw3mYtej2fAp4-Ei@infradead.org>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-7-zhiw@nvidia.com>
 <20240926225343.GV9417@nvidia.com>
 <bc19bc8f-1692-49f5-9286-d4442714776e@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc19bc8f-1692-49f5-9286-d4442714776e@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 14, 2024 at 07:38:03AM +0000, Zhi Wang wrote:
> As what has been explained in PATCH 4's reply, the concept of vGPU and 
> VF are not identically equal. PCI SRIOV VF is the HW interface of 
> reaching a vGPU and there were generations in which HW didn't have SRIOV 
> VFs and a vGPU is reached via other means.

What does "were" mean.  Are they supported by this driver?  If so how.
If not that's entirely irrelevant.

