Return-Path: <kvm+bounces-7144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAC4F83DB5A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:59:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61A9D293FEC
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 13:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF7F1BC21;
	Fri, 26 Jan 2024 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T2ra2UH1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B0E1B7F2
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 13:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706277478; cv=none; b=UCgap/gnPt5EqvWrwf3RitgcNuS8KW1yGSXfk5BmO+THwZ0gpE4bsShU/ILyBXjYgYo7WSDsmy47SOgIksZqvm4p6BxjyR0m1EVYzd24TZBUziCL/WJx1S47Fe74NNpgyR6YBQv0w7Sq+3BG+Ab8Zwv7Mq2b8tsLeSRcrlhoRYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706277478; c=relaxed/simple;
	bh=6waacAzXL+Tpx5zQVsLrsOlJr5hBUd+d+KIWZyK1yUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DiaS+rQkyUZ6KCZKgWMFaUrtcQPmm0engjz8mdFZ0ZXnCO7iMsy73GQwZvqNmoNsPaKwF7b/8+W/FFkqsn0TCVV2XCQrzPVDiS+/l7FpFGe/YFtCtBkBEjbHE5jwcPGplFfYnirBfje/ikYcA+0yfmmh6v/3choMT6q18ARNVCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T2ra2UH1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706277476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xSXRGQngmFK9Sx/8Ei0ngl3iNg7BxibW1pg5kPF9OuQ=;
	b=T2ra2UH1/XUZNCXX7fXxjlULvcZl3IWhTB0TRfiGyFqGEf1o39cyf95KJFvRUAyqQjkgxt
	yjMb1YqcAr9bB692hyQbAtelrKiWi3uNr4roKSsuhqr6Kkt4bhg/MWo7nIyZpdn/FTAqdd
	vOIaZICoE/yIHxcipMUYzQ+QAbp9uVo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-yfj1UKsgPRqcb0L8uaIDYA-1; Fri, 26 Jan 2024 08:57:54 -0500
X-MC-Unique: yfj1UKsgPRqcb0L8uaIDYA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40e4478a3afso1973775e9.1
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 05:57:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706277473; x=1706882273;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xSXRGQngmFK9Sx/8Ei0ngl3iNg7BxibW1pg5kPF9OuQ=;
        b=iyn5mYa78Htg4CJBfcb0WP1HZdUb1GXrFS57Y7vT/QIy+k8TOXMS1DPVnO5Nwk/+Hh
         agaScrJMDkud7Ar7b3RkeOCpFZBqbWXuoryu40vlnF314sHjY5jIK1z2RWq+U4dDdqeP
         jMuVIq27nHlouicuisFxJcioS+we6Gxiu3o2xv6VI3V1I0G4Eq6vdSLo46howrx33XhG
         atiOVVr5/1pJNAlBkNLKFdlkLMU0YOyAySu3pQUDl7QkAHXKwTPgLGugPQo20JjYffMW
         nG2LkNB8e03yPXnYSZQNiSErq1qDiZmNnuMhPUr44UWjAFk4DD1grHUdrdgJI+J394ia
         /V7g==
X-Gm-Message-State: AOJu0Yy2Nz2O1QnFFVvDRVR+rUv4J6vb9q41QV3c7ZHyk4O+V0zqM1A8
	Nqx2lTmdbQ0e1tPHmB88YM4j+lCmkoUyKHPSFrZYJsgHmwmDRY1OzzMCRKzmwJ8tOgXT/6u21c+
	D9ptcfZmm3WkDYzOt1SVnTREmb0GxnZN5cqD93cVPKleXFgjXvA==
X-Received: by 2002:a1c:7919:0:b0:40d:b191:10e with SMTP id l25-20020a1c7919000000b0040db191010emr572199wme.175.1706277473468;
        Fri, 26 Jan 2024 05:57:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEEkpGE1Pu6e5X8Jk29S9vir52yw/GllKKjFTRUG9Ngie3xAhUTrEndrSCbsTO42siFgDe28A==
X-Received: by 2002:a1c:7919:0:b0:40d:b191:10e with SMTP id l25-20020a1c7919000000b0040db191010emr572176wme.175.1706277472990;
        Fri, 26 Jan 2024 05:57:52 -0800 (PST)
Received: from ?IPV6:2003:cb:c70a:5100:7e95:22ff:3f9b:1e92? (p200300cbc70a51007e9522ff3f9b1e92.dip0.t-ipconnect.de. [2003:cb:c70a:5100:7e95:22ff:3f9b:1e92])
        by smtp.gmail.com with ESMTPSA id az29-20020a05600c601d00b0040ee6ff86f6sm709785wmb.0.2024.01.26.05.57.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 05:57:52 -0800 (PST)
Message-ID: <504fca4f-89a1-4f92-a2f0-f64b04473ec4@redhat.com>
Date: Fri, 26 Jan 2024 14:57:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/66] RAMBlock: Add support of KVM private guest memfd
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
 <20240125032328.2522472-3-xiaoyao.li@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240125032328.2522472-3-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>   uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
>   {
>       uint8_t mask = mr->dirty_log_mask;
> diff --git a/system/physmem.c b/system/physmem.c
> index c1b22bac77c2..4735b0462ed9 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -1841,6 +1841,17 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>           }
>       }
>   
> +    if (kvm_enabled() && (new_block->flags & RAM_GUEST_MEMFD) &&
> +        new_block->guest_memfd < 0) {

How could we have a guest_memfd already at this point? Smells more like 
an assert(new_block->guest_memfd < 0);

> +        /* TODO: to decide if KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is supported */

I suggest dropping that completely. As long as it's not upstream, not 
even the name of that thing is stable.

> +        new_block->guest_memfd = kvm_create_guest_memfd(new_block->max_length,
> +                                                        0, errp);
> +        if (new_block->guest_memfd < 0) {
> +            qemu_mutex_unlock_ramlist();
> +            return;
> +        }
> +    }
> +


In general, LGTM. With the two nits above:

Reviewed-by: David Hildenbrand <david@redhat.com>


-- 
Cheers,

David / dhildenb


