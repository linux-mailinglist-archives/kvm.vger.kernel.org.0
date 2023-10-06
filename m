Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18C47BB01D
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 03:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjJFBkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 21:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjJFBkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 21:40:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA132DE
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 18:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696556382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8wz8kyE+dZb18cqkHb1ZRrmOPbvMpW72hRxdClXtNac=;
        b=fn9Ww1I0LbjO3ul6eWsla1fkL2nG3rZdknript7E0aLYKXmwKzZ/kDV5QdTPX/AFxaZeZY
        /nj2w1nmRBRPpITU+69Lik9n2R5nne8jbyyUD7Yztz7xIsQukFUGiTcNpmk1XVLprvu4L7
        EE1aAOGVRCyMRhBTIUCdXO3tCMdYUwY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-vieuiJopP_GvuJTEU3pjDQ-1; Thu, 05 Oct 2023 21:39:41 -0400
X-MC-Unique: vieuiJopP_GvuJTEU3pjDQ-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-690bbc5fabaso1572742b3a.1
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 18:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696556380; x=1697161180;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8wz8kyE+dZb18cqkHb1ZRrmOPbvMpW72hRxdClXtNac=;
        b=qQUOQvvMB+JMxvcV4Vyd+8L4897+PVv5FeLYFRUuUJbqn/jV9R3W5vG3IdzwFChwXy
         CXCsDSNCnl35UN62BkwXkwRkM6mWElJgBIZn1w0njoQnR1aZ10iBGH61AqstREpzEnfB
         afXovNHxvm+Zfw8RocIroxCvPIcxzIleHBP+ccMq2X69ZiFo40UYcC9u/yPL3OgUmWD2
         2wWCsQKLO0cg1MrlHogjfDgoo8NcD/OQAG74W3Rum4MpJrez1MV7Z9mRyGx3Kg47b6ob
         oXYFeE1sVb//bvCeW4hlC3FLZcG8FfjafiKzf0rai92kyS8rvygq9JOI5pChpaGownfb
         mGUQ==
X-Gm-Message-State: AOJu0YyduxqyzBj3ymutkJ0rUSVMmoKwO+1fVjnUvMTZuvWwHUNaROmb
        ViU0giG8QBEJCOkjjtEQXAV/R7L1ClhdOGliizGj96IX660R3BGA1VNLE86vACNw2SxKhNGyt6h
        Y0TP6B+EUWzo7
X-Received: by 2002:a05:6a20:1455:b0:10f:be0:4dce with SMTP id a21-20020a056a20145500b0010f0be04dcemr8321706pzi.8.1696556380226;
        Thu, 05 Oct 2023 18:39:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEA7151Q6nRzeKdZh2rrFpLyYJxoDegYR3wOdaUSEEbvgikqYlYmQ9MTmsmlNBDRgM5eTii5Q==
X-Received: by 2002:a05:6a20:1455:b0:10f:be0:4dce with SMTP id a21-20020a056a20145500b0010f0be04dcemr8321687pzi.8.1696556379918;
        Thu, 05 Oct 2023 18:39:39 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:b890:3e54:96bb:2a15? ([2001:8003:e5b0:9f00:b890:3e54:96bb:2a15])
        by smtp.gmail.com with ESMTPSA id c26-20020aa781da000000b0068be3489b0dsm243540pfn.172.2023.10.05.18.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Oct 2023 18:39:39 -0700 (PDT)
Message-ID: <131babfc-3450-68bd-f35b-d126a36acb0c@redhat.com>
Date:   Fri, 6 Oct 2023 11:39:34 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: Bug? Incompatible APF for 4.14 guest on 5.10 and later host
Content-Language: en-US
To:     "Mancini, Riccardo" <mancio@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Teragni, Matias" <mteragni@amazon.com>,
        "Batalov, Eugene" <bataloe@amazon.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
References: <1a68941c7abc4968a1e98627743256f3@amazon.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <1a68941c7abc4968a1e98627743256f3@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/6/23 03:24, Mancini, Riccardo wrote:
>> From: Paolo Bonzini <pbonzini@redhat.com>
>> Sent: 05 October 2023 17:15

[...]

>> I do have a question for you.  Can you describe the context in which you
>> are using APF, and would you be interested in ARM support?  We (Red Hat,
>> not me the maintainer :)) have been trying to understand for a long time
>> if cloud providers use or need APF.
> 
> Keeping it short, we resume "remote" VM snapshots so page faults might
> be very expensive on local cache misses. We have a few optimizations to work
> around some of the issues, but even on local hits there are still a lot
> of expensive page faults compared to a normal VM use-case, I believe.
> To be fair, I didn't even realise the benefits we were getting from APF
> until it actually broke :)
> It indeed plays a big role in keeping the resumption quick and efficient
> in our use-case.
> I didn't know that it wasn't available for ARM, as we don't use it at
> the moment, but that would be interesting for the future.
> 

Adding Marc, Oliver and kvmarm@lists.linux.dev

I tried to make the feature available to ARM64 long time ago, but the efforts
were discontinued as the significant concern was no users demanding for it [1].
It's definitely exciting news to know it's a important feature to AWS. I guess
it's probably another chance to re-evaluate the feature for ARM64?

[1] https://lore.kernel.org/kvmarm/87iloq2oke.wl-maz@kernel.org/

Async PF needs two signals sent from host to guest, SDEI (Software Delegated
Exception Interface) is leveraged for that. So there were two series to support
SDEI virtualization [1] and Async PF on ARM64 [2].

[1] https://lore.kernel.org/kvmarm/20220527080253.1562538-1-gshan@redhat.com/
[2] https://lore.kernel.org/kvmarm/20210815005947.83699-1-gshan@redhat.com/

I got several questions for Mancini to answer, helpful understand the situation
better.

- VM shapshot is stored somewhere remotely. It means the page fault on
   instruction fetch becomes expensive. Do we have benchmarks how much
   benefits brought by Async PF on x86 in AWS environment?

- I'm wandering if the data can be fetched from somewhere remotely in AWS
   environment?

- The data can be stored in local DRAM or swapping space, the page fault
   to fetch data becomes expensive if the data is stored in swapping space.
   I'm not sure if it's possible the data resides in the swapping space in
   AWS environment? Note that the swapping space, corresponding to disk,
   could be somewhere remotely seated.

Thanks,
Gavin


