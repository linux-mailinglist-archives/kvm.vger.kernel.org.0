Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D921D6482FB
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 14:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiLINwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 08:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiLINvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 08:51:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18706ACFB
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 05:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670593858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UdIkgy6BMRJ7r/sade2qdtqGA4Czc9DE5XCsMjvzwps=;
        b=Qlbe/bJoXt85XnJtpqgr6F+8mW3bCj9zCNaTFhPcuf6nNdq4rGeQ3ytrlxsaYPDJTjofFc
        uLsxAlUwe6z2BZd9PSUSg7JD6ULyTmxNZn6Unb1eH4P+tjz611Z5PfQ3CKBqNd8wEJy/+S
        po5nxwSvwCmXuL9UT4Qh3cvMXFeEy5I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-622-zWk_PE_1OPqWBM8u22KcDQ-1; Fri, 09 Dec 2022 08:50:51 -0500
X-MC-Unique: zWk_PE_1OPqWBM8u22KcDQ-1
Received: by mail-wm1-f69.google.com with SMTP id q6-20020a05600c2e4600b003d211775a99so537640wmf.1
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 05:50:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UdIkgy6BMRJ7r/sade2qdtqGA4Czc9DE5XCsMjvzwps=;
        b=FHbjBpYpklbjJeVhtHISYprSHZ3/JrgJgSwGDehrk3sOs1RsgIK2iT3hnuImEADkQe
         gIrar6aeeMgvZpCBw8dg+HcxE4H2sMVuCRV++3sVJOTbdDUbntBle3/3VuaA6HQNh+/e
         jIUXSD+jQJgG3tFuboM+10BAvTTTzUKCHcTEH7jaslM6284Qgu28/69wRv9e+wca69oO
         91N+Xc9ICcQn9ai1M19I4ViJaZ5Qj+tgssFuuCLTR1G1aG7SYWKzUVZ4PnR+ulmpxKnA
         jw9W/K8qQf+TL+XjIqBhFPSzuY6fQMqF9DRu3WU4JmiiuJJLR3vPACXx6FMLBrB5qonc
         U9oQ==
X-Gm-Message-State: ANoB5pmNZE7+1XbRnCVYqHNqJiGJ1ByMM6b7K8S7UjMfBmfeVa8JindB
        ZyOoZi0fDzFhbCThIvhVEiH6/QLIB6oJ3UEDKXZK6q6AMa5dlvsaFGBmz5BMj7wAv+lTP4OYvft
        nVGHPVfPBM0qz
X-Received: by 2002:a05:600c:348a:b0:3c6:e63e:89aa with SMTP id a10-20020a05600c348a00b003c6e63e89aamr5086722wmq.6.1670593850406;
        Fri, 09 Dec 2022 05:50:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4hgYz57feDfx3gQAIUTjMoGk2YWf2IxJA0RI3KDh7nNxWom8c+WkUNGbJES5lR/4S4VdNNQQ==
X-Received: by 2002:a05:600c:348a:b0:3c6:e63e:89aa with SMTP id a10-20020a05600c348a00b003c6e63e89aamr5086702wmq.6.1670593850200;
        Fri, 09 Dec 2022 05:50:50 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-177-15.web.vodafone.de. [109.43.177.15])
        by smtp.gmail.com with ESMTPSA id i10-20020a1c540a000000b003d1f2c3e571sm7855692wmb.33.2022.12.09.05.50.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 05:50:49 -0800 (PST)
Message-ID: <be4571a6-edaa-3291-1b31-6f309c00a9f9@redhat.com>
Date:   Fri, 9 Dec 2022 14:50:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v13 1/7] s390x/cpu topology: Creating CPU topology device
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <20221208094432.9732-2-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221208094432.9732-2-pmorel@linux.ibm.com>
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

On 08/12/2022 10.44, Pierre Morel wrote:
> We will need a Topology device to transfer the topology
> during migration and to implement machine reset.
> 
> The device creation is fenced by s390_has_topology().
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
[...]
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..b3e59873f6
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
> @@ -0,0 +1,149 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> +
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qemu/error-report.h"
> +#include "hw/qdev-properties.h"
> +#include "hw/boards.h"
> +#include "qemu/typedefs.h"
> +#include "target/s390x/cpu.h"
> +#include "hw/s390x/s390-virtio-ccw.h"
> +#include "hw/s390x/cpu-topology.h"
> +
> +/**
> + * s390_has_topology
> + *
> + * Return false until the commit activating the topology is
> + * commited.
> + */
> +bool s390_has_topology(void)
> +{
> +    return false;
> +}
> +
> +/**
> + * s390_get_topology
> + *
> + * Returns a pointer to the topology.
> + *
> + * This function is called when we know the topology exist.
> + * Testing if the topology exist is done with s390_has_topology()
> + */
> +S390Topology *s390_get_topology(void)
> +{
> +    static S390Topology *s390Topology;
> +
> +    if (!s390Topology) {
> +        s390Topology = S390_CPU_TOPOLOGY(
> +            object_resolve_path(TYPE_S390_CPU_TOPOLOGY, NULL));
> +    }
> +
> +    assert(s390Topology);

I think you can move the assert() into the body of the if-statement.

> +    return s390Topology;
> +}
> +
> +/**
> + * s390_init_topology
> + * @machine: The Machine state, used to retrieve the SMP parameters
> + * @errp: the error pointer in case of problem
> + *
> + * This function creates and initialize the S390Topology with
> + * the QEMU -smp parameters we will use during adding cores to the
> + * topology.
> + */
> +void s390_init_topology(MachineState *machine, Error **errp)
> +{
> +    DeviceState *dev;
> +
> +    if (machine->smp.threads > 1) {
> +        error_setg(errp, "CPU Topology do not support multithreading");

s/CPU Toplogy do/CPU topology does/

> +        return;
> +    }
> +
> +    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
> +
> +    object_property_add_child(&machine->parent_obj,
> +                              TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));
> +    object_property_set_int(OBJECT(dev), "num-cores",
> +                            machine->smp.cores, errp);
> +    object_property_set_int(OBJECT(dev), "num-sockets",
> +                            machine->smp.sockets, errp);
> +
> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), errp);
> +}

  Thomas

