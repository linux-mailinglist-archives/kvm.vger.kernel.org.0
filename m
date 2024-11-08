Return-Path: <kvm+bounces-31252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E6E69C1BD3
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 12:05:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D6F128415C
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 11:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD6BB1E32AA;
	Fri,  8 Nov 2024 11:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="YFR2V8pB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99101DEFEA
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 11:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731063937; cv=none; b=CuHSuqrZftWgftfPsRBObjoaRS5tbqDKuB2hsrkugmFx1Oa2Vs0nn6lsBSYr/g9zQRaYusG64SOv+idvurlhz/kMGaEGZKVZ3Gzw3hFWTOLyNa62BoUtzPZvXYIO0IZ4RnqG/+dj1+NYOfvHtwxswBXuqsPTz90MWeCxbPLcZp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731063937; c=relaxed/simple;
	bh=8XN0VP7I673COgoJlhJizMkRxPHITAlgFeP6yBP7wSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XvT9aNaTDLAX+pQ6KLlKV5YppO1V3DgdHnN+4kjgNfKxXpyl0RVOqXHeiFQfdZn7C/W4wndRDcnVGLip0jAFzVzoOI3ISOQpNdTmYIJ0nZq5GL/VdGgHT6rrhDu+NSIJOPt3ClEufgiob0MkyN2hNETMxl7YE/JCb6PKpUAH5oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=YFR2V8pB; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-37d4b0943c7so1122693f8f.1
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 03:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1731063934; x=1731668734; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ei04cRd9dd3Ei4oSjI8uDS6cZdRZ1aqwkFMjWl7Z0kk=;
        b=YFR2V8pB5WOAoSBAD1j5EtAfha58AlW5hSXnvVMGpSGdbMb3jEoF2D3skFQKfnmADb
         LD8L4V9Bm1Dpt3S6M5yYSwRgIR1u88S4dOKsAYag4xjaW0VtW0yeQEng1AwRmo0+Ur2R
         tsZ8upHTwxzoFGhT0AlqOiUUdP7KCneCLH/tElXLGdpH5h+BWNaxZa3vRG3hEH+99uxP
         HHAVI1cZgY9EeQJa70scLLSDQcthOzqPzfSre6/IOQmHL6z3Ywg/zUZnXJmulOndGAe/
         0e0VIhfLRuYLV2Dfes5e6eHRoOZta4qjDEc2myCZ1b7D3Gw49uV0tmfr3RBc5VExTE8/
         Ww/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731063934; x=1731668734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ei04cRd9dd3Ei4oSjI8uDS6cZdRZ1aqwkFMjWl7Z0kk=;
        b=Zamkfz3UgKCg9+Xc19r+0dN/Fxi1SyzSbFJo5UNJ7NeZuhuYd581XTUWJVdD3j9vtQ
         lzDBqf282r2LS+Ht1Glc2TX9lzYgMDwgksjzliaUwxOiOReE77F1JU/q+0zcIH+bfbqm
         /3YlcIXbAxPHKxCRDrdE07riOkh9T6Mtb0z8ei5Aarq9MwG4Wx1oXCbal/lrhikNiCnn
         I1O4DH5RNtkQ9VC+iGupYH0lISNq16bjkvTBa9faAo7oAxp/SGiwDFV+bLDnALUyHmxL
         zzLqlSpKfIvKEFv4ByBtoZ3EoKH6sa9tVP8CwRHIdgGB3EbqEXB4ONO5qnZmKgtsegAt
         TPCw==
X-Forwarded-Encrypted: i=1; AJvYcCU1B99euIewPYTZ/Q2QcJopaYg58m5YTfIbEDgltzHO9BTXOFAtQiXwVTBJQehci3rhgGI=@vger.kernel.org
X-Gm-Message-State: AOJu0YweS5hLSB8i1NDx6nGM62Aiv4/wOERFiq9BBFaS1hU6Vmh3qz+b
	cG0Z7nxqnL5GlQCIH4GMbNiA+Gxd7LOgivJGsgSMOC4koJCm5o1rD9nT6ifzXWY=
X-Google-Smtp-Source: AGHT+IF6yxcP+ZA1gmHcAz0qWF6DZiDkNmSWK2EbdhHg+3pJ8fXCTOVqi/qxta+MiHUm18AZebfwig==
X-Received: by 2002:a5d:5e90:0:b0:37c:c892:a98c with SMTP id ffacd0b85a97d-381f188c972mr1778438f8f.56.1731063933914;
        Fri, 08 Nov 2024 03:05:33 -0800 (PST)
