Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E19741E996
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 11:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352892AbhJAJ3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 05:29:06 -0400
Received: from foss.arm.com ([217.140.110.172]:38640 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229906AbhJAJ3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 05:29:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 50D24101E;
        Fri,  1 Oct 2021 02:27:21 -0700 (PDT)
Received: from [10.57.72.173] (unknown [10.57.72.173])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE4CA3F70D;
        Fri,  1 Oct 2021 02:27:19 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Allow KVM to be disabled from the command
 line
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, ascull@google.com,
        dbrazdil@google.com, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20210903091652.985836-1-maz@kernel.org>
 <5bc623f2-e4c1-cc9c-683c-2f95648f1a68@arm.com> <87a6jutkyq.wl-maz@kernel.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <e80b2454-45c3-19a3-7a96-dcb484f9e2f5@arm.com>
Date:   Fri, 1 Oct 2021 10:27:18 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <87a6jutkyq.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/2021 11:29, Marc Zyngier wrote:
> On Wed, 29 Sep 2021 11:35:46 +0100,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> On 03/09/2021 10:16, Marc Zyngier wrote:
>>> Although KVM can be compiled out of the kernel, it cannot be disabled
>>> at runtime. Allow this possibility by introducing a new mode that
>>> will prevent KVM from initialising.
>>>
>>> This is useful in the (limited) circumstances where you don't want
>>> KVM to be available (what is wrong with you?), or when you want
>>> to install another hypervisor instead (good luck with that).
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>    Documentation/admin-guide/kernel-parameters.txt |  3 +++
>>>    arch/arm64/include/asm/kvm_host.h               |  1 +
>>>    arch/arm64/kernel/idreg-override.c              |  1 +
>>>    arch/arm64/kvm/arm.c                            | 14 +++++++++++++-
>>>    4 files changed, 18 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>>> index 91ba391f9b32..cc5f68846434 100644
>>> --- a/Documentation/admin-guide/kernel-parameters.txt
>>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>>> @@ -2365,6 +2365,9 @@
>>>    	kvm-arm.mode=
>>>    			[KVM,ARM] Select one of KVM/arm64's modes of operation.
>>>    +			none: Forcefully disable KVM and run in nVHE
>>> mode,
>>> +			      preventing KVM from ever initialising.
>>> +
>>>    			nvhe: Standard nVHE-based mode, without support for
>>>    			      protected guests.
>>>    diff --git a/arch/arm64/include/asm/kvm_host.h
>>> b/arch/arm64/include/asm/kvm_host.h
>>> index f8be56d5342b..019490c67976 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -58,6 +58,7 @@
>>>    enum kvm_mode {
>>>    	KVM_MODE_DEFAULT,
>>>    	KVM_MODE_PROTECTED,
>>> +	KVM_MODE_NONE,
>>>    };
>>>    enum kvm_mode kvm_get_mode(void);
>>>    diff --git a/arch/arm64/kernel/idreg-override.c
>>> b/arch/arm64/kernel/idreg-override.c
>>> index d8e606fe3c21..57013c1b6552 100644
>>> --- a/arch/arm64/kernel/idreg-override.c
>>> +++ b/arch/arm64/kernel/idreg-override.c
>>> @@ -95,6 +95,7 @@ static const struct {
>>>    	char	alias[FTR_ALIAS_NAME_LEN];
>>>    	char	feature[FTR_ALIAS_OPTION_LEN];
>>>    } aliases[] __initconst = {
>>> +	{ "kvm-arm.mode=none",		"id_aa64mmfr1.vh=0" },
>>>    	{ "kvm-arm.mode=nvhe",		"id_aa64mmfr1.vh=0" },
>>>    	{ "kvm-arm.mode=protected",	"id_aa64mmfr1.vh=0" },
>>>    	{ "arm64.nobti",		"id_aa64pfr1.bt=0" },
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index fe102cd2e518..cdc70e238316 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -2064,6 +2064,11 @@ int kvm_arch_init(void *opaque)
>>>    		return -ENODEV;
>>>    	}
>>>    +	if (kvm_get_mode() == KVM_MODE_NONE) {
>>> +		kvm_info("KVM disabled from command line\n");
>>> +		return -ENODEV;
>>> +	}
>>> +
>>>    	in_hyp_mode = is_kernel_in_hyp_mode();
>>>      	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE)
>>> ||
>>> @@ -2137,8 +2142,15 @@ static int __init early_kvm_mode_cfg(char *arg)
>>>    		return 0;
>>>    	}
>>>    -	if (strcmp(arg, "nvhe") == 0 &&
>>> !WARN_ON(is_kernel_in_hyp_mode()))
>>> +	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
>>> +		kvm_mode = KVM_MODE_DEFAULT;
>>>    		return 0;
>>> +	}
>>> +
>>> +	if (strcmp(arg, "none") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
>>
>> nit: Does this really need to WARN here ? Unlike the "nvhe" case, if the
>> user wants to keep the KVM out of the picture for, say debugging
>> something, it is perfectly Ok to allow the kernel to be running at EL2
>> without having to change the Firmware to alter the landing EL for the
>> kernel ?
> 
> Well, the doc says "run in nVHE mode" and the option forces
> id_aa64mmfr1.vh=0. The WARN_ON() will only fires on broken^Wfruity HW
> that is VHE only. Note that this doesn't rely on any firmware change
> (we drop from EL2 to EL1 and stay there).

Ah, ok. So the "none" is in fact "nvhe + no-kvm". Thats the bit I
missed. TBH, that name to me sounds like "no KVM" at all, which is what
we want. The question is, do we really need "none" to force vh == 0 ? I
understand this is only a problem on a rare set of HWs. But the generic
option looks deceiving.

That said, I am happy to leave this as is and the doc says so.

> 
> We could add another option (none-vhe?) that stays at EL2 and still
> disables KVM if there is an appetite for it.

Na. Don't think that is necessary.

> 
>> Otherwise,
>>
>> Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Suzuki
