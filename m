Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACA05E821C
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 20:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiIWSwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 14:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIWSwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 14:52:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668F9121125
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 11:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663959153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PwEuQBLi537kQdUZzr3rjI1uvJzPmgfNaZEmLsxs2Tg=;
        b=BiwGLVHkyWC1Cm+5mEPcpbYY177l2fiqgp4qVuBgsxoea9XBss9gQc1QLUgs3fbMg9i0rP
        z5E7Z3/evsQwt1Z6S6LNoBZ66ut1KjG5VLBrXGCjcIki7vNmyh1BtWYwEE08Mi3FOn3LI5
        fIBrZP/4Q38ISkaPueXmngCkCMKDG6Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-524-LG_wpoAhNO2sTt5pPTQZ1g-1; Fri, 23 Sep 2022 14:52:30 -0400
X-MC-Unique: LG_wpoAhNO2sTt5pPTQZ1g-1
Received: by mail-wm1-f70.google.com with SMTP id p24-20020a05600c1d9800b003b4b226903dso3111308wms.4
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 11:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=PwEuQBLi537kQdUZzr3rjI1uvJzPmgfNaZEmLsxs2Tg=;
        b=wr/qnvC7f+Agh8ZLNderN1dNECdlL49NsqZfoh4QfdWIrcI16uTFUl2MW7eKx5LK1C
         H9qe1qUryfhmngjLjxg++aTe8Z6U3dhRZI4NmJNxZPY54epoqx/gBu/RQngGrWM8AzRE
         t2wonvpRPr5y5Jt2V5czD95dVeE5PR0w9Yr5dAPfBNBpaVFVikha8DZheoYfIr42MOek
         /MrXAzzJisLZUZthdtDe7Wxl5tDmaxZ9CL6ylJVoLQe/TtecdC9LT2CZ5VmYgzPAjYSR
         LrMSgS1a3QWOyE56AzX67GCHw3WuDZtpWFp8HyPEdHUyBY6I9YkZFgQwuDE69glXdi7G
         IzvQ==
X-Gm-Message-State: ACrzQf2blBV2SFmR2jbKiaYfBkzEvmAE/kU/98UYeOJhzYLJ6HM9Hn9Z
        p2JGxv/Tbl48qdwYV44NYhpeLw9i1S1zTR5+kBtEOgMnrMs9c1w+2hfG2DK8++HmvTNdqbi8SF4
        OV7oKW5Jhfr8W
X-Received: by 2002:a05:600c:5124:b0:3b4:faef:87be with SMTP id o36-20020a05600c512400b003b4faef87bemr7232420wms.68.1663959149597;
        Fri, 23 Sep 2022 11:52:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4YxpwK/kZZ2rKKmU0xYSHyUVcBkpC7nualkqDg1Us/X/9uNGeB20SLdeJhnxmdRvEWPOmu3Q==
X-Received: by 2002:a05:600c:5124:b0:3b4:faef:87be with SMTP id o36-20020a05600c512400b003b4faef87bemr7232400wms.68.1663959149362;
        Fri, 23 Sep 2022 11:52:29 -0700 (PDT)
Received: from [192.168.8.103] (tmo-097-189.customers.d1-online.com. [80.187.97.189])
        by smtp.gmail.com with ESMTPSA id e2-20020a5d5302000000b00225239d9265sm8061515wrv.74.2022.09.23.11.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 11:52:28 -0700 (PDT)
Message-ID: <26a30e36-755a-8c77-316d-6dc4999c50e4@redhat.com>
Date:   Fri, 23 Sep 2022 20:52:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v8 8/8] s390x/s390-virtio-ccw: add zpcii-disable machine
 property
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220902172737.170349-1-mjrosato@linux.ibm.com>
 <20220902172737.170349-9-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220902172737.170349-9-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/2022 19.27, Matthew Rosato wrote:
