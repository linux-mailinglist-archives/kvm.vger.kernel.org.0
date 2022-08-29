Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A3A5A52FE
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 19:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiH2RVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 13:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiH2RVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 13:21:11 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF496EF3F
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:21:05 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 69so6631385pgb.13
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=N8v9XiNinBwgapG6G2g4Lw1ZeaB/KtBqvxLAMxYhJZ0=;
        b=NfRnBVW89tj7Au3HywW16OEWiHNb4GaSjmEwi+NAYqoi4cwMah/XZ+pxiE6BS8poL0
         UdYe4SvnI/d5a6fn/U641J7UGrFUDWekiE8WvIqGr3l7yoGjhl7gm72dVy6sdoRFh94q
         f4HkXyu6iAPgnszZSoF+rlGzgjNO9e1M+Ibx53ObMMOboc3gEbUNQgvsg3JHyXuPgZyn
         zJMFCtgsQcBDAxXnjn8bhI7UZnooOFoaMWgwsZ0IWOUTSEnRV2f6OFgerv4vtIFcn7L2
         81VRdZ6M5MiDiQm6AgkLwtFaUIGoHu0cB47KIiWYfnZX4bDFK36L82NehZYsgO/aOq/M
         YA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=N8v9XiNinBwgapG6G2g4Lw1ZeaB/KtBqvxLAMxYhJZ0=;
        b=KuD9qHA8r3Y71hyipWcLBO1+GsUZIbBju2mPNq8ghYQS7nNOgH/Ck36LY+uleIqOPx
         ivG2d7MH3kyJ8dq9ND0Wh65XAFrXG93zsMCyTkId41COiWdJOUWuETvlT38eR7bmZ7hy
         F0ejUx4jQNSoFNTJ9soqVkgtXJLgXcoqTEWtLdybWxFpsX4zPU/7VGRXTIjDhXd5xXI1
         b36jYyqWVXZXcu0X7c24eG5St9/dokw1W14E/dbEUrcxYjvBHwkxOxFU3xStAfC34Lpv
         mDYQi29zZMppPqPodnn8KyjmQGXFJGuIf3l3rri6kVMKhk5naMTbvfFGDCRMggRcNBdI
         bekw==
X-Gm-Message-State: ACgBeo2MQhTjrONuSmpgT5vF4UMykqGp8/xSjZKHg5rNyaBAJeLzEkKx
        zLG5k/F6Kn3LPnSfjyEQMIEchg==
X-Google-Smtp-Source: AA6agR7JVkZEqiHBQMT3/HK53IbqnS0HPUadhw2Pc+wlqYBU/5llkrjsnpQV1BRpTuK0X2jptbEaPQ==
X-Received: by 2002:a05:6a00:21c2:b0:52b:ff44:6680 with SMTP id t2-20020a056a0021c200b0052bff446680mr17655948pfj.57.1661793664751;
        Mon, 29 Aug 2022 10:21:04 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902d50400b00175111a277dsm136685plg.185.2022.08.29.10.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 10:21:04 -0700 (PDT)
Date:   Mon, 29 Aug 2022 17:21:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 4/4] KVM: selftests: Test if posted interrupt delivery
 race with migration
Message-ID: <Ywz1fJlkuhY/vMEU@google.com>
References: <20220828222544.1964917-1-mizhang@google.com>
 <20220828222544.1964917-5-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220828222544.1964917-5-mizhang@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 28, 2022, Mingwei Zhang wrote:
> From: Jim Mattson <jmattson@google.com>
> 
> Test if posted interrupt delivery race with migration. Add a selftest
> to demonstrate a race condition between migration and posted
> interrupt for a nested VM. The consequence of this race condition causes
> the loss of a posted interrupt for a nested vCPU after migration and
> triggers a warning for unpatched kernel.
> 
> The selftest demonstrates that if a L2 vCPU is in halted state before
> migration, then after migration, it is not able to receive a posted
> interrupt from another vCPU within the same VM.

For tests, try to phrase the changelog in terms of what architectural behavior is
being tested, as opposed to stating what exact KVM bug is being targeted.  It's
definitely helpful to call out the KVM bug, but do that _after_ explaining the
test itself.  The problem with talking about a specific KVM bug is that 

IIUC, this can be:

  Add a test to verify that a posted interrupt wakes the target vCPU from
  a halted state if the VM is migrated while the vCPU is halted.

and then something like this to call out the known KVM bug

  This test exposes a bug where KVM checks the vAPIC page before loading
  nested pages when the vCPU is blocking.

