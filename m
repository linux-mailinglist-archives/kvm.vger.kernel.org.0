Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730BD78A3A1
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 02:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjH1AGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Aug 2023 20:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjH1AGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Aug 2023 20:06:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC239FE
        for <kvm@vger.kernel.org>; Sun, 27 Aug 2023 17:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693181118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ibbxsoxCKoBvkUXcOjeA5GRQGxS837QbGPrgrI0q1/A=;
        b=g/8Tpsl5o3GeWffUmOeKIZ8pvO14MIcMGkyukXsjj7u3cEXpfn5M0A2rzwORet0Mt/Fndf
        DTtuNOUWBdE4v+RkdqgutNnZ3lb2ueN5qThvfqXgHz7bIWYALwRlTgYpGdTawZwj4GXSEr
        YUYnEFXyIm54sRMiTClHPpOY0WaeAhw=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-GF-H1xhmMFSUYdLJ-1TqVA-1; Sun, 27 Aug 2023 20:05:17 -0400
X-MC-Unique: GF-H1xhmMFSUYdLJ-1TqVA-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-d74b711ec0dso3292879276.0
        for <kvm@vger.kernel.org>; Sun, 27 Aug 2023 17:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693181116; x=1693785916;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ibbxsoxCKoBvkUXcOjeA5GRQGxS837QbGPrgrI0q1/A=;
        b=Zj3guAYKrdcvSx+9FmVovxX+pkhuUmobA2KEAO2TaW9+rS+zKQ6sm10XRmreAjmqQ7
         6YHnMyZczWDMPy4p3wzjjNQqpE7arSxYkl/fviQ9wRyVuNNVJGglwVXqmwHObTFnB5pk
         SgevhFlZ1689HVMczUqcZ4FntyNFZiDVO2QqFOn2Byjm/Ikof8Uu6xKebylMoOZpkGsL
         fiYaM1cQZtYkRbV6/4nCR/dXuTBhZOAPn++2BWhYZ09Fyy4zbKlkj8JbdqpO2kbyHA7S
         1YEK+rj54sQIXXX2JB9s6XjYjkVWR8ncAfu/hYH+2xajeJ1o0uR6eTLathdeBmV5fRZU
         K18g==
X-Gm-Message-State: AOJu0Yxzx0JxEuHPNgowSgpWIyVnJNU16NKtMsU1ZSs9tJy8juJgNp7A
        m9HhCizQtY2SX7cPRHxCaueb67U1dalpkDONRYXTO/LUEvM4/K1jEVSrrwt0TLIQprpDH7Tp5CF
        0Fmcs7K2THhNA
X-Received: by 2002:a5b:c4d:0:b0:c6c:e4f4:2fb1 with SMTP id d13-20020a5b0c4d000000b00c6ce4f42fb1mr23159082ybr.3.1693181116680;
        Sun, 27 Aug 2023 17:05:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzTGnH/D9yks8HrxCxd1C2qlL/9q/iUYvVS74r5N4bfJiUroHlQVt3omDGJuT4KA1Dop6X2Q==
X-Received: by 2002:a5b:c4d:0:b0:c6c:e4f4:2fb1 with SMTP id d13-20020a5b0c4d000000b00c6ce4f42fb1mr23159074ybr.3.1693181116446;
        Sun, 27 Aug 2023 17:05:16 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id g10-20020a63b14a000000b00566095dac12sm5920524pgp.19.2023.08.27.17.05.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Aug 2023 17:05:15 -0700 (PDT)
Message-ID: <4bd99ea8-46de-f66f-8e9e-aa981b26dc43@redhat.com>
Date:   Mon, 28 Aug 2023 10:05:10 +1000
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

[...]

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

Errors spotted by './scripts/checkpatch.pl', as below:

ERROR: line over 90 characters
#139: FILE: target/arm/kvm.c:1112:
+        error_setg(errp, "Cannot set properties after the accelerator has been initialized");

Thanks,
Gavin

