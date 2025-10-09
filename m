Return-Path: <kvm+bounces-59706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id ADFE7BC8D46
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 13:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E01CE4F920D
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 11:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76BE92D3EEE;
	Thu,  9 Oct 2025 11:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bkAimmaY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5332E06ED
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760009410; cv=none; b=GQdOhPcu5irap8T0I8dvrMm7UDbrqNK80JOkCY43RKWAtAqAWKbsM7kqaxz9vja+NqbHBUUJIxMWBhDIvpsCYIEx3Lif2jY26EEmFStf7bFUzBSr0RRyP2rDCArBG76Hd2vMqrqU9QCZhsHPWwPhIdJZeOyU/yAp3oX6klDIpfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760009410; c=relaxed/simple;
	bh=LEKR+TNKI+l925hD25ERcKHV2EDFGPvH0Rn0Kaf3B6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VOOX/v74G0qwuGRBUmViVzSd60sfFT1iC0ZxNbTDZGRwRP+P/3zbZ37EaptGFGf8InSoJ4F304sLkn7yHBMVhziPOlKoqv1b9d8vJSYESZc5jBVW509CrqHsRPdC75bnhwALK4ze9fqfexAKOh9EGH4PiLN2sYM/lRrYWF5P7Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bkAimmaY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760009404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=anZnb7FGDnfo+uyqEej2Xh3gIZULvJpGNAIjXS0/XGc=;
	b=bkAimmaYZlWJKGrulgn0meGD0AQKVZILGOUa3L0KFrHfMA4W9spa3gI+bJAAG/pZBtkudl
	mV93UGGFdPeA9etDFPR01fGDRrdpk/ks1zrnQbOIzhZm5gLjGsjQarVyuIdu+xlvpTbcpL
	cTztP6b3ORVDzH0XHQxumwb9WNVPUt0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-tVEH-IiFM7uWY2C17YDuvg-1; Thu, 09 Oct 2025 07:30:03 -0400
X-MC-Unique: tVEH-IiFM7uWY2C17YDuvg-1
X-Mimecast-MFC-AGG-ID: tVEH-IiFM7uWY2C17YDuvg_1760009402
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f030846a41so666198f8f.2
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 04:30:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760009402; x=1760614202;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=anZnb7FGDnfo+uyqEej2Xh3gIZULvJpGNAIjXS0/XGc=;
        b=S6H0Ecv0NKr2F4Kt/4NCWvEJr29tMLaP3SnCVlzmwGEf5tas4mSCDQJmfTToQ56P69
         SymJUfDehU0sRxqjAwRtAvo+AhKaEwH7966DvdhqRXwngyyzolF0etEv2wRTXButH6ap
         M8WLPIDaYiGtOw8Q5oWVoW7Q7WJozkI++ByegQyOTAD2UT7wcaYb1iyqdOaTFh2AYYtm
         oeCdaTRXV5PzkKP5tf5t8BniaKAnvKGWod7zWrMumjnNV/q+3SjIwYSxxhIMioFniLiT
         jZkTYRnKSZgToRs0Ag7HaI+Gn2H6k+AIEPdfLVqR6l0AeCoDrjpGGAfARmBsCSaXc2Yf
         Akcw==
X-Forwarded-Encrypted: i=1; AJvYcCUiG3Guk7cc9xOBL0oFA4flL32zADaeXngE732D3Mi9XR3ixjbrjMG+HdIwv+fDsJM6tY4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoScDJDSpszkATbHBHq8v5VtiKpg7iwBria7pSbvXdMqcOQcuj
	4e0oe0+rwnO77Qpq2KMgwrvCPXWgyHqH14jwkeUPCYq6RkPjD3e8KexOWe8JpTKztg9mg8qfyfH
	D2/uS8rwwq/Jmhvzee6UsZFBFuMvvfJntKY710jaYoEnU5naOVSrgXA==
X-Gm-Gg: ASbGncuLdFYIG4aoRLl4avsXxNDzWDkSk0qIlcahRnRhlHXbkFDwz12pBLsHwTnFbdB
	iXTJfzXA5cjNQGY8RZtdDHlT5E0pK3sVyB5q9YaVat0CsQItI1gvdBRhm497l1Ofck5KB4TbGqW
	cQTN5r0dJc0HEtwFxuGlqKSx70ixsjb3yn5/tfu3UW4gykTeD0P+W9rVcfZRAS/O6OMaBkVetnR
	8127HTz9G8Ft/gu/zClEtfAlsPhRybCGV5Wo8qy3AZkZGYkkmNbscIqN0lo7YUXOhRjMjyeV9Ge
	YBiopxNkRhLCrTuiwbcjiKi76SmYmkNgNbKAr1SGi2EWoggyuesjRtGyiSzlH5dZQ5AB95SfU8T
	P1ROKqRmvfzK+HJDzBG6UautuZpud6DNB9DG1QYiSnvx/knjbeA==
