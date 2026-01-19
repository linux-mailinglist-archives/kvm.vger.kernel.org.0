Return-Path: <kvm+bounces-68537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E4F44D3B7BB
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 20:54:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8BEBB30090DB
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 19:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4F42E6CCD;
	Mon, 19 Jan 2026 19:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Y8xzswM1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com [209.85.222.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001A92DF3F2
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 19:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768852489; cv=none; b=obcFBqi3bhlPihpovEiN3CyHIUXYl4AnkyUDiBMrfF96AqJIB4yY2uU5hTbDXtQiVnf5hrepbpPloaQdlsfxGGSsrojCAvCLJNQZqBZYgeFG0ikzR/td81KuG39VTxKuvNbQzvT7Fz3TlmD+BgvMLIg/Ka8XRk65EsWCjMBa7Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768852489; c=relaxed/simple;
	bh=EgdbrvHnoBh/zDpp9ewcIGQxrvWxBBXiNgVYU0RjdCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pv+xdsIxg9TrZCTR6SXjKmjFaCva0l3MvNXPoRtjHBVYzfwi6yuXOJF8WyIPylccsXV154IXvqUGVdMKkgpN7KQtDkDqczjzsTbXYFrK7FwP6z7eYPN5QWXs8wFnbBJM2vfiSJcY6b6RVydO+tDwebRHSMqAB7EuGTwRksU/PcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Y8xzswM1; arc=none smtp.client-ip=209.85.222.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f194.google.com with SMTP id af79cd13be357-8c52c1d2a7bso624125285a.0
        for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 11:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768852487; x=1769457287; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zwZ9o3ha19w1BUlcGeJzNZvsy/mlKSz+FRMjn04+Z/c=;
        b=Y8xzswM1blPsOkAhqH9fGcG5IadYE5sQt0vvRXgZTPwAqYIsRh7nfXeu6jNChZ9hKz
         pxh03Sf81TJGk6WYR/8QTTKv0398gWd3wYINx05q1DLlmDzVVk/NEVNNQwO+bPsjiEM+
         DwUUbkbk10s6Fp3bgZ57bQyIFL/QYcj3I6o6+LDJWtvZc2pKLOJKUzT1qPnWdD8nfsB8
         0yCZUa/cLOmqCmhtbTBryPRqR8QJa6sP4qKlGepQD5Upo2SfzMS2mOKHpFphA7+f7C5J
         BP85MmGwAh5gJ4jJ++0ltmFsTXWDGrIdPIsFj8/s8hh9WLBQHyZMI9O4mkorRJ3DA1nv
         FZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768852487; x=1769457287;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zwZ9o3ha19w1BUlcGeJzNZvsy/mlKSz+FRMjn04+Z/c=;
        b=H1pv8mop/NWebZhNMcOSHHNjGzFiWVxAl57q+iw+BsqS78ZYWp5JSVgBqy7AzQ/TWK
         vO6EhYZxlo39qrgzYHYhZcNXZV6SIn71NLRTkDq/aJdQ78wV7i6Uz6VehUHgMPK6d8Ad
         kcmb8FeUIgFqV+QrRySMLZTCl9bkj1yukjV9IzRKSqih5GPNUji5d/A950TZoUqdex1C
         YSRNcsbMIbfiqbWg4rX17Uz+E2yRTCyeeW/Fu4+umXB3+e1bua9XqdcJFgQ2lcRrPEF5
         sMgxvaiGxL65Gwmh3GZsIuKTsE5NJ6FKN1jHnBDVwRD0PaF2epAkeM0LEZTONaGwn0sE
         QZCw==
X-Forwarded-Encrypted: i=1; AJvYcCUA0REnMyfRoVJmmQcXQ0be7CTZj2d8m0MLBsy7giWR5kUn9ipywmeXe8rcnxd4UnyDUCk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+769DydVNCbOcJU2uPQhWiezEzrvhXCZ2tJhXha0jFAdeEXUS
	BjH+uZXhQSbOeckSiBKXC76R0r2AeYrJvMkFab0BMzYzNi+oKrbXKggZvPOQ+UxECCU=
X-Gm-Gg: AY/fxX7dXjlQqG+JEqkcqgJs8DD1Lax6kp0GzdYAXxITq/L1QTqGSHROCKC0MD9x4h2
	KrH3YegTRgmfZiDRVr5NeClaFpJpad91LgxRF/N6Uy9AIvqW7JFkpUV/ZxRHz03LuxJ0bk2f59T
	97xJnubw2ewCIR9SrMa87Xyk+PaqJApybetOw1/wSoKis0BSiCY82f9esFKVc5BEzHRCj7UpUtT
	YYp9mjc8CjjGFVDKgXUNOln491J83GLqdqLq3IOgWhIuo9755xTh1HG1MQ+YqAi4qZlfdiV8D4s
	+/pMpjJgVkQcvEUIO1jeVW3B9/K6J+R4pm75cWUVIUHjeiHRgHB2p/b52qnqcJcAri8/VlP8+/E
	XhGUXl+FKU9oyVYDJdbwtcSJ21kf4J3ZMXroYcc9KfOIbi/ByPrCQvtLrhkFhFPCI7AOAL52nxn
	YDM8GbAI1l/bciTrjo5zg2VWErzmTa+GYEdQXj3sRgiPywTHkYPdBP0YAJSHWNmp1MNrs=
X-Received: by 2002:a05:620a:4606:b0:8a3:a42e:6e14 with SMTP id af79cd13be357-8c589b9706emr2117693085a.10.1768852486747;
        Mon, 19 Jan 2026 11:54:46 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e6ad75asm86947906d6.31.2026.01.19.11.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 11:54:44 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vhvKm-00000005JRT-0mKA;
	Mon, 19 Jan 2026 15:54:44 -0400
Date: Mon, 19 Jan 2026 15:54:44 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/4] iommufd: Require DMABUF revoke semantics
Message-ID: <20260119195444.GL961572@ziepe.ca>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <20260118-dmabuf-revoke-v2-3-a03bb27c0875@nvidia.com>
 <20260119165951.GI961572@ziepe.ca>
 <20260119182300.GO13201@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260119182300.GO13201@unreal>

