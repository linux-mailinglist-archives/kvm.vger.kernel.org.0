Return-Path: <kvm+bounces-30711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 096F69BC9D2
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:59:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCE6F28318D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 09:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BCA81D173F;
	Tue,  5 Nov 2024 09:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QEaLEvGL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8091D172A
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 09:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730800788; cv=none; b=gvnj8I2LX1mB8Ckdo3opXyXFFF9OTTAojFxnkCRt2xgy00AdqvG3xV0O98IAZ6fUePGiAGW3XjhNdFNFdeooFMCMRF4T+DJZPkUDL29E95A2wLfNdEAGzVR+5MOs7aQhgnsCQXzdAQp/oZbQbM939Y9CKtrKhRYoaPZGl6KrIJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730800788; c=relaxed/simple;
	bh=auKbAwmDVLuLzDePYeb9+7433lrdAyJ4IcErJw4WynQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uysJdsM9XF7cdj0wBM6/M84Q0T32UFZMuJgbS1YzT5cC4B1e+TGDByix5OiW4m9UoJiDHB9F+xzTXPL4+kyY8MQyCS0IxlV9izB/eZsAncEcZC1H3nWTLRgYP6O+Yd9+lFonZO/howyYThlRde04pao+jZ5x7jgyh//cs+n3M8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QEaLEvGL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730800785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QInjCe2HZxMiS9t3tTItXMpvJOBheXFw8ILfgZfDc04=;
	b=QEaLEvGLpIzWMJAo42yG7fWD+H+opeOskGQuBgolEn9/EOZJhuzDxh/fOMww5R29vKZgjK
	i3zdmybxDnd9wT5zKBU7K7RUEIaW5poKTnKanL+kInCczqzW2UP0Ev/pjlc/Ud7QSo6Gro
	MKoCu6lekb+pNKsRUiKX+eePFVFJHTA=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-7r82p7XQPI-2UfDLMW0nGg-1; Tue, 05 Nov 2024 04:59:43 -0500
X-MC-Unique: 7r82p7XQPI-2UfDLMW0nGg-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-539e75025f9so2931153e87.3
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 01:59:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730800782; x=1731405582;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QInjCe2HZxMiS9t3tTItXMpvJOBheXFw8ILfgZfDc04=;
        b=I7ec6a/Xfqe0h304hjmOvWYOrLE5034zwh7C6teCUJwj4m7lTawIonvQJK3eKiivDk
         4X9QEF5uRFQzfQ7ZtUoe3VdjVQwaXoaPSOJUn/nCVgKEZHxBa/nqyL5rfmOhyBjvER+6
         3w3u9BMPP3RNJnvkxPwgEa3DkazEhdKvZmSXTcqMaYo/GPu0zmcmYkkJppHQfI8hieGU
         AD/peM6Uzit9NYumyGmEqaulmpyxbKufP1GEzkP57nVAVFoJQh6mw744Llz6OdJvXx3P
         5cp41yisnKvQCewmYgXpP8qmcrkZK0vQbf2V+vrTKCkU9ZFyzSXMV0/y50N/lXKPAwVN
         hxgg==
X-Forwarded-Encrypted: i=1; AJvYcCXbW3KgcQAKjHBEOTwFqLqrpAwRQwN1n/eVxkdByFoWI/xwn91u0B5LD/HjOSf/Hsk9oyg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj3F2nbNJdoqqJQInV8Gncu8/NjQmZKvEPq55ZydwoayzgnxOf
	jqbDlQ1fhM8Ma5EhUGaoDeNsdDjnbOjo+iYxhQS7+N0fYUa+PhfmCTuqzv8N/lsxjYTDtq3o6av
	gUl6bBW5tYGn05ciDchoZMtpxy0HUnfrhztPBwPRuCI1YSd/f+A==
X-Received: by 2002:a05:6512:3091:b0:539:ea7a:7688 with SMTP id 2adb3069b0e04-53b348b9130mr16974775e87.1.1730800782275;
        Tue, 05 Nov 2024 01:59:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEzMuWVU/ndch0oUzHzWK5tBEpoZHJkJ1/PzWbUd+f2Le81X2BJN/p+vKXeYJ1oT0Rc+ksAww==
X-Received: by 2002:a05:6512:3091:b0:539:ea7a:7688 with SMTP id 2adb3069b0e04-53b348b9130mr16974745e87.1.1730800781730;
        Tue, 05 Nov 2024 01:59:41 -0800 (PST)
Received: from [192.168.10.3] ([151.49.226.83])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-431bd947c0esm220305265e9.24.2024.11.05.01.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 01:59:41 -0800 (PST)
Message-ID: <f1c7bba2-7b21-4e10-a245-36673e93f8b7@redhat.com>
Date: Tue, 5 Nov 2024 10:59:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 56/60] i386/tdx: Don't treat SYSCALL as unavailable
To: Xiaoyao Li <xiaoyao.li@intel.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-57-xiaoyao.li@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241105062408.3533704-57-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/24 07:24, Xiaoyao Li wrote:
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   target/i386/kvm/tdx.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 9cb099e160e4..05475edf72bd 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -734,6 +734,13 @@ static int tdx_check_features(X86ConfidentialGuest *cg, CPUState *cs)
>   
>           requested = env->features[w];
>           unavailable = requested & ~actual;
> +        /*
> +         * Intel enumerates SYSCALL bit as 1 only when processor in 64-bit
> +         * mode and before vcpu running it's not in 64-bit mode.
> +         */
> +        if (w == FEAT_8000_0001_EDX && unavailable & CPUID_EXT2_SYSCALL) {
> +            unavailable &= ~CPUID_EXT2_SYSCALL;
> +        }
>           mark_unavailable_features(cpu, w, unavailable, unav_prefix);
>           if (unavailable) {
>               mismatch = true;

This seems like a TDX module bug?  It's the kind of thing that I guess 
could be worked around in KVM.

If we do it in QEMU, I'd rather see it as

             actual = cpuid_entry_get_reg(entry, wi->cpuid.reg);
             switch (w) {
             case FEAT_8000_0001_EDX:
                 actual |= CPUID_EXT2_SYSCALL;
                 break;
             }
             break;

Paolo


