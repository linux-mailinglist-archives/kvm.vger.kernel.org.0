Return-Path: <kvm+bounces-65542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E81CCAEE37
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 05:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EF6513003DD6
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 04:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94689226D17;
	Tue,  9 Dec 2025 04:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aa6kHL1D";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cGjEYRBU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15EB23AE9A
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 04:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765254782; cv=none; b=o/kGq8WzHJ0xWnMz7MVxhIP5od0OTJHDQ39E/gSeByAzL6Tn7AiboBTaq6Fazv5dxER0qtJLY2gVNmQsLOVLUYBgV/mWza6ZGoy0sXGLdGBxihY5K0EbauUKpqKkathwBzaB37AczDNUOYT5p3HFjX4ZmRJMQz7eTWq3r3JwZZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765254782; c=relaxed/simple;
	bh=IR1GJIw1WogTr/OB4lNYncQ1ZxCQwr6Kq+gJH+Iw0t0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TPNVqt5nfSaPp+JL6mJbCAwQE60EB2LdE88prh/VgG/pVBi+b4p8l+LJ7ULKRKsea0ONTyxSczg6rXjHv3LtnIjhY2Yb1kkRyOl8iVEjm3mS5HKAFuzKxdTICMP6g191C40PKRk5L9IOtkiiXBlJPQYxJZ6r7hOlEyTFC4PwXUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aa6kHL1D; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cGjEYRBU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765254779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D7tlj801JGEwEviglxOLZTOSOnNkUWu4oKsf3XJ8MAU=;
	b=aa6kHL1Dt5u3jh8VWsdoMjOqn/04BUwO36pVlyZ15CqMyxanpdDQzubOp8m5BTvqaicHck
	LP5+TdlJn+yI6OITEFM3aTdSOx/iBerZMT5za4mBK8jfV0CqZSoNPWvFKMX5ko3pI2wYMP
	1tzblQ1PScWtxNt2WLFGoOFYjYonUYM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-NbfCe4l3N5-LkB0iLdHoCg-1; Mon, 08 Dec 2025 23:32:58 -0500
X-MC-Unique: NbfCe4l3N5-LkB0iLdHoCg-1
X-Mimecast-MFC-AGG-ID: NbfCe4l3N5-LkB0iLdHoCg_1765254777
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34992a92fa0so6716413a91.3
        for <kvm@vger.kernel.org>; Mon, 08 Dec 2025 20:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765254777; x=1765859577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D7tlj801JGEwEviglxOLZTOSOnNkUWu4oKsf3XJ8MAU=;
        b=cGjEYRBU9uyXGvVJR7FkTj8tlz5qNRfRxY5qLuguciAqWUBhWPnvzihuidLf12atnw
         HfKq9E4kAIlWVpy2C7EEp++Kl3V9tSOiJsf4dGbZa/EwkKsNnJXLjv79UTiURXLqGS6T
         /W5YjgwgnEeXIiC4//PlaA+6oM8rrg0YumdGHgyWNrZJW48hRgfhS4Jh/lz3/vIZI6GU
         vrydqTYquhtXd4w9wsj4zRxKeVaCF+Bxz4ItfAXKedP+v//suwT5LboRA7C1qmZOy6jN
         hkBj8lCqSXVSrrz3Fy8/gPG0nCqHYEWYwAKD33xYegRRFoppHe/0edmyNpLY78IPsqLp
         A9FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765254777; x=1765859577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D7tlj801JGEwEviglxOLZTOSOnNkUWu4oKsf3XJ8MAU=;
        b=aAMWW3xA60Dhi+RWIIEyjNJpAVZ/A8AizATE/k8xkKhqDJct1M3bvGrTDGc9ij5QLQ
         H95oTybLFWsVb8PEINDoj+56AORxpgfS7H6/Fn//O8MElripZN/0z9XR+PeTsOxyWQsK
         qd3h9mh7QZo79X86piC5fr7PDLREwtXqC4Op8LQOzIrv1klaxwUTXFKphEn9vqHnwH72
         kB6cvfnYRfwEMTTDCeF7Wf/KxJNPO5q4+ttrLoD9OqXexGH+zQ2V53j7I8x5klpOo/Je
         P4CsyYD7s0VC7WxlvkbdiVVQ+ee8LILF0DGVW6Y4w7Nn8QZxTJZXrkRpa9+eRnidS7sY
         i1ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUT7nV/IlccOUHyj90OoAQZcC0QT8+iAHspAFt/DJeVLFf32FcAyZaq4QikxRFaDZ6pUs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1lEcbaLt1kXN7J2+U5KDdtxMUjVdrP4E38b7p7KCjfBjHlDBh
	ezQKgo3kTNzeiZbf1tIzCTvMUgLM9tw6Lrw649Fg2t/MT3//Ad2pRvPqWh598GEwrqSb/2uiutw
	XnMzm9/mYeY6slnIy8SXgOu/WuYWyNI/2ixCIhn/c62iCaPlbxqrM+95w7d0WV6BkWTjSsEfHbF
	3iiAqHVp4S3GQMKm+K9LTx7gv9W4Z6
