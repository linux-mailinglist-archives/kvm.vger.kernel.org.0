Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA75C78A39E
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 02:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjH1AD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Aug 2023 20:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjH1ADY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Aug 2023 20:03:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D78F5
        for <kvm@vger.kernel.org>; Sun, 27 Aug 2023 17:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693180955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xpHPOqpS/BopQCNTxUES7lap/T1aoNZFxwlnvj3+xR8=;
        b=MB0ihnshJehpAPs2kqDRV3BxVWBqsKi63iLi6AhjjNZSyAMWc3nrd2TMJ6vikplSuOdjuI
        saUESilY6wlj2PN5QpkTt5aKWmsOclr6GVD9vssC32VBx1d+jYrD0OtfDiWBSTGq4k3m/8
        g2V/1NlIH/wW69VQc7h5F1+VYmPRc30=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-yAXaYQXYN6SoN2FTIlyCaw-1; Sun, 27 Aug 2023 20:02:31 -0400
X-MC-Unique: yAXaYQXYN6SoN2FTIlyCaw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7911973a90eso188970239f.3
        for <kvm@vger.kernel.org>; Sun, 27 Aug 2023 17:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693180951; x=1693785751;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xpHPOqpS/BopQCNTxUES7lap/T1aoNZFxwlnvj3+xR8=;
        b=eFkPSitxGMRJ6DELaJjjBnnjpMtQxVjO15l2LlbPPa5eXaxRdwxckANHrxSKGqWiT9
         OuQ3BEnilx2334lJkC55uplZppThsTeErQoA6rDEZ2e6lm0kebtQ2IGtAluXnv0yHpzv
         0ymuUONbrRoDRUGiCHQ4yofwwGdTYGv+msfD5C/k6XFtRUv4+ykf4WBLpYK5NKgaRHBj
         E4gNxdbPP055IZ9SFR6BevZJ2CZQ1w4vj0f3ygufJKhvY4Rr2vU8yzAvj9RRFPoZVGbF
         Pfts9zsGdVYyjEM0X7LGKk6cOOc5qMijALZrjQSbsHXZgyttlFuurZNAiua2hOkN6sED
         a6sA==
X-Gm-Message-State: AOJu0YyM6Ec9am1ObyiBecPgHBKSqZPC3k3IaC+jEa8m/MPhtFgg/2Nd
        f8cDz1nQexev5QXbh1GZAA1g6+lYKl3SbnTwLKXywFTgXtJvKJfvYnyJHFEAwcnj74xic6ui/NL
        a5KUHkWs4ZuFr
X-Received: by 2002:a6b:d201:0:b0:792:6963:df3b with SMTP id q1-20020a6bd201000000b007926963df3bmr12962642iob.14.1693180951156;
        Sun, 27 Aug 2023 17:02:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCcVC2Fb5o3H5Bt8yOb6xoFh2KkZ7sDO2Q1xXCoRXBwCaTF7tedNS897rzyeU1YCMzznZsbQ==
X-Received: by 2002:a6b:d201:0:b0:792:6963:df3b with SMTP id q1-20020a6bd201000000b007926963df3bmr12962610iob.14.1693180950704;
        Sun, 27 Aug 2023 17:02:30 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id y19-20020aa78553000000b00682af93093dsm5339822pfn.45.2023.08.27.17.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Aug 2023 17:02:30 -0700 (PDT)
Message-ID: <9fc460ef-bb6b-8b67-d52a-f2d5aea887f1@redhat.com>
Date:   Mon, 28 Aug 2023 10:02:24 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2] arm/kvm: Enable support for
 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
Content-Language: en-US
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     peter.maydell@linaro.org, ricarkol@google.com, kvm@vger.kernel.org,
        jonathan.cameron@huawei.com, linuxarm@huawei.com
References: <20230815092709.1290-1-shameerali.kolothum.thodi@huawei.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230815092709.1290-1-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On 8/15/23 19:27, Shameer Kolothum wrote:
> Now that we have Eager Page Split support added for ARM in the kernel,
> enable it in Qemu. This adds,
>   -eager-split-size to -accel sub-options to set the eager page split chunk size.
>   -enable KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE.
> 
> The chunk size specifies how many pages to break at a time, using a
> single allocation. Bigger the chunk size, more pages need to be
> allocated ahead of time.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
> RFC v1: https://lore.kernel.org/qemu-devel/20230725150002.621-1-shameerali.kolothum.thodi@huawei.com/
>    -Updated qemu-options.hx with description
>    -Addressed review comments from Peter and Gavin(Thanks).
> ---
>   include/sysemu/kvm_int.h |  1 +
>   qemu-options.hx          | 14 +++++++++
>   target/arm/kvm.c         | 62 ++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 77 insertions(+)
> 
> diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
> index 511b42bde5..03a1660d40 100644
> --- a/include/sysemu/kvm_int.h
> +++ b/include/sysemu/kvm_int.h
> @@ -116,6 +116,7 @@ struct KVMState
>       uint64_t kvm_dirty_ring_bytes;  /* Size of the per-vcpu dirty ring */
>       uint32_t kvm_dirty_ring_size;   /* Number of dirty GFNs per ring */
>       bool kvm_dirty_ring_with_bitmap;
> +    uint64_t kvm_eager_split_size; /* Eager Page Splitting chunk size */

One more space is needed before the comments, to have same alignment as
we had. Besides, it needs to be initialized to zero in kvm-all.c::kvm_accel_instance_init()
as we're doing for @kvm_dirty_ring_size.

