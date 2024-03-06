Return-Path: <kvm+bounces-11171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E288B873D25
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:16:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23C892829A1
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B391213A87A;
	Wed,  6 Mar 2024 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HyHwz4J9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11891137935
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745395; cv=none; b=n5bIPaSEJIvhMGo6qbKlKCtsn6nziBiLaLECJmyQDFRLXqNOvGswBcUvLoruJ9S0naCyN/Gwg3tvQJJL+UpDRg120XeGr86iRk4aJ+wnFZUjkzKoONzIY03uawjvOIhvVG5VuI/o+3ZDrihGXFIflRwX3k/nb2TddSGo/XLBANM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745395; c=relaxed/simple;
	bh=Tp6Jy397zhR69804zHitVnmgSBK0ZUwmNTIqNUZAqAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m0MJth8C57RDYrnmrIxnQwl4RVeMJL/Mc2tUxW+PdDTbOKd8B4QsRtOcuPF2W/iJ0aYWWYiBW6PlArw8hn/jEsrJ/hdFHCeh1DvO4abyDn2kow4qW+EM3Zhd0nloY1R9NbRNCzE0pHlUUTSDFlgKvXUsQwzDVpeJBePE1D/3e2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HyHwz4J9; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-513382f40e9so5951419e87.2
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 09:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709745392; x=1710350192; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MTstlGT/a18Frjz+rGLei+v7kWgyirApdQCesjszieE=;
        b=HyHwz4J9zx7dJ9/Eeo6vnmMhuHYLj4LTpbBeHlUSTC3a/ohUhjp3VsxBwsu4/7wG2y
         jJKu1q2Iysh4RpvXkT7xbhS/TRxC4YNtGhs2Tzd9GXMi2p2FcOxZ7Sc1lgUT8XPSAnXZ
         JJ3AMI27U7IF6whXiKbF+bocQhrsNQJ8ZqPufZ/O4P3tJ6BOESzuWwdHrRZYFyHdUhB2
         p5QM7lqoNDUgA8lqB79syijlDN5EKeAsllHxLAzt9v5nH++g1tFzmBpVSvshukHmJ3rq
         WHEuDgo/uMLQ6AMtVhCmLjiZhF9/7vaWkSMcPte2w3nc5TF6Gf5KMiri94jv8xTW0g1q
         eWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709745392; x=1710350192;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MTstlGT/a18Frjz+rGLei+v7kWgyirApdQCesjszieE=;
        b=PUjZGySd4KwxCsPPzjSADJ5ewr9bIGVvt1jDZzqcE5/mO40wQhxL2J/iHVXZ68BN3I
         AiVe4694c0o+9zzhEq/ISnHV/kt2T3K1p4Ir7nE4pxFOuGsd49gf3yV/+Xlmjg8M28LL
         CjG4064N4YP9psYOYkkcjjYLXWXsUQC2YZoyUuiwo5Ad5UCgw9wK3tk6IYcslqhM9LV5
         mLhrSkYjyDzHf5BxE2EG/R8IDlKrz7iaBEE9fpuJJUXQ6xJd+ueSyFlR/LCZyJJ01+db
         WK+1Y5PEsAwPL1uJMJsvd1jXAhi7HerTz9xl3fcd2IIhBLOfC5EM/PrBs2bAJEZg/ID9
         Vknw==
X-Forwarded-Encrypted: i=1; AJvYcCX069iVgv1oXwQ7iavLUqoY0XpmfDAnyisI7jLhgtM+7sOjcDjixjpdq5QH18mIElGNIL8+bWnTVm9YNltMvrZVAd4n
X-Gm-Message-State: AOJu0YxPxA2yGk99/DsmshZR/tVo7FPt/ADm1E3cdj3Lw2vwUKxYv7uw
	inye+R6tZmTZWTAe3QPN+boKOFkHST1hi62Jp2zmsEimeb9MgWdDcMy8aXRnPGE=
X-Google-Smtp-Source: AGHT+IEEEm27HQQ1yt59I8k1pXk5Kp9RWbi0wEjybB+XpiWEN9134OAxfJLk1YHC0bnesbA0/Cv8CA==
X-Received: by 2002:a05:6512:1152:b0:513:5203:e255 with SMTP id m18-20020a056512115200b005135203e255mr4652979lfg.7.1709745392070;
        Wed, 06 Mar 2024 09:16:32 -0800 (PST)
