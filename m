Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5B77719BD
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 07:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjHGFyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 01:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjHGFyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 01:54:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103A61FDB
        for <kvm@vger.kernel.org>; Sun,  6 Aug 2023 22:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691387609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uCp7b56SWxgUbUzJQ28m6nrXlScD4v5IlsPvQl+WPo8=;
        b=btc159dgzwJk2uy+OV6HDP0/+OICL9pbvOgWGWyHAVwmGYwUXUUNwzr4qAd7RMVuT7wKA+
        1bazCsJfWkbnNoPyXgIXFCy0rK7qM+kOXcKTk+WChHt47bbXN+jtVsGRss9r37Gw0HXwzC
        fNqElFFY+5HEybZDK0/Rjl6GyHssOt0=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-w8HPy5hJMy-mDgCyQXJ7dg-1; Mon, 07 Aug 2023 01:53:27 -0400
X-MC-Unique: w8HPy5hJMy-mDgCyQXJ7dg-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1bba7a32a40so31732155ad.0
        for <kvm@vger.kernel.org>; Sun, 06 Aug 2023 22:53:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691387606; x=1691992406;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uCp7b56SWxgUbUzJQ28m6nrXlScD4v5IlsPvQl+WPo8=;
        b=DHzuf/NSOz+WSE6galUe6FjNiRJnS/CayKfHT7fiC4yZ/1ja32OFXytAauBcFBum+L
         4HHo35QvhGaYYNblHuK2a2+7mpieGXel/VW6GlxtsTDlgiJIT+aRhU3dDzbtymC4b95a
         8xpRAxx+Bm6Ygu0zqdbYZbn+4eloLV5WJtIOSZQ58fvLbRN/Tol5k7eXAYRxtJUdwIBz
         5nVWVTa3Zb/1wfNEK9fHrvOhw3oro40KWmoG2hjoVLwsVI0TkZ2RqqBtkoWIU6ooWYqk
         g+IwdTFMTA4p83ETgJq+s8WgRBlxKSMko9s16zNVULw3LCB9lnDuzoRV6NGuyrxkbqOk
         pjRQ==
X-Gm-Message-State: AOJu0YxJws+0ltSyBUN9m008Gt1ex82mbxhcYNTJe6XrOrSPhpiQQ6Uv
        xhpRIZNAVoYB1GznnDD/kg+cbKGk02hMPb/TRE+uzQMpQqj0Zo3gYv7wHCs9CgGmm+FPcOXplMo
        SawSSR5Ks9wJk
X-Received: by 2002:a17:903:24d:b0:1bb:20ee:e29e with SMTP id j13-20020a170903024d00b001bb20eee29emr9355925plh.1.1691387606184;
        Sun, 06 Aug 2023 22:53:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLTiMPAC3WZUAEQaGsEGz2qaBAjymsiBDnj7GUjFknatNXn31GlCeE4lq72fKDuLk4ncT72w==
X-Received: by 2002:a17:903:24d:b0:1bb:20ee:e29e with SMTP id j13-20020a170903024d00b001bb20eee29emr9355912plh.1.1691387605870;
        Sun, 06 Aug 2023 22:53:25 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id ix14-20020a170902f80e00b001bc7306d321sm551156plb.282.2023.08.06.22.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Aug 2023 22:53:25 -0700 (PDT)
Message-ID: <c76de653-489c-ea4a-3163-f7d114c72d0f@redhat.com>
Date:   Mon, 7 Aug 2023 15:53:20 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH] arm/kvm: Enable support for
 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
Content-Language: en-US
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     peter.maydell@linaro.org, ricarkol@google.com, kvm@vger.kernel.org,
        jonathan.cameron@huawei.com, linuxarm@huawei.com
References: <20230725150002.621-1-shameerali.kolothum.thodi@huawei.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230725150002.621-1-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/26/23 01:00, Shameer Kolothum wrote:
> Now that we have Eager Page Split support added for ARM in the kernel[0],
> enable it in Qemu. This adds,
>   -eager-split-size to Qemu options to set the eager page split chunk size.
>   -enable KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE.
> 
> The chunk size specifies how many pages to break at a time, using a
> single allocation. Bigger the chunk size, more pages need to be
> allocated ahead of time.
> 
> Notes:
>   - I am not sure whether we need to call kvm_vm_check_extension() for
>     KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE or not as kernel seems to disable
>     eager page size by default and it will return zero always.
> 
>    -ToDo: Update qemu-options.hx
> 
> [0]: https://lore.kernel.org/all/168426111477.3193133.10748106199843780930.b4-ty@linux.dev/
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>   include/sysemu/kvm_int.h |  1 +
>   target/arm/kvm.c         | 73 ++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 74 insertions(+)
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
>       struct KVMDirtyRingReaper reaper;
>       NotifyVmexitOption notify_vmexit;
>       uint32_t notify_window;
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index b4c7654f49..985d901062 100644
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
> @@ -247,6 +248,23 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
>       return ret > 0 ? ret : 40;
>   }
>   
> +static bool kvm_arm_eager_split_size_valid(uint64_t req_size, uint32_t sizes)
> +{
> +    int i;
> +
> +    for (i = 0; i < sizeof(uint32_t) * BITS_PER_BYTE; i++) {
> +        if (!(sizes & (1 << i))) {
> +            continue;
> +        }
> +
> +        if (req_size == (1 << i)) {
> +            return true;
> +        }
> +    }
> +
> +    return false;
> +}
> +
>   int kvm_arch_init(MachineState *ms, KVMState *s)
>   {
>       int ret = 0;
> @@ -280,6 +298,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>           }
>       }
>   
> +    if (s->kvm_eager_split_size) {
> +        uint32_t sizes;
> +
> +        sizes = kvm_vm_check_extension(s, KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES);
> +        if (!sizes) {
> +            error_report("Eager Page Split not supported on host");
> +        } else if (!kvm_arm_eager_split_size_valid(s->kvm_eager_split_size,
> +                                                   sizes)) {
> +            error_report("Eager Page Split requested chunk size not valid");
> +        } else if (kvm_vm_enable_cap(s, KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE, 0,
> +                                     s->kvm_eager_split_size)) {
> +            error_report("Failed to set Eager Page Split chunk size");
> +        }
> +    }
> +
>       kvm_arm_init_debug(s);
>   
>       return ret;

Do we really want to fail when KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES isn't supported?
I think the appropriate behavior is to warn and clear s->kvm_eager_split_size
for this specific case, similar to what we are doing for s->kvm_dirty_ring_size
in kvm_dirty_ring_init(). With this, the behavior is backwards compatible to the
old host kernels.


> @@ -1062,6 +1095,46 @@ bool kvm_arch_cpu_check_are_resettable(void)
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
> +    if (!visit_type_size(v, name, &value, errp)) {
> +        return;
> +    }
> +
> +    if (value & (value - 1)) {
> +        error_setg(errp, "early-split-size must be a power of two.");
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
> +        "Configure Eager Page Split chunk size for hugepages. (default: 0, disabled)");
>   }

Thanks,
Gavin

