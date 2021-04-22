Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C252E368328
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 17:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbhDVPR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 11:17:27 -0400
Received: from foss.arm.com ([217.140.110.172]:52672 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237474AbhDVPR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 11:17:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2731D13A1;
        Thu, 22 Apr 2021 08:16:52 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 838F33F73B;
        Thu, 22 Apr 2021 08:16:51 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH 0/1] configure: arm: Replace --vmm with
 --target
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
References: <20210420161338.70914-1-alexandru.elisei@arm.com>
 <20210420165101.irbx2upgqbazkvlt@gator.home>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ed3ba802-fee7-4c58-9d73-d33dfbd44d7f@arm.com>
Date:   Thu, 22 Apr 2021 16:17:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210420165101.irbx2upgqbazkvlt@gator.home>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 4/20/21 5:51 PM, Andrew Jones wrote:
> Hi Alex,
>
> On Tue, Apr 20, 2021 at 05:13:37PM +0100, Alexandru Elisei wrote:
>> This is an RFC because it's not exactly clear to me that this is the best
>> approach. I'm also open to using a different name for the new option, maybe
>> something like --platform if it makes more sense.
> I like 'target'.
>
>> I see two use cases for the patch:
>>
>> 1. Using different files when compiling kvm-unit-tests to run as an EFI app
>> as opposed to a KVM guest (described in the commit message).
>>
>> 2. This is speculation on my part, but I can see extending
>> arm/unittests.cfg with a "target" test option which can be used to decide
>> which tests need to be run based on the configure --target value. For
>> example, migration tests don't make much sense on kvmtool, which doesn't
>> have migration support. Similarly, the micro-bench test doesn't make much
>> sense (to me, at least) as an EFI app. Of course, this is only useful if
>> there are automated scripts to run the tests under kvmtool or EFI, which
>> doesn't look likely at the moment, so I left it out of the commit message.
> Sounds like a good idea. unittests.cfg could get a new option 'targets'
> where a list of targets is given. If targets is not present, then the
> test assumes it's for all targets. Might be nice to also accept !<target>
> syntax. E.g.
>
> # builds/runs for all targets
> [mytest]
> file = mytest.flat
>
> # builds/runs for given targets
> [mytest2]
> file = mytest2.flat
> targets = qemu,kvmtool
>
> # builds/runs for all targets except disabled targets
> [mytest3]
> file = mytest3.flat
> targets = !kvmtool

That's sounds like a good idea, but to be honest, I would wait until someone
actually needs it before implementing it. That way we don't risk not taking a use
case into account and then having to rework it.

>
> And it wouldn't bother me to have special logic for kvmtool's lack of
> migration put directly in scripts/runtime.bash

Good to keep in mind when support is added.

>
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 132389c7dd59..0d5cb51df4f4 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -132,7 +132,7 @@ function run()
>      }
>  
>      cmdline=$(get_cmdline $kernel)
> -    if grep -qw "migration" <<<$groups ; then
> +    if grep -qw "migration" <<<$groups && [ "$TARGET" != "kvmtool" ]; then
>          cmdline="MIGRATION=yes $cmdline"
>      fi
>      if [ "$verbose" = "yes" ]; then
>
>> Using --vmm will trigger a warning. I was thinking about removing it entirely in
>> a about a year's time, but that's not set in stone. Note that qemu users
>> (probably the vast majority of people) will not be affected by this change as
>> long as they weren't setting --vmm explicitely to its default value of "qemu".
>>
> While we'd risk automated configure+build tools, like git{hub,lab} CI,
> failing, I think the risk is pretty low right now that anybody is using
> the option. Also, we might as well make them change sooner than later by
> failing configure. IOW, I'd just do s/vmm/target/g to rename it now. If
> we are concerned about the disruption, then I'd just make vmm an alias
> for target and not bother deprecating it ever.

I also think it will not be too bad if we make the change now, but I'm not sure
what you mean by making vmm an alias of target. The patch ignores --vmm is it's
not specified, and if it is specified on the configure command line, then it must
match the value of --target, otherwise configure fails.

Thanks,

Alex