Received: from localhost (cst2-173-13.cust.vodafone.cz. [31.30.173.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381edc1104asm4279796f8f.88.2024.11.08.03.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2024 03:05:33 -0800 (PST)
Date: Fri, 8 Nov 2024 12:05:32 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Anup Patel <anup@brainfault.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] KVM selftests runner for running more than just
 default
Message-ID: <20241108-eaacad12f1eef31481cf0c6c@orel>
References: <20240821223012.3757828-1-vipinsh@google.com>
 <CAHVum0eSxCTAme8=oV9a=cVaJ9Jzu3-W-3vgbubVZ2qAWVjfJA@mail.gmail.com>
 <CAHVum0fWJW7V5ijtPcXQAtPSdoQSKjzYwMJ-XCRH2_sKs=Kg7g@mail.gmail.com>
 <ZyuiH_CVQqJUoSB-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyuiH_CVQqJUoSB-@google.com>

On Wed, Nov 06, 2024 at 09:06:39AM -0800, Sean Christopherson wrote:
> On Fri, Nov 01, 2024, Vipin Sharma wrote:
> > Had an offline discussion with Sean, providing a summary on what we
> > discussed (Sean, correct me if something is not aligned from our
> > discussion):
> > 
> > We need to have a roadmap for the runner in terms of features we support.
> > 
> > Phase 1: Having a basic selftest runner is useful which can:
> > 
> > - Run tests parallely
> 
> Maybe with a (very conversative) per test timeout?  Selftests generally don't have
> the same problems as KVM-Unit-Tests (KUT), as selftests are a little better at
> guarding against waiting indefinitely, i.e. I don't think we need a configurable
> timeout.  But a 120 second timeout or so would be helpful.
> 
> E.g. I recently was testing a patch (of mine) that had a "minor" bug where it
> caused KVM to do a remote TLB flush on *every* SPTE update in the shadow MMU,
> which manifested as hilariously long runtimes for max_guest_memory_test.  I was
> _this_ close to not catching the bug (which would have been quite embarrasing),
> because my hack-a-scripts don't use timeouts (I only noticed because a completely
> unrelated bug was causing failures).
> 
> > - Provide a summary of what passed and failed, or only in case of failure.
> 
> I think a summary is always warranted.  And for failures, it would be helpful to
> spit out _what_ test failed, versus the annoying KUT runner's behavior of stating
> only the number of passes/failures, which forces the user to go spelunking just
> to find out what (sub)test failed.
> 
> I also think the runner should have a "heartbeat" mechanism, i.e. something that
> communicates to the user that forward progress is being made.  And IMO, that
> mechanism should also spit out skips and failures (this could be optional though).
> One of the flaws with the KUT runner is that it's either super noisy and super
> quiet.
> 
> E.g. my mess of bash outputs this when running selftests in parallel (trimmed for
> brevity):
> 
>         Running selftests with npt_disabled
>         Waiting for 'access_tracking_perf_test', PID '92317'
>         Waiting for 'amx_test', PID '92318'
>         SKIPPED amx_test
>         Waiting for 'apic_bus_clock_test', PID '92319'
>         Waiting for 'coalesced_io_test', PID '92321'
>         Waiting for 'cpuid_test', PID '92324'
>         
>         ...
>         
>         Waiting for 'hyperv_svm_test', PID '92552'
>         SKIPPED hyperv_svm_test
>         Waiting for 'hyperv_tlb_flush', PID '92563'
>         FAILED hyperv_tlb_flush : ret ='254'
>         Random seed: 0x6b8b4567
>         ==== Test Assertion Failure ====
>           x86_64/hyperv_tlb_flush.c:117: val == expected
>           pid=92731 tid=93548 errno=4 - Interrupted system call
>              1	0x0000000000411566: assert_on_unhandled_exception at processor.c:627
>              2	0x000000000040889a: _vcpu_run at kvm_util.c:1649
>              3	 (inlined by) vcpu_run at kvm_util.c:1660
>              4	0x00000000004041a1: vcpu_thread at hyperv_tlb_flush.c:548
>              5	0x000000000043a305: start_thread at pthread_create.o:?
>              6	0x000000000045f857: __clone3 at ??:?
>           val == expected
>         Waiting for 'kvm_binary_stats_test', PID '92579'
>         
>         ...
>         
>         SKIPPED vmx_preemption_timer_test
>         Waiting for 'vmx_set_nested_state_test', PID '93316'
>         SKIPPED vmx_set_nested_state_test
>         Waiting for 'vmx_tsc_adjust_test', PID '93329'
>         SKIPPED vmx_tsc_adjust_test
>         Waiting for 'xapic_ipi_test', PID '93350'
>         Waiting for 'xapic_state_test', PID '93360'
>         Waiting for 'xcr0_cpuid_test', PID '93374'
>         Waiting for 'xen_shinfo_test', PID '93391'
>         Waiting for 'xen_vmcall_test', PID '93405'
>         Waiting for 'xss_msr_test', PID '93420'
> 
> It's far from perfect, e.g. just waits in alphabetical order, but it gives me
> easy to read feedback, and signal that tests are indeed running and completing.
>         
> > - Dump output which can be easily accessed and parsed.
> 
> And persist the output/logs somewhere, e.g. so that the user can triage failures
> after the fact.
> 
> > - Allow to run with different command line parameters.
> 
> Command line parameters for tests?  If so, I would put this in phase 3.  I.e. make
> the goal of Phase 1 purely about running tests in parallel.
> 
> > Current patch does more than this and can be simplified.
> > 
> > Phase 2: Environment setup via runner
> > 
> > Current patch, allows to write "setup" commands at test suite and test
> > level in the json config file to setup the environment needed by a
> > test to run. This might not be ideal as some settings are exposed
> > differently on different platforms.
> > 
> > For example,
> > To enable TDP:
> > - Intel needs npt=Y
> > - AMD needs ept=Y
> > - ARM always on.
> > 
> > To enable APIC virtualization
> > - Intel needs enable_apicv=Y
> > - AMD needs avic=Y
> > 
> > To enable/disable nested, they both have the same file name "nested"
> > in their module params directory which should be changed.
> > 
> > These kinds of settings become more verbose and unnecessary on other
> > platforms. Instead, runners should have some programming constructs
> > (API, command line options, default) to enable these options in a
> > generic way. For example, enable/disable nested can be exposed as a
> > command line --enable_nested, then based on the platform, runner can
> > update corresponding module param or ignore.
> > 
> > This will easily extend to providing sane configuration on the
> > corresponding platforms without lots of hardcoding in JSON. These
> > individual constructs will provide a generic view/option to run a KVM
> > feature, and under the hood will do things differently based on the
> > platform it is running on like arm, x86-intel, x86-amd, s390, etc.
> 
> My main input on this front is that the runner needs to configure module params
> (and other environment settings) _on behalf of the user_, i.e. in response to a
> command line option (to the runner), not in response to per-test configurations.
> 
> One of my complaints with our internal infrastructure is that the testcases
> themselves can dictate environment settings.  There are certainly benefits to
> that approach, but it really only makes sense at scale where there are many
> machines available, i.e. where the runner can achieve parallelism by running
> tests on multiple machines, and where the complexity of managing the environment
> on a per-test basis is worth the payout.
> 
> For the upstream runner, I want to cater to developers, i.e. to people that are
> running tests on one or two machines.  And I want the runner to rip through tests
> as fast as possible, i.e. I don't want tests to get serialized because each one
> insists on being a special snowflake and doesn't play nice with other children.
> Organizations that the have a fleet of systems can pony up the resources to develop
> their own support (on top?).
> 
> Selftests can and do check for module params, and should and do use TEST_REQUIRE()
> to skip when a module param isn't set as needed.  Extending that to arbitrary
> sysfs knobs should be trivial.  I.e. if we get _failures_ because of an incompatible
> environment, then it's a test bug.
> 
> > Phase 3: Provide collection of interesting configurations
> > 
> > Specific individual constructs can be combined in a meaningful way to
> > provide interesting configurations to run on a platform. For example,
> > user doesn't need to specify each individual configuration instead,
> > some prebuilt configurations can be exposed like
> > --stress_test_shadow_mmu, --test_basic_nested
> 
> IMO, this shouldn't be baked into the runner, i.e. should not surface as dedicated
> command line options.  Users shouldn't need to modify the runner just to bring
> their own configuration.  I also think configurations should be discoverable,
> e.g. not hardcoded like KUT's unittest.cfg.  A very real problem with KUT's
> approach is that testing different combinations is frustratingly difficult,
> because running a testcase with different configuration requires modifying a file
> that is tracked by git.

