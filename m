Return-Path: <kvm+bounces-43083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 196B1A84135
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 12:52:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6ABE1B666B1
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 10:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2575B281355;
	Thu, 10 Apr 2025 10:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZO5qvvk6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F8D26B972
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 10:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744282316; cv=none; b=d8InQNbXmTb/UNrp5KIblKYJCEh1NJVC6uEfgPWBGrkX5CMU0kjQ3naQtXLeBVpYCyJpSAaK0Ek2rf573IftS/k5hF5o8w5pwwoQYrgyoD6twhB6yniIMSdFDkXoFrYBEeDk/rIFpPptBjhHuniVje9WwKZMWfzFKccEiIqDPYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744282316; c=relaxed/simple;
	bh=Hu/dyNyMQiMt3jY/azDePScdyJcDtyMqgmW7s3RlZB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S0fbstVD4Bz7gpgJZ7KlC6jeN9CoB+Ptr6UpuGM9CKAx1kTcr5kT3UUGm6o08lx/oJY6cr/HBuXLRhl7AN98Y5/B6gTYpGihsrlzEX2AZXRvDP7ZjtGEUStspNt7BBgz9HawIs7F4TDCNX8ZNq7/XShFQqcMgIBe5JTtFXXpXt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZO5qvvk6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744282313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hu/dyNyMQiMt3jY/azDePScdyJcDtyMqgmW7s3RlZB4=;
	b=ZO5qvvk6YRpbS3miMHoM7UKOBe6NWBMDmykWsYHmuy4//i5/UfkhhOfVG9BdJzRP3Iw+39
	kmulXg56GL+8GU5Vjqoq8oEOltZrkg1fltHuDIM1RDXylMNxSF/+2lVMJcfIDm8UX5fyKO
	70Ot91iJSu4a8ogPGTs6+mIoLT15ssI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-VLORekxhOtKUGRaYtg23og-1; Thu, 10 Apr 2025 06:51:52 -0400
X-MC-Unique: VLORekxhOtKUGRaYtg23og-1
X-Mimecast-MFC-AGG-ID: VLORekxhOtKUGRaYtg23og_1744282311
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3912539665cso986016f8f.1
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 03:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744282311; x=1744887111;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hu/dyNyMQiMt3jY/azDePScdyJcDtyMqgmW7s3RlZB4=;
        b=IRUiN3nz84N5ykPqDDUHJagH3OZ2QYqrslh3QFk3ILNoiVvZ5vDrMN86qjdkvt28ck
         VWJxnf2Z4byveLFQLOrORYRoAztP9NRhzLMHy0f7lTtlu1UQ7QeBZRP06K6WpJaDYtDr
         UZcPesX1hAoWdi7r4upUEb5E6i7byKtQ7tBQhypJFZon+/pT3iAykW02UQsiW51YqA1l
         yyFVLy+4rYrkPM7TqnpyNQeZ9QStbnCHzqYqutj/fOfmnCZHPKrcl2DWBAyAprrD8wtz
         zf/3gr1ui+ra7pDdRMxWljMM8YOWcREIq8PUGDMoHexIwKk1Rp5UHwLaTu7Vi0hYX+nR
         fvvA==
X-Forwarded-Encrypted: i=1; AJvYcCVQCHj0Jq1xiKNGQ26qc+ZdtRya9zwi1kTJjQ0zzgV6QBtAnXddXkJpKuol/5Me6IaFFk0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyKUwmkzUZYug2YI9PgVWZq3NtMWq3kHJwEUzEElS6kEfGpv84
	UPZBvtvAMlPdK/PhUbOJkOcwTVyeAJB5B8uv4ZA1hRy8oc6p5sddKIYeu9kJcb33QcqBj+QPyVe
	cUJ9GmIbwyAubtREfHPyiXViU4B3N4++SaTbjGLYqX71BwOvHKg==
X-Gm-Gg: ASbGncuvdy2fd0n0lFmanLd2KRKamjqh0VBPNBXXaU1sTlajJCoM5zuOEkXLHweioda
	Mu0FH8IgcTOIv1JHAZEQz1Nv1ZeJGpAeKNcWj1U0pt1R4lptx/GRTeeHoPFYUizIpq6soN+goVD
	sDSDlF9/I/FGSONxMMLA53ci3BXjqzn6iEsvamy7vhyK28TMPFlGL1y+YaPhmaDO+D0mQW2MPHc
	dNSsXvcBxs6fU7qsff5Nsu2f8ELuPvZjd+tMnzzmZMg36CgaA3U6SvZMhD0sd6jJ6cHibdqfIa1
	R35/WyHOlarzu3IzwxaITqSc86I157ieFotpwIk=
X-Received: by 2002:a5d:648c:0:b0:39c:2c0b:8db4 with SMTP id ffacd0b85a97d-39d8f275fbamr1595323f8f.10.1744282310742;
        Thu, 10 Apr 2025 03:51:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/0IeDpLk+TZuwsPB4YIsabynndJrajxwaMO5dLlq7dbzR+E2v8IMog4+FmRDVWpawIdK9Kw==
X-Received: by 2002:a5d:648c:0:b0:39c:2c0b:8db4 with SMTP id ffacd0b85a97d-39d8f275fbamr1595300f8f.10.1744282310374;
        Thu, 10 Apr 2025 03:51:50 -0700 (PDT)
Received: from [192.168.88.253] (146-241-84-24.dyn.eolo.it. [146.241.84.24])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39d893fdf8fsm4359327f8f.91.2025.04.10.03.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Apr 2025 03:51:49 -0700 (PDT)
Message-ID: <22ad09e7-f2b3-48c3-9a6b-8a7b9fd935fe@redhat.com>
Date: Thu, 10 Apr 2025 12:51:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 1/2] vsock: Linger on unsent data
To: Michal Luczaj <mhal@rbox.co>, Stefano Garzarella <sgarzare@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250407-vsock-linger-v1-0-1458038e3492@rbox.co>
 <20250407-vsock-linger-v1-1-1458038e3492@rbox.co>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250407-vsock-linger-v1-1-1458038e3492@rbox.co>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/7/25 8:41 PM, Michal Luczaj wrote:
> Change the behaviour of a lingering close(): instead of waiting for all
> data to be consumed, block until data is considered sent, i.e. until worker
> picks the packets and decrements virtio_vsock_sock::bytes_unsent down to 0.

I think it should be better to expand the commit message explaining the
rationale.

> Do linger on shutdown() just as well.

Why? Generally speaking shutdown() is not supposed to block. I think you
should omit this part.

Thanks,

Paolo


