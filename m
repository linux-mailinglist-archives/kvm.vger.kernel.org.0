Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A796F5430
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 11:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjECJOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 05:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjECJNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 05:13:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8499420B
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 02:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683105154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G69fIHlmIsYaU1yYzfVo/haBxO0QIvIFxIbtlU2nh10=;
        b=RiSKf0JYex2hVYU44u2M3V+RV/Wn73S3AozYy2lCtNHkXbMJtlFOlnfhGMKDOoxZCyf1xX
        2vYB7cFShIlSRMSWqcf2EqVLukR0UKgofNp8BwIdcrybXwenHj9fCEJb7enaisLd6Hbyju
        AYeJHI2QTBTJLHHpPihGXeEM8+t5zCI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-moweG_SNP5iCcBE3soVSJQ-1; Wed, 03 May 2023 05:12:33 -0400
X-MC-Unique: moweG_SNP5iCcBE3soVSJQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f1757ebb1eso14950905e9.2
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 02:12:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683105152; x=1685697152;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G69fIHlmIsYaU1yYzfVo/haBxO0QIvIFxIbtlU2nh10=;
        b=fqe9JqdW1X9ILXkW1Zk05weePIfko/aGhtKKo7LA3fwVO+NKMJC/0HLZwaYaSqKWiL
         Uc+OtfQdvWXDECOwj4OBuNuPZ5nHsX9HqyYb2CEs7pfsX0CSvAwt91UsJkV/1ypCMS6F
         R1Z+c3XHCe/8bCVFpFRco+Tk6IDH+mleBr0QH5eJtKSLUjWU0ynoFTguG1HR0blSf+Im
         RKFSkSuhWlP1bMpiyrkufX8wu8t2OHaOlB40uycAiPlEt8s8qzAquzllLQF3jtmmN3Sb
         4DUJ+qNrpVQsiqtnFYj7iOfNy18/Hi+i9qk6FK54kieITX5/OO3dZ2oz/6FQxl+yj6qv
         VqrA==
X-Gm-Message-State: AC+VfDwl8dcimRUjEGbH41XpL8LrtENrs6RTwMqyhL5INpObe8WlEw6T
        lsDvVfVdFTQf/yqVvvmeHeUEPxSYIBEO69Kk3DOrYXVdm4VG2mloDd3MZVm+XPv5GfQgQAoPONB
        Xhe45+KaEYnMW
X-Received: by 2002:a5d:6351:0:b0:306:2b9e:2a8c with SMTP id b17-20020a5d6351000000b003062b9e2a8cmr6978348wrw.11.1683105152375;
        Wed, 03 May 2023 02:12:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4wZ8Rfk7K2tKrJi73T13Id1JrbR75/WznOk8lrB7FKVufcPgcjccPOOclle2x2l+cpSZ3rig==
X-Received: by 2002:a5d:6351:0:b0:306:2b9e:2a8c with SMTP id b17-20020a5d6351000000b003062b9e2a8cmr6978329wrw.11.1683105152086;
        Wed, 03 May 2023 02:12:32 -0700 (PDT)
Received: from [10.33.192.225] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id d18-20020a5d4f92000000b002c7163660a9sm33097390wru.105.2023.05.03.02.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 02:12:31 -0700 (PDT)
Message-ID: <0d983d5f-f511-8e8f-0762-99f83e41171f@redhat.com>
Date:   Wed, 3 May 2023 11:12:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
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
 <1a919123-f07b-572e-8a33-0e5f9a6ed75c@redhat.com>
 <e233756c-52f6-547c-4c06-708459a98075@linux.ibm.com>
Content-Language: en-US
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v20 02/21] s390x/cpu topology: add topology entries on CPU
 hotplug
In-Reply-To: <e233756c-52f6-547c-4c06-708459a98075@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/2023 14.35, Pierre Morel wrote:
> 
> On 4/27/23 15:38, Thomas Huth wrote:
>> On 25/04/2023 18.14, Pierre Morel wrote:
>>> The topology information are attributes of the CPU and are
>>> specified during the CPU device creation.
>>>
>>> On hot plug we:
>>> - calculate the default values for the topology for drawers,
>>>    books and sockets in the case they are not specified.
>>> - verify the CPU attributes
>>> - check that we have still room on the desired socket
>>>
>>> The possibility to insert a CPU in a mask is dependent on the
>>> number of cores allowed in a socket, a book or a drawer, the
>>> checking is done during the hot plug of the CPU to have an
>>> immediate answer.
>>>
>>> If the complete topology is not specified, the core is added
>>> in the physical topology based on its core ID and it gets
>>> defaults values for the modifier attributes.
>>>
>>> This way, starting QEMU without specifying the topology can
>>> still get some advantage of the CPU topology.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>> ...
>>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>>> new file mode 100644
>>> index 0000000000..471e0e7292
>>> --- /dev/null
>>> +++ b/hw/s390x/cpu-topology.c
>>> @@ -0,0 +1,259 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>>> +/*
>>> + * CPU Topology
>>
>> Since you later introduce a file with almost the same name in the 
>> target/s390x/ folder, it would be fine to have some more explanation here 
>> what this file is all about (especially with regards to the other file in 
>> target/s390x/).
> 
> 
> I first did put the interceptions in target/s390/ then moved them in 
> target/s390x/kvm because it is KVM related then again only let STSI 
> interception.
> 
> But to be honest I do not see any reason why not put everything in hw/s390x/ 
> if CPU topology is implemented for TCG I think the code will call 
> insert_stsi_15_1_x() too.
> 
> no?

Oh well, it's all so borderline ... whether you rather think of this as part 
of the CPU (like the STSI instruction) or rather part of the machine 
(drawers, books, ...).
I don't mind too much, as long as we don't have two files around with almost 
the same name (apart from "_" vs. "-"). So either keep the stsi part in 
target/s390x and use a better file name for that, or put everything together 
in one "cpu-topology.c" file.
Or what do others think about it?

  Thomas

