Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD60649BE7
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 11:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiLLKSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 05:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiLLKSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 05:18:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18E22C8
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 02:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670840247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LrxYoLraYK/YnEM/Z68AAgqMtIkOYtXcUgkaMfC5LZw=;
        b=bWhnK7V/opi/8L4iziUMfVhveRfIfQSBWLEVZ8ySJMjV8L6hGkQrqFwIUw/Kza3DCeS9qJ
        gU1IsOf6RdN9YJ/jb9OGtiijt2hM0bg0bVqwQnJQfven5U7RFfkj190j1pQCpAOW2/sjhk
        SPrnw8d+FgQ+yeGiDxiID5TwB96lCfc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-610-x5M9gwn2MKyhK9oL2QzS0w-1; Mon, 12 Dec 2022 05:17:25 -0500
X-MC-Unique: x5M9gwn2MKyhK9oL2QzS0w-1
Received: by mail-wm1-f70.google.com with SMTP id f20-20020a7bc8d4000000b003d1cda5bd6fso1823349wml.9
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 02:17:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LrxYoLraYK/YnEM/Z68AAgqMtIkOYtXcUgkaMfC5LZw=;
        b=TJzrorktrtGwLs7y0ZOTyhVMzbqmfyCErQPuvVwdp/k5/wlYTGDPobUhxa1iIz/gxx
         r4MRSlRd2NuILmmAofzS2QmGQ/4LP7IxfD2D0Fcl8MWWtc9AzhVHRh/ouuRkQsNwB6eg
         2qg0Whi8ymbTK9nh0CR7q97yP66y7VVReqLq9blWGBVQfkoTM+b6kotLlUdlOCdNC78g
         sHd4/qeKbZP0wn/S6pL88S4BrB2eZQuuaiXUD9FUEjp4luE71/Y+2CJzbPpKjqvJPooW
         65DCLBdaEoOrR6Zt0r3iZCO60LbN7vXnv3yJuVl+5+aSqg3EdecEmefTVa/Tjn6LJN8E
         pAhg==
X-Gm-Message-State: ANoB5pnhQYzi+ijiNAoZsPgxgk0At3DuppNe3g3yZuBPEZbuZCl/GF7s
        AKdIqn/0Uk8GNey5DLMWBg8kG55swonUicC21uWuXgJE9HeBbSMHS6IRTeZmGyE7jnX8KkEOBmr
        ugtoFtnAOYxHa
X-Received: by 2002:a05:600c:3508:b0:3c6:e63e:23e9 with SMTP id h8-20020a05600c350800b003c6e63e23e9mr12012724wmq.24.1670840244788;
        Mon, 12 Dec 2022 02:17:24 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5tk+LjUbeujog/OZs+XMZEmEYAQ5x4z4kHABRLnPsXuqlCNBDUdstG3KHTxzUz67a1M6fWRw==
X-Received: by 2002:a05:600c:3508:b0:3c6:e63e:23e9 with SMTP id h8-20020a05600c350800b003c6e63e23e9mr12012714wmq.24.1670840244580;
        Mon, 12 Dec 2022 02:17:24 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-178-127.web.vodafone.de. [109.43.178.127])
        by smtp.gmail.com with ESMTPSA id k22-20020a7bc416000000b003c5571c27a1sm10223308wmi.32.2022.12.12.02.17.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 02:17:23 -0800 (PST)
Message-ID: <73238c6c-a9dc-9d18-8ffb-92c8a41922d3@redhat.com>
Date:   Mon, 12 Dec 2022 11:17:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
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
 <8c0777d2-7b70-51ce-e64a-6aff5bdea8ae@redhat.com>
 <60f006f4-d29e-320a-d656-600b2fd4a11a@linux.ibm.com>
 <864cc127-2dbd-3792-8851-937ef4689503@redhat.com>
 <90514038-f10c-33e7-3600-e3131138a44d@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <90514038-f10c-33e7-3600-e3131138a44d@linux.ibm.com>
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

On 12/12/2022 11.10, Pierre Morel wrote:
> 
> 
> On 12/12/22 10:07, Thomas Huth wrote:
>> On 12/12/2022 09.51, Pierre Morel wrote:
>>>
>>>
>>> On 12/9/22 14:32, Thomas Huth wrote:
>>>> On 08/12/2022 10.44, Pierre Morel wrote:
>>>>> Hi,
>>>>>
>>>>> Implementation discussions
>>>>> ==========================
>>>>>
>>>>> CPU models
>>>>> ----------
>>>>>
>>>>> Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU model
>>>>> for old QEMU we could not activate it as usual from KVM but needed
>>>>> a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>>> Checking and enabling this capability enables
>>>>> S390_FEAT_CONFIGURATION_TOPOLOGY.
>>>>>
>>>>> Migration
>>>>> ---------
>>>>>
>>>>> Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the source
>>>>> host the STFL(11) is provided to the guest.
>>>>> Since the feature is already in the CPU model of older QEMU,
>>>>> a migration from a new QEMU enabling the topology to an old QEMU
>>>>> will keep STFL(11) enabled making the guest get an exception for
>>>>> illegal operation as soon as it uses the PTF instruction.
>>>>
>>>> I now thought that it is not possible to enable "ctop" on older QEMUs 
>>>> since the don't enable the KVM capability? ... or is it still somehow 
>>>> possible? What did I miss?
>>>>
>>>>   Thomas
>>>
>>> Enabling ctop with ctop=on on old QEMU is not possible, this is right.
>>> But, if STFL(11) is enable in the source KVM by a new QEMU, I can see 
>>> that even with -ctop=off the STFL(11) is migrated to the destination.
>>
>> Is this with the "host" CPU model or another one? And did you explicitly 
>> specify "ctop=off" at the command line, or are you just using the default 
>> setting by not specifying it?
> 
> With explicit cpumodel and using ctop=off like in
> 
> sudo /usr/local/bin/qemu-system-s390x_master \
>       -m 512M \
>       -enable-kvm -smp 4,sockets=4,cores=2,maxcpus=8 \
>       -cpu z14,ctop=off \
>       -machine s390-ccw-virtio-7.2,accel=kvm \
>       ...

Ok ... that sounds like a bug somewhere in your patches or in the kernel 
code ... the guest should never see STFL bit 11 if ctop=off, should it?

  Thomas

