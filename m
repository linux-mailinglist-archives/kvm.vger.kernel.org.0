Return-Path: <kvm+bounces-66707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 78D58CDEC58
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 15:46:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2CAE0300EA26
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 14:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47FD02192F4;
	Fri, 26 Dec 2025 14:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AHhiemlQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TSJAAihn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA96BEEAB
	for <kvm@vger.kernel.org>; Fri, 26 Dec 2025 14:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766760339; cv=none; b=copCyUPwH5YZtJWQkKrcFApQmMaAvOl+sXB9o5Mbmnmew9f8a8y+v6v8FdWXNvN7CmCr05yCKFTktr9/q2LrLyGq6oFmmvKffmWXOVopgbix6vD3OWey/Rvt/pr4M8ER7uSXlF9cvpuLGPxIaxEDsrQ3ATL3vJieTw2nOdk1Vpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766760339; c=relaxed/simple;
	bh=SXTJEfUAsxpmV3Y9FcdDE7mD/TcQYNGaO6iokuni8dI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qnsOoiiFfs9DMl2GNgMa0YQCTdWT15nVNP7Dq2MGbLCf3oE81qc6cgmVvYlWgt2DUSWfqcTA34XpfdDNvUpWO4gLBalSjzmkuj0hCKhPTbcfqR1063iv/1gXLxAZovbL+y8GorERtvltSa6RymMcZdY2wbxQ8hRr2XmBZl3RTpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AHhiemlQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TSJAAihn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766760336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VE+XQJ2ff3BxHjYIGcw/EM6UwUrFo+tFmbt/xfhwNvE=;
	b=AHhiemlQMTavEwdSeHgW4o931O+yueeazygL+zSlFTrjKRHuhnAaSYFh/hNBWKy5Gs2IyD
	KRbOfO17xHwTbqNupr9rZDOPDvwsAUu3gLXiXNbVENIMxjdIMWGBhHNcqrvm+N/ScJlMwd
	bKddebKIoD3/0OKNVsgGdze3RfbIETI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-qnGfk4CWNgC1ymbZvnv9-w-1; Fri, 26 Dec 2025 09:45:34 -0500
X-MC-Unique: qnGfk4CWNgC1ymbZvnv9-w-1
X-Mimecast-MFC-AGG-ID: qnGfk4CWNgC1ymbZvnv9-w_1766760333
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47910af0c8bso48862455e9.2
        for <kvm@vger.kernel.org>; Fri, 26 Dec 2025 06:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766760333; x=1767365133; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VE+XQJ2ff3BxHjYIGcw/EM6UwUrFo+tFmbt/xfhwNvE=;
        b=TSJAAihnLrmbbIuDaWv3hDWOW+9D5An2Xb9nWxaXqjdpDbMs6jJXFNYGko9tQMwg5C
         yDv5kI8htzJFQZMjJs7zViAkhV+kwTJPEbS9Hre5wQhA0OUwQDWFG5W0pPvzoyYjfzzo
         q3YqTmnDCY6V79J4vAYMB8SYIVeZSiz5E5NxMNqlltN9dSaMsepEXSufGcmX3c0V5hmA
         9QDVZpG75thx3YmXlpz6hN1LKtf9VCsUWC5okZ/lhT+QK0wXARHxVKKhF3i3uErhL2NG
         JOW9lMaJDvpywJjPiT81WH6ktDPUoOZDYG2NBdpl0w5wqU5WSv8galHE/TzZs1sZTO6g
         vPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766760333; x=1767365133;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VE+XQJ2ff3BxHjYIGcw/EM6UwUrFo+tFmbt/xfhwNvE=;
        b=rSZ7GCtvZ/PaRsuq00UMKxRX323OhqXDrvpXiKtX9cSZ9S9xgqJOBE+3UwLsguqrP6
         YySfIgHmxXoTYxogNzXIALUXV1K5/w6IADyVqIzb/P6ikU7R5tZIJygzZQqZIWDEnGeA
         HKBid2z/SDcf0NnfXPxTffNFqoZiMCi1dzABXgkfYY6vabV7iWuE9FZZeHihLF+rU8Hi
         hpXqzQQAS2S8QzJ5PBeOlPkUKVQ60MqTAwVePLTQgQES/eEWEKGaw3O/MqLNaK+CwUZo
         KBht13ZWIoCYzGk6GMg1ifaiRFwG7nr4Fm/MwPVNNySxZdnYYAJmzV2VTCOCqhZtH0vZ
         04dQ==
X-Forwarded-Encrypted: i=1; AJvYcCVv+WNDl+ZXD4tJLYr6ZYKVz8HuJG6C2CnKl7EwqZl6ihaB/vTlnnAdt1tVH3dHhP9B99A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3Ee9w6Mf0anVcYaNZa5DcI3YHzu7OzDfOsY1wQqYCSW37CmCc
	aJdHK1nddfy77eW0aXPzzIe0wz4xtGq0y2agAbxj15PzmkiaLo1+tUaWcJxewZz4v6G66L+3na3
	5cRPt5znIlRIxY8upoamhE79ICaql5hWhxcTyPGpYYB60cJvvopRpug==
