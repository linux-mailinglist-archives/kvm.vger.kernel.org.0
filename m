Return-Path: <kvm+bounces-24240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BBE3952C55
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 12:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA5FB1F21914
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 10:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A811A3BB6;
	Thu, 15 Aug 2024 09:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pz1Hutz2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DFC29422
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 09:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723715410; cv=none; b=TLr5/VG+E/O0x6rarsB6vOcctVJycZG6x0e2RdHXGnSUE9hZwE+1buOk/mBFc1+yEyjReON9G3T1HIILQV/NVyYrbhHMI7E33BozdbWb9mZ+xxF0aGc8TvhYJJ1I9JqmjqVAYn5x79J4gocQnwNHrD8xsYP65zbVcESjweM5E2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723715410; c=relaxed/simple;
	bh=35QpxSym/JcNyd88IJTFbCO/OSH7Cz/Od6Si/eP3pik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RpRMPJuUXvj5fb23h0RrcX+Gwo8NNv8PU4buX1A5ohg82piibGmchEYG65mblnc2eZX5PJhlmLKnPEJitOiCxpfSklNzlevgOeckTWjr33+FZxQudUX7VTzu1TnRW7BnNCG6MQcUUq9U+3Ohs0qNT2WQoeh+//eopKEvAV/GdiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pz1Hutz2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723715407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mRP/oMA5V9IShaM3ZDtqmT59XLN5dInyR7CGxSOftL8=;
	b=Pz1Hutz2jWO1Rfn1H5JrKqCRWth+s7pTetDy5IqXO8xb2NixaYs66ew9SiLOJhi7h3aiit
	FxNMXj0FnjPWue1eWWw9KMXf85tzDfcxSXlb1TQ1z4BlEbWYAhP8LFDBDec9WF8/355bjI
	hvXnMv54W5uf1brvMNgSziL0LpZc2v8=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-1W9QyFDHOmuzYkkNk36ipA-1; Thu, 15 Aug 2024 05:50:06 -0400
X-MC-Unique: 1W9QyFDHOmuzYkkNk36ipA-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-52f00bde29dso903885e87.3
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 02:50:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723715404; x=1724320204;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mRP/oMA5V9IShaM3ZDtqmT59XLN5dInyR7CGxSOftL8=;
        b=IC4o4KUQVRGLR3BUOaCxoXtiIiKiLu0EjrmdeAV9RA9QDBZXueCep71gZoV5e2DME0
         Ro6lTZXQRhqrFz8ZVctK12GAWn935SMuIA+t6SCf+JtAxMwWRoAb74JMoouvmKILd2Jm
         3ia+nkbCm0C3rO+hT4m8SfV/P2/ePOffjrxna6CmyyRtUA2J/hGnDRTmTboiAuNaV6oV
         zJ4jdZArkUTrhPYqdkOf22r8wghrwEq1ojcIyIWpUK9X1QCvimNibItAgJVYTsp9PVUx
         LeV0TZ2L5bSXJxRlAjzYcGWAj6ugKXhq3gdkIQcLJeF7vDzy581H4k09TDo9Gyqgg0E+
         puTg==
X-Forwarded-Encrypted: i=1; AJvYcCVoCu1jCsXVpTbof3HHm6Gd7srb5lgvaWs0iyuAfzU7iPtYeOGBifInC19ovmnguviJqZpX0K30uEyZHb1j6dhU4AbC
X-Gm-Message-State: AOJu0Yy2FHPVzi+tkrHS3HEZnfT+PClb8tKu1P0WHMuXho7N/1KyMJ1v
	7A9JMhG76O/B3nHSSt4sD256IiGkxMGkIHthqYjgjlKG7mG8YkmQLaYeN0phPbFQCdvMfKzOMEA
	JfNhJX7E9jQQ/ROrURD3U7b0BoO7JWYc7KV+d9MgonP1gJOGgDw==
X-Received: by 2002:a05:6512:b86:b0:52f:cd03:a823 with SMTP id 2adb3069b0e04-532edbaeed1mr4326664e87.45.1723715404367;
        Thu, 15 Aug 2024 02:50:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIt8FvwBc7Aa1/AFpHN00ExuvLZnCKNK6QmD/kPJG4QpxgYCimw322WnvTj7TMN5bvmaBeIg==
X-Received: by 2002:a05:6512:b86:b0:52f:cd03:a823 with SMTP id 2adb3069b0e04-532edbaeed1mr4326634e87.45.1723715403812;
        Thu, 15 Aug 2024 02:50:03 -0700 (PDT)
Received: from [192.168.0.6] (ip-109-43-177-15.web.vodafone.de. [109.43.177.15])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838c6b5dsm76787566b.13.2024.08.15.02.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 02:50:03 -0700 (PDT)
Message-ID: <8a987dbb-aff5-42dc-ae56-0b6b4e6a985a@redhat.com>
Date: Thu, 15 Aug 2024 11:50:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] meson: hide tsan related warnings
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Beraldo Leal <bleal@redhat.com>, David Hildenbrand <david@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org, Wainer dos Santos Moschetta <wainersm@redhat.com>,
 qemu-s390x@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
 <20240814224132.897098-2-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240814224132.897098-2-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15/08/2024 00.41, Pierrick Bouvier wrote:
> When building with gcc-12 -fsanitize=thread, gcc reports some
> constructions not supported with tsan.
> Found on debian stable.
> 
> qemu/include/qemu/atomic.h:36:52: error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’ [-Werror=tsan]
>     36 | #define smp_mb()                     ({ barrier(); __atomic_thread_fence(__ATOMIC_SEQ_CST); })
>        |                                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   meson.build | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/meson.build b/meson.build
> index 81ecd4bae7c..52e5aa95cc0 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -499,7 +499,15 @@ if get_option('tsan')
>                            prefix: '#include <sanitizer/tsan_interface.h>')
>       error('Cannot enable TSAN due to missing fiber annotation interface')
>     endif
> -  qemu_cflags = ['-fsanitize=thread'] + qemu_cflags
> +  tsan_warn_suppress = []
> +  # gcc (>=11) will report constructions not supported by tsan:
> +  # "error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’"
> +  # https://gcc.gnu.org/gcc-11/changes.html
> +  # However, clang does not support this warning and this triggers an error.
> +  if cc.has_argument('-Wno-tsan')
> +    tsan_warn_suppress = ['-Wno-tsan']
> +  endif
> +  qemu_cflags = ['-fsanitize=thread'] + tsan_warn_suppress + qemu_cflags
>     qemu_ldflags = ['-fsanitize=thread'] + qemu_ldflags
>   endif
>   

Not sure if we should hide these warnings ... they seem to be there for a 
reason? Paolo, any ideas?

  Thomas


