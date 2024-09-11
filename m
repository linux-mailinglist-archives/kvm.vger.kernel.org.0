Return-Path: <kvm+bounces-26471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D11974C04
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 10:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 83FCFB252A5
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E2013E023;
	Wed, 11 Sep 2024 08:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UjW021vy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C0A13DDB9
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726041762; cv=none; b=ijZcoKUVV+TWuCNgFHeTXgL8NVEkfPk8mIlmuhsNPx4V4zoxGWgsfFgQnVHV5g3hnp6QbVdCfnXhDPqBCvxlheFXORJqf5qmM1bO91FxB8kdbBwRi2AtuHOuHLc7sLeDx6FYfYxg34ZPNOzgbhaOuXoljfth+1/DTWRbrZXgX0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726041762; c=relaxed/simple;
	bh=SBqvxjgwuKxYi5tRyD56jhxnOgIIsD/rrS+45v5OEvk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FhUtOAi398X1nBIH2d0cVZllM9SgYt+4jRTsmWaSaXaw8eNVShwbErqOxarIT7hbaWkZpMDJKQ/wOdf0tiA+3RkKYwIkFlti2tLcC4O3quGsHtwQKEm9VgNO4grjSVociUh0fbUQBwrwxybEIkqq4Hol8Aiw38xrWkON1mkLKKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UjW021vy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726041760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gMv5A1puR1PVSNKI7BtOx9/tBwsThWDT9tdVtzSjjWI=;
	b=UjW021vyVYyvCW6kbyVOqie/UmLDEqFL5c7bPIqeXOGg5fxkMNjOrPlFDMGQpgS9jcdPGx
	zvZja7cx7ZkbCDXPKFgBcqXH0cQ2tN4q5CAfW3NSE0X5fffz2fi0z5xuDLeb2XTXLU4EPP
	cd3KTVHo3Ryaq214ijKC6q3LAewqBDA=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-dqWZBh3SPku6jnMYhNMxxw-1; Wed, 11 Sep 2024 04:02:39 -0400
X-MC-Unique: dqWZBh3SPku6jnMYhNMxxw-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6d475205628so189509287b3.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 01:02:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726041758; x=1726646558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gMv5A1puR1PVSNKI7BtOx9/tBwsThWDT9tdVtzSjjWI=;
        b=DUdOY0hBMVliCCRvGM5ppb1xiKMTNdiNSDkni2uCo/EJGD18yF3ULmT7OZp7Q8v0e6
         tXEm1zft313guVM2vkHdSydOrGibaS/fMw5oes5v8VRFtDN3R7vbWDDUlRq7X+N4jLbR
         uzkgah/r7k6/fI6O/AFDG+hJ6Ba2dtqjcvnV1S+HWBLLCDwNS2m8w4rhyj2dclgTNTbm
         ITC4v5XB8UHCvHAiPj7hS98JqS1qIn9QRv1YrrqMN1SfD31FPszj3467dj3uPC7depOm
         L3tY+CUU65uQ5NkCJDZp9nJNic2pgV8W6d7Xjr++N2jcDIMASU/G3fKsgc0WixwYfYo/
         FKow==
X-Forwarded-Encrypted: i=1; AJvYcCVfEgtRuqDrZB9Lml9mgMLAWd/N+tVjmyLnoIlmlMaVd99pONYxtIApA34UCWVGbCnUt40=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoZfNhKKcVA11emTnRTg6PSiPLbJoQjT1rpEJyj3no50bOM6kd
	dgSVUmBDOvGjKPtEf93bqm6GpUnSACUo3geWfV6UdQoe3v7c055Ed74mNFvl9eVMD1r+sPW0ajz
	nmR5zttRGinLmM3XdCoLF6yEvmf3sSL7WHdYy2HxDKT1U60Z9eKXZESvYihijylOVJ4O4vHE5JH
	YdD02XXxWX87vdjzTJLRfDZkbq
X-Received: by 2002:a05:690c:4801:b0:6be:523:af4d with SMTP id 00721157ae682-6db44da271bmr185115217b3.11.1726041758679;
        Wed, 11 Sep 2024 01:02:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJeejzNHOmqV77bv+PMzikwQtB8ZyHDG4/ZhkqhGXqCY1isJM+xkRb3k3F3/Fagm+Jpye9YalAIDnoFocfBjw=
X-Received: by 2002:a05:690c:4801:b0:6be:523:af4d with SMTP id
 00721157ae682-6db44da271bmr185115007b3.11.1726041758352; Wed, 11 Sep 2024
 01:02:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240830105838.2666587-2-dtatulea@nvidia.com> <fb6b1d3d-c200-479a-941e-1b994757b049@nvidia.com>
In-Reply-To: <fb6b1d3d-c200-479a-941e-1b994757b049@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 11 Sep 2024 10:02:02 +0200
Message-ID: <CAJaqyWfVfOe7X-2Ku3VhuzPMdF6TGM63D5squ6Naw=6iUQdgDg@mail.gmail.com>
Subject: Re: [PATCH vhost v2 0/7] vdpa/mlx5: Optimze MKEY operations
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, virtualization@lists.linux.dev, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 9, 2024 at 11:30=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
>
>
> On 30.08.24 12:58, Dragos Tatulea wrote:
> > This series improves the time of .set_map() operations by parallelizing
> > the MKEY creation and deletion for direct MKEYs. Looking at the top
> > level MKEY creation/deletion functions, the following improvement can b=
e
> > seen:
> >
> > |-------------------+-------------|
> > | operation         | improvement |
> > |-------------------+-------------|
> > | create_user_mr()  | 3-5x        |
> > | destroy_user_mr() | 8x          |
> > |-------------------+-------------|
> >
> > The last part of the series introduces lazy MKEY deletion which
> > postpones the MKEY deletion to a later point in a workqueue.
> >
> > As this series and the previous ones were targeting live migration,
> > we can also observe improvements on this front:
> >
> > |-------------------+------------------+------------------|
> > | Stage             | Downtime #1 (ms) | Downtime #2 (ms) |
> > |-------------------+------------------+------------------|
> > | Baseline          | 3140             | 3630             |
> > | Parallel MKEY ops | 1200             | 2000             |
> > | Deferred deletion | 1014             | 1253             |
> > |-------------------+------------------+------------------|
> >
> > Test configuration: 256 GB VM, 32 CPUs x 2 threads per core, 4 x mlx5
> > vDPA devices x 32 VQs (16 VQPs)
> >
> > This series must be applied on top of the parallel VQ suspend/resume
> > series [0].
> >
> > [0] https://lore.kernel.org/all/20240816090159.1967650-1-dtatulea@nvidi=
a.com/
> >
> > ---
> > v2:
> > - Swapped flex array usage for plain zero length array in first patch.
> > - Updated code to use Scope-Based Cleanup Helpers where appropriate
> >   (only second patch).
> > - Added macro define for MTT alignment in first patch.
> > - Improved commit messages/comments based on review comments.
> > - Removed extra newlines.
> Gentle ping for the remaining patches in v2.
>

Same here, this series is already in MST's branch:
https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=3Dv=
host&id=3Dd424b079e243128383e88bee79f143ff30b4ec62


