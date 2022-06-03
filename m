Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1352053CA8A
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 15:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244574AbiFCNSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 09:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240900AbiFCNSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 09:18:12 -0400
Received: from smarthost1.sentex.ca (smarthost1.sentex.ca [IPv6:2607:f3e0:0:1::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3D913F7C
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 06:18:10 -0700 (PDT)
Received: from pyroxene2a.sentex.ca (pyroxene19.sentex.ca [199.212.134.19])
        by smarthost1.sentex.ca (8.16.1/8.16.1) with ESMTPS id 253DI6Iw017522
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 3 Jun 2022 09:18:07 -0400 (EDT)
        (envelope-from mike@sentex.net)
Received: from [IPV6:2607:f3e0:0:4:f415:e14:2b55:3cca] ([IPv6:2607:f3e0:0:4:f415:e14:2b55:3cca])
        by pyroxene2a.sentex.ca (8.16.1/8.15.2) with ESMTPS id 253DI64J011942
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 3 Jun 2022 09:18:06 -0400 (EDT)
        (envelope-from mike@sentex.net)
Message-ID: <ce81de90-3dd1-1e8a-6a8f-b1c18310cb08@sentex.net>
Date:   Fri, 3 Jun 2022 09:18:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Guest migration between different Ryzen CPU generations
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Leonardo Bras <leobras@redhat.com>
References: <48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net>
 <20220602144200.1228b7bb@redhat.com>
 <489ddcdf-e38f-ea51-6f90-8c17358da61d@sentex.net>
 <Ypkvu6l5sxyuP6iM@google.com>
From:   mike tancsa <mike@sentex.net>
In-Reply-To: <Ypkvu6l5sxyuP6iM@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 64.7.153.18
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/2022 5:46 PM, Sean Christopherson wrote:
> On Thu, Jun 02, 2022, mike tancsa wrote:
>> On 6/2/2022 8:42 AM, Igor Mammedov wrote:
>>> On Tue, 31 May 2022 13:00:07 -0400
>>> mike tancsa <mike@sentex.net> wrote:
>>>
>>>> Hello,
>>>>
>>>>        I have been using kvm since the Ubuntu 18 and 20.x LTS series of
>>>> kernels and distributions without any issues on a whole range of Guests
>>>> up until now. Recently, we spun up an Ubuntu LTS 22 hypervisor to add to
>>>> the mix and eventually upgrade to. Hardware is a series of Ryzen 7 CPUs
>>>> (3700x).  Migrations back and forth without issue for Ubuntu 20.x
>>>> kernels.  The first Ubuntu 22 machine was on identical hardware and all
>>>> was good with that too. The second Ubuntu 22 based machine was spun up
>>>> with a newer gen Ryzen, a 5800x.  On the initial kernel version that
>>>> came with that release back in April, migrations worked as expected
>>>> between hardware as well as different kernel versions and qemu / KVM
>>>> versions that come default with the distribution. Not sure if migrations
>>>> between kernel and KVM versions "accidentally" worked all these years,
>>>> but they did.  However, we ran into an issue with the kernel
>>>> 5.15.0-33-generic (possibly with 5.15.0-30 as well) thats part of
>>>> Ubuntu.  Migrations no longer worked to older generation CPUs.  I could
>>>> send a guest TO the box and all was fine, but upon sending the guest to
>>>> another hypervisor, the sender would see it as successfully migrated,
>>>> but the VM would typically just hang, with 100% CPU utilization, or
>>>> sometimes crash.  I tried a 5.18 kernel from May 22nd and again the
>>>> behavior is different. If I specify the CPU as EPYC or EPYC-IBPB, I can
>>>> migrate back and forth.
>>> perhaps you are hitting issue fixed by:
>>> https://lore.kernel.org/lkml/CAJ6HWG66HZ7raAa+YK0UOGLF+4O3JnzbZ+a-0j8GNixOhLk9dA@mail.gmail.com/T/
>>>
>> Thanks for the response. I am not sure.
> I suspect Igor is right.  PKRU/PKU, the offending XSAVE feature in that bug, is
> in the "new in 5800" list below, and that bug fix went into v5.17, i.e. should
> also be fixed in v5.18.
>
> Unfortunately, there's no Fixes: provided and I'm having a hell of a time trying
> to figure out when the bug was actually introduced.  The v5.15 code base is quite
> different due to a rather massive FPU rework in v5.16.  That fix definitely would
> not apply cleanly, but it doesn't mean that the underlying root cause is different,
> e.g. the buggy code could easily have been lurking for multiple kernel versions
> before the rework in v5.16.
>> That patch is from Feb. Would the bug have been introduced sometime in May to
>> the 5.15 kernel than Ubuntu 22 would have tracked ?
> Dates don't necessarily mean a whole lot when it comes to stable kernels, e.g.
> it's not uncommon for a change to be backported to a stable kernel weeks/months
> after it initially landed in the upstream tree.
>
> Is moving to v5.17 or later an option for you?  If not, what was the "original"
> Ubuntu 22 kernel version that worked?  Ideally, assuming it's the same FPU/PKU bug,
> the fix would be backported to v5.15, but that's likely going to be quite difficult,
> especially without knowing exactly which commit introduced the bug.

Thanks Sean, I can, but it just means adjusting our work flow a bit. For 
our hypervisors we like to just track LTS and be conservative in what 
software we install and stick with apps and kernels designed 
specifically to work with that release / distribution. The Ubuntu 22 
kernel that worked back in April was 5.15.0-25-generic.  TBH, if I am 
told we were just lucky things worked with different hardware and 
different kernels and KVM versions (ie. migrating bidirectionally from 
ubuntu 20.x to 22.x) I would be fine with that too.  But I was a little 
surprised that a kernel version bump from 5.15 would break what was working.

     ---Mike

