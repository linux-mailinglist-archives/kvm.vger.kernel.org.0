Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055856656BF
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 10:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbjAKJCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 04:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236823AbjAKJBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 04:01:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDEA1144B
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 01:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673427636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6fVZh4pfsJpmZbOYSBkRk4GHEkxKt9nd3zTIFVmbyEA=;
        b=V602NJHdQXe5+PCfkwg2jnIhyI4Jv0qlEQIjKmIKMhvVng/vrxBZZbKY9ENAxTR6V70Ne+
        p6MPL4ESSvYo5TBVyLgd9vP0Wy6q585qDIZv5x332tKqjrg/+OvxUdoa1qiPqVNjFR9iX8
        A0UHxEZelSVKmmkKua0xBIrhLt98csE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-502--MQITpNuOO6lpU4rl5fJGA-1; Wed, 11 Jan 2023 04:00:34 -0500
X-MC-Unique: -MQITpNuOO6lpU4rl5fJGA-1
Received: by mail-qt1-f199.google.com with SMTP id g19-20020ac84693000000b003acef862350so4143187qto.7
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 01:00:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6fVZh4pfsJpmZbOYSBkRk4GHEkxKt9nd3zTIFVmbyEA=;
        b=cnUIrX40DXyn03j32l8Xtwj39y3P/8vfB6ddEtnXrqbmFqLWflCnrFqRMxQ54rUT4i
         h54UJeDFcWipXQOBJz4bpFVcTqMWP2jRr1/dUTEZhGrtt1HhEzWBGTrEMF3jNB+hUJlk
         B0nQi62kIRgRmT1TuKS8hd9H9lapuW/OGZhB6LEubFG99oVd1DW17fmUCOU7IchZ/W3c
         GvEml24IL4lVnYx6hGklccl6C2oUR+wiqlP1h4s1F39v4khnpke9xQ5KLkejFq4LF36H
         8mSGveluRnR0bzyqd8MlO7Sq14pr9Zd0PvzmTsdniTKcCbSuOmbVy0jVpZExCf4KWbxk
         AUxA==
X-Gm-Message-State: AFqh2koEIDvpT5OHoS4chI9rUfLwtSX3hLEmPzXN6x8DmcqGFHyC4PjX
        DgIaH8wvLEX59zkURSoFQRcp/huPBYN5L756Rt48StFhcFEA8kmafLcE3EFhy1JqJGriyoxxrJE
        7/x4Xw71wekB8
X-Received: by 2002:a05:622a:4cc5:b0:3ac:c333:484 with SMTP id fa5-20020a05622a4cc500b003acc3330484mr19366734qtb.9.1673427634409;
        Wed, 11 Jan 2023 01:00:34 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsxxI6TtBwQ5lXVg/ea9lcDYALmua1c7tkdHLqfy2/kdbedjjtjdcEFiGQFUvYF7ebroQL6Xg==
X-Received: by 2002:a05:622a:4cc5:b0:3ac:c333:484 with SMTP id fa5-20020a05622a4cc500b003acc3330484mr19366697qtb.9.1673427634161;
        Wed, 11 Jan 2023 01:00:34 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-91.web.vodafone.de. [109.43.176.91])
        by smtp.gmail.com with ESMTPSA id x10-20020a05620a448a00b006faa2c0100bsm8746892qkp.110.2023.01.11.01.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:00:33 -0800 (PST)
Message-ID: <f2433967-3c97-e4d7-9e2f-577b24c2369a@redhat.com>
Date:   Wed, 11 Jan 2023 10:00:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v14 05/11] s390x/cpu topology: resetting the
 Topology-Change-Report
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
 <20230105145313.168489-6-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230105145313.168489-6-pmorel@linux.ibm.com>
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
> During a subsystem reset the Topology-Change-Report is cleared
> by the machine.
> Let's ask KVM to clear the Modified Topology Change Report (MTCR)
> bit of the SCA in the case of a subsystem reset.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> diff --git a/target/s390x/kvm/kvm_s390x.h b/target/s390x/kvm/kvm_s390x.h
> index f9785564d0..649dae5948 100644
> --- a/target/s390x/kvm/kvm_s390x.h
> +++ b/target/s390x/kvm/kvm_s390x.h
> @@ -47,5 +47,6 @@ void kvm_s390_crypto_reset(void);
>   void kvm_s390_restart_interrupt(S390CPU *cpu);
>   void kvm_s390_stop_interrupt(S390CPU *cpu);
>   void kvm_s390_set_diag318(CPUState *cs, uint64_t diag318_info);
> +int kvm_s390_topology_set_mtcr(uint64_t attr);
>   
>   #endif /* KVM_S390X_H */
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index c98b93a15f..14798ca305 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -122,6 +122,7 @@ static void subsystem_reset(void)
>               device_cold_reset(dev);
>           }
>       }
> +    s390_cpu_topology_reset();
>   }

Would it make sense to add a "if (s390_has_topology())" check around the new 
line?

Anyway:
Reviewed-by: Thomas Huth <thuth@redhat.com>