>       struct KVMDirtyRingReaper reaper;
>       NotifyVmexitOption notify_vmexit;
>       uint32_t notify_window;
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 29b98c3d4c..6ef7b89013 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -186,6 +186,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
>       "                split-wx=on|off (enable TCG split w^x mapping)\n"
>       "                tb-size=n (TCG translation block cache size)\n"
>       "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
> +    "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
>       "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
>       "                thread=single|multi (enable multi-threaded TCG)\n", QEMU_ARCH_ALL)
>   SRST
> @@ -244,6 +245,19 @@ SRST
>           is disabled (dirty-ring-size=0).  When enabled, KVM will instead
>           record dirty pages in a bitmap.
>   
> +    ``eager-split-size=n``
> +        KVM implements dirty page logging at the PAGE_SIZE granularity and
> +        enabling dirty-logging on a huge-page requires breaking it into
> +        PAGE_SIZE pages in the first place. KVM on ARM does this splitting
> +        lazily by default. There are performance benefits in doing huge-page
> +        split eagerly, especially in situations where TLBI costs associated
> +        with break-before-make sequences are considerable and also if guest
> +        workloads are read intensive. The size here specifies how many pages
> +        to break at a time and needs to be a valid block page size(eg: 4KB |
> +        2M | 1G when PAGE_SIZE is 4K). Be wary of specifying a higher size as
> +        it will have an impact on the memory. By default, this feature is
> +        disabled (eager-split-size=0).
> +

Since 64KB base page size is another popular option, it's worthy to mention the
supported block sizes for 64KB base page size. I'm not sure about 16KB though.
For this, the comments can be improved as below if you agree. With the improvement,
users needn't look into the code to figure out the valid block sizes.

The size here specifies how many pages to be split at a time and needs to be a valid
block size, which is 1GB/2MB/4KB, 32MB/16KB and 512MB/64KB for 4KB/16KB/64KB PAGE_SIZE
respectively.

>       ``notify-vmexit=run|internal-error|disable,notify-window=n``
>           Enables or disables notify VM exit support on x86 host and specify
>           the corresponding notify window to trigger the VM exit if enabled.
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index b4c7654f49..6ceba673d9 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -30,6 +30,7 @@
>   #include "exec/address-spaces.h"
>   #include "hw/boards.h"
>   #include "hw/irq.h"
> +#include "qapi/visitor.h"
>   #include "qemu/log.h"
>   
>   const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
> @@ -247,6 +248,11 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
>       return ret > 0 ? ret : 40;
>   }
>   
> +static bool kvm_arm_eager_split_size_valid(uint64_t req_size, uint32_t sizes)
> +{
> +    return req_size & sizes;
> +}
> +

It's worthy to be a inline function.

>   int kvm_arch_init(MachineState *ms, KVMState *s)
>   {
>       int ret = 0;
> @@ -280,6 +286,22 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>           }
>       }
>   
> +    if (s->kvm_eager_split_size) {
> +        uint32_t sizes;
> +
> +        sizes = kvm_vm_check_extension(s, KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES);
> +        if (!sizes) {
> +            s->kvm_eager_split_size = 0;
> +            warn_report("Eager Page Split support not available");
> +        } else if (!kvm_arm_eager_split_size_valid(s->kvm_eager_split_size,
> +                                                   sizes)) {
> +            error_report("Eager Page Split requested chunk size not valid");
> +        } else if (kvm_vm_enable_cap(s, KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE, 0,
> +                                     s->kvm_eager_split_size)) {
> +            error_report("Failed to set Eager Page Split chunk size");

Lets print the errno here. It's indicative to tell what happens inside the host
kernel and why it's failing to enable the feature.

		error_report("Enabling of Eager Page Split failed: %s.", strerror(-ret));

> +        }
> +    }
> +
>       kvm_arm_init_debug(s);
>   
>       return ret;
> @@ -1062,6 +1084,46 @@ bool kvm_arch_cpu_check_are_resettable(void)
>       return true;
>   }
>   
> +static void kvm_arch_get_eager_split_size(Object *obj, Visitor *v,
> +                                          const char *name, void *opaque,
> +                                          Error **errp)
> +{
> +    KVMState *s = KVM_STATE(obj);
> +    uint64_t value = s->kvm_eager_split_size;
> +
> +    visit_type_size(v, name, &value, errp);
> +}
> +
> +static void kvm_arch_set_eager_split_size(Object *obj, Visitor *v,
> +                                          const char *name, void *opaque,
> +                                          Error **errp)
> +{
> +    KVMState *s = KVM_STATE(obj);
> +    uint64_t value;
> +
> +    if (s->fd != -1) {
> +        error_setg(errp, "Cannot set properties after the accelerator has been initialized");
> +        return;
> +    }
> +

Lets be more obvious here?

	error_setg(errp, "Unable to set early-split-size after KVM has been initialized");

> +    if (!visit_type_size(v, name, &value, errp)) {
> +        return;
> +    }
> +
> +    if (is_power_of_2(value)) {
> +        error_setg(errp, "early-split-size must be a power of two.");
> +        return;
> +    }
> +

This condition looks wrong to me. 'value = 0' is accepted to disable the early
page splitting. Besides, we actually need to warn on !is_power_of_2(value)

	if (value && !is_power_of_2(value)) {
             error_setg(errp, "early-split-size must be a power of two.");
             return;
         }

> +    s->kvm_eager_split_size = value;
> +}
> +
>   void kvm_arch_accel_class_init(ObjectClass *oc)
>   {
> +    object_class_property_add(oc, "eager-split-size", "size",
> +                              kvm_arch_get_eager_split_size,
> +                              kvm_arch_set_eager_split_size, NULL, NULL);
> +
> +    object_class_property_set_description(oc, "eager-split-size",
> +        "Configure Eager Page Split chunk size for hugepages. (default: 0, disabled)");

"Configure" needs to be dropped since the property has both read/write permission.

>   }

Thanks,
Gavin

