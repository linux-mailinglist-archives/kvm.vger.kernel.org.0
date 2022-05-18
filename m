Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0769C52B42D
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 10:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiERIGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 04:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiERIF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 04:05:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24EA6F0D
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 01:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652861157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vb9VySVR+4W+uz+Lu99v5HuhF6i+HtZKB3KJwQnTgSg=;
        b=KvBHVRjkX51vbyLsRjpWsnfBScO5QcTWR8dH2JP0Wz6CuzWR6LRyJcQP45RV8pyt6TUdgA
        twU3GsOMq7ypr5m056sn0iW20/YXiyMrQmn78lnjq+nP8yzQgZCKOmugqGhjGRCB2jHJDg
        aNI06Mg8fm1TYPGHVdg/FFYKr5vL6X4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-R0f1jJMMO4akhGP3NhyeTQ-1; Wed, 18 May 2022 04:05:56 -0400
X-MC-Unique: R0f1jJMMO4akhGP3NhyeTQ-1
Received: by mail-wm1-f71.google.com with SMTP id p24-20020a1c5458000000b003945d2ffc6eso568062wmi.5
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 01:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Vb9VySVR+4W+uz+Lu99v5HuhF6i+HtZKB3KJwQnTgSg=;
        b=cnS45QUbVajG/KT9YLeVcOMp2dazTtgS8spwXG5c3341aaymrBijdrXAxMxAh1ltKp
         xhaN04Q+p7h3asVDw/MoltAwQ+BMQ/WzpNsdLxHdAUD+jIroCpsLyPSnyMWfF7Kp/CRp
         y2El3tLVtmzvfxX/hlHimTn+CUXnBaAcu4vxoEiVO19AKUyTStjiPyQZEZtDXSXshi6k
         gQKJHZaihLuDmkroLNPdNj1Js8iwNx47Pj/qtOe9BV6UYJGyL4lO4gt5By3fK9zPWkQX
         w3bpuusk4r4v5LAPJdN2ad0JeqWEE3ZJF2VKe7n0b3xGDFrq3yA90kGgisOZcOgN8WSs
         cs0A==
X-Gm-Message-State: AOAM533M4blwlnWvdgAvF+1JDrHzFqxXOT6Bl4z0khnsicKLRAjePwAT
        7EDHWEUUNEW36dYeTvULeo3/t0CJfUmNDNSxSrb04qZoXft9GDAW2fwpkmwD8B8iT3wMXsBaLwm
        uo91o9qfNQK9+
X-Received: by 2002:a05:6000:1846:b0:20e:5d27:7ca7 with SMTP id c6-20020a056000184600b0020e5d277ca7mr3564811wri.536.1652861155048;
        Wed, 18 May 2022 01:05:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/30cS4PJxmHAl+2xrMBwaMFiCWGXTdx7x4IINri6wxV/RgNXy9UYZKLMriIL5IvLAWmSHMw==
X-Received: by 2002:a05:6000:1846:b0:20e:5d27:7ca7 with SMTP id c6-20020a056000184600b0020e5d277ca7mr3564789wri.536.1652861154786;
        Wed, 18 May 2022 01:05:54 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id y21-20020a7bcd95000000b0039489e1bbd6sm3594130wmj.47.2022.05.18.01.05.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 01:05:54 -0700 (PDT)
Message-ID: <db7ebd91-818d-f63e-6835-c38b9881383a@redhat.com>
Date:   Wed, 18 May 2022 10:05:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v5 3/9] target/s390x: add zpci-interp to cpu models
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-4-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220404181726.60291-4-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/04/2022 20.17, Matthew Rosato wrote:
> The zpci-interp feature is used to specify whether zPCI interpretation is
> to be used for this guest.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-virtio-ccw.c          | 1 +
>   target/s390x/cpu_features_def.h.inc | 1 +
>   target/s390x/gen-features.c         | 2 ++
>   target/s390x/kvm/kvm.c              | 1 +
>   4 files changed, 5 insertions(+)
> 
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 90480e7cf9..b190234308 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -805,6 +805,7 @@ static void ccw_machine_6_2_instance_options(MachineState *machine)
>       static const S390FeatInit qemu_cpu_feat = { S390_FEAT_LIST_QEMU_V6_2 };
>   
>       ccw_machine_7_0_instance_options(machine);
> +    s390_cpudef_featoff_greater(14, 1, S390_FEAT_ZPCI_INTERP);
>       s390_set_qemu_cpu_model(0x3906, 14, 2, qemu_cpu_feat);
>   }

This needs to be moved into ccw_machine_7_0_instance_options() now that 7.0 
has been released without this feature.

  Thomas

