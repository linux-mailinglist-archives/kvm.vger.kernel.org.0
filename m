Return-Path: <kvm+bounces-26470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B479974BF7
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 10:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43B071F2258D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6961D13AD26;
	Wed, 11 Sep 2024 08:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iKYe1LaH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14895558BB
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726041684; cv=none; b=BmThXSg1pflgTYe/D75+/varfTDhXj2R0ZKC6c2N4Hqbc6yYQrrUBRMVkaMPadlJBMEZCMp1y0af4zc/U/XCViB4nuPCRYGcUOg7SZWa+NSzYLpRPWIi2WLzqEeSKx3y+14H2c1kCDwe11q5pbkY5/rd3Mh/lz/PsIumuLT2KtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726041684; c=relaxed/simple;
	bh=S7YFPOr47KnzpX+EfvhDAL9kUueFzGcx6/bEZmJEe1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=htDPMYWCZkHvZ+FP9dup7fLwxNJF8lndeHZJQreGM+U7n/ce+WpZ1fey8E5jLGaaTDA5qPZV5542nY6ygTCwE0CwXRABRgR9HlwvPzdBa5kpyiYFYQRjIbiqDM+XHh5JM/ijeByVD2be3FQW42Y63RnvhAIah7v4zvW+B7yMKoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iKYe1LaH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726041682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S7YFPOr47KnzpX+EfvhDAL9kUueFzGcx6/bEZmJEe1U=;
	b=iKYe1LaH+ntw8w/lhU+wlFD3FxNXNOnQU9f+HDBAdxtIMnqmjC2RE4WGEGSDh4znzw3uRR
	vG7PYeKmKGEjuxEzGKHtE/O0n/S5YiwgnBoVdLHJag8QcJwSKuLvZj8ifF4wXH6Clo6QjU
	ExW8EcVPouleCK5pe2/p4I62cCkvhOU=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-RyfSWJbqNR-ElS9nFze0kA-1; Wed, 11 Sep 2024 04:01:20 -0400
X-MC-Unique: RyfSWJbqNR-ElS9nFze0kA-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6d475205628so189493787b3.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 01:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726041680; x=1726646480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7YFPOr47KnzpX+EfvhDAL9kUueFzGcx6/bEZmJEe1U=;
        b=oEMzKREl8iJle/RyPT8Exs49cK2HW3xix4BjFHmUJ1GUKI0i9zBKyZTMP1uLdYJlxo
         Z0/1xB6zS5xs60JWJ3A0di9dbjJG8GIZtwCp5VFsEWIHBMMKMoNY/J8qQ+JLt/v1Kcuo
         ECwmPXLIeDo93ybRvI5eJx4wn6KdukMCdT9YCIVF8wbdiu7CjIVHyXdNoEgmb8NZLiZB
         pYx3Noft9LHHuxDTS8yCk/GNJXi5Imj69U4tWUzUbzg5fjNBR7jg56QgEdSf5w7IumS+
         Qeip2Pgazt5VB4fAVX8pa7483Li+sQNzLkei6zJ/N2/xPbeDi1rwVw2hSWECX64MkfsI
         FtZA==
X-Forwarded-Encrypted: i=1; AJvYcCX7SMgLBWIBNhkl4vCq41ohj2MGX6wOnBqvAL/obNsj2b4Ud55XDybRjPifmZf4AVvzKbA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJEtsiCQL8aTb5p9TivohbkCNtyeyd/9vbK+4gDczEvavls0tD
	8JMHqayx+7b50nIDS0H2ZCKuTYE0EOEZ0st5vFeqKqxC/KVZhUMWCvF5gL2j8D1wpq3P+gX4qDH
	dhHGDP5Y+blpHPTf6M5/iHpid8uX18xZ9eZ4toVd96VpmRXykefA4UAMBABdEhenJdBxHgD+YGY
	kW8IitNFvh+X52FchIERkQym0u
X-Received: by 2002:a05:690c:6512:b0:64a:3e36:7fd1 with SMTP id 00721157ae682-6db44d9e360mr200120267b3.10.1726041680282;
        Wed, 11 Sep 2024 01:01:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFGycL15wVUOnoLYy7HKMCqM5sIYCNMn+FEaCTz3f8kQpDk/ygjQU73LezZOKgf3VnEGDHaAdRqQdFmHRUiFMw=
X-Received: by 2002:a05:690c:6512:b0:64a:3e36:7fd1 with SMTP id
 00721157ae682-6db44d9e360mr200119947b3.10.1726041679985; Wed, 11 Sep 2024
 01:01:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816090159.1967650-1-dtatulea@nvidia.com> <20240816090159.1967650-2-dtatulea@nvidia.com>
 <c59afb55-78b1-48b3-bafa-646b8499bf1c@nvidia.com>
In-Reply-To: <c59afb55-78b1-48b3-bafa-646b8499bf1c@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 11 Sep 2024 10:00:44 +0200
Message-ID: <CAJaqyWcEt7=3j2uoToZH=no-gPvRsXwW7RLtFcbD7_-nQ0Dqyw@mail.gmail.com>
Subject: Re: [PATCH mlx5-vhost v2 01/10] net/mlx5: Support throttled commands
 from async API
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	virtualization@lists.linux-foundation.org, Si-Wei Liu <si-wei.liu@oracle.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 9, 2024 at 11:33=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
>
>
> On 16.08.24 11:01, Dragos Tatulea wrote:
> > Currently, commands that qualify as throttled can't be used via the
> > async API. That's due to the fact that the throttle semaphore can sleep
> > but the async API can't.
> >
> > This patch allows throttling in the async API by using the tentative
> > variant of the semaphore and upon failure (semaphore at 0) returns EBUS=
Y
> > to signal to the caller that they need to wait for the completion of
> > previously issued commands.
> >
> > Furthermore, make sure that the semaphore is released in the callback.
> >
> > Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> > Cc: Leon Romanovsky <leonro@nvidia.com>
> > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Same reminder as in v1: Tariq is the maintainer for mlx5 so his review
> also counts as Acked-by.
>

Not sure if it was the case when you send the mail, but this series is
already in the maintainer's branch:
* https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/
* https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=
=3Dvhost&id=3D691fd851e1bc8ec043798e1ab337305e6291cd6b

Thanks!


