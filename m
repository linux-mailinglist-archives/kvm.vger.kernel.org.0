Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623D960F1C9
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 10:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiJ0IF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 04:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbiJ0IF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 04:05:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6D33643E
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 01:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666857920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kiVqPx6WzKgITKnYhdH2TjnlWUBARdiwwDg7KFfkxuc=;
        b=ak3w3u3upWBJKOahDThQbOmPGSL6fIkbMN4l/WmOw4v5zmkqeUbun7AIMsYt7IaCOWAslq
        S2jab62/cbsBYMyZwo1rVJqtPtk+INrSaLAHtYqMDjKbMEhqHF99FhoxLNbvbV4K7Io07Y
        W2Tcg8UfOeOwA/CiTQE44F4Om3m/1Gs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-481-GL4YLtw0OFSvwRxrgEobBw-1; Thu, 27 Oct 2022 04:05:18 -0400
X-MC-Unique: GL4YLtw0OFSvwRxrgEobBw-1
Received: by mail-wm1-f69.google.com with SMTP id bg25-20020a05600c3c9900b003cf3ed7e27bso350706wmb.4
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 01:05:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kiVqPx6WzKgITKnYhdH2TjnlWUBARdiwwDg7KFfkxuc=;
        b=8Fhk7wwjnTY+U7nZt4tSHWHuGWN68h4nXS9zMgLAo/cUEG6fePpb9kNKVaRiaZC9v+
         BtOH073FzVTMaD1x3KDAjCznKyUklqhEFAXLk2oWPWT9tBD5TM+zlOch8O/c/bS8aaYU
         AlSZThc7S9Vj25ICxxfbiUKW6qR8ovN27jvH7LAFXVr4a0SZgQhgtOTm9FViGjqqqzFd
         mht8WMwFb8DhLtY2jrwtHZYiGnyy9uhT4BPZ/zDo/cL6GNJheoEj6nWw8XVoSAPIOpps
         OLn6wilO3an4+p4PCFvvYnxCV36WJbDQqwfSrWhgmsvB0u7f84otgydzfrWDEECaUW5p
         kKGw==
X-Gm-Message-State: ACrzQf2h8o8uQcKpMm618Hsdx8zEHV4OrFFEdOO75F/SI0MEw2tJvGph
        2LnU8x7YtZHCHAegI764sQ4LFCFWPlEpk97qWI1XvNHOisoDwzDG7aAveIjPD1NViNdBKbyK/3F
        Ql+ALaNwsVn88
X-Received: by 2002:a5d:564c:0:b0:236:6089:cc50 with SMTP id j12-20020a5d564c000000b002366089cc50mr16772326wrw.520.1666857917371;
        Thu, 27 Oct 2022 01:05:17 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6cGBa1vemygTiBh25vWQYc58I/twK3ikaEvNvyVh2CEHaa+xC3Ddfcg8NjWQQDBKWDKZN91A==
X-Received: by 2002:a5d:564c:0:b0:236:6089:cc50 with SMTP id j12-20020a5d564c000000b002366089cc50mr16772311wrw.520.1666857917143;
        Thu, 27 Oct 2022 01:05:17 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-195.web.vodafone.de. [109.43.176.195])
        by smtp.gmail.com with ESMTPSA id l8-20020a5d6d88000000b0022b315b4649sm597481wrs.26.2022.10.27.01.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 01:05:16 -0700 (PDT)
Message-ID: <a45185d1-16dc-6a31-6f1e-13b97fdb31e2@redhat.com>
Date:   Thu, 27 Oct 2022 10:05:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v10 1/9] s390x/cpu topology: core_id sets s390x CPU
 topology
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
 <20221012162107.91734-2-pmorel@linux.ibm.com>
 <65c3bfd263b03ca524444cdf5f96d937f582f2d7.camel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <65c3bfd263b03ca524444cdf5f96d937f582f2d7.camel@linux.ibm.com>
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

On 24/10/2022 21.25, Janis Schoetterl-Glausch wrote:
> On Wed, 2022-10-12 at 18:20 +0200, Pierre Morel wrote:
>> In the S390x CPU topology the core_id specifies the CPU address
>> and the position of the core withing the topology.
>>
>> Let's build the topology based on the core_id.
>> s390x/cpu topology: core_id sets s390x CPU topology
>>
>> In the S390x CPU topology the core_id specifies the CPU address
>> and the position of the cpu withing the topology.
>>
>> Let's build the topology based on the core_id.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/cpu-topology.h |  45 +++++++++++
>>   hw/s390x/cpu-topology.c         | 132 ++++++++++++++++++++++++++++++++
>>   hw/s390x/s390-virtio-ccw.c      |  21 +++++
>>   hw/s390x/meson.build            |   1 +
>>   4 files changed, 199 insertions(+)
>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>   create mode 100644 hw/s390x/cpu-topology.c
>>
>> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
>> new file mode 100644
>> index 0000000000..66c171d0bc
>> --- /dev/null
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -0,0 +1,45 @@
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright 2022 IBM Corp.
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
>> + * your option) any later version. See the COPYING file in the top-level
>> + * directory.
>> + */
>> +#ifndef HW_S390X_CPU_TOPOLOGY_H
>> +#define HW_S390X_CPU_TOPOLOGY_H
>> +
>> +#include "hw/qdev-core.h"
>> +#include "qom/object.h"
>> +
>> +typedef struct S390TopoContainer {
>> +    int active_count;
>> +} S390TopoContainer;
>> +
>> +#define S390_TOPOLOGY_CPU_IFL 0x03
>> +#define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
>> +typedef struct S390TopoTLE {
>> +    uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
>> +} S390TopoTLE;
> 
> Since this actually represents multiple TLEs, you might want to change the
> name of the struct to reflect this. S390TopoTLEList maybe?

Didn't TLE mean "Topology List Entry"? (by the way, Pierre, please explain 
this three letter acronym somewhere in this header in a comment)...

So expanding the TLE, this would mean S390TopoTopologyListEntryList ? ... 
this is getting weird... Also, this is not a "list" in the sense of a linked 
list, as one might expect at a first glance, so this is all very confusing 
here. Could you please come up with some better naming?

  Thomas

