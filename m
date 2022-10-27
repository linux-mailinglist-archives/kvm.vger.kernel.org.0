Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB8F60F1FC
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 10:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbiJ0IPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 04:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiJ0IO7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 04:14:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EAF1E72B
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 01:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666858497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QjPY9+4I5DHjVi/Y4rzSS+KVMTBTql04AcJyqsjIKhc=;
        b=WbBdYchPBO1l2DioAiFCR9YCqS2G0oJl9bIXKYBNapbX3gPjW2qbNK8EWR6gabKZk9rEl+
        gR/6vLy+mrngxxOmUid3HFkw15jb6lGY+NUpPfGoGOUyM8Seykin+l3TRnh7Nffr6fZOLg
        rdMKBExcFkuLW3WbGw1AgqKkdFlRdH0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-457-lbP3cX7DOsat754CggZ2Nw-1; Thu, 27 Oct 2022 04:14:55 -0400
X-MC-Unique: lbP3cX7DOsat754CggZ2Nw-1
Received: by mail-wm1-f71.google.com with SMTP id h8-20020a1c2108000000b003cf550bfc8dso199001wmh.2
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 01:14:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QjPY9+4I5DHjVi/Y4rzSS+KVMTBTql04AcJyqsjIKhc=;
        b=Z37WVQLSGEIu4Ou8KatiR9UaR1lVPz7sqx8p9n5q94oMhTlakmkF13ZUIvm/hecziK
         Ii4nti9yh5NFh23Uemcs5NzBZ/czVYyB07uDOXqqXyElhE2LVSGrakExjk+9dvsUl8O1
         irSC/FQg5UBd4xm1+lvH0eZa36x2Y+sKmn80z5DCCCFyE8XeK1tYEf0Ab/WYxqYI89RP
         /ApXGnHU5sdrGvH/OI70c7h+GZW+hzWJchEsDHf5+7TBrgT661uZ+wDLci7aWARz0s6B
         A6qtLpkDBZ4v5HiU3HfREvS/KoOg08Ypg+06DA1Khlz4KhfsdfZl7bfxOkuilIJ5DEPA
         2lCw==
X-Gm-Message-State: ACrzQf3vbSkfU2Llr2ifBmv/H7NPdJK6BxSphwRI5rmxwujhsdR+xF/2
        Z/b+R1tjo5JjbdCsg/byyUOcPrxFd/Jo0N4f9fVXLpeWUW9XdlFlEqG2TC0CmvDWO2m1doBWQE0
        zSHzFDcHhbSjX
X-Received: by 2002:adf:e491:0:b0:236:5270:7f5e with SMTP id i17-20020adfe491000000b0023652707f5emr21168719wrm.600.1666858493988;
        Thu, 27 Oct 2022 01:14:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7IS9b7XmiKiAdINdp/ix1KQsBwFRndZI/5hqy5WjLYQxpP2j1yn9Od/dgibZX8QTwDaUps5g==
X-Received: by 2002:adf:e491:0:b0:236:5270:7f5e with SMTP id i17-20020adfe491000000b0023652707f5emr21168694wrm.600.1666858493766;
        Thu, 27 Oct 2022 01:14:53 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-195.web.vodafone.de. [109.43.176.195])
        by smtp.gmail.com with ESMTPSA id l16-20020a5d4110000000b002365cd93d05sm464583wrp.102.2022.10.27.01.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 01:14:53 -0700 (PDT)
Message-ID: <450544bf-4ff0-9d72-f57c-4274692916a5@redhat.com>
Date:   Thu, 27 Oct 2022 10:14:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v10 3/9] s390x/cpu_topology: resetting the
 Topology-Change-Report
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
 <20221012162107.91734-4-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221012162107.91734-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/2022 18.21, Pierre Morel wrote:
