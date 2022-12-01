Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54C863EC01
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 10:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiLAJJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 04:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiLAJJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 04:09:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375AD5C76C
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 01:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669885719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QxMB75eWtFF0uMoLEmcBdzPho0iX+ChWmUeNxOWjHHQ=;
        b=UAJoBvn+Nigs1mrF/BqdhSQ1XjDPBtBrMYbHxtTPLjLCF+8InNlmQd+IF+0vabfGEt0qFV
        lXWpORaaUE8AZO5icEMX1gl8uyjIj6uTONNv3gF9WdiRIUxFDybcq5I60I5/fpBdNLQFwr
        Dgcdi3w8L/eLdAssR4vQ7iDljhd8JjQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-275-gCcm9E4jNkqrA7dKgJfV5g-1; Thu, 01 Dec 2022 04:08:36 -0500
X-MC-Unique: gCcm9E4jNkqrA7dKgJfV5g-1
Received: by mail-wm1-f70.google.com with SMTP id 204-20020a1c02d5000000b003d06031f2cfso594700wmc.0
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 01:08:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QxMB75eWtFF0uMoLEmcBdzPho0iX+ChWmUeNxOWjHHQ=;
        b=ztsS6+2vPWpWJoOjqlvxG0Pp6iKBh2CEiorhx5MFBQz+rR6YQ0AYHLMAm5BgV3qLIO
         liImFxxU9xcSsS29wWH4aTiAaQ8Dyn6gTglbaPqxDg60Uyy8+GuHls3HkWfUwVFPrNO3
         vKedSnJwvbXN/N9mJkqeJgtcrMtABTOeHEM4lChXEe2AyK8LS780pEdbEK81bQf3UYjO
         H2cuuyM8Z79P/UQnbVTPokbxXD0pImlp/2bWxQ4LpNxxP+lX8XUbzqjeLl2z1tw4bpnv
         l9jxuF44p0eIzkNCqOxX43urcKSb108Zg2lPPwlLbLDj75eQ6TOxO/eXSU7uR1Hpo9Xi
         l3nQ==
X-Gm-Message-State: ANoB5plxKzpg4OnzggX+uYl15RfAuLBZEefayIZxgpPZZqfrpbHZ80/W
        UyUiyTxjnvqrd4J6LvJgRSakNo9VrWZw89xf/U2Z3OeH1jiRk0lOlWHNTycUIJzL6b27NbXsOWC
        ecMGrAuSLYNQB
X-Received: by 2002:a5d:6b0c:0:b0:241:c595:9f05 with SMTP id v12-20020a5d6b0c000000b00241c5959f05mr37181292wrw.439.1669885715589;
        Thu, 01 Dec 2022 01:08:35 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5UGx+VPpgBoJL4qDPhFrPR0TJKg4mQJDVgnOt/k9kp2qtdYpGndR+q9NhcXCRv71hLWUY8oA==
X-Received: by 2002:a5d:6b0c:0:b0:241:c595:9f05 with SMTP id v12-20020a5d6b0c000000b00241c5959f05mr37181274wrw.439.1669885715397;
        Thu, 01 Dec 2022 01:08:35 -0800 (PST)
Received: from [192.168.8.102] (tmo-073-221.customers.d1-online.com. [80.187.73.221])
        by smtp.gmail.com with ESMTPSA id h12-20020a05600c314c00b003cfa81e2eb4sm5118156wmo.38.2022.12.01.01.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 01:08:34 -0800 (PST)
Message-ID: <b61c8e4d-cae9-b267-a00b-007401b95bfb@redhat.com>
Date:   Thu, 1 Dec 2022 10:08:31 +0100
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
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
 <20221129174206.84882-2-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v12 1/7] s390x/cpu topology: Creating CPU topology device
In-Reply-To: <20221129174206.84882-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/11/2022 18.42, Pierre Morel wrote:
> We will need a Topology device to transfer the topology
> during migration and to implement machine reset.
> 
> The device creation is fenced by s390_has_topology().
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 2e64ffab45..973bbdd36e 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -44,6 +44,7 @@
>   #include "hw/s390x/pv.h"
>   #include "migration/blocker.h"
>   #include "qapi/visitor.h"
> +#include "hw/s390x/cpu-topology.h"
>   
>   static Error *pv_mig_blocker;
>   
> @@ -102,6 +103,24 @@ static void s390_init_cpus(MachineState *machine)
>       }
>   }
>   
> +static DeviceState *s390_init_topology(MachineState *machine, Error **errp)
> +{
> +    DeviceState *dev;
> +
> +    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
> +
> +    object_property_add_child(&machine->parent_obj,
> +                              TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));
> +    object_property_set_int(OBJECT(dev), "num-cores",
> +                            machine->smp.cores * machine->smp.threads, errp);

I wonder what will happen if we ever support multithreading on s390x later? 
... won't this cause some oddities when migrating older machines types with 
smp.threads > 1 later? Maybe we should prohibit to enable the CPU topology 
instead if a user tried to use threads > 1 with an older machine type?

  Thomas


> +    object_property_set_int(OBJECT(dev), "num-sockets",
> +                            machine->smp.sockets, errp);
> +
> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), errp);
> +
> +    return dev;
> +}

