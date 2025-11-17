Return-Path: <kvm+bounces-63333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EE931C62BD2
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 08:35:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7C04D4ED497
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 07:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294E8318143;
	Mon, 17 Nov 2025 07:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="wYHuu64M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E5035CBB7
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 07:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763364733; cv=none; b=mk856fv7MMqGAxc8UHveDWbJdBJGS7z5R/7ioB2GoCmX3Iogxvc2IoHwY6WkT3NabhDnEi9mbcRVDp6rYx6mvbJHQ0jezwqnIKhNyalyx52T+Td9AOD6E4/mC3cwzYBsZcyO1t4TgkkrbR8H+K1s+At5LlBpt2sX5Gnv3cUz58E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763364733; c=relaxed/simple;
	bh=YoV/7dSf69+guJ8u+9SV89QGhtMlNWEqjZcrVMCNmI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MlFDPzbqoD91/NIvnqvM3l2v+azl3i3AxJcl8R5Q65HkkenoC8UTQ0rG+9hB9oUOmUD4TBe/TmVWgM7MNAShT1S6epPzdynB6/3e/APgIvqTAsZyc6xbSpJN+23TXpDHkcOga/sbwkpn5Us+oOLQrxJGjVbNM4W3v2KmMYu4WcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=wYHuu64M; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ee1879e6d9so14779201cf.1
        for <kvm@vger.kernel.org>; Sun, 16 Nov 2025 23:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763364730; x=1763969530; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4p8nfBMplL1MMFjoLuwTkabV7IoOO9xmiP0+6aCowlY=;
        b=wYHuu64MM9IzLOJShOgHn5TtTmS43L2fNnzbFutBzzR0WZzY6oDK5F1bipJ2zWDj5i
         ofsn3sXcDsZQ+BcBCGBdpvNu+I4kf1x/MNaYxW/DSf5xO0kZOFqrD7R/z8ZvIkQ5any2
         VkkBUQPtrGzTxjCz0dLQg6Smb7agvvNT3aSAwZhg2YK54WobtRNUKJTeGJLHsN5Bltqa
         /69Qln08hOStUmzD5T6iLkD2fX9EsrXGb4TCECC1nRrVJSAhwYwYB6mzU7i0rudXSizd
         N7GpwrKzkFAFmX1JdLdrDtyT1hLNseBOkbQm0Vq/reCHc9IAYUhzgWSWx5rEafHGBSrc
         GdzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763364730; x=1763969530;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4p8nfBMplL1MMFjoLuwTkabV7IoOO9xmiP0+6aCowlY=;
        b=cOz4NdX1tk0z1XVMoxxwIni80qE6mGjyUrPeHfwgt+fHwbRE93iKaA8qYZCzQrKSaK
         9PORvQq7wsKBqB7AtTEzYGlL7r7xCNVBkvJfykrN4+WXPB9jUtX7LDfBRrxSc9IDppdO
         S8989wtYpC30vsPeM/OwcZOu5dogfIAB5/hw5kct1R3MyCgvNdigEo0UJeO94NckpCv+
         DVUOD2/o+COhFMQBW0nCA3yteK+Jk3g2OyolZDR5LBuX3nf6XVhXC3EI7zxIYcsodFUa
         ik2BA9ryHq/0jKc7clIqu7iOcFSJ+DwPAGXY207+USE3fybHLgDxws9QAS82qicqdWic
         As8w==
X-Gm-Message-State: AOJu0YxBcV6T08eANRC9PNkG8PP2e0cFQVOlzU/WpWdxyWlB7qsd+Jbh
	khrV5mpqfyjtTue6uEJ28ItPcrkfUplxqphFWJ02OcBKq5ps8ub6EAqiEJzhfiQLpEI=
X-Gm-Gg: ASbGncujNveWFVhKC1zHN8DunQKZrh1iqwgHfiTn1Zdwrx8X618e7HN9cjVabyOCuhw
	C9ghOkbh2nuAbpyopiMl6CYXcuGL0KSJBV+mAJE9zxpngRGNPnr+QyalWpGje89HehbQOHAkyRZ
	N0Ps2j7W5TtfuNUPSLAcGbjVRxOXX1B3HBu8p3lK8DMRrbC8YT23i7wMsDHtkTQ/1HSi0xojidq
	mwPcRHV3rXG9TS1ilGmyuHXvp7c6uj9dB1NBL/iO+4f7zn3W0hgV2ZtYk/9zmCMFZx1Ep0RixLC
	LqulVxJo7ZxUNZf64z7r9+dGjcHQo7xboMP62UP8yRDn/hJ9ORO57GvuUTjFu2NQsXQZ/hBsgEF
	3YqRNcVRIpYtWXpmjj9XaBWK+y+GnvVCt2UEx3nMchmD8D7LZs/GRTvHUZUMWonsJFECgKuLnYX
	vyjiyPpC7Q8IwgM6Ai6SLOyMlMR+SXtUULs6EaJtvyucLuoeGD0oa6pXnUrp01sQpIbxBmb0mA3
	iA7yqeKdaaPn/efkQDuxE3bp8KzALzJT5wfrO/0+vdp+g==
X-Google-Smtp-Source: AGHT+IH36/RlucfVUFJn79UZhVqr6Oxrguj0dhZDGZoV2D87KD/l4v1AnyEXdu4Z27GsBFvDrUo4fw==
X-Received: by 2002:a05:622a:1aa7:b0:4ee:1913:9616 with SMTP id d75a77b69052e-4ee191398f0mr56268111cf.51.1763364730290;
        Sun, 16 Nov 2025 23:32:10 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2aeeb2522sm921823685a.23.2025.11.16.23.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Nov 2025 23:32:09 -0800 (PST)
Message-ID: <aa192757-f6be-49ca-a2fb-38b9784c255e@grsecurity.net>
Date: Mon, 17 Nov 2025 08:32:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 18/18] x86: cet: Add testcases to verify
 KVM rejects emulation of CET instructions
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20251114205100.1873640-1-seanjc@google.com>
 <20251114205100.1873640-19-seanjc@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20251114205100.1873640-19-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14.11.25 21:51, Sean Christopherson wrote:
> Add SHSTK and IBT testcases to verify that KVM rejects (forced) emulation
> of instructions that interact with SHSTK and/or IBT state, as KVM doesn't
> support emulating SHSTK or IBT (rejecting emulation is preferable to
> compromising guest security).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> [...]

Successfully tested on v6.18-rc6:

Tested-by: Mathias Krause <minipli@grsecurity.net>

Thanks,
Mathias

