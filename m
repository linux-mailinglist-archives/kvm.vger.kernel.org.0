Return-Path: <kvm+bounces-44291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4D95A9C598
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D50E9C2AAD
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D21241684;
	Fri, 25 Apr 2025 10:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W+49BJMj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D377923FC5F
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 10:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745577183; cv=none; b=Yn+H0GIQMJ04ROafZ+gTXaRXHL+9PZ8Lvo5t66LqrvsDn7Ipg/zw3rLfrSQmBHFusM8vgEVvfyfPjF99taMlz9t4YXzUj3BL3tPFBL5CON6Ms5MymoQJd5YMpygUkaRxnrZObEkOtbiTMYUN+bJn+S9ScKA6D2XJfkx+dJ/L6SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745577183; c=relaxed/simple;
	bh=tmwuyWwNvggjxVvagGGr+okytXKL6sTezf6kc6XCDBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I76Anj84G5iS4Wg9c31f5PRWYX9jluCZY7UgKuPbuc+raJHuEGGINwmKdjaomA1B+R73K45GuaVHHO2DHdpKBSwqnByuP8RBJLwOFwL2v1yG0An24NLFzsfsFEdt/PopGp5CCx9M3485wQGL9QCUBuPopdyGBcL6jOCROt68Ci8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=W+49BJMj; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3995ff6b066so1108076f8f.3
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 03:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745577179; x=1746181979; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sOvNB9OXakWwwLO478SymfKCouNPG/XyF/EAXAqw/50=;
        b=W+49BJMjZYFK8nKEBbVV2nkh9hSVy0gwvBKnXPFH32ItXSOje0yNkiaydTMTFNgPYF
         4wzUK+xtD/v0PFpbkr8vat4flqd9YVZnxz+g6+HO32+IjmHwQZbFZmTNVdeKWyNBp1bc
         taALvRyMDq9KNbN8u34JQi6y47Bo8dVgzTPFJLSL5jxnGeQk+lYnovP6Nx0Mf7F+RI56
         vECkqoDMSQY2fJKeLyFbwFDxzi1enrnXtYx3CYhs1sd8HNWjOEQ7AU3XpBGK0XfXphCD
         Jh1WgwVskz5FdGZURtk3ayCkv/v+T5eESMFx1t8XyFW4C7vbB0/teC1W0rp9sPacdcDH
         VjvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745577179; x=1746181979;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sOvNB9OXakWwwLO478SymfKCouNPG/XyF/EAXAqw/50=;
        b=PwRUCdfr/I11hJWO/iQ6gJaJOesedIOPrarer/3ICsFTPwBRPB99y+J+Km7Orh7ICv
         z52quYMu6IUdQocIIJ+r3ZwqaYpYQAKsN3MaXoiHEr4kMrVEKJj46px2S+IwfxxB+pf9
         FaGY7XLASalG+Cevw4ZQXQPIzaMFIz/AkM6mM/10a/e+HzQ19/biArtA5ksD17VYh5mD
         TSnfkqr6wgv8ezyHd7Tp+SIJjjBlN5C+fdzIGqK24ON1oI3j6C1B972/giEvEJ1qNt5z
         QIdP2oUxEF7dOOJsqSREOmXV03w5Owh+LUvUSbmzIffI4nHkhNLke+ut/+j4RtNHtcgz
         QVPw==
X-Forwarded-Encrypted: i=1; AJvYcCUrmP87UDuy5a/Pu2ybf+pwzmGegGmT/hLKPWrf5BRtYOe9hGTJXI0ebyfXXl7SaDI9khs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSVDXXZmtHk1VMmqzVTHWDz7hX0kGjdYzRT0jA9Amg5my7Eg50
	v55kr8wMkmtt+7p0qSPL7t0czr03fpgOxF6B8P6KtX+KFT7cmAb9J9gIhQBE9Mw=
X-Gm-Gg: ASbGncvE3Gf1AGUj8q28nkFyBTv2Dx60pvvn1MfbPeJHZ6A/IerLoY9qZk35hpmw9H1
	s1PD/dcJpKOG8buvKnQ48Z6zZ3lG9DuN7VZm4OKCKjw3kmJLT6AKLyFW6OlY7SPfln8j4pq12UF
	SWlUbOoCqrUOQo7QADdNKs7ZQea/qR5gqH/xKLVf1PJjk88aFRe8jz/QtHSjCCETo6vctfFo1KE
	X0/Xg+XwoHwqKn7PONOWKYeAvq302tKms4VOPPntZek8dKluVJVQSrqgNHKJNGj/RJvzSDGuwCx
	yWbSHsojDAsLCaseKEx9wsL6zUwY6Iw8Ta78ZkgUAeQuBQw0xnSZvJQOOunfo3WgXK25FtKcHqF
	byMkNjdSy
X-Google-Smtp-Source: AGHT+IFMMVBirbFD7Umi/fq28itS5m0zi8Hkp7j4s4Q3aCO6JdI/MQBixPoYKElyC2opOx8PMWuqqw==
X-Received: by 2002:a05:6000:4304:b0:38f:4f60:e669 with SMTP id ffacd0b85a97d-3a074e3c47cmr1386882f8f.29.1745577178843;
        Fri, 25 Apr 2025 03:32:58 -0700 (PDT)
