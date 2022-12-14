Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2E364C749
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 11:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237984AbiLNKka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 05:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237911AbiLNKk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 05:40:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB1023397
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 02:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671014379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Wkenrs+ujiU8vud5r51m+YKWxnHOKAbgiQrKXuiRzw=;
        b=YqVaFXuzEFrOc/XDLPodTMEUsl1wXXBHUDg0YkIL3WBvq4bYEEZ3U+G88vVrmFfkBG4Tvn
        Qber3KU9j78lNoT63Dk0IRj8MkjCByzn6DwCZyOEsQ9nwmycmBWu4/nlGAwKGWtMLaYhWD
        bQatsVVCRf+Y+EVIiyVRyKAfQmXbDeM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-74-omauLMOVNPKE1MpCAT5Ocw-1; Wed, 14 Dec 2022 05:39:38 -0500
X-MC-Unique: omauLMOVNPKE1MpCAT5Ocw-1
Received: by mail-wm1-f69.google.com with SMTP id 21-20020a05600c021500b003d227b209e1so2824289wmi.1
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 02:39:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Wkenrs+ujiU8vud5r51m+YKWxnHOKAbgiQrKXuiRzw=;
        b=5gNEbkbIkB4dXBURTxHF47+CeTM85vvOd/Cy9rcBwip/zdpc8iI5NWq8D4CnumaEzp
         dLmL3qKZFrkYqTI0kskUtNQJ01w4IZpkNSzEWs3zKS3xt0mnA9jnM8B3d2caYULgUs/z
         U9T8v9ID7bUGDzixSOab7lAZjknJRDO2gY5e7DbqBvRrqg+baK1IemeMTCXHZtDaX53l
         qvtt1rqL8e3hhn5nGbgbIt+qIGXmiZZIiocS0DarQ+G+5wlc5/M8qjAtFHOnqF4XSGJp
         TsbNQblMYpcFynjvXODXE9nDb6xFYMD8dXorunVu2OZ5quoj19IVON9YUtzsqWXaefW+
         cv0w==
X-Gm-Message-State: ANoB5pkv6ER/EvRV1ckFO14qlaLshJzL7jTe+lRZhCgmWNoDmDX283+/
        jsbmzCN9NCOB6Tor6G6KWBYfTr9K4Vbtwxv8Cc7RaSxchrlzPdW82rFZ5MJ/HjbVa0tH5oGhp7/
        P9wbIWO79/TSG
X-Received: by 2002:a05:600c:4fd1:b0:3cf:a08f:10a5 with SMTP id o17-20020a05600c4fd100b003cfa08f10a5mr18931823wmq.31.1671014377156;
        Wed, 14 Dec 2022 02:39:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7FyK2kGQ/X8l+u+weZBL218XKoCFtdJ4Gfht+9/c+XnKO+wcYfwK5VwibQ8vabI7GZZbjJ8Q==
X-Received: by 2002:a05:600c:4fd1:b0:3cf:a08f:10a5 with SMTP id o17-20020a05600c4fd100b003cfa08f10a5mr18931801wmq.31.1671014376882;
        Wed, 14 Dec 2022 02:39:36 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-178-56.web.vodafone.de. [109.43.178.56])
        by smtp.gmail.com with ESMTPSA id l1-20020a5d6681000000b00241c712916fsm3164363wru.0.2022.12.14.02.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Dec 2022 02:39:36 -0800 (PST)
Message-ID: <3283aa30-b43d-88d7-1c89-5ed404e34c37@redhat.com>
Date:   Wed, 14 Dec 2022 11:39:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <8c0777d2-7b70-51ce-e64a-6aff5bdea8ae@redhat.com>
 <60f006f4-d29e-320a-d656-600b2fd4a11a@linux.ibm.com>
 <864cc127-2dbd-3792-8851-937ef4689503@redhat.com>
 <90514038-f10c-33e7-3600-e3131138a44d@linux.ibm.com>
 <73238c6c-a9dc-9d18-8ffb-92c8a41922d3@redhat.com>
 <b36eef2e-92ed-a0ea-0728-4a5ea5bf25d9@de.ibm.com>
 <5f609d94-52c5-7505-6bce-79103aa9a789@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <5f609d94-52c5-7505-6bce-79103aa9a789@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/2022 18.24, Pierre Morel wrote:
