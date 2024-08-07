Return-Path: <kvm+bounces-23536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE43594A8A9
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 15:35:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F33DB1C22CDE
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 13:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3DE1EA0CC;
	Wed,  7 Aug 2024 13:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="epEJzuLJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E091E674B
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 13:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723037688; cv=none; b=tPk2kw25mRwXd9Bsgd30pbrAEYfIgTOSt/bUwFafvnaFu9wVlp6a2wlYl323kveIK3cAarPSaiN5wutcPtOSvOUiM3ywlTLahFoaEd23DMOjZBGO4LLpDTAEgXRr4DDB/PGiZKlAdK3Y+b7S222TZi0JV4vBoxvF4O/PyxOkyPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723037688; c=relaxed/simple;
	bh=q9NcHt6yfC3iP9uRtNhtgIABvg+G9gkTnkkFm1hOZlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L78CQNOWlWSojSTfLSGUoAFtnpZ1a0RsHN3EP4pVqHd4fgAweutOfY5vO0F+SLmVWLoINN4moXB23WnVp7uvXhloolelptaK0SEqzMDRo8MzMoTWc1GYBH2+RwBxa0kBGcGuGdLEZytfHV8Xj8PdgYRKT5S3S/8ij+D3s4c1xKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=epEJzuLJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723037685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BSUqX+IG7mupB/XOn4TRmU85G6PcmHt69UDnYVwYRo8=;
	b=epEJzuLJb4ZGB2UtqBtFDd300kV56IzCLnK6qB0UL+m38UqzoRSJCVgxQRGyIzFe8huvuu
	HZOqTvFL8a3PY9SLH48q1LUfhA0z9JErYt4S31HfP1jH31DISg0DjRND7HQldP5Q3Y0qho
	RXWGnDGblyfOpv/xgJkTxQUWBwNAvZE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-tsbkCrc2NWiYBnh39yV_2Q-1; Wed, 07 Aug 2024 09:34:44 -0400
X-MC-Unique: tsbkCrc2NWiYBnh39yV_2Q-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2ef311ad4bcso18855301fa.0
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 06:34:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723037683; x=1723642483;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BSUqX+IG7mupB/XOn4TRmU85G6PcmHt69UDnYVwYRo8=;
        b=su/Ig6NUHIiujxqnrwAhqtECEWNvMHBSLLx8qQgyd/2CwCq70zW8+e+Wat+veevHrA
         ZWlw23jeGNm20wl4wZpA20AOA0DO8t+u8gFfw8TzZMAB0aHjQfiX0+f+DXSOfkQqwab5
         mFG7wyiApksHr2CW+iNVb9Mbxw4VR5RHQ4IRdIqEbNWdXBbwKnLxfdyeIe09UIAyhuUO
         HoTrta0Sg//9zSLs/98W9ulMhVr9fRLczH2CalOMf6C+m6OCf7/ZwogkBX5w/G6LJXfX
         WUMAYTMgja7riHoLNHdifmq4pGE7XU/9L6CYw83F6ZNkVJHLv5GNJmshEImKd2YjvdEZ
         Dbsg==
X-Forwarded-Encrypted: i=1; AJvYcCX6frVE5n8nvUZNhSLSmtM+hmQiXOZbjwSwu9R4SRsJN1AhpVz8hJTNUJqVRWKjhyCC9+gxCLYHySaEIohOfUm//ZgQ
X-Gm-Message-State: AOJu0YyGjtO740dwrLKA8kbHSSD65x/V0yjEdUbL1DHnoX7XrpWe69Cw
	Wp+mQkOzSNfPNhCIeIG9hkHC8m1umZOHgjj9AExOHIN9oJXG7/VoVT1sjwwZd63tBp3UlecYsaw
	GE4GjSbE2p3qfzoRjuQP+R3JPomYlV0N7t19EOQNsVrBMX6SUJ07D/EE0Hg==
X-Received: by 2002:a2e:8609:0:b0:2ef:2c4b:b799 with SMTP id 38308e7fff4ca-2f15aabccc8mr133927531fa.28.1723037682765;
        Wed, 07 Aug 2024 06:34:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1kLJOf5OmR6kChfxdY0La3W7+UVEX3evrbMrawtVKvFb7dXch4A6sXrabkqBnUM9UXYidjQ==
X-Received: by 2002:a2e:8609:0:b0:2ef:2c4b:b799 with SMTP id 38308e7fff4ca-2f15aabccc8mr133927051fa.28.1723037681669;
        Wed, 07 Aug 2024 06:34:41 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f4:efe1:812e:e83a:2c34:ce60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429059714d5sm29324685e9.13.2024.08.07.06.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 06:34:41 -0700 (PDT)
Date: Wed, 7 Aug 2024 09:34:15 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev,
	axboe@kernel.dk, kvm@vger.kernel.org, linux-block@vger.kernel.org,
	oren@nvidia.com
