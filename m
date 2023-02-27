Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E69A6A41D1
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 13:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjB0Mk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 07:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjB0Mk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 07:40:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5661DBA9
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 04:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677501590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cMMqs3SVTvebSpFoMCgni9IV5ypQSyPPBlVp3D5v8+4=;
        b=T5fdLO+mZ2rQVrKZzXJPVj+zj+1qxEIO3VyEMbzpUt2KyLH04u2SUQB5wtuYAZap613Bg9
        GJnINkEBliyoV4cFQ7B9PEvLNW0kt5quDBzHbKF2864B1WiJMOydRr6G3VRJdKdyQ6nuhO
        dspLKDT5kK3OoUkXI9uakea8zVVbS8M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-572-4wUrZAu4M-G9AbILdQ0F1w-1; Mon, 27 Feb 2023 07:39:48 -0500
X-MC-Unique: 4wUrZAu4M-G9AbILdQ0F1w-1
Received: by mail-wr1-f70.google.com with SMTP id r3-20020a5d6c63000000b002bff57fc7fcso799712wrz.19
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 04:39:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cMMqs3SVTvebSpFoMCgni9IV5ypQSyPPBlVp3D5v8+4=;
        b=W4ikhDBzYeh6eJ8E3YwFkQUa7JsUY1+2ivLP8xWTGU+29L2OwgQuZTHx25k2fP9t1w
         dpLJ57Y86YLJIdw92uPJ9aQQ/AyjQk2EJ+8xXhGMrrbgCikXQ0Vzq/+HK6JDKQlVza5J
         8if6wTzJf2zKlljqyi906xZXUMuxySBrAr4eCAAoBFy1///sdUvyFw15dJj36svzd9yP
         O8ine13ArxUN7tylpR+PEo44UocXulxT4BArzCnujNIqJ8FOPBoMICdzxlMPSypzMuJA
         +P5lNtWV90LsDjV9gwG+OuIMF+uR1U3sg+/Hb7lYxesFAPzJvTrBiW/dny1orklSxmnI
         l+uQ==
X-Gm-Message-State: AO0yUKVziGD/WrCHDLi/Zm67jEqYAXfspQxYk48yZGMmIh+i20+9mWmV
        4ehgUSRKcKsjvAMzVmCO1bQxX+b/BWYdAZ5iT8UV02+VbJqjTOJ7386B9JOeU4LwwdD8eQXFuvJ
        zgqdWf8kOOcEt
X-Received: by 2002:a05:600c:4b30:b0:3e2:147f:ac1a with SMTP id i48-20020a05600c4b3000b003e2147fac1amr16862847wmp.21.1677501587841;
        Mon, 27 Feb 2023 04:39:47 -0800 (PST)
X-Google-Smtp-Source: AK7set9KPsx6+1T3kuKidRwsQAIPZyfimjAZLiWjTRLNbUcke4Oge0qHZsM8yzLru/NcsBv3NBFMiw==
X-Received: by 2002:a05:600c:4b30:b0:3e2:147f:ac1a with SMTP id i48-20020a05600c4b3000b003e2147fac1amr16862831wmp.21.1677501587534;
        Mon, 27 Feb 2023 04:39:47 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-150.web.vodafone.de. [109.43.176.150])
        by smtp.gmail.com with ESMTPSA id u6-20020a05600c00c600b003e21dcccf9fsm12279156wmm.16.2023.02.27.04.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 04:39:47 -0800 (PST)
Message-ID: <f6854f27-2c32-dc07-883d-9cbfc9d49c48@redhat.com>
Date:   Mon, 27 Feb 2023 13:39:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-7-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v16 06/11] s390x/cpu topology: interception of PTF
 instruction
In-Reply-To: <20230222142105.84700-7-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/02/2023 15.21, Pierre Morel wrote:
> When the host supports the CPU topology facility, the PTF
> instruction with function code 2 is interpreted by the SIE,
> provided that the userland hypervisor activates the interpretation
> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
> 
> The PTF instructions with function code 0 and 1 are intercepted
> and must be emulated by the userland hypervisor.
> 
> During RESET all CPU of the configuration are placed in
> horizontal polarity.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   include/hw/s390x/s390-virtio-ccw.h |  6 +++
>   hw/s390x/cpu-topology.c            | 85 ++++++++++++++++++++++++++++++
>   target/s390x/kvm/kvm.c             | 11 ++++
>   3 files changed, 102 insertions(+)
> 
> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
> index 9bba21a916..c1d46e78af 100644
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
> +void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra);
> +
>   struct S390CcwMachineClass {
>       /*< private >*/
>       MachineClass parent_class;
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index 08642e0e04..40253a2444 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -87,6 +87,89 @@ static void s390_topology_init(MachineState *ms)
>       QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
>   }
>   
> +/**
> + * s390_topology_set_cpus_entitlement:
> + * @polarization: polarization requested by the caller
> + *
> + * Set all CPU entitlement according to polarization and
> + * dedication.
> + * Default vertical entitlement is S390_CPU_ENTITLEMENT_MEDIUM as
> + * it does not require host modification of the CPU provisioning
> + * until the host decide to modify individual CPU provisioning
> + * using QAPI interface.
> + * However a dedicated vCPU will have a S390_CPU_ENTITLEMENT_HIGH
> + * entitlement.
> + */
> +static void s390_topology_set_cpus_entitlement(int polarization)
> +{
> +    CPUState *cs;
> +
> +    CPU_FOREACH(cs) {
> +        if (polarization == S390_CPU_POLARIZATION_HORIZONTAL) {
> +            S390_CPU(cs)->env.entitlement = 0;

Maybe use S390_CPU_ENTITLEMENT_HORIZONTAL instead of "0" ?

> +        } else if (S390_CPU(cs)->env.dedicated) {
> +            S390_CPU(cs)->env.entitlement = S390_CPU_ENTITLEMENT_HIGH;
> +        } else {
> +            S390_CPU(cs)->env.entitlement = S390_CPU_ENTITLEMENT_MEDIUM;
> +        }
> +    }
> +}

With the nit above fixed:
Reviewed-by: Thomas Huth <thuth@redhat.com>

