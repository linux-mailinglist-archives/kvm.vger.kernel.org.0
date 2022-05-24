Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3043C5328F3
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 13:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbiEXL1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 07:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbiEXL1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 07:27:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDCB47B9D6
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653391650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bhG5Ck13GAPrVJ8vbRNY/0IdFeWvv/sdaevWgalHSV0=;
        b=FFYo3Iqv49VZjV4SKF8/4o9ukAOAIVWuvtRHPrRXoWbT9Z6pyqxwTsAnb1X/trcEYlKEBg
        +gulMabIYtmN+Ngos30m6xUjFqGU10lNeWkxTfWQ2TklZaL8zQRH89O81BiXJzK71HUSjZ
        avhCGYah/PgMzFi5qY1JDNvuPv7e3uY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-VAbKCdsdNXWUeOr04N6UrA-1; Tue, 24 May 2022 07:27:29 -0400
X-MC-Unique: VAbKCdsdNXWUeOr04N6UrA-1
Received: by mail-wm1-f70.google.com with SMTP id m9-20020a05600c4f4900b0039746692dc2so2925384wmq.6
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:27:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bhG5Ck13GAPrVJ8vbRNY/0IdFeWvv/sdaevWgalHSV0=;
        b=xlOJHigaHnJSOwC9u0QePEulcs880XALxgKNtRfMXBczPfp5cmRyr9TTXJjrZVYIKO
         Pnq4GhqQPD7zpJIGyqm8r23okrDTBmEFb3g0IQs8QTQsbipKgEEPJgTwlloyMJLo4h1+
         XEqtx/ibtymMv3kfkRTn/cyXOXzA4DYEwrHxHU7CcXFaQcLI5naJfe530xEIASIooNeR
         N9NTdIccFoQtabGGZYaPg/GYum9fSuHF3xeOQReOFSgm43F7zg1eyuHNTARfIm6bpvIJ
         oKNM4rUY8Sf3APW12J3kFIQfNm5cI4JaGXSOY5AdeM7X125CG4gllf/xW+ZFl7PtcVN5
         xDNA==
X-Gm-Message-State: AOAM530oqfhY6F6vC7TBj+8TR4fUgd+mkpQFoJndbV6yCTMgrhTBVaA0
        Acy+ETvWI0vdiBTWZ3FQ5unBlufTtSPvDY7HnqSpgoCoXk0c0MG04aVJJY4nmmoEbTuH3A/YVzq
        yXs+bfIbW24Me
X-Received: by 2002:a05:6000:1f0a:b0:20e:674a:ce2 with SMTP id bv10-20020a0560001f0a00b0020e674a0ce2mr22220262wrb.450.1653391648524;
        Tue, 24 May 2022 04:27:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypT0T4ipNG9nB+q5Xa3blcQoYRizXV4S+8aqy+n5YSEXzafFH9TBbGRIax40l9njwM0/vvXw==
X-Received: by 2002:a05:6000:1f0a:b0:20e:674a:ce2 with SMTP id bv10-20020a0560001f0a00b0020e674a0ce2mr22220225wrb.450.1653391648250;
        Tue, 24 May 2022 04:27:28 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id n1-20020a7bc5c1000000b003976525c38bsm95660wmk.3.2022.05.24.04.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 04:27:27 -0700 (PDT)
Message-ID: <87783273-6abd-f31e-f5f3-a5cf21b1594f@redhat.com>
Date:   Tue, 24 May 2022 13:27:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v7 10/13] s390x: kvm: topology: interception of PTF
 instruction
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
 <20220420115745.13696-11-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220420115745.13696-11-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/2022 13.57, Pierre Morel wrote:
> When the host supports the CPU topology facility, the PTF
> instruction with function code 2 is interpreted by the SIE,
> provided that the userland hypervizor activates the interpretation
> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
> 
> The PTF instructions with function code 0 and 1 are intercepted
> and must be emulated by the userland hypervizor.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   hw/s390x/s390-virtio-ccw.c         | 50 ++++++++++++++++++++++++++++++
>   include/hw/s390x/s390-virtio-ccw.h |  6 ++++
>   target/s390x/kvm/kvm.c             | 14 +++++++++
>   3 files changed, 70 insertions(+)
> 
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 93d1a43583..1ffaddebcc 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c

Why do you put this into s390-virtio-ccw.c and not into cpu_topology.c ?