Subject: Re: [PATCH 1/1] virtio_blk: implement init_hctx MQ operation
Message-ID: <20240807093322-mutt-send-email-mst@kernel.org>
References: <20240801111337-mutt-send-email-mst@kernel.org>
 <0888da3b-3283-405b-b1a8-a315e2623289@nvidia.com>
 <20240801112843-mutt-send-email-mst@kernel.org>
 <9400fb28-47c2-4629-af17-df2a95f2d3d8@nvidia.com>
 <20240801114205-mutt-send-email-mst@kernel.org>
 <6a8f0c72-ba77-42c3-8d85-6bb23a23f025@nvidia.com>
 <20240801175617.GA1133773@fedora.redhat.com>
 <a10e97ce-792a-410f-b68e-d00292987b3a@nvidia.com>
 <20240803083824-mutt-send-email-mst@kernel.org>
 <7022d183-f98e-40b4-b3cb-00eb43c1ff06@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7022d183-f98e-40b4-b3cb-00eb43c1ff06@nvidia.com>

On Sat, Aug 03, 2024 at 08:54:45PM +0300, Max Gurtovoy wrote:
> 
> On 03/08/2024 15:39, Michael S. Tsirkin wrote:
> > On Sat, Aug 03, 2024 at 01:07:27AM +0300, Max Gurtovoy wrote:
> > > On 01/08/2024 20:56, Stefan Hajnoczi wrote:
> > > > On Thu, Aug 01, 2024 at 06:56:44PM +0300, Max Gurtovoy wrote:
> > > > > On 01/08/2024 18:43, Michael S. Tsirkin wrote:
> > > > > > On Thu, Aug 01, 2024 at 06:39:16PM +0300, Max Gurtovoy wrote:
> > > > > > > On 01/08/2024 18:29, Michael S. Tsirkin wrote:
> > > > > > > > On Thu, Aug 01, 2024 at 06:17:21PM +0300, Max Gurtovoy wrote:
> > > > > > > > > On 01/08/2024 18:13, Michael S. Tsirkin wrote:
> > > > > > > > > > On Thu, Aug 01, 2024 at 06:11:37PM +0300, Max Gurtovoy wrote:
> > > > > > > > > > > In this operation set the driver data of the hctx to point to the virtio
> > > > > > > > > > > block queue. By doing so, we can use this reference in the and reduce
> > > > > > > > > > in the .... ?
> > > > > > > > > sorry for the type.
> > > > > > > > > 
> > > > > > > > > should be :
> > > > > > > > > 
> > > > > > > > > "By doing so, we can use this reference and reduce the number of operations in the fast path."
> > > > > > > > ok. what kind of benefit do you see with this patch?
> > > > > > > As mentioned. This is a micro optimization that reduce the number of
> > > > > > > instructions/dereferences in the fast path.
> > > > > > By how much? How random code tweaks affect object code is unpredictable.
> > > > > > Pls show results of objdump to prove it does anything
> > > > > > useful.
> > > > > This is the way all modern block drivers such as NVMe PCI/RDMA/TCP use the
> > > > > driver_data.
> > > > > 
> > > > > These drivers don't have driver specific mechanisms to find the queue from
> > > > > the hctx->queue->queuedata like vblk driver has for some unknown reason.
> > > > > 
> > > > > It is pretty easy to review this patch and see its benefits, isn't it ?
> > > > > 
> > > > > It is not expected to provide extreme perf improvement.
> > > > > 
> > > > > It is introduced for aligning the driver to use common MQ mechanisms and
> > > > > reduce dereferences.
> > > > > 
> > > > > This is not "random code tweaks".
> > > > If you cannot observe a performance change, then adjusting the commit
> > > > description to explain this as a code cleanup to reduce dereferences and
> > > > local variables, improving code readability seems fine to me. I think
> > > > it's a nice cleanup when presented as such rather than a performance
> > > > optimization.
> > > > 
> > > > Stefan
> > > Sure. Please check the bellow adjustment:
> > > 
> > > virtio_blk: implement init_hctx MQ operation
> > > 
> > > Set the driver data of the hardware context (hctx) to point directly to
> > > the virtio block queue. This cleanup improves code readability, reduces
> > > the number of dereferences, and minimizes local variables in the fast
> > > path.
> > I'd drop the local variables part, it is not at all clear why is that
> > a win.
> 
> We can drop it:
> 
> virtio_blk: implement init_hctx MQ operation
> 
> Set the driver data of the hardware context (hctx) to point directly to
> the virtio block queue. This cleanup improves code readability and reduces
> the number of dereferences in the fast path.
> 


yep. also pls drop 1/1 from subject. Just [PATCH vX]

pls repost with these commit log tweaks, I will queue.
-- 
MST


