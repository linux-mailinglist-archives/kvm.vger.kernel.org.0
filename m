Return-Path: <kvm+bounces-2471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87AB97F9826
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 05:12:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C6AD280DFE
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D18C539D;
	Mon, 27 Nov 2023 04:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SCgIMSBH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E70FE8
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701058339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=67A6reGph7OBDqrRqdMlH2sW1EYf0zn15yqP5FYtCnU=;
	b=SCgIMSBH92OjOB8dCLYUcRr03mo6LNPg5tp7/FFSBoyx0h6iKe5tmZ1kCSMlMeUF4pT6ue
	Y2aMU+F0NhmtNv6MYcoTJED7EVeMqBK3U0jMHd4biAYd8pX3/KVTTcRkmUuPLVGFNKi3zQ
	Q7IlPX+cxGse1J6s3Qm302Ckpu/XeGg=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-4UBrlDgiO9qnsGv4gZRKbw-1; Sun, 26 Nov 2023 23:12:15 -0500
X-MC-Unique: 4UBrlDgiO9qnsGv4gZRKbw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5bd18d54a48so3735157a12.0
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:12:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701058335; x=1701663135;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=67A6reGph7OBDqrRqdMlH2sW1EYf0zn15yqP5FYtCnU=;
        b=pmeDLfiv+8ZyWw7vavVbSChfJVIT9VX8CUG9WOsqGqcY3Odj1oqOfMd4BnIWp4D8Nf
         Te1esnhNpn4OO4T18PMp48fy4fNrrYNPI47hffaXQu0B4R/bwKgzCglx3jdN2eC/2ZBq
         M62jL4lppCRiJBncCsnwDQwgry88yzSebcVtaVRsFOQQAIvy6024rac6aZQwgSBKLRFM
         2FZSHEDd7LNiH4x8IdSEdktl1+YtSJ0omBVdnxJ4vi8nwLT4bWZyVpdJm5jQTN2XiEcW
         U+5/2zs1999TYPSUMur3IH8EZ9XDXHvUSZB2KzOlpyedQO/b340QHjekDH9LiaRd8Ijb
         +Iew==
X-Gm-Message-State: AOJu0YwBbcGvy4Himft4mBDsZmNBN9ihFuGzdNSeNazjUPW5W5vmYTdy
	LGBTX33Ojm26bNEF4mNuGfT6bfvo02vo41hFzXAelL2H/XbdVd9C2UrlraFcNWYfz57LpOI42UO
	f/SCVzjE00Ykg
X-Received: by 2002:a05:6a20:7d89:b0:189:b618:1736 with SMTP id v9-20020a056a207d8900b00189b6181736mr12382811pzj.57.1701058334718;
        Sun, 26 Nov 2023 20:12:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHSDd4AtOdVN2L90B0w3l0OXzwCUCzv6le27hMT8UJkoQ+VC0ZETzVfDuabM5RN4XqjwPhDXA==
X-Received: by 2002:a05:6a20:7d89:b0:189:b618:1736 with SMTP id v9-20020a056a207d8900b00189b6181736mr12382802pzj.57.1701058334453;
        Sun, 26 Nov 2023 20:12:14 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902ee8900b001ca86a9caccsm7173261pld.228.2023.11.26.20.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 20:12:14 -0800 (PST)
Message-ID: <54a38178-18ca-4bea-9d5d-af34114dda5b@redhat.com>
Date: Mon, 27 Nov 2023 15:12:10 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 05/16] target/arm/kvm: Have kvm_arm_sve_get_vls
 take a ARMCPU argument
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-6-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231123183518.64569-6-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Phil,

On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
> Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
> take a ARMCPU* argument. Use the CPU() QOM cast macro When
> calling the generic vCPU API from "sysemu/kvm.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/arm/kvm_arm.h | 6 +++---
>   target/arm/cpu64.c   | 2 +-
>   target/arm/kvm.c     | 2 +-
>   3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index 6fb8a5f67e..84f87f5ed7 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -129,13 +129,13 @@ void kvm_arm_destroy_scratch_host_vcpu(int *fdarray);
>   
>   /**
>    * kvm_arm_sve_get_vls:
> - * @cs: CPUState
> + * @cpu: ARMCPU
>    *
>    * Get all the SVE vector lengths supported by the KVM host, setting
>    * the bits corresponding to their length in quadwords minus one
>    * (vq - 1) up to ARM_MAX_VQ.  Return the resulting map.
>    */
> -uint32_t kvm_arm_sve_get_vls(CPUState *cs);
> +uint32_t kvm_arm_sve_get_vls(ARMCPU *cpu);
>   

Either @cs or @cpu isn't dereferenced in kvm_arm_sve_get_vls(). So I guess
the argument can be simply droped?

>   /**
>    * kvm_arm_set_cpu_features_from_host:
> @@ -278,7 +278,7 @@ static inline void kvm_arm_steal_time_finalize(ARMCPU *cpu, Error **errp)
>       g_assert_not_reached();
>   }
>   
> -static inline uint32_t kvm_arm_sve_get_vls(CPUState *cs)
> +static inline uint32_t kvm_arm_sve_get_vls(ARMCPU *cpu)
>   {
>       g_assert_not_reached();
>   }
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index 1e9c6c85ae..8e30a7993e 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -66,7 +66,7 @@ void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
>        */
>       if (kvm_enabled()) {
>           if (kvm_arm_sve_supported()) {
> -            cpu->sve_vq.supported = kvm_arm_sve_get_vls(CPU(cpu));
> +            cpu->sve_vq.supported = kvm_arm_sve_get_vls(cpu);
>               vq_supported = cpu->sve_vq.supported;
>           } else {
>               assert(!cpu_isar_feature(aa64_sve, cpu));
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 71833a845a..766a077bcf 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1803,7 +1803,7 @@ bool kvm_arm_sve_supported(void)
>   
>   QEMU_BUILD_BUG_ON(KVM_ARM64_SVE_VQ_MIN != 1);
>   
> -uint32_t kvm_arm_sve_get_vls(CPUState *cs)
> +uint32_t kvm_arm_sve_get_vls(ARMCPU *cpu)
>   {
>       /* Only call this function if kvm_arm_sve_supported() returns true. */
>       static uint64_t vls[KVM_ARM64_SVE_VLS_WORDS];

Thanks,
Gavin