> @@ -434,6 +434,56 @@ static void s390_pv_prepare_reset(S390CcwMachineState *ms)
>       s390_pv_prep_reset();
>   }
>   
> +/*
> + * s390_handle_ptf:
> + *
> + * @register 1: contains the function code
> + *
> + * Function codes 0 and 1 handle the CPU polarization.
> + * We assume an horizontal topology, the only one supported currently
> + * by Linux, consequently we answer to function code 0, requesting
> + * horizontal polarization that it is already the current polarization
> + * and reject vertical polarization request without further explanation.
> + *
> + * Function code 2 is handling topology changes and is interpreted
> + * by the SIE.
> + */
> +int s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
> +{
> +    CPUS390XState *env = &cpu->env;
> +    uint64_t reg = env->regs[r1];
> +    uint8_t fc = reg & S390_TOPO_FC_MASK;
> +
> +    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
> +        s390_program_interrupt(env, PGM_OPERATION, ra);
> +        return 0;
> +    }
> +
> +    if (env->psw.mask & PSW_MASK_PSTATE) {
> +        s390_program_interrupt(env, PGM_PRIVILEGED, ra);
> +        return 0;
> +    }
> +
> +    if (reg & ~S390_TOPO_FC_MASK) {
> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
> +        return 0;
> +    }
> +
> +    switch (fc) {
> +    case 0:    /* Horizontal polarization is already set */
> +        env->regs[r1] |= S390_PTF_REASON_DONE;
> +        return 2;
> +    case 1:    /* Vertical polarization is not supported */
> +        env->regs[r1] |= S390_PTF_REASON_NONE;
> +        return 2;
> +    default:
> +        /* Note that fc == 2 is interpreted by the SIE */
> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
> +    }
> +
> +    return 0;
> +}
> +
>   static void s390_machine_reset(MachineState *machine)
>   {
>       S390CcwMachineState *ms = S390_CCW_MACHINE(machine);
> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
> index 3331990e02..ac4b4a92e7 100644
> --- a/include/hw/s390x/s390-virtio-ccw.h
> +++ b/include/hw/s390x/s390-virtio-ccw.h
> @@ -30,6 +30,12 @@ struct S390CcwMachineState {
>       uint8_t loadparm[8];
>   };
>   
> +#define S390_PTF_REASON_NONE (0x00 << 8)
> +#define S390_PTF_REASON_DONE (0x01 << 8)
> +#define S390_PTF_REASON_BUSY (0x02 << 8)
> +#define S390_TOPO_FC_MASK 0xffUL
> +int s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra);
> +
>   struct S390CcwMachineClass {
>       /*< private >*/
>       MachineClass parent_class;
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index 27b3fbfa09..e3792e52c2 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -98,6 +98,7 @@
>   
>   #define PRIV_B9_EQBS                    0x9c
>   #define PRIV_B9_CLP                     0xa0
> +#define PRIV_B9_PTF                     0xa2
>   #define PRIV_B9_PCISTG                  0xd0
>   #define PRIV_B9_PCILG                   0xd2
>   #define PRIV_B9_RPCIT                   0xd3
> @@ -1453,6 +1454,16 @@ static int kvm_mpcifc_service_call(S390CPU *cpu, struct kvm_run *run)
>       }
>   }
>   
> +static int kvm_handle_ptf(S390CPU *cpu, struct kvm_run *run)
> +{
> +    uint8_t r1 = (run->s390_sieic.ipb >> 20) & 0x0f;
> +    int ret;
> +
> +    ret = s390_handle_ptf(cpu, r1, RA_IGNORED);
> +    setcc(cpu, ret);

So you're still setting the CC in case the s390_handle_ptf() function 
injected a program interrupt? ... feels wrong. Maybe the CC should be set 
within s390_handle_ptf() instead?

  Thomas


> +    return 0;
> +}
> +
>   static int handle_b9(S390CPU *cpu, struct kvm_run *run, uint8_t ipa1)
>   {
>       int r = 0;
> @@ -1470,6 +1481,9 @@ static int handle_b9(S390CPU *cpu, struct kvm_run *run, uint8_t ipa1)
>       case PRIV_B9_RPCIT:
>           r = kvm_rpcit_service_call(cpu, run);
>           break;
> +    case PRIV_B9_PTF:
> +        r = kvm_handle_ptf(cpu, run);
> +        break;
>       case PRIV_B9_EQBS:
>           /* just inject exception */
>           r = -1;

