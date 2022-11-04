Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5D4619A02
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 15:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbiKDOdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 10:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiKDOcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 10:32:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F129A3122B
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 07:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667572185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K0NQRmCrmy0snNMqQGvOxaS4uPp+eLjooqLWgEXCU88=;
        b=Ev2fc7xThikgD8KbstqLkLRqXf0xXPzmarvmhuZ8vPv2PruCJWJQYKHry20CoHTRPEr4rh
        KvZZXq7HDIOaPuYwopNmeXpP1isF3BhcrHKZuE1DSwL+W5LRplX/2N0S4yukfrdeWtmJGD
        9nIlBmEdJHmjq0x4hYSjcPQIRLKkiQk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-145-mUtqX_4NM8qQghMRCq0paQ-1; Fri, 04 Nov 2022 10:29:43 -0400
X-MC-Unique: mUtqX_4NM8qQghMRCq0paQ-1
Received: by mail-wm1-f71.google.com with SMTP id c10-20020a7bc84a000000b003cf81c2d3efso1812520wml.7
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 07:29:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K0NQRmCrmy0snNMqQGvOxaS4uPp+eLjooqLWgEXCU88=;
        b=dZ/BgZPwkIHD7K01N0lcDRNMywXyDs82qUuf7957tUAyCxxU41HI52XXwrLxkj5xnn
         f+NvPikcQ50eS7ap/XMQcvs0uW/yrrE0P2uroGEQAOMWo2uZf8uVDfG01Z4SO53nygIn
         WBYoUmmf3IDORAjwq78ldHjz4BMrQAgMJ5jZ242zO/Cc2EEPwfU3Rsk/p6JBAnCp5GgE
         /G0G/IHirzZ6ovwXT2VuMuI85f2rurSNFNSb7/cCUpIZi5Pt0Y/iXMaEyj2/Vbo7fZAI
         K6bDMdBcx18sfhxz3pvlvAgMve+GiXA2cbzny87NOoCeGeyr97JlZpnLxkiw0/oyNyTN
         ZD9Q==
X-Gm-Message-State: ACrzQf0qPumFYPEYulqClpN8Au8DJIELux77z5rqoz3swmo1UW0NRHsF
        yA1BBZUHv0d4wHwuJw09YiGsYLi4DPsE/7d02nIWJbQndBTLRX7V1mj+umGdYwkY3ksskBehWxV
        CwejG6RJRAi8h
X-Received: by 2002:a05:600c:3d8a:b0:3c6:f241:cb36 with SMTP id bi10-20020a05600c3d8a00b003c6f241cb36mr23848725wmb.115.1667572182756;
        Fri, 04 Nov 2022 07:29:42 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5b4jwcT/qiNkNkDn0JGgJsf2gDj2TH9ztahfx6jfDmW8RW+kgc5CPYDKLVgnl4o5IDLvpj/g==
X-Received: by 2002:a05:600c:3d8a:b0:3c6:f241:cb36 with SMTP id bi10-20020a05600c3d8a00b003c6f241cb36mr23848702wmb.115.1667572182483;
        Fri, 04 Nov 2022 07:29:42 -0700 (PDT)
Received: from [10.33.192.232] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id v9-20020a5d4b09000000b00228a6ce17b4sm3634702wrq.37.2022.11.04.07.29.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 07:29:41 -0700 (PDT)
Message-ID: <7a3c34dc-2c16-6fdd-e8bc-7a1c623823ae@redhat.com>
Date:   Fri, 4 Nov 2022 15:29:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-2-pmorel@linux.ibm.com>
 <3f913a58-e7d0-539e-3bc0-6cbd5608db8e@redhat.com>
 <7d809617-67e0-d233-97b2-8534e2a4610f@linux.ibm.com>
 <6415cf08-e6a1-c72a-1c56-907d3a446a8c@kaod.org>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v11 01/11] s390x: Register TYPE_S390_CCW_MACHINE
 properties as class properties
In-Reply-To: <6415cf08-e6a1-c72a-1c56-907d3a446a8c@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/2022 11.53, Cédric Le Goater wrote:
> On 11/4/22 11:16, Pierre Morel wrote:
>>
>>
>> On 11/4/22 07:32, Thomas Huth wrote:
>>> On 03/11/2022 18.01, Pierre Morel wrote:
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>   hw/s390x/s390-virtio-ccw.c | 127 +++++++++++++++++++++----------------
>>>>   1 file changed, 72 insertions(+), 55 deletions(-)
>>>
>>> -EMISSINGPATCHDESCRIPTION
>>>
>>> ... please add some words *why* this is a good idea / necessary.
>>
>> I saw that the i386 patch had no description for the same patch so...
>>
>> To be honest I do not know why it is necessary.
>> The only reason I see is to be in sync with the PC implementation.
>>
>> So what about:
>> "
>> Register TYPE_S390_CCW_MACHINE properties as class properties
>> to be conform with the X architectures
>> "
>> ?
>>
>> @Cédric , any official recommendation for doing that?
> 
> There was a bunch of commits related to QOM in this series :
> 
>    91def7b83 arm/virt: Register most properties as class properties
>    f5730c69f0 i386: Register feature bit properties as class properties
> 
> which moved property definitions at the class level.
> 
> Then,
> 
>    commit d8fb7d0969 ("vl: switch -M parsing to keyval")
> 
> changed machine_help_func() to use a machine class and not machine
> instance anymore.
> 
> I would use the same kind of commit log and add a Fixes tag to get it
> merged in 7.2

Ah, so this fixes the problem that running QEMU with " -M 
s390-ccw-virtio,help" does not show the s390x-specific properties anymore? 
... that's certainly somethings that should be mentioned in the commit 
message! What about something like this:

"Currently, when running 'qemu-system-s390x -M -M s390-ccw-virtio,help' the 
s390x-specific properties are not listed anymore. This happens because since 
commit d8fb7d0969 ("vl: switch -M parsing to keyval") the properties have to 
be defined at the class level and not at the instance level anymore. Fix it 
on s390x now, too, by moving the registration of the properties to the class 
level"

Fixes: d8fb7d0969 ("vl: switch -M parsing to keyval")

?

  Thomas

