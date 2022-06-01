Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA7053A14D
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 11:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351635AbiFAJwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 05:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349979AbiFAJwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 05:52:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A8A95DE53
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 02:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654077129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S8SLZ/gpBAnuu2nonvDs04H2zRpGtTgk07BIA/nAZcg=;
        b=U9u0NCv6wt+HRBDAP5+7APgPVlJbuWH0EWVgDPT7aHOvCVmxozuYqGr3FKAviyXEciZDHG
        rut4xc+G1CdKDSTqFFOeYcc2cVhvupJT+Kuh9c1GEceswfaa/nNoHvrpwSa0KgTXa0tPUE
        sJozVDP7Uh2cieOdLlm3CNjHw55l8Zo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-1-UrxY3TNTW9WCbjRkwq7Q-1; Wed, 01 Jun 2022 05:52:08 -0400
X-MC-Unique: 1-UrxY3TNTW9WCbjRkwq7Q-1
Received: by mail-wm1-f71.google.com with SMTP id o2-20020a05600c510200b0039747b0216fso3111432wms.0
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 02:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=S8SLZ/gpBAnuu2nonvDs04H2zRpGtTgk07BIA/nAZcg=;
        b=0tdnEibm5Lj6XGGbKtItD9jN0mqdqnojU4NiWX/kFuqKR2bhDDYhwVPq5S0Tn7F+dQ
         7AXpGZ3nUhEJGWgxx6Al8VJf4d7o71/hQDpmSZDxWFYSTK3tKFn/wPh+ksQGXpteoM/M
         gpK0w8TnoSzKb5BNBkDvgAwy7fPGSIAx8kqVf3Q44k5DGbrmvbmFP47OPGPDryxf0DzE
         2nl1q4glQxSmaHSk3ZEEOMmKOc1EQ3x1K0lU6VQX+Vx6ECLKX0/lXD+ftVy3d9JY7pjD
         xio/ipFbPysSYhYVNjIu6iWWv6ziRNTTut+4OgBNcJuJYwzrwYp0ljgsA9CmDf9VCQ35
         hjag==
X-Gm-Message-State: AOAM531sBp8uXj9yoSAZCG8m0M/WBElYMmr8rf4/LPGLzYOhN7Xdye3f
        TQKy7JCKPC+V6eRhFeLFvGEfKLnqebZZm57/UjKDZWLVunUL7AZYEEvQErsgEQYxc+5YOP3OSom
        H6LPLVGr4DkUB
X-Received: by 2002:a5d:6f07:0:b0:20f:e7b6:60e9 with SMTP id ay7-20020a5d6f07000000b0020fe7b660e9mr36876427wrb.452.1654077126995;
        Wed, 01 Jun 2022 02:52:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfmJEhuKto8dWe9djv8V0HWrJDK7LLd/Gekw/NvZ02056FHNaptIVSZJ7/IPYBN3KebVhicw==
X-Received: by 2002:a5d:6f07:0:b0:20f:e7b6:60e9 with SMTP id ay7-20020a5d6f07000000b0020fe7b660e9mr36876408wrb.452.1654077126724;
        Wed, 01 Jun 2022 02:52:06 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:2600:951d:63df:c091:3b45? (p200300cbc7052600951d63dfc0913b45.dip0.t-ipconnect.de. [2003:cb:c705:2600:951d:63df:c091:3b45])
        by smtp.gmail.com with ESMTPSA id v19-20020a1cf713000000b0039c18d3fe27sm1361545wmh.19.2022.06.01.02.52.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 02:52:06 -0700 (PDT)
Message-ID: <5b19dd64-d6be-0371-da63-0dd0b78a3a5c@redhat.com>
Date:   Wed, 1 Jun 2022 11:52:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220524190305.140717-1-mjrosato@linux.ibm.com>
 <20220524190305.140717-3-mjrosato@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v6 2/8] target/s390x: add zpci-interp to cpu models
