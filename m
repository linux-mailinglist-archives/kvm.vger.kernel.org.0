Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4854075F1DE
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 12:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbjGXKCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 06:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjGXKBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 06:01:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D84065B4
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690192425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W8BnD/WmjfxcZiGA/dUP3aM2hxnahbkcOcilHinU3gM=;
        b=KdcIa3LR4CJVBTxXodS/zNWfvoR0k+YIUfdSVN9TWEVFeSg0OYfzoOE5GQubndxVwk3AR7
        OOQg7kwmZEzkRkdj+tjjuehZrqvaSHGZJ0BOGCoP97/y7ByC7utAJ8xLDKvy7qRPRP0wfn
        l0V/BQtvPbEbKWMs6xOR8pimWXfouzo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-3hdcpRhxM02L7j3eOEfaTQ-1; Mon, 24 Jul 2023 05:53:43 -0400
X-MC-Unique: 3hdcpRhxM02L7j3eOEfaTQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-31758708b57so811961f8f.1
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:53:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690192422; x=1690797222;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W8BnD/WmjfxcZiGA/dUP3aM2hxnahbkcOcilHinU3gM=;
        b=ThLwHq4TgrmNhqf2o7Q/eKBGBpfT9/U1v9S4wZ6ufgwFis/zWJmX4x2cJ61QtsS8oH
         Ol+BJZ4qJGoFwvLvJO5VryqzHTPw9YVbU1Qg0pq7yktnSsYqoZCA23SVWnD1Wjrprb5m
         nziOIXfo0ztlRPUXn8NGx+lsd8gupDhOb3KoPYFQkntgAEwb1lOCRZvSUrtXzZMYBYFT
         affJyCua942o0h+Z1r3cWgA22vAWvWPK4riTWU4Ka4hOx+Maxq3CcgWLvMcL1D28dcZi
         3jG+iJHX6bLxPpCDfJasRFRdau4Ty/cRQcdV4wy6tzziUQJqIAL/z5mA5v6pyx+IkkgF
         oQBQ==
X-Gm-Message-State: ABy/qLZ+I3P7zLnoi1jAPK4vJsIi7YPI5FTs07XkwUcaC0cR/tEsbvpp
        dYQGAsvlcCoaWzkVXiAQlTTMUissRFdb6etxIqB2P0kskx7hY672BqzKfMsovhV9oz5F610YGvZ
        jbTiC6giS9U4tSJAr9iGh
X-Received: by 2002:a5d:50c7:0:b0:315:99be:6fe4 with SMTP id f7-20020a5d50c7000000b0031599be6fe4mr7650815wrt.69.1690192422001;
        Mon, 24 Jul 2023 02:53:42 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGxbWUV0xYlSpNLpOV84UuVEJ8ow6uwWgFdY0GnM3+jt3qIuyL2U8kIgBOuTPi71Pe686AN4g==
X-Received: by 2002:a5d:50c7:0:b0:315:99be:6fe4 with SMTP id f7-20020a5d50c7000000b0031599be6fe4mr7650795wrt.69.1690192421663;
        Mon, 24 Jul 2023 02:53:41 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-177-165.web.vodafone.de. [109.43.177.165])
        by smtp.gmail.com with ESMTPSA id m12-20020adff38c000000b003145559a691sm12402548wro.41.2023.07.24.02.53.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 02:53:41 -0700 (PDT)
