Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABB982E30
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 10:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732356AbfHFIzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 04:55:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39722 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728056AbfHFIzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 04:55:25 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 00BF69BDC5D9930B0BAB;
        Tue,  6 Aug 2019 16:55:23 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Tue, 6 Aug 2019
 16:55:12 +0800
Subject: Re: [PATCH 1/2] KVM: arm64: Don't write junk to sysregs on reset
To:     Marc Zyngier <maz@kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
CC:     Andrew Jones <drjones@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20190805121555.130897-1-maz@kernel.org>
 <20190805121555.130897-2-maz@kernel.org>
 <01b74492-c59f-dfd9-e439-752e6b1c53dc@huawei.com>
 <7b36f1dd-e44f-af75-0e51-8f6e705e81f6@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <1a5eb1cb-99e4-6e20-576a-076ca4fd3342@huawei.com>
Date:   Tue, 6 Aug 2019 16:52:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <7b36f1dd-e44f-af75-0e51-8f6e705e81f6@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/8/6 16:35, Marc Zyngier wrote:
> On 06/08/2019 07:29, Zenghui Yu wrote:
>> Hi Marc,
>>
>> On 2019/8/5 20:15, Marc Zyngier wrote:
>>> At the moment, the way we reset system registers is mildly insane:
>>> We write junk to them, call the reset functions, and then check that
>>> we have something else in them.
>>>
>>> The "fun" thing is that this can happen while the guest is running
>>> (PSCI, for example). If anything in KVM has to evaluate the state
>>> of a system register while junk is in there, bad thing may happen.
>>>
>>> Let's stop doing that. Instead, we track that we have called a
>>> reset function for that register, and assume that the reset
>>> function has done something. This requires fixing a couple of
>>> sysreg refinition in the trap table.
>>>
>>> In the end, the very need of this reset check is pretty dubious,
>>> as it doesn't check everything (a lot of the sysregs leave outside of
>>> the sys_regs[] array). It may well be axed in the near future.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>
>> (Regardless of whether this check is needed or not,) I tested this patch
>> with kvm-unit-tests:
>>
>> for i in {1..100}; do QEMU=/path/to/qemu-system-aarch64 accel=kvm
>> arch=arm64 ./run_tests.sh; done
>>
>> And all the tests passed!
> 
> Great! Can I take this as a 'Tested-by:'?

Yes, please add:

Tested-by: Zenghui Yu <yuzenghui@huawei.com>


Zenghui

