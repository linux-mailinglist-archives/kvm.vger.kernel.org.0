Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C46F78E483
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 03:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345625AbjHaBoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 21:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236116AbjHaBoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 21:44:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A28ECE0
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 18:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693446209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=raRRZt8Kjchm0E16NQZbMgza4POm6EXhRH+XznC3V64=;
        b=izjrES7RF+XsIjTF6Gw6ACoi4sy7ucXxGHKM3pTRagPGF44IaLiMZkBGJf9PUyOC+Z6qJH
        4yA+kIOEm6GsZ31rh+w/NN+5C9j4seR29tSqSxGOr+zXFdKPp1h9jN6bNjgtHF6bKmzbjM
        6Eiz9OcjwqwGw3IVU8ZA9IZneiO3Py8=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-RLJhfjYQN4iosc8BqfjBFg-1; Wed, 30 Aug 2023 21:43:27 -0400
X-MC-Unique: RLJhfjYQN4iosc8BqfjBFg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1bf703dd21fso2683815ad.3
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 18:43:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693446206; x=1694051006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=raRRZt8Kjchm0E16NQZbMgza4POm6EXhRH+XznC3V64=;
        b=ePkIWxGNU9qW3EyUSrl0ErMcyWK3JHV8PJ7zsR785gSkjAjW3bZ5SuhU4XOxZkG3Kc
         aP2IS1fGl2YYe5ELwbb2s/ce16voCMp8uRU9r620AHeFgsaCJlEyKpJwtMxbGSXnLZN0
         x076qm/gNXevApBgijXiG/J4537+5C3ycm0VZv+ribSGbLrQ3ulPsq0VhBR/PJm6Wiu0
         DVo9vWK1M/3WofEHF8+X+j0/eF4CFxVpikzkF+4nS9bEAdkW08SV3o03MjJpaeNdE699
         ZLnD/B1Jj/axtl0hoJfIY9b9Gcad3rne9JkwtP1YqzR1YwaatfPXEDx6JAly+p5TkyEM
         4L9w==
X-Gm-Message-State: AOJu0YwH8SqYeDiq+5tVzEGKXrDVicc+IoEAG/D3vHaiHFNDgyKYX5PZ
        Dln7/S4uMTeLueKF/WdMYHWf2yv3+XGnmpM1Jdh5LZmkKYaKsF9I09nb+6Dyy/akTbqKzPly9V4
        nw81BGGaHKhSX
X-Received: by 2002:a17:902:e885:b0:1c0:d5b1:2de8 with SMTP id w5-20020a170902e88500b001c0d5b12de8mr4400037plg.9.1693446206596;
        Wed, 30 Aug 2023 18:43:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyVoIWodsjLPnoDoAcOvuyj2EEeIVJlLCYjnP39q8JzcYUlqFKCut777rC9HEUiMQjQwZzLw==
X-Received: by 2002:a17:902:e885:b0:1c0:d5b1:2de8 with SMTP id w5-20020a170902e88500b001c0d5b12de8mr4400030plg.9.1693446206216;
        Wed, 30 Aug 2023 18:43:26 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id y4-20020a170902700400b001bb889530adsm143381plk.217.2023.08.30.18.43.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 18:43:25 -0700 (PDT)
Message-ID: <f3abdbd6-337f-d175-07ab-ac1975d98dfc@redhat.com>
Date:   Thu, 31 Aug 2023 11:43:20 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3] arm/kvm: Enable support for
 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
Content-Language: en-US
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     peter.maydell@linaro.org, ricarkol@google.com,
        jonathan.cameron@huawei.com, kvm@vger.kernel.org,
        linuxarm@huawei.com
References: <20230830114818.641-1-shameerali.kolothum.thodi@huawei.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230830114818.641-1-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On 8/30/23 21:48, Shameer Kolothum wrote:
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
> v2: https://lore.kernel.org/qemu-devel/20230815092709.1290-1-shameerali.kolothum.thodi@huawei.com/
>     -Addressed comments from Gavin(Thanks).
> RFC v1: https://lore.kernel.org/qemu-devel/20230725150002.621-1-shameerali.kolothum.thodi@huawei.com/
>    -Updated qemu-options.hx with description
>    -Addressed review comments from Peter and Gavin(Thanks).
> ---
>   accel/kvm/kvm-all.c      |  1 +
>   include/sysemu/kvm_int.h |  1 +
>   qemu-options.hx          | 15 +++++++++
>   target/arm/kvm.c         | 68 ++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 85 insertions(+)
> 

