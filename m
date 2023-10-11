Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8606F7C58F1
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 18:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjJKQPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 12:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbjJKQP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 12:15:28 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54E0993
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 09:15:27 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB87D14BF;
        Wed, 11 Oct 2023 09:16:07 -0700 (PDT)
Received: from [10.57.3.164] (unknown [10.57.3.164])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8803B3F7A6;
        Wed, 11 Oct 2023 09:15:25 -0700 (PDT)
Message-ID: <8f2d7a1a-afe3-233a-75a4-68f4e65505c2@arm.com>
Date:   Wed, 11 Oct 2023 17:15:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH kvmtool 0/3] Change what --nodefaults does and a revert
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     maz@kernel.org, andre.przywara@arm.com,
        jean-philippe.brucker@arm.com, kvm@vger.kernel.org,
        julien.thierry.kdev@gmail.com, apatel@ventanamicro.com,
        oliver.upton@linux.dev, catalin.marinas@arm.com,
        kernel-team@android.com
References: <20230907171655.6996-1-alexandru.elisei@arm.com>
 <169503375704.3755487.15995711453259792866.b4-ty@kernel.org>
 <ZSa3tQ830HcQgPwD@monolith>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ZSa3tQ830HcQgPwD@monolith>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/2023 15:56, Alexandru Elisei wrote:
> Hi Will,
> 
> Sorry for the late reply, was on holiday.
> 
> On Mon, Sep 18, 2023 at 12:05:14PM +0100, Will Deacon wrote:
>> On Thu, 7 Sep 2023 18:16:52 +0100, Alexandru Elisei wrote:
>>> The first two patches revert "virtio-net: Don't print the compat warning
>>> for the default device" because using --network mode=none disables the
>>> device and lets the user know that it can use that to disable the default
>>> virtio-net device. I don't think the changes are controversial.
>>>
>>> And the last patch is there to get the conversation going about changing
>>> what --nodefaults does. Details in the patch.
>>>
>>> [...]
>>
>> Applied first two to kvmtool (master), thanks!
>>
>> [1/3] Revert "virtio-net: Don't print the compat warning for the default device"
>>        https://git.kernel.org/will/kvmtool/c/4498eb7400c6
>> [2/3] builtin-run: Document mode=none for -n/--network
>>        https://git.kernel.org/will/kvmtool/c/c7b7a542cdcd
>>
>> I'm also not sure about the final RFC patch:
>>
>> [3/3] builtin-run: Have --nodefaults disable the default virtio-net device
>>
>> so it would be great to hear if anybody else has an opinion on that. IIRC,
>> we introduced this for some EFI work, so perhaps those folks might have
>> an opinion?
> 
> It was actually introduced to allow kvmtool to load a kvm-unit-tests test
> file using --kernel instead of --firmware [1].
> 
> The user can specify parameters for a test using two methods: using the
> kernel command line (for selecting a specific test from a test file with
> multiple tests, for example) and from an initrd (for environment variables,
> in a key=value format). --firmware cannot load an initrd, so the only
> option is to use --kernel. But kvmtool mangles the kernel command line by
> prepending several kernel options, which breaks kvm-unit-tests' command
> line parser. Until --defaults there was no way to disable this behaviour.
> 
> To the point of running kvm-unit-tests, it makes no functional difference
> if a test is run with --nodefaults --network mode=none or with --nodefaults
> only. It's just that I think that --nodefaults disabling the default
> configuration options is slightly more intuitive, but I'm not sure the
> effort of changing the semantics is worth it (need to inspect all the code
> that sets the default configuration options, then possibly adding new
> kvmtool command line parameters to bring back those options if there's no
> other way of changing them - I suspect this can get rather tedious).

I personally prefer "--nodefaults" doing what it says. i.e., kvmtool
not adding *anything* by default on its own.

Suzuki


> 
> [1] https://lore.kernel.org/all/20210923144505.60776-1-alexandru.elisei@arm.com/
> 
> Thanks,
> Alex
> 
>>
>> Cheers,
>> -- 
>> Will
>>
>> https://fixes.arm64.dev
>> https://next.arm64.dev
>> https://will.arm64.dev

