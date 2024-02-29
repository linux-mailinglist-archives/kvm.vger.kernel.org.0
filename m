Return-Path: <kvm+bounces-10476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B19A86C72A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 11:43:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2068B22C4D
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 10:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E417A708;
	Thu, 29 Feb 2024 10:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AWUcHtuT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F55167C54
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 10:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709203398; cv=none; b=q0ZboktF/kaU3yp+Qf7TV/KRNVu2U/sA/UodYkRgys3ZbdQe7Zgh65Voq5WwO5juoPUpP9c76B4gV1a3hRU4JKNUcp1zLybUMOMBhrACcCMpvxx4ABk/FKC85iXw0Onzw+2HwNfobIYX3FHRaPz7lPx/aCoMcwdjgsS+acT7kmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709203398; c=relaxed/simple;
	bh=G9inbGuH/deCfFlBeCV3+n6+eXPc/sQdW9zyYyvjjYI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DbQxVO5G+AcXraMrCthImiS1P7A/OenRZEjwoFaTztG9lG9WI0iXpPdcJgyvD214LlkCavLLWyTpf5JNQ+XkX+pcP1dVgzsZTDlmED66kLeVK0ZaYPuwtTjcTxwSlY+BN9SNV/DbCepA45s8PieZmXGPBivs+z7Ny6Ysw5TOLIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AWUcHtuT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709203395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jtYSKVHcGkmiG0WkHJQ0+oofirBnO53PO7FPiruqtKw=;
	b=AWUcHtuTr0TAf8wMKMRlJtVgLe5yJYxgA2tKCYJkaXH0iBzHe2HmKog3a7aF2YQz7R+MXN
	T9+Fa30KWkYrpgmEg0iZyt7tJ347MZO5ZmTf/Gm1uC2ohCAC7eTCrpKV2H/fm6wTIWcz8M
	fbZpY0yJJpHKY68Y2Z29J+kocb1f7kg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-vv4NmHt8MNCVgLmg1tJPmA-1; Thu, 29 Feb 2024 05:43:14 -0500
X-MC-Unique: vv4NmHt8MNCVgLmg1tJPmA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33d7f6b1c7fso159582f8f.1
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 02:43:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709203393; x=1709808193;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jtYSKVHcGkmiG0WkHJQ0+oofirBnO53PO7FPiruqtKw=;
        b=kc8vYFxzyyih/lXa6AupxdP17t5UXMJsKFmnTSItC3KBd2aq0a6mOMnYnPOiZP6tAm
         W2oSmA9bhoycMwkepSN/TLhyJz5WH4REKmIEL/II4wMtlLdLwdQUAz3LundgBW7+90hD
         zd6xLL/3jUYiuDOYGqpC4QECETAMiDZVgte8bQf/e4+wmOczUXKM5f2XGTB89sQr1mEQ
         A4CYHy7+C6pHmQ4BIi38eQt+8xDtnqzmjRBxR5krIV0oO/4H0kWuSR2jNOmo6vV0YF49
         xoB1RtOlM/MXoKjJNecp86nn776iv7EC8P+ur26eMVpYOd7EMMadYGEAveLVQNCp4rfd
         JCbw==
X-Forwarded-Encrypted: i=1; AJvYcCWU7/73rGE4Ef3uKOmgCzpl9a9THs7izI9w9Wp3KJztXotrc6+lxPaRo4qx7LxjKCd7IrPTP85Q2eEpdWiFoieCOHXF
X-Gm-Message-State: AOJu0YxCHfQQjfHP6Q/sd64N8kurDHoNpjApkJETEKjLolJOJGAainU6
	PIMeGETBWoLjE9wWzFoPcNw+57wmxYdtpWLPZs8Vp4rognDdq095DPVO60wNP/6onKZyjs53PpP
	JbCqooGkyRNYxNhKTonTbSLPzy6hX2NtMUpJVhqQO5i/55Un8OA==
X-Received: by 2002:adf:ff8a:0:b0:33e:1102:8fb8 with SMTP id j10-20020adfff8a000000b0033e11028fb8mr703879wrr.6.1709203392986;
        Thu, 29 Feb 2024 02:43:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGIsQvtvMXLWTBHNasSdylfrG26iPdNEdTVfkfPJFsqMBAtAbkCZmkCfiQwjA3h4qoQSvlUeA==
X-Received: by 2002:adf:ff8a:0:b0:33e:1102:8fb8 with SMTP id j10-20020adfff8a000000b0033e11028fb8mr703867wrr.6.1709203392618;
        Thu, 29 Feb 2024 02:43:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-250-174.dyn.eolo.it. [146.241.250.174])
        by smtp.gmail.com with ESMTPSA id e5-20020adff345000000b0033b278cf5fesm1393832wrp.102.2024.02.29.02.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 02:43:12 -0800 (PST)
Message-ID: <75b6f7686c03519a1aaeb461618070747890143b.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/3] xsk: Remove non-zero 'dma_page' check
 in xp_assign_dev
From: Paolo Abeni <pabeni@redhat.com>
To: Yunjian Wang <wangyunjian@huawei.com>, mst@redhat.com, 
	willemdebruijn.kernel@gmail.com, jasowang@redhat.com, kuba@kernel.org, 
	bjorn@kernel.org, magnus.karlsson@intel.com, maciej.fijalkowski@intel.com, 
	jonathan.lemon@gmail.com, davem@davemloft.net
Cc: bpf@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,  kvm@vger.kernel.org,
 virtualization@lists.linux.dev, xudingke@huawei.com,  liwei395@huawei.com
Date: Thu, 29 Feb 2024 11:43:10 +0100
In-Reply-To: <1709118325-120336-1-git-send-email-wangyunjian@huawei.com>
References: <1709118325-120336-1-git-send-email-wangyunjian@huawei.com>
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
> Now dma mappings are used by the physical NICs. However the vNIC
> maybe do not need them. So remove non-zero 'dma_page' check in
> xp_assign_dev.
>=20
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>  net/xdp/xsk_buff_pool.c | 7 -------
>  1 file changed, 7 deletions(-)
>=20
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index ce60ecd48a4d..a5af75b1f43c 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -219,16 +219,9 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
>  	if (err)
>  		goto err_unreg_pool;
> =20
> -	if (!pool->dma_pages) {
> -		WARN(1, "Driver did not DMA map zero-copy buffers");
> -		err =3D -EINVAL;
> -		goto err_unreg_xsk;
> -	}

This would unconditionally remove an otherwise valid check for most
NIC. What about let the driver declare it wont need DMA map with a
(pool?) flag.

Cheers,

Paolo


