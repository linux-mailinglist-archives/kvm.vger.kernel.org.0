Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC793B76AC
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 18:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhF2QwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 12:52:10 -0400
Received: from foss.arm.com ([217.140.110.172]:54286 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232441AbhF2QwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Jun 2021 12:52:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1764BD6E;
        Tue, 29 Jun 2021 09:49:42 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B8573F694;
        Tue, 29 Jun 2021 09:49:40 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 0/3] Add support for external tests and
 litmus7 documentation
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        Jade Alglave <Jade.Alglave@arm.com>,
        maranget <luc.maranget@inria.fr>
References: <20210324171402.371744-1-nikos.nikoleris@arm.com>
 <aaabf2d9-ecea-8665-f43b-d3382963ff5a@arm.com>
 <20210414084216.khko7c7tk2tnu6bw@kamzik.brq.redhat.com>
 <d28b8ee3-6957-a987-10da-727110343b8e@arm.com>
 <20210629161346.txzpeyqq2r2uaqyy@gator>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <3d5e3769-a48b-03b8-a97b-3b2e533e676c@arm.com>
Date:   Tue, 29 Jun 2021 19:49:37 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210629161346.txzpeyqq2r2uaqyy@gator>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 29/06/2021 19:13, Andrew Jones wrote:
> On Tue, Jun 29, 2021 at 04:32:36PM +0300, Nikos Nikoleris wrote:
>> Hi all,
>>
>> On 14/04/2021 11:42, Andrew Jones wrote:
>>> On Tue, Apr 13, 2021 at 05:52:37PM +0100, Nikos Nikoleris wrote:
>>>> On 24/03/2021 17:13, Nikos Nikoleris wrote:
>>>>> This set of patches makes small changes to the build system to allow
>>>>> easy integration of tests not included in the repository. To this end,
>>>>> it adds a parameter to the configuration script `--ext-dir=DIR` which
>>>>> will instruct the build system to include the Makefile in
>>>>> DIR/Makefile. The external Makefile can then add extra tests,
>>>>> link object files and modify/extend flags.
>>>>>
>>>>> In addition, to demonstrate how we can use this functionality, a
>>>>> README file explains how to use litmus7 to generate the C code for
>>>>> litmus tests and link with kvm-unit-tests to produce flat files.
>>>>>
>>>>> Note that currently, litmus7 produces its own independent Makefile as
>>>>> an intermediate step. Once this set of changes is committed, litmus7
>>>>> will be modifed to make use hook to specify external tests and
>>>>> leverage the build system to build the external tests
>>>>> (https://github.com/relokin/herdtools7/commit/8f23eb39d25931c2c34f4effa096df58547a3bb4).
>>>>>
>>>>
>>>> Just wanted to add that if anyone's interested in trying out this series
>>>> with litmus7 I am very happy to help. Any feedback on this series or the way
>>>> we use kvm-unit-tests would be very welcome!
>>>
>>> Hi Nikos,
>>>
>>> It's on my TODO to play with this. I just haven't had a chance yet. I'm
>>> particularly slow right now because I'm in the process of handling a
>>> switch of my email server from one type to another, requiring rewrites
>>> of filters, new mail synchronization methods, and, in general, lots of
>>> pain... Hopefully by the end of this week all will be done. Then, I can
>>> start ignoring emails on purpose again, instead of due to the fact that
>>> I can't find them :-)
>>>
>>> Thanks,
>>> drew
>>>
>>
>> Just wanted to revive the discussion on this. In particular there are two
>> fairly small changes to the build system that allow us to add external tests
>> (in our case, generated using litmus7) to the list of tests we build. This
>> is specific to arm builds but I am happy to look into generalizing it to
>> include all archs.
>>
> 
> Hi Nikos,
> 

Hi Drew,

Thanks for having a look!

> I just spent a few minutes playing around with litmus7. I see the
> litmus/libdir/kvm-*.cfg files in herdtools7[1] are very kvm-unit-tests
> specific. They appear to absorb much of the kvm-unit-tests Makefile
> paths, flags, cross compiler prefixes, etc. Are these .cfg files the
> only kvm-unit-tests specific files in herdtools7?
> 

Indeed these kvm-*.cfg files redefine much of the same variables we have 
in kvm-unit-tests make files. litmus7 uses these cfg files (and 
litmus/libdir/_aarch64/kvm.rules for the rules) to generate a standalone 
Makefile. When we call make, we compile the generated sources and link 
with kvm-unit-tests object files. The generated Makefile redefines much 
of the build system in kvm-unit-tests which is not great. If we make any 
change to the build system in kvm-unit-tests (e.g., add support for efi) 
we have to port this change to the standalone Makefile we generate using 
litmus7.

> Here's a half-baked proposal that I'd like your input on:
> 
>   1) Generate the kvm-unit-tests specific .cfg files in kvm-unit-tests when
>      configured with a new --litmus7 configure switch. This will ensure
>      that the paths, flags, etc. will be up to date in the .cfg file.

This wouldn't be enough we would also need some sort of minimal Makefile 
too (something like litmus/libdir/_aarch64/kvm.rules).

>   2) Add kvm-unit-tests as a git submodule to [1] to get access to the
>      generated .cfg files and to build the litmus tests for kvm-unit-tests.
>      A litmus7 command will invoke the kvm-unit-tests build (using
>      make -C).

That's possible but it doesn't solve the biggest problem which is 
figuring out what is the command(s) we need to run to link an elf and 
subsequently generate a flat file.

>   3) Create an additional unittests.cfg file (e.g. litmus7-tests.cfg) for
>      kvm-unit-tests that allows easily running all the litmus7 tests.
>      (That should also allow 'make standalone' to work for litmus7 tests.)

This is a good point I can have a look at how we could add this.

>   4) Like patch 3/3 already does, document the litmus7 stuff in
>      kvm-unit-tests, so people understand the purpose of the --litmus7
>      configure switch and also to inform them of the ability to run
>      additional tests and how (by using [1]).
> 

Overall it would be great if we could piggyback on the build system of 
kvm-unit-tests rather than try to re-generate (part of) it. This is what 
the patch 2/3 tries to do. This is not solving the problem in a way that 
is specific to litmus7 and allows for adding more source files to the 
all-tests list.

If 2/3 was accepted then we would do something like [1]. And the 
generated Makefile for the litmus7 tests turns into something very simple:

CFLAGS += -march=armv8.1-a

tests += $(EXT_DIR)/MP.flat

cflatobjs += $(EXT_DIR)/utils.o
cflatobjs += $(EXT_DIR)/kvm_timeofday.o

[1]: 
https://github.com/relokin/herdtools7/commit/6fa5ec06856c8263a0823ad21e097a39c97cabc1

Thanks,

Nikos

> [1] https://github.com/herd/herdtools7.git
> 
> Thanks,
> drew
> 

