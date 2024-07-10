Return-Path: <kvm+bounces-21256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 140F992C915
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 05:25:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 101521C226A4
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 03:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A3534545;
	Wed, 10 Jul 2024 03:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZLUgi+PN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2E3282F7
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 03:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720581929; cv=none; b=CbHrDwEDX42K0Co13mwmF5DgEnJ/EI5w8BGJObtjFQiD7OIqGRQQFb8qsd0RYVEuJLJksqXJaS5Ih6hmY0pFmeHdB768ra49CP/5j8RDPn5/2fdtyzfPlv0xgmfho3dQDxjAdclfjFJZXEKAH6f8OHbXf/i04FaIIot5qxGPC0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720581929; c=relaxed/simple;
	bh=9sbwGihOLkbKRAKocXOlId4hhNDwPbs0zE0X3aDWblY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MMb3bB3u4qVB7NXjGqLxNaMOJYn9XhBkKlidEZZshAe/SP9yY4hscrM2cvkTqauYGh/clzkjw5ON49qZKAWmIJaA8r0Ef+vcpHh/6+YKmxbGb5qHv3hqXGjyEB/Ji0BMoHM7AmOSbYF7iIm5ND1El6st199ZSXpC6QPjhuuRPwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZLUgi+PN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720581927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9sbwGihOLkbKRAKocXOlId4hhNDwPbs0zE0X3aDWblY=;
	b=ZLUgi+PNNFgQ2nB5KNCTuOMH7KMrtG8vL4VQ6wIFV/NxMGHEbOrFOWTCFpjnh25roiw9k1
	llpId9ZbIjPF/YF0QBJPmhWx+0VnfrpI6l03h7zi/mYTAn4Qxudh+MPk+BV3E0IDjSFCgn
	N68n17Ji/NL6k0s2w89FrEmD9utvSM4=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-qjE3zMmKOA6xRtwPYBr8JQ-1; Tue, 09 Jul 2024 23:25:25 -0400
X-MC-Unique: qjE3zMmKOA6xRtwPYBr8JQ-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-381c11633e9so63875095ab.0
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 20:25:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720581924; x=1721186724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9sbwGihOLkbKRAKocXOlId4hhNDwPbs0zE0X3aDWblY=;
        b=gTevvY4WXVC7AXEYGOm6kUBklZj46Lvp04pu7zOfgMLZibW2AHlrjxzVCAfFR1oGSI
         ZeZX3irog0fnikPtiSmwH94Mbea4ekILQKjis+L/q0iY/dmsmRaMGiXXyy3ikz4O32Ir
         PXnHfRGpJDU3D6/TXFRSGGbDh3ynMbPdsl2eU4FI0bbX3upZopHLXjXp5d1sHscKMmot
         07nHk3V9Kd43c5i5iea8atQfQGMy4kuRYePqZMVrOvvQP9tGa2EehBFR60gy9TCTw1ZP
         VN0LspL/wLXO2nOjPCi5HZQYmXdfEIFvAQ9MPEX8Qzl8enF4g8kT3iGr4eFBFUe/Qb2d
         xEfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyCc6rTgy8RK1gp59gVTmGzMh9Alb4/MU4fBWnUUKuY5cAmmFF25wdyqR85oyCkAHaOsHbjNVV6nowlEAjmSbDNQCs
X-Gm-Message-State: AOJu0Ywszykxsz75WAChd5sivPmEgLrfXJULV0yEXV8A9GR7SbZbUfTQ
	uUVMP3X73B/lweL91S5rHRyPJ1oksn04Q6NT6ZQzZ8wZhIGQCYNYfMj6ZcCH9HPOK0KlGoO/C4o
	Ll3TG5u45ztRswcEbWjl29s5aLJvqjQPmuKtSeU5ynjemqVicIV0KbLNG5Yfloq5M5U/gM/1b4W
	4me7ruU6ScVeUfS8CVsGt/mCkq93FNLWU2
X-Received: by 2002:a05:6e02:170b:b0:382:b436:ecbb with SMTP id e9e14a558f8ab-38a57bcd755mr44254665ab.11.1720581923962;
        Tue, 09 Jul 2024 20:25:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEW8tp760Eusr7cpOewOOzt8KywljVE5imblpi4EA9nOMhtnhRxpdbKT5KwR6ZV/XXWj53jrT/VMHmkMmslXtc=
X-Received: by 2002:a05:6e02:170b:b0:382:b436:ecbb with SMTP id
 e9e14a558f8ab-38a57bcd755mr44254435ab.11.1720581923592; Tue, 09 Jul 2024
 20:25:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1720173841.git.mst@redhat.com> <1a5d7456542bcd1df8e397c93c48deacd244add5.1720173841.git.mst@redhat.com>
In-Reply-To: <1a5d7456542bcd1df8e397c93c48deacd244add5.1720173841.git.mst@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 10 Jul 2024 11:25:10 +0800
Message-ID: <CACGkMEsg0+vpav1Fo8JF1isq4Ef8t4_CFN1scyztDO8bXzRLBQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] virtio: fix vq # when vq skipped
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	Alexander Duyck <alexander.h.duyck@linux.intel.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	linux-um@lists.infradead.org, linux-remoteproc@vger.kernel.org, 
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 5, 2024 at 6:09=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> virtio balloon communicates to the core that in some
> configurations vq #s are non-contiguous by setting name
> pointer to NULL.
>
> Unfortunately, core then turned around and just made them
> contiguous again. Result is that driver is out of spec.
>
> Implement what the API was supposed to do
> in the 1st place. Compatibility with buggy hypervisors
> is handled inside virtio-balloon, which is the only driver
> making use of this facility, so far.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


