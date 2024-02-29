Return-Path: <kvm+bounces-10481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F27286C7CA
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 12:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 629081C2147C
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 11:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E2B7B3C0;
	Thu, 29 Feb 2024 11:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FCuJGVvm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2553657AF
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 11:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709205172; cv=none; b=YKg4TaU+A6o1n2R9Vgpf7KgZn/u96rwZNa6sSCtqCOZSrRklQPwxivO9EKIXC32qq90ax/ZAP5k/U5cwNXq4pBmWNSH1KNRt4sDBg1SMyjJW4LVDAx34JiWe3YQlhuqVnWuP/1EKv0fWVKPK+uQVAn5/VHvSuChgQIEZrdacBQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709205172; c=relaxed/simple;
	bh=N7Mhx8vT1jnELD9+9yC9rVTfdvP/sYDILPO0ay84HGM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kgbtjFYLYiSKdvIgwQuucUuKHq3CXMvp2d8St30vpFN5KnpNjf1bUcq5kPeCH/emNG0AGSM11J3f5N/YC8ra5ofkWtuclgSg9dOC2JvZ7R3hn8cxIBq2As27V1p8FtReAhLAeZXIt0D522bVjvyhRFbCgrlUN1eStFd9j/PWMh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FCuJGVvm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709205169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=J1ljLBvAKrzOfqXsdymMG4sOPRNjFy8nCCCQL/VLcRg=;
	b=FCuJGVvmBolUlHyQBm1XQBXIBokTImgYlUiM36k4Bug9tSN8IX9hsgh56Ttqy+Kc1e2q/8
	KAYw8PKnCsMseguJsxKvXxKcDpYlm0vNdbkKWbQkqEgRd4Aq76pspxZ5ALqJbBfuccvkH/
	uFf5ZalGVMyR7zzks7zJAf3JYz2X/vw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-3DR8k3aeOKKNB10pfryhaA-1; Thu, 29 Feb 2024 06:12:48 -0500
X-MC-Unique: 3DR8k3aeOKKNB10pfryhaA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-41293adf831so1138455e9.0
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 03:12:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709205167; x=1709809967;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J1ljLBvAKrzOfqXsdymMG4sOPRNjFy8nCCCQL/VLcRg=;
        b=YyHVWigKC9IVbP94ON2yt2IBdJCw88ZyK2yRI0ostITc3o5OWiSHA2nF8YNldRdbQP
         tNrIo62znuBlTv+yzO2R6T58QOqALqmuFOhStnM08P9b1lgHjW00GMrSLMiGX6VRqgsf
         +vCbYAYYnws7Mr0FBnjICCGxsi4GsA1MC0HfPbmLMKA7u21ez883xQf+CRfgbyAKt6rz
         0m+GIcSyPmgY1nYZp/Ofz+8ICXgp5N5CCeiilalF92j/AEo5YLH7GaOYuktAYUtQBh4d
         HSu8KazAqxo4ljtmzXjR7ZQCMJbTofI0/Yj3TBOu1oHvKKKjdnGYJCaC3fsckB/e8TJ8
         eoDw==
X-Forwarded-Encrypted: i=1; AJvYcCWIEJiq6jPERiM5z8wRF5fOgCcj0opuRjUXLEtWvR+dRj9bpHEVn/3JCJFwB4crHD8rFwUi+lOUk6wB+V0YKCdevygV
X-Gm-Message-State: AOJu0YxsSIAP9sgueTl1HR+EFZKPP21q8AbeS40Tlh29J/RcKR3rldOJ
	hGwm2S15iGo5Rzo/wlbQIREhoDFthn4GW1wqwNKwUOKGVxf2+iZoZlZnO7eisGcEjIlPkIxzIKt
	uarUYuo3vSM5k8+XzVhIFAQ8OyyNyuPsme4TnGAV2ZbgCDYzcOg==
X-Received: by 2002:a05:6000:18a9:b0:33d:9e15:12bf with SMTP id b9-20020a05600018a900b0033d9e1512bfmr1372347wri.3.1709205167114;
        Thu, 29 Feb 2024 03:12:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHfKKnPq3F5LjzBgxvLGpBosG5KZdsojuxXv+y3866lEvo3VcN/Hqtb7eOfxFpQwYKS/TI+dQ==
