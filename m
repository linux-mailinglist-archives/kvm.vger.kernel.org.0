Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A52728EDFC
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 09:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbgJOH4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 03:56:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28924 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729788AbgJOH4G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 03:56:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602748564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=009V89s6d6GLNb5lHrp9BOLh2KJNDGDipwZJzNijz5c=;
        b=iTENv7exTkEZDrxfDNe9ruUzfqwMVn5ntDHNHDpURFZntbbgjf1/4+c4hC3DOUgWItut2D
        U15GkJ+Wh+GUGufIPx00MEjb5OlOaW9dejmDHr68G3OabhZ5vdCmOx8UT1jrHSwN6foWzS
        Og5LqQ1jod5Wc2oMu0/xkHxJr5U2aTo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-FBDf41L-PYa4W3Iqear6nQ-1; Thu, 15 Oct 2020 03:56:00 -0400
X-MC-Unique: FBDf41L-PYa4W3Iqear6nQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E380803638;
        Thu, 15 Oct 2020 07:55:59 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-212.ams2.redhat.com [10.36.112.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B38701002C00;
        Thu, 15 Oct 2020 07:55:54 +0000 (UTC)
Subject: Re: [PATCH v1] self_tests/kvm: sync_regs and reset tests for diag318
To:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com
References: <20201014192710.66578-1-walling@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <dc00c982-8d36-3df4-f896-ebe197b97274@redhat.com>
Date:   Thu, 15 Oct 2020 09:55:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20201014192710.66578-1-walling@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/2020 21.27, Collin Walling wrote:
> The DIAGNOSE 0x0318 instruction, unique to s390x, is a privileged call
> that must be intercepted via SIE, handled in userspace, and the
> information set by the instruction is communicated back to KVM.
> 
> To test the instruction interception, an ad-hoc handler is defined which
> simply has a VM execute the instruction and then userspace will extract
> the necessary info. The handler is defined such that the instruction
> invocation occurs only once. It is up the the caller to determine how the
> info returned by this handler should be used.
> 
> The diag318 info is communicated from userspace to KVM via a sync_regs
> call. This is tested during a sync_regs test, where the diag318 info is
> requested via the handler, then the info is stored in the appropriate
> register in KVM via a sync registers call.
> 
> The diag318 info is checked to be 0 after a normal and clear reset.
> 
> If KVM does not support diag318, then the tests will print a message
> stating that diag318 was skipped, and the asserts will simply test
> against a value of 0.

Thanks a lot for writing the test! Looks pretty good already, but I still
have some comments / questions below...

> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
> @@ -0,0 +1,80 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Test handler for the s390x DIAGNOSE 0x0318 instruction.
> + *
> + * Copyright (C) 2020, IBM
> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +
> +#define VCPU_ID	5
> +
> +#define ICPT_INSTRUCTION	0x04
> +#define IPA0_DIAG		0x8300
> +
> +static void guest_code(void)
> +{
> +	uint64_t diag318_info = 0x12345678;
> +
> +	asm volatile ("diag %0,0,0x318\n" : : "d" (diag318_info));
> +}
> +
> +/*
> + * The DIAGNOSE 0x0318 instruction call must be handled via userspace. As such,
> + * we create an ad-hoc VM here to handle the instruction then extract the
> + * necessary data. It is up to the caller to decide what to do with that data.
> + */
> +static uint64_t diag318_handler(void)
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_run *run;
> +	uint64_t reg;
> +	uint64_t diag318_info;
> +
> +	vm = vm_create_default(VCPU_ID, 0, guest_code);
> +	vcpu_run(vm, VCPU_ID);
> +	run = vcpu_state(vm, VCPU_ID);
> +
> +	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
> +		    "DIAGNOSE 0x0318 instruction was not intercepted");
> +	TEST_ASSERT(run->s390_sieic.icptcode == ICPT_INSTRUCTION,
> +		    "Unexpected intercept code: 0x%x", run->s390_sieic.icptcode);
> +	TEST_ASSERT((run->s390_sieic.ipa & 0xff00) == IPA0_DIAG,
> +		    "Unexpected IPA0 code: 0x%x", (run->s390_sieic.ipa & 0xff00));
> +
> +	reg = (run->s390_sieic.ipa & 0x00f0) >> 4;
> +	diag318_info = run->s.regs.gprs[reg];
> +
> +	kvm_vm_free(vm);

Could you please add a

	TEST_ASSERT(diag_318_info == 0x12345678, ...)

here?

> +	return diag318_info;
> +}
> +
> +uint64_t get_diag318_info(void)
> +{
> +	static uint64_t diag318_info;
> +	static bool printed_skip;
> +
> +	/*
> +	 * If KVM does not support diag318, then return 0 to
> +	 * ensure tests do not break.
> +	 */
> +	if (!kvm_check_cap(KVM_CAP_S390_DIAG318)) {
> +		if (!printed_skip) {
> +			fprintf(stdout, "KVM_CAP_S390_DIAG318 not supported. "
> +				"Skipping diag318 test.\n");
> +			printed_skip = true;
> +		}
> +		return 0;
> +	}
> +
> +	/*
> +	 * If a test has previously requested the diag318 info,
> +	 * then don't bother spinning up a temporary VM again.
> +	 */
> +	if (!diag318_info)
> +		diag318_info = diag318_handler();
> +
> +	return diag318_info;
> +}
> diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
> index b143db6d8693..d0416ba94ec5 100644
> --- a/tools/testing/selftests/kvm/s390x/resets.c
> +++ b/tools/testing/selftests/kvm/s390x/resets.c
> @@ -12,6 +12,7 @@
>  
>  #include "test_util.h"
>  #include "kvm_util.h"
> +#include "diag318_test_handler.h"
>  
>  #define VCPU_ID 3
>  #define LOCAL_IRQS 32
> @@ -110,6 +111,8 @@ static void assert_clear(void)
>  
>  	TEST_ASSERT(!memcmp(sync_regs->vrs, regs_null, sizeof(sync_regs->vrs)),
>  		    "vrs0-15 == 0 (sync_regs)");
> +
> +	TEST_ASSERT(sync_regs->diag318 == 0, "diag318 == 0 (sync_regs)");
>  }
>  
>  static void assert_initial_noclear(void)
> @@ -182,6 +185,7 @@ static void assert_normal(void)
>  	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
>  	TEST_ASSERT(sync_regs->pft == KVM_S390_PFAULT_TOKEN_INVALID,
>  			"pft == 0xff.....  (sync_regs)");
> +	TEST_ASSERT(sync_regs->diag318 == 0, "diag318 == 0 (sync_regs)");
>  	assert_noirq();
>  }
>  
> @@ -206,6 +210,7 @@ static void test_normal(void)
>  	/* Create VM */
>  	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
>  	run = vcpu_state(vm, VCPU_ID);
> +	run->s.regs.diag318 = get_diag318_info();
>  	sync_regs = &run->s.regs;

Not sure, but don't you have to mark KVM_SYNC_DIAG318 in run->kvm_valid_regs
and run->kvm_dirty_regs here...

>  	vcpu_run(vm, VCPU_ID);
> @@ -250,6 +255,7 @@ static void test_clear(void)
>  	pr_info("Testing clear reset\n");
>  	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
>  	run = vcpu_state(vm, VCPU_ID);
> +	run->s.regs.diag318 = get_diag318_info();
>  	sync_regs = &run->s.regs;

... and here?

 Thomas