Received: from [192.168.69.100] (vau06-h02-176-184-43-100.dsl.sta.abo.bbox.fr. [176.184.43.100])
        by smtp.gmail.com with ESMTPSA id m26-20020a17090607da00b00a441ff174a3sm7372337ejc.90.2024.03.06.09.16.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 09:16:31 -0800 (PST)
Message-ID: <6de50dbc-9525-4e25-ba70-55aea0d3f044@linaro.org>
Date: Wed, 6 Mar 2024 18:16:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH-for-9.0 v2 13/19] hw/xen: Remove use of 'target_ulong'
 in handle_ioreq()
Content-Language: en-US
To: David Woodhouse <dwmw@amazon.co.uk>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paul Durrant <paul@xen.org>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
 Anthony Perard <anthony.perard@citrix.com>, kvm@vger.kernel.org,
 Thomas Huth <thuth@redhat.com>, Anton Johansson <anjo@rev.ng>
References: <20231114143816.71079-1-philmd@linaro.org>
 <20231114143816.71079-14-philmd@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20231114143816.71079-14-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Cc'ing Anton.

On 14/11/23 15:38, Philippe Mathieu-Daudé wrote:
> Per commit f17068c1c7 ("xen-hvm: reorganize xen-hvm and move common
> function to xen-hvm-common"), handle_ioreq() is expected to be
> target-agnostic. However it uses 'target_ulong', which is a target
> specific definition.
> 
> Per xen/include/public/hvm/ioreq.h header:
> 
>    struct ioreq {
>      uint64_t addr;          /* physical address */
>      uint64_t data;          /* data (or paddr of data) */
>      uint32_t count;         /* for rep prefixes */
>      uint32_t size;          /* size in bytes */
>      uint32_t vp_eport;      /* evtchn for notifications to/from device model */
>      uint16_t _pad0;
>      uint8_t state:4;
>      uint8_t data_is_ptr:1;  /* if 1, data above is the guest paddr
>                               * of the real data to use. */
>      uint8_t dir:1;          /* 1=read, 0=write */
>      uint8_t df:1;
>      uint8_t _pad1:1;
>      uint8_t type;           /* I/O type */
>    };
>    typedef struct ioreq ioreq_t;
> 
> If 'data' is not a pointer, it is a u64.
> 
> - In PIO / VMWARE_PORT modes, only 32-bit are used.
> 
> - In MMIO COPY mode, memory is accessed by chunks of 64-bit
> 
> - In PCI_CONFIG mode, access is u8 or u16 or u32.
> 
> - None of TIMEOFFSET / INVALIDATE use 'req'.
> 
> - Fallback is only used in x86 for VMWARE_PORT.
> 
> Masking the upper bits of 'data' to keep 'req->size' low bits
> is irrelevant of the target word size. Remove the word size
> check and always extract the relevant bits.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/xen/xen-hvm-common.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/hw/xen/xen-hvm-common.c b/hw/xen/xen-hvm-common.c
> index bb3cfb200c..fb81bd8fbc 100644
> --- a/hw/xen/xen-hvm-common.c
> +++ b/hw/xen/xen-hvm-common.c
> @@ -1,5 +1,6 @@
>   #include "qemu/osdep.h"
>   #include "qemu/units.h"
> +#include "qemu/bitops.h"
>   #include "qapi/error.h"
>   #include "trace.h"
>   
> @@ -426,9 +427,8 @@ static void handle_ioreq(XenIOState *state, ioreq_t *req)
>       trace_handle_ioreq(req, req->type, req->dir, req->df, req->data_is_ptr,
>                          req->addr, req->data, req->count, req->size);
>   
> -    if (!req->data_is_ptr && (req->dir == IOREQ_WRITE) &&
> -            (req->size < sizeof (target_ulong))) {
> -        req->data &= ((target_ulong) 1 << (8 * req->size)) - 1;
> +    if (!req->data_is_ptr && (req->dir == IOREQ_WRITE)) {
> +        req->data = extract64(req->data, 0, BITS_PER_BYTE * req->size);
>       }
>   
>       if (req->dir == IOREQ_WRITE)


