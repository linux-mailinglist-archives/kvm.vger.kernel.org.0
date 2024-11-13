Return-Path: <kvm+bounces-31770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46F0D9C7770
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 16:40:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B59DB29735
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 15:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B517E171C9;
	Wed, 13 Nov 2024 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P4ukQDWx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624A2635
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731510395; cv=none; b=UqpkQc93ZQjPZWXUa2dImFqtC49Uye3a5IozGIwtupE+VFrEVwU0v8mQOp2ziHbLPns9Fcd4A/4wkqjalrkaZN1/JY1Qx6KVNk9NUv42LeMBqVE2ykYzeWif9aN1US5XfgbyPh5sr84L739WIg1velbfdFDzIBT11TCb7Etrf5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731510395; c=relaxed/simple;
	bh=mpJgoK+KWuNIIegnc/x2H4Utp5hqy3HIkW65cX40Zx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vC86CFs7E48xmeRcggNWj2cy2ipD4anSXCG5+cp//PlAOJ1TFqYQGsfK/qNQvBWKJaODK6z6q933fLrySZvwtVSq2tyD/Epc8n2Gz+i9XYhHcFDrlLzWaGhVhzdd6wKmt6VH79j0NJAB/z3oquMKIX7XoAs8mpy42L/PeaJk8NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P4ukQDWx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731510393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GWLdOv3kD3hyDaciZE7jYJRmtPh0CooncSDI6Dayl5M=;
	b=P4ukQDWxkK/AJPitoTJP0Mk/Pcv3XlvmYPlOrsRuJ17dx0/+vycpeRDrOzxOqnoXrgink6
	hevJZvQVqZUUlwD/wMY1aLfq6qKVFOpxTXVV2zIaum5fyiF7ERHtUvvL8XYHoax132Vnfq
	Uq0Kl194PBxLKwXJVuAbn6BxJhsUg0A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-YI2yA_usOiyuIZlab6kcKA-1; Wed, 13 Nov 2024 10:06:31 -0500
X-MC-Unique: YI2yA_usOiyuIZlab6kcKA-1
X-Mimecast-MFC-AGG-ID: YI2yA_usOiyuIZlab6kcKA
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d589138a9so4268061f8f.1
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 07:06:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731510390; x=1732115190;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GWLdOv3kD3hyDaciZE7jYJRmtPh0CooncSDI6Dayl5M=;
        b=GFO/Zpv7eq2BlknXgiucrUT4eedJsrOXMTGzzm25iRNSCKelHet5WL/OYkNA/IvnU7
         qH4HNEjg1Anyv650MHYQ/LL2niMV6y9pGSDUBk2E3tERIz7bRW01mHPor2/0l6WtzoPT
         0KP/hnsLrqTexu2jrHAMeDcjuyFQKWKDiT5F4GRDiOC/OkRQxS7OcSM63EwXGEspSkEu
         o3qLYeNnKyyONAivzlEKfC1e3Upi+lwM3FK3mJkMULTtjTObCHbQi4qiW4ntLgsz0BJN
         CoLhVS/LwjMXER6q8DWEoYZFIH2WUcbbr/wsATlLP+gXAdak2+2m+4ektJBV3cFg+dNb
         rF1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUNzOXVnpnmw/bD1obI3YS7R80bMjW8K/bhIP2eMbZMAL4mBgDM1vnFQT+D18/+DHKegTo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3wkbLGmrAc+bEefhU7DMkZdvam8weo1WwAyaCQM+XP/47ccm3
	bWe9Hp8NCvyt0FRpqZ9xcEY9UO+Vw2oohW9dF3AlPjGqYPVCt1cd0zq6rKO+dbP+ut5bh39DS5D
	XsymkeTD0pmnWYSaF1XXDqCuz+GTqWyhr61iwZh1UqjOHGryzIQ==
X-Received: by 2002:a5d:588d:0:b0:37d:3bad:a50b with SMTP id ffacd0b85a97d-381f18855aamr18437796f8f.45.1731510389838;
        Wed, 13 Nov 2024 07:06:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFR7SGrB4Fhm/j6pwU0uLR/0ukNIUrLvC+LHfK+NVU9lonHgPfDgfk60S9MS3/zsxXaiAHN+g==
X-Received: by 2002:a5d:588d:0:b0:37d:3bad:a50b with SMTP id ffacd0b85a97d-381f18855aamr18437760f8f.45.1731510389417;
        Wed, 13 Nov 2024 07:06:29 -0800 (PST)
Received: from redhat.com ([2.55.171.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed99681csm19022148f8f.49.2024.11.13.07.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 07:06:28 -0800 (PST)
Date: Wed, 13 Nov 2024 10:06:24 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: virtualization@lists.linux.dev, Si-Wei Liu <si-wei.liu@oracle.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 2/2] vdpa/mlx5: Fix suboptimal range on iotlb
 iteration
Message-ID: <20241113100618-mutt-send-email-mst@kernel.org>
References: <20241021134040.975221-1-dtatulea@nvidia.com>
 <20241021134040.975221-3-dtatulea@nvidia.com>
 <20241113013149-mutt-send-email-mst@kernel.org>
 <195f8d81-36d8-4730-9911-5797f41c58ad@nvidia.com>
 <20241113094920-mutt-send-email-mst@kernel.org>
 <83e533ff-e7cc-41e3-8632-7c4e3f6af8b7@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83e533ff-e7cc-41e3-8632-7c4e3f6af8b7@nvidia.com>

On Wed, Nov 13, 2024 at 04:01:05PM +0100, Dragos Tatulea wrote:
> 
> 
> On 13.11.24 15:49, Michael S. Tsirkin wrote:
> > On Wed, Nov 13, 2024 at 03:33:35PM +0100, Dragos Tatulea wrote:
> >>
> >>
> >> On 13.11.24 07:32, Michael S. Tsirkin wrote:
> >>> On Mon, Oct 21, 2024 at 04:40:40PM +0300, Dragos Tatulea wrote:
> >>>> From: Si-Wei Liu <si-wei.liu@oracle.com>
> >>>>
> >>>> The starting iova address to iterate iotlb map entry within a range
> >>>> was set to an irrelevant value when passing to the itree_next()
> >>>> iterator, although luckily it doesn't affect the outcome of finding
> >>>> out the granule of the smallest iotlb map size. Fix the code to make
> >>>> it consistent with the following for-loop.
> >>>>
> >>>> Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
> >>>
> >>>
> >>> But the cover letter says "that's why it does not have a fixes tag".
> >>> Confused.
> >> Sorry about that. Patch is fine with fixes tag, I forgot to drop that
> >> part of the sentence from the cover letter.
> >>
> >> Let me know if I need to resend something.
> >>
> >> Thanks,
> >> Dragos
> > 
> > But why does it need the fixes tag? That one means "if you have
> > that hash, you need this patch". Pls do not abuse it for
> > optimizations.
> > 
> Well, it is a fix but it happens that the code around still works without
> this fix. I figured that it would be better to take it into older stable kernels
> just like the other one. But if you consider it an improvement I will send a v2
> without the Fixes tag.
> 
> Thanks,
> Dragos

No need.


