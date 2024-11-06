Return-Path: <kvm+bounces-31007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 566F59BF3E8
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:06:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 791D31C232EE
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC90206511;
	Wed,  6 Nov 2024 17:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WVoNbPpp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A48A206506
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 17:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730912804; cv=none; b=AadkzbwmLN45lVY4220Mm5CozCl2qy7dUIfT1SBr1HKeAgXdt2EPl4RFsK4pyJlHmprQPQs2SRmkgmLHFAICXWOnHjXvPxC4n78d8vTrZKzClbvHEy8gsaT+4/DddnHedWXPpr+c0y+oLrskU/oFeEnwhf8hJnUr2qTxcaZ7RD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730912804; c=relaxed/simple;
	bh=6Rf5zqPa5m3hV7JKPsCSyDllRSudKN5CTQ483bKOox4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o3SXQl4e0lkZ8N+MDvBEFHWQEp1AjraLfdvAh36PuZB0/NLQYctbcUmOPrCAfnjyTebDZqJsP+55cmjFjBVQo/SADKaSst51m4nymkG14Ve9fYsGCPbb55qeB//lPG9ZPzFZIWQuNwTlYbE+MMiu/z4G67NqcvLzvoHsu2ys3b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WVoNbPpp; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e5bdb9244eso109726737b3.2
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 09:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730912801; x=1731517601; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5t+pTmBPHbo0E/uwfzEy52VjrmqfqWmgZSSzb34Bz4w=;
        b=WVoNbPppUwP8N0xx6+U+zD/bpRPIimnYdMKeGWAo/MaBmItQyW7yYwCzDp33PxAmIE
         7sqrjittlj7swW10B26tiR8yg2LNnzdgvkidQK3a6fFVepmj7NeC+IWU7jIU9z/Xhzcz
         YEGG6mlKAE7bK/fTg3Dexqh4lRy2Oo8e57lcNUQBpqnvenNaNYFjziqsLizAMzWBL+f8
         jgT+XhH3ULLZbWflXHndn73BHVxZHeE2ftRh1DMSlOoMkWEdM+vx0GBhhBRi/MVoqQNP
         SjuOZKHebFKO1VrFW0MPfKdqWSoUiH00wsXi7sD7jJn1lYbw/w+wS5EJHV0zisFydoHi
         tqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730912801; x=1731517601;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5t+pTmBPHbo0E/uwfzEy52VjrmqfqWmgZSSzb34Bz4w=;
        b=cMqzDTg0+BQoIAgk6rdjWTWxnZST5GokVmlSa1fu0yc1hngsNgYobsBUsL/D6vKNhY
         jn0FNdktJgglNo5EcrFgp0K+ZQSM8guekLbe0QvkbjTJen8Zo90/dLaCAY+ia4tKFQmj
         HYfIoVOLnwcKNuJuDUw7W1wO0GakgeNM9n4NiwZm166i9cK4W/DEwc90JCpQv/+BX7g1
         v3ws1lbG5wSu/BiL0LSRDM6ueYJfRgk6OoT+X55WYT6HI4qnwoJLUiYnuhWvE3uxx2xN
         D2oYY0XrbwyBH0T9t2YyRxhOpjxpb1Xhi2WYUH0fPS0jG57eWKXhP2HMb/DijFqiXYu7
         MXkA==
X-Gm-Message-State: AOJu0Yz8Ch16IY5CZ0WG1JPSIDXbjPI30JAL9L5okexX/XIyfvEX26iP
	YERT0tQdaJ5eEeoNfCQ6FYasiBHhZMnD6flfJpAu4cV8ABs60foGdJaNc3Gyc0/m8Wyl/CYqhmf
	BKw==
X-Google-Smtp-Source: AGHT+IGtFenR1QTBctdMYFKBTYZG/ZO0INYKhWuvVmpVVCJ3u0Ldd1ciEKyXxUgTterH6MxTNnFNUgE23Nc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:abe9:0:b0:e30:b98d:a33d with SMTP id
 3f1490d57ef6-e30b98da4f0mr50282276.5.1730912800993; Wed, 06 Nov 2024 09:06:40
 -0800 (PST)
