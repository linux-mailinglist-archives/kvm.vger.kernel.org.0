Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2521503B8
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 10:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgBCJ7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 04:59:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59748 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727377AbgBCJ7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 04:59:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580723991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B1NfG/wEwzb4qfvuHz92YFVlPl1qDYt7tfMRCttPhDs=;
        b=jTZr/216G/OvQ9NRmHVP3ss+2cLTmSZ3yMCLAZsFnpapvD6f/W3ylsULnMRUnLVh8lMMKz
        94TRatWqGM424zKV1oB/3GJ5QY8MF3vcn4UeANAmNCGlX1S5oWYSDKF+2RBgm5pjmamHX2
        /NuWfPT7C4CtFztfYuU4QG9eDtZewJI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-aKRMZUjMNWmebPHpb5B_3w-1; Mon, 03 Feb 2020 04:59:50 -0500
X-MC-Unique: aKRMZUjMNWmebPHpb5B_3w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48B67800D41;
        Mon,  3 Feb 2020 09:59:49 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D55FE7792E;
        Mon,  3 Feb 2020 09:59:45 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] selftests: KVM: SVM: Add vmcall test
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com,
        eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com
References: <20200203090851.19938-1-eric.auger@redhat.com>
 <20200203090851.19938-3-eric.auger@redhat.com>
 <875zgoovhx.fsf@vitty.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <f6e4a06b-8795-170a-15f4-51b58ea467c1@redhat.com>
Date:   Mon, 3 Feb 2020 10:59:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <875zgoovhx.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/3/20 10:44 AM, Vitaly Kuznetsov wrote:
> Eric Auger <eric.auger@redhat.com> writes:
> 
>> L2 guest calls vmcall and L1 checks the exit status does
>> correspond.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  tools/testing/selftests/kvm/Makefile          |  1 +
>>  .../selftests/kvm/x86_64/svm_vmcall_test.c    | 86 +++++++++++++++++++
>>  2 files changed, 87 insertions(+)
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
>> index 000000000000..75e66f3bbbc0
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
>> @@ -0,0 +1,86 @@
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
>> +#include "svm.h"
>> +
>> +#include <string.h>
>> +#include <sys/ioctl.h>
>> +
>> +#include "kselftest.h"
>> +#include <linux/kernel.h>
>> +
>> +#define VCPU_ID		5
>> +
>> +/* The virtual machine object. */
> 
> I'm not sure this comment is any helpful, the virus is probably
> spreading from vmx_close_while_nested_test.c/vmx_tsc_adjust_test.c :-)

;-)
> 
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
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks!

I will respin quickly

Eric
> 
> Thanks!
> 

