Return-Path: <kvm+bounces-67076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BCD36CF5585
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 20:19:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2005B302F2C9
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 19:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7103D33BBD0;
	Mon,  5 Jan 2026 19:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hs3O2KUT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1292D97A6
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 19:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767640766; cv=none; b=XIqFwYYJ82Hd3oC3p5fkbPFSBS3Rp+MiPrK4tDHt7qfci+Ls4PW7tM6QO4DHQwrrinoYMZuAdvy/rx2f6arHY2JRaRZT3gaBNSC5PpLi+nWX3jH+I2SRP1ChKPKfkaSRhDUbjgjf4/5xA9qLAKd3EE6hp5c2ssZtg8DytOcIE0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767640766; c=relaxed/simple;
	bh=hhETuqLKzj0T5EHz4qHnJx+sSo4cAu4za+19Tz5HBE4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sAoyXH40kFsaMd/Fm1g8m1ZPYaNpxNnBXuYzqfxULYkVChHHoxAgWkky4AfJdkwO9d7u/lluDgY0j5Rinyh0gXCj6yodkYgVOF0ftoV9mYnu0/mUYe6VR3fyB5acXwQnMUGu/K2zBMZKppL5irenNMipAXsBZA5kN8/M2tsUpZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hs3O2KUT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ab8693a2cso746742a91.0
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 11:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767640763; x=1768245563; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d9ntbdX9K2AtzUNdNKNcm+rfYK2fUVxnSHYza2QIr/A=;
        b=hs3O2KUTH59uHY3+zsoX0yMImz9p64CnS2tmmqaEABkyxtSTsYac/Vs3H/zGAsY/kx
         HfBa5koRlWZFdWgad1+GBrVcRwvNvNBxgNngl5zR8P4JrdCJiicud8zaVOYnHzpxAgGn
         36cDr3uMjb3HCDHQXEPIP6aV1+WBRHekPz2BojIQ5RkbyEA8T3l/qW/IxDg+o8d0dydh
         O6K5DE7qdrMCp/eMQKSqs8JCJzOzSNjvuQ7+XPtJgjezSUZ8h3B9mcMSQSKOnMXN+SQs
         k+UWkvxleALY4emeJJuP3E4kfax2OYm4kWw9HtGq4AYJecWZ2bEDdeDim+zAilbhXdLR
         se/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767640763; x=1768245563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d9ntbdX9K2AtzUNdNKNcm+rfYK2fUVxnSHYza2QIr/A=;
        b=innhbpPTnn0hE/wHW5dvnACK9mvELAukj3vuRVu30k4rfanoSEo4nLARaC/gbFuydd
         8g+v3Ct3NQwMHZi17CHTx8j4ZRSm+km1oD9xqcnvz97Kz4OGus0//aI0lZScRk3XC3Dp
         zIkxCf+BfTb/UzR9Gk7GC3Y/It/wQHdcahvt1MC9cDvlz3HykJifyCzWdpa8jLa1oaGM
         EpGX1nDS0FW8r+nAzpp+XlIXW8wk4IgrX1AFm5LTJMZkEzoDLLCE61TEwnUWnk8Mb6I2
         IR99E8+m7yASgy3xKcmKjk2PNfUfEe3osqqvO3FW45581ptFOyycFLeozw/OBEuu9LNV
         jspg==
X-Forwarded-Encrypted: i=1; AJvYcCU6kL4D/xRJ3XAbYe+QNOppdwdh+TSWRg2qkfaY4QMC91JRsD9R5brAzlQ10BvyUbt6/RU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0bSS0/LuWjNPWUoVIcpRet1FXCPLFdtwUSi5Y9Kc347ufm/LE
	XN5ABAP8NTNZKWfX+geAtHO4JfcxtdH8/1KjtY8Nl02oIqP+9jkk1R4d7fqgB9e+Kmo375tU6cm
	BnBZpJA==
X-Google-Smtp-Source: AGHT+IH+bYHSyMnars/iwMuAEK83wLmCWdlfJqxD7aNHjiVi4EGuhWugYuioFdWpdCTSX+ItFnBrgh8dA5M=
X-Received: from pjbkb13.prod.google.com ([2002:a17:90a:e7cd:b0:34a:adf0:4010])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5885:b0:34e:5aa2:cf61
 with SMTP id 98e67ed59e1d1-34f5f32e65fmr253069a91.28.1767640763344; Mon, 05
 Jan 2026 11:19:23 -0800 (PST)
Date: Mon, 5 Jan 2026 11:19:21 -0800
In-Reply-To: <6fltlvsnlbqyw3sme2zamsxp2u54tkoauydeoq2v3rri6r2uja@lmxwn57ll5ta>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260102183039.496725-1-yosry.ahmed@linux.dev>
 <aVv6xaI0hYwgB0ce@google.com> <6fltlvsnlbqyw3sme2zamsxp2u54tkoauydeoq2v3rri6r2uja@lmxwn57ll5ta>
