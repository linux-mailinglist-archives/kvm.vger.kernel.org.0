Return-Path: <kvm+bounces-65013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C2E8AC9825A
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 17:01:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E7C4C343F32
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 16:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 970311F461D;
	Mon,  1 Dec 2025 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HG39atvW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OMwfRSnb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF2378F5D
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 16:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764604881; cv=none; b=tvwEgwLTefbMkcmFiyhuwqVAhpfa9BLoG19kvDBJptBXq3KUnXup2ZIovWCg8mszSnpTg81j56lEkqb/Pa7VuGiOwIVxswMG8xvy8ix3V1qpsyI2HCM7tjxDLXDJ55umN9hXyZFfVfdXTq5o0eOcXh/QKtYhRMADB4N12E3bjW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764604881; c=relaxed/simple;
	bh=zB8uBg05JnGkLJU2uyCuihehwv9m+UIIYOQl+kopbvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EQV2yzqSKQD4A4B2ZF2r0ww8bcto0FE+bSIjRYKQthx27OGHCRRnLUqwySM4T8PWrYYG6JeCT0rUyTocL4b9xF2nc+3YWMEVSsuRzES7Ogpi6gRym7I+vo8igFAoQJQ+pvvH0iPKleQb25UlaaBsIUW1zHHRDsWpbDbRyV8A1uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HG39atvW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OMwfRSnb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764604878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0w55hQ+eXVZqzmQQ0BXJyh7tN55VxL9A5XlGAQlZ1qU=;
	b=HG39atvWVlB4CzchvqhBJSxgoYqigq1lQKno8MhLN+5xx2lvVV30EimYJfwcaqo+dFk9oc
	LzHQJzKdNfByZmqEjZr0NHXWGfNza4ka6VVFDq3tsFLWwiMXiZPokNzdRCGl4F38SzQo7m
	+MpglNuc3qxel4J24C/fy4+tjFqQpT4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-O4HjgzjDPtOb7ve8hUrsQQ-1; Mon, 01 Dec 2025 11:01:17 -0500
X-MC-Unique: O4HjgzjDPtOb7ve8hUrsQQ-1
X-Mimecast-MFC-AGG-ID: O4HjgzjDPtOb7ve8hUrsQQ_1764604876
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b7178ad1a7dso521745366b.1
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 08:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764604876; x=1765209676; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0w55hQ+eXVZqzmQQ0BXJyh7tN55VxL9A5XlGAQlZ1qU=;
        b=OMwfRSnb+m1wdV2OSEWD9nvZkjH4eIRBVV4QW0G9GPsR7u4Fl9h+azRF1BsGEOjpx9
         Lqa/pZglQ0w11Xb3rEDArVCkRpFvtCireVnLq12Fr/MIsen5LqnvoWmtt5DhDLRukeAl
         TRjBZnqBY8ogHJAUl3OIO/tMT4hRmRvROmLHDMHT0E2Ru479I4lSz4Iqf2pBEdc/skPh
         RvmjtZ2cogya5KBU11RqaE174MNNkUXIhXQ9zqVVfQ/ufzslpNyGiFApL9I0gwD0bSSl
         pAZnCM8ze/GuSrZyJ/ELB/Ftt8rdsK7zorREqdhypTSI1IkIYuaA65rclN6Q0KlqeOzs
         lIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764604876; x=1765209676;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0w55hQ+eXVZqzmQQ0BXJyh7tN55VxL9A5XlGAQlZ1qU=;
        b=nkBpHuJl3Ey5EuQuzwgVH9FwKBAqnShAkC303v0F97wHBg/adfbGnbbx8ONZlvwl1g
         pk5ayCbxI3D1SwXBPJpKt8QwmFW1tcTEUnGOuzbb/EQh3LHeqNq/XLBLFI8Sh0gAyGlq
         Ay2wVU7vZNQ8p3BrzPHbdbhW98b703osOPk3t/uuo3ed+5ghsOW8TgP0OBqM9XChYOwz
         qZ62NqiHyvY8FULwyda+xptCgu2E86P8VJ0zO3jNNp9rqACwYuv2rZv8B95NlMFyi+KJ
         5Sm6SCPG6NkbZfE02f1/176a7H27k8PbA7BcHJ/A9dFqr+zlL6JqHez1J6TW/FGRpvuB
         SUpA==
X-Forwarded-Encrypted: i=1; AJvYcCVwqikYdXzb9DKIuPq014RehsfDvbUzqfKm0OHOFo80RyLd+Y7J8kvlbgPa75eDoyaNJ/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyELyKlNG+RJ2h/wNUArLUC7G3a5ZAQcG5M3mQ4f47tQbMonJQP
	MoEagaqL8BCn/0JmV9HFMD5nqpV16Zsvb/Xb40FwFMqI3V5CP8EdexG3y8N8HFAknw3Eva1c10t
	EFV7QTC3Xl7BwS2strNx7OqIIg5P6bFvc2neYd11mZvXyuH/v0Tt9tA==
X-Gm-Gg: ASbGncsYuLKXx887YsA6jyN1tnyjOpU8Y1Cza4CJPth6BAPy3zse25sBFTOTdYt2LKM
	ObVxuXoGR0C2o6oRGy3KgZgJiQhLRpLiCtv5cjAPRcSnGnihQyslTdnFJWfYSKGRA5UhEQTsT/P
	kSzLadQhFuFkTJM4nHGQBu04UZFuui3kI0iwoRLdl7i95j6SAVK6ZsgjQ5F2gKtpKgp9FmUWlPy
	nmw4bCPFcVqHviei0ilKnRAohc1MXnO5wmWw+KRZ3SFK0keBqgDX/1EW4vxrL03uRoJ2icqL4VO
	8vcAyjwpI9OXDwJEyTPjH8AaVUHrK6N16JDw2jE4L9PWvM9x+bNpt+mP7MCVOEYiS5a60bE1BGl
	K6MJoXLYBfyz22+XMr3wwj5M2J7crBYCE7T/8kMWJSLUNVgiWS2sSwoxwokiAaUQ1Ulqx4GZKTB
	g+X4lGyO/qwJ0OjZs=