X-Received: by 2002:a05:6000:2c0c:b0:405:3028:1bf0 with SMTP id ffacd0b85a97d-42666ac2d6dmr4468475f8f.10.1760009402190;
        Thu, 09 Oct 2025 04:30:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IERTxLYiMQ7fyg7AUq1KMTpPI33xEF9Jny9XfjxZSzAP1Uj6yPDkUrOygCRlA9GBVZ3SpMVsg==
X-Received: by 2002:a05:6000:2c0c:b0:405:3028:1bf0 with SMTP id ffacd0b85a97d-42666ac2d6dmr4468452f8f.10.1760009401715;
        Thu, 09 Oct 2025 04:30:01 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.231.162])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-4255d8e980dsm37379027f8f.36.2025.10.09.04.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 04:30:01 -0700 (PDT)
Message-ID: <86a16e8e-48ab-404f-9530-d21e5d30db4b@redhat.com>
Date: Thu, 9 Oct 2025 13:30:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] target/i386: Add TSA attack variants TSA-SQ and
 TSA-L1
To: Babu Moger <babu.moger@amd.com>, zhao1.liu@intel.com, bp@alien8.de
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>
Content-Language: en-US
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/10/25 21:46, Babu Moger wrote:
> Transient Scheduler Attacks (TSA) are new speculative side channel attacks
> related to the execution timing of instructions under specific
> microarchitectural conditions. In some cases, an attacker may be able to
> use this timing information to infer data from other contexts, resulting in
> information leakage.
> 
> AMD has identified two sub-variants two variants of TSA.
> CPUID Fn8000_0021 ECX[1] (TSA_SQ_NO).
> 	If this bit is 1, the CPU is not vulnerable to TSA-SQ.
> 
> CPUID Fn8000_0021 ECX[2] (TSA_L1_NO).
> 	If this bit is 1, the CPU is not vulnerable to TSA-L1.
> 
> Add the new feature word FEAT_8000_0021_ECX and corresponding bits to
> detect TSA variants.

Applied, thanks.

Paolo

> 
> Link: https://www.amd.com/content/dam/amd/en/documents/resources/bulletin/technical-guidance-for-mitigating-transient-scheduler-attacks.pdf
> Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
> v2: Split the patches into two.
>      Not adding the feature bit in CPU model now. Users can add the feature
>      bits by using the option "-cpu EPYC-Genoa,+tsa-sq-no,+tsa-l1-no".
> 
> v1: https://lore.kernel.org/qemu-devel/20250709104956.GAaG5JVO-74EF96hHO@fat_crate.local/
> ---
>   target/i386/cpu.c | 17 +++++++++++++++++
>   target/i386/cpu.h |  6 ++++++
>   2 files changed, 23 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 0d35e95430..2cd07b86b5 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1292,6 +1292,22 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>           .tcg_features = 0,
>           .unmigratable_flags = 0,
>       },
> +    [FEAT_8000_0021_ECX] = {
> +        .type = CPUID_FEATURE_WORD,
> +        .feat_names = {
> +            NULL, "tsa-sq-no", "tsa-l1-no", NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +        },
> +        .cpuid = { .eax = 0x80000021, .reg = R_ECX, },
> +        .tcg_features = 0,
> +        .unmigratable_flags = 0,
> +    },
>       [FEAT_8000_0022_EAX] = {
>           .type = CPUID_FEATURE_WORD,
>           .feat_names = {
> @@ -7934,6 +7950,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>           *eax = *ebx = *ecx = *edx = 0;
>           *eax = env->features[FEAT_8000_0021_EAX];
>           *ebx = env->features[FEAT_8000_0021_EBX];
> +        *ecx = env->features[FEAT_8000_0021_ECX];
>           break;
>       default:
>           /* reserved values: zero */
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 51e10139df..6a9eb2dbf7 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -641,6 +641,7 @@ typedef enum FeatureWord {
>       FEAT_8000_0008_EBX, /* CPUID[8000_0008].EBX */
>       FEAT_8000_0021_EAX, /* CPUID[8000_0021].EAX */
>       FEAT_8000_0021_EBX, /* CPUID[8000_0021].EBX */
> +    FEAT_8000_0021_ECX, /* CPUID[8000_0021].ECX */
>       FEAT_8000_0022_EAX, /* CPUID[8000_0022].EAX */
>       FEAT_C000_0001_EDX, /* CPUID[C000_0001].EDX */
>       FEAT_KVM,           /* CPUID[4000_0001].EAX (KVM_CPUID_FEATURES) */
> @@ -1124,6 +1125,11 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
>    */
>   #define CPUID_8000_0021_EBX_RAPSIZE    (8U << 16)
>   
> +/* CPU is not vulnerable TSA SA-SQ attack */
> +#define CPUID_8000_0021_ECX_TSA_SQ_NO  (1U << 1)
> +/* CPU is not vulnerable TSA SA-L1 attack */
> +#define CPUID_8000_0021_ECX_TSA_L1_NO  (1U << 2)
> +
>   /* Performance Monitoring Version 2 */
>   #define CPUID_8000_0022_EAX_PERFMON_V2  (1U << 0)
>   