> The fundamental problem is deeply buried in the kernel logic where
> vcpu_block() will directly check vmcs12 related mappings before having a
> valid vmcs12 ready.  Because of that, it fails to process the posted
> interrupt and triggers the warning in vmx_guest_apic_has_interrupt()
> 
> static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
> {
> 	...
> 	if (WARN_ON_ONCE(!is_guest_mode(vcpu)) ||
> 		!nested_cpu_has_vid(get_vmcs12(vcpu)) ||
> 		WARN_ON_ONCE(!vmx->nested.virtual_apic_map.gfn)) <= HERE
> 		return false;
> 	...
> }
> +static void vcpu0_ipi_handler(struct ex_regs *regs)

This needs to clarify that it's an L2 handler, that info is _extremely_ important
to understanding this sequence.  And even if that info were superfluous, it's still
a good habit to use consistent namespacing.

> +{
> +	 asm volatile("inb %%dx, %%al"
> +		      : : [port] "d" (PORT_L0_EXIT) : "rax");

Can't this use GUEST_SYNC()?

> +	asm volatile("vmcall");

A comment would be helpful, but not as necessary if this is vcpu0_l2_ipi_handler().

> +}
> +
> +static void l2_vcpu0_guest_code(void)

I have a slight preference for

	vcpu0_l2_ipi_handler()
	vcpu0_l2_guest_code()

	vcpu1_l1_guest_code()

because the "vcpu0 vs. vcpu1" is the broader scope, and then "l1 vs. l2" further
clarifies the exact scope of the function.

> +{
> +	asm volatile("cli");
> +	asm volatile("sti; nop; hlt");

What is this code trying to do?  Assuming the intent is to ensure the posted IRQ
arrives after "hlt", this needs to be:

	GUEST_ASSERT(!irqs_enabled());
	asm volatile("sti; hlt");

because if interrupts are enabled when l2_vcpu0_guest_code() starts running, then
the IRQ can arrive before CLI.  And the "nop" needs to go because the nop will
consume the STI shadow, i.e. the IRQ can arrive before the "hlt".  irqs_enabled()
needs to be defined, but it's fairly straightfoward; something like this:

static __always_inline bool irqs_enabled(void)
{
	unsigned long flags;

	asm volatile("pushf ; pop %0"
		     : "=rm" (flags)
		     :
		     : "memory");

	return flags & X86_EFLAGS_IF;
}

If my assuming is wrong, then this needs a very verbose comment.

> +static void post_intr(u8 vector, void *pi_desc)
> +{
> +       set_bit(vector, pi_desc);
> +       set_bit(PI_ON_BIT, pi_desc);
> +}
> +
> +static void l1_vcpu1_guest_code(void *vcpu0_pi_desc)
> +{
> +       post_intr(L2_INTR, vcpu0_pi_desc);

Open code post_intr() here.  I would expect a "post_intr()" helper to actually do
the notification.  Separating the two things confused me.

> +       x2apic_enable();

Why take a dependency on x2APIC?  Either way, enable x2APIC, then post the
interrupt.  Again, it's weird splitting "set info in PI descriptor" from the
notification.

> +       x2apic_write_reg(APIC_ICR, ((u64)VCPU_ID0 << 32) |
> +                        APIC_DEST_PHYSICAL | APIC_DM_FIXED | PI_NV);
> +       GUEST_DONE();
> +}

...

> +void *create_and_run_vcpu1(void *arg)
> +{
> +	struct ucall uc;
> +	struct kvm_run *run;
> +	struct kvm_mp_state vcpu0_mp_state;
> +
> +	pthread_cpu1 = pthread_self();
> +
> +	/* Keep trying to kick out vcpu0 until it is in halted state. */
> +	for (;;) {
> +		WRITE_ONCE(vcpu0_can_run, true);
> +		sleep(1);
> +		WRITE_ONCE(vcpu0_can_run, false);
> +		pthread_kill(pthread_cpu0, SIGUSR1);
> +		printf("vcpu1: Sent SIGUSR1 to vcpu0\n");

Use pr_debug(), this has the potential to spam the console.  And then probably use
pr_info() for the other printfs so that they can be turned off via QUIET.

> +
> +		while (READ_ONCE(vcpu0_running))
> +			;

vcpu0_running is unnecessary.  KVM needs to acquire vcpu->mutex to do KVM_GET_MP_STATE,
i.e. vcpu_mp_state_get() will block until KVM_RUN completes.  Nothing guarantees
vcpu0_running will be set from main() before this gets to the while-loop, so
vcpu_mp_state_get() racing with KVM_RUN is already possible.

> +
> +		vcpu_mp_state_get(vcpu0, &vcpu0_mp_state);
> +		if (vcpu0_mp_state.mp_state == KVM_MP_STATE_HALTED)
> +			break;
> +	}
> +
> +	printf("vcpu1: Kicked out vcpu0 and ensure vcpu0 is halted\n");
> +
> +	/* Use save_restore_vm() to simulate a VM migration. */
> +	save_restore_vm(vm);
> +
> +	printf("vcpu1: Finished save and restore vm.\n");

Uber nit, be consistent on whether or not the test uses punctionation.

> +	vcpu1 = vm_vcpu_add(vm, VCPU_ID1, l1_vcpu1_guest_code);
> +	vcpu_args_set(vcpu1, 1, vmx->posted_intr_desc);
> +
> +	/* Start an L1 in vcpu1 and send a posted interrupt to halted L2 in vcpu0. */
> +	for (;;) {
> +		run = vcpu1->run;
> +		vcpu_run(vcpu1);
> +
> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "vcpu1: Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
> +			    run->exit_reason,
> +			    exit_reason_str(run->exit_reason));
> +
> +		switch (get_ucall(vcpu1, &uc)) {
> +		case UCALL_ABORT:
> +			TEST_FAIL("%s", (const char *)uc.args[0]);
> +			/* NOT REACHED */

			REPORT_GUEST_ASSERT(...)

> +		case UCALL_DONE:
> +			printf("vcpu1: Successfully send a posted interrupt to vcpu0\n");
> +			goto done;
> +		default:
> +			TEST_FAIL("vcpu1: Unknown ucall %lu", uc.cmd);
> +		}
> +	}
> +
> +done:
> +	/*
> +	 * Allow vcpu0 resume execution from L0 userspace and check if the
> +	 * posted interrupt get executed.
> +	 */
> +	WRITE_ONCE(vcpu0_can_run, true);
> +	sleep(1);

What guarantees that sleep(1) is sufficient for vCPU to get back into the guest?
This might be a good candidate for a sempahore?

> +	TEST_ASSERT(READ_ONCE(pi_executed),
> +		    "vcpu0 did not execute the posted interrupt.\n");
> +
> +	return NULL;
> +}

