Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0918B68BC29
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 12:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjBFL6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 06:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjBFL6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 06:58:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A048A9ED2
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 03:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675684642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uS4CtaqrUMD/f6x0WCVMDIkGkH5LrLtOJTV7xMEM8Mw=;
        b=aCXA+1SlM01nApaco/xD/u3LPUuDQ8BbKp3dGvdZDoeW6W9RRMmsJ+WD+RlMwl15RI5i6w
        ejkP6qTRYMq5YJ4MxyS+8zhwUKpUuUS7NULJf14d2Rir8oZTqO2DlKk5yKockAERfy8DA7
        P7tkulbIVbTFOjhCEYx+9Fq8JZuD1p4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-54-KO8KPzSHMhu0BlIw8a3-gw-1; Mon, 06 Feb 2023 06:57:21 -0500
X-MC-Unique: KO8KPzSHMhu0BlIw8a3-gw-1
Received: by mail-qt1-f199.google.com with SMTP id f2-20020ac80682000000b003b6364059d2so6267362qth.9
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 03:57:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uS4CtaqrUMD/f6x0WCVMDIkGkH5LrLtOJTV7xMEM8Mw=;
        b=ELJxoAuHymWAtMW3zXWVPkVZWrLLGTcya9V56uqc3VjB2zZ9hs3aWXQzeOb3IO+gFZ
         n6Y40gwV+MZmk/tOBGyV9K776NFqQHC2lWM4u/L3tDHUKhdGBB9k77rYL8SXdm44iRUB
         7JKgCoz/VnpoPPaJKZWeFFUWfaHDq8AxzHuA2d1aw50YnbTWlsGSQOc40OgS7N7+Q5Iy
         2T8HjVC1AMwFTZgKquXMmcJSQkNomSvdyi8ZPO390LRyyIUNn+LuL4bPvM4JuFawy6W0
         QBJRrb7rl/GPZQ+Nqd+5xF/B09Oqaqyg7BEu08hwwfqS5g+UDcUgUFEqPmYbACHw+Buq
         W0pQ==
X-Gm-Message-State: AO0yUKXo8OWPYCzkI4HZ24Hk+LeRmrlI5o28oYx1x8oBeLODYwyZDttd
        +0X+TmmVgYhL/wzSBMXHZIrDkb3V5meHGmIgU65j89gmuHfDn7vorh1My2K1lgcGKuk6PbPZw/Y
        bBI5X6pog8Ast
X-Received: by 2002:ac8:73d9:0:b0:3b9:bc8c:c20b with SMTP id v25-20020ac873d9000000b003b9bc8cc20bmr16176792qtp.22.1675684641053;
        Mon, 06 Feb 2023 03:57:21 -0800 (PST)
X-Google-Smtp-Source: AK7set/Vdvgis8O0hl0sM5kvVlwPCy3C6j4RuwO89/z5o31Vk/ib9lywMQfxvIWNgX+uhayn0cNynA==
X-Received: by 2002:ac8:73d9:0:b0:3b9:bc8c:c20b with SMTP id v25-20020ac873d9000000b003b9bc8cc20bmr16176779qtp.22.1675684640812;
        Mon, 06 Feb 2023 03:57:20 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-71.web.vodafone.de. [109.43.177.71])
        by smtp.gmail.com with ESMTPSA id s20-20020a05620a16b400b0071f40a59fe5sm7205403qkj.127.2023.02.06.03.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 03:57:20 -0800 (PST)
Message-ID: <b74543e8-5646-49da-2fab-8c5c69169d97@redhat.com>
Date:   Mon, 6 Feb 2023 12:57:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v15 07/11] target/s390x/cpu topology: activating CPU
 topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-8-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230201132051.126868-8-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/2023 14.20, Pierre Morel wrote:
> The KVM capability KVM_CAP_S390_CPU_TOPOLOGY is used to
> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
> the topology facility in the host CPU model for the guest
> in the case the topology is available in QEMU and in KVM.
> 
> The feature is disabled by default and fenced for SE
> (secure execution).
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   hw/s390x/cpu-topology.c   |  2 +-
>   target/s390x/cpu_models.c |  1 +
>   target/s390x/kvm/kvm.c    | 12 ++++++++++++
>   3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index 1028bf4476..c33378577b 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -55,7 +55,7 @@ int s390_socket_nb(S390CPU *cpu)
>    */
>   bool s390_has_topology(void)
>   {
> -    return false;
> +    return s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY);
>   }
>   
>   /**
> diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
> index 065ec6d66c..aca2c5c96b 100644
> --- a/target/s390x/cpu_models.c
> +++ b/target/s390x/cpu_models.c
> @@ -254,6 +254,7 @@ bool s390_has_feat(S390Feat feat)
>           case S390_FEAT_SIE_CMMA:
>           case S390_FEAT_SIE_PFMFI:
>           case S390_FEAT_SIE_IBS:
> +        case S390_FEAT_CONFIGURATION_TOPOLOGY:
>               return false;
>               break;
>           default:
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index fb63be41b7..808e35a7bd 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -2470,6 +2470,18 @@ void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
>           set_bit(S390_FEAT_UNPACK, model->features);
>       }
>   
> +    /*
> +     * If we have kernel support for CPU Topology indicate the
> +     * configuration-topology facility.
> +     */
> +    if (kvm_check_extension(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY)) {
> +        if (kvm_vm_enable_cap(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY, 0) < 0) {
> +            error_setg(errp, "KVM: Error enabling KVM_CAP_S390_CPU_TOPOLOGY");
> +            return;
> +        }
> +        set_bit(S390_FEAT_CONFIGURATION_TOPOLOGY, model->features);
> +    }

Not sure, but for the other capabilities, the kvm_vm_enable_cap() is rather 
done in kvm_arch_init() instead ... likely that it is properly available in 
case you don't run with the "host" cpu model? So should the 
kvm_vm_enable_cap(KVM_CAP_S390_CPU_TOPOLOGY) also be moved there (but of 
course keep the set_bit() here in kvm_s390_get_host_cpu_model())?

  Thomas

