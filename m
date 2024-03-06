Return-Path: <kvm+bounces-11212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DE91874303
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FDA9B2302E
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2878D1C294;
	Wed,  6 Mar 2024 22:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zo9snahb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A578E1B59D
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 22:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709765512; cv=none; b=JT1AKdGt+wvPVFReiLnFmW37LTEBZf7rIUFKQAqBcNMIVWYffhn1KheYLxbN6ZIjRc0BzHN3Za249aDxU2mm/Q8lIPQhts59ATcvKXzfZTzctKEvJFF35/KIVedv8bd/X/tuyVBAZkOdATvmhZOJ0BRtyr1kqZH1D5+FhnB8vdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709765512; c=relaxed/simple;
	bh=G0luUsVUXqMmFI4TeATa7Q9i0FGHfpzsu2ZHiJZ24Z4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QyxSP5r2P4CR6weqHUrGR9UZVaft4jCqh41uj4YktseIJf+Zik1Emib7jc8R9agFhQi0oKcDNaVj93VNuayevTVEI6K9SeW0pN9gjO0o0/IcmEXBgybu5y0s6jNcrY7SuKxYgLGqPFZH1H/h+DK/EF5DT/0c9702EXtPCTSXwEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zo9snahb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709765509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H+214zJq4+PGenKyaJZt8PX4Iig/W74yJ6h+EMR0lKM=;
	b=Zo9snahbsbxwKeZXXHS01mOrTqtDogchVMN+cnugSLaWwJTW33OKLxPrXa6LQcc/GE4Fxq
	mUftg8ES/TLN2uCmF8f4hLRM/5xMrwr5l3n4Wmg8wQz3WwO66b6yliPv3nMqBQB1KmRFi/
	7JUbE+tJiRe6WAYuf4xEwcbj4sZqY58=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-QMRfnRkeOyOeQNNsBRhAJw-1; Wed, 06 Mar 2024 17:51:48 -0500
X-MC-Unique: QMRfnRkeOyOeQNNsBRhAJw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-412d557cea6so1735625e9.1
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 14:51:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709765507; x=1710370307;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H+214zJq4+PGenKyaJZt8PX4Iig/W74yJ6h+EMR0lKM=;
        b=Gpk6yWhvb9I0o5wi2UpDhq1TJLYGRq43qO6jTOERp92bptwvWefKjl9MYaBvNYj0PS
         c5I6DGLye6TgdCi6Yqaq4b/IePPRr0GdrICYxFyhsVrscZhsD+5EG/k9pwdkJE/vYutS
         75VSq/fHDcIHFLh3pGiCL6YU63l5mLGYD6vSnQ1Xl97dNiehN2jTWgHufj2+wOMGlsBB
         yxG3NmCGCaNHyh7C48cQH3jgCKwttLMWsd8JzQHKWVTn7YbeTu2KVJgW3zosuhFPGmtB
         HkXuLrxGED2iZSCz8EJRGAxclqVG0PH1gyQQyR7TrM1zu96WmTK/l/2L77H4y1lvanBc
         Lkow==
X-Forwarded-Encrypted: i=1; AJvYcCXalFqTz3dinRB1C0yegH7GKDk9yfzVPoa5OFLHjlFih40OQgc94z6Ztq6actDnhMYejuvFQpS/MpeKvCn6OKbyN/1Y
X-Gm-Message-State: AOJu0YzXAwVqUnHhgDm6k/9etwHcL2/kwm/zS9KPqMvKC3mAG0YXnHnN
	XTJGd71Mwlj/IbRIZhYpvZ1bsxyJZPpSAcC/DBOpAceMDp4USjNcJL8vECMFjyO89OVi6Y4ovJf
	2d+Vdrr8Hz2O1b1Q4TA11N71FDJtHS3pYFoKUC9H1McQfawz3oA==
X-Received: by 2002:a05:600c:1c89:b0:412:d149:254c with SMTP id k9-20020a05600c1c8900b00412d149254cmr9760667wms.17.1709765506887;
        Wed, 06 Mar 2024 14:51:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHyy9kRGSYZILnWvvlPVhZ51eJbxvphBCxuj9yEWlawmPdeIT8WA5Y7KS8iOIhWaop5KJd00g==
X-Received: by 2002:a05:600c:1c89:b0:412:d149:254c with SMTP id k9-20020a05600c1c8900b00412d149254cmr9760659wms.17.1709765506553;
        Wed, 06 Mar 2024 14:51:46 -0800 (PST)
Received: from [192.168.10.118] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id b29-20020a05600c4a9d00b00412f4afab4csm1203055wmp.1.2024.03.06.14.51.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 14:51:46 -0800 (PST)
Message-ID: <33bac01d-6343-4bbb-8baf-f6a741b026ce@redhat.com>
Date: Wed, 6 Mar 2024 23:51:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vmbus: Print a warning when enabled without the
 recommended set of features
Content-Language: en-US
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
 David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
References: <e2d961d56d795fe42ea54f1272c7157e40aeae1e.1706198618.git.maciej.szmigiero@oracle.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <e2d961d56d795fe42ea54f1272c7157e40aeae1e.1706198618.git.maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/25/24 17:19, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Some Windows versions crash at boot or fail to enable the VMBus device if
> they don't see the expected set of Hyper-V features (enlightenments).
> 
> Since this provides poor user experience let's warn user if the VMBus
> device is enabled without the recommended set of Hyper-V features.
> 
> The recommended set is the minimum set of Hyper-V features required to make
> the VMBus device work properly in Windows Server versions 2016, 2019 and
> 2022.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks,