X-Gm-Gg: ASbGnct396VjPCF1sWId2Nu4ic6e8Nak9umWDdaT3VPuvw/1p3lNRz/EI2l5h+2Reky
	TSSrLniu9BvcGDFJ8mPLlr0vxIMjrGYbFYvXnQ/Ql0q2jrd3WQedLHNidI0MNbUBg97i7Ntlwiu
	YLOrWbV5pPJgUfn03luGK7MzKklypORoNANE6RGJ082JKFTceXLJLWqIVMordA4r9e5w==
X-Received: by 2002:a17:90b:4b02:b0:340:e521:bc73 with SMTP id 98e67ed59e1d1-349a24e1417mr6855266a91.5.1765254777264;
        Mon, 08 Dec 2025 20:32:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEdw0M8LAPWgyO/elXlfshz40Rlioju2PuyFc9XLzszeCdo7ctlmBpq76QMP0pwFL39U8NEhUcTgC3HIYBdbo8=
X-Received: by 2002:a17:90b:4b02:b0:340:e521:bc73 with SMTP id
 98e67ed59e1d1-349a24e1417mr6855241a91.5.1765254776843; Mon, 08 Dec 2025
 20:32:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251209022258.4183415-1-maobibo@loongson.cn> <20251209022258.4183415-2-maobibo@loongson.cn>
In-Reply-To: <20251209022258.4183415-2-maobibo@loongson.cn>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 9 Dec 2025 12:32:45 +0800
X-Gm-Features: AQt7F2oiXNzEXvaoIJ5PYmQS-SgPLwwMhAbf5fZFgBwLJ4Ewmxplg8YGZKVBbKg
Message-ID: <CACGkMEu3rhZy6hiZ14AvXgXLz2KvwvcU81KNrP_XsM475ZM=Nw@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] crypto: virtio: Add spinlock protection with
 virtqueue notification
To: Bibo Mao <maobibo@loongson.cn>
Cc: Gonglei <arei.gonglei@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	wangyangxin <wangyangxin1@huawei.com>, kvm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	stable@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 9, 2025 at 10:23=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> When VM boots with one virtio-crypto PCI device and builtin backend,
> run openssl benchmark command with multiple processes, such as
>   openssl speed -evp aes-128-cbc -engine afalg  -seconds 10 -multi 32
>
> openssl processes will hangup and there is error reported like this:
>  virtio_crypto virtio0: dataq.0:id 3 is not a head!
>
> It seems that the data virtqueue need protection when it is handled
> for virtio done notification. If the spinlock protection is added
> in virtcrypto_done_task(), openssl benchmark with multiple processes
> works well.
>
> Fixes: fed93fb62e05 ("crypto: virtio - Handle dataq logic with tasklet")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


