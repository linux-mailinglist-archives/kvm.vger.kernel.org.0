Return-Path: <kvm+bounces-58998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7608BBA9EB3
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:01:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91BC83C161E
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E4D30C344;
	Mon, 29 Sep 2025 16:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JfN+ag3p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C58309EE8
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161662; cv=none; b=HZx+uA7JLMFvxsXQZDobNv/6EzikylbEJRqC+KQPqx6BtQsXv87hZRW1Gw4z7JtxQrHwL0Tl0Ia0CiYspx7ZSD1yl8AraW7BXEy9x4ldTDRvZJ0/8up248ONXTyjaOwqqPoZYz3wMpW+9TN2tCln7sfN6zGb1TFi0QdhdicGXEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161662; c=relaxed/simple;
	bh=rvJzaJvHn4ysl0SarKojQPWkHG0cHul95/d7suros2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iOqIj8QzqGXiktiWLiPKAfDrN4RtkQuaxnfzi9r84Z5cw5NG7KLgKs2/HufFkZrcKCAo/44A1dtbnq5HJ2u4yTILzHqCx14sNW7PlO6zeQaGP6873omb6co7oxvR/aDViK4U9FqqWoaGGtgG2KGvZxNzTCV01jTrDqTBJyrfREw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JfN+ag3p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759161659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rvJzaJvHn4ysl0SarKojQPWkHG0cHul95/d7suros2Y=;
	b=JfN+ag3pNuXQwhIKsJ2eOHLF1Qtb5wwK6bFHSSwv1V+2Y5NTbhSaEniITycAuopVKeEYzT
	frLrEZ4WpgAanJxm/l20pvhLJ9bHJjQG9x50RdTqZRryK6KoIv3n9Kyiq0Lj2qoHaTTk6w
	aFAb5z55wWnzWY5az4ECLhrHaWgxnuY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-df2kDgSxPCeyJ5k1xUFcdw-1; Mon, 29 Sep 2025 12:00:57 -0400
X-MC-Unique: df2kDgSxPCeyJ5k1xUFcdw-1
X-Mimecast-MFC-AGG-ID: df2kDgSxPCeyJ5k1xUFcdw_1759161656
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b2e6b2bb443so510031066b.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 09:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759161656; x=1759766456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rvJzaJvHn4ysl0SarKojQPWkHG0cHul95/d7suros2Y=;
        b=a/DPMqIp6uOTEmvzaBmIDy6Uy5e4Wm239Bn1eiyR4R0g2riHCZd+d0IlYhBFGffsS8
         3GzGQLN+wy3vQmJ+FwOwFl8m8S8wyJKSVVEXXgsRy2G4HPCJImf8LHVS8SswAbhvNosA
         TbkaEW6m7N9mCYIPUvomV3niL+DsKycB1dcU1g1wIPuSzOn5nCnpJmKusDtPKS2WCu8w
         yD0+zd+oZKB0cfXLbTN93Hc7XGUeYn+KI815yMj3hD1LARslF0rLvwjwEIQL+FVq5iXf
         KTVjrrY2WYOOC6q9FX2WbrdIDxrd7xy8vK1R7r85s+2JHqJbdQxWM0GUlE8AZoGK4GWL
         NzfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjxpsaWYmukn3GbsavjJNL0vlrl9rGUiRgCM1dYC72ix4QhPvncGBOO+1J4Nf9Dcrj0GU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl2CAEEP7W5dGIo3vnRHRIT9Bz0O8OHA4XrpXvkd9r9c/kSU9n
	MCcKQOA6epI69EZlUpnBE49oDDImAdrcJI0YtxsTWb/26nTEaw5RY4yQcj7WRRD6GJbo/2kCJY3
	ngVB3trEmXiStku40WqxSKAxqX7nPtjpa7l28WEUwWZAKmHke25eLrmvEHyg09OS0mZAPmCHQYs
	PQWkYnsj00Nhy1yNNc7zKFXZJ0b5Qv
X-Gm-Gg: ASbGncsnjY133Zaldhjad3yW1XSh7vxiju/NSVPlXcMZdErUe3gINprlXNJFyA4DwrY
	QoSh74s0axu4EsWE2A/GIeQj/oGQc1QjRWEjpqbGf912PEG7DAK0GJoaiILtWl37g+EBbzgSoah
	Ntspzoh8lAaJHw1fgsxMuPHw==
X-Received: by 2002:a17:907:3e9f:b0:b3b:d772:719b with SMTP id a640c23a62f3a-b3bd781ba71mr843425466b.41.1759161655728;
        Mon, 29 Sep 2025 09:00:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6hzu6lwEjjnhGnHFD8M9ofM8ojrlvCKKGBmnqXaS/KCPAQ0khSQKd+hnPIMyAHKH3zg+/WlTMjm+XtQu+5y0=
X-Received: by 2002:a17:907:3e9f:b0:b3b:d772:719b with SMTP id
 a640c23a62f3a-b3bd781ba71mr843420566b.41.1759161655326; Mon, 29 Sep 2025
 09:00:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cd637504a6e3967954a9e80fc1b75e8c0978087b.1758664002.git.mst@redhat.com>
 <CACGkMEtU9YSuJhuHCk=RZ2wyPbb+zYp05jdGp1rtpJx8iRDpXg@mail.gmail.com>
In-Reply-To: <CACGkMEtU9YSuJhuHCk=RZ2wyPbb+zYp05jdGp1rtpJx8iRDpXg@mail.gmail.com>
From: Lei Yang <leiyang@redhat.com>
Date: Tue, 30 Sep 2025 00:00:18 +0800
X-Gm-Features: AS18NWC2orrPAiafpnWLj0PiUo6H6ktFe9pH1En2rWhE1VkgRlQKrFKPhSd3Jgc
Message-ID: <CAPpAL=z9GZKTDETJVEpq1aop8q1Rgn7VaXbV_S4_y-nsVfzpxQ@mail.gmail.com>
Subject: Re: [PATCH] vhost: vringh: Fix copy_to_iter return value check
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, 
	zhang jiao <zhangjiao2@cmss.chinamobile.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested this patch with virtio-net regression tests, everything works fine.

Tested-by: Lei Yang <leiyang@redhat.com>

On Wed, Sep 24, 2025 at 8:54=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Wed, Sep 24, 2025 at 5:48=E2=80=AFAM Michael S. Tsirkin <mst@redhat.co=
m> wrote:
> >
> > The return value of copy_to_iter can't be negative, check whether the
> > copied length is equal to the requested length instead of checking for
> > negative values.
> >
> > Cc: zhang jiao <zhangjiao2@cmss.chinamobile.com>
> > Link: https://lore.kernel.org/all/20250910091739.2999-1-zhangjiao2@cmss=
.chinamobile.com
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >
> >
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> Thanks
>
>


