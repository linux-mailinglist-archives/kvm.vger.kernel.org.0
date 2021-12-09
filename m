Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1600C46F5C9
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 22:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhLIVSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 16:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbhLIVSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 16:18:47 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CA8C061746
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 13:15:07 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so7938645pjb.2
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 13:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nOMQQ7o+O1HM3alRtAPQ7TKI8XUGevsRU4QJOxbxMbk=;
        b=Y0eHD92Po7RcvR7gD7yafJiHbtBClnrGvMDHU8QTaUdqPENx4bNYP6m1ymy7wGBGkF
         YQbvU3A03RK38wj890YC2khVJi8Blw4oyej9GmiUiTLT9UAC52jyQejjgJLyEjqlh6jh
         mhbZrLITHd3M4sO2AYQbGgfoUmFDgiVjq94JJVz8X4QibSGRBMIgPD7LfMnEz32OmT2E
         snlBtXb8NKkP/peJ29zem8gEQY6pzEyWhP14Zo2E50dQeXj4Gt3suM3qpSUMWhLOj1vb
         9fh7+SQ/FEAHz5x9MsBIhdl4bgjxk6jqci4htEoks8c3Q8SX93pNysFnxCxfCLekH82y
         5acg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nOMQQ7o+O1HM3alRtAPQ7TKI8XUGevsRU4QJOxbxMbk=;
        b=MMfruVFwzHdfPCgFZkKezaeYpio9sWQEE5Pl/CnfRQObZ2TfKjQG4zA7bRo4Kselbg
         0HzQBk6GnsFGRh4T52/vH2hrxbVXuugdqgyNh1n4odVXNu0s/6oNrD6SRHrRcvqMQKAV
         +ulD4UwBiXAIsnm6piVFiPaEAZOekidLX5wFJ5pDvISXONzwV2lWbXNtezQmGfZ53e02
         3A63ypI4C3iYLZxs0Tnq4szkGWwyPBJrX++IEiT5VCDhZ6qnBuXw7gghi1CeQbg2Rw+n
         2QvkOPUxYretgZ4JNFnfywOGeZe7CT0I3VU7wi8QplcREmYE1LfDfFtR3xiTRFSGvOyO
         Ocug==
X-Gm-Message-State: AOAM5327k6LXxTXAJPAPOCK1KFVoHZ5/BHoBPlPa7bjAOQnFVN8nhuPC
        VWqqEu7ecNuPIt/syBqakFv6VA==
X-Google-Smtp-Source: ABdhPJwlZxsqXaTDpgWiAf9nh+/xFEW+NsCZ6mKVLa5Kdt2QtFHdY4Lr8R3cVFFkOo50R0LE7FREBw==
X-Received: by 2002:a17:902:9888:b0:142:8731:4b55 with SMTP id s8-20020a170902988800b0014287314b55mr70481944plp.51.1639084506732;
        Thu, 09 Dec 2021 13:15:06 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a3sm467040pgb.85.2021.12.09.13.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 13:15:06 -0800 (PST)
Date:   Thu, 9 Dec 2021 21:15:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Add test coverage for the
 routing logic when exceptions occur in L2
Message-ID: <YbJx1iB9ZowrVcuF@google.com>
References: <20211209182624.2316453-1-aaronlewis@google.com>
 <20211209182624.2316453-4-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209182624.2316453-4-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021, Aaron Lewis wrote:
> +static void vmx_exception_test_guest(void)
> +{
> +	handler old_gp = handle_exception(GP_VECTOR, vmx_exception_handler_gp);
> +	handler old_ud = handle_exception(UD_VECTOR, vmx_exception_handler_ud);
> +	handler old_de = handle_exception(DE_VECTOR, vmx_exception_handler_de);
> +	handler old_db = handle_exception(DB_VECTOR, vmx_exception_handler_db);
> +	handler old_bp = handle_exception(BP_VECTOR, vmx_exception_handler_bp);
> +	bool raised_vector = false;
> +	u64 old_cr0, old_rflags;
> +
> +	asm volatile (
> +		/* Return to L1 before starting the tests. */
> +		"vmcall\n\t"
> +
> +		/* #GP handled by L2*/
> +		"mov %[val], %%cr0\n\t"
> +		"vmx_exception_test_skip_gp:\n\t"
> +		"vmcall\n\t"
> +
> +		/* #GP handled by L1 */
> +		"mov %[val], %%cr0\n\t"

I would strongly prefer each of these be a standalone subtest in the sense that
each test starts from a clean state, configures the environment as need, then
triggers the exception and checks the results.  I absolutely detest the tests
that string a bunch of scenarios together, they inevitably accrue subtle dependencies
between scenarios and are generally difficult/annoying to debug.

Having a gigantic asm blob is also unnecessary.  #GP can be generated with a
non-canonical access purely in C.  Ditto for #AC though that may or may not be
more readable.  #DE probably requires assembly to avoid compiler intervention.
#UD and #BP should be short and sweet.  E.g.

It should be fairly straightforward to create a framework to handle running each
test, a la the vmx_tests array.  E.g. something like the below (completely untested).
This way there's no need to skip instructions, thus no need for a exposing a bunch
of labels.  Each test is isolated, there's no code pairing between L0 and L1/L2, and
adding new tests or running a specific test is trivial.

static u8 vmx_exception_test_vector;

static void vmx_exception_handler(struct ex_regs *regs)
{
        report(regs->vector == vmx_exception_test_vector,
               "Handling %s in L2's exception handler",
               exception_mnemonic(vmx_exception_test_vector));
}

static void vmx_gp_test_guest(void)
{
	*(volatile u64 *)NONCANONICAL = 0;
}

static void handle_exception_in_l2(u8 vector)
{
	handler old_handler = handle_exception(vector, vmx_exception_handler);
	u32 old_eb = vmcs_read(EXC_BITMAP);

	vmx_exception_test_vector = vector;

	vmcs_write(EXC_BITMAP, old_eb & ~(1u << vector));

	enter_guest();
	report(vmcs_read(EXI_REASON) == VMX_VMCALL,
	       "%s handled by L2", exception_mnemonic(vector));

	vmcs_write(EXC_BITMAP, old_eb);
	handle_exception(old_handler);
}

static void handle_exception_in_l1(u32 vector, const char *vector_name)
{
	u32 old_eb = vmcs_read(EXC_BITMAP);

	vmx_exception_test_vector = 0xff;

	vmcs_write(EXC_BITMAP, old_eb | (1u << vector));

	enter_guest();
	report((vmcs_read(EXI_REASON) == VMX_EXC_NMI) &&
	       ((vmcs_read(EXI_INTR_INFO) & 0xff) == vector),
	       "%s handled by L1", exception_mnemonic(vector));

	vmcs_write(EXC_BITMAP, old_eb);
}

struct vmx_exception_test {
	u8 vector;
	void (*guest_code)(void);
}

struct vmx_exception_test vmx_exception_tests[] {
	{ GP_VECTOR, vmx_gp_test_guest },
};

static void vmx_exception_test(void)
{
	struct vmx_exception_test *t;
	handler old_ex;

	enter_guest();
	assert_exit_reason(VMX_VMCALL);
	skip_exit_insn();

	for (i = 0; i < ARRAY_SIZE(vmx_exception_tests); i++) {
		t = &vmx_exception_tests[i];

		test_set_guest(t->guest_code);

		handle_exception_in_l2(t->vector);
		handle_exception_in_l1(t->vector);
	}
}

