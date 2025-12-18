Return-Path: <kvm+bounces-66241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CE6AACCB218
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 10:18:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4D1DC3007E5D
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5BA3321A0;
	Thu, 18 Dec 2025 09:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EB3tDm4J";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="k7Dw+IfW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC20132F74C
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 09:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766049506; cv=none; b=OWAr2h799pHBZTJvOGMaZZ1aeKoc/A8Peun2hHNkaoZGIEPB76SetzYNNwvdUKIFChF50k+LIHRiD48Z0F27eEBj6Ancz5NlErJ/0jg0n+iaX7fv9yB3CMR2NcLzMMaC01uYmFokf0bwx6NeqHVj0W1V2aa0MlxqKCitWN2BnvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766049506; c=relaxed/simple;
	bh=RcOUD8PizUrveNi2sWL4N3Or/VKczgaKQcnCIdRnJWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lHZ2JwadNtpJxwnX0wsUR2IE0eUo/048G/6e78kzbPtGHlKS0rh9tuQ+1ZHbr3RQEMzM3XBnXmja/jCjUvFfAOkWrHoXPw9FbjaQEgWDmD/CMtNrGyxuFba91p7+mSsilBBUecE/iwp2ZGoP5P9OWlqn2kLjUP1wzSw1QaIj8ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EB3tDm4J; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=k7Dw+IfW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766049502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Y8NO7Mq1adk0vM4mhl9J4FEFJM+mdoyo3nQIjYbenU=;
	b=EB3tDm4JY8MY1aVhp2m2CBAiydqbrcQ6UQeJZWjmtYCbthCU3iem/g0r/TzW2Vi+FJfU5W
	OMK41/LocpLByTUnLrUzz8bmbhQ5Kt08DbSKiF3TkAXisJan5YFYV9x8BZZLQDOKDH1lyQ
	Q4drll3UQYjQrfnF4Wk8KcIhoZFdARc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-w7OL-TalOy2xXb9Mk8RcUg-1; Thu, 18 Dec 2025 04:18:21 -0500
X-MC-Unique: w7OL-TalOy2xXb9Mk8RcUg-1
X-Mimecast-MFC-AGG-ID: w7OL-TalOy2xXb9Mk8RcUg_1766049500
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b80055977feso31685366b.0
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 01:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766049500; x=1766654300; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Y8NO7Mq1adk0vM4mhl9J4FEFJM+mdoyo3nQIjYbenU=;
        b=k7Dw+IfWb1kqVhtXzK8A1FL03Bs/ainTdN4ayaLw0OOuQrR0QRpC0a2p1AnCEY3vWa
         /symouCWpAs3jCanR2+9VWhqDTKgLhJmTbBhdDkK/WmQi731ungqYCb+zVzh7JxFh4CW
         Iijp6LW8C2reUFKko4WGUG9/KBRyrLZU7GLSgHOxVlalBCo/Y98ZYO4j/V1ZDRsDRPyq
         P5vzhCy36Il5UT91E+8Grw4qgupQz+rfCDlwYg4lAIRhhVRTCX0x3K13fVmpxuE/L31T
         M8TVzRRQj7Wlv0hg6zRQ6MEOnqMtmQWMKVwFbnUnEtBps81i/JmiGeASlT5HF0Cf5foY
         f8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766049500; x=1766654300;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Y8NO7Mq1adk0vM4mhl9J4FEFJM+mdoyo3nQIjYbenU=;
        b=AdyTxvTTWJp2fdpgsWXQsIHT+yKL45R5d99cP1AfYUJhQxG9eXiMsxPE0Qlwgavmcw
         eCCw3g5Pfc74H+LV1s2/Xshhs/ecPwNM8mk2dRyIeitci3TZuvcIoMOSVnNC4lh/xD9k
         pJu/QSjEHiwScBMYNdUcS5TGSyymxIi5Ryl/z0orQklG3Jmn/I/gc1r4WRwHJWvNy9Ar
         /hoCv/B9V0UgB+g+zZffqErRko7lFsJ7ykZyc5j/Y6R8IQD5o9z0fEsKCWtrCoPRLJLk
         VFP5tzVWXrehhkhYeho0Lls02+QBtMRvFSMoLISwepscwW/g6CCO2zDmH14Yrg4asRJM
         stZw==
