Return-Path: <kvm+bounces-67036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E660FCF2D46
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 10:48:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5E1D43002D36
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 09:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012263370EC;
	Mon,  5 Jan 2026 09:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MijUTPjs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE70C337104
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 09:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767606494; cv=none; b=mq5WzsMu8GzC7nZg/zq36UXBhjw0Y5b5YCTD6bNSEhqGKipyevF7bS0khu9cXGNJDTy27vikZSSxGJObfCqQ7xehAuCiqdFbFaZfE2KMEAhEhhElT011Wg7UHLuVq9rHU0NM+nfz0NoHw5JF2/RkLRejjLmMHe+l4/n5C9YsRkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767606494; c=relaxed/simple;
	bh=GqAwY0OHbZKQzzJb3VatReAfBA97RCbOF3bWO0/Z1Js=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QcuRqqzTVHOH8lSHyxIvpl4j43QD3ygWOPgUey5BQhBaQTIW21rrm4cjTJuUHCVffZUlub88F1WILvfJ6gVkfLM1zBI9+RSAYrEIExMwlMq36DBBMAqUJvwrIoOgPeY0TQFUcFR/t6FwB/NS62TivrgV+1iZR3U4fM0/fQpNAXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MijUTPjs; arc=none smtp.client-ip=209.85.128.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-4779cd413b4so9919435e9.2
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 01:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767606490; x=1768211290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3YNJPmUNbnGNTCEfFfuOCZFqj9o9elJ+A8mEb2IK5hU=;
        b=MijUTPjsGF+IN0qQnZU2UN+SXwz/10gftaqnCi6pmz8HNpiGxU6fNXR8FXqPpFtMiq
         bZ9sq+haPTqBmsZrj07bW1MWIebWGo93ZMb6xZ32lzg82cneRjLiTTIPYVSwfrSMOdko
         ErPJtuxpVAteZGm42JEr/QyLhqCBWowGfTyRRXHjgHUa2fPkIyDLfrYW48giSVPGB4op
         UDr5TmBgAUapVGstDDVQONrxiwlWKLzh4eDsleMzmhp1XKsEmTu8casZMLv3aSojf63k
         qM50JaJb7BqnYnk163aKYVUi07zhDk6GZOIftxcbFpf3KXSeGa64jte/8xcbueaSIocv
         m9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767606490; x=1768211290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3YNJPmUNbnGNTCEfFfuOCZFqj9o9elJ+A8mEb2IK5hU=;
        b=kTjje0lT7c81X5ou+oC61yL5NX9djYLPlAVwfinqIWz7JbVaumBp3CkaK6kvKs5kDn
         0zCWwt0uX5mmTh5dMfb8fszYmFg7tk0mfMUqS06NUvBvpBhlzZf06YiYYwvenYAtyiWb
         jP8lT8MGQqxuYWWxItEx/sx1+83WmP9hLjIRdW7XMY9mPBIS5q2JojgWKeUbs/beOPgU
         1+t3KMwuiq/xkyKdXdLXZphueeiAimSsnGofvaXo6i0sg4Rt1VZJeqGLyqMOPAXsSI5D
         aWsExGMb089a8z7f6YVB6xEdjND58gGZscr12ne5DNpRVqQU3K31oGbSr1XlNCo+qQeP
         8OPw==
X-Forwarded-Encrypted: i=1; AJvYcCXK8CXSgKkFu2BtpEspwR85NKuinx2WuFuBTnqXlaZvVKatRYdmUmcyiWbeXQlFQV0b/4c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1H4H/9dI5D+/Oss/hfw08T8/9cTSWK+nc/gWSJqc3346DuGM8
	Lk26Q7IJCd+hlT0aZYVt0+zSXkAj2mSF4YpL08hqPpoj0Q0ZBF7WepysXWXOnslrHLo=
X-Gm-Gg: AY/fxX7uMqSthJGEA6iqtA1iE4mm80g7iPcx51Atw1H/2UyOwarx21FfeO7mmEc7rVW
	omTA0eVC/dvP74pyY6jPsaf9GofHptcyUNQKSfQsvMkqnXgxZmyGFX3PIyIt90jySF8tySHSzJ8
	SWUKdxUfSkmCO5ruWaTL+juDo4pF5UiMLpIQMY0aNgLW9v9RZTZJrvFz63gaopKhr7ohLJPHo12
	6gUzxWILn8hQ3qT3HjCiF0Kg+sewRwsjIyX9g75Iz0JsBqXpRxEuJtMj4PbhGV0xG4mMvqP/YGs
	6hCY+ur+jo9hg+2MIr4Uk/wnrKfqPI5vnPfr9LBuswd4m3nkxTFdjuRPno1CCGyP5zOqyiw00of
	f3W9Vlw6VwPx6rBSoxZOxR34eVI9NJ4wJDWHnWFuBxmfPYq+EpSvvpiMSCKQ4tka00tmwe4gIZB
	/SisJ2FfyT5ZWC5o0UEeT7/Lum7mUKPCD1dl9hE6yzcgEMkad4yxJhDakhNYcH4TwHMGVAyPUDp
	Vru
