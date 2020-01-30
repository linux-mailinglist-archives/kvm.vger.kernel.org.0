Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9EB014D9EA
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 12:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgA3LhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 06:37:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46451 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726980AbgA3LhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 06:37:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580384219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=FZeHcxXxS1/CHn96QDMm1nKof92sILcVlU0NI0EIkmE=;
        b=GMoovjfzAkRXQbJKowTpO87cVjDB0Yff/dppXQzaqSGv37dFFEdZS9jDA7+6folPMPIJRC
        4xVk40urbi3AkYVcdM+fDmR0FWk29Ko+HT9o7M1rw5vCkMlg4e8Dp6A/XyuQFGYd9JT9sH
        t3JRF6hoouiJyZAO/7ggOsCJmWg8nLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-RvzQFfyyNZS4vm-Ms_utXA-1; Thu, 30 Jan 2020 06:36:51 -0500
X-MC-Unique: RvzQFfyyNZS4vm-Ms_utXA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C84408017CC;
        Thu, 30 Jan 2020 11:36:50 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-117.ams2.redhat.com [10.36.117.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C2C7D87B34;
        Thu, 30 Jan 2020 11:36:46 +0000 (UTC)
Subject: Re: [PATCH v8 3/4] selftests: KVM: s390x: Add reset tests
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20200129200312.3200-1-frankja@linux.ibm.com>
 <20200129200312.3200-4-frankja@linux.ibm.com>
 <e0f72503-d292-edc4-67e1-abe1cbab3f96@redhat.com>
 <0993d789-5cfd-d4c3-a39e-28d22d82dd43@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d3ed6702-a96d-b0bb-c768-5c59f40444e7@redhat.com>
Date:   Thu, 30 Jan 2020 12:36:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0993d789-5cfd-d4c3-a39e-28d22d82dd43@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/01/2020 12.32, Janosch Frank wrote:
> On 1/30/20 11:51 AM, Thomas Huth wrote:
>> On 29/01/2020 21.03, Janosch Frank wrote:
>>> Test if the registers end up having the correct values after a normal,
>>> initial and clear reset.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>  tools/testing/selftests/kvm/Makefile       |   1 +
>>>  tools/testing/selftests/kvm/s390x/resets.c | 165 +++++++++++++++++++++
>>>  2 files changed, 166 insertions(+)
>>>  create mode 100644 tools/testing/selftests/kvm/s390x/resets.c
>>>
>>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
>>> index 3138a916574a..fe1ea294730c 100644
>>> --- a/tools/testing/selftests/kvm/Makefile
>>> +++ b/tools/testing/selftests/kvm/Makefile
>>> @@ -36,6 +36,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
>>>  
>>>  TEST_GEN_PROGS_s390x = s390x/memop
>>>  TEST_GEN_PROGS_s390x += s390x/sync_regs_test
>>> +TEST_GEN_PROGS_s390x += s390x/resets
>>>  TEST_GEN_PROGS_s390x += dirty_log_test
>>>  TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
>>>  
>>> diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
>>> new file mode 100644
>>> index 000000000000..2b2378cc9e80
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/kvm/s390x/resets.c
>>> @@ -0,0 +1,165 @@
>>> +// SPDX-License-Identifier: GPL-2.0-or-later
>>> +/*
>>> + * Test for s390x CPU resets
>>> + *
>>> + * Copyright (C) 2020, IBM
>>> + */
>>> +
>>> +#include <stdio.h>
>>> +#include <stdlib.h>
>>> +#include <string.h>
>>> +#include <sys/ioctl.h>
>>> +
>>> +#include "test_util.h"
>>> +#include "kvm_util.h"
>>> +
>>> +#define VCPU_ID 3
>>> +
>>> +struct kvm_vm *vm;
>>> +struct kvm_run *run;
>>> +struct kvm_sync_regs *regs;
>>> +static uint64_t regs_null[16];
>>> +
>>> +static uint64_t crs[16] = { 0x40000ULL,
>>> +			    0x42000ULL,
>>> +			    0, 0, 0, 0, 0,
>>> +			    0x43000ULL,
>>> +			    0, 0, 0, 0, 0,
>>> +			    0x44000ULL,
>>> +			    0, 0
>>> +};
>>> +
>>> +static void guest_code_initial(void)
>>> +{
>>> +	/* Round toward 0 */
>>> +	uint32_t fpc = 0x11;
>>> +
>>> +	/* Dirty registers */
>>> +	asm volatile (
>>> +		"	lctlg	0,15,%0\n"
>>> +		"	sfpc	%1\n"
>>> +		: : "Q" (crs), "d" (fpc));
>>
>> I'd recommend to add a GUEST_SYNC(0) here ... otherwise the guest code
>> tries to return from this function and will cause a crash - which will
>> also finish execution of the guest, but might have unexpected side effects.
> 
> Ok
> 
>>
>>> +}
>>> +
>>> +static void test_one_reg(uint64_t id, uint64_t value)
>>> +{
>>> +	struct kvm_one_reg reg;
>>> +	uint64_t eval_reg;
>>> +
>>> +	reg.addr = (uintptr_t)&eval_reg;
>>> +	reg.id = id;
>>> +	vcpu_get_reg(vm, VCPU_ID, &reg);
>>> +	TEST_ASSERT(eval_reg == value, "value == %s", value);
>>> +}
>>> +
>>> +static void assert_clear(void)
>>> +{
>>> +	struct kvm_sregs sregs;
>>> +	struct kvm_regs regs;
>>> +	struct kvm_fpu fpu;
>>> +
>>> +	vcpu_regs_get(vm, VCPU_ID, &regs);
>>> +	TEST_ASSERT(!memcmp(&regs.gprs, regs_null, sizeof(regs.gprs)), "grs == 0");
>>> +
>>> +	vcpu_sregs_get(vm, VCPU_ID, &sregs);
>>> +	TEST_ASSERT(!memcmp(&sregs.acrs, regs_null, sizeof(sregs.acrs)), "acrs == 0");
>>> +
>>> +	vcpu_fpu_get(vm, VCPU_ID, &fpu);
>>> +	TEST_ASSERT(!memcmp(&fpu.fprs, regs_null, sizeof(fpu.fprs)), "fprs == 0");
>>> +}
>>> +
>>> +static void assert_initial(void)
>>> +{
>>> +	struct kvm_sregs sregs;
>>> +	struct kvm_fpu fpu;
>>> +
>>> +	vcpu_sregs_get(vm, VCPU_ID, &sregs);
>>> +	TEST_ASSERT(sregs.crs[0] == 0xE0UL, "cr0 == 0xE0");
>>> +	TEST_ASSERT(sregs.crs[14] == 0xC2000000UL, "cr14 == 0xC2000000");
>>> +	TEST_ASSERT(!memcmp(&sregs.crs[1], regs_null, sizeof(sregs.crs[1]) * 12),
>>> +		    "cr1-13 == 0");
>>> +	TEST_ASSERT(sregs.crs[15] == 0, "cr15 == 0");
>>> +
>>> +	vcpu_fpu_get(vm, VCPU_ID, &fpu);
>>> +	TEST_ASSERT(!fpu.fpc, "fpc == 0");
>>> +
>>> +	test_one_reg(KVM_REG_S390_GBEA, 1);
>>> +	test_one_reg(KVM_REG_S390_PP, 0);
>>> +	test_one_reg(KVM_REG_S390_TODPR, 0);
>>> +	test_one_reg(KVM_REG_S390_CPU_TIMER, 0);
>>> +	test_one_reg(KVM_REG_S390_CLOCK_COMP, 0);
>>> +}
>>> +
>>> +static void assert_normal(void)
>>> +{
>>> +	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
>>> +}
>>> +
>>> +static void test_normal(void)
>>> +{
>>> +	printf("Testing notmal reset\n");
>>> +	/* Create VM */
>>> +	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
>>> +	run = vcpu_state(vm, VCPU_ID);
>>> +	regs = &run->s.regs;
>>> +
>>> +	_vcpu_run(vm, VCPU_ID);
>>
>> Could you use vcpu_run() instead of _vcpu_run() ?
> 
> Done.
> 
>>
>>> +	vcpu_ioctl(vm, VCPU_ID, KVM_S390_NORMAL_RESET, 0);
>>> +	assert_normal();
>>> +	kvm_vm_free(vm);
>>> +}
>>> +
>>> +static int test_initial(void)
>>> +{
>>> +	int rv;
>>> +
>>> +	printf("Testing initial reset\n");
>>> +	/* Create VM */
>>> +	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
>>> +	run = vcpu_state(vm, VCPU_ID);
>>> +	regs = &run->s.regs;
>>> +
>>> +	rv = _vcpu_run(vm, VCPU_ID);
>>
>> Extra bonus points if you check here that the registers contain the
>> values that have been set by the guest ;-)
> 
> I started working on that yesterday
> 
>>
>>> +	vcpu_ioctl(vm, VCPU_ID, KVM_S390_INITIAL_RESET, 0);
>>> +	assert_normal();
>>> +	assert_initial();
>>> +	kvm_vm_free(vm);
>>> +	return rv;
>>> +}
>>> +
>>> +static int test_clear(void)
>>> +{
>>> +	int rv;
>>> +
>>> +	printf("Testing clear reset\n");
>>> +	/* Create VM */
>>> +	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
>>> +	run = vcpu_state(vm, VCPU_ID);
>>> +	regs = &run->s.regs;
>>> +
>>> +	rv = _vcpu_run(vm, VCPU_ID);
>>> +
>>> +	vcpu_ioctl(vm, VCPU_ID, KVM_S390_CLEAR_RESET, 0);
>>> +	assert_normal();
>>> +	assert_initial();
>>> +	assert_clear();
>>> +	kvm_vm_free(vm);
>>> +	return rv;
>>> +}
>>> +
>>> +int main(int argc, char *argv[])
>>> +{
>>> +	int addl_resets;
>>> +
>>> +	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
>>> +	addl_resets = kvm_check_cap(KVM_CAP_S390_VCPU_RESETS);
>>> +
>>> +	test_initial();
>>> +	if (addl_resets) {
>>
>> I think you could still fit this into one line, without the need to
>> declare the addl_resets variable:
> 
> The other question is if we still need to check that if the test is
> bundled with the kernel anyway?

For brand new capabilities, I think it would be nice to have the check,
in case somebody (like me) wants to backport the test to slightly older
kernels. For capabilities that have been in the kernel since a long time
(like the IRQ caps in the next patch), I think you can also skip the check.

 Thomas

