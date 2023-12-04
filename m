Return-Path: <kvm+bounces-3325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0691180313E
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 12:05:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 380571C20A5F
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 11:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6655722EE6;
	Mon,  4 Dec 2023 11:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XyhQQiY6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8DFB9
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 03:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701687889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aT/At2upGCT9VPho4S8jj9YWkQ5O4LoKTBPlC60T3Pg=;
	b=XyhQQiY6vVLU8TGpQm1QBrofSu3IBpdwTnSR0XrjQGIODNsJTinoys2zrPCjmx/R+rF2/C
	1qaxqlWHJ69Xp3dj252hFUIj6HVhhRaLL42+uLCYz/XvNrj2ND56t/q19RJsyuP11sdKiY
	X0DZYFQz/ShKHW106EScyKh0+MIqS8U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-6NMiB8upM_eqfFy1ZqLywA-1; Mon, 04 Dec 2023 06:04:48 -0500
X-MC-Unique: 6NMiB8upM_eqfFy1ZqLywA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40c068985e7so11456135e9.3
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 03:04:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701687887; x=1702292687;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aT/At2upGCT9VPho4S8jj9YWkQ5O4LoKTBPlC60T3Pg=;
        b=fITszVMmDaZ11S5CHJ2a6TvxxfJbmRoiSXu2ODLK6vOlDtgEQWQTXDC3RyWGkaSSva
         VJ+VpqmUsqI9BIpkHXGAsYVwmXUrRK5u9/UTDwH6wglagDeZ2kWnETRGpwBR4eRjojzs
         CQNgoIfMVT1LZsbnERihPqU7/Sys5Lc63cK9ClzSIsRJ6JOGlOsPu36HpdWT1NjFJ2xD
         TsI9pmBLIBxhsWfmyUV6ZZ/yKRWtlS6J2X6Ovjhtg9AunPdg7FXHz9b8ezbEjG/ES557
         jKhgyLTi47P4XdTWqeQIXZTIizZbdNPGUG9DmBOyDWeYeykf3pGgDuOnxATAvLXYsiIs
         r3fA==
X-Gm-Message-State: AOJu0YyyH/NHkMdIDNwWotSRMPw4CNdbzmqfRNP+bPcjmvA5p2zwZt5q
	LorYItfZvZdSzkKTaStWgOF0i+TV9JQuQCu1q/ePeBDuGk3aBsRlmzVUjqxsiT51OcFhnteIaAA
	yEUAd64JDnRrZ
X-Received: by 2002:a7b:ce8d:0:b0:40c:b81:d31e with SMTP id q13-20020a7bce8d000000b0040c0b81d31emr342742wmj.148.1701687887338;
        Mon, 04 Dec 2023 03:04:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFihxBxPdB2ys3q394rHHxaK//1lPggGSVUB+ncquBCZ170Lw3mhpOTy808C1BWlo7xnT0FBw==
X-Received: by 2002:a7b:ce8d:0:b0:40c:b81:d31e with SMTP id q13-20020a7bce8d000000b0040c0b81d31emr342733wmj.148.1701687886974;
        Mon, 04 Dec 2023 03:04:46 -0800 (PST)
Received: from redhat.com ([2.55.57.48])
        by smtp.gmail.com with ESMTPSA id f17-20020a05600c155100b004083729fc14sm18256693wmg.20.2023.12.04.03.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 03:04:46 -0800 (PST)
Date: Mon, 4 Dec 2023 06:04:42 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
	Parav Pandit <parav@nvidia.com>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	"galp@nvidia.com" <galp@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH vhost 0/7] vdpa/mlx5: Add support for resumable vqs
Message-ID: <20231204060300-mutt-send-email-mst@kernel.org>
References: <20231201104857.665737-1-dtatulea@nvidia.com>
 <20231202152523-mutt-send-email-mst@kernel.org>
 <aff0361edcb0fd0c384bf297e71d25fb77570e15.camel@nvidia.com>
 <20231203112324-mutt-send-email-mst@kernel.org>
 <e088b2ac7a197352429d2f5382848907f98c1129.camel@nvidia.com>
 <20231204035443-mutt-send-email-mst@kernel.org>
 <b9f5c48788daa3ac335b589b2ad23ea8366c08ba.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9f5c48788daa3ac335b589b2ad23ea8366c08ba.camel@nvidia.com>

On Mon, Dec 04, 2023 at 09:16:07AM +0000, Dragos Tatulea wrote:
> On Mon, 2023-12-04 at 03:55 -0500, Michael S. Tsirkin wrote:
> > On Mon, Dec 04, 2023 at 08:53:26AM +0000, Dragos Tatulea wrote:
> > > On Sun, 2023-12-03 at 11:23 -0500, Michael S. Tsirkin wrote:
> > > > On Sun, Dec 03, 2023 at 03:21:01PM +0000, Dragos Tatulea wrote:
> > > > > On Sat, 2023-12-02 at 15:26 -0500, Michael S. Tsirkin wrote:
> > > > > > On Fri, Dec 01, 2023 at 12:48:50PM +0200, Dragos Tatulea wrote:
> > > > > > > Add support for resumable vqs in the driver. This is a firmware feature
> > > > > > > that can be used for the following benefits:
> > > > > > > - Full device .suspend/.resume.
> > > > > > > - .set_map doesn't need to destroy and create new vqs anymore just to
> > > > > > >   update the map. When resumable vqs are supported it is enough to
> > > > > > >   suspend the vqs, set the new maps, and then resume the vqs.
> > > > > > > 
> > > > > > > The first patch exposes the relevant bits in mlx5_ifc.h. That means it
> > > > > > > needs to be applied to the mlx5-vhost tree [0] first.
> > > > > > 
> > > > > > I didn't get this. Why does this need to go through that tree?
> > > > > > Is there a dependency on some other commit from that tree?
> > > > > > 
> > > > > To avoid merge issues in Linus's tree in mlx5_ifc.h. The idea is the same as for
> > > > > the "vq descriptor mappings" patchset [1].
> > > > > 
> > > > > Thanks,
> > > > > Dragos
> > > > 
> > > > Are there other changes in that area that will cause non-trivial merge
> > > > conflicts?
> > > > 
> > > There are pending changes in mlx5_ifc.h for net-next. I haven't seen any changes
> > > around the touched structure but I would prefer not to take any risk.
> > > 
> > > Thanks,
> > > Dragos
> > 
> > This is exactly what linux-next is for.
> > 
> Not sure what the suggestion is here. Is it:
> 
> 1) To post patch 1/7 to net-next? Then we'd have to wait for a few weeks to make
> sure that it gets into the next tree.
> 
> or 
> 
> 2) To apply it into the vhost tree directly? Then we run the risk of having
> merge issues.
> 
> The "pull from branch" approach for cross subsystem changes was suggested by
> Linus this merge issue.
> 
> [0]
> https://lore.kernel.org/all/CA+55aFxxoO=i7neGBRGW_afHsSZ7K-x6fMO8v-8po3Ls_Ew0Rg@mail.gmail.com/
> 
> Thanks,
> Dragos

I will park this in my tree for now so it can get testing in linux next.
When it's available in some other tree as well, let me know and
I'll figure it out.

-- 
MST


