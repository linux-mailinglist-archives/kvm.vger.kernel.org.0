Return-Path: <kvm+bounces-2483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 591077F9867
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 05:36:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E443BB20B57
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3E21879;
	Mon, 27 Nov 2023 04:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YDgo6p9X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E403A111
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701059786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uB8RtCVtSAfV4uboXXib4r70O1crEDrMolu/UkoV8Y0=;
	b=YDgo6p9XSS/vuPrtqeL4A0KCBwiN8hI9ABjdAgBwTpZ8SmLOUVQgFMQhoR972mkzOOI/N1
	Bxt0LxoDeOfb/Xpw6cpshZmern/E1SuziPYZjPh0gIZXICrRZUBYT5IVghwS+htVFBE5ly
	go7OuEU88+wga7vThTOCq3t1S6X05PY=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-zbgyYZH1P7KTuxXCRxwCbQ-1; Sun, 26 Nov 2023 23:36:24 -0500
X-MC-Unique: zbgyYZH1P7KTuxXCRxwCbQ-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6d646f61253so4625500a34.0
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:36:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701059784; x=1701664584;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uB8RtCVtSAfV4uboXXib4r70O1crEDrMolu/UkoV8Y0=;
        b=X0u7MUQlV65iYgOQXO50IqCPJznH1PA3XrA2+f1hMtZac4VXirCp76js0k84maZU3F
         p1FG//Q+65syz91hp1B2wymPNERTWDlSm8OklTG4nyNokfLlOE3IgJVH01UcFMqGeR/v
         29J296S50RbCf8r+PPkQqNiJfkDiDlCMjlUCJNol4v2P33v61G2W2aX3CM9BElsEPWKo
         qVjg30NoF1ukgSFTxnXfjjO0HcmXRZTm06Sqwl8R5aosAS9Z0qfMHNGyfdeF7R9NzwP3
         7KtvIkL2vjGfxUris3w5BryNXegqNxa4K9taCFvWu9xjR/rIQE3lwo8Dz6tdaqbDFpua
         /5HQ==
X-Gm-Message-State: AOJu0YxnL3Hw1T2w9ew6aeqRp+WmsrBmWetiL/RkdIeC2XKx/0kKcNul
	dlMn9bWcM/iq+rdEDcj4nt0yjEXH0RQWx/gxqbpLGyJuE5LMXIpNo+zf0BaMqTXaDdQMAfkOtc7
	5GgL3S9X1GLDl
X-Received: by 2002:a05:6870:ea08:b0:1fa:1efd:f65e with SMTP id g8-20020a056870ea0800b001fa1efdf65emr9308578oap.21.1701059784159;
        Sun, 26 Nov 2023 20:36:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHS3kztNt48niItFPhRKBja756oNavjoZfrYv85qD4BdhzRiKHQ1nqW8EJ9HSaJNJ1pWad57w==
X-Received: by 2002:a05:6870:ea08:b0:1fa:1efd:f65e with SMTP id g8-20020a056870ea0800b001fa1efdf65emr9308568oap.21.1701059783938;
        Sun, 26 Nov 2023 20:36:23 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id j25-20020a62e919000000b006930db1e6cfsm6334347pfh.62.2023.11.26.20.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 20:36:23 -0800 (PST)
Message-ID: <9c1cb48a-9de0-45ed-80e3-2ea4d4d5bff3@redhat.com>
Date: Mon, 27 Nov 2023 15:36:19 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 16/16] target/arm/kvm: Have
 kvm_arm_hw_debug_active take a ARMCPU argument
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-17-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231123183518.64569-17-philmd@linaro.org>
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
>   target/arm/kvm.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 

With the following comments addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 1f6da5529f..cbfea689cc 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1455,11 +1455,11 @@ int kvm_arch_process_async_events(CPUState *cs)
>   
>   /**
>    * kvm_arm_hw_debug_active:
> - * @cs: CPU State
> + * @cpu: ARMCPU
>    *
>    * Return: TRUE if any hardware breakpoints in use.
>    */
> -static bool kvm_arm_hw_debug_active(CPUState *cs)
> +static bool kvm_arm_hw_debug_active(ARMCPU *cpu)
>   {
>       return ((cur_hw_wps > 0) || (cur_hw_bps > 0));
>   }

Either @cs or @cpu isn't dereferenced in kvm_arm_hw_debug_active(). So I guess
the argument can be simply droped?

> @@ -1493,7 +1493,7 @@ void kvm_arch_update_guest_debug(CPUState *cs, struct kvm_guest_debug *dbg)
>       if (kvm_sw_breakpoints_active(cs)) {
>           dbg->control |= KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
>       }
> -    if (kvm_arm_hw_debug_active(cs)) {
> +    if (kvm_arm_hw_debug_active(ARM_CPU(cs))) {
>           dbg->control |= KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW;
>           kvm_arm_copy_hw_debug_data(&dbg->arch);
>       }

Thanks,
Gavin


