Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECE74E1ABB
	for <lists+kvm@lfdr.de>; Sun, 20 Mar 2022 09:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242705AbiCTILq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 04:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240809AbiCTILp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 04:11:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0475E3CA6C
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 01:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647763821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VIVfEVjg2/Uysu5XJww27HboQwkxzQuGka2JuAsuzE4=;
        b=KyphZvgtTvcOcMyZKhlHdAHV4osLvptOjFOIWDvK0Q8XMnRFTKlp0mgjgR9Mt4MOJPdWBT
        YimerYsD7F36r/+eA7E5032v13I4KNq3Ttl0oQw8pFwkCS1uzFD/QukR3H0xTf+BJkFErx
        oUI7ZmsiEDoiSar8E80fxrCI4o0dPCs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-0aX1FeLMNDeX4pDFf6XpmA-1; Sun, 20 Mar 2022 04:10:20 -0400
X-MC-Unique: 0aX1FeLMNDeX4pDFf6XpmA-1
Received: by mail-ed1-f72.google.com with SMTP id b24-20020a50e798000000b0041631767675so7210640edn.23
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 01:10:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VIVfEVjg2/Uysu5XJww27HboQwkxzQuGka2JuAsuzE4=;
        b=TQD1YVdmw1KEst22BaiVMk9GmpijjtS6/8b7erGZdC7MXHPiedv0mIq6enCn1Aw1AF
         qKNIuNTBxHtQpu8DdklFjjRWkiyoBGMZzG4ufa+UFHyj1LIxd3hKRojNCoOo/2eHDFBy
         zXNKcA1XnuPvZDVX8sXJDwMn2DlsoUpdmLnnwwU6/dze2s55yfug73oOeo6KW4RBaE7/
         9M6W1kgXs1KMfq/dCBTnBW7RWemymBaV+ZWIdIgVCo8w8lGvyzby9R79m5Tk+8eNOrpX
         gJLba4AMdIFW2M0DEM9fRtaqTM9tjqLDA9q56c74OmT/H8trcii8dAj/SrRhkIbbAB0c
         5m3Q==
X-Gm-Message-State: AOAM531RVFa+QPkG40/cHQtjOelQu0oDCZn8lEEtB2lZG8HMlTuAZSKL
        aKe4FAyOthKhs3S4EJhkcFq9b0C5B9kkrUOs3u3FMvORUvfv4tkHdhCirfBad8sAHiA2fnnW3fH
        UR0qGo1ThR6EZ
X-Received: by 2002:a17:907:8a09:b0:6df:f1c6:bfc4 with SMTP id sc9-20020a1709078a0900b006dff1c6bfc4mr3178413ejc.550.1647763818329;
        Sun, 20 Mar 2022 01:10:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxqYdkb3jmjvZY9BtYGiM/uEXQ4qOEbASprapLrpAEOrg6eokVvGEUBXddj8XpAPpbFZuAqw==
X-Received: by 2002:a17:907:8a09:b0:6df:f1c6:bfc4 with SMTP id sc9-20020a1709078a0900b006dff1c6bfc4mr3178397ejc.550.1647763818043;
        Sun, 20 Mar 2022 01:10:18 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id nc13-20020a1709071c0d00b006dfa376ee55sm3686948ejc.131.2022.03.20.01.10.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Mar 2022 01:10:17 -0700 (PDT)
Message-ID: <9ca10e3a-cd99-714a-76ad-6f1b83bb0abf@redhat.com>
Date:   Sun, 20 Mar 2022 09:10:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20220316045308.2313184-1-oupton@google.com>
 <34ccef81-fe54-a3fc-0ba9-06189b2c1d33@redhat.com>
 <YjTRyssYQhbxeNHA@google.com>
 <0bff64ae-0420-2f69-10ba-78b9c5ac7b81@redhat.com>
 <YjWNfQThS4URRMZC@google.com>
 <e48bc11a5c4b0864616686cb1365dfb4c11b5b61.camel@infradead.org>
 <a6011bed-79b4-72ab-843c-315bf3fcf51e@redhat.com>
 <3548e754-28ae-f6c4-5d4c-c316ae6fbbb0@redhat.com>
 <100b54469a8d59976bbd96f50dd4cd33.squirrel@twosheds.infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <100b54469a8d59976bbd96f50dd4cd33.squirrel@twosheds.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/19/22 14:13, David Woodhouse wrote:
> 
> 
>> On 3/19/22 12:54, Paolo Bonzini wrote:
>>> On 3/19/22 09:08, David Woodhouse wrote:
>>>> If a basic API requires this much documentation, my instinct is to
>>>> *fix* it with fire first, then document what's left.
>>> I agree, but you're missing all the improvements that went in together
>>> with the offset API in order to enable the ugly algorithm.
>>>
>>>> A userspace-friendly API for migration would be more like KVM on the
>>>> source host giving me { TIME_OF_DAY, TSC } and then all I have to do on
>>>> the destination host (after providing the TSC frequency) is give it
>>>> precisely the same data.
>>
>> I guess you meant {hostTimeOfDay, hostTSC} _plus_ the constant
>> {guestTSCScale, guestTSCOffset, guestTimeOfDayOffset}.  That would work,
>> and in that case it wouldn't even be KVM returning that host information.
> 
> I would have said nobody cares about the host TSC value and frequency.
> That is for KVM to know and deal with internally.

There are two schools as to how to do migration.  The QEMU school is to 
just load back the guest TOD and TSC and let NTP resync.  They had 
better be synced, but a difference of a few microseconds might not matter.

This has the advantage of not showing the guest that there was a pause. 
  QEMU is doing it this way due to not having postcopy live migration 
for a long time; precopy is subject to longer brownout between source 
and destination, which might result in soft lockups.  Apart from this it 
really has only disadvantage.

The Google school has the destination come up with the guest TOD and TSC 
that takes into account the length of the brownout phase.  This is where 
the algorithm in Documentation/ comes into play, and why you need the 
host pair as well.  Actually Google does not use it because they already 
have precise time available to userspace as part of Spanner.  Maybe so 
does Amazon (?), but for the rest of the world the host {TOD, TSC} pair 
is required to compute what the guest TSC "should look like" on the 
destination.

Paolo

> For guest migration it should be as simple as "guest TSC frequency is <F>,
> and the TSC value was <X> at (wallclock time <T>|KVM_CLOCK time <T>).
> 
> Not sure I have an opinion on whether the objective time reference is the
> timeofday clock or the KVM clock.
> 
> 