> The zpcii-disable machine property can be used to force-disable the use
> of zPCI interpretation facilities for a VM.  By default, this setting
> will be off for machine 7.2 and newer.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-kvm.c            |  4 +++-
>   hw/s390x/s390-virtio-ccw.c         | 25 +++++++++++++++++++++++++
>   include/hw/s390x/s390-virtio-ccw.h |  1 +
>   qemu-options.hx                    |  8 +++++++-
>   util/qemu-config.c                 |  4 ++++
>   5 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/s390x/s390-pci-kvm.c b/hw/s390x/s390-pci-kvm.c
> index 9134fe185f..5eb7fd12e2 100644
> --- a/hw/s390x/s390-pci-kvm.c
> +++ b/hw/s390x/s390-pci-kvm.c
> @@ -22,7 +22,9 @@
>   
>   bool s390_pci_kvm_interp_allowed(void)
>   {
> -    return kvm_s390_get_zpci_op() && !s390_is_pv();
> +    return (kvm_s390_get_zpci_op() && !s390_is_pv() &&
> +            !object_property_get_bool(OBJECT(qdev_get_machine()),
> +                                      "zpcii-disable", NULL));
>   }
>   
>   int s390_pci_kvm_aif_enable(S390PCIBusDevice *pbdev, ZpciFib *fib, bool assist)
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 9a2467c889..f8ecb6172c 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -645,6 +645,21 @@ static inline void machine_set_dea_key_wrap(Object *obj, bool value,
>       ms->dea_key_wrap = value;
>   }
>   
> +static inline bool machine_get_zpcii_disable(Object *obj, Error **errp)
> +{
> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
> +
> +    return ms->zpcii_disable;
> +}
> +
> +static inline void machine_set_zpcii_disable(Object *obj, bool value,
> +                                             Error **errp)
> +{
> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
> +
> +    ms->zpcii_disable = value;
> +}
> +
>   static S390CcwMachineClass *current_mc;
>   
>   /*
> @@ -740,6 +755,13 @@ static inline void s390_machine_initfn(Object *obj)
>               "Up to 8 chars in set of [A-Za-z0-9. ] (lower case chars converted"
>               " to upper case) to pass to machine loader, boot manager,"
>               " and guest kernel");
> +
> +    object_property_add_bool(obj, "zpcii-disable",
> +                             machine_get_zpcii_disable,
> +                             machine_set_zpcii_disable);
> +    object_property_set_description(obj, "zpcii-disable",
> +            "disable zPCI interpretation facilties");
> +    object_property_set_bool(obj, "zpcii-disable", false, NULL);
>   }
>   
>   static const TypeInfo ccw_machine_info = {
> @@ -803,8 +825,11 @@ DEFINE_CCW_MACHINE(7_2, "7.2", true);
>   
>   static void ccw_machine_7_1_instance_options(MachineState *machine)
>   {
> +    S390CcwMachineState *ms = S390_CCW_MACHINE(machine);
> +
>       ccw_machine_7_2_instance_options(machine);
>       s390_cpudef_featoff_greater(16, 1, S390_FEAT_PAIE);
> +    ms->zpcii_disable = true;
>   }
>   
>   static void ccw_machine_7_1_class_options(MachineClass *mc)
> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
> index 3331990e02..8a0090a071 100644
> --- a/include/hw/s390x/s390-virtio-ccw.h
> +++ b/include/hw/s390x/s390-virtio-ccw.h
> @@ -27,6 +27,7 @@ struct S390CcwMachineState {
>       bool aes_key_wrap;
>       bool dea_key_wrap;
>       bool pv;
> +    bool zpcii_disable;
>       uint8_t loadparm[8];
>   };
>   
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 31c04f7eea..7427dd1ed5 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -37,7 +37,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
>       "                memory-encryption=@var{} memory encryption object to use (default=none)\n"
>       "                hmat=on|off controls ACPI HMAT support (default=off)\n"
>       "                memory-backend='backend-id' specifies explicitly provided backend for main RAM (default=none)\n"
> -    "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n",
> +    "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n"
> +    "                zpcii-disable=on|off disables zPCI interpretation facilities (default=off)\n",
>       QEMU_ARCH_ALL)
>   SRST
>   ``-machine [type=]name[,prop=value[,...]]``
> @@ -157,6 +158,11 @@ SRST
>           ::
>   
>               -machine cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.targets.1=cxl.1,cxl-fmw.0.size=128G,cxl-fmw.0.interleave-granularity=512k
> +
> +    ``zpcii-disable=on|off``
> +        Disables zPCI interpretation facilties on s390-ccw hosts.
> +        This feature can be used to disable hardware virtual assists
> +        related to zPCI devices. The default is off.
>   ERST
>   
>   DEF("M", HAS_ARG, QEMU_OPTION_M,
> diff --git a/util/qemu-config.c b/util/qemu-config.c
> index 433488aa56..5325f6bf80 100644
> --- a/util/qemu-config.c
> +++ b/util/qemu-config.c
> @@ -236,6 +236,10 @@ static QemuOptsList machine_opts = {
>               .help = "Up to 8 chars in set of [A-Za-z0-9. ](lower case chars"
>                       " converted to upper case) to pass to machine"
>                       " loader, boot manager, and guest kernel",
> +        },{
> +            .name = "zpcii-disable",
> +            .type = QEMU_OPT_BOOL,
> +            .help = "disable zPCI interpretation facilities",
>           },
>           { /* End of list */ }
>       }

Reviewed-by: Thomas Huth <thuth@redhat.com>

