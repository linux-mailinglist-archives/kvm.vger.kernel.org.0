Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3CFB9918B
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 13:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387973AbfHVLA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 07:00:59 -0400
Received: from foss.arm.com ([217.140.110.172]:43850 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731126AbfHVLA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 07:00:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3F691596;
        Thu, 22 Aug 2019 04:00:57 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E5B673F246;
        Thu, 22 Aug 2019 04:00:55 -0700 (PDT)
Subject: Re: [PATCH v3 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
To:     Jonathan Cameron <jonathan.cameron@huawei.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20190821153656.33429-1-steven.price@arm.com>
 <20190821153656.33429-6-steven.price@arm.com>
 <20190822113942.0000701f@huawei.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <301610cc-ba04-89d6-a0b6-d37ecf4a717a@arm.com>
Date:   Thu, 22 Aug 2019 12:00:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822113942.0000701f@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/08/2019 11:39, Jonathan Cameron wrote:
> On Wed, 21 Aug 2019 16:36:51 +0100
> Steven Price <steven.price@arm.com> wrote:
> 
>> Implement the service call for configuring a shared structure between a
>> VCPU and the hypervisor in which the hypervisor can write the time
>> stolen from the VCPU's execution time by other tasks on the host.
>>
>> The hypervisor allocates memory which is placed at an IPA chosen by user
>> space. The hypervisor then updates the shared structure using
>> kvm_put_guest() to ensure single copy atomicity of the 64-bit value
>> reporting the stolen time in nanoseconds.
>>
>> Whenever stolen time is enabled by the guest, the stolen time counter is
>> reset.
>>
>> The stolen time itself is retrieved from the sched_info structure
>> maintained by the Linux scheduler code. We enable SCHEDSTATS when
>> selecting KVM Kconfig to ensure this value is meaningful.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
> 
> One totally trivial comment inline... Feel free to ignore :)
> 
[...]
>> +int kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
>> +{
>> +	u64 ret;
>> +	int err;
>> +
>> +	/*
>> +	 * Start counting stolen time from the time the guest requests
>> +	 * the feature enabled.
>> +	 */
>> +	vcpu->arch.steal.steal = 0;
>> +	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
>> +
>> +	err = kvm_update_stolen_time(vcpu, true);
>> +
>> +	if (err)
>> +		ret = SMCCC_RET_NOT_SUPPORTED;
> 
> Trivial by why not
> 		return SMCCC_RET_NOT_SUPPORTED;
> 
> 	return vcpu->kvm->arch.pvtime.st_base +
> ...
> Drops the indentation a bit and puts the error handling out of
> line which is slightly nicer to read (to my eyes).

Yes that's a nice change - drops the extra "ret" variable too.

Thanks,

Steve