In-Reply-To: <20220524190305.140717-3-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.05.22 21:02, Matthew Rosato wrote:
> The zpci-interp feature is used to specify whether zPCI interpretation is
> to be used for this guest.

We have

DEF_FEAT(SIE_PFMFI, "pfmfi", SCLP_CONF_CHAR_EXT, 9, "SIE: PFMF
interpretation facility")

and

DEF_FEAT(SIE_SIGPIF, "sigpif", SCLP_CPU, 12, "SIE: SIGP interpretation
facility")


Should we call this simply "zpcii" or "zpciif" (if the official name
includes "Facility")

> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/s390x/s390-virtio-ccw.c          | 1 +
>  target/s390x/cpu_features_def.h.inc | 1 +
>  target/s390x/gen-features.c         | 2 ++
>  target/s390x/kvm/kvm.c              | 1 +
>  4 files changed, 5 insertions(+)
> 
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 047cca0487..b33310a135 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -806,6 +806,7 @@ static void ccw_machine_7_0_instance_options(MachineState *machine)
>      static const S390FeatInit qemu_cpu_feat = { S390_FEAT_LIST_QEMU_V7_0 };
>  
>      ccw_machine_7_1_instance_options(machine);
> +    s390_cpudef_featoff_greater(14, 1, S390_FEAT_ZPCI_INTERP);
>      s390_set_qemu_cpu_model(0x8561, 15, 1, qemu_cpu_feat);
>  }
>  
> diff --git a/target/s390x/cpu_features_def.h.inc b/target/s390x/cpu_features_def.h.inc
> index e86662bb3b..4ade3182aa 100644
> --- a/target/s390x/cpu_features_def.h.inc
> +++ b/target/s390x/cpu_features_def.h.inc
> @@ -146,6 +146,7 @@ DEF_FEAT(SIE_CEI, "cei", SCLP_CPU, 43, "SIE: Conditional-external-interception f
>  DEF_FEAT(DAT_ENH_2, "dateh2", MISC, 0, "DAT-enhancement facility 2")
>  DEF_FEAT(CMM, "cmm", MISC, 0, "Collaborative-memory-management facility")
>  DEF_FEAT(AP, "ap", MISC, 0, "AP instructions installed")
> +DEF_FEAT(ZPCI_INTERP, "zpci-interp", MISC, 0, "zPCI interpretation")

How is this feature exposed to the guest, meaning, how can the guest
sense support?

Just a gut feeling: does this toggle enable the host to use
interpretation and the guest cannot really determine the difference
whether it's enabled or not? Then, it's not a guest CPU feature. But
let's hear first what this actually enables :)

>  
>  /* Features exposed via the PLO instruction. */
>  DEF_FEAT(PLO_CL, "plo-cl", PLO, 0, "PLO Compare and load (32 bit in general registers)")
> diff --git a/target/s390x/gen-features.c b/target/s390x/gen-features.c
> index c03ec2c9a9..f991646c01 100644
> --- a/target/s390x/gen-features.c
> +++ b/target/s390x/gen-features.c
> @@ -554,6 +554,7 @@ static uint16_t full_GEN14_GA1[] = {
>      S390_FEAT_HPMA2,
>      S390_FEAT_SIE_KSS,
>      S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
> +    S390_FEAT_ZPCI_INTERP,
>  };
>  
>  #define full_GEN14_GA2 EmptyFeat
> @@ -650,6 +651,7 @@ static uint16_t default_GEN14_GA1[] = {
>      S390_FEAT_GROUP_MSA_EXT_8,
>      S390_FEAT_MULTIPLE_EPOCH,
>      S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
> +    S390_FEAT_ZPCI_INTERP,

I'm curious, should we really add this to the default model?

This implies that on any setup where we don't have zpci interpretation
support (including missing kernel support), that a basic "-cpu z14" will
no longer work with the new machine type.

If, OTOH, we expect this feature to be around in any sane installation,
then it's good to include it in the

-- 
Thanks,

David / dhildenb

