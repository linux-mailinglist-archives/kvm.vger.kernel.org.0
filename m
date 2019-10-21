Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21AC6DEAC9
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 13:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbfJULY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 07:24:57 -0400
Received: from [217.140.110.172] ([217.140.110.172]:49806 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbfJULY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 07:24:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82EBEEBD;
        Mon, 21 Oct 2019 04:24:22 -0700 (PDT)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1F893F718;
        Mon, 21 Oct 2019 04:24:20 -0700 (PDT)
Subject: Re: [PATCH v6 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
To:     Marc Zyngier <maz@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20191011125930.40834-1-steven.price@arm.com>
 <20191011125930.40834-6-steven.price@arm.com> <86eez9yoog.wl-maz@kernel.org>
 <1bb10eb5-0fe8-57c9-3b67-9b3661a73d29@arm.com>
 <cc639f743d621198ef02f880089bb54d@www.loen.fr>
From:   Steven Price <steven.price@arm.com>
Message-ID: <89a8002f-a9b0-1864-a568-36285eb2c485@arm.com>
Date:   Mon, 21 Oct 2019 12:24:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <cc639f743d621198ef02f880089bb54d@www.loen.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/2019 11:40, Marc Zyngier wrote:
> On 2019-10-21 11:21, Steven Price wrote:
>> On 19/10/2019 12:12, Marc Zyngier wrote:
>>> On Fri, 11 Oct 2019 13:59:25 +0100,
>>> Steven Price <steven.price@arm.com> wrote:
>>>>
>>>> Implement the service call for configuring a shared structure between a
>>>> VCPU and the hypervisor in which the hypervisor can write the time
>>>> stolen from the VCPU's execution time by other tasks on the host.
>>>>
>>>> User space allocates memory which is placed at an IPA also chosen by
>>>> user
>>>> space. The hypervisor then updates the shared structure using
>>>> kvm_put_guest() to ensure single copy atomicity of the 64-bit value
>>>> reporting the stolen time in nanoseconds.
>>>>
>>>> Whenever stolen time is enabled by the guest, the stolen time
>>>> counter is
>>>> reset.
>>>>
>>>> The stolen time itself is retrieved from the sched_info structure
>>>> maintained by the Linux scheduler code. We enable SCHEDSTATS when
>>>> selecting KVM Kconfig to ensure this value is meaningful.
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>>  arch/arm/include/asm/kvm_host.h   | 20 +++++++++++
>>>>  arch/arm64/include/asm/kvm_host.h | 21 +++++++++++-
>>>>  arch/arm64/kvm/Kconfig            |  1 +
>>>>  include/linux/kvm_types.h         |  2 ++
>>>>  virt/kvm/arm/arm.c                | 11 ++++++
>>>>  virt/kvm/arm/hypercalls.c         |  3 ++
>>>>  virt/kvm/arm/pvtime.c             | 56 +++++++++++++++++++++++++++++++
>>>>  7 files changed, 113 insertions(+), 1 deletion(-)
> 
> [...]
> 
>>>> +long kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
>>>
>>> Why long? If that's a base address, then it is either a phys_addr_t or
>>> a gpa_t. I'd suggest you move the error check to the caller.
>>
>> This is a bit more tricky. It's a long because that's the declared type
>> of the SMCCC return in kvm_hvc_call_handler(). I can't (easily) move the
>> code into kvm_hvc_call_handler() because that is compiled for arm (as
>> well as arm64) and we don't have the definitions for stolen time there.
>> The best option I could come up with is to have a dummy stub for arm and
>> use generic types for this function.
>>
>> This means we need a type which can contain both a gpa_t and the
>> SMCCC_RET_NOT_SUPPORTED error code.
>>
>> I'm open to alternative suggestions on how to make this work.
> 
> My suggestion would be to always return a gpa_t from this function, and
> change the 32bit stub for kvm_hypercall_stolen_time() to always return
> GPA_INVALID.

Ok, fair enough. Although it ends up with this strange looking fragment
in kvm_hvc_call_handler():

	case ARM_SMCCC_HV_PV_TIME_ST:
		gpa = kvm_init_stolen_time(vcpu);
		if (gpa != GPA_INVALID)
			val = gpa;
		break;

But I agree the gpa_t return type is clearer.

Thanks,

Steve
