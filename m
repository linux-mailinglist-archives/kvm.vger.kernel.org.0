Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1096F06C2
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 15:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243440AbjD0NjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 09:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243215AbjD0NjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 09:39:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B5C1B8
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 06:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682602713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XHFntnekYXETfFFiCrSNt5DtnSXpqwhD/5/8kxtTcsA=;
        b=RIMFMCGE2IS1DOEuQ3NvYx3p0/mGOhDPPbncVeeBU0hpzXIUbo6/qpO6vBuDbv8W4XfoDz
        DhC9UtzdwLX5egjZXZwQucTXCzYemTVHF3P/1VVgeA5MXzNoiQMS+XI+FnMd429JcOzhte
        OAcYEWzM2vKxPrOwoD3Rzrz5G/ZWbSw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-b9h_cwrqNRmtHlnbJfrvhQ-1; Thu, 27 Apr 2023 09:38:31 -0400
X-MC-Unique: b9h_cwrqNRmtHlnbJfrvhQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f19517536eso27893255e9.2
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 06:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682602710; x=1685194710;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XHFntnekYXETfFFiCrSNt5DtnSXpqwhD/5/8kxtTcsA=;
        b=JyjkxsObioUu5V7rB2c0htszV9Opqrdc+QW8AnD1n24wrM3V4fmhZlslpJnI+Q4wW8
         olGwiHJTdmRthAimvP4jcSY4bIBzv/FX9Olsq4HuYdN2Cxp0mvW1ZKmrnq/f3+WH2aEh
         cQwoePgILRiRj14AVMdpJ1LKKKmrdaBbH4WLdVV/ugspQaYMMz1Om3eg6FSjhhzmp8zF
         aZUryRHUF0YMs51GpsLVifSVOYLpMktCBwYQVzLkdr8pUpvB/2fMiZMjbd3ZVnuq6wIu
         0/rzHdUOXzYbTKVraOStfuR31BVcTyeiFvZd+bpTqtGJuh8QroW2rf/gPWHb+hJ3rk+B
         /HDw==
X-Gm-Message-State: AC+VfDxeEGz8KFDFLDTmplzVJ7SRlcfGwvpJV34gcgUqPaM0eykaSMf7
        GeBiWWWg4OUArNo1s7jSia2Ac+OCDjoyi6/SMzFA6pxKY2UIKaFC5G7Eg2UR2GtFPa547sRCxMt
        9MANBiyZXznSP
X-Received: by 2002:a5d:4611:0:b0:2f9:7841:f960 with SMTP id t17-20020a5d4611000000b002f97841f960mr1535202wrq.21.1682602709928;
        Thu, 27 Apr 2023 06:38:29 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6HKPEyrCnedzzIBCBcqoeLnK2efHxefTWPkCgCCVjmHcrNDNXPwJDn7e2CPT4IIqtm0xaJmw==
X-Received: by 2002:a5d:4611:0:b0:2f9:7841:f960 with SMTP id t17-20020a5d4611000000b002f97841f960mr1535182wrq.21.1682602709654;
        Thu, 27 Apr 2023 06:38:29 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id r17-20020adfdc91000000b002ff2c39d072sm18585239wrj.104.2023.04.27.06.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 06:38:29 -0700 (PDT)
Message-ID: <1a919123-f07b-572e-8a33-0e5f9a6ed75c@redhat.com>
Date:   Thu, 27 Apr 2023 15:38:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-3-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v20 02/21] s390x/cpu topology: add topology entries on CPU
 hotplug
In-Reply-To: <20230425161456.21031-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/04/2023 18.14, Pierre Morel wrote:
> The topology information are attributes of the CPU and are
> specified during the CPU device creation.
> 
> On hot plug we:
> - calculate the default values for the topology for drawers,
>    books and sockets in the case they are not specified.
> - verify the CPU attributes
> - check that we have still room on the desired socket
> 
> The possibility to insert a CPU in a mask is dependent on the
> number of cores allowed in a socket, a book or a drawer, the
> checking is done during the hot plug of the CPU to have an
> immediate answer.
> 
> If the complete topology is not specified, the core is added
> in the physical topology based on its core ID and it gets
> defaults values for the modifier attributes.
> 
> This way, starting QEMU without specifying the topology can
> still get some advantage of the CPU topology.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..471e0e7292
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
> @@ -0,0 +1,259 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * CPU Topology

Since you later introduce a file with almost the same name in the 
target/s390x/ folder, it would be fine to have some more explanation here 
what this file is all about (especially with regards to the other file in 
target/s390x/).

> + *
> + * Copyright IBM Corp. 2022,2023
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qemu/error-report.h"
> +#include "hw/qdev-properties.h"
> +#include "hw/boards.h"
> +#include "qemu/typedefs.h"

qemu/typedefs.h is already included by osdep.h by default, no need to 
re-include it here.

> +#include "target/s390x/cpu.h"
> +#include "hw/s390x/s390-virtio-ccw.h"
> +#include "hw/s390x/cpu-topology.h"
...> +
> +/**
> + * s390_topology_setup_cpu:
> + * @ms: MachineState used to initialize the topology structure on
> + *      first call.
> + * @cpu: the new S390CPU to insert in the topology structure
> + * @errp: the error pointer
> + *
> + * Called from CPU Hotplug to check and setup the CPU attributes

s/Hotplug/hotplug/

> + * before the CPU is inserted in the topology.
> + * There is no need to update the MTCR explicitely here because it

s/explicitely/explicitly/

> + * will be updated by KVM on creation of the new CPU.
> + */
> +void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
...

  Thomas


