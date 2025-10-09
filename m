Return-Path: <kvm+bounces-59707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F2B6BC8D43
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 13:31:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B6C11885B19
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 11:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D5FF2E0927;
	Thu,  9 Oct 2025 11:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RemoWKAN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795AB2BE04B
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 11:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760009444; cv=none; b=CClkmNi4gGVk2zoINue38jQL8OoDksxNHqsjjnDWX/ypZgzcYBu4Yoe0HdsScmub74ZeOfbo4/zA/uH2afaveBh8uWiSo0nOlbU+XUG45nAOy2dWmLeA4lm30aMPaAA0XYBPAsRgHcZHxSuYKQrWv178PAq4TH8EFYBR+zQYf28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760009444; c=relaxed/simple;
	bh=eCCUolAH/tt0fm/oP5HQ76oaZXU+UT4CFgqdk/T/9/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NY0kZv6eix7qeaTatj/AjPuBmmIQF3DOoCMv/vJzOfUDG7BEnPWqZOXtUZrRbdZdHx9W7guDQOVhQIbvzuikXFOKIaIBDg2pvxiDfLmQQqDmOJpY9cGlImS1mRnZ6nTEXsgcqSx29CL2LOL1UeZgD4W6PzK+IqDIeE8FNZ4/0GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RemoWKAN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760009441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vehNq207aKynKEYYCVHxT4GQfQAO9JInkmFzUxjvzdQ=;
	b=RemoWKANfEHGg6xrs7v8mos5YdN/M9ouP6vipwjFCQ51fh6igBlR6WCkZjuI78Z1y3bNPW
	WHiWr6KWERVYmSTUWUOLKwWKLMP+W70U2G7Xt7xSXvVUsse5gz/XR5Qwc3yvqdGTUdCs6j
	OXTP0O312Mex8Fid68jzUSMvYaEUaDo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-k23yv3FFMx2pcnRuXyaAHw-1; Thu, 09 Oct 2025 07:30:40 -0400
X-MC-Unique: k23yv3FFMx2pcnRuXyaAHw-1
X-Mimecast-MFC-AGG-ID: k23yv3FFMx2pcnRuXyaAHw_1760009439
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso876443f8f.0
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 04:30:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760009438; x=1760614238;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vehNq207aKynKEYYCVHxT4GQfQAO9JInkmFzUxjvzdQ=;
        b=t5LRBRXCuEBnBFLk8ZqzvjXH7q6IhHB++4yRm+PD6AUc9p4j4jhVIZpjB1GZT8WjRw
         FH2M/4Rb9149WMiMuyQaZ8DT4IDfbPJVGW/Hua0p7xc3OeKk2wbOP0RJe57oba5bgaMs
         AsMSUTHwU5a4jYacSiXvbu7zKfkibBD3OamOshzMUcu8EqqW43ZTk2yQpoCzyeFXhMp0
         8bL5oH3Xwk3TA/fzN9M5sXhdczGJHqJK775GHgZtmWTBTZpbpZHgyFyAw8k+qY68kycd
         MGgtd43MeqtdfTLTsga2F4mfZ4o0qEM3rUWTTKGagOIqPmezKKeddpEadd4M0n0cFDTI
         UalQ==
X-Forwarded-Encrypted: i=1; AJvYcCWat1ftHPpzsOPniaL8wqwcS71ip/f2zU+Zht4seK1jJVCnhVWPQ+Z7E2FL5E/LMSOgUas=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa0GNMO8qOTQS8k8YNdIX3eHYk40siqaHn/JDfiUQ+Wi7VghTY
	87QvbysAWDwCJ2nqzLomLy6s+RNx8My5+PwiHZb0WByrvJENWDYitWz6fD1+BvkF7rpgho9Bhvd
	caaUBPmTvDIIOkXv8yRTMm3vNZ04G1+A2RwAeec656Dql24h++usq/VDC2/XXRA==