X-Received: by 2002:a17:907:3e15:b0:b73:b05c:38fd with SMTP id a640c23a62f3a-b76717332acmr4052587966b.50.1764604875344;
        Mon, 01 Dec 2025 08:01:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEtU1UITdt7IPgIFW5jxqCEQKvj8EGriEmYfhfxuTYjFDBNr4/3dxso9Yf8O55cM4UA9A+/ug==
X-Received: by 2002:a17:907:3e15:b0:b73:b05c:38fd with SMTP id a640c23a62f3a-b76717332acmr4052570066b.50.1764604873682;
        Mon, 01 Dec 2025 08:01:13 -0800 (PST)
Received: from [192.168.10.48] ([176.206.119.13])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-b76f519e8f4sm1273506066b.22.2025.12.01.08.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 08:01:12 -0800 (PST)
Message-ID: <5675fe47-f8ca-468a-abb6-449c88030a5f@redhat.com>
Date: Mon, 1 Dec 2025 17:01:08 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/23] i386/kvm: Initialize x86_ext_save_areas[] based
 on KVM support
To: Zhao Liu <zhao1.liu@intel.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, Xin Li <xin@zytor.com>, John Allen
 <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, Dapeng Mi <dapeng1.mi@intel.com>,
 Zide Chen <zide.chen@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
 <20251118034231.704240-7-zhao1.liu@intel.com>
Content-Language: en-US
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251118034231.704240-7-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/25 04:42, Zhao Liu wrote:
> At present, in KVM, x86_ext_save_areas[] is initialized based on Host
> CPUIDs.
> 
> Except AMX xstates, both user & supervisor xstates have their
> information exposed in KVM_GET_SUPPORTED_CPUID. Therefore, their entries
> in x86_ext_save_areas[] should be filled based on KVM support.
> 
> For AMX xstates (XFEATURE_MASK_XTILE_DATA and XFEATURE_MASK_XTILE_CFG),
> KVM doesn't report their details before they (mainly
> XSTATE_XTILE_DATA_MASK) get permission on host. But this happens within
> the function kvm_request_xsave_components(), after the current
> initialization. So still fill AMX entries with Host CPUIDs.
> 
> In addition, drop a check: "if (eax != 0)" when assert the assert the
> size of xstate. In fact, this check is incorrect, since any valid
> xstate should have non-zero size of xstate area.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes Since v3:
>   - New commit.
> ---
>   target/i386/cpu.h         |  3 +++
>   target/i386/kvm/kvm-cpu.c | 23 +++++++++++++++++------
>   2 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 3d74afc5a8e7..f065527757c4 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -609,6 +609,9 @@ typedef enum X86Seg {
>   
>   #define XSTATE_DYNAMIC_MASK             (XSTATE_XTILE_DATA_MASK)
>   
> +#define XSTATE_XTILE_MASK               (XSTATE_XTILE_DATA_MASK | \
> +                                         XSTATE_XTILE_CFG_MASK)
> +
>   #define ESA_FEATURE_ALIGN64_BIT         1
>   #define ESA_FEATURE_XFD_BIT             2
>   
> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
> index 9c25b5583955..2e2d47d2948a 100644
> --- a/target/i386/kvm/kvm-cpu.c
> +++ b/target/i386/kvm/kvm-cpu.c
> @@ -136,7 +136,7 @@ static void kvm_cpu_max_instance_init(X86CPU *cpu)
>   static void kvm_cpu_xsave_init(void)
>   {
>       static bool first = true;
> -    uint32_t eax, ebx, ecx, edx;
> +    uint32_t eax, ebx, ecx, unused;
>       int i;
>   
>       if (!first) {
> @@ -154,12 +154,23 @@ static void kvm_cpu_xsave_init(void)
>           if (!esa->size) {
>               continue;
>           }
> -        host_cpuid(0xd, i, &eax, &ebx, &ecx, &edx);
> -        if (eax != 0) {
> -            assert(esa->size == eax);
> -            esa->offset = ebx;
> -            esa->ecx = ecx;
> +
> +        /*
> +         * AMX xstates are supported in KVM_GET_SUPPORTED_CPUID only when
> +         * XSTATE_XTILE_DATA_MASK gets guest permission in
> +         * kvm_request_xsave_components().
> +         */
> +        if (!((1 << i) & XSTATE_XTILE_MASK)) {

This should be XSTATE_DYNAMIC_MASK, but I don't like getting the 
information differently.  My understanding is that this is useful for 
the next patch, but I don't understand well why the next patch is 
needed. The commit message doesn't help.

Can you move the call to kvm_cpu_xsave_init() after 
x86_cpu_enable_xsave_components()?  Is it used anywhere before the CPU 
is running?

Paolo

> +            eax = kvm_arch_get_supported_cpuid(kvm_state, 0xd, i, R_EAX);
> +            ebx = kvm_arch_get_supported_cpuid(kvm_state, 0xd, i, R_EBX);
> +            ecx = kvm_arch_get_supported_cpuid(kvm_state, 0xd, i, R_ECX);
> +        } else {
> +            host_cpuid(0xd, i, &eax, &ebx, &ecx, &unused);
>           }
> +
> +        assert(esa->size == eax);
> +        esa->offset = ebx;
> +        esa->ecx = ecx;
>       }
>   }
>   


