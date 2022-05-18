Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC10752B454
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 10:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbiERIC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 04:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiERICu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 04:02:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9E1E24BD8
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 01:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652860966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UO8E2l/aapTWr//awTMwoKIM2VWZagf8e9tkMqm2woc=;
        b=M19CXR93OMLDvDYNo34oNB7f9npgpL1p8BZWdQofsimH8DkbG5teP0IwCFd+sMiSfvS4Vp
        mJX+jwLfj/klZlkDakP3xajXAHgYkHvNvUnoRWgAxTEkctsySrYbtLFa94hoJPyVi8nc4S
        84wchpyWBcnF5OdVDyKKapXXvJA7Uqw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-tTigeoYTM1Ci_wZP3ARA-g-1; Wed, 18 May 2022 04:02:37 -0400
X-MC-Unique: tTigeoYTM1Ci_wZP3ARA-g-1
Received: by mail-wr1-f71.google.com with SMTP id s14-20020adfa28e000000b0020ac7532f08so316079wra.15
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 01:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=UO8E2l/aapTWr//awTMwoKIM2VWZagf8e9tkMqm2woc=;
        b=zvHJ+U2g0WdShkC3rDiMApVbsn2vD0x12zl3oZiTecu2ROfAKOJ/P11We3Kv9MEI8I
         y1Z/7ERN7bj61muWP3VB7MUl3ytqzoC5AyOxauP0ZTwiEab9o0UsDQV5y7AeDsbBvCf6
         Gp9sYZ3RBaSrHfjkWue8TIx9TPtVGItsJrozbJDbZAk0kk/EVLTMFkd/6LuGbc3EsqHl
         O97QZ92AjkBMba3lH1sT2CEUr+F3x2OGMwrBBofJj7yMvKEJyBIdWr3E6rNjnojcXvo5
         XmIXiuhiazQb6yttzsquxLCye1zLKuQcjJ27yCjeFas1bWRvqg7zoScxPPDq/MzNQmX3
         PzSA==
X-Gm-Message-State: AOAM530+b35cio9GFecC8ylfRY3fVd3wJFKM1dO7QBEBxJhO7sf6AZmY
        VC0CBPSjEp4qQYmF/ChE7FZEjnIFBxr53PfyTbf4gETUBAcD6vMh2L46wH0MOY36BcdlM7Dd3RR
        rDl38Hb5M4loP
X-Received: by 2002:a05:600c:ad3:b0:394:46ae:549b with SMTP id c19-20020a05600c0ad300b0039446ae549bmr35196653wmr.113.1652860956119;
        Wed, 18 May 2022 01:02:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiyEXRDMVEX7RdQ1x3/fHssB2j/UgPms2Lr5sNWZhCpDndWRHucErUoazdKqgeL00RpgueXA==
X-Received: by 2002:a05:600c:ad3:b0:394:46ae:549b with SMTP id c19-20020a05600c0ad300b0039446ae549bmr35196635wmr.113.1652860955892;
        Wed, 18 May 2022 01:02:35 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id h18-20020a05600c415200b00394708a3d7dsm3642156wmm.15.2022.05.18.01.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 01:02:35 -0700 (PDT)
Message-ID: <159d28b9-3607-dd66-975b-bf004752cda4@redhat.com>
Date:   Wed, 18 May 2022 10:02:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v5 3/9] target/s390x: add zpci-interp to cpu models
Content-Language: en-US
From:   Thomas Huth <thuth@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org,
        david@redhat.com
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-4-mjrosato@linux.ibm.com>
 <f7ca365a-1e7e-d0a8-8a0e-5cf744cd1d20@redhat.com>
In-Reply-To: <f7ca365a-1e7e-d0a8-8a0e-5cf744cd1d20@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/2022 10.01, Thomas Huth wrote:
> On 04/04/2022 20.17, Matthew Rosato wrote:
>> The zpci-interp feature is used to specify whether zPCI interpretation is
>> to be used for this guest.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   hw/s390x/s390-virtio-ccw.c          | 1 +
>>   target/s390x/cpu_features_def.h.inc | 1 +
>>   target/s390x/gen-features.c         | 2 ++
>>   target/s390x/kvm/kvm.c              | 1 +
>>   4 files changed, 5 insertions(+)
>>
>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>> index 90480e7cf9..b190234308 100644
>> --- a/hw/s390x/s390-virtio-ccw.c
>> +++ b/hw/s390x/s390-virtio-ccw.c
>> @@ -805,6 +805,7 @@ static void 
>> ccw_machine_6_2_instance_options(MachineState *machine)
>>       static const S390FeatInit qemu_cpu_feat = { S390_FEAT_LIST_QEMU_V6_2 };
>>       ccw_machine_7_0_instance_options(machine);
>> +    s390_cpudef_featoff_greater(14, 1, S390_FEAT_ZPCI_INTERP);
>>       s390_set_qemu_cpu_model(0x3906, 14, 2, qemu_cpu_feat);
>>   }
>> diff --git a/target/s390x/cpu_features_def.h.inc 
>> b/target/s390x/cpu_features_def.h.inc
>> index e86662bb3b..4ade3182aa 100644
>> --- a/target/s390x/cpu_features_def.h.inc
>> +++ b/target/s390x/cpu_features_def.h.inc
>> @@ -146,6 +146,7 @@ DEF_FEAT(SIE_CEI, "cei", SCLP_CPU, 43, "SIE: 
>> Conditional-external-interception f
>>   DEF_FEAT(DAT_ENH_2, "dateh2", MISC, 0, "DAT-enhancement facility 2")
>>   DEF_FEAT(CMM, "cmm", MISC, 0, "Collaborative-memory-management facility")
>>   DEF_FEAT(AP, "ap", MISC, 0, "AP instructions installed")
>> +DEF_FEAT(ZPCI_INTERP, "zpci-interp", MISC, 0, "zPCI interpretation")
>>   /* Features exposed via the PLO instruction. */
>>   DEF_FEAT(PLO_CL, "plo-cl", PLO, 0, "PLO Compare and load (32 bit in 
>> general registers)")
>> diff --git a/target/s390x/gen-features.c b/target/s390x/gen-features.c
>> index 22846121c4..9db6bd545e 100644
>> --- a/target/s390x/gen-features.c
>> +++ b/target/s390x/gen-features.c
>> @@ -554,6 +554,7 @@ static uint16_t full_GEN14_GA1[] = {
>>       S390_FEAT_HPMA2,
>>       S390_FEAT_SIE_KSS,
>>       S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
>> +    S390_FEAT_ZPCI_INTERP,
>>   };
>>   #define full_GEN14_GA2 EmptyFeat
>> @@ -650,6 +651,7 @@ static uint16_t default_GEN14_GA1[] = {
>>       S390_FEAT_GROUP_MSA_EXT_8,
>>       S390_FEAT_MULTIPLE_EPOCH,
>>       S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
>> +    S390_FEAT_ZPCI_INTERP,
>>   };
> 
> If you add something to the default model, I think you also need to add some 
> compatibility handling to the machine types. See e.g. commit 84176c7906f as 
> an example.

Ah, never mind, it's there some lines earlier in the patch ... I guess I did 
not have not enough coffee today yet...

  Thomas