> During a subsystem reset the Topology-Change-Report is cleared
> by the machine.
> Let's ask KVM to clear the Modified Topology Change Report (MTCR)
>   bit of the SCA in the case of a subsystem reset.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   target/s390x/cpu.h           |  1 +
>   target/s390x/kvm/kvm_s390x.h |  1 +
>   hw/s390x/cpu-topology.c      | 12 ++++++++++++
>   hw/s390x/s390-virtio-ccw.c   |  1 +
>   target/s390x/cpu-sysemu.c    |  7 +++++++
>   target/s390x/kvm/kvm.c       | 23 +++++++++++++++++++++++
>   6 files changed, 45 insertions(+)
> 
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index d604aa9c78..9b35795ac8 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -825,6 +825,7 @@ void s390_enable_css_support(S390CPU *cpu);
>   void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
>   int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
>                                   int vq, bool assign);
> +void s390_cpu_topology_reset(void);
>   #ifndef CONFIG_USER_ONLY
>   unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
>   #else
> diff --git a/target/s390x/kvm/kvm_s390x.h b/target/s390x/kvm/kvm_s390x.h
> index aaae8570de..a13c8fb9a3 100644
> --- a/target/s390x/kvm/kvm_s390x.h
> +++ b/target/s390x/kvm/kvm_s390x.h
> @@ -46,5 +46,6 @@ void kvm_s390_crypto_reset(void);
>   void kvm_s390_restart_interrupt(S390CPU *cpu);
>   void kvm_s390_stop_interrupt(S390CPU *cpu);
>   void kvm_s390_set_diag318(CPUState *cs, uint64_t diag318_info);
> +int kvm_s390_topology_set_mtcr(uint64_t attr);
>   
>   #endif /* KVM_S390X_H */
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index c73cebfe6f..9f202621d0 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -107,6 +107,17 @@ static void s390_topology_realize(DeviceState *dev, Error **errp)
>       qemu_mutex_init(&topo->topo_mutex);
>   }
>   
> +/**
> + * s390_topology_reset:
> + * @dev: the device
> + *
> + * Calls the sysemu topology reset
> + */
> +static void s390_topology_reset(DeviceState *dev)
> +{
> +    s390_cpu_topology_reset();
> +}
> +
>   /**
>    * topology_class_init:
>    * @oc: Object class
> @@ -120,6 +131,7 @@ static void topology_class_init(ObjectClass *oc, void *data)
>   
>       dc->realize = s390_topology_realize;
>       set_bit(DEVICE_CATEGORY_MISC, dc->categories);
> +    dc->reset = s390_topology_reset;
>   }
>   
>   static const TypeInfo cpu_topology_info = {
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index aa99a62e42..362378454a 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -113,6 +113,7 @@ static const char *const reset_dev_types[] = {
>       "s390-flic",
>       "diag288",
>       TYPE_S390_PCI_HOST_BRIDGE,
> +    TYPE_S390_CPU_TOPOLOGY,
>   };
>   
>   static void subsystem_reset(void)
> diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
> index 948e4bd3e0..707c0b658c 100644
> --- a/target/s390x/cpu-sysemu.c
> +++ b/target/s390x/cpu-sysemu.c
> @@ -306,3 +306,10 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg)
>           kvm_s390_set_diag318(cs, arg.host_ulong);
>       }
>   }
> +
> +void s390_cpu_topology_reset(void)
> +{
> +    if (kvm_enabled()) {
> +        kvm_s390_topology_set_mtcr(0);
> +    }
> +}
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index f96630440b..9c994d27d5 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -2585,3 +2585,26 @@ int kvm_s390_get_zpci_op(void)
>   {
>       return cap_zpci_op;
>   }
> +
> +int kvm_s390_topology_set_mtcr(uint64_t attr)
> +{
> +    struct kvm_device_attr attribute = {
> +        .group = KVM_S390_VM_CPU_TOPOLOGY,
> +        .attr  = attr,
> +    };
> +    int ret;
> +
> +    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
> +        return -EFAULT;

EFAULT is something that indicates a bad address (e.g. a segmentation fault) 
... so this definitely sounds like a bad choice for an error code here.

  Thomas


