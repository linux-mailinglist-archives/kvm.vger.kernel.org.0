Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D093DE9DE
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 12:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfJUKkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 06:40:19 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:42245 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727767AbfJUKkS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Oct 2019 06:40:18 -0400
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iMV6l-00020K-Os; Mon, 21 Oct 2019 12:40:15 +0200
To:     Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v6 05/10] KVM: arm64: Support stolen time reporting via  shared structure
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Oct 2019 11:40:15 +0100
From:   Marc Zyngier <maz@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, <kvm@vger.kernel.org>,
        =?UTF-8?Q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        <linux-doc@vger.kernel.org>, Russell King <linux@armlinux.org.uk>,
        <linux-kernel@vger.kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1bb10eb5-0fe8-57c9-3b67-9b3661a73d29@arm.com>
References: <20191011125930.40834-1-steven.price@arm.com>
 <20191011125930.40834-6-steven.price@arm.com> <86eez9yoog.wl-maz@kernel.org>
 <1bb10eb5-0fe8-57c9-3b67-9b3661a73d29@arm.com>
Message-ID: <cc639f743d621198ef02f880089bb54d@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: steven.price@arm.com, mark.rutland@arm.com, kvm@vger.kernel.org, rkrcmar@redhat.com, catalin.marinas@arm.com, suzuki.poulose@arm.com, linux-doc@vger.kernel.org, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-10-21 11:21, Steven Price wrote:
> On 19/10/2019 12:12, Marc Zyngier wrote:
>> On Fri, 11 Oct 2019 13:59:25 +0100,
>> Steven Price <steven.price@arm.com> wrote:
>>>
>>> Implement the service call for configuring a shared structure 
>>> between a
>>> VCPU and the hypervisor in which the hypervisor can write the time
>>> stolen from the VCPU's execution time by other tasks on the host.
>>>
>>> User space allocates memory which is placed at an IPA also chosen 
>>> by user
>>> space. The hypervisor then updates the shared structure using
>>> kvm_put_guest() to ensure single copy atomicity of the 64-bit value
>>> reporting the stolen time in nanoseconds.
>>>
>>> Whenever stolen time is enabled by the guest, the stolen time 
>>> counter is
>>> reset.
>>>
>>> The stolen time itself is retrieved from the sched_info structure
>>> maintained by the Linux scheduler code. We enable SCHEDSTATS when
>>> selecting KVM Kconfig to ensure this value is meaningful.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>>  arch/arm/include/asm/kvm_host.h   | 20 +++++++++++
>>>  arch/arm64/include/asm/kvm_host.h | 21 +++++++++++-
>>>  arch/arm64/kvm/Kconfig            |  1 +
>>>  include/linux/kvm_types.h         |  2 ++
>>>  virt/kvm/arm/arm.c                | 11 ++++++
>>>  virt/kvm/arm/hypercalls.c         |  3 ++
>>>  virt/kvm/arm/pvtime.c             | 56 
>>> +++++++++++++++++++++++++++++++
>>>  7 files changed, 113 insertions(+), 1 deletion(-)

[...]

>>> +long kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
>>
>> Why long? If that's a base address, then it is either a phys_addr_t 
>> or
>> a gpa_t. I'd suggest you move the error check to the caller.
>
> This is a bit more tricky. It's a long because that's the declared 
> type
> of the SMCCC return in kvm_hvc_call_handler(). I can't (easily) move 
> the
> code into kvm_hvc_call_handler() because that is compiled for arm (as
> well as arm64) and we don't have the definitions for stolen time 
> there.
> The best option I could come up with is to have a dummy stub for arm 
> and
> use generic types for this function.
>
> This means we need a type which can contain both a gpa_t and the
> SMCCC_RET_NOT_SUPPORTED error code.
>
> I'm open to alternative suggestions on how to make this work.

My suggestion would be to always return a gpa_t from this function, and
change the 32bit stub for kvm_hypercall_stolen_time() to always return
GPA_INVALID.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
