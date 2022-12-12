Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C87D649AB3
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 10:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiLLJIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 04:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbiLLJI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 04:08:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5E9B495
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 01:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670836045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0sBPYy4SSrrjZw+jrVOMWp6jQwmm3JH0xQisWa/AP0s=;
        b=dfAH3TBhK0CxzGSanTk1/Xo3Q36gi01Fq/BCmHglSqepgheb12TjI//YR5RLbLi0baLVGT
        2bahcFZsC66k21h0IwvsoyE4srhw0I3N3qEYa9c7/fKK0evub/aIlSDyH9RcPw6JyjmM82
        NbZ94JU6Y5ehANAq0fZmZoJHkPU7qbU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-159-Te_1a-p2NCqfBkWoC7d-Xg-1; Mon, 12 Dec 2022 04:07:24 -0500
X-MC-Unique: Te_1a-p2NCqfBkWoC7d-Xg-1
Received: by mail-wr1-f72.google.com with SMTP id r6-20020adfbb06000000b002455227c5c5so2031225wrg.20
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 01:07:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0sBPYy4SSrrjZw+jrVOMWp6jQwmm3JH0xQisWa/AP0s=;
        b=BBbxYvP13JyiMbbKLrWMCtQ8nUqruncKQWnHMMRJfBq8lbcRGcliO9Aq8NQsiiFP/Y
         hTrw2nIG0wPpjx5jdYYrzEQky9b3yPgZ8xzQJz1zks4X49IcnB0GTcSXjQK9HESxVAgZ
         SnqR2sgBzxjupTgf+c4XX1bhFmuLng2B7D477tH5fiR/tG6U3GDZdsTplKWBVxdmaUDO
         FttUK/ZZJmAxlvlB/fzdVEnVqpaXbSgBXOV5W/6mYuq+fEIfvnwnfqe0eLVfoGXb7RWH
         A9SsNIT24VO5rOWSN6ujZC8cvni931YSaIyOJCjCXjpYQD14OOIrmXatv6zuhTyB74SS
         tdqg==
X-Gm-Message-State: ANoB5pn8VVxEe3R3sagrhqmoPCk1JuWY2jiHN8JxJ95uVGksZ5LdRtbX
        ZchGJHKblgFiYOE4XRnK0mW5q4dPPV7uBVcXJaSdoUBKDEpWlV3XqKalJMGg2Mjci4QioekL0aF
        sYVxPiYHRVWrT
X-Received: by 2002:a1c:6a17:0:b0:3cf:7031:bdcc with SMTP id f23-20020a1c6a17000000b003cf7031bdccmr11708023wmc.11.1670836042938;
        Mon, 12 Dec 2022 01:07:22 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7sxv4VwcGxfQEfikpi6mNn4cuetCJzNaAH/YbFwkvO1oDoL/87hj0D7aTF883KxWU5Rv1LFQ==
X-Received: by 2002:a1c:6a17:0:b0:3cf:7031:bdcc with SMTP id f23-20020a1c6a17000000b003cf7031bdccmr11708010wmc.11.1670836042743;
        Mon, 12 Dec 2022 01:07:22 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-178-127.web.vodafone.de. [109.43.178.127])
        by smtp.gmail.com with ESMTPSA id f9-20020a05600c154900b003d2157627a8sm9127452wmg.47.2022.12.12.01.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 01:07:22 -0800 (PST)
Message-ID: <864cc127-2dbd-3792-8851-937ef4689503@redhat.com>
Date:   Mon, 12 Dec 2022 10:07:20 +0100
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
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <60f006f4-d29e-320a-d656-600b2fd4a11a@linux.ibm.com>
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

On 12/12/2022 09.51, Pierre Morel wrote:
> 
> 
> On 12/9/22 14:32, Thomas Huth wrote:
>> On 08/12/2022 10.44, Pierre Morel wrote:
>>> Hi,
>>>
>>> Implementation discussions
>>> ==========================
>>>
>>> CPU models
>>> ----------
>>>
>>> Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU model
>>> for old QEMU we could not activate it as usual from KVM but needed
>>> a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>> Checking and enabling this capability enables
>>> S390_FEAT_CONFIGURATION_TOPOLOGY.
>>>
>>> Migration
>>> ---------
>>>
>>> Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the source
>>> host the STFL(11) is provided to the guest.
>>> Since the feature is already in the CPU model of older QEMU,
>>> a migration from a new QEMU enabling the topology to an old QEMU
>>> will keep STFL(11) enabled making the guest get an exception for
>>> illegal operation as soon as it uses the PTF instruction.
>>
>> I now thought that it is not possible to enable "ctop" on older QEMUs 
>> since the don't enable the KVM capability? ... or is it still somehow 
>> possible? What did I miss?
>>
>>   Thomas
> 
> Enabling ctop with ctop=on on old QEMU is not possible, this is right.
> But, if STFL(11) is enable in the source KVM by a new QEMU, I can see that 
> even with -ctop=off the STFL(11) is migrated to the destination.

Is this with the "host" CPU model or another one? And did you explicitly 
specify "ctop=off" at the command line, or are you just using the default 
setting by not specifying it?

  Thomas