One more question below. Please check if it's worthy to be addressed in v4, needed
to resolved other comments. Otherwise, it looks fine to me.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 2ba7521695..ff1578bb32 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -3763,6 +3763,7 @@ static void kvm_accel_instance_init(Object *obj)
>       /* KVM dirty ring is by default off */
>       s->kvm_dirty_ring_size = 0;
>       s->kvm_dirty_ring_with_bitmap = false;
> +    s->kvm_eager_split_size = 0;
>       s->notify_vmexit = NOTIFY_VMEXIT_OPTION_RUN;
>       s->notify_window = 0;
>       s->xen_version = 0;
> diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
> index 511b42bde5..a5b9122cb8 100644
> --- a/include/sysemu/kvm_int.h
> +++ b/include/sysemu/kvm_int.h
> @@ -116,6 +116,7 @@ struct KVMState
>       uint64_t kvm_dirty_ring_bytes;  /* Size of the per-vcpu dirty ring */
>       uint32_t kvm_dirty_ring_size;   /* Number of dirty GFNs per ring */
>       bool kvm_dirty_ring_with_bitmap;
> +    uint64_t kvm_eager_split_size;  /* Eager Page Splitting chunk size */
>       struct KVMDirtyRingReaper reaper;
>       NotifyVmexitOption notify_vmexit;
>       uint32_t notify_window;
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 29b98c3d4c..2e70704ee8 100644
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
> @@ -244,6 +245,20 @@ SRST
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
> +        to break at a time and needs to be a valid block size which is
> +        1GB/2MB/4KB, 32MB/16KB and 512MB/64KB for 4KB/16KB/64KB PAGE_SIZE
> +        respectively. Be wary of specifying a higher size as it will have an
> +        impact on the memory. By default, this feature is disabled
> +        (eager-split-size=0).
> +
>       ``notify-vmexit=run|internal-error|disable,notify-window=n``
>           Enables or disables notify VM exit support on x86 host and specify
>           the corresponding notify window to trigger the VM exit if enabled.
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 23aeb09949..28d81ca790 100644
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
> @@ -247,6 +248,12 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
>       return ret > 0 ? ret : 40;
>   }
>   
> +static inline bool kvm_arm_eager_split_size_valid(uint64_t req_size,
> +                                                  uint32_t sizes)
> +{
> +    return req_size & sizes;
> +}
> +
>   int kvm_arch_get_default_type(MachineState *ms)
>   {
>       bool fixed_ipa;
> @@ -287,6 +294,27 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
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
> +            ret = -EINVAL;
> +        } else {
> +            ret = kvm_vm_enable_cap(s, KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE, 0,
> +                                    s->kvm_eager_split_size);
> +            if (ret < 0) {
> +                error_report("Enabling of Eager Page Split failed: %s",
> +                             strerror(-ret));
> +            }
> +        }
> +    }
> +
>       kvm_arm_init_debug(s);
>   
>       return ret;

The function kvm_arm_eager_split_size_valid() was suggested by Peter if I'm correct.
However, it seems we needn't it any more since it's called for once. Why not simply to
have something like below? The detailed error message can help to explain why we
need the condition of (s->kvm_eager_split_size & sizes) here.

     } else if (s->kvm_eager_split_size & sizes) {
         error_report("Unsupported Eager Page Split chunk size 0x%lx by 0x%x",
                      s->kvm_eager_split_size, sizes);
         ret = -EINVAL;
     }

> @@ -1069,6 +1097,46 @@ bool kvm_arch_cpu_check_are_resettable(void)
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
> +        error_setg(errp, "Unable to set early-split-size after KVM has been initialized");
> +        return;
> +    }
> +
> +    if (!visit_type_size(v, name, &value, errp)) {
> +        return;
> +    }
> +
> +    if (value && !is_power_of_2(value)) {
> +        error_setg(errp, "early-split-size must be a power of two");
> +        return;
> +    }
> +
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
> +        "Eager Page Split chunk size for hugepages. (default: 0, disabled)");
>   }

Thanks,
Gavin

