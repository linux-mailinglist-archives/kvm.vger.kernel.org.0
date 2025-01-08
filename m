Return-Path: <kvm+bounces-34847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48004A0677F
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 22:51:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 894543A6D45
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 21:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA96202C4F;
	Wed,  8 Jan 2025 21:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cacVmXKO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3C61A01C6
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 21:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736373107; cv=none; b=mPNzvJZWTuCJ0gO7GBAwCEsbHxk97hl5HJfdPWa6ORL434z/Rx8IbAxetm5l43az6+5aH5spDmgNZINqNR3VBJJw7RYFJGIr+R4x/eHqRMBCJ6NAltvATcIyGiWWUOdvE1a90tMVMCrwO6EqVMw3oYvAWD+QbNiIP9hfNRCPAX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736373107; c=relaxed/simple;
	bh=RflcajQmF/0gVeJPYxYILVTz0lLHYzRzdomanjr8INc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hOdkOdK5Whl84pVxuqbP9dYbUGua76pxZWocigs/EFKYQLZ/D5SEkFfPU1c3n5tW63Qcjfa+f3FTVAJaMFDhCANa/ixqS+7FMYfVKtX+Flbm7c24JB1AdPtQ/THNOGHjkOG60lm8+EnC3zM18EPvopClJewDoAN+EwWCJdBDTDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cacVmXKO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736373104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8N0guUDSbIYVWqXggvmiyG0+OeGoVojdJbWZtZjg92s=;
	b=cacVmXKOxJWAZe6N/WX6oI2a3mqBQ5nh9XuEdCqUPa93UrcLAuGPY0Z3CWYRAc6VBJmh62
	L2zU1LLxdyxMUsi6e6VtQVHGu002yOkFYzfmjSMk9aMISttXRg5PjQxQw3aTm76EbHIhgA
	QV5aw0+g6HTKdafnGKa/3Wu7sYh54c4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-jSi-xUMLM6OD2KX1_UXiOg-1; Wed, 08 Jan 2025 16:51:43 -0500
X-MC-Unique: jSi-xUMLM6OD2KX1_UXiOg-1
X-Mimecast-MFC-AGG-ID: jSi-xUMLM6OD2KX1_UXiOg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43635895374so5950625e9.0
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 13:51:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736373102; x=1736977902;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8N0guUDSbIYVWqXggvmiyG0+OeGoVojdJbWZtZjg92s=;
        b=mGfQ4EKQRR3PS/kIeH8ysH7g9KeEpcXdIbFsoIuIKQpI9+MziyKVlVorcpwTUo1QLD
         2bLyu0xEIhCP0yJWikLL2QwmVP3Rc/FwmIu/8pMCygmmwgz8vw1lDMHaQ/PYeuQiNa8L
         4T6Ved1rx1ftNa41z7bWF0Y0mvWJ5GpGpDBALS8Ui5A2yiXkmRERFLijwkAeTbkhndRK
         fvF4iY53KiG+JL7pjU2vlD0F4CcvWktTz8mydxXUE4cCKAdDmJmp2p/qnQr+F8k0ngIi
         A+8ddxsxWS4jUqEPU2c3nQycrcmiM+pY2CSFH/KQmo5By9Nsmy2wp4a4Ero/R0b55Yyp
         gVXw==
X-Forwarded-Encrypted: i=1; AJvYcCXPX7AO7C705rnp/giZdIOVu2iPEcAcga+XF5dTZj+C9Y0Q7/UC9KuHdGGC1WQBQ89dl4g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxncbd86jizULRqUBwZf5YWKtG/hxZ2j2ZqtOkL/w4sLU5mgezS
	SDFD5O6+ym8xsB9CeoCesJkV1vOesxqQaip6ssgGpET0zyoaKYYdFKimoFzJ6c3ffVdF+gHjJhE
	VZd1nNklxCf0PQSCMf+IZ021ST22jV5xOZtoGSR1lG0XQ8HrX6w==
X-Gm-Gg: ASbGncv9z6lwW80C5G5H5sBtbkPlZhctZZzEYTcwOiFbnbJSAh+8TuU1UBV8OwiALL/
	DLw4W9gxMuaEAb3HjAjgzn9JY77TJNljKBWpCp02Wrphi8e4kgkhyQTtwoVqzo2prknBtQcaxpj
	qaEjfMu6AmMGG/DDbIQDIardBz3chk/jwBN3mNqmT+0vB9xWX7s1wMvvl/1qXaBNkB0tiYtp5HD
	1D91eeeTCuLCozNn5V3nJS87VTnpGGQJkHAftHhza/uLnv8dX7VP0uAeSkyq6IKtmD0v5vb4CEo
	wRt1wypziQ40N2BVIbXNCvgkZTGs8o0nPqkVligodUpO7bN34yGUd/UcAZd9oXrKj5tCIC4KZuh
	eFGdcIA==
X-Received: by 2002:a05:6000:2a9:b0:38a:88bc:aea6 with SMTP id ffacd0b85a97d-38a8b0b816dmr700630f8f.6.1736373102259;
        Wed, 08 Jan 2025 13:51:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGdQZn9sbC0j/500N2aXfLDc3+B4bnc9d7BRW68te+PhIY3H7ViQETdbfPrzgYOrEfKA1kpsQ==
X-Received: by 2002:a05:6000:2a9:b0:38a:88bc:aea6 with SMTP id ffacd0b85a97d-38a8b0b816dmr700608f8f.6.1736373101931;
        Wed, 08 Jan 2025 13:51:41 -0800 (PST)
Received: from ?IPV6:2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7? (p200300cbc70d3a00d73c06a8ca9f1df7.dip0.t-ipconnect.de. [2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38c6a2sm3178f8f.54.2025.01.08.13.51.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 13:51:40 -0800 (PST)
Message-ID: <56c1cf86-9244-4388-abec-d5c48b9217b9@redhat.com>
Date: Wed, 8 Jan 2025 22:51:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/7] c
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
 <20241214134555.440097-7-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241214134555.440097-7-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14.12.24 14:45, “William Roche wrote:
> From: David Hildenbrand <david@redhat.com>
> 
> Let's register a RAM block notifier and react on remap notifications.
> Simply re-apply the settings. Exit if something goes wrong.
> 
> Note: qemu_ram_remap() will not remap when RAM_PREALLOC is set. Could be
> that hostmem is still missing to update that flag ...

I think we can drop this comment, I was probably confused when writing 
that :)

> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: William Roche <william.roche@oracle.com>
> ---
>   backends/hostmem.c       | 34 ++++++++++++++++++++++++++++++++++
>   include/sysemu/hostmem.h |  1 +
>   2 files changed, 35 insertions(+)
> 
> diff --git a/backends/hostmem.c b/backends/hostmem.c
> index bf85d716e5..863f6da11d 100644
> --- a/backends/hostmem.c
> +++ b/backends/hostmem.c
> @@ -361,11 +361,37 @@ static void host_memory_backend_set_prealloc_threads(Object *obj, Visitor *v,
>       backend->prealloc_threads = value;
>   }
>   
> +static void host_memory_backend_ram_remapped(RAMBlockNotifier *n, void *host,
> +                                             size_t offset, size_t size)
> +{
> +    HostMemoryBackend *backend = container_of(n, HostMemoryBackend,
> +                                              ram_notifier);
> +    Error *err = NULL;
> +
> +    if (!host_memory_backend_mr_inited(backend) ||
> +        memory_region_get_ram_ptr(&backend->mr) != host) {
> +        return;
> +    }

I think this should work, yes.

-- 
Cheers,

David / dhildenb


