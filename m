Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF2F665899
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 11:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbjAKKJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 05:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238714AbjAKKIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 05:08:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C68CC9
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 02:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673431454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ws57bKhCFEIuKPB2whL4Z/ylGixJw3tf3/cpkOfXajE=;
        b=I2+0aDaSeR2AYgQHwKjwjqdMJN4z5iG9Wb9WobqHVDCFj2bGIRwTGiE24og4qRcOlZVLvc
        iGlL/mbmzRiARLQ3+OVsmSOWE1nT7Ydvm3GXhc/BoE9nZUpMX6uCWjBXmgQWXEymGeXWjA
        z0O0+w+nWQ0UitDzqrUqln9dPvGZur8=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-658-n1MRTyPPMIyFHzaawf4-bg-1; Wed, 11 Jan 2023 05:04:13 -0500
X-MC-Unique: n1MRTyPPMIyFHzaawf4-bg-1
Received: by mail-vs1-f71.google.com with SMTP id k124-20020a672482000000b003ceea654c04so3167264vsk.11
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 02:04:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ws57bKhCFEIuKPB2whL4Z/ylGixJw3tf3/cpkOfXajE=;
        b=WoV18gr3+DmAH+ziXNxo8oHfttMHH+ehujnmizcW/N9rVOWLnTyrMLAeC4vBkQBm5L
         2+7c9rpn11pCqqODfgQ6ogq3c/PPLsHuLtvRQ0d4ijQIosO9jItg6YWbsXX+6jE1l4I1
         i9Mf+5CEPb/RUzzYNc2Ayf6VrA/9MN+JvPsId7nZR34lpwkXAIq0wWUi/A/Rwca2Yw46
         waAmMPlXFg62AOvr2pgso0fOHPZHgYHGSHKAbFMIqU6frofH62npVGIKa5T1W3k7I1of
         +V38zSOWxUiN+98XnLs9ZpmJC4PR7Sb8avzqJ8pxiMmfgO6eYILJ7UijvXXn++gYQmWK
         3ewA==
X-Gm-Message-State: AFqh2koU097t/LUUeroLM5MhtSMLtQZ2J19IQArXCFfxtr2ychmld00i
        bTYCnK9V5sreHeykbC3t7b9IgnifdcmMK05zcfBA/uMMQRxkDb6YiWnXL4fsvUZ33bibrIDosYs
        l7mn08OdyYzH4
X-Received: by 2002:a67:e208:0:b0:3c7:f2c1:93b9 with SMTP id g8-20020a67e208000000b003c7f2c193b9mr34245224vsa.4.1673431453040;
        Wed, 11 Jan 2023 02:04:13 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvjnzgsgJJgjCqD3C1Cyv45Y2MgPPRJorKUF4GN0qROCnrOdLUxHQmLxeI8bgmisnsGaMoauw==
X-Received: by 2002:a67:e208:0:b0:3c7:f2c1:93b9 with SMTP id g8-20020a67e208000000b003c7f2c193b9mr34245203vsa.4.1673431452785;
        Wed, 11 Jan 2023 02:04:12 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-91.web.vodafone.de. [109.43.176.91])
        by smtp.gmail.com with ESMTPSA id u8-20020a37ab08000000b00702311aea78sm8652658qke.82.2023.01.11.02.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 02:04:12 -0800 (PST)
Message-ID: <69555196-ffde-8176-24d9-b8935fe6f365@redhat.com>
Date:   Wed, 11 Jan 2023 11:04:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v14 07/11] target/s390x/cpu topology: activating CPU
 topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-8-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230105145313.168489-8-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/01/2023 15.53, Pierre Morel wrote:
> The KVM capability, KVM_CAP_S390_CPU_TOPOLOGY is used to

Remove the "," in above line?

> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
> the topology facility for the guest in the case the topology

I'd like to suggest to add "in the host CPU model" after "facility".

> is available in QEMU and in KVM.
> 
> The feature is disabled by default and fenced for SE
> (secure execution).
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   hw/s390x/cpu-topology.c   |  2 +-
>   target/s390x/cpu_models.c |  1 +
>   target/s390x/kvm/kvm.c    | 13 +++++++++++++
>   3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index e6b4692581..b69955a1cd 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -52,7 +52,7 @@ static int s390_socket_nb(s390_topology_id id)
>    */
>   bool s390_has_topology(void)
>   {
> -    return false;
> +    return s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY);
>   }
>   
>   /**
> diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
> index c3a4f80633..3f05e05fd3 100644
> --- a/target/s390x/cpu_models.c
> +++ b/target/s390x/cpu_models.c
> @@ -253,6 +253,7 @@ bool s390_has_feat(S390Feat feat)
>           case S390_FEAT_SIE_CMMA:
>           case S390_FEAT_SIE_PFMFI:
>           case S390_FEAT_SIE_IBS:
> +        case S390_FEAT_CONFIGURATION_TOPOLOGY:
>               return false;
>               break;
>           default:
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index fb63be41b7..4e2a2ff516 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -2470,6 +2470,19 @@ void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
>           set_bit(S390_FEAT_UNPACK, model->features);
>       }
>   
> +    /*
> +     * If we have support for CPU Topology prevent overrule
> +     * S390_FEAT_CONFIGURATION_TOPOLOGY with S390_FEAT_DISABLE_CPU_TOPOLOGY

That S390_FEAT_DISABLE_CPU_TOPOLOGY looks like a leftover from v12 ?

Apart from that, patch looks fine to me now.

  Thomas


> +     * implemented in KVM, activate the CPU TOPOLOGY feature.
> +     */
> +    if (kvm_check_extension(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY)) {
> +        if (kvm_vm_enable_cap(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY, 0) < 0) {
> +            error_setg(errp, "KVM: Error enabling KVM_CAP_S390_CPU_TOPOLOGY");
> +            return;
> +        }
> +        set_bit(S390_FEAT_CONFIGURATION_TOPOLOGY, model->features);
> +    }
> +
>       /* We emulate a zPCI bus and AEN, therefore we don't need HW support */
>       set_bit(S390_FEAT_ZPCI, model->features);
>       set_bit(S390_FEAT_ADAPTER_EVENT_NOTIFICATION, model->features);

