Return-Path: <kvm+bounces-45025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 999D4AA5A09
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 05:43:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64DA49E1593
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 03:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41103182B7;
	Thu,  1 May 2025 03:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ObqbPHCH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14CB230996
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 03:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746070983; cv=none; b=kV1+jWWnWNWobdPNXpyT2Nj9JuLMUYIAC/GZy9dqb/2IsKiiAZ+IW1cZ6QcZFP/MfAIzC1nNlxCH1o/TQE0eOC1oD8xGNuHPkS0b2gqAsv8wf9pgtJGRyM6/dAf3SnMtd2j5gINMBzusRAPuQoje61GhtxDpM0nh+rjmNltFELY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746070983; c=relaxed/simple;
	bh=rCfk93JTwE7IksYYV61B6JuTCbu+HHdPHtJEQpV6aCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BKnG50gVIeJXJG7H5tU6KEvF4rntI9EUO8kTd2t7jpsNWx2O5xsC6wu16KjJhu8OgnDboX/X25dEV2Dc26d1IoXLBd+FPW5YpTIaRQpsto0PPQJfX1enZRSpD7eop8Qzcw2bca/HC8KAly7f73jUTqa/MYlLdsRE9Gkc61r+XL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ObqbPHCH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746070979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JC4AbsVCdLJ1p7UYeSXewTdrjDsKeZ54RhtL8jSgmm0=;
	b=ObqbPHCHqFTS2s2ebNC+6x7vAV1gyqIjHVARis6Waxf2gt9AapSfPFK5rMFMayFmp2YnZd
	zXAYtzvBO7FDx4FJ/TFjp4/jYgr6/4WTh4lswMVVZfzwNKeaKOuA4EBq8Sq9Re95zfV3h6
	IKf36gROdmifLfC2OwxGZG1/i37aAUg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-6odwNiyVOi-L1pIMq65iuw-1; Wed, 30 Apr 2025 23:42:57 -0400
X-MC-Unique: 6odwNiyVOi-L1pIMq65iuw-1
X-Mimecast-MFC-AGG-ID: 6odwNiyVOi-L1pIMq65iuw_1746070975
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-22403329f9eso4247955ad.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 20:42:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746070975; x=1746675775;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JC4AbsVCdLJ1p7UYeSXewTdrjDsKeZ54RhtL8jSgmm0=;
        b=ZAhhcW9tAFGi/QLJpcYwr/zYHYAP2QOv6kz/U8aw5Q7ugFt5ADK6bjyFihAwJPH4ul
         pMlnsl5qNEvybvV2OvhVG17/AHKcfHZzRJrQ1+jOAbQZkNrK2AClP4B3K7DAWoEe+DSO
         QD5E5DrPQspv8yhGgdATbVhnr+qfqQg4I89FXsAiy7CIn6c0BWHEyjYa7n/R/Se6WQTD
         E78JoychrH4b8//GS+3RI8tYtbetSzixN93dSiKPEcF5kvWvbT5zBP7HBl625vWfMRxn
         2VIP906wB0B2iOEsYPF47eJroLoUA9uCwPw6cx0KG6YC4xt7lQyniUe34z9e4VsQgttK
         f9jg==
X-Forwarded-Encrypted: i=1; AJvYcCWVqS4lUoMH044vScTLbI6YmAaISzhpNMtEgxCni/uXxqswXjAgoAbgj+1AzGnuuyJbc34=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqnPRyLfxKnoSatS8lHM5oMWavGClhoTWSfHWfRI/0mVtrc5Sz
	5Vha2wT8CJl8tx7Bbd7zaeRmPZJX5KvRVFllfU7B7ALeELAokd+4Y6DVFeqci5Lf8EEVkQhC42/
	HURCks9X9To1s3hot0N4+5PveE4n422a1VA4pyE/H/N37l/Qtvw==
X-Gm-Gg: ASbGncuKLnyOowZRRLBm/Ufz0SjOhk2fjIeX9tpIhQ9xT3zV6YhXLKQPRDolKXVDSo8
	F99Lknm6hp5l54bu5oL6LbJMVeNR9wBKihGiEPJieo9fJxSMJ0dLYXmTPTZaleO7JbcfcxinrKc
	ldHX5UDop5Nlt+GQHM4Ts6R62Uz7RBqdqizaFEAKxlbJqqsDu0OcQdbN+oJhNjCfVwX12pofIwG
	vjnyJqn1OXLRe2kdlzRToeEilVyJuj15WwHYjXwa01qTAFZ2JzgNMWy4B3kRyUzfKjm+iq3FpRB
	omqqyTU31pFm
X-Received: by 2002:a17:902:f548:b0:21f:4649:fd49 with SMTP id d9443c01a7336-22e0863efbfmr14694145ad.49.1746070975376;
        Wed, 30 Apr 2025 20:42:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6XeA16VOaq6zL1nFcqHpvVwTJjX64McCuJNjLU9eHJvxIX6JXOCTvpbcT/Z0Dp6bPnFYLIg==
X-Received: by 2002:a17:902:f548:b0:21f:4649:fd49 with SMTP id d9443c01a7336-22e0863efbfmr14693805ad.49.1746070975009;
        Wed, 30 Apr 2025 20:42:55 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5102b03sm130327715ad.194.2025.04.30.20.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:42:54 -0700 (PDT)
Message-ID: <f61ef14b-9a51-48c5-b88e-518461c988cb@redhat.com>
Date: Thu, 1 May 2025 13:42:46 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 36/43] arm64: RME: Initialize PMCR.N with number
 counter supported by RMM
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-37-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-37-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Provide an accurate number of available PMU counters to userspace when
> setting up a Realm.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h | 1 +
>   arch/arm64/kvm/pmu-emul.c        | 3 +++
>   arch/arm64/kvm/rme.c             | 5 +++++
>   3 files changed, 9 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


