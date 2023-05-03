Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEE96F556E
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 11:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjECJ40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 05:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjECJ4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 05:56:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC275FD2
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 02:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683107654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QfDh1HnKMyX+ix+B/1joO88eLFvIU3pV3Zk04H6Q3pM=;
        b=HMmhNTCTG8cCouiAQOJeA2UYkQnj2ozibxXx0D2mToUwGBcRwapjtmKRA5jQ0uJ3g1L09J
        sfv1D+PtTfzsw9d5WsQ/XP711HUrgyPBXDQ7T19Yoim5HiEbFMvVRC46MaZlWBGYa57XmI
        scpIvA3gzCxOIhnJAVwOecGHqPbCPXc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-DpI_3yHcM7WC-gbDjAB9Uw-1; Wed, 03 May 2023 05:54:13 -0400
X-MC-Unique: DpI_3yHcM7WC-gbDjAB9Uw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-306286b3573so2422011f8f.2
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 02:54:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683107652; x=1685699652;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QfDh1HnKMyX+ix+B/1joO88eLFvIU3pV3Zk04H6Q3pM=;
        b=fXXyL/75zfA1Mqf5J7RthSlt0b8CT3zmbAQhrSD9KU0fQ0Sepuk2q9Dzdezb+/PDIT
         3DNq+jRi/1K8pOIF7v9lbivlM0tX9hHcpiR6g9EFYPyAThGSCwiHkVzws7s+lLSG64JN
         M9UbWD1EtUG3F5jbumdiszBOgej2tpFtVPu2Hh9/DJnO//T+H5NC/qKatebPX6glq7lR
         SB8/63qHy0He8/HrMXbvkperK2hQTSZ2px2Tq0KGLV6F0F+2bxpX8vDL+xQGJdn4lgiR
         UbIBooi63eIdXHg7xl2wmnUKJXO7E/cn+9nXPG6w7TButUmukoZW8pw8vVdMq1kBQRAU
         lrdw==
X-Gm-Message-State: AC+VfDzCtQCCFbGimgOjoh0hoaiGIPlBSRzTlazOEKcERh9HvJDqckzT
        DF09mYHmyaFu7ZqEEgoyMgP+laKuJ9T59jjlLR9SSHDwP4cr6tuq/J/KbSnxiynja7jYmVLU4og
        7HfBUD3DpdpAG
X-Received: by 2002:a5d:6243:0:b0:2fb:bb97:d975 with SMTP id m3-20020a5d6243000000b002fbbb97d975mr14157235wrv.47.1683107652093;
        Wed, 03 May 2023 02:54:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6z8OMMoDCsW7/+VAR/96RegARypnwnMLqZLZrqW6zoadIY7R4GMQEQxDFLLLf8zI2RTNd5pg==
X-Received: by 2002:a5d:6243:0:b0:2fb:bb97:d975 with SMTP id m3-20020a5d6243000000b002fbbb97d975mr14157220wrv.47.1683107651806;
        Wed, 03 May 2023 02:54:11 -0700 (PDT)
Received: from [10.33.192.225] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id j6-20020a5d6186000000b003063772a55bsm4221775wru.61.2023.05.03.02.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 02:54:11 -0700 (PDT)
Message-ID: <669d2181-7429-5c49-aad1-65fb844f2e5a@redhat.com>
Date:   Wed, 3 May 2023 11:54:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v20 01/21] s390x/cpu topology: add s390 specifics to CPU
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
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-2-pmorel@linux.ibm.com>
 <45e09800-6a47-0372-5244-16e2dc72370d@redhat.com>
 <47e3a077-0819-e88b-bc49-a580c8939350@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <47e3a077-0819-e88b-bc49-a580c8939350@linux.ibm.com>
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

On 03/05/2023 11.36, Pierre Morel wrote:
> 
> On 4/27/23 10:04, Thomas Huth wrote:
>> On 25/04/2023 18.14, Pierre Morel wrote:
>>> S390 adds two new SMP levels, drawers and books to the CPU
>>> topology.
>>> The S390 CPU have specific topology features like dedication
>>> and entitlement to give to the guest indications on the host
>>> vCPUs scheduling and help the guest take the best decisions
>>> on the scheduling of threads on the vCPUs.
>>>
>>> Let us provide the SMP properties with books and drawers levels
>>> and S390 CPU with dedication and entitlement,
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> 
> [...]
> 
> 
>>>   {
>>>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>>>       unsigned cpus    = config->has_cpus ? config->cpus : 0;
>>> +    unsigned drawers = config->has_drawers ? config->drawers : 0;
>>> +    unsigned books   = config->has_books ? config->books : 0;
>>>       unsigned sockets = config->has_sockets ? config->sockets : 0;
>>>       unsigned dies    = config->has_dies ? config->dies : 0;
>>>       unsigned clusters = config->has_clusters ? config->clusters : 0;
>>> @@ -85,6 +98,8 @@ void machine_parse_smp_config(MachineState *ms,
>>>        * explicit configuration like "cpus=0" is not allowed.
>>>        */
>>>       if ((config->has_cpus && config->cpus == 0) ||
>>> +        (config->has_drawers && config->drawers == 0) ||
>>> +        (config->has_books && config->books == 0) ||
>>>           (config->has_sockets && config->sockets == 0) ||
>>>           (config->has_dies && config->dies == 0) ||
>>>           (config->has_clusters && config->clusters == 0) ||
>>> @@ -111,6 +126,19 @@ void machine_parse_smp_config(MachineState *ms,
>>>       dies = dies > 0 ? dies : 1;
>>>       clusters = clusters > 0 ? clusters : 1;
>>>   +    if (!mc->smp_props.books_supported && books > 1) {
>>> +        error_setg(errp, "books not supported by this machine's CPU 
>>> topology");
>>> +        return;
>>> +    }
>>> +    books = books > 0 ? books : 1;
>>
>> Could be shortened to:  book = books ?: 1;
>>
> More thinking about this, all other existing assignments are done so, 
> clusters, dies, sockets, cores and threads.
> 
> to keep the core consistent shouldn't we keep it the same way?

Fine for me, too. It just might happen that I forget about it and suggest it 
again in a future version of the patch ;-)

  Thomas