Paolo

> ---
>   hw/hyperv/hyperv.c            | 12 ++++++++++++
>   hw/hyperv/vmbus.c             |  6 ++++++
>   include/hw/hyperv/hyperv.h    |  4 ++++
>   target/i386/kvm/hyperv-stub.c |  4 ++++
>   target/i386/kvm/hyperv.c      |  5 +++++
>   target/i386/kvm/hyperv.h      |  2 ++
>   target/i386/kvm/kvm.c         |  7 +++++++
>   7 files changed, 40 insertions(+)
> 
> diff --git a/hw/hyperv/hyperv.c b/hw/hyperv/hyperv.c
> index 57b402b95610..2c91de7ff4a8 100644
> --- a/hw/hyperv/hyperv.c
> +++ b/hw/hyperv/hyperv.c
> @@ -947,3 +947,15 @@ uint64_t hyperv_syndbg_query_options(void)
>   
>       return msg.u.query_options.options;
>   }
> +
> +static bool vmbus_recommended_features_enabled;
> +
> +bool hyperv_are_vmbus_recommended_features_enabled(void)
> +{
> +    return vmbus_recommended_features_enabled;
> +}
> +
> +void hyperv_set_vmbus_recommended_features_enabled(void)
> +{
> +    vmbus_recommended_features_enabled = true;
> +}
> diff --git a/hw/hyperv/vmbus.c b/hw/hyperv/vmbus.c
> index 380239af2c7b..f33afeeea27d 100644
> --- a/hw/hyperv/vmbus.c
> +++ b/hw/hyperv/vmbus.c
> @@ -2631,6 +2631,12 @@ static void vmbus_bridge_realize(DeviceState *dev, Error **errp)
>           return;
>       }
>   
> +    if (!hyperv_are_vmbus_recommended_features_enabled()) {
> +        warn_report("VMBus enabled without the recommended set of Hyper-V features: "
> +                    "hv-stimer, hv-vapic and hv-runtime. "
> +                    "Some Windows versions might not boot or enable the VMBus device");
> +    }
> +
>       bridge->bus = VMBUS(qbus_new(TYPE_VMBUS, dev, "vmbus"));
>   }
>   
> diff --git a/include/hw/hyperv/hyperv.h b/include/hw/hyperv/hyperv.h
> index 015c3524b1c2..d717b4e13d40 100644
> --- a/include/hw/hyperv/hyperv.h
> +++ b/include/hw/hyperv/hyperv.h
> @@ -139,4 +139,8 @@ typedef struct HvSynDbgMsg {
>   } HvSynDbgMsg;
>   typedef uint16_t (*HvSynDbgHandler)(void *context, HvSynDbgMsg *msg);
>   void hyperv_set_syndbg_handler(HvSynDbgHandler handler, void *context);
> +
> +bool hyperv_are_vmbus_recommended_features_enabled(void);
> +void hyperv_set_vmbus_recommended_features_enabled(void);
> +
>   #endif
> diff --git a/target/i386/kvm/hyperv-stub.c b/target/i386/kvm/hyperv-stub.c
> index 778ed782e6fc..3263dcf05d31 100644
> --- a/target/i386/kvm/hyperv-stub.c
> +++ b/target/i386/kvm/hyperv-stub.c
> @@ -52,3 +52,7 @@ void hyperv_x86_synic_reset(X86CPU *cpu)
>   void hyperv_x86_synic_update(X86CPU *cpu)
>   {
>   }
> +
> +void hyperv_x86_set_vmbus_recommended_features_enabled(void)
> +{
> +}
> diff --git a/target/i386/kvm/hyperv.c b/target/i386/kvm/hyperv.c
> index 6825c89af374..f2a3fe650a18 100644
> --- a/target/i386/kvm/hyperv.c
> +++ b/target/i386/kvm/hyperv.c
> @@ -149,3 +149,8 @@ int kvm_hv_handle_exit(X86CPU *cpu, struct kvm_hyperv_exit *exit)
>           return -1;
>       }
>   }
> +
> +void hyperv_x86_set_vmbus_recommended_features_enabled(void)
> +{
> +    hyperv_set_vmbus_recommended_features_enabled();
> +}
> diff --git a/target/i386/kvm/hyperv.h b/target/i386/kvm/hyperv.h
> index 67543296c3a4..e3982c8f4dd1 100644
> --- a/target/i386/kvm/hyperv.h
> +++ b/target/i386/kvm/hyperv.h
> @@ -26,4 +26,6 @@ int hyperv_x86_synic_add(X86CPU *cpu);
>   void hyperv_x86_synic_reset(X86CPU *cpu);
>   void hyperv_x86_synic_update(X86CPU *cpu);
>   
> +void hyperv_x86_set_vmbus_recommended_features_enabled(void);
> +
>   #endif
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index e88e65fe014c..d3d01b3cf82d 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1650,6 +1650,13 @@ static int hyperv_init_vcpu(X86CPU *cpu)
>           }
>       }
>   
> +    /* Skip SynIC and VP_INDEX since they are hard deps already */
> +    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_STIMER) &&
> +        hyperv_feat_enabled(cpu, HYPERV_FEAT_VAPIC) &&
> +        hyperv_feat_enabled(cpu, HYPERV_FEAT_RUNTIME)) {
> +        hyperv_x86_set_vmbus_recommended_features_enabled();
> +    }
> +
>       return 0;
>   }
>   
> 
> 


