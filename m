Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BF75E565C
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 00:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiIUWwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 18:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiIUWwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 18:52:43 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC3FA2848
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 15:52:42 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id v1so7084886plo.9
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 15:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=S3hwfKvotVXsthfCnxkxJbZinClhF0B7HMknMNXolO0=;
        b=LMt/PzB+ynhMDVTJGXdJP5bVpTZg4kePhiSSgzehGwKZs1xlYsxqcHH4nsbJG1FB4L
         lJLuYpg6kWRiUTy/ovhiLC5ZIZYW7KRTdBszisRPeoXbH3lgrFzovwH6FicYauihSi7G
         OJB5SjOyMhJEJiOXDnuFOQaThh0ffZRegaDMWvUuN72PluWjWsL9anHFNKm4boZ4W2x0
         vh6EyAgrCGyWUGJ7f/n0RLLhwxtJ0sDfHwoAUMP9Qt5PjRN4B+5YGs+hLRp39BmUvZ8+
         8JhNGft43mmZl1/5Ezw6zBL0B1xV4g5TTJqBonSqClmiDOXb29qMxmbW5JMkYD/krz4Y
         XoZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=S3hwfKvotVXsthfCnxkxJbZinClhF0B7HMknMNXolO0=;
        b=JIGczEnXDIpaGJFpFoSWu9+hfnmojMtqoLhJIWrxelKqBscP+HLExYkmFNtbfk19No
         sOuFuAdVhq+99ogumJo3i9DoNfzWa6MMuxjHZ+Ewvdx80P7jukzzKj/qGi0xsKFlYiZm
         9jPvUDQdG3xODJ8hFinudb9v1x5sCH2jJ1pMJoY7tYVXpKom4Jp2F2i+llpY5RPengfO
         HhmbChfXydMZpWi/L3d30vxdeli4VWWujzJKr6BVPWyxfTy3vUiIPhq06P22oi5jFl7q
         SdjtbV2+WSNBjqwB/nw44UnrNmP2oPHpiQGsn3JFKRsvOj3EI6RjT12dRrjYzHX/CsJO
         sPCQ==
X-Gm-Message-State: ACrzQf06Y7HRltZwvxkwa77N3xoi6NhUkUXG0B2+urpL7OwnKVVbM1Ei
        u6gTJY+42kLmnoSheNKSINQKog==
X-Google-Smtp-Source: AMsMyM4JQyt8CDl8rUdZX0cVMhZDqQTD6flVYpXf46pDsc+IfoHNzZ2Ketv34Q5sLeWOkVDC6fXRnw==
X-Received: by 2002:a17:902:db0f:b0:176:e70f:6277 with SMTP id m15-20020a170902db0f00b00176e70f6277mr457269plx.13.1663800762099;
        Wed, 21 Sep 2022 15:52:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r26-20020a63441a000000b0042b5095b7b4sm2501018pga.5.2022.09.21.15.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 15:52:41 -0700 (PDT)