X-Forwarded-Encrypted: i=1; AJvYcCVFBZ/Jag8ak58WlKAdN1kBt8xoUshxrG1Cb4h8cgJpH3p3f6bicocP7OHWrhGUaV3TjeE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKKQq2YkcSa7DqlzZeTUESXJwlvOk78v0IG+BbEZr4ZhfhgQJn
	yQiWst+YuuBfxbAB/nXMMQ5RFDW5nktSxdnwOCUcBROTODyLzLl2TFtjt/tJL7Q/ah8m/HpP76B
	/zPh08zY/puSe9fjo2otOM8sXucDCT85dKqAhdKEAg4d8MRYxe85FLA==
X-Gm-Gg: AY/fxX5f7Wv89nHdn761tyR0GaoIdoGtB5KIJrWSkhF60Wczv7An/cyN1SNRGnxGlOo
	qhgw/hkb44Kn7qghgsxiqQCz+LQqg/Sq9BaiHH6M8euD2mDmQdLCdXLY/eu1qZYiOb5Q2mMmOiB
	7sHEimex7Vt/7TkSrP1LLyB5lo+DY/HTXThyFzF93F6+Qs8A6PrDGB2/UZH2QkzjxmSFMeqhJm2
	qNchDTW0bb3l/XA86vxm9VFF3E+UH4d3FLvEApcgSTZH6bzOFWnq89moWdIw/vulON+AUj2ldpa
	vnttuU/hYZofPlpbpbrkpkeMnc0pcOGXLEOmx6iDdTZ+pEjLQ97nf8uPxrGIeZp52WP5dCn58JD
	GHB263GVoqck/LFs=
X-Received: by 2002:a17:907:9494:b0:b76:ece0:368e with SMTP id a640c23a62f3a-b7d23a401cemr2117452166b.47.1766049499926;
        Thu, 18 Dec 2025 01:18:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEcKL+BM+WSBzW736mQ01Q9Qz517mYVZpBrWNfzO0M26INZM8AbP6Rm/+n3aYe01EJOghEvnw==
X-Received: by 2002:a17:907:9494:b0:b76:ece0:368e with SMTP id a640c23a62f3a-b7d23a401cemr2117449966b.47.1766049499454;
        Thu, 18 Dec 2025 01:18:19 -0800 (PST)
Received: from sgarzare-redhat ([193.207.200.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b585b52afsm2060402a12.7.2025.12.18.01.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 01:18:18 -0800 (PST)
Date: Thu, 18 Dec 2025 10:18:03 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: stefanha@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, mst@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org
Subject: Re: [PATCH net v4 0/4] vsock/virtio: fix TX credit handling
Message-ID: <xwnhhms5divyalikrekxxfkz7xaeqwuyfzvro72v5b4davo6hc@kii7js242jbc>
References: <20251217181206.3681159-1-mlbnkm1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251217181206.3681159-1-mlbnkm1@gmail.com>

On Wed, Dec 17, 2025 at 07:12:02PM +0100, Melbin K Mathew wrote:
>This series fixes TX credit handling in virtio-vsock:
>
>Patch 1: Fix potential underflow in get_credit() using s64 arithmetic
>Patch 2: Cap TX credit to local buffer size (security hardening)
>Patch 3: Fix vsock_test seqpacket bounds test
>Patch 4: Add stream TX credit bounds regression test

Again, this series doesn't apply both on my local env but also on 
patchwork:
https://patchwork.kernel.org/project/netdevbpf/list/?series=1034314

Please, can you fix your env?

Let me know if you need any help.

Stefano

>
>The core issue is that a malicious guest can advertise a huge buffer
>size via SO_VM_SOCKETS_BUFFER_SIZE, causing the host to allocate
>excessive sk_buff memory when sending data to that guest.
>
>On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
>32 guest vsock connections advertising 2 GiB each and reading slowly
>drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB; the system only
>recovered after killing the QEMU process.
>
>With this series applied, the same PoC shows only ~35 MiB increase in
>Slab/SUnreclaim, no host OOM, and the guest remains responsive.
>-- 
>2.34.1
>


