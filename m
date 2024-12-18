Return-Path: <kvm+bounces-34060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 860379F6AAF
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 17:02:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3DAF171457
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34EA41D45FC;
	Wed, 18 Dec 2024 16:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ORUe4DzU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E4F12A177
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 16:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734537761; cv=none; b=qNiUs9s6OyrnS+GtCKY5To3DHa93F7qdsi1OOYg0DWSpzgsTTCAdi39lGXESKfyLY0677xUMAFnGxzn7zgg5MKL8n5Zl1oXHIaa1paZZIVpURy4BylCKzp0x62uKg3gACax2TZJYdP/EhTu/GQBBmigoLS9veuT/QwcGDPW02oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734537761; c=relaxed/simple;
	bh=ipwWPfFJbSUfc3mWcfI0Cxr2pUpE2GvE+eFO7CUR/iw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=daL+AVMGOiNXNLiu/W8HkReI+taneEIZcBey7kXHk6hFpPu8NiNuvvs7FOblHobooh2uC/Vw3OwjYGVpCUxmDyPaj+hjmWmzFDR+6QbqZeLj07tLYNtIo0gClspnYaqOxNge/An5QgGsA9SrkaWxKdtky4tgoS40tDuq5d5XTo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ORUe4DzU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734537758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1RVHCfcdqcEQIiL70TH4TJkxTcYPAUx4uhixmbAGrhM=;
	b=ORUe4DzUgtYpSB9g1TtPoP976IN8znc5I4BNkAZBgGzslP8lCL/8bZTpacbDdihCUB3HFE
	h2pvTGLqUF43UJOwQACJiJ5mjtyu0IUkO5IXiGyTvxgnVL3gxRE08QPpg/gwoe7l0iBBz3
	mHaL2cpGnIopzVyxxsjpYS9kxQdlGOA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-ZoWtHm4fOUSCAXWrEuUZJA-1; Wed, 18 Dec 2024 11:02:37 -0500
X-MC-Unique: ZoWtHm4fOUSCAXWrEuUZJA-1
X-Mimecast-MFC-AGG-ID: ZoWtHm4fOUSCAXWrEuUZJA
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b6ef2163d9so1351269485a.0
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 08:02:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734537757; x=1735142557;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1RVHCfcdqcEQIiL70TH4TJkxTcYPAUx4uhixmbAGrhM=;
        b=CPBF+lOxPfDA1Q/F5/b/D2Eyv34xzE6/tTncwrMJtTa2fgSyMTNBWHTa8gXXWS2lr6
         +TlpWIoAtBnZlWmZHcPv4Q5EOytkR1hzU9sQD+MUVXAjDmaRMTlWVeHKIdo6ynGqFj/p
         luK2ppbiF2mqpLPfqN8pVpuMCNRkVeWkSUMF8XdSCiQrBKe9Nu6Xk7w37iloTZlpY2Yo
         wAcw5SEeAqjOWcoEGyHZC2lcLA5tTGLDwRhlIKJhwN24wpsVMKpV2/x1Rn6YarrfUpHf
         H/lb8kFsIOM9ke8Qj7tweswFAS5j8j4ob5K4MTeoURFKMcEeNcFndys+5beo1cPf1LQG
         fZpA==
X-Forwarded-Encrypted: i=1; AJvYcCXv3kVUUQfWCZqMc28uUjSgy7bcV33936DLZEkz3Qj9ZsHBautlYkIe0OQrtrpb15lJlGI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrxaqez0v1eTs6mFLtmdaFv4cSv0fI5rjiMWjtwMtR/EsVAdbg
	qtLEOCHvzpx0PO1cU5R1zPIGeh9/4CqxaMN98gHa+vXo0YusfST0O6SukZH7BbJx7HYhKw9NVYZ
	EXaqUpVUDOp0ZxAKzPtABd7YmDnLQR7gmboSoC07sBcROwshz/w==
X-Gm-Gg: ASbGnctwYuRk+UQtR8QLOvg0WqIOZN5Cqvx3ZeBfOQLlOS57Im09957ZfCTdcTo+YDF
	aSJGKs1PzcO/G+JOox2o7xEptyvcImxASVOZLqezsRcsCpz69bwJRAmSt7XWGEoD9D14J9VJQIR
	bXqfWV+OUPbmb7fyalb1qY0bbBye+JgqnezBB2J7BNlsmWa9eBmTfEa1wQe/gqhwc7oe14edgAT
	D/xhnlxGktgtG7DtrqQD324q2dVL5MY2VoQUUgave2RNuawjm92HUP6nYZc46eq+UZJe+krEVIq
	Uew2Cu1V3SdV
X-Received: by 2002:a05:620a:44d3:b0:7b6:d6e5:ac6e with SMTP id af79cd13be357-7b8636e6e09mr424918885a.4.1734537756979;
        Wed, 18 Dec 2024 08:02:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEk8K8Li40AVxD7oY68g+83EbML+bij5y1nsmF6JgePbttJbriFRdhTg65OIR7WoiH27Z5Cpw==
X-Received: by 2002:a05:620a:44d3:b0:7b6:d6e5:ac6e with SMTP id af79cd13be357-7b8636e6e09mr424913285a.4.1734537756673;
        Wed, 18 Dec 2024 08:02:36 -0800 (PST)
Received: from [192.168.0.6] (ip-109-42-49-186.web.vodafone.de. [109.42.49.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b7048bb8b6sm438319585a.89.2024.12.18.08.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 08:02:36 -0800 (PST)
Message-ID: <d34b78bd-4add-4123-b0e7-5c5afb8a9e67@redhat.com>
Date: Wed, 18 Dec 2024 17:02:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] system: Move 'exec/confidential-guest-support.h' to
 system/
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
 Marcelo Tosatti <mtosatti@redhat.com>, David Hildenbrand <david@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org,
 Zhao Liu <zhao1.liu@intel.com>, qemu-s390x@nongnu.org,
 Yanan Wang <wangyanan55@huawei.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Halil Pasic <pasic@linux.ibm.com>
References: <20241218155913.72288-1-philmd@linaro.org>
 <20241218155913.72288-2-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20241218155913.72288-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18/12/2024 16.59, Philippe Mathieu-Daudé wrote:
> "exec/confidential-guest-support.h" is specific to system
> emulation, so move it under the system/ namespace.
> Mechanical change doing:
> 
>    $ sed -i \
>      -e 's,exec/confidential-guest-support.h,sysemu/confidential-guest-support.h,' \
>          $(git grep -l exec/confidential-guest-support.h)
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/{exec => system}/confidential-guest-support.h | 6 +++---
>   target/i386/confidential-guest.h                      | 2 +-
>   target/i386/sev.h                                     | 2 +-
>   backends/confidential-guest-support.c                 | 2 +-
>   hw/core/machine.c                                     | 2 +-
>   hw/ppc/pef.c                                          | 2 +-
>   hw/ppc/spapr.c                                        | 2 +-
>   hw/s390x/s390-virtio-ccw.c                            | 2 +-
>   system/vl.c                                           | 2 +-
>   target/s390x/kvm/pv.c                                 | 2 +-
>   10 files changed, 12 insertions(+), 12 deletions(-)
>   rename include/{exec => system}/confidential-guest-support.h (96%)

Reviewed-by: Thomas Huth <thuth@redhat.com>