X-Gm-Gg: AY/fxX5xWCYacDXAepcUXd3uSeT1rvgMMV1rWcMj3C17rmR4p/FO7K4DyqKzVyF5niM
	KEQronw0fP93weSGt7DLf6IcUzPLXArSY4UNxc9wap+ZIBPSiaY/e/FBOA21EjpIXAxt4xexGZO
	wtf5llS3X3578PHaQ8JNcUzXPG6CSut8jl8ankix6y6LIrFOdatgUXPkcesAXq0yPX+V9aWTxv/
	9NOqQORkEwX8/9WHa+oo6k7+hJ2iXfpeflNB7CsFS1aUiRKdg1tdF1QXOfaXEffroy1LApn8qIK
	groUk+rxM9gmA5/zCN7UC7dSuj2Kp+P1NAiVTs9KV616+IHK/PmZvQ2JOu2W1cwX4CR/moWYvpi
	Kzd0fI8moJYThrHUlBPzy3ftXbFsGuduJ1A==
X-Received: by 2002:a05:600c:c0d5:b0:47b:da85:b9ee with SMTP id 5b1f17b1804b1-47d1c038cf9mr223419855e9.31.1766760333201;
        Fri, 26 Dec 2025 06:45:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGUSuOL/+Z5eImF8z0Stqnf2VAFdjsiKConmHMyX/icJjMnlpwTCTDNWLhP2RjMojF/BX4/hQ==
X-Received: by 2002:a05:600c:c0d5:b0:47b:da85:b9ee with SMTP id 5b1f17b1804b1-47d1c038cf9mr223419615e9.31.1766760332788;
        Fri, 26 Dec 2025 06:45:32 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193d4f09sm400673295e9.12.2025.12.26.06.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Dec 2025 06:45:32 -0800 (PST)
Date: Fri, 26 Dec 2025 09:45:29 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bibo Mao <maobibo@loongson.cn>
Cc: Gonglei <arei.gonglei@huawei.com>, Jason Wang <jasowang@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 0/9] crypto: virtio: Some bugfix and enhancement
Message-ID: <20251226094413-mutt-send-email-mst@kernel.org>
References: <20251218034846.948860-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218034846.948860-1-maobibo@loongson.cn>

On Thu, Dec 18, 2025 at 11:48:37AM +0800, Bibo Mao wrote:
> There is problem when multiple processes add encrypt/decrypt requests
> with virtio crypto device and spinlock is missing with command response
> handling. Also there is duplicated virtqueue_kick() without lock hold.
> 
> Here these two issues are fixed and the others are code clean up, such as
> use common APIs for block size and iv size etc.

series:
Acked-by: Michael S. Tsirkin <mst@redhat.com>

but you did not CC maintainers, you really should if you want this
applied.

> ---
> v3 ... v4:
>   1. Remove patch 10 which adds ECB AES algo, since application and qemu
>      backend emulation is not ready for ECB AES algo.
>   2. Add Cc stable tag with patch 2 which removes duplicated
>      virtqueue_kick() without lock hold.
> 
> v2 ... v3:
>   1. Remove NULL checking with req_data where kfree() is called, since
>      NULL pointer is workable with kfree() API.
>   2. In patch 7 and patch 8, req_data and IV buffer which are preallocated
>      are sensitive data, memzero_explicit() is used even on error path
>      handling.
>   3. Remove duplicated virtqueue_kick() in new patch 2, since it is
>      already called in previous __virtio_crypto_skcipher_do_req().
> 
> v1 ... v2:
>   1. Add Fixes tag with patch 1.
>   2. Add new patch 2 - patch 9 to add ecb aes algo support.
> ---
> Bibo Mao (9):
>   crypto: virtio: Add spinlock protection with virtqueue notification
>   crypto: virtio: Remove duplicated virtqueue_kick in
>     virtio_crypto_skcipher_crypt_req
>   crypto: virtio: Replace package id with numa node id
>   crypto: virtio: Add algo pointer in virtio_crypto_skcipher_ctx
>   crypto: virtio: Use generic API aes_check_keylen()
>   crypto: virtio: Remove AES specified marcro AES_BLOCK_SIZE
>   crypto: virtio: Add req_data with structure virtio_crypto_sym_request
>   crypto: virtio: Add IV buffer in structure virtio_crypto_sym_request
>   crypto: virtio: Add skcipher support without IV
> 
>  drivers/crypto/virtio/virtio_crypto_common.h  |   2 +-
>  drivers/crypto/virtio/virtio_crypto_core.c    |   5 +
>  .../virtio/virtio_crypto_skcipher_algs.c      | 113 +++++++++---------
>  3 files changed, 62 insertions(+), 58 deletions(-)
> 
> 
> base-commit: ea1013c1539270e372fc99854bc6e4d94eaeff66
> -- 
> 2.39.3