Message-ID: <aVwOuUEeE5dm3cpF@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Increase the timeout for vmx_pf_{vpid/no_vpid/invvpid}_test
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 05, 2026, Yosry Ahmed wrote:
> On Mon, Jan 05, 2026 at 09:54:13AM -0800, Sean Christopherson wrote:
> > On Fri, Jan 02, 2026, Yosry Ahmed wrote:
> > > When running the tests on some older CPUs (e.g. Skylake) on a kernel
> > > with some debug config options enabled (e.g. CONFIG_DEBUG_VM,
> > > CONFIG_PROVE_LOCKING, ..), the tests timeout. In this specific setup,
> > > the tests take between 4 and 5 minutes, so pump the timeout from 4 to 6
> > > minutes.
> > 
> > Ugh.  Can anyone think of a not-insane way to skip these tests when running in
> > an environment that is going to be sloooooow?  Because (a) a 6 minute timeout
> > could very well hide _real_ KVM bugs, e.g. if is being too aggressive with TLB
> > flushes (speaking from experience) and (b) running a 5+ minute test is a likely
> > a waste of time/resources.
> 
> The definition of a slow enviroment is also very dynamic, I don't think
> we want to play whack-a-mole with config options or runtime knobs that
> would make the tests slow.
> 
> I don't like just increasing the timeout either, but the tests are slow
> even without these specific config options. They only make them a little
> bit slower, enough to consistently reproduce the timeout.

Heh, "little bit" is also subjective.  The tests _can_ run in less than 10
seconds:

$ time qemu --no-reboot -nodefaults -global kvm-pit.lost_tick_policy=discard
  -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -display none
  -serial stdio -device pci-testdev -machine accel=kvm,kernel_irqchip=split
  -kernel x86/vmx.flat -smp 1 -append vmx_pf_invvpid_test -cpu max,+vmx

933897 tests, 0 failures
PASS: 4-level paging tests
filter = vmx_pf_invvpid_test, test = vmx_pf_vpid_test
filter = vmx_pf_invvpid_test, test = vmx_exception_test
filter = vmx_pf_invvpid_test, test = vmx_canonical_test
filter = vmx_pf_invvpid_test, test = vmx_cet_test
SUMMARY: 1867887 tests
Command exited with non-zero status 1
3.69user 3.19system 0:06.90elapsed 99%CPU

> This is also acknowledged by commit ca785dae0dd3 ("vmx: separate VPID
> tests"), which introduced the separate targets to increase the timeout.
> It mentions the 3 tests taking 12m (so roughly 4m each). 

Because of debug kernels.  With a fully capable host+KVM and non-debug kernel,
the tests take ~50 seconds each.

Looking at why the tests can run in ~7 seconds, the key difference is that the
above run was done with ept=0, which culls the Protection Keys tests (KVM doesn't
support PKU when using shadow paging because it'd be insane to emulate correctly).
The PKU testcases increase the total number of testcases by 10x, which leads to
timeouts with debug kernels.

Rather than run with a rather absurd timeout, what if we disable PKU in the guest
for the tests?  Running all four tests completes in <20 seconds:

$ time qemu --no-reboot -nodefaults -global kvm-pit.lost_tick_policy=discard
  -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -display none
  -serial stdio -device pci-testdev -machine accel=kvm,kernel_irqchip=split
  -kernel x86/vmx.flat -smp 1 -append "vmx_pf_exception_forced_emulation_test
  vmx_pf_vpid_test vmx_pf_invvpid_test vmx_pf_no_vpid_test" -cpu max,+vmx,-pku

10.40user 7.28system 0:17.76elapsed 99%CPU (0avgtext+0avgdata 79788maxresident)

That way we can probably/hopefully bundle the configs together, and enable it by
default:

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 522318d3..45f25f51 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -413,37 +413,16 @@ qemu_params = -cpu max,+vmx
 arch = x86_64
 groups = vmx nested_exception
 
-[vmx_pf_exception_test_fep]
+[vmx_pf_exception_test_emulated]
 file = vmx.flat
-test_args = "vmx_pf_exception_forced_emulation_test"
-qemu_params = -cpu max,+vmx
+test_args = "vmx_pf_exception_forced_emulation_test vmx_pf_vpid_test vmx_pf_invvpid_test vmx_pf_no_vpid_test"
+# Disable Protection Keys for the VMX #PF tests that require KVM to emulate one
+# or more instructions per testcase, as PKU increases the number of testcases
+# by an order of magnitude, and testing PKU for these specific tests isn't all
+# that interesting.
+qemu_params = -cpu max,+vmx,-pku
 arch = x86_64
-groups = vmx nested_exception nodefault
-timeout = 240
-
-[vmx_pf_vpid_test]
-file = vmx.flat
-test_args = "vmx_pf_vpid_test"
-qemu_params = -cpu max,+vmx
-arch = x86_64
-groups = vmx nested_exception nodefault
-timeout = 240
-
-[vmx_pf_invvpid_test]
-file = vmx.flat
-test_args = "vmx_pf_invvpid_test"
-qemu_params = -cpu max,+vmx
-arch = x86_64
-groups = vmx nested_exception nodefault
-timeout = 240
-
-[vmx_pf_no_vpid_test]
-file = vmx.flat
-test_args = "vmx_pf_no_vpid_test"
-qemu_params = -cpu max,+vmx
-arch = x86_64
-groups = vmx nested_exception nodefault
-timeout = 240
+groups = vmx nested_exception
 
 [vmx_pf_exception_test_reduced_maxphyaddr]
 file = vmx.flat