Date: Wed, 6 Nov 2024 09:06:39 -0800
In-Reply-To: <CAHVum0fWJW7V5ijtPcXQAtPSdoQSKjzYwMJ-XCRH2_sKs=Kg7g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240821223012.3757828-1-vipinsh@google.com> <CAHVum0eSxCTAme8=oV9a=cVaJ9Jzu3-W-3vgbubVZ2qAWVjfJA@mail.gmail.com>
 <CAHVum0fWJW7V5ijtPcXQAtPSdoQSKjzYwMJ-XCRH2_sKs=Kg7g@mail.gmail.com>
Message-ID: <ZyuiH_CVQqJUoSB-@google.com>
Subject: Re: [RFC PATCH 0/1] KVM selftests runner for running more than just default
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Anup Patel <anup@brainfault.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 01, 2024, Vipin Sharma wrote:
> Had an offline discussion with Sean, providing a summary on what we
> discussed (Sean, correct me if something is not aligned from our
> discussion):
> 
> We need to have a roadmap for the runner in terms of features we support.
> 
> Phase 1: Having a basic selftest runner is useful which can:
> 
> - Run tests parallely

Maybe with a (very conversative) per test timeout?  Selftests generally don't have
the same problems as KVM-Unit-Tests (KUT), as selftests are a little better at
guarding against waiting indefinitely, i.e. I don't think we need a configurable
timeout.  But a 120 second timeout or so would be helpful.

E.g. I recently was testing a patch (of mine) that had a "minor" bug where it
caused KVM to do a remote TLB flush on *every* SPTE update in the shadow MMU,
which manifested as hilariously long runtimes for max_guest_memory_test.  I was
_this_ close to not catching the bug (which would have been quite embarrasing),
because my hack-a-scripts don't use timeouts (I only noticed because a completely
unrelated bug was causing failures).

> - Provide a summary of what passed and failed, or only in case of failure.

I think a summary is always warranted.  And for failures, it would be helpful to
spit out _what_ test failed, versus the annoying KUT runner's behavior of stating
only the number of passes/failures, which forces the user to go spelunking just
to find out what (sub)test failed.

I also think the runner should have a "heartbeat" mechanism, i.e. something that
communicates to the user that forward progress is being made.  And IMO, that
mechanism should also spit out skips and failures (this could be optional though).
One of the flaws with the KUT runner is that it's either super noisy and super
quiet.

E.g. my mess of bash outputs this when running selftests in parallel (trimmed for
brevity):

        Running selftests with npt_disabled
        Waiting for 'access_tracking_perf_test', PID '92317'
        Waiting for 'amx_test', PID '92318'
        SKIPPED amx_test
        Waiting for 'apic_bus_clock_test', PID '92319'
        Waiting for 'coalesced_io_test', PID '92321'
        Waiting for 'cpuid_test', PID '92324'
        
        ...
        
        Waiting for 'hyperv_svm_test', PID '92552'
        SKIPPED hyperv_svm_test
        Waiting for 'hyperv_tlb_flush', PID '92563'
        FAILED hyperv_tlb_flush : ret ='254'
        Random seed: 0x6b8b4567
        ==== Test Assertion Failure ====
          x86_64/hyperv_tlb_flush.c:117: val == expected
          pid=92731 tid=93548 errno=4 - Interrupted system call
             1	0x0000000000411566: assert_on_unhandled_exception at processor.c:627
             2	0x000000000040889a: _vcpu_run at kvm_util.c:1649
             3	 (inlined by) vcpu_run at kvm_util.c:1660
             4	0x00000000004041a1: vcpu_thread at hyperv_tlb_flush.c:548
             5	0x000000000043a305: start_thread at pthread_create.o:?
             6	0x000000000045f857: __clone3 at ??:?
          val == expected
        Waiting for 'kvm_binary_stats_test', PID '92579'
        
        ...
        
        SKIPPED vmx_preemption_timer_test
        Waiting for 'vmx_set_nested_state_test', PID '93316'
        SKIPPED vmx_set_nested_state_test
        Waiting for 'vmx_tsc_adjust_test', PID '93329'
        SKIPPED vmx_tsc_adjust_test
        Waiting for 'xapic_ipi_test', PID '93350'
        Waiting for 'xapic_state_test', PID '93360'
        Waiting for 'xcr0_cpuid_test', PID '93374'
        Waiting for 'xen_shinfo_test', PID '93391'
        Waiting for 'xen_vmcall_test', PID '93405'
        Waiting for 'xss_msr_test', PID '93420'

