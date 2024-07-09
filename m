Return-Path: <kvm+bounces-21157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6445092B141
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 09:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE14C2822C0
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 07:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A988114831C;
	Tue,  9 Jul 2024 07:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f6FVDQG4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FEB13211E
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 07:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720510556; cv=none; b=fSVzAK+zZ7MU3I5xofLKj5hXVk2BGuzQbvmg0d6W4bdTGeyA9rhFVK8ME04qdYC+F5Mi1r2kq3RBuLxnkE5OtjFmFY6UebbmPqqIjwZy+Egn15mVMkoHtewnlXS9TpGg06D3/5oPwZrxnz3Sm1SBecZnA1cnDfx6ooNsNCvGS+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720510556; c=relaxed/simple;
	bh=bk6TipIY+YZoexVbFgevxA604DBUzZ7+Qxg6gsX5klE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OviNUw/JfRzWIzcjEn3vpPTyH1b8XRnqDMrLRcG2m38Ms3T2hf9WlsQt0L2fKioYERZnL7kYTMLX6mBAdsbfAmVAEQjGuHIK15au1dVp43qCFa501C8RIft0Z/BGh7W1LGfSS9KDylvWMKsDYyyW73X6G3CInTUGC6XVnvSk0us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f6FVDQG4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720510554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M/aFi9ih4y79YK2CY+Ehp2n7r5MFyUbmdEljfkFAxlY=;
	b=f6FVDQG4Tdmw3yxc3qENg+kLWXw5VkHRBO9O1prYG6NPOBB+q23N2AjUhV8fJtLDUAwD0h
	6RiRXU2RrdvnJMsWIuG+KzIj5ZG/9NFfGzEac/jN8P/EanI7hTM9Dmk3vLoGJQNuE0YVmW
	j/kbdaWC3wYb5L4R5tDPFlgfTlYW7jk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-4JjIfIUFNHe7lbiuvh2wDA-1; Tue, 09 Jul 2024 03:35:52 -0400
X-MC-Unique: 4JjIfIUFNHe7lbiuvh2wDA-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-58c859c5d96so3784367a12.3
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 00:35:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720510551; x=1721115351;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M/aFi9ih4y79YK2CY+Ehp2n7r5MFyUbmdEljfkFAxlY=;
        b=hHnDK+Gi442Muyshs10lTrwISCrEIjlGVeVjLfwBpVbc8S1EUA78dgPE7qxMQdycHA
         mpLus8QxAjYwBogUl3CjW+n/tdO/1OLtnipww8X3mbAbIPg4inLTSS3CQ7W4UyRsT/be
         0tZZ9myVsSRTuuRlbvqqVv2P4ws4FmTAayuve3sS8SAhLOItL2JS4V7quDNfhiZeVx/f
         WceSzjOPIq51hQ6Nenn8wAE4dEUb8RM4crINFqSNSOCYmSurSbJxQu4IDSgAHNWMdUwX
         95Aww7z8BUm/qB/ezZiIKM6DottH5tWrC9x0vVMv8xJmCj8IfUe2Xtr0UtOCg9xBx5dB
         c+0Q==
X-Forwarded-Encrypted: i=1; AJvYcCX4I+a2kaeDC27250igELowLKS5MnfEXv0CUUhLRSxIhiDVWsviTvPtDKpTqPBybEldFmQrWqyxjaIOyf3v9jPXTyIq
X-Gm-Message-State: AOJu0Ywf2irgSkeCJdWmXTVauKmLrp8kvez2laOrpIVKorsIbveMef0a
	D8T0TR57Ddh9cpcD3anSQijGIdDpOgoKWEg9JM9MkOWt0ZJrIeKogMtN4rNRGnhrXue3Cc6u8/7
	bzXEnzY42Hc2omBl9vVbwIwRq4Fb6ew6xrYJaDURfutY1H5+RrVRggxbbv5FySCpPB0W4aJ9r7X
	YfRVyj1DytaV4FzRAMb0sX0Z4j
X-Received: by 2002:aa7:d98f:0:b0:57d:105c:c40c with SMTP id 4fb4d7f45d1cf-594bb67e9e9mr997098a12.24.1720510551379;
        Tue, 09 Jul 2024 00:35:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiWni+LJU+6yVhYpIE9XYIpyjrSEJCag4tVtoxMKRcXeymx8yfK8l7rFpFU9jUUkq9Rln8XyB6tiM44nsNR3c=
X-Received: by 2002:aa7:d98f:0:b0:57d:105c:c40c with SMTP id
 4fb4d7f45d1cf-594bb67e9e9mr997083a12.24.1720510551112; Tue, 09 Jul 2024
 00:35:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240709045609.GA3082655@maili.marvell.com>
In-Reply-To: <20240709045609.GA3082655@maili.marvell.com>
From: Cindy Lu <lulu@redhat.com>
Date: Tue, 9 Jul 2024 15:35:13 +0800
Message-ID: <CACLfguUYny6-1cYABsGS+qtdzO+MKp3O09t_gt-bMM4JgdpZqA@mail.gmail.com>
Subject: Re: [PATCH] vdpa/mlx5: Add the support of set mac address
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: dtatulea@nvidia.com, mst@redhat.com, jasowang@redhat.com, parav@nvidia.com, 
	sgarzare@redhat.com, netdev@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 Jul 2024 at 12:56, Ratheesh Kannoth <rkannoth@marvell.com> wrote:
>
> On 2024-07-08 at 12:25:49, Cindy Lu (lulu@redhat.com) wrote:
> > +static int mlx5_vdpa_set_attr_mac(struct vdpa_mgmt_dev *v_mdev,
> > +                               struct vdpa_device *dev,
> > +                               const struct vdpa_dev_set_config *add_config)
> > +{
> > +     struct mlx5_vdpa_dev *mvdev = to_mvdev(dev);
> > +     struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> > +     struct mlx5_core_dev *mdev = mvdev->mdev;
> > +     struct virtio_net_config *config = &ndev->config;
> > +     int err;
> > +     struct mlx5_core_dev *pfmdev;
> nit: reverse xmas tree; may be, split assigment and definition.
>
Thanks, Will change this
Thanks
cindy
> >
>


