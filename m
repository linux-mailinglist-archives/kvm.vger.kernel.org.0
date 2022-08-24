Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2027E5A0364
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 23:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiHXVtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 17:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiHXVtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 17:49:23 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD00620A
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 14:49:21 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oQyFT-00GvKd-3i; Wed, 24 Aug 2022 23:49:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=eHgommjf2h7GBOukRi97jsdSDkdqQqF0uiaRunyg2LM=; b=jHrbS8wvkAad1QMu8tSqyiYY9G
        iiN2dCtpAxvl8ITDgZ8s7OIhScLa5yiGL2h4O1OVjigAwx2M1HyIUkARN4YSAvZULAEnkxOT+eMFl
        jy3PfOk5MTEdmXZvBNd0NYaSn7ZRVpcDpyDNo/2L+Rs88QYr/2031ER56YdfgMYKIHjucbqaHP6Bu
        5A4PcobsGGaRxQIhglaOOEKra7FBj6bSifNYeMh/EqTIG03eqeiwm7XOGpIXkS3FQbxq9hxiM2rqw
        fa6a/5FIH2gK0gBtWi7nix1jr9Cq8AftSm62rlwiAMzMw31kgeYpnl6eOHKvzaUQy5R+83mSUAyqk
        UvKQVzdg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oQyFS-0000dR-JJ; Wed, 24 Aug 2022 23:49:18 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oQyFI-0007uH-20; Wed, 24 Aug 2022 23:49:08 +0200
Message-ID: <69d74e6a-dd6b-28bb-8011-e204d4ab0253@rbox.co>
Date:   Wed, 24 Aug 2022 23:49:06 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test POP-SS blocking
Content-Language: pl-PL
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20220821215900.1419215-1-mhal@rbox.co>
 <20220821220647.1420411-1-mhal@rbox.co>
 <9b853239-a3df-f124-e793-44cbadfbbd8f@rbox.co> <YwOj6tzvIoG34/sF@google.com>
 <6d19f78f-120a-936b-3eba-e949ecc3509f@rbox.co> <YwZu1K5Rgb1sevsy@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <YwZu1K5Rgb1sevsy@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/22 20:32, Sean Christopherson wrote:
> Eh, let's completely skip usermode for code #DBs and not tweak __run_single_step_db_test().
> It's easier to just have a standalone function.

Something like this?

static void test_pop_ss_code_db(bool fep_available)
{
	write_ss(KERNEL_DS);

	write_dr7(DR7_FIXED_1 |
		  DR7_ENABLE_DRx(0) |
		  DR7_EXECUTE_DRx(0) |
		  DR7_LEN_1_DRx(0));

#define POPSS_DB(desc, fep1, fep2)				\
({								\
	unsigned int r;						\
								\
	n = 0;							\
	asm volatile(/* jump to 32-bit code segment */		\
		     "ljmp *1f\n\t"				\
		     "1:\n\t"					\
		     "	.long 2f\n\t"				\
		     "	.word " xstr(KERNEL_CS32) "\n\t"	\
		     /* exercise POP SS blocking */		\
		     ".code32\n\t"				\
		     "2: lea 3f, %0\n\t"			\
		     "mov %0, %%dr0\n\t"			\
		     "push %%ss\n\t"				\
		     fep1 "pop %%ss\n\t"			\
		     fep2 "3: xor %0, %0\n\t"			\
		     /* back to long mode */			\
		     "ljmp %[cs64], $4f\n\t"			\
		     ".code64\n\t"				\
		     "4:"					\
		     : "=R" (r)					\
		     : [cs64] "i" (KERNEL_CS64)			\
		     : "memory");				\
								\
	report(!n && !r, desc ": #DB suppressed after POP SS"); \
})

	POPSS_DB("no fep", "", "");
	if (fep_available) {
		POPSS_DB("fep POP-SS", KVM_FEP, "");
		POPSS_DB("fep XOR", "", KVM_FEP);
		POPSS_DB("fep POP-SS/fep XOR", KVM_FEP, KVM_FEP);
	}

	write_dr7(DR7_FIXED_1);
}

Results:

em_pop_sreg unpatched
PASS: no fep: #DB suppressed after POP SS
FAIL: fep POP-SS: #DB suppressed after POP SS
PASS: fep XOR: #DB suppressed after POP SS
PASS: fep POP-SS/fep XOR: #DB suppressed after POP SS

em_pop_sreg patched
PASS: no fep: #DB suppressed after POP SS
PASS: fep POP-SS: #DB suppressed after POP SS
PASS: fep XOR: #DB suppressed after POP SS
PASS: fep POP-SS/fep XOR: #DB suppressed after POP SS

thanks,
Michal