X-Google-Smtp-Source: AGHT+IHPziOrpKV7Kr9yyjS7tcuC3KfVS3vu6/0u8YX5ecS7isO2cmN7o1CvFXRGO2JgzmojB4/s8Q==
X-Received: by 2002:a5d:548c:0:b0:432:5b81:493 with SMTP id ffacd0b85a97d-4325b810aa7mr24854531f8f.5.1767606485367;
        Mon, 05 Jan 2026 01:48:05 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea1af2bsm99699009f8f.1.2026.01.05.01.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 01:48:04 -0800 (PST)
Date: Mon, 5 Jan 2026 10:48:02 +0100
From: Petr Tesarik <ptesarik@suse.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Eugenio =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Stefano Garzarella
 <sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Leon Romanovsky
 <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Bartosz Golaszewski
 <brgl@kernel.org>, linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
 virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
 iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 02/15] docs: dma-api: document
 __dma_from_device_group_begin()/end()
Message-ID: <20260105104802.42bd8fe5@mordecai>
In-Reply-To: <01ea88055ded4d70cac70ba557680fd5fa7d9ff5.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
	<01ea88055ded4d70cac70ba557680fd5fa7d9ff5.1767601130.git.mst@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jan 2026 03:22:57 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Document the __dma_from_device_group_begin()/end() annotations.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

I really like your wording ("CPU does not write"), which rightly refers
to what happens on the bus rather then what may or may not make a
specific CPU architecture initiate a bus write.

I'm not formally a reviewer, but FWIW:

Reviewed-by: Petr Tesarik <ptesarik@suse.com>

> ---
>  Documentation/core-api/dma-api-howto.rst | 52 ++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/Documentation/core-api/dma-api-howto.rst b/Documentation/core-api/dma-api-howto.rst
> index 96fce2a9aa90..e97743ab0f26 100644
> --- a/Documentation/core-api/dma-api-howto.rst
> +++ b/Documentation/core-api/dma-api-howto.rst
> @@ -146,6 +146,58 @@ What about block I/O and networking buffers?  The block I/O and
>  networking subsystems make sure that the buffers they use are valid
>  for you to DMA from/to.
>  
> +__dma_from_device_group_begin/end annotations
> +=============================================
> +
> +As explained previously, when a structure contains a DMA_FROM_DEVICE /
> +DMA_BIDIRECTIONAL buffer (device writes to memory) alongside fields that the
> +CPU writes to, cache line sharing between the DMA buffer and CPU-written fields
> +can cause data corruption on CPUs with DMA-incoherent caches.
> +
> +The ``__dma_from_device_group_begin(GROUP)/__dma_from_device_group_end(GROUP)``
> +macros ensure proper alignment to prevent this::
> +
> +	struct my_device {
> +		spinlock_t lock1;
> +		__dma_from_device_group_begin();
> +		char dma_buffer1[16];
> +		char dma_buffer2[16];
> +		__dma_from_device_group_end();
> +		spinlock_t lock2;
> +	};
> +
> +To isolate a DMA buffer from adjacent fields, use
> +``__dma_from_device_group_begin(GROUP)`` before the first DMA buffer
> +field and ``__dma_from_device_group_end(GROUP)`` after the last DMA
> +buffer field (with the same GROUP name). This protects both the head
> +and tail of the buffer from cache line sharing.
> +
> +The GROUP parameter is an optional identifier that names the DMA buffer group
> +(in case you have several in the same structure)::
> +
> +	struct my_device {
> +		spinlock_t lock1;
> +		__dma_from_device_group_begin(buffer1);
> +		char dma_buffer1[16];
> +		__dma_from_device_group_end(buffer1);
> +		spinlock_t lock2;
> +		__dma_from_device_group_begin(buffer2);
> +		char dma_buffer2[16];
> +		__dma_from_device_group_end(buffer2);
> +	};
> +
> +On cache-coherent platforms these macros expand to zero-length array markers.
> +On non-coherent platforms, they also ensure the minimal DMA alignment, which
> +can be as large as 128 bytes.
> +
> +.. note::
> +
> +        It is allowed (though somewhat fragile) to include extra fields, not
> +        intended for DMA from the device, within the group (in order to pack the
> +        structure tightly) - but only as long as the CPU does not write these
> +        fields while any fields in the group are mapped for DMA_FROM_DEVICE or
> +        DMA_BIDIRECTIONAL.
> +
>  DMA addressing capabilities
>  ===========================
>  


