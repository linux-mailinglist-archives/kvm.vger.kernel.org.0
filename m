Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4254A52B431
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 10:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbiERIBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 04:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiERIBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 04:01:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59A941D0C9
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 01:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652860904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MAl2bjEIAetEBRabM2lB8bJRFmizaHWXMjTDRpC0K/M=;
        b=eCOq+3qcEWJTcGHG/vKF8nojyJyDqCns1SkfLpM5ifwCqqbDHb3EOWWzlob/Py7QuHFR7f
        gwRy9K0U7EAnqzaVWiSjx/16oFhYeOMi8S1XYCfPDIXV/hG59fNmu2PbleWOK58S3uk3Y9
        ZDqkZZoe6VlA23yjjopxA0mru8uVq94=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-1HUHKrGIP7S54UoGNnbVeA-1; Wed, 18 May 2022 04:01:35 -0400
X-MC-Unique: 1HUHKrGIP7S54UoGNnbVeA-1
Received: by mail-wr1-f70.google.com with SMTP id x4-20020a5d4444000000b0020d130e8a36so316085wrr.9
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 01:01:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MAl2bjEIAetEBRabM2lB8bJRFmizaHWXMjTDRpC0K/M=;
        b=zDQK1PM/7P/Ut1bYeh7sYKs4xqmWOop4ms7Z9QYSUnQAw6Zocep6xi5P5pY5j9NlwD
         /PTfW7nXHdLxhffAelgngJEQivN3qMTrIPWxnSYCWDliV8idHVvPDQccpA7TbwRzRiBR
         zXyg/2MQZn0fKovFPwBgGkl4T6R+0iCQY+iOa5w54iV/l0VmJJWm6znblxMRp6FWpkYh
         zNIbn15u0a41PcDV+C9IR6khLkKjLX3H3gS9e4HJRHaq8Qt232tijWwpGlKYLPKEPX1b
         1fH3lcRDsOIVG3v1QKgyC3VxH+XytEWzLz/pA4thEYDzaZM+Skz1Wgt0UDWS5dkyedgk
         idWQ==
X-Gm-Message-State: AOAM532Mofnw9NCLCuPMEnaG1yowtqHn9Fpf7JwifsVmrs8c5Q08lMAI
        EXQp12U0wvppFVxKtwUE6X5cf32vGxz1yaqkWd/55qvF8Z00wy9FOn0RyMx1MM7yq/JzIKV9/it
        GWp0yU9Nkv5+a
X-Received: by 2002:a05:600c:3d89:b0:397:104:b1c9 with SMTP id bi9-20020a05600c3d8900b003970104b1c9mr14843960wmb.84.1652860894244;
        Wed, 18 May 2022 01:01:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTuV5UFWfWPMdtdFPQFTF1GHcHutlZSVAg9dOVmkjZ8iGTy9IVzodBNzvTDfcfXtnJReuDpA==
X-Received: by 2002:a05:600c:3d89:b0:397:104:b1c9 with SMTP id bi9-20020a05600c3d8900b003970104b1c9mr14843943wmb.84.1652860894014;
        Wed, 18 May 2022 01:01:34 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id f18-20020adfb612000000b0020d00174eabsm1171224wre.94.2022.05.18.01.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 01:01:33 -0700 (PDT)
Message-ID: <f7ca365a-1e7e-d0a8-8a0e-5cf744cd1d20@redhat.com>
Date:   Wed, 18 May 2022 10:01:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v5 3/9] target/s390x: add zpci-interp to cpu models
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org,
        david@redhat.com
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
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
>   
> diff --git a/target/s390x/cpu_features_def.h.inc b/target/s390x/cpu_features_def.h.inc
> index e86662bb3b..4ade3182aa 100644
> --- a/target/s390x/cpu_features_def.h.inc
> +++ b/target/s390x/cpu_features_def.h.inc
> @@ -146,6 +146,7 @@ DEF_FEAT(SIE_CEI, "cei", SCLP_CPU, 43, "SIE: Conditional-external-interception f
>   DEF_FEAT(DAT_ENH_2, "dateh2", MISC, 0, "DAT-enhancement facility 2")
>   DEF_FEAT(CMM, "cmm", MISC, 0, "Collaborative-memory-management facility")
>   DEF_FEAT(AP, "ap", MISC, 0, "AP instructions installed")
> +DEF_FEAT(ZPCI_INTERP, "zpci-interp", MISC, 0, "zPCI interpretation")
>   
>   /* Features exposed via the PLO instruction. */
>   DEF_FEAT(PLO_CL, "plo-cl", PLO, 0, "PLO Compare and load (32 bit in general registers)")
> diff --git a/target/s390x/gen-features.c b/target/s390x/gen-features.c
> index 22846121c4..9db6bd545e 100644
> --- a/target/s390x/gen-features.c
> +++ b/target/s390x/gen-features.c
> @@ -554,6 +554,7 @@ static uint16_t full_GEN14_GA1[] = {
>       S390_FEAT_HPMA2,
>       S390_FEAT_SIE_KSS,
>       S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
> +    S390_FEAT_ZPCI_INTERP,
>   };
>   
>   #define full_GEN14_GA2 EmptyFeat
> @@ -650,6 +651,7 @@ static uint16_t default_GEN14_GA1[] = {
>       S390_FEAT_GROUP_MSA_EXT_8,
>       S390_FEAT_MULTIPLE_EPOCH,
>       S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
> +    S390_FEAT_ZPCI_INTERP,
>   };

If you add something to the default model, I think you also need to add some 
compatibility handling to the machine types. See e.g. commit 84176c7906f as 
an example.

  Thomas