X-Gm-Gg: ASbGnctu155LcLPdi1JwOCBn+1OgM6wfQtBOC+yZlwjS5UjNCfhrhX10sWtV2QCb43+
	W0gq5Lnll3eSOkCSD6dwQmac3209oBlQqbyOPJ2Gh3PE0AbGSz1TICYiX/hDY01k6V/mCu3Bils
	QlKkRs2UInX9w2q9TVVlTDLLj89zjFZCa97YJdefDn5L7EjMTpdh4vK4Ps0/J2fVIT+d0Z3hjBu
	d50eTVmBOvDJN+yF81kVhJxgunGI4wXXwxvYKWs13xPOjDvJrYIOG1K3ll/E+IOSUj/1Y864jn7
	5DUXtox7tR63mZnDM03qxA2vXKzyrnkqM0VemAGYGsaFJLUlsa1Py5xndtPUQ0Qkw+19zjw1OzF
	C1ALKOiIgMx7Sa5greOCkYQpLpwAMZtxJoYB/inHyciLp7n4fOg==
X-Received: by 2002:a05:6000:1ac8:b0:3f7:b7ac:f3d4 with SMTP id ffacd0b85a97d-42666abbbc1mr5654668f8f.5.1760009438220;
        Thu, 09 Oct 2025 04:30:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlP8l8EyfW7rcYqytt3jcelkFrNeuCHobP5tZUApaXWt6cy00Cg4gyA/v9+mAmCJ5tZDAP4g==
X-Received: by 2002:a05:6000:1ac8:b0:3f7:b7ac:f3d4 with SMTP id ffacd0b85a97d-42666abbbc1mr5654561f8f.5.1760009437420;
        Thu, 09 Oct 2025 04:30:37 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.231.162])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-4255d8e9703sm34718441f8f.30.2025.10.09.04.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 04:30:36 -0700 (PDT)
Message-ID: <9e9f5f0b-ad40-44c2-97a3-9845f2e1ac6f@redhat.com>
Date: Thu, 9 Oct 2025 13:30:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] target/i386: Add TSA feature flag verw-clear
To: Babu Moger <babu.moger@amd.com>, zhao1.liu@intel.com, bp@alien8.de
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>
 <e6362672e3a67a9df661a8f46598335a1a2d2754.1752176771.git.babu.moger@amd.com>
Content-Language: en-US
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <e6362672e3a67a9df661a8f46598335a1a2d2754.1752176771.git.babu.moger@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/10/25 21:46, Babu Moger wrote:
> Transient Scheduler Attacks (TSA) are new speculative side channel attacks
> related to the execution timing of instructions under specific
> microarchitectural conditions. In some cases, an attacker may be able to
> use this timing information to infer data from other contexts, resulting in
> information leakage
> 
> CPUID Fn8000_0021 EAX[5] (VERW_CLEAR). If this bit is 1, the memory form of
> the VERW instruction may be used to help mitigate TSA.
> 
> Link: https://www.amd.com/content/dam/amd/en/documents/resources/bulletin/technical-guidance-for-mitigating-transient-scheduler-attacks.pdf
> Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Babu Moger <babu.moger@amd.com>

Applied, thanks.

Paolo

> ---
> v2: Split the patches into two.
>      Not adding the feature bit in CPU model now. Users can add the feature
>      bits by using the option "-cpu EPYC-Genoa,+verw-clear".
> 
> v1: https://lore.kernel.org/qemu-devel/20250709104956.GAaG5JVO-74EF96hHO@fat_crate.local/
> ---
>   target/i386/cpu.c | 2 +-
>   target/i386/cpu.h | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 2cd07b86b5..d46bc65e44 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1274,7 +1274,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>           .type = CPUID_FEATURE_WORD,
>           .feat_names = {
>               "no-nested-data-bp", "fs-gs-base-ns", "lfence-always-serializing", NULL,
> -            NULL, NULL, "null-sel-clr-base", NULL,
> +            NULL, "verw-clear", "null-sel-clr-base", NULL,
>               "auto-ibrs", NULL, NULL, NULL,
>               NULL, NULL, NULL, NULL,
>               NULL, NULL, NULL, NULL,
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 6a9eb2dbf7..4127acf1b1 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1102,6 +1102,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
>   #define CPUID_8000_0021_EAX_FS_GS_BASE_NS                (1U << 1)
>   /* LFENCE is always serializing */
>   #define CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING    (1U << 2)
> +/* Memory form of VERW mitigates TSA */
> +#define CPUID_8000_0021_EAX_VERW_CLEAR                   (1U << 5)
>   /* Null Selector Clears Base */
>   #define CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE            (1U << 6)
>   /* Automatic IBRS */


