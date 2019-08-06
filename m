Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC1182DD2
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 10:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbfHFIfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 04:35:53 -0400
Received: from foss.arm.com ([217.140.110.172]:58652 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728845AbfHFIfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 04:35:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8EB3337;
        Tue,  6 Aug 2019 01:35:52 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF5A73F706;
        Tue,  6 Aug 2019 01:35:51 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: arm64: Don't write junk to sysregs on reset
To:     Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20190805121555.130897-1-maz@kernel.org>
 <20190805121555.130897-2-maz@kernel.org>
 <01b74492-c59f-dfd9-e439-752e6b1c53dc@huawei.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <7b36f1dd-e44f-af75-0e51-8f6e705e81f6@kernel.org>
Date:   Tue, 6 Aug 2019 09:35:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <01b74492-c59f-dfd9-e439-752e6b1c53dc@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/08/2019 07:29, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2019/8/5 20:15, Marc Zyngier wrote:
>> At the moment, the way we reset system registers is mildly insane:
>> We write junk to them, call the reset functions, and then check that
>> we have something else in them.
>>
>> The "fun" thing is that this can happen while the guest is running
>> (PSCI, for example). If anything in KVM has to evaluate the state
>> of a system register while junk is in there, bad thing may happen.
>>
>> Let's stop doing that. Instead, we track that we have called a
>> reset function for that register, and assume that the reset
>> function has done something. This requires fixing a couple of
>> sysreg refinition in the trap table.
>>
>> In the end, the very need of this reset check is pretty dubious,
>> as it doesn't check everything (a lot of the sysregs leave outside of
>> the sys_regs[] array). It may well be axed in the near future.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> (Regardless of whether this check is needed or not,) I tested this patch
> with kvm-unit-tests:
> 
> for i in {1..100}; do QEMU=/path/to/qemu-system-aarch64 accel=kvm 
> arch=arm64 ./run_tests.sh; done
> 
> And all the tests passed!

Great! Can I take this as a 'Tested-by:'?

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
