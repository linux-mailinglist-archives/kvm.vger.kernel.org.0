Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF22CCB71E
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 11:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbfJDJNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 05:13:44 -0400
Received: from foss.arm.com ([217.140.110.172]:39618 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfJDJNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 05:13:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7066C1597;
        Fri,  4 Oct 2019 02:13:43 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FCE83F739;
        Fri,  4 Oct 2019 02:13:41 -0700 (PDT)
Subject: Re: [PATCH v5 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191002145037.51630-1-steven.price@arm.com>
 <20191002145037.51630-6-steven.price@arm.com>
 <20191003132235.ruanyfmdim5s6npj@kamzik.brq.redhat.com>
 <20191004070301.d7ari5rjlu3uuara@kamzik.brq.redhat.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <b107c1ca-6804-dc47-af25-fcd0b201472f@arm.com>
Date:   Fri, 4 Oct 2019 10:13:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191004070301.d7ari5rjlu3uuara@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/2019 08:03, Andrew Jones wrote:
> On Thu, Oct 03, 2019 at 03:22:35PM +0200, Andrew Jones wrote:
>> On Wed, Oct 02, 2019 at 03:50:32PM +0100, Steven Price wrote:
>>> +int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init)
>>> +{
>>> +	struct kvm *kvm = vcpu->kvm;
>>> +	u64 steal;
>>> +	u64 steal_le;
>>> +	u64 offset;
>>> +	int idx;
>>> +	u64 base = vcpu->arch.steal.base;
>>> +
>>> +	if (base == GPA_INVALID)
>>> +		return -ENOTSUPP;
>>> +
>>> +	/* Let's do the local bookkeeping */
>>> +	steal = vcpu->arch.steal.steal;
>>> +	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
>>> +	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
>>> +	vcpu->arch.steal.steal = steal;
>>> +
>>> +	steal_le = cpu_to_le64(steal);
>>
>> Agreeing on a byte order for this interface makes sense, but I don't see
>> it documented anywhere. Is this an SMCCC thing? Because I skimmed some
>> of those specs and other users too but didn't see anything obvious. Anyway
>> even if everybody but me knows that all data returned from SMCCC calls
>> should be LE, it might be nice to document that in the pvtime doc.

A very good point - I'll document this in the Linux document and feed
that back for DEN0057A.

> 
> I have another [potentially dumb] SMCCC byte order question. If we need
> to worry about using LE for the members of this structure, then why don't
> we need to worry about the actual return values of the SMCCC calls? Like
> the IPA of the structure?

The SMCCC calls pass values in registers. It's only when reading/writing
these values from/to memory that the endianness actually has any meaning.

Steve
