Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2082D6A445B
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 15:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjB0O2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 09:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjB0O2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 09:28:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8FF17CD9
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 06:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677508040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XpUVmUxP9Hjlacn8N0Dmk25mmERAn/Ff687O+zJOal0=;
        b=GrKOqVMwByoukj+OqhMRMI7WwZVcUQbTnu1+i7/AjGNKw/mMvSnqY1q2SVp6Zunb7vwxgq
        lP4oP5vy96h19N1wgXZjfBhggBNvZKLqMSE84ci7zeeOYkLvLE2qxvEDiv8rWmcfjIxCFx
        q6pS9m4Ak23mVl3rPbgLsvPiRUt3eig=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-9nWmxfo6Nt6ZxEzoBZfvCg-1; Mon, 27 Feb 2023 09:27:19 -0500
X-MC-Unique: 9nWmxfo6Nt6ZxEzoBZfvCg-1
Received: by mail-wr1-f71.google.com with SMTP id o15-20020a05600002cf00b002c54a27803cso900543wry.22
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 06:27:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XpUVmUxP9Hjlacn8N0Dmk25mmERAn/Ff687O+zJOal0=;
        b=LU5RsSZvnc6uN3rb6iMOtYwTNbWbRXXG4vo/tvLBu+4+E1WqWJ64xNbtLE/i7NrZoP
         X0tGCBXyzx8uEEUukoaKMUbl+gnnaIeOZedPo23n2JiRg3zHYfxKfzCzrqS/ICP/OZvc
         RwjgCBghuQpCtbBL6lD8cuCXCpcRysEDE0+cVMcSqmQDWJdMOxtq7qNy13yx+x565VwJ
         o6FtL5lvROKVkhhhhZ/I5xc6UaeTTWFEuuPHeVV7tMqSZyJHZ9dUNdGX6GmMjHX62h93
         O/JvQMLG5i8KqR/CXfS+5JL3PqSt/qNGcLrOZ7i+KqY8ks+YcxQjxvtmwZT3fvKYSnoc
         5vrQ==
X-Gm-Message-State: AO0yUKXD2Y/tmO5HRwxIZW09mJtCWxiK4K5y5NVtKfZ4AarSf9sfCn7F
        Fg09gIxG+buBztl2m0cQCzAfY9xkw5MYM3Dlhmu+PvF0XBTGqP96eji+RWQ8HkVqlhMnQCYoRgc
        imIIIPb2sSF9O
X-Received: by 2002:a05:600c:70a:b0:3df:eecc:de2b with SMTP id i10-20020a05600c070a00b003dfeeccde2bmr15835620wmn.11.1677508036867;
        Mon, 27 Feb 2023 06:27:16 -0800 (PST)
X-Google-Smtp-Source: AK7set+kx3pf+OK3eqMXfBQR/57KFFHAJgwXKARMS0xFg1AD+XyBsMvWXMiu92JMAfWbirYJv2HFnQ==
X-Received: by 2002:a05:600c:70a:b0:3df:eecc:de2b with SMTP id i10-20020a05600c070a00b003dfeeccde2bmr15835590wmn.11.1677508036615;
        Mon, 27 Feb 2023 06:27:16 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-150.web.vodafone.de. [109.43.176.150])
        by smtp.gmail.com with ESMTPSA id u17-20020adff891000000b002c553e061fdsm7185802wrp.112.2023.02.27.06.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 06:27:16 -0800 (PST)
Message-ID: <365c5bca-eda6-52dd-a90c-12de397bedf6@redhat.com>
Date:   Mon, 27 Feb 2023 15:27:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v16 11/11] docs/s390x/cpu topology: document s390x cpu
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
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-12-pmorel@linux.ibm.com>
 <039b5a0f-4440-324c-d5a7-54e9e1c89ea8@redhat.com>
 <dcac1561-8c91-310c-7e9f-db9fff3b00a7@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <dcac1561-8c91-310c-7e9f-db9fff3b00a7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/02/2023 15.17, Pierre Morel wrote:
> 
> On 2/27/23 14:58, Thomas Huth wrote:
>> On 22/02/2023 15.21, Pierre Morel wrote:
>>> Add some basic examples for the definition of cpu topology
>>> in s390x.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   docs/system/s390x/cpu-topology.rst | 378 +++++++++++++++++++++++++++++
>>>   docs/system/target-s390x.rst       |   1 +
>>>   2 files changed, 379 insertions(+)
>>>   create mode 100644 docs/system/s390x/cpu-topology.rst
>>>
>>> diff --git a/docs/system/s390x/cpu-topology.rst 
>>> b/docs/system/s390x/cpu-topology.rst
>>> new file mode 100644
>>> index 0000000000..d470e28b97
>>> --- /dev/null
>>> +++ b/docs/system/s390x/cpu-topology.rst
>>> @@ -0,0 +1,378 @@
>>> +CPU topology on s390x
>>> +=====================
>>> +
>>> +Since QEMU 8.0, CPU topology on s390x provides up to 3 levels of
>>> +topology containers: drawers, books, sockets, defining a tree shaped
>>> +hierarchy.
>>> +
>>> +The socket container contains one or more CPU entries consisting
>>> +of a bitmap of three dentical CPU attributes:
>>
>> What do you mean by "dentical" here?
> 
> :D i.. dentical
> 
> I change it to identical

Ok, but even with "i" at the beginning, it does not make too much sense here 
to me - I'd interpret "identical" as "same", but these attributes have 
clearly different meanings, haven't they?

  Thomas

