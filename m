Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993E57511BA
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 22:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjGLUPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 16:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjGLUPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 16:15:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB971FE4
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 13:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689192906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rjXct6QyHMgUfqhtTgEk0R9CeSHqsm0bJ7QiO4uTmfE=;
        b=fYKm5AygN0HsDo9S3tv4b0ivxYmC46ahwapbPqklMY6eNr2R1YyxsjXiuoAOvJZ5JKDlur
        SvoOwQR5TnneZ6qmXSXD6gxg2GhpA5BL/joALy+dlCvqN+EFKr0N+F4RS8z5fLuOzk7/mj
        UYCtMTxSX603c5hBO16/CzTSA7B/s1M=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-KxePsIvgMvmidXYGLx68xg-1; Wed, 12 Jul 2023 16:15:04 -0400
X-MC-Unique: KxePsIvgMvmidXYGLx68xg-1
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-44515f0770bso8599137.2
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 13:15:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689192904; x=1691784904;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjXct6QyHMgUfqhtTgEk0R9CeSHqsm0bJ7QiO4uTmfE=;
        b=FU6m2kjz5CYEc32TWmlCYraS6KMcPZTFt3LXFX0qJgUcqJHjxkOa9c8r4JWs6oLM5U
         WTqL4cWA8Ts9xQnf9AIGAfQbSi7ARgD40gKRD4mIG25Ierjd1GwTE+WIMmEjuQtn2aUP
         4NCvzCa7cJ/Uozffr0XjaSbryBByu/62aK7f5wjrrG6sHwLBEBizPInyJoXfvqH8sc02
         /rBasy8IFO5dYOYqs8S00oakF3warKN3ZbjWbCfvsiP7cXFtFlRtbATGbJ5+moI7csvb
         X4cOlGY87QFSHC+tWT3NSIbirAbOIW0fvKoYOE9nrtoU4pSfXf+4aSzni9NfAzC2t3p4
         /0wg==
X-Gm-Message-State: ABy/qLYYxE9dWFJ85YKtyXtsoV5bbZa+YmcxK9OJ3vQ7QJ5CriH+FeFK
        TKBRKmK3Z6qrW9Jmo0sqluZxG+95F8M56/fb75ShSih4Y+wP2kQvdpCz+nGrAwSEiCasuc4Lb/9
        s4FZNBVvYk5zV
X-Received: by 2002:a05:6102:34e8:b0:444:17aa:df60 with SMTP id bi8-20020a05610234e800b0044417aadf60mr11395479vsb.13.1689192904077;
        Wed, 12 Jul 2023 13:15:04 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFVtFy0Lt61ytlue3Jw7sp5oSlCsS3zt2wE42+BBpCVNmjdJZmcZFIAIfS/ZBqq5gpdlFT53w==
X-Received: by 2002:a05:6102:34e8:b0:444:17aa:df60 with SMTP id bi8-20020a05610234e800b0044417aadf60mr11395473vsb.13.1689192903776;
        Wed, 12 Jul 2023 13:15:03 -0700 (PDT)
Received: from [192.168.8.101] (tmo-097-78.customers.d1-online.com. [80.187.97.78])
        by smtp.gmail.com with ESMTPSA id t10-20020a0ce2ca000000b0062618962ec0sm2435777qvl.133.2023.07.12.13.14.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 13:15:03 -0700 (PDT)
Message-ID: <6a302f29-9b46-2a5f-c1e2-7f72b38f0f6d@redhat.com>
Date:   Wed, 12 Jul 2023 22:14:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v21 03/20] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        frankja@linux.ibm.com, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-4-pmorel@linux.ibm.com>
 <aef8accb-3576-2b10-a946-191a6be3e3e0@redhat.com>
 <b1768b7b-301d-8208-8b31-8ddef378f216@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <b1768b7b-301d-8208-8b31-8ddef378f216@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/07/2023 16.24, Pierre Morel wrote:
> 
> On 7/4/23 13:40, Thomas Huth wrote:
>> On 30/06/2023 11.17, Pierre Morel wrote:
>>> On interception of STSI(15.1.x) the System Information Block
>>> (SYSIB) is built from the list of pre-ordered topology entries.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>> ...
>>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>>> index 7ebd5e05b6..6e7d041b01 100644
>>> --- a/target/s390x/cpu.h
>>> +++ b/target/s390x/cpu.h
>>> @@ -569,6 +569,29 @@ typedef struct SysIB_322 {
>>>   } SysIB_322;
>>>   QEMU_BUILD_BUG_ON(sizeof(SysIB_322) != 4096);
>>>   +/*
>>> + * Topology Magnitude fields (MAG) indicates the maximum number of
>>> + * topology list entries (TLE) at the corresponding nesting level.
>>> + */
>>> +#define S390_TOPOLOGY_MAG  6
>>> +#define S390_TOPOLOGY_MAG6 0
>>> +#define S390_TOPOLOGY_MAG5 1
>>> +#define S390_TOPOLOGY_MAG4 2
>>> +#define S390_TOPOLOGY_MAG3 3
>>> +#define S390_TOPOLOGY_MAG2 4
>>> +#define S390_TOPOLOGY_MAG1 5
>>> +/* Configuration topology */
>>> +typedef struct SysIB_151x {
>>> +    uint8_t  reserved0[2];
>>> +    uint16_t length;
>>> +    uint8_t  mag[S390_TOPOLOGY_MAG];
>>> +    uint8_t  reserved1;
>>> +    uint8_t  mnest;
>>> +    uint32_t reserved2;
>>> +    char tle[];
>>> +} SysIB_151x;
>>> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
>>> +
>>>   typedef union SysIB {
>>>       SysIB_111 sysib_111;
>>>       SysIB_121 sysib_121;
>>> @@ -576,9 +599,62 @@ typedef union SysIB {
>>>       SysIB_221 sysib_221;
>>>       SysIB_222 sysib_222;
>>>       SysIB_322 sysib_322;
>>> +    SysIB_151x sysib_151x;
>>>   } SysIB;
>>>   QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
>>>   +/*
>>> + * CPU Topology List provided by STSI with fc=15 provides a list
>>> + * of two different Topology List Entries (TLE) types to specify
>>> + * the topology hierarchy.
>>> + *
>>> + * - Container Topology List Entry
>>> + *   Defines a container to contain other Topology List Entries
>>> + *   of any type, nested containers or CPU.
>>> + * - CPU Topology List Entry
>>> + *   Specifies the CPUs position, type, entitlement and polarization
>>> + *   of the CPUs contained in the last Container TLE.
>>> + *
>>> + * There can be theoretically up to five levels of containers, QEMU
>>> + * uses only three levels, the drawer's, book's and socket's level.
>>> + *
>>> + * A container with a nesting level (NL) greater than 1 can only
>>> + * contain another container of nesting level NL-1.
>>> + *
>>> + * A container of nesting level 1 (socket), contains as many CPU TLE
>>> + * as needed to describe the position and qualities of all CPUs inside
>>> + * the container.
>>> + * The qualities of a CPU are polarization, entitlement and type.
>>> + *
>>> + * The CPU TLE defines the position of the CPUs of identical qualities
>>> + * using a 64bits mask which first bit has its offset defined by
>>> + * the CPU address orgin field of the CPU TLE like in:
>>> + * CPU address = origin * 64 + bit position within the mask
>>> + *
>>> + */
>>> +/* Container type Topology List Entry */
>>> +typedef struct SysIBTl_container {
>>> +        uint8_t nl;
>>> +        uint8_t reserved[6];
>>> +        uint8_t id;
>>> +} SysIBTl_container;
>>
>> Why mixing CamelCase with underscore-style here? SysIBTlContainer would 
>> look more natural, I think?
> 
> 
> OK, what about SYSIBContainerListEntry ?

Sounds fine!

> 
>>
>>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
>>> +
>>> +/* CPU type Topology List Entry */
>>> +typedef struct SysIBTl_cpu {
>>> +        uint8_t nl;
>>> +        uint8_t reserved0[3];
>>> +#define SYSIB_TLE_POLARITY_MASK 0x03
>>> +#define SYSIB_TLE_DEDICATED     0x04
>>> +        uint8_t flags;
>>> +        uint8_t type;
>>> +        uint16_t origin;
>>> +        uint64_t mask;
>>> +} SysIBTl_cpu;
>>
>> dito, maybe better SysIBTlCpu ?
> 
> 
> What about SysIBCPUListEntry ?

Ack.

  Thomas