Received: from [192.168.69.169] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e46976sm1941254f8f.63.2025.04.25.03.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 03:32:58 -0700 (PDT)
Message-ID: <6a93fa6b-d38d-48ac-9cde-488765238247@linaro.org>
Date: Fri, 25 Apr 2025 12:32:57 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] i386/kvm: Support fixed counter in KVM PMU filter
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Michael Roth <michael.roth@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Marcelo Tosatti
 <mtosatti@redhat.com>, Shaoqin Huang <shahuang@redhat.com>,
 Eric Auger <eauger@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
 <20250409082649.14733-6-zhao1.liu@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250409082649.14733-6-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/25 10:26, Zhao Liu wrote:
> KVM_SET_PMU_EVENT_FILTER of x86 KVM allows user to configure x86 fixed
> function counters by a bitmap.
> 
> Add the support of x86-fixed-counter in kvm-pmu-filter object and handle
> this in i386 kvm codes.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---
> Changes since RFC v2:
>   * Drop KVMPMUX86FixedCounter structure and use uint32_t to represent
>     bitmap in QAPI directly.
>   * Add Tested-by from Yi.
>   * Add documentation in qemu-options.hx.
>   * Bump up the supported QAPI version to v10.1.
> 
> Changes since RFC v1:
>   * Make "action" as a global (per filter object) item, not a per-counter
>     parameter. (Dapeng)
>   * Bump up the supported QAPI version to v10.0.
> ---
>   accel/kvm/kvm-pmu.c      | 31 +++++++++++++++++++++++++++++++
>   include/system/kvm-pmu.h |  5 ++++-
>   qapi/kvm.json            |  6 +++++-
>   qemu-options.hx          |  6 +++++-
>   target/i386/kvm/kvm.c    | 39 ++++++++++++++++++++++++---------------
>   5 files changed, 69 insertions(+), 18 deletions(-)
> 
> diff --git a/accel/kvm/kvm-pmu.c b/accel/kvm/kvm-pmu.c
> index 9205907d1779..509d69d9c515 100644
> --- a/accel/kvm/kvm-pmu.c
> +++ b/accel/kvm/kvm-pmu.c
> @@ -101,6 +101,29 @@ fail:
>       qapi_free_KvmPmuFilterEventList(head);
>   }
>   
> +static void kvm_pmu_filter_get_fixed_counter(Object *obj, Visitor *v,
> +                                             const char *name, void *opaque,
> +                                             Error **errp)
> +{
> +    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
> +
> +    visit_type_uint32(v, name, &filter->x86_fixed_counter, errp);
> +}
> +
> +static void kvm_pmu_filter_set_fixed_counter(Object *obj, Visitor *v,
> +                                             const char *name, void *opaque,
> +                                             Error **errp)
> +{
> +    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
> +    uint32_t counter;
> +
> +    if (!visit_type_uint32(v, name, &counter, errp)) {
> +        return;
> +    }
> +
> +    filter->x86_fixed_counter = counter;
> +}
> +
>   static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
>   {
>       object_class_property_add_enum(oc, "action", "KvmPmuFilterAction",
> @@ -116,6 +139,14 @@ static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
>                                 NULL, NULL);
>       object_class_property_set_description(oc, "events",
>                                             "KVM PMU event list");
> +
> +    object_class_property_add(oc, "x86-fixed-counter", "uint32_t",
> +                              kvm_pmu_filter_get_fixed_counter,
> +                              kvm_pmu_filter_set_fixed_counter,
> +                              NULL, NULL);
> +    object_class_property_set_description(oc, "x86-fixed-counter",
> +                                          "Enablement bitmap of "
> +                                          "x86 PMU fixed counter");

Adding that x86-specific field to all architectures is a bit dubious.

>   }
>   
>   static void kvm_pmu_filter_instance_init(Object *obj)
> diff --git a/include/system/kvm-pmu.h b/include/system/kvm-pmu.h
> index 6abc0d037aee..5238b2b4dcc7 100644
> --- a/include/system/kvm-pmu.h
> +++ b/include/system/kvm-pmu.h
> @@ -19,10 +19,12 @@ OBJECT_DECLARE_SIMPLE_TYPE(KVMPMUFilter, KVM_PMU_FILTER)
>   
>   /**
>    * KVMPMUFilter:
> - * @action: action that KVM PMU filter will take for selected PMU events.
> + * @action: action that KVM PMU filter will take for selected PMU events
> + *    and counters.
>    * @nevents: number of PMU event entries listed in @events
>    * @events: list of PMU event entries.  A PMU event entry may represent one
>    *    event or multiple events due to its format.
> + * @x86_fixed_counter: bitmap of x86 fixed counter.
>    */
>   struct KVMPMUFilter {
>       Object parent_obj;
> @@ -30,6 +32,7 @@ struct KVMPMUFilter {
>       KvmPmuFilterAction action;
>       uint32_t nevents;
>       KvmPmuFilterEventList *events;
> +    uint32_t x86_fixed_counter;
>   };

