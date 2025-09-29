Return-Path: <kvm+bounces-59013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1AA5BA9FAC
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C51B175477
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06BB230C111;
	Mon, 29 Sep 2025 16:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AH/84x6g"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946B721770C
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 16:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759162413; cv=none; b=f6IpkUx/6fzM/eoSACfzT+EnRgzkf9BOB7YT4pFUjvuqmXAERuKLcR0l75vIY2a6X8gMnCCqCY2k4ziZsM5zW1vTh8lpfistGgCxXlRYnp0HXpKuofLY4aSYfCUB17iwtVvofCunxYcPOfHJN5AoT8C55qV/4RnnYdiK1xpxQsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759162413; c=relaxed/simple;
	bh=eTYKqm+CChwomxRyeWuc4/Slx4wTjDT+tzcawC9lkzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eFYU7q53lUt0xl4APrvkcIiBjfo8npiMjQW1I5rGN5F/hfOY1eejbvFJBxMxe47CXDug5paS9J2IKWULCCR9EaUAKw3flcEatFxDciJM+G/WZFYj8vFcB/sRwjFYs8JRbbk6FHP4dxrEYeTi68PLXtgOaY/VUumMZ8H2uFM+opw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AH/84x6g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759162410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=V5FQfi5+60+FYu1bBdU/dOdi8w4fRkHBNI51zjoQbQU=;
	b=AH/84x6g+HHVyu/LIKhV1Afnm74In7P55YlFBzPaSmtyWPJptd0CFj8N9wL0+vtEg34SK9
	jPqZw3NWelOuRsLyvNmi1pzbdGch9kzX91ld2dSlCtwkYjovkAiLNPyRK9WDZ34MlGcXHv
	6T98E5B/NMX7emkqMirIRbMm73svnvs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-J2sHT16BP-my7g68PUc_5A-1; Mon, 29 Sep 2025 12:13:28 -0400
X-MC-Unique: J2sHT16BP-my7g68PUc_5A-1
X-Mimecast-MFC-AGG-ID: J2sHT16BP-my7g68PUc_5A_1759162407
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3f42b54d159so3758200f8f.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 09:13:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759162406; x=1759767206;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V5FQfi5+60+FYu1bBdU/dOdi8w4fRkHBNI51zjoQbQU=;
        b=uEXqb2mW2l7xMSupeaqZHv6K4n4K3CKIm/JyaAM2U0TWu33AIomI1agcNuO9RDWohe
         /OXMI7T95QQW+zby12Fa+YkxxqWRhnCCuFlLbkG9I+c5oawuNJlAgid5hX8kOBTxVNFR
         X33R8S+ABQKQKWiYZwP/0JMtAV/54PMjSZD4ZZJsyE7leK5el+IQHOz9xYUKdkxRA0Js
         wj3DtqlKz9ZTTPK4Gq3GeAcCCrk8p6TbufYq3rjFIV0DyObyqVtCypqbEpKcPG+P/2vd
         mNMDEDwLhUf9n32M7qLl8ixqjfj4Kg8ylJZZ6+d8wTrVJKtnsTzrpnSea+8mO+cDpcLe
         Gdhg==
X-Forwarded-Encrypted: i=1; AJvYcCUz5+gusdV4ERHRVabo2kcSZlWKyvIEabk25E3YxxUOdC9+DI8brKo+yRmCtLfS1cSk3cU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1yDpbBnqdoVS4xP48UK7V0JIQ1dYs9MA2cqA9cDUeoqsPi3mO
	WcjbdePl6pWB8ZVLhaLNHe2v2PbZFO+wSKFvnaeGUqXPBlcoKCy3ZwPQEAiHJdARgK+QAqsWtUz
	0nwTx+r02I0Hm6L4eltK1R+py0y9ijL1J+oVtEDI1Mb/K6F6UfXLQCQ==
X-Gm-Gg: ASbGncvqMVWpbOw3d2zu9rFxywdDfvBLfXwpKDqv60iwLt3fMeJKL6gREKvDa8ra7jz
	sxsuDXAf2YABGAOyI1Y5MLGk0eSVzUqYQjhIzL9KcNnrlLptVeDBMbdDnoEb54wzRb/PW12Einx
	IQZKNu1HLA0zzK2IRYsO0mnQfYYrzmMofqNUtQaPrbPtW7ipJ1gxd7M+Og76zKFg4qlq1XP5MYe
	6yZM/obPAtrxuh066uyFytkisA3CAmV/mw+naZNZuhr84j+FrV92ufs01IY0KiYDioIiyN1SNp3
	Oz25A1JR+/G3VkAWvlpTvNOfESxzLJyXkCTAAXNaupKvk6zewg8sFj/8fwvq9CR4YYQeNo3XhVv
	WdyE=
X-Received: by 2002:a05:6000:2c06:b0:3ee:1125:fb6d with SMTP id ffacd0b85a97d-40e468e7375mr11782389f8f.9.1759162406546;
        Mon, 29 Sep 2025 09:13:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKpSH9fRflMsb1ojiq5LUNQpXmbTnkW3vSiA+dsRwDaRi0QYqZM24S/w/DhOGTZ1BCCMV2aw==
X-Received: by 2002:a05:6000:2c06:b0:3ee:1125:fb6d with SMTP id ffacd0b85a97d-40e468e7375mr11782363f8f.9.1759162406151;
        Mon, 29 Sep 2025 09:13:26 -0700 (PDT)
Received: from ?IPV6:2a01:599:901:4a65:f2e2:845:f3d2:404d? ([2a01:599:901:4a65:f2e2:845:f3d2:404d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-41f0c467ecasm6026435f8f.38.2025.09.29.09.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 09:13:25 -0700 (PDT)
Message-ID: <d6a3321c-1492-4c64-9341-8071659220fe@redhat.com>
Date: Mon, 29 Sep 2025 18:13:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] system/ramblock: Remove obsolete comment
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Fabiano Rosas <farosas@suse.de>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>
References: <20250929154529.72504-1-philmd@linaro.org>
 <20250929154529.72504-2-philmd@linaro.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250929154529.72504-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29.09.25 17:45, Philippe Mathieu-Daudé wrote:
> This comment was added almost 5 years ago in commit 41aa4e9fd84
> ("ram_addr: Split RAMBlock definition"). Clearly it got ignored:
> 
>    $ git grep -l system/ramblock.h
>    hw/display/virtio-gpu-udmabuf.c
>    hw/hyperv/hv-balloon.c
>    hw/virtio/vhost-user.c
>    migration/dirtyrate.c
>    migration/file.c
>    migration/multifd-nocomp.c
>    migration/multifd-qatzip.c
>    migration/multifd-qpl.c
>    migration/multifd-uadk.c
>    migration/multifd-zero-page.c
>    migration/multifd-zlib.c
>    migration/multifd-zstd.c
>    migration/multifd.c
>    migration/postcopy-ram.c
>    system/ram-block-attributes.c
>    target/i386/kvm/tdx.c
>    tests/qtest/fuzz/generic_fuzz.c
> 
> At this point it seems saner to just remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