X-Received: by 2002:a05:6000:18a9:b0:33d:9e15:12bf with SMTP id b9-20020a05600018a900b0033d9e1512bfmr1372320wri.3.1709205166722;
        Thu, 29 Feb 2024 03:12:46 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-250-174.dyn.eolo.it. [146.241.250.174])
        by smtp.gmail.com with ESMTPSA id e5-20020adff345000000b0033b278cf5fesm1462888wrp.102.2024.02.29.03.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 03:12:46 -0800 (PST)
Message-ID: <7d478cb842e28094f4d6102e593e3de25ab27dfe.camel@redhat.com>
Subject: Re: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
From: Paolo Abeni <pabeni@redhat.com>
To: Yunjian Wang <wangyunjian@huawei.com>, mst@redhat.com, 
	willemdebruijn.kernel@gmail.com, jasowang@redhat.com, kuba@kernel.org, 
	bjorn@kernel.org, magnus.karlsson@intel.com, maciej.fijalkowski@intel.com, 
	jonathan.lemon@gmail.com, davem@davemloft.net
Cc: bpf@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,  kvm@vger.kernel.org,
 virtualization@lists.linux.dev, xudingke@huawei.com,  liwei395@huawei.com
Date: Thu, 29 Feb 2024 12:12:44 +0100
In-Reply-To: <1709118356-133960-1-git-send-email-wangyunjian@huawei.com>
References: <1709118356-133960-1-git-send-email-wangyunjian@huawei.com>
Autocrypt: addr=pabeni@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-02-28 at 19:05 +0800, Yunjian Wang wrote:
> @@ -2661,6 +2776,54 @@ static int tun_ptr_peek_len(void *ptr)
>  	}
>  }
> =20
> +static void tun_peek_xsk(struct tun_file *tfile)
> +{
> +	struct xsk_buff_pool *pool;
> +	u32 i, batch, budget;
> +	void *frame;
> +
> +	if (!ptr_ring_empty(&tfile->tx_ring))
> +		return;
> +
> +	spin_lock(&tfile->pool_lock);
> +	pool =3D tfile->xsk_pool;
> +	if (!pool) {
> +		spin_unlock(&tfile->pool_lock);
> +		return;
> +	}
> +
> +	if (tfile->nb_descs) {
> +		xsk_tx_completed(pool, tfile->nb_descs);
> +		if (xsk_uses_need_wakeup(pool))
> +			xsk_set_tx_need_wakeup(pool);
> +	}
> +
> +	spin_lock(&tfile->tx_ring.producer_lock);
> +	budget =3D min_t(u32, tfile->tx_ring.size, TUN_XDP_BATCH);
> +
> +	batch =3D xsk_tx_peek_release_desc_batch(pool, budget);
> +	if (!batch) {

This branch looks like an unneeded "optimization". The generic loop
below should have the same effect with no measurable perf delta - and
smaller code. Just remove this.

> +		tfile->nb_descs =3D 0;
> +		spin_unlock(&tfile->tx_ring.producer_lock);
> +		spin_unlock(&tfile->pool_lock);
> +		return;
> +	}
> +
> +	tfile->nb_descs =3D batch;
> +	for (i =3D 0; i < batch; i++) {
> +		/* Encode the XDP DESC flag into lowest bit for consumer to differ
> +		 * XDP desc from XDP buffer and sk_buff.
> +		 */
> +		frame =3D tun_xdp_desc_to_ptr(&pool->tx_descs[i]);
> +		/* The budget must be less than or equal to tx_ring.size,
> +		 * so enqueuing will not fail.
> +		 */
> +		__ptr_ring_produce(&tfile->tx_ring, frame);
> +	}
> +	spin_unlock(&tfile->tx_ring.producer_lock);
> +	spin_unlock(&tfile->pool_lock);

More related to the general design: it looks wrong. What if
get_rx_bufs() will fail (ENOBUF) after successful peeking? With no more
incoming packets, later peek will return 0 and it looks like that the
half-processed packets will stay in the ring forever???

I think the 'ring produce' part should be moved into tun_do_read().

Cheers,

Paolo