On Mon, Jan 19, 2026 at 08:23:00PM +0200, Leon Romanovsky wrote:
> On Mon, Jan 19, 2026 at 12:59:51PM -0400, Jason Gunthorpe wrote:
> > On Sun, Jan 18, 2026 at 02:08:47PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > IOMMUFD does not support page fault handling, and after a call to
> > > .invalidate_mappings() all mappings become invalid. Ensure that
> > > the IOMMUFD DMABUF importer is bound to a revoke‑aware DMABUF exporter
> > > (for example, VFIO).
> > > 
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  drivers/iommu/iommufd/pages.c | 9 ++++++++-
> > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
> > > index 76f900fa1687..a5eb2bc4ef48 100644
> > > --- a/drivers/iommu/iommufd/pages.c
> > > +++ b/drivers/iommu/iommufd/pages.c
> > > @@ -1501,16 +1501,22 @@ static int iopt_map_dmabuf(struct iommufd_ctx *ictx, struct iopt_pages *pages,
> > >  		mutex_unlock(&pages->mutex);
> > >  	}
> > >  
> > > -	rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys);
> > > +	rc = dma_buf_pin(attach);
> > >  	if (rc)
> > >  		goto err_detach;
> > >  
> > > +	rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys);
> > > +	if (rc)
> > > +		goto err_unpin;
> > > +
> > >  	dma_resv_unlock(dmabuf->resv);
> > >  
> > >  	/* On success iopt_release_pages() will detach and put the dmabuf. */
> > >  	pages->dmabuf.attach = attach;
> > >  	return 0;
> > 
> > Don't we need an explicit unpin after unmapping?
> 
> Yes, but this patch is going to be dropped in v3 because of this
> suggestion.
> https://lore.kernel.org/all/a397ff1e-615f-4873-98a9-940f9c16f85c@amd.com

That's not right, that suggestion is about changing VFIO. iommufd must
still act as a pinning importer!

Jason

