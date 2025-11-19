Return-Path: <kvm+bounces-63748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D857C70DB1
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 20:41:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 97B5828B7A
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 19:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F770371DC4;
	Wed, 19 Nov 2025 19:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="bPc6S0sG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4E736A030
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 19:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763581287; cv=none; b=KNqJkgiLHfTI1n2nUhCeDuGlOmsjhqdkIPGjKY1LiLifaQrl4meR2ORKbfZUDR8JMSqsU1tzyhRkuvpJkzXvAm5tpi0BIBRecGMMN47BgNgsiqD4LbtK28G4bUlRHr6NKD399/Beqdwaoc9s6DAK8MOOtSDeKif1CyjpHOOAN6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763581287; c=relaxed/simple;
	bh=McLj5MkyXM/EMQB5rQ6xp2qJjBV3WgZDPtIMlF++SQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BdvJuldyguOB+O+upIsiW5ZqJB5l38J0iYSNnU7BkpUZYXIN2wp6TnJkzYj2TNmRNR3wWTfRIt0dukbEfherDPyycQK07cXdk4HJganaDSV0303ojRj/PSE9Z0DKSwC0bDmc0OUcAhRbQJCBT8FDTVxQa+l0Wd+p1eH0ORsLvoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=bPc6S0sG; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-880503ab181so1063576d6.2
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 11:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763581282; x=1764186082; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1xvMcuBzJSIcfclCVWQ2hNnnKt+oezBHS+z89ygHsa4=;
        b=bPc6S0sGuHmGARD8ZnpZfpm34GFSkaMU4OFxV21xf8BCKqrDuDP5OSlnsvWhrOxRZX
         YRPZGnk4HlFvvfrXi4vurzIIFGZbdxPcBWTX8paU27knM2Uy0YyHUQaP/SbIe5tYs25M
         auLCKa71tmA4b9oRJB7tRbZCJ5gzfG5IYHiXSYTTvrXL0H7m47vcmEcSh1dC+tawQWXp
         YjgAR9cFyUPRlIPRLolCsiWYZyfCeOsDfnC5AVkjTKAOixK9O2mV1jUfpr7J66CPzf0b
         DyQjsItU8VvA+A+r0bVuLpQU8+5hX+La18EKV9zTuaWbH9eO0dxkCMXRfCZQsRcT1Z85
         Faog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763581282; x=1764186082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xvMcuBzJSIcfclCVWQ2hNnnKt+oezBHS+z89ygHsa4=;
        b=Ohvyyf3H2TFT7in7rHg701lQcUtOn5ldGv/pQ9mHW5IaujJwSz+JeTs3M0j7Vp2Sxe
         otVHTEjGGzF4CqHAiQvUaN31xfKiGgo5kZqcXdce7GQzUyG38erw/2nUVZwbV+Lgy/2v
         rMYkAynXcTl7xe6ONZH45u+Oqa/yfP6QVgSGOQoLzshC/kzU+5hzTnKFVF7B57r9FjrH
         l6Djl4cgNXBmhvs6ZMHlql8k+IYDQLttFkXM6x0OMjo4S2QiokPlacdakiN9JG9atAX5
         uE6u3r0T2v//BbFlzkitbY50bMOYoxwgb0CAW15b7llVA4k4S3cDGdYOWSxpIH+j2MMM
         r6og==
X-Forwarded-Encrypted: i=1; AJvYcCWpsjvobt3mmXQ7pm1Pc3PZsWqebfep1mwgbEKF3IQhIMUJeoQW07mhfWIWw2u9KSCZkNQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6VAYGmGkzR73VF19b4CWFUNmlYa7IPTIHTDLok7WjSxtviyro
	0xBAkWCTC/zclSYuj4AjQDjlhD6/wzkYC7i27pn2/XIAo7B6cjt6GsEeIe2Un+tVZ8E=
X-Gm-Gg: ASbGncuL/9ZERqwV50XKM1kC73BvKZaO3E1QIov9tIBf8Kg9zCQpe+hDv3HYo9i04yQ
	cnh78EyDMcMC1CjyavzvrhYFN97qFyNlB1JTukRVg83lG/ykDv23mnQrOoYfSvNHw0pGD0BbVAF
	L1VPtqZoICT3Y5BBDUBO5vRZnGn/sWSRAXL1xGGiWuW95srTU3x9dLaiIxb+QuV7qQxDhkBscqn
	ubkdk0dm2qMC/MfGkfxUP1tT4s9ySE1BK79duX5xPCRSkicdWjAgJu6FZED2bCugTecpQ8e+ayW
	cZoKKvefD51iMgV9I72E5GIOV48mTEYN2CtGE4A+VVjLXJeA1Q5rdda9BjSxDS4+xv3K+7ACx41
	UBJGGY4ixkSFc8wjngtle+5qRE4Dw4iRiNrhRHQfcfhPnDHgUE773XWNV4rMGwrTbzd5N4OG43q
	CpzEYGfx3meRtmHMtNYoTToWbZ2vg8EIuhkdrGPoWZzVxoD+xahWOXjgov
X-Google-Smtp-Source: AGHT+IEkkwKLlD7bgArhzanqcgyJXrNkTCLmX/zPs7UZp1FVMILPKD98FXvYwEVi1NAfBqdDip+8Dg==
X-Received: by 2002:a05:6214:4a84:b0:7d2:f787:1978 with SMTP id 6a1803df08f44-8846ed7f961mr1725046d6.3.1763581281958;
        Wed, 19 Nov 2025 11:41:21 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e47115bsm1948696d6.21.2025.11.19.11.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 11:41:21 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLo3M-00000000bbB-3imG;
	Wed, 19 Nov 2025 15:41:20 -0400
Date: Wed, 19 Nov 2025 15:41:20 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
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
	"Kasireddy, Vivek" <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v8 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251119194120.GR17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-10-fd9aa5df478f@nvidia.com>
 <BN9PR11MB527610F3240E677BE9720C2B8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20251118142849.GG17968@ziepe.ca>
 <BN9PR11MB5276EF47D26AB55B2CD456EE8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276EF47D26AB55B2CD456EE8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>

On Tue, Nov 18, 2025 at 11:56:14PM +0000, Tian, Kevin wrote:
> > > > +	down_write(&vdev->memory_lock);
> > > > +	list_for_each_entry_safe(priv, tmp, &vdev->dmabufs, dmabufs_elm)
> > > > {
> > > > +		if (!get_file_active(&priv->dmabuf->file))
> > > > +			continue;
> > > > +
> > > > +		dma_resv_lock(priv->dmabuf->resv, NULL);
> > > > +		list_del_init(&priv->dmabufs_elm);
> > > > +		priv->vdev = NULL;
> > > > +		priv->revoked = true;
> > > > +		dma_buf_move_notify(priv->dmabuf);
> > > > +		dma_resv_unlock(priv->dmabuf->resv);
> > > > +		vfio_device_put_registration(&vdev->vdev);
> > > > +		fput(priv->dmabuf->file);
> > >
> > > dma_buf_put(priv->dmabuf), consistent with other places.
> > 
> > Someone else said this, I don't agree, the above got the get via
> > 
> > get_file_active() instead of a dma_buf version..
> > 
> > So we should pair with get_file_active() vs fput().
> > 
> > Christian rejected the idea of adding a dmabuf wrapper for
> > get_file_active(), oh well.
> 
> Okay then vfio_pci_dma_buf_move() should be changed. It uses
> get_file_active() to pair dma_buf_put().

Makes sense, Leon can you fix it?

Thanks,
Jason 

