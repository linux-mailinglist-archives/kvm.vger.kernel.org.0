Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100AC2C5883
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 16:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389756AbgKZPwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 10:52:47 -0500
Received: from foss.arm.com ([217.140.110.172]:37444 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbgKZPwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 10:52:46 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED0A731B;
        Thu, 26 Nov 2020 07:52:45 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4156A3F23F;
        Thu, 26 Nov 2020 07:52:45 -0800 (PST)
Subject: Re: [PATCH 6/8] KVM: arm64: Remove dead PMU sysreg decoding code
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20201113182602.471776-1-maz@kernel.org>
 <20201113182602.471776-7-maz@kernel.org>
 <1ed6dfd6-4ace-a562-bc2f-054a5c853fa6@arm.com>
 <3ae09ecc95b732129f71076b4b59c873@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b05e1334-e7d0-5c00-3442-d383d0358bcd@arm.com>
Date:   Thu, 26 Nov 2020 15:54:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <3ae09ecc95b732129f71076b4b59c873@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 11/26/20 3:34 PM, Marc Zyngier wrote:
> Hi Alex,
>
> On 2020-11-26 15:18, Alexandru Elisei wrote:
>> Hi Marc,
>>
>> I checked and indeed the remaining cases cover all registers that use
>> this accessor.
>>
>> However, I'm a bit torn here. The warning that I got when trying to run a guest
>> with the PMU feature flag set, but not initialized (reported at [1])
>> was also not
>> supposed to ever be reached:
>>
>> static u32 kvm_pmu_event_mask(struct kvm *kvm)
>> {
>>     switch (kvm->arch.pmuver) {
>>     case 1:            /* ARMv8.0 */
>>         return GENMASK(9, 0);
>>     case 4:            /* ARMv8.1 */
>>     case 5:            /* ARMv8.4 */
>>     case 6:            /* ARMv8.5 */
>>         return GENMASK(15, 0);
>>     default:        /* Shouldn't be here, just for sanity */
>>         WARN_ONCE(1, "Unknown PMU version %d\n", kvm->arch.pmuver);
>>         return 0;
>>     }
>> }
>>
>> I realize it's not exactly the same thing and I'll leave it up to you
>> if you want
>> to add a warning for the cases that should never happen. I'm fine either way:
>
> I already have queued such a warning[1]. It turns out that LLVM warns
> idx can be left uninitialized, and shouts. Let me know if that works
> for you.

Looks good to me, unsigned long is 64 bits and instructions are 32 bits, so we'll
never run into a situation where a valid encoding is ~0UL.

You can add my Reviewed-by to this patch (and to the one at [1] if it's still
possible).

Thanks,

Alex

>
> Thanks,
>
>         M.
>
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/pmu-undef&id=af7eff70eaf8f28179334f5aeabb70a306242c83