> 
> 
> On 12/13/22 14:41, Christian Borntraeger wrote:
>>
>>
>> Am 12.12.22 um 11:17 schrieb Thomas Huth:
>>> On 12/12/2022 11.10, Pierre Morel wrote:
>>>>
>>>>
>>>> On 12/12/22 10:07, Thomas Huth wrote:
>>>>> On 12/12/2022 09.51, Pierre Morel wrote:
>>>>>>
>>>>>>
>>>>>> On 12/9/22 14:32, Thomas Huth wrote:
>>>>>>> On 08/12/2022 10.44, Pierre Morel wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> Implementation discussions
>>>>>>>> ==========================
>>>>>>>>
>>>>>>>> CPU models
>>>>>>>> ----------
>>>>>>>>
>>>>>>>> Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU model
>>>>>>>> for old QEMU we could not activate it as usual from KVM but needed
>>>>>>>> a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>>>>>> Checking and enabling this capability enables
>>>>>>>> S390_FEAT_CONFIGURATION_TOPOLOGY.
>>>>>>>>
>>>>>>>> Migration
>>>>>>>> ---------
>>>>>>>>
>>>>>>>> Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the source
>>>>>>>> host the STFL(11) is provided to the guest.
>>>>>>>> Since the feature is already in the CPU model of older QEMU,
>>>>>>>> a migration from a new QEMU enabling the topology to an old QEMU
>>>>>>>> will keep STFL(11) enabled making the guest get an exception for
>>>>>>>> illegal operation as soon as it uses the PTF instruction.
>>>>>>>
>>>>>>> I now thought that it is not possible to enable "ctop" on older QEMUs 
>>>>>>> since the don't enable the KVM capability? ... or is it still somehow 
>>>>>>> possible? What did I miss?
>>>>>>>
>>>>>>>   Thomas
>>>>>>
>>>>>> Enabling ctop with ctop=on on old QEMU is not possible, this is right.
>>>>>> But, if STFL(11) is enable in the source KVM by a new QEMU, I can see 
>>>>>> that even with -ctop=off the STFL(11) is migrated to the destination.
>>
>> This does not make sense. the cpu model and stfle values are not migrated. 
>> This is re-created during startup depending on the command line parameters 
>> of -cpu.
>> Thats why source and host have the same command lines for -cpu. And 
>> STFLE.11 must not be set on the SOURCE of ctop is off.
> 
> OK, so it is a feature
> 
>>
>>
>>>>>
>>>>> Is this with the "host" CPU model or another one? And did you 
>>>>> explicitly specify "ctop=off" at the command line, or are you just 
>>>>> using the default setting by not specifying it?
>>>>
>>>> With explicit cpumodel and using ctop=off like in
>>>>
>>>> sudo /usr/local/bin/qemu-system-s390x_master \
>>>>       -m 512M \
>>>>       -enable-kvm -smp 4,sockets=4,cores=2,maxcpus=8 \
>>>>       -cpu z14,ctop=off \
>>>>       -machine s390-ccw-virtio-7.2,accel=kvm \
>>>>       ...
>>>
>>> Ok ... that sounds like a bug somewhere in your patches or in the kernel 
>>> code ... the guest should never see STFL bit 11 if ctop=off, should it?
>>
>> Correct. If ctop=off then QEMU should disable STFLE.11 for the CPU model.
> 
> Sorry but not completely correct in the case of migration.
> 
> After a migration if the source host specifies ctop=on and target host 
> specifies ctop=off it does see the STFL bit 11.
>
> The admin should not, but can, specify ctop=off on target if the source set 
> ctop=on. Then the target will start and run in a degraded mode.
> 
> Admin should specify the same flags on both ends, as you said above the STFL 
> bits are not migrated and target QEMU can not verify what the original flags 
> were.
> 
> However, isn't it a bug?
> Is there a reason to not prevent QEMU to start with a wrong cpu model like 
> specifying different flags on both ends or even different cpu?

It's clearly an user error if the two QEMUs are started with different flags 
on the source and destination ends. But it would be great if there was a 
generic way to check for this error condition and bail out early instead of 
doing the migration and let the user run into weird problems later... Does 
anybody have an idea whether there is a good and easy way to implement such 
a check?

  Thomas

