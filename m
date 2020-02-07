Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A39F3155568
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 11:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgBGKQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 05:16:05 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50655 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726587AbgBGKQF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 05:16:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581070563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sAtq39YosfHmZJxK5UhNNcUku/GZXmkz5H1802fMXAM=;
        b=Yqacl5ClP7+ioTSwahzWUGZXZ48BPqwwdGwShNY+vKa5fWSqomOnXZ4xJ4DJsDKeTd5D8n
        9ajgCaGwMUDE3iO5DRya4xZdF/eP2QdKYxsae8Jx8z4T0j/A+nuy2JI/z3wsZ3oiDAF5HX
        xAhS1eM7UYkrqZiQnuAgc50LuNCGXYo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-XV0cSZK6PFigHiiSQPK9Ig-1; Fri, 07 Feb 2020 05:16:01 -0500
X-MC-Unique: XV0cSZK6PFigHiiSQPK9Ig-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95CF6800E21;
        Fri,  7 Feb 2020 10:16:00 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CF1215DA7D;
        Fri,  7 Feb 2020 10:15:56 +0000 (UTC)
Subject: Re: [PATCH v4 3/3] selftests: KVM: SVM: Add vmcall test
To:     Wei Huang <wei.huang2@amd.com>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        thuth@redhat.com, drjones@redhat.com
References: <20200206104710.16077-1-eric.auger@redhat.com>
 <20200206104710.16077-4-eric.auger@redhat.com>
 <20200206173931.GC2465308@weiserver.amd.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <130c32bc-7533-1b4e-b913-d9596ed4e94d@redhat.com>
Date:   Fri, 7 Feb 2020 11:15:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200206173931.GC2465308@weiserver.amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Wei,

On 2/6/20 6:39 PM, Wei Huang wrote:
> On 02/06 11:47, Eric Auger wrote:
>> L2 guest calls vmcall and L1 checks the exit status does
>> correspond.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
> 
> I verified this patch with my AMD box, both with nested=1 and nested=0. I
> also intentionally changed the assertion of exit_code to a different
> value (0x082) and the test complained about it. So the test is good.
> 
> # selftests: kvm: svm_vmcall_test
> # ==== Test Assertion Failure ====
> #   x86_64/svm_vmcall_test.c:64: false
> #   pid=2485656 tid=2485656 - Interrupted system call
> #      1        0x0000000000401387: main at svm_vmcall_test.c:72
> #      2        0x00007fd0978d71a2: ?? ??:0
> #      3        0x00000000004013ed: _start at ??:?
> #   Failed guest assert: vmcb->control.exit_code == SVM_EXIT_VMMCALL
> # Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> # Guest physical address width detected: 48
> not ok 15 selftests: kvm: svm_vmcall_test # exit=254

thank you for testing! May I include your T-b then?
> 
>>
>> ---
>>
>> v3 -> v4:
>> - remove useless includes
>> - collected Lin's R-b
>>
>> v2 -> v3:
>> - remove useless comment and add Vitaly's R-b
>> ---
>>  tools/testing/selftests/kvm/Makefile          |  1 +
>>  .../selftests/kvm/x86_64/svm_vmcall_test.c    | 79 +++++++++++++++++++
>>  2 files changed, 80 insertions(+)
>>  create mode 100644 tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
>>
>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
>> index 2e770f554cae..b529d3b42c02 100644
>> --- a/tools/testing/selftests/kvm/Makefile
>> +++ b/tools/testing/selftests/kvm/Makefile
>> @@ -26,6 +26,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
>>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>>  TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
>> +TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
>>  TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>>  TEST_GEN_PROGS_x86_64 += dirty_log_test
>>  TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
>> diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
>> new file mode 100644
>> index 000000000000..6d3565aab94e
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> 
> Probably rename the file to svm_nested_vmcall_test.c. This matches with
> the naming convention of VMX's nested tests. Otherwise people might not know
> it is a nested one.

From what I understand, all the vmx_* (including vmx_tsc_adjust_test for
instance) are related to nested. So I'd rather leave svm_ prefix for
nested SVM.

Thanks

Eric
> 
> Everything else looks good.
> 
>> @@ -0,0 +1,79 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * svm_vmcall_test
>> + *
>> + * Copyright (C) 2020, Red Hat, Inc.
>> + *
>> + * Nested SVM testing: VMCALL
>> + */
>> +
>> +#include "test_util.h"
>> +#include "kvm_util.h"
>> +#include "processor.h"
>> +#include "svm_util.h"
>> +
>> +#define VCPU_ID		5
>> +
>> +static struct kvm_vm *vm;
>> +
>> +static inline void l2_vmcall(struct svm_test_data *svm)
>> +{
>> +	__asm__ __volatile__("vmcall");
>> +}
>> +
>> +static void l1_guest_code(struct svm_test_data *svm)
>> +{
>> +	#define L2_GUEST_STACK_SIZE 64
>> +	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
>> +	struct vmcb *vmcb = svm->vmcb;
>> +
>> +	/* Prepare for L2 execution. */
>> +	generic_svm_setup(svm, l2_vmcall,
>> +			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
>> +
>> +	run_guest(vmcb, svm->vmcb_gpa);
>> +
>> +	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
>> +	GUEST_DONE();
>> +}
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	vm_vaddr_t svm_gva;
>> +
>> +	nested_svm_check_supported();
>> +
>> +	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
>> +	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
>> +
>> +	vcpu_alloc_svm(vm, &svm_gva);
>> +	vcpu_args_set(vm, VCPU_ID, 1, svm_gva);
>> +
>> +	for (;;) {
>> +		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
>> +		struct ucall uc;
>> +
>> +		vcpu_run(vm, VCPU_ID);
>> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
>> +			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
>> +			    run->exit_reason,
>> +			    exit_reason_str(run->exit_reason));
>> +
>> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
>> +		case UCALL_ABORT:
>> +			TEST_ASSERT(false, "%s",
>> +				    (const char *)uc.args[0]);
>> +			/* NOT REACHED */
>> +		case UCALL_SYNC:
>> +			break;
>> +		case UCALL_DONE:
>> +			goto done;
>> +		default:
>> +			TEST_ASSERT(false,
>> +				    "Unknown ucall 0x%x.", uc.cmd);
>> +		}
>> +	}
>> +done:
>> +	kvm_vm_free(vm);
>> +	return 0;
>> +}
> 
> 

