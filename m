Return-Path: <kvm+bounces-66213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AD32FCCA384
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 04:53:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 781A730185C4
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 03:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F9B2FFFB8;
	Thu, 18 Dec 2025 03:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QK40YqQ3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="k+e+s4HN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161332EB5D4
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 03:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766029980; cv=none; b=Vn8pcHxjGGvUAY+VQpCgwmsbT01cmboZ2qxoG7vtM5Frotj+qv1jDtabQB8WBHvFm0gg1TUJjOBBOOXqn7RTD7ER+YXt+VAPxqpkNIs81PngFdyU0Bp33MRUWnixDJtX9NEuBF2dVEoq7JkWgerNQjkjl1ekVQdaktllLeXgZHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766029980; c=relaxed/simple;
	bh=QMWBJBUexqbwWDfCPvN8knkhyI690YN3Qu8L+4wssTM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WbxXy/QYrkeTpvneVStwMi+lpuVGoKngc6lf8jx1bGVUdnlKoSL9W6pxyaukoNU75vvb4RzpShUQeGAp0DOtofVJRBfpEBU72uUV/ewd3cm0bucdOkRaXnYakPWnAahQ25A0cB7XiJe+iPUFFryUFbGGRO4Qp70rHlKtzVEnAtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QK40YqQ3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=k+e+s4HN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766029976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMWBJBUexqbwWDfCPvN8knkhyI690YN3Qu8L+4wssTM=;
	b=QK40YqQ39mPPKK0GAiQv6RT4DB7A0rVH3wbASKq+8q3cUBfjuMhLXQrAIwlBF08HaJnm9r
	oZYJZ6y+jZyp11E8QTt9CdWIRoWeJ8OWHY7KPbO7kJvy9xtcjhUWsm5P4MBz5iSd7IJE2Y
	X2NeFlBHPquo6qDCrgNCIQeyG0lX0EI=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-i4RnkMimOae6SqhucgaA4Q-1; Wed, 17 Dec 2025 22:52:55 -0500
X-MC-Unique: i4RnkMimOae6SqhucgaA4Q-1
X-Mimecast-MFC-AGG-ID: i4RnkMimOae6SqhucgaA4Q_1766029974
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a0f47c0e60so5263105ad.3
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 19:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766029974; x=1766634774; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QMWBJBUexqbwWDfCPvN8knkhyI690YN3Qu8L+4wssTM=;
        b=k+e+s4HNnZewU/pX5QWpphFgZNQnFcYBTaNVpMVZctsfx918Jny2rX2lMe07sh93w7
         MNZxOWBt3AH04y6Yw5MgM73QcTXHs3UwqQUZ5l6UZo3V2LrBMTHgjb8rkAjrsD42Hoh4
         THK8dAXe3b9kwMoyunySKb0qOwyKjyocY1SxzIL8jDn8NAtfmQqpFNgcWHNeM86aSSkd
         gPw1y7hh82DYhbfUM2fDCLITX28gqLwwsSP8eTnN82a5+WDTsAeVnWQUs+/8LBZFXG+J
         KsgNbtQTwOhubNL2KlJQXo1nzdcQI1IjnKVHFrxRvhcSabSiFvE9rQMX/AXIkKuwwckj
         Q+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766029974; x=1766634774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QMWBJBUexqbwWDfCPvN8knkhyI690YN3Qu8L+4wssTM=;
        b=Yv0FTCs7a1PCmGe+CJpTJM/7rHe0ZP8I830PdMzT9BdKmMcBXHrYklmzmK/9FmqzV8
         3LfXZ5vJYTufkthWns3nqRbO5du8yr5dUS7ek4w8750ywXBqcBXm6Imbg+x/VOB1ZJYL
         8akvU5oVq7imAd66xLatCiHz/MjHp/kB/ZzcNjzLUyrzvtEV3XY9tlrA02t1Ifmt61UC
         j9sil1P+P/srP7KXuTZtOdxpd9rLR7qnLe+9wBFTDdSjav0aGs0BVxyXlyU2+vdrtS5T
         V5m+mny+BMwueTquQaKACe8yE+T2NMa7jOWV3lB9fqi839CZll5j9KWhOIxYXQIWGsBO
         An0w==
X-Forwarded-Encrypted: i=1; AJvYcCWmdQZsbh91EpD3QeQdyAG43aA/SgsTct+ti2arNvPKvfYUg5N57QSSLmXU4o4Ro9aymiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAITDEoX9fuIc5JPPixQtxh7c4OVFvnX5gPkE/zohB+yZIj5Qz
	7CUiRu4lpf3UXymxIzDjVuWXbFWz9RZjrEpfNlUh1AkHSqz6Wva9YtAsSn6MZZ0b5kXxt6DhGKf
	nYdi6Z2GErC2PeFDmkr/pdHKZIEaTTv7XF69JEuU931WPB+xNiVn4y94W+/QHOh2Hrp9/bOmBYS
	B8uO3tIS7M/XnWx6hTFTiDertW6vPr
X-Gm-Gg: AY/fxX75208LeWU821o5W38XdX0yoxtNYVUPDYoCQguAoFzd4Mequ15pyhdXpy7KnJ1
	XMjz2O6cxxX3Ubnq8AOgEABMyyIIdBc8VhWKpCBIxLT5dR9rk5nOR0T5VeB9nFCx0cqIO9Ob6IJ
	AK6VL30fTMpsLM7JmEMX89QyuLXyxsfd6r5aoqPng2z+6Vv7VGy1+w5LtpzKvCwo2rnMY=
X-Received: by 2002:a17:903:1aac:b0:298:5fde:5a93 with SMTP id d9443c01a7336-29f23c677edmr196912305ad.32.1766029974606;
        Wed, 17 Dec 2025 19:52:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHw9DNEwmWjxWfi+F7K4n2BB/diI3M5uZKNjbX0bS9zDqcVCQPXZbRoNc0uTilQyHet8P2VB9LVOiFRTvTgn7U=
X-Received: by 2002:a17:903:1aac:b0:298:5fde:5a93 with SMTP id
 d9443c01a7336-29f23c677edmr196912045ad.32.1766029974179; Wed, 17 Dec 2025
 19:52:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218034846.948860-1-maobibo@loongson.cn> <20251218034846.948860-3-maobibo@loongson.cn>
In-Reply-To: <20251218034846.948860-3-maobibo@loongson.cn>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 18 Dec 2025 11:52:42 +0800
X-Gm-Features: AQt7F2qn7yrgQLTm-jx-zOUUwaHI5CYNjj2jNdNQeouWQKRiXmdxNRu5gCHge8I
Message-ID: <CACGkMEv-zTNkyxQHx5v5FGZE12SHib_73Lf10wF50_7B1WrPbg@mail.gmail.com>
Subject: Re: [PATCH v4 2/9] crypto: virtio: Remove duplicated virtqueue_kick
 in virtio_crypto_skcipher_crypt_req
To: Bibo Mao <maobibo@loongson.cn>
Cc: Gonglei <arei.gonglei@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Eric Biggers <ebiggers@kernel.org>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, stable@vger.kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 11:49=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> With function virtio_crypto_skcipher_crypt_req(), there is already
> virtqueue_kick() call with spinlock held in function
> __virtio_crypto_skcipher_do_req(). Remove duplicated virtqueue_kick()
> function call here.
>
> Fixes: d79b5d0bbf2e ("crypto: virtio - support crypto engine framework")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