...

> +       TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
> +       TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));

This also requires APICv / posted interrupts, and x2APIC if that hardcoded behavior
is kept.

> +	for (;;) {
> +		struct kvm_run *run = vcpu0->run;
> +		struct ucall uc;
> +		int rc;
> +
> +		while (!READ_ONCE(vcpu0_can_run))
> +			;
> +
> +		WRITE_ONCE(vcpu0_running, true);
> +
> +		rc = __vcpu_run(vcpu0);
> +
> +		vcpu0->run->immediate_exit = 0;

Why?  vcpu_run_complete_io() is the only thing that sets immediate_exit, and it
clears the flag after doing __vcpu_run().

> +
> +		/*
> +		 * When vCPU is kicked out by a signal, ensure a consistent vCPU
> +		 * state to prepare for migration before setting the
> +		 * vcpu_running flag to false.
> +		 */
> +		if (rc == -1 && run->exit_reason == KVM_EXIT_INTR) {
> +			vcpu_run_complete_io(vcpu0);
> +
> +			WRITE_ONCE(vcpu0_running, false);
> +
> +			continue;
> +		}
> +
> +		WRITE_ONCE(vcpu0_running, false);
> +
> +		if (run->io.port == PORT_L0_EXIT) {

One of the motivations for using GUEST_SYNC() instead of PORT_L0_EXIT is that
this test could (very theoretically) get a false pass if GUEST_DONE() is reached
before PORT_L0_EXIT is encountered.

> +			printf("vcpu0: Executed the posted interrupt\n");
> +			WRITE_ONCE(pi_executed, true);
> +			continue;
> +		}
> +
> +		switch (get_ucall(vcpu0, &uc)) {
> +		case UCALL_ABORT:
> +			TEST_FAIL("%s", (const char *)uc.args[0]);

			REPORT_GUEST_ASSERT(...)

> +			/* NOT REACHED */
> +		case UCALL_DONE:
> +			goto done;

Just break?

> +		default:
> +			TEST_FAIL("vcpu0: Unknown ucall %lu", uc.cmd);
> +		}
> +	}
> +
> +done:
> +	kvm_vm_free(vm);
> +	return 0;
> +}
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
