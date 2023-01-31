Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662226833FB
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 18:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjAaRey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 12:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjAaReo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 12:34:44 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C8ADCDF8
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:34:43 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 419472F4;
        Tue, 31 Jan 2023 09:35:25 -0800 (PST)
Received: from [10.57.78.39] (unknown [10.57.78.39])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 185233F64C;
        Tue, 31 Jan 2023 09:34:40 -0800 (PST)
Message-ID: <3c15760c-c76f-3d5d-a661-442459ce4e07@arm.com>
Date:   Tue, 31 Jan 2023 17:34:39 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v8 01/69] arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230131092504.2880505-1-maz@kernel.org>
 <20230131092504.2880505-2-maz@kernel.org>
 <b7dbe85e-c7f8-48ad-e1af-85befabd8509@arm.com> <86cz6u248j.wl-maz@kernel.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86cz6u248j.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 31/01/2023 14:00, Marc Zyngier wrote:
> Hi Suzuki,
> 
> On Tue, 31 Jan 2023 13:47:31 +0000,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> Hi Marc
>>
>> On 31/01/2023 09:23, Marc Zyngier wrote:
>>> From: Jintack Lim <jintack.lim@linaro.org>
>>>
>>> Add a new ARM64_HAS_NESTED_VIRT feature to indicate that the
>>> CPU has the ARMv8.3 nested virtualization capability, together
>>> with the 'kvm-arm.mode=nested' command line option.
>>>
>>> This will be used to support nested virtualization in KVM.
>>>
>>> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>>> [maz: moved the command-line option to kvm-arm.mode]
>>
>> Should this be separate kvm-arm mode ? Or can this be tied to
>> is_kernel_in_hyp_mode() ? Given this mode (from my limited
>> review) doesn't conflict with normal VHE mode (and RME support),
>> adding this explicit mode could confuse the user.
> 
> What is exactly the objection here? NV is more or less a VHE++ mode,
> but is also completely experimental and incomplete.

I am all in for making this an "optional", only enabled it when "I know
what I want".

kvm-arm.mode=nv kind of seems that the KVM driver is conditioned
mainly for running NV (comparing with the other existing options
for kvm-arm.mode).

In reality, as you confirmed, NV is an *additional* capability
of a VHE hypervisor. So it would be good to "opt" in for "nv" capability
support.

e.g,

    kvm-arm.nv=on

Thinking more about it, either is fine.

> 
>> In case we need a command line to turn the NV mode on/off,
>> we could always use the id-override and simply leave this out ?
> 
> I really want an explicit user buy-in. There is absolutely no way this
> can be enabled by default, the risks are way too high. Just look at
> the x86 story: it took them 10 years to enable NV by default. I don't
> expect to do any better.

Of course, I am with you on that. I realise that we may not be able
to disable nv by default using idreg-override (i.e., without any kernel
command line option). So we may need something outside of that, like
the option mentioned above.

Suzuki

> 
> Thanks,
> 
> 	M.
> 

