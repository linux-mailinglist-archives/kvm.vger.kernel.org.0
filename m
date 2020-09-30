Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03D027E8AD
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 14:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgI3Mgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 08:36:50 -0400
Received: from foss.arm.com ([217.140.110.172]:35376 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbgI3Mgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 08:36:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FFC530E;
        Wed, 30 Sep 2020 05:36:49 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6EF553F6CF;
        Wed, 30 Sep 2020 05:36:47 -0700 (PDT)
Subject: Re: [PATCH v7 5/7] KVM: arm64: pmu: Make overflow handler NMI safe
To:     Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, sumit.garg@linaro.org, maz@kernel.org,
        swboyd@chromium.org, catalin.marinas@arm.com,
        Julien Thierry <julien.thierry@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200924110706.254996-1-alexandru.elisei@arm.com>
 <20200924110706.254996-6-alexandru.elisei@arm.com>
 <20200928175725.GB11792@willie-the-truck>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <6b1ecdef-3a42-c428-2309-753b1470e3de@arm.com>
Date:   Wed, 30 Sep 2020 13:37:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200928175725.GB11792@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On 9/28/20 6:57 PM, Will Deacon wrote:

> On Thu, Sep 24, 2020 at 12:07:04PM +0100, Alexandru Elisei wrote:
>> From: Julien Thierry <julien.thierry@arm.com>
>>
>> kvm_vcpu_kick() is not NMI safe. When the overflow handler is called from
>> NMI context, defer waking the vcpu to an irq_work queue.
>>
>> A vcpu can be freed while it's not running by kvm_destroy_vm(). Prevent
>> running the irq_work for a non-existent vcpu by calling irq_work_sync() on
>> the PMU destroy path.
>>
>> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
>> Cc: kvm@vger.kernel.org
>> Cc: kvmarm@lists.cs.columbia.edu
>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>> Tested-by: Sumit Garg <sumit.garg@linaro.org> (Developerbox)
>> [Alexandru E.: Added irq_work_sync()]
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>> I suggested in v6 that I will add an irq_work_sync() to
>> kvm_pmu_vcpu_reset(). It turns out it's not necessary: a vcpu reset is done
>> by the vcpu being reset with interrupts enabled, which means all the work
>> has had a chance to run before the reset takes place.
> I don't understand this ^^

Marc had the same comment, I replied in his email. I thought about it and you're
right, it doesn't make much sense.

>
> But the patch itself looks good, so I'm going to queue this lot anyway!

Thank you for picking up the series!

Thanks,
Alex
