Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571DE66717A
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 13:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236749AbjALMAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 07:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjALL7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 06:59:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1182050E49
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 03:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673524359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Jnv11p8/p3gyPXhfzLFhgQ2bMLOcfy8scnrrZUdSr0=;
        b=XjFAZHhdD7aGXySm2wxEC6qg3i6AhlYaRmK6ugTJ9w+9qPB8M5G89mr+diYJh6h0/rxglw
        D6W6AIrvq5Vof+u/7Wo341Ncyjjp/4yvwKei9503eJxQjZyLC8mPx0AcaekeWDgXLUdMZ+
        x6QA7o5g9/nP2UncPzbo6PjXl4MmryU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-75-T4rzr_RPOMS-ksPqbtP7zg-1; Thu, 12 Jan 2023 06:52:38 -0500
X-MC-Unique: T4rzr_RPOMS-ksPqbtP7zg-1
Received: by mail-wm1-f71.google.com with SMTP id c7-20020a1c3507000000b003d355c13ba8so9161575wma.6
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 03:52:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Jnv11p8/p3gyPXhfzLFhgQ2bMLOcfy8scnrrZUdSr0=;
        b=biGl4ar4/vft8DqZFVLJqAPq1lMeL60g74dL7ydOl8SDoebr6mRfYGtr6nm7lbSMTx
         gumRmRvK3Elg1ps3A6WwJYM+eqi4d/HnXxfaSSqBI5Qb+IW8TEXrkV0Jn2Tvrnhbj8Wg
         xibG57MwnIcgwGSBTrqZGrubB5LQkJcbPxcFKfcdR4smZd2GiSeCMMx+eOY9oJ9VWPyS
         eihHBd25QpHsF/Aywzt4d96TkzY4eaaIn7yYCSWTVpV1+wQdz7TOFnyBmVCJe622KZOD
         g/tl5Rp3qmCz3AupNeOAHS9oNfkgC3YHLiW27cWh8inJn5ZBVDrBOU+5bYdA8wdBHLFo
         VJdQ==
X-Gm-Message-State: AFqh2krH0QvUwNtqm9uxG1g8Mu4yaxKUvTXQfpFTmrMfCBqFDD7iTK2r
        q1cA7fFrHzRm3yjHMJShY5+Vyq8zh1aqzm3rbVGgkAAcUlZaxHhmhSCq+mFge+5QxLHunxGhPN3
        g6XCIL6IXq6UR
X-Received: by 2002:adf:ef0d:0:b0:2bc:8360:885 with SMTP id e13-20020adfef0d000000b002bc83600885mr8372921wro.21.1673524357017;
        Thu, 12 Jan 2023 03:52:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuqsT3dDr5vjdtlamMwWWOda3bUZMRGnbspNnRt7MCNDFd/eKnyFqG8kQzczXAPXKAAwU64cQ==
X-Received: by 2002:adf:ef0d:0:b0:2bc:8360:885 with SMTP id e13-20020adfef0d000000b002bc83600885mr8372900wro.21.1673524356793;
        Thu, 12 Jan 2023 03:52:36 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-128.web.vodafone.de. [109.43.177.128])
        by smtp.gmail.com with ESMTPSA id w6-20020adfd4c6000000b0027cb20605e3sm15955030wrk.105.2023.01.12.03.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 03:52:36 -0800 (PST)
Message-ID: <c338245c-82c3-ed57-9c98-f4d630fa1759@redhat.com>
Date:   Thu, 12 Jan 2023 12:52:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v14 10/11] qapi/s390/cpu topology: POLARITY_CHANGE qapi
 event
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
 <20230105145313.168489-11-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230105145313.168489-11-pmorel@linux.ibm.com>
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
> When the guest asks to change the polarity this change
> is forwarded to the admin using QAPI.
> The admin is supposed to take according decisions concerning
> CPU provisioning.

I somehow doubt that an average admin will monitor QEMU for such events ... 
so this rather should be handled by upper layers like libvirt one day?

> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   qapi/machine-target.json | 21 +++++++++++++++++++++
>   hw/s390x/cpu-topology.c  |  2 ++
>   2 files changed, 23 insertions(+)
> 
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index 927618a78f..10235cfb45 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -437,3 +437,24 @@
>     'returns': ['S390CpuTopology'],
>     'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>   }
> +
> +##
> +# @POLARITY_CHANGE:

I'd maybe rather call it CPU_POLARITY_CHANGE ... in case "polarity" is one 
day also used for some other devices.

> +#
> +# Emitted when the guest asks to change the polarity.
> +#
> +# @polarity: polarity specified by the guest

Please elaborate: Where does the value come from (the PTF instruction)? 
Which values are possible?

  Thomas


> +#
> +# Since: 8.0
> +#
> +# Example:
> +#
> +# <- { "event": "POLARITY_CHANGE",
> +#      "data": { "polarity": 0 },
> +#      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
> +#
> +##
> +{ 'event': 'POLARITY_CHANGE',
> +  'data': { 'polarity': 'int' },
> +   'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM'] }
> +}
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index c3748654ff..45621387d5 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -19,6 +19,7 @@
>   #include "hw/s390x/s390-virtio-ccw.h"
>   #include "hw/s390x/cpu-topology.h"
>   #include "qapi/qapi-commands-machine-target.h"
> +#include "qapi/qapi-events-machine-target.h"
>   #include "qapi/qmp/qdict.h"
>   #include "monitor/hmp.h"
>   #include "monitor/monitor.h"
> @@ -128,6 +129,7 @@ void s390_topology_set_polarity(int polarity)
>           }
>       }
>       s390_cpu_topology_set();
> +    qapi_event_send_polarity_change(polarity);
>   }
>   
>   /*

