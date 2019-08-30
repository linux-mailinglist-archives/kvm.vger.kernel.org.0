Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACFBA347E
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 11:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfH3JwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 05:52:10 -0400
Received: from foss.arm.com ([217.140.110.172]:57630 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbfH3JwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 05:52:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C85E8344;
        Fri, 30 Aug 2019 02:52:08 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 23C263F718;
        Fri, 30 Aug 2019 02:52:07 -0700 (PDT)
Subject: Re: [PATCH v4 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
To:     Christoffer Dall <christoffer.dall@arm.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20190830084255.55113-1-steven.price@arm.com>
 <20190830084255.55113-6-steven.price@arm.com>
 <20190830094245.GB5307@e113682-lin.lund.arm.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <bf45fea9-f2f7-1ff3-c90c-cb9623cbd959@arm.com>
Date:   Fri, 30 Aug 2019 10:52:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190830094245.GB5307@e113682-lin.lund.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/08/2019 10:42, Christoffer Dall wrote:
> On Fri, Aug 30, 2019 at 09:42:50AM +0100, Steven Price wrote:
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
[...]
>> +int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	u64 steal;
>> +	u64 steal_le;
>> +	u64 offset;
>> +	int idx;
>> +	u64 base = vcpu->arch.steal.base;
>> +
>> +	if (base == GPA_INVALID)
>> +		return -ENOTSUPP;
>> +
>> +	/* Let's do the local bookkeeping */
>> +	steal = vcpu->arch.steal.steal;
>> +	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
>> +	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
>> +	vcpu->arch.steal.steal = steal;
>> +
>> +	steal_le = cpu_to_le64(steal);
>> +	idx = srcu_read_lock(&kvm->srcu);
>> +	if (init) {
>> +		struct pvclock_vcpu_stolen_time init_values = {
>> +			.revision = 0,
>> +			.attributes = 0
>> +		};
>> +		kvm_write_guest(kvm, base, &init_values,
>> +				sizeof(init_values));
>> +	}
>> +	offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
>> +	kvm_put_guest(kvm, base + offset, steal_le, u64);
> 
> Let's hope we don't have thousands of memslots through which we have to
> do a linear scan on every vcpu load after this.  If that were the case,
> I think the memslot search path would have to be updated anyhow.

Yes I'm not sure with the current memslot implementation it is actually
beneficial to split up the stolen time structures into separate
memslots. But there's nothing requiring the use of so many memslots.

If this is really a problem it would be possible to implement a
memslot-caching kvm_put_guest(), but I'd want to wait until someone
shows there's actually a problem first.

> Otherwise looks reasonable to me.

Great, thanks for the review.

Steve