It's far from perfect, e.g. just waits in alphabetical order, but it gives me
easy to read feedback, and signal that tests are indeed running and completing.
        
> - Dump output which can be easily accessed and parsed.

And persist the output/logs somewhere, e.g. so that the user can triage failures
after the fact.

> - Allow to run with different command line parameters.

Command line parameters for tests?  If so, I would put this in phase 3.  I.e. make
the goal of Phase 1 purely about running tests in parallel.

> Current patch does more than this and can be simplified.
> 
> Phase 2: Environment setup via runner
> 
> Current patch, allows to write "setup" commands at test suite and test
> level in the json config file to setup the environment needed by a
> test to run. This might not be ideal as some settings are exposed
> differently on different platforms.
> 
> For example,
> To enable TDP:
> - Intel needs npt=Y
> - AMD needs ept=Y
> - ARM always on.
> 
> To enable APIC virtualization
> - Intel needs enable_apicv=Y
> - AMD needs avic=Y
> 
> To enable/disable nested, they both have the same file name "nested"
> in their module params directory which should be changed.
> 
> These kinds of settings become more verbose and unnecessary on other
> platforms. Instead, runners should have some programming constructs
> (API, command line options, default) to enable these options in a
> generic way. For example, enable/disable nested can be exposed as a
> command line --enable_nested, then based on the platform, runner can
> update corresponding module param or ignore.
> 
> This will easily extend to providing sane configuration on the
> corresponding platforms without lots of hardcoding in JSON. These
> individual constructs will provide a generic view/option to run a KVM
> feature, and under the hood will do things differently based on the
> platform it is running on like arm, x86-intel, x86-amd, s390, etc.

My main input on this front is that the runner needs to configure module params
(and other environment settings) _on behalf of the user_, i.e. in response to a
command line option (to the runner), not in response to per-test configurations.

One of my complaints with our internal infrastructure is that the testcases
themselves can dictate environment settings.  There are certainly benefits to
that approach, but it really only makes sense at scale where there are many
machines available, i.e. where the runner can achieve parallelism by running
tests on multiple machines, and where the complexity of managing the environment
on a per-test basis is worth the payout.

For the upstream runner, I want to cater to developers, i.e. to people that are
running tests on one or two machines.  And I want the runner to rip through tests
as fast as possible, i.e. I don't want tests to get serialized because each one
insists on being a special snowflake and doesn't play nice with other children.
Organizations that the have a fleet of systems can pony up the resources to develop
their own support (on top?).

Selftests can and do check for module params, and should and do use TEST_REQUIRE()
to skip when a module param isn't set as needed.  Extending that to arbitrary
sysfs knobs should be trivial.  I.e. if we get _failures_ because of an incompatible
environment, then it's a test bug.

> Phase 3: Provide collection of interesting configurations
> 
> Specific individual constructs can be combined in a meaningful way to
> provide interesting configurations to run on a platform. For example,
> user doesn't need to specify each individual configuration instead,
> some prebuilt configurations can be exposed like
> --stress_test_shadow_mmu, --test_basic_nested

IMO, this shouldn't be baked into the runner, i.e. should not surface as dedicated
command line options.  Users shouldn't need to modify the runner just to bring
their own configuration.  I also think configurations should be discoverable,
e.g. not hardcoded like KUT's unittest.cfg.  A very real problem with KUT's
approach is that testing different combinations is frustratingly difficult,
because running a testcase with different configuration requires modifying a file
that is tracked by git.

There are underlying issues with KUT that essentially necessitate that approach,
e.g. x86 has several testcases that fail if run without the exact right config.
But that's just another reason to NOT follow KUT's pattern, e.g. to force us to
write robust tests.

E.g. instead of per-config command line options, let the user specify a file,
and/or a directory (using a well known filename pattern to detect configs).

> Tests need to handle the environment in which they are running
> gracefully, which many tests already do but not exhaustively. If some
> setting is not provided or set up properly for their execution then
> they should fail/skip accordingly.

This belongs in phase 2.

> Runner will not be responsible to precheck things on tests behalf.
> 
> 
> Next steps:
> 1. Consensus on above phases and features.
> 2. Start development.
> 
> Thanks,
> Vipin