We have support in KUT for environment variables (which are stored in an
initrd). The feature hasn't been used too much, but x86 applies it to
configuration parameters needed to execute tests from grub, arm uses it
for an errata framework allowing tests to run on kernels which may not
include fixes to host-crashing bugs, and riscv is using them quite a bit
for providing test parameters and test expected results in order to allow
SBI tests to be run on a variety of SBI implementations. The environment
variables are provided in a text file which is not tracked by git. kvm
selftests can obviously also use environment variables by simply sourcing
them first in wrapper scripts for the tests.

> 
> There are underlying issues with KUT that essentially necessitate that approach,
> e.g. x86 has several testcases that fail if run without the exact right config.
> But that's just another reason to NOT follow KUT's pattern, e.g. to force us to
> write robust tests.
> 
> E.g. instead of per-config command line options, let the user specify a file,
> and/or a directory (using a well known filename pattern to detect configs).

Could also use an environment variable to specify a file which contains
a config in a test-specific format if parsing environment variables is
insufficient or awkward for configuring a test.

Thanks,
drew

> 
> > Tests need to handle the environment in which they are running
> > gracefully, which many tests already do but not exhaustively. If some
> > setting is not provided or set up properly for their execution then
> > they should fail/skip accordingly.
> 
> This belongs in phase 2.
> 
> > Runner will not be responsible to precheck things on tests behalf.
> > 
> > 
> > Next steps:
> > 1. Consensus on above phases and features.
> > 2. Start development.
> > 
> > Thanks,
> > Vipin
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