Date:   Wed, 21 Sep 2022 22:52:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 30/39] KVM: selftests: Hyper-V PV TLB flush selftest
Message-ID: <YyuVtrpQwZGHs4ez@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-31-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921152436.3673454-31-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
> +/* 'Worker' vCPU code checking the contents of the test page */
> +static void worker_guest_code(vm_vaddr_t test_data)
> +{
> +	struct test_data *data = (struct test_data *)test_data;
> +	u32 vcpu_id = rdmsr(HV_X64_MSR_VP_INDEX);
> +	unsigned char chr_exp1, chr_exp2, chr_cur;

Any reason for "unsigned char" over uint8_t?

And the "chr_" prefix is rather weird, IMO it just makes the code harder to read.

Actually, why a single char?  E.g. why not do a uint64_t?  Oooh, because the
offset is only by vcpu_id, not by vcpu_id * PAGE_SIZE.  Maybe add a comment about
that somewhere?

> +
> +	x2apic_enable();
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
> +
> +	for (;;) {
> +		/* Read the expected char, then check what's in the test pages and then
> +		 * check the expectation again to make sure it wasn't updated in the meantime.

Please wrap at the soft limit.

> +		 */

Except for apparently networking, kernel preferred style for block comments is:

		/*
		 * This comment is for KVM.
		 */

> +		chr_exp1 = READ_ONCE(*(unsigned char *)
> +				     (data->test_pages + PAGE_SIZE * NTEST_PAGES + vcpu_id));

Use a local variable for the pointer, then these line lengths are much more sane.
Hmm, and if you give them descriptive names, I think it will make the code much
easier to follow.  E.g. I've been staring at this test for ~10 minutes and am still
not entirely sure what shenanigans are going on.

> +		asm volatile("lfence");

The kernel versions of these are provided by tools/arch/x86/include/asm/barrier.h,
which I think is available?  I forget if we can use those in the selftests mess.

Regardless, this needs a comment explaining why LFENCE/rmb() is needed, and why
the writer needs MFENCE/mb().

> +		chr_cur = *(unsigned char *)data->test_pages;

READ_ONCE()?

> +		asm volatile("lfence");
> +		chr_exp2 = READ_ONCE(*(unsigned char *)
> +				     (data->test_pages + PAGE_SIZE * NTEST_PAGES + vcpu_id));
> +		if (chr_exp1 && chr_exp1 == chr_exp2)

IIUC, the "chr_exp1 != 0" check is the read side of "0 == disable".  Splitting
that out and adding a comment would be helpful.

And if a local variable is used to hold the pointer, there's no need for an "exp2"
variable.

> +			GUEST_ASSERT(chr_cur == chr_exp1);
> +		asm volatile("nop");

Use cpu_relax(), which KVM selftests provide.

All in all, something like this?

	for (;;) {
		cpu_relax();

		expected = READ_ONCE(*this_vcpu);
		
		/* ??? */
		rmb();
		val = READ_ONCE(*???);
		/* ??? */
		rmb();

		/*
		 * '0' indicates the sender is between iterations, wait until
		 * the sender is ready for this vCPU to start checking again.
		 */
		if (!expected)
			continue;

		/*
		 * Re-read the per-vCPU byte to ensure the sender didn't move
		 * onto a new iteration.
		 */	
		if (expected != READ_ONCE(*this_vcpu))
			continue;
		
		GUEST_ASSERT(val == expected);
	}

> +	}
> +}
> +
> +/*
> + * Write per-CPU info indicating what each 'worker' CPU is supposed to see in
> + * test page. '0' means don't check.
> + */
> +static void set_expected_char(void *addr, unsigned char chr, int vcpu_id)
> +{
> +	asm volatile("mfence");

Why MFENCE?

> +	*(unsigned char *)(addr + NTEST_PAGES * PAGE_SIZE + vcpu_id) = chr;
> +}
> +
> +/* Update PTEs swapping two test pages */
> +static void swap_two_test_pages(vm_paddr_t pte_gva1, vm_paddr_t pte_gva2)
> +{
> +	uint64_t pte[2];
> +
> +	pte[0] = *(uint64_t *)pte_gva1;
> +	pte[1] = *(uint64_t *)pte_gva2;
> +
> +	*(uint64_t *)pte_gva1 = pte[1];
> +	*(uint64_t *)pte_gva2 = pte[0];

xchg()?  swap()?

> +}
> +
> +/* Delay */
> +static inline void rep_nop(void)

LOL, rep_nop() is a hilariously confusing function name.  "REP NOP" is "PAUSE",
and for whatever reason the kernel proper use rep_nop() as the function name for
the wrapper.  My reaction to the MFENCE+rep_nop() below was "how the hell does
MFENCE+PAUSE guarantee a delay?!?".

Anyways, why not do e.g. usleep(1)?  And if you really need a udelay() and not a
usleep(), IMO it's worth adding exactly that instead of throwing NOPs at the CPU.
E.g. aarch64 KVM selftests already implements udelay(), so adding an x86 variant
would move us one step closer to being able to use it in common tests.


> +{
> +	int i;
> +
> +	for (i = 0; i < 1000000; i++)
> +		asm volatile("nop");
> +}
> +	r = pthread_create(&threads[0], NULL, vcpu_thread, vcpu[1]);
> +	TEST_ASSERT(r == 0,

!r is preferred

> +		    "pthread_create failed errno=%d", errno);

TEST_ASSERT() already captures errno, e.g. these can be:

	TEST_ASSERT(!r, "pthread_create() failed");

> +
> +	r = pthread_create(&threads[1], NULL, vcpu_thread, vcpu[2]);
> +	TEST_ASSERT(r == 0,
> +		    "pthread_create failed errno=%d", errno);
> +
> +	while (true) {
> +		r = _vcpu_run(vcpu[0]);
> +		exit_reason = vcpu[0]->run->exit_reason;
> +
> +		TEST_ASSERT(!r, "vcpu_run failed: %d\n", r);

Pretty sure newlines in asserts aren't necessary, though I forget if they cause
weirdness or just end up being ignored.

> +		TEST_ASSERT(exit_reason == KVM_EXIT_IO,
> +			    "unexpected exit reason: %u (%s)",
> +			    exit_reason, exit_reason_str(exit_reason));
> +
> +		switch (get_ucall(vcpu[0], &uc)) {
> +		case UCALL_SYNC:
> +			TEST_ASSERT(uc.args[1] == stage,
> +				    "Unexpected stage: %ld (%d expected)\n",
> +				    uc.args[1], stage);
> +			break;
> +		case UCALL_ABORT:
> +			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
> +				  __FILE__, uc.args[1]);

			REPORT_GUEST_ASSERT(uc);
