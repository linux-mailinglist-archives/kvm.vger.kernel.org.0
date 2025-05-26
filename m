Return-Path: <kvm+bounces-47698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC2C9AC3CF2
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:32:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9852A3A90EF
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 09:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D1B1EF391;
	Mon, 26 May 2025 09:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xs7cAK6i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3F61DF97C
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 09:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748251923; cv=none; b=oJlsGG9owUy2B4EGAOnM55oFbpr35yd2DEUOjxZJZIHJtr4P0q7MiIB8w84PB4Li/lPibUaya7abT/57Ef47dLGvNXBMtKwEOhgRcE1VbMD/GqQ7e63OwLZpzJiK+NdRyBvAtwMtpV5RJg7pNB04oSohBclNOQUXlNPdAhv/5jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748251923; c=relaxed/simple;
	bh=hXYYH4M7NLd2AYwpNlaUkNczKSnNxEiYkF0+b+8dfbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JD1549cPQ+5s58hvoNcNrzeY76Jm6s4bEjIHWXpfuEznLHMxeIo4LM9bHS80aqFqs/y3mKQ6q1Rs5JB5TuH3tnQDFZ7nftrP0YeZw9p/oeutuJLxAiUoFOgu3Lod0TUhS9ZXqq9Xuwbenjkx+LXOVCKC/8Fq1ZxzkYOqFgCLDQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Xs7cAK6i; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-44b1ff82597so18484035e9.3
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 02:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748251920; x=1748856720; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VQaUKMuqli2CeDV/2HOoV1p5VWj4I72PzrRaLmrsavk=;
        b=Xs7cAK6i5Rd5zWGmaVaC97fhPANhCIew9erPu6W3lG+ug3D+hACHWz5dUDnBNGdsAH
         Em3o9mKjiFf3FtjI7uI+gLD7PR4PiIff44IGW78+stA9xtj/UrHHg6uYBSdnK4t1ED9f
         rxAY9z58UTABuu9D9JP6uamun1RFNKRMDt27fpd9Jx3EQXWBQXXl1n7RkT92chruc6gs
         zaxv7JnDCZk9ef8X4uwDVNXZpl8O/SbRHYJwocWEHD3p1OhNpwYH+8iPeInC8cLa6BbL
         Ziz7RG7i6cTYkWv1FCtn+kghbHsOv8qIFZ/xjmj/IEUEWqIkKA3lIIV3bJn71hnpWak4
         +jlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748251920; x=1748856720;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VQaUKMuqli2CeDV/2HOoV1p5VWj4I72PzrRaLmrsavk=;
        b=wqhOj3QkfIQaCHWhYHVG5PoPc+o/0JSENbjyflkRczYHEkf3kcFGR4SENd9RiOHaiV
         vYrKyqw2u6F+Q+w6ilwfnOTH3Qz0xxaUpl1V7wWm5eroLwtj/XUdh//FJPtUSj9NO7dQ
         0XShWej86vxwwBBxhH//DbMiqV07cTEvKChpaNaAY8aiyoX+wl/+DnGmwxa96cQSB3XC
         m5StOeAFM4EZHIxksK5OfwOLkQmi7lqVPh2M3ePivChDm4hxK/9bkGrxK9HLxIk2EXSe
         cbqUKPNkJqGOYoIuhzN32TEO9NIUDtogmb0qBVubhUuZ5F3P3+QNylGpe/u1DfgYSGsk
         2ZmA==
X-Forwarded-Encrypted: i=1; AJvYcCWx+sjRV91Tz4uiR6CvC1gO9XEXaSYAajc3TOsBZc9IxN71GZCRh91MwtyWnENRdAyg6e8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhsCVAC/mTJ8EX/ql1NT1bihqn8Qm742jQ9DregK/oA+B6RzaX
	sf3ROP+8ppXDugzJbPYGcpwOKQ5nAExni9G06x5RrU5qTjIy3HGl3goflK7uoeClekM=
X-Gm-Gg: ASbGncsaRAZ3MUTMPe5Bwb4t21TAxKdnSJzX0zct7d2QcLWxrLmdA3yoADgRnNIKqgM
	J1YAX2utlWlu4aj4tFWtkd8e17jxvKzMYQaS7gpcxatdgiMRDSLE3QQiYJsbJ0YIV7QwoFMCC5F
	9LTjbmO8hKTemtC/cbSjaQErf8PImqh0SGL/Icmk0Vn1vE6KE6blZYe8iyr7tGTLnuPYEA4gu0k
	M0OiUVrFv1x1qePehH4B9VF1FOrJEgcTywT8+7yCzwDf1eB5PIeMnAdr04RQiC4QTVyfonQZoCd
	BtnVS09vtAh4B683z1EIKh61iPtUavJeF3SZnZLLUDc2bdr0z5hB5+Tt8dWF5IvP/z1NB7S6cQ3
	MsGiKxXITZKksupIMlrOoyxyy
X-Google-Smtp-Source: AGHT+IFBLDAbHUmvBbM2FQiCwBMChHISQMitYm193ScCp7pHbwWljyeA1hODgEUF8f+q6XDc8rNu0Q==
X-Received: by 2002:a05:600c:384b:b0:442:c98f:d8cf with SMTP id 5b1f17b1804b1-44c91fbb3b4mr91200545e9.16.1748251920468;
        Mon, 26 May 2025 02:32:00 -0700 (PDT)
Received: from [192.168.69.138] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f73d25b8sm237844105e9.17.2025.05.26.02.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 May 2025 02:32:00 -0700 (PDT)
Message-ID: <1790986f-4793-483f-8756-2701e54db744@linaro.org>
Date: Mon, 26 May 2025 11:31:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/10] memory: Change NotifyRamDiscard() definition to
 return the result
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-9-chenyi.qiang@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250520102856.132417-9-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/5/25 12:28, Chenyi Qiang wrote:
> So that the caller can check the result of NotifyRamDiscard() handler if
> the operation fails.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v5:
>      - Revert to use of NotifyRamDiscard()
> 
> Changes in v4:
>      - Newly added.
> ---
>   hw/vfio/listener.c           | 6 ++++--
>   include/system/memory.h      | 4 ++--
>   system/ram-block-attribute.c | 3 +--
>   3 files changed, 7 insertions(+), 6 deletions(-)


> diff --git a/include/system/memory.h b/include/system/memory.h
> index 83b28551c4..e5155120d9 100644
> --- a/include/system/memory.h
> +++ b/include/system/memory.h
> @@ -518,8 +518,8 @@ struct IOMMUMemoryRegionClass {
>   typedef struct RamDiscardListener RamDiscardListener;
>   typedef int (*NotifyRamPopulate)(RamDiscardListener *rdl,
>                                    MemoryRegionSection *section);
> -typedef void (*NotifyRamDiscard)(RamDiscardListener *rdl,
> -                                 MemoryRegionSection *section);
> +typedef int (*NotifyRamDiscard)(RamDiscardListener *rdl,
> +                                MemoryRegionSection *section);

Please document the return value.



