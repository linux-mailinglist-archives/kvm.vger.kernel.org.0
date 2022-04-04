Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093364F1BB1
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380955AbiDDVWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379350AbiDDRBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:01:50 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8548C3FD99;
        Mon,  4 Apr 2022 09:59:53 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nbQ3J-0002uy-3w; Mon, 04 Apr 2022 18:59:41 +0200
Message-ID: <eecfc868-d217-198f-5752-3f59aad59de6@maciej.szmigiero.name>
Date:   Mon, 4 Apr 2022 18:59:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 8/8] KVM: selftests: nSVM: Add svm_nested_soft_inject_test
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-9-seanjc@google.com>
 <2401bf729beab6d9348fda18f55e90ed9c1f7583.camel@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <2401bf729beab6d9348fda18f55e90ed9c1f7583.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4.04.2022 14:27, Maxim Levitsky wrote:
> On Sat, 2022-04-02 at 01:09 +0000, Sean Christopherson wrote:
>> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>>
>> Add a KVM self-test that checks whether a nSVM L1 is able to successfully
>> inject a software interrupt and a soft exception into its L2 guest.
>>
>> In practice, this tests both the next_rip field consistency and
>> L1-injected event with intervening L0 VMEXIT during its delivery:
>> the first nested VMRUN (that's also trying to inject a software interrupt)
>> will immediately trigger a L0 NPF.
>> This L0 NPF will have zero in its CPU-returned next_rip field, which if
>> incorrectly reused by KVM will trigger a #PF when trying to return to
>> such address 0 from the interrupt handler.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   tools/testing/selftests/kvm/.gitignore        |   1 +
>>   tools/testing/selftests/kvm/Makefile          |   1 +
>>   .../selftests/kvm/include/x86_64/svm_util.h   |   2 +
>>   .../kvm/x86_64/svm_nested_soft_inject_test.c  | 147 ++++++++++++++++++
>>   4 files changed, 151 insertions(+)
>>   create mode 100644 tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
>>
(..)
>> diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
>> new file mode 100644
>> index 000000000000..d39be5d885c1
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
>> @@ -0,0 +1,147 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2022 Oracle and/or its affiliates.
>> + *
>> + * Based on:
>> + *   svm_int_ctl_test
>> + *
>> + *   Copyright (C) 2021, Red Hat, Inc.
>> + *
>> + */
>> +
>> +#include "test_util.h"
>> +#include "kvm_util.h"
>> +#include "processor.h"
>> +#include "svm_util.h"
>> +
>> +#define VCPU_ID		0
>> +#define INT_NR			0x20
>> +#define X86_FEATURE_NRIPS	BIT(3)
>> +
>> +#define vmcall()		\
>> +	__asm__ __volatile__(	\
>> +		"vmmcall\n"	\
>> +		)
>> +
>> +#define ud2()			\
>> +	__asm__ __volatile__(	\
>> +		"ud2\n"	\
>> +		)
>> +
>> +#define hlt()			\
>> +	__asm__ __volatile__(	\
>> +		"hlt\n"	\
>> +		)
> 
> Minor nitpick: I guess it would be nice to put these in some common header file.

Will move these to include/x86_64/processor.h (that's probably the most
matching header file).

>> +
>> +static void l1_guest_code(struct svm_test_data *svm)
>> +{
>> +	#define L2_GUEST_STACK_SIZE 64
>> +	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
>> +	struct vmcb *vmcb = svm->vmcb;
>> +
>> +	/* Prepare for L2 execution. */
>> +	generic_svm_setup(svm, l2_guest_code,
>> +			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
>> +
>> +	vmcb->control.intercept_exceptions |= BIT(PF_VECTOR) | BIT(UD_VECTOR);
>> +	vmcb->control.intercept |= BIT(INTERCEPT_HLT);
>> +
>> +	vmcb->control.event_inj = INT_NR | SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_SOFT;
>> +	/* The return address pushed on stack */
>> +	vmcb->control.next_rip = vmcb->save.rip;
> 
> I'll would be putting even something more spicy here just to see that KVM preserves this field
> like say put two ud2 in the start of guest code, and here have
> 
> vmcb->control.next_rip = vmcb->save.rip + 4; // skip over two ud2 instructions.
> 
> That way KVM won't be able to skip over a single instruction to get correct next_rip

Good point, will add these two additional ud2s at the start of L2 guest code.

> 
> 
> Other that nitpicks:
> 
> Reviewed-by: Maxim levitsky <mlevitsk@redhat.com>
> 
> Best regards,
> 	Maxim Levitsky
> 
> 

Thanks,
Maciej
