Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30D659CD15
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 02:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239033AbiHWAQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 20:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239029AbiHWAQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 20:16:52 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB06CC02
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:16:49 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oQHb4-00Bkgy-HL; Tue, 23 Aug 2022 02:16:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=HTJw75iycaZewoe7HywmIg0hisjG3sBsQG26be+L0q8=; b=jlNnHVuvCiNcnsyyGriOMsaqpz
        pAH0WIPwo2OmhNHLgiNsvw+dqFXO+wWsm2Qd/p9CK74vKwy7pU7tmTIxLglkzukyHs3HcHA+7NeSM
        iVDoRb55bvLqnyG+ais3DIzctBSSWvMVzl0utDeJ0wHaWFMzjpkrzSGH+ADQUCoPU1P5+ivA+OEwR
        3+bdvKZoVqdlpShNlu3K7htO7kSGGVLqvW30gbN0ozRwVaVKvSOacsCZK/pO068f4h9siWTlBNuBd
        zGr6psgCD7CwskJ7ShlH38mKwBm83gRirX1X3NwqTKDshyZx99iG5ownwWaZCGUr8rKIPle2oYm1D
        ByBg3T6Q==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oQHb4-0002t9-5X; Tue, 23 Aug 2022 02:16:46 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oQHal-0003Bo-78; Tue, 23 Aug 2022 02:16:27 +0200
Message-ID: <6d19f78f-120a-936b-3eba-e949ecc3509f@rbox.co>
Date:   Tue, 23 Aug 2022 02:16:25 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test POP-SS blocking
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20220821215900.1419215-1-mhal@rbox.co>
 <20220821220647.1420411-1-mhal@rbox.co>
 <9b853239-a3df-f124-e793-44cbadfbbd8f@rbox.co> <YwOj6tzvIoG34/sF@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <YwOj6tzvIoG34/sF@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/22/22 17:42, Sean Christopherson wrote:
>> On 8/22/22 00:06, Michal Luczaj wrote:
>> test can be simplified to something like
>>
>> 	asm volatile("push %[ss]\n\t"
>> 		     __ASM_TRY(KVM_FEP "pop %%ss", "1f")
>> 		     "ex_blocked: mov $1, %[success]\n\t"
> 
> So I'm 99% certain this only passes because KVM doesn't emulate the `mov $1, %[success]`.
> kvm_vcpu_check_code_breakpoint() honors EFLAGS.RF, but not MOV/POP_SS blocking.
> I.e. I would expect this to fail if the `mov` were also tagged KVM_FEP.

I wasn't sure if I understood you correctly, so, FWIW, I've ran:

static void test_pop_ss_blocking_try(void)
{
	int success;

	write_dr7(DR7_FIXED_1 |
		  DR7_GLOBAL_ENABLE_DRx(0) |
		  DR7_EXECUTE_DRx(0) |
		  DR7_LEN_1_DRx(0));

#define POPSS(desc, fep1, fep2)					\
	asm volatile("mov $0, %[success]\n\t"			\
		     "lea 1f, %%eax\n\r"			\
		     "mov %%eax, %%dr0\n\r"			\
		     "push %%ss\n\t"				\
		     __ASM_TRY(fep1 "pop %%ss", "2f")		\
		     "1:" fep2 "mov $1, %[success]\n\t"		\
		     "2:"					\
		     : [success] "=g" (success)			\
		     :						\
		     : "eax", "memory");			\
	report(success, desc ": #DB suppressed after POP SS")

	POPSS("no fep", "", "");
	POPSS("fep pop-ss", KVM_FEP, "");
	POPSS("fep mov-1", "", KVM_FEP);
	POPSS("fep pop-ss/fep mov-1", KVM_FEP, KVM_FEP);

	write_dr7(DR7_FIXED_1);
}

and got:

em_pop_sreg unpatched:
PASS: no fep: #DB suppressed after POP SS
FAIL: fep pop-ss: #DB suppressed after POP SS
PASS: fep mov-1: #DB suppressed after POP SS
FAIL: fep pop-ss/fep mov-1: #DB suppressed after POP SS

em_pop_sreg patched:
PASS: no fep: #DB suppressed after POP SS
PASS: fep pop-ss: #DB suppressed after POP SS
PASS: fep mov-1: #DB suppressed after POP SS
PASS: fep pop-ss/fep mov-1: #DB suppressed after POP SS

For the sake of completeness: basically the same, but MOV SS, i.e.

	asm volatile("mov $0, %[success]\n\t"			\
		     "lea 1f, %%eax\n\r"			\
		     "mov %%eax, %%dr0\n\r"			\
		     "mov %%ss, %%eax\n\t"			\
		     __ASM_TRY(fep1 "mov %%eax, %%ss", "2f")	\
		     "1:" fep2 "mov $1, %[success]\n\t"		\
		     "2:"					\
		     : [success] "=g" (success)			\
		     :						\
		     : "eax", "memory");			\

PASS: no fep: #DB suppressed after MOV SS
PASS: fep mov-ss: #DB suppressed after MOV SS
PASS: fep mov-1: #DB suppressed after MOV SS
PASS: fep mov-ss/fep mov-1: #DB suppressed after MOV SS

> The reason I say the setup_idt() change is a moot point is because I think it
> would be better to put this testcase into debug.c (where "this" testcase is really
> going to be multiple testcases).  With macro shenanigans (or code patching), it
> should be fairly easy to run all testcases with both FEP=0 and FEP=1.
>
> Then it's "just" a matter of adding a code #DB testcase.  __run_single_step_db_test()
> and run_ss_db_test() aren't fundamentally tied to single-step, i.e. can simply be
> renamed.  For simplicity, I'd say just skip the usermode test for code #DBs, IMO
> it's not worth the extra coverage.

So that would involve a 32-bit segment for POP SS and making use of DR0/DR7 instead
of single stepping? I guess I can try.

Thanks,
Michal