Message-ID: <81dd6b4c-200f-bb35-69fa-ed623eb7e6d1@redhat.com>
Date:   Mon, 24 Jul 2023 11:53:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] kvm: Remove KVM_CREATE_IRQCHIP support assumption
Content-Language: en-US
To:     Andrew Jones <ajones@ventanamicro.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, peter.maydell@linaro.org,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        dbarboza@ventanamicro.com, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, qemu-s390x@nongnu.org
References: <20230722062115.11950-2-ajones@ventanamicro.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230722062115.11950-2-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/07/2023 08.21, Andrew Jones wrote:
> Since Linux commit 00f918f61c56 ("RISC-V: KVM: Skeletal in-kernel AIA
> irqchip support") checking KVM_CAP_IRQCHIP returns non-zero when the
> RISC-V platform has AIA. The cap indicates KVM supports at least one
> of the following ioctls:
> 
>    KVM_CREATE_IRQCHIP
>    KVM_IRQ_LINE
>    KVM_GET_IRQCHIP
>    KVM_SET_IRQCHIP
>    KVM_GET_LAPIC
>    KVM_SET_LAPIC
> 
> but the cap doesn't imply that KVM must support any of those ioctls
> in particular. However, QEMU was assuming the KVM_CREATE_IRQCHIP
> ioctl was supported. Stop making that assumption by introducing a
> KVM parameter that each architecture which supports KVM_CREATE_IRQCHIP
> sets. Adding parameters isn't awesome, but given how the
> KVM_CAP_IRQCHIP isn't very helpful on its own, we don't have a lot of
> options.
> 
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
> 
> While this fixes booting guests on riscv KVM with AIA it's unlikely
> to get merged before the QEMU support for KVM AIA[1] lands, which
> would also fix the issue. I think this patch is still worth considering
> though since QEMU's assumption is wrong.
> 
> [1] https://lore.kernel.org/all/20230714084429.22349-1-yongxuan.wang@sifive.com/
> 
> 
>   accel/kvm/kvm-all.c    | 5 ++++-
>   include/sysemu/kvm.h   | 1 +
>   target/arm/kvm.c       | 3 +++
>   target/i386/kvm/kvm.c  | 2 ++
>   target/s390x/kvm/kvm.c | 3 +++
>   5 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 373d876c0580..0f5ff8630502 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -86,6 +86,7 @@ struct KVMParkedVcpu {
>   };
>   
>   KVMState *kvm_state;
> +bool kvm_has_create_irqchip;
>   bool kvm_kernel_irqchip;
>   bool kvm_split_irqchip;
>   bool kvm_async_interrupts_allowed;
> @@ -2377,8 +2378,10 @@ static void kvm_irqchip_create(KVMState *s)
>           if (s->kernel_irqchip_split == ON_OFF_AUTO_ON) {
>               error_report("Split IRQ chip mode not supported.");
>               exit(1);
> -        } else {
> +        } else if (kvm_has_create_irqchip) {
>               ret = kvm_vm_ioctl(s, KVM_CREATE_IRQCHIP);
> +        } else {
> +            return;
>           }
>       }
>       if (ret < 0) {

I think I'd do this differntly... at the beginning of the function, there is 
a check for kvm_check_extension(s, KVM_CAP_IRQCHIP) etc. ... I think you 
could now replace that check with a simple

	if (!kvm_has_create_irqchip) {
		return;
	}

The "kvm_vm_enable_cap(s, KVM_CAP_S390_IRQCHIP, 0)" of course has to be 
moved to the target/s390x/kvm/kvm.c file, too.

  Thomas


> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 115f0cca79d1..84b1bb3dc91e 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -32,6 +32,7 @@
>   #ifdef CONFIG_KVM_IS_POSSIBLE
>   
>   extern bool kvm_allowed;
> +extern bool kvm_has_create_irqchip;
>   extern bool kvm_kernel_irqchip;
>   extern bool kvm_split_irqchip;
>   extern bool kvm_async_interrupts_allowed;
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index b4c7654f4980..2fa87b495d68 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -250,6 +250,9 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
>   int kvm_arch_init(MachineState *ms, KVMState *s)
>   {
>       int ret = 0;
> +
> +    kvm_has_create_irqchip = kvm_check_extension(s, KVM_CAP_IRQCHIP);
> +
>       /* For ARM interrupt delivery is always asynchronous,
>        * whether we are using an in-kernel VGIC or not.
>        */
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index ebfaf3d24c79..6363e67f092d 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2771,6 +2771,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>           }
>       }
>   
> +    kvm_has_create_irqchip = kvm_check_extension(s, KVM_CAP_IRQCHIP);
> +
>       return 0;
>   }
>   
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index a9e5880349d9..c053304adf94 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -391,6 +391,9 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>       }
>   
>       kvm_set_max_memslot_size(KVM_SLOT_MAX_BYTES);
> +
> +    kvm_has_create_irqchip = kvm_check_extension(s, KVM_CAP_S390_IRQCHIP);
> +
>       return 0;
>   }
>   

