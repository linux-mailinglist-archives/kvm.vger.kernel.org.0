Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB1107AA8F
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 16:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbfG3OIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 10:08:36 -0400
Received: from foss.arm.com ([217.140.110.172]:33296 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729975AbfG3OIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 10:08:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E47AE28;
        Tue, 30 Jul 2019 07:08:35 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FD2A3F694;
        Tue, 30 Jul 2019 07:08:35 -0700 (PDT)
Subject: Re: [PATCH 11/59] KVM: arm64: nv: Inject HVC exceptions to the
 virtual EL2
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-12-marc.zyngier@arm.com>
 <c83d9421-a027-9edf-021b-5d41a7a1884b@arm.com>
Message-ID: <e0e78eea-0e84-7afd-2b4f-2887f07d99aa@arm.com>
Date:   Tue, 30 Jul 2019 15:08:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <c83d9421-a027-9edf-021b-5d41a7a1884b@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/25/19 2:13 PM, Alexandru Elisei wrote:
> On 6/21/19 10:37 AM, Marc Zyngier wrote:
>> From: Jintack Lim <jintack.lim@linaro.org>
>>
>> Now that the psci call is done by the smc instruction when nested
> This suggests that we have support for PSCI calls using SMC as the conduit, but
> that is not the case, as the handle_smc function is not changed by this commit,
> and support for PSCI via SMC is added later in patch 22/59 "KVM: arm64: nv:
> Handle PSCI call via smc from the guest". Perhaps the commit message should be
> reworded to reflect that?
>> virtualization is enabled, it is clear that all hvc instruction from the
>> VM (including from the virtual EL2) are supposed to handled in the
>> virtual EL2.
>>
>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/handle_exit.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index 516aead3c2a9..6c0ac52b34cc 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -30,6 +30,7 @@
>>  #include <asm/kvm_coproc.h>
>>  #include <asm/kvm_emulate.h>
>>  #include <asm/kvm_mmu.h>
>> +#include <asm/kvm_nested.h>
>>  #include <asm/debug-monitors.h>
>>  #include <asm/traps.h>
>>  
>> @@ -52,6 +53,12 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  			    kvm_vcpu_hvc_get_imm(vcpu));
>>  	vcpu->stat.hvc_exit_stat++;
>>  
>> +	/* Forward hvc instructions to the virtual EL2 if the guest has EL2. */
>> +	if (nested_virt_in_use(vcpu)) {
>> +		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
>> +		return 1;
>> +	}

According to ARM DDI 0487E.a, when HCR_EL2.HCD = 1, HVC instructions are
undefined at EL2 and EL1.

Thanks,
Alex
>> +
>>  	ret = kvm_hvc_call_handler(vcpu);
>>  	if (ret < 0) {
>>  		vcpu_set_reg(vcpu, 0, ~0UL);
