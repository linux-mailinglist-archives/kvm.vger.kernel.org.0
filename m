Return-Path: <kvm+bounces-59324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20698BB133E
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 18:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A24AB3B5AD1
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 16:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A50285047;
	Wed,  1 Oct 2025 16:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PRnQ4qPp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8738C1F
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 16:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759334627; cv=none; b=qTB0yGvnZFKxneBB/s/5+2QqSo8ojPGsk/mhnVdTM2XunHs1ZyDnJFpzpAH5EC8m/OXwNvImmpbz4SQdVJr55bYJ6rm/fagenE72ez8StY2QQJxUeyxrbNPgJBj1jqpCHIKKJjPn7hKNIkonu7RKYxgeOjIHKsqMc8ByG4xxN68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759334627; c=relaxed/simple;
	bh=bkiYsRPXqm7Bbo1+QnW1KTCeYV0Dfhmqgq5sn82LM3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j/SccYj0a6JJPhjBDBEPQgFQ64Eah4Q3X3tmKQ7kXQEZBtf8pPT5h+7yJmcz6DRH3uvjj21j/J00LSvg/Wk/NAyDCVW7clZMKcF1/RXJp7GdhzPrlN1dZo0rzsG6jL8jHiycjgytQ899uXQtCuuY5xP+831E+hN+zCtWPaeinX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PRnQ4qPp; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4de584653cfso181181cf.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 09:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759334624; x=1759939424; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LRN/gSuS1GAP18uW4uZI9r2/gGWJmDTUpS3beftY9+c=;
        b=PRnQ4qPp/xwf4Agi+VoTVgyQT+1FSB9i3CAhapqTio/pJ0tOmwhvmX4v2+T3H82Byj
         X5ooaG9po1wjZUBX84/RX3EibZ4eDFmhNapyhry/vFZixmneuwqGISgz4K5Aq5/PHDHX
         oo68RvVOVrVeMl63eM780aJtVarfGU2l22z6rN/yiv3oLMsKyi+n0tv9deI7AOLooRVy
         rNLdzKq5X4uFrDq6SUeiMAUxdEQBFYWWA9IqtARt/XNxKAibXpOD64++aIWsYKK9SRKr
         X6VYt2I6SZ2Ff4ObamZIX6sUkCBDWGMeejjkyGpFTolgpDPJoz6j3Xserbos/5EqNU7u
         m8Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759334624; x=1759939424;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LRN/gSuS1GAP18uW4uZI9r2/gGWJmDTUpS3beftY9+c=;
        b=AyiYWcnMjaQWRXwHzOwlLI+XnwmylCDF1Cw/YuMMKVQfFEKI2l7G0Y4msdbVoRoObC
         vOW6hZAj4lEr7ikzAMK2343RhwyETXOYd5HNXwEL91lcZCsgcrsxBhhJ7XA0oT6Yq4fy
         FHVCUklBgtlhHPU37G7wP/wIX+FibHso6EIb6dgXMe79xfX3PamfRHhvd5LoXg9Gc/WW
         rG5VxkRgIVZ8agz7EX+L20e10R7Y6JHMdk4ps5In+GZLH5NAjsaxm2vtko2sdUvXGUF3
         dAs/LEawG5D1l9FdOE4UHm11Mt9iXsbL9nE8xkcMDWQSQ1vh3pxVg21jmlH0Jdeb6WA/
         GEdg==
X-Forwarded-Encrypted: i=1; AJvYcCXHhFGoUH040hJJfxYiMrJGX3roESpJLrecijcnu/HwClyWSRvuZqHEn1nO3AAmiepxHMI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1f2MdBaF8fILSmREOpZM3Hj9qDOvcPl5LWncOX96MFDD2X5qj
	Q6eGNc2xWnXnPtUYaCpSrEjK8y23YsQSZ+f9AbLd/PeUASjnUZbaO8KojYRE47KvfDQ=
X-Gm-Gg: ASbGncviouboJ+TUMAQKryITGxm2xklO6ZpXE07ALMqnTlhT7TP7dq2QZXLpk48KKg2
	ienkbrIQfCpuoplqdzpWxcYblfldybnuckrWUf4uHGFG4X8COwpXNupcNw4UZb1pP/6Pm3FcbL/
	WafuuaIbNktSueXwlB9RudPeZOOkEM2NRj2gvdxCkn8S5mVal4b3dqS9laDLBEEFoO7UdRIkmqQ
	XdPLhd9VtXwuWMjb0JJVPGgli2KnNtUdgTC+8J8ddFPciuhQdEbS4V5kBce5A/crq5avYhHeb+i
	Sk4iQ4wPm+YFWwsY+lJFOJ2DWqPey+d38dWINXkzFf19rT5mU0C1MpnqX2jlaPq1QkRl/aQvq6j
	2ldTmBbPGQS7zFK1m8JlbxSZEjbV1S+2B841OKaAsLr995m9qQ9lXCbJwOnibRyzJLYxPDbCzLg
	YDhD8AHOjym5XO4Z3HIv/+BmDXqsQD7pg=
X-Google-Smtp-Source: AGHT+IEHuRntYtfblmIAnhKBBcUOe3vagIGzluokfa3UwmivMH5oOuOgJzWyvpEoKCwtykjm7AhDBA==
X-Received: by 2002:ac8:5a55:0:b0:4e0:296e:8cbb with SMTP id d75a77b69052e-4e41de7318amr48478751cf.64.1759334624359;
        Wed, 01 Oct 2025 09:03:44 -0700 (PDT)
Received: from ?IPV6:2607:fb91:1ec5:27b9:1bec:2e21:cc45:2345? ([2607:fb91:1ec5:27b9:1bec:2e21:cc45:2345])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e55cadc7f0sm1011971cf.26.2025.10.01.09.03.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 09:03:43 -0700 (PDT)
Message-ID: <62257ea8-f06f-4a42-b426-bc4a7d93eaff@linaro.org>
Date: Wed, 1 Oct 2025 09:03:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] system/ramblock: Move RAMBlock helpers out of
 "system/ram_addr.h"
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Fabiano Rosas <farosas@suse.de>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
 Peter Xu <peterx@redhat.com>
References: <20250929154529.72504-1-philmd@linaro.org>
 <20250929154529.72504-7-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20250929154529.72504-7-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/29/25 08:45, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/system/ram_addr.h | 11 -----------
>   include/system/ramblock.h | 11 +++++++++++
>   2 files changed, 11 insertions(+), 11 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

> +static inline bool offset_in_ramblock(RAMBlock *b, ram_addr_t offset)
> +{
> +    return (b && b->host && offset < b->used_length) ? true : false;

... though we could stand to clean up "? true : false" silliness.

I assume this comes from programmers who first learned something other than C, but I can't 
work out what language that might be.  I see it in patches every once in a while.


r~

