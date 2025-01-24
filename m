Return-Path: <kvm+bounces-36582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F18BFA1BF0F
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 00:36:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF6DD188FFEF
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 23:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF54A1EEA2E;
	Fri, 24 Jan 2025 23:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EySUwm/d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044732B9BC
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 23:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737761769; cv=none; b=STqa3ym4USOdb8owc/VOaW+09JLIVIy+TvNwwCkOyrzb5cnsW/uTwOpPhMUKtfpJgg2JU41JiyiS6Mo+Ax/5gbGTNB/D0F80oQ4VEHIFfDH4lOP+coldI5f60BdcEkkzyNuap3qh/nvfqLcPRSnJLwYwz8IeIAv2NNZfcLfnX50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737761769; c=relaxed/simple;
	bh=D0GLU8GREmbgQHc8YP//C2Qzi2ex0u88kFzgIC0HnRM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cDxD1L4VQUZwNwN2ABwxMHWDqWbIWz3yjh7xBB47m/G5U4X2rQlnbjNglB3+eqdZ6GKrwtAqFjsD1m753XRGTQemHKA63g9khfB6lbAoV6CMVlPGDXcPUh1KFme+rUDHsDiTfNyMYZV2GHfR4vrKWaAG8vnILBrBt8Boqq4a/xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EySUwm/d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737761766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A32pAWHZZ0hQgbLXQptrQMsflGlYd7oIEavcz3xQziw=;
	b=EySUwm/d7YvC5XYGFxwAzayhPId40li6B3bPGte1hc+wnP366A9ZNNMFCCNOSnsrsScTON
	IVpWt84W3eYVqzoXijqWST++MlIR9AhJkDENdwdZeSluCtlR0x2j7mHc1wy7NtkZTW4XOC
	avtGTcowfgssR2Y3bmHIGrBY/xXUMm0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-oIJnewBOOoGf5zMA0jHAjg-1; Fri, 24 Jan 2025 18:36:05 -0500
X-MC-Unique: oIJnewBOOoGf5zMA0jHAjg-1
X-Mimecast-MFC-AGG-ID: oIJnewBOOoGf5zMA0jHAjg
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6d884999693so42716446d6.0
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 15:36:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737761765; x=1738366565;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A32pAWHZZ0hQgbLXQptrQMsflGlYd7oIEavcz3xQziw=;
        b=FyeewAe6CzfylcndimwolOkrMLYCJx78Arj4wZVE96EVAMYGc9UopcW97A2MFY4QHg
         dkgtKWsaGZKhumUHyiwKO5X0bbg5z6TCTjh5qU+JtNCvRrbi8WNA9l7Lb5swkfTvng8k
         foqkgwOi2+zBNHv8pO4I/4LRyeCo05vSNLvY97bP+jSJPGaXhViZN/a7/k7jZ5t15Gp+
         m4inMtnNreIZD8HNF2DVE8Bmuh8hUIqoE9enztLvfQQQeOs7b7LKwtx4JTgvMkbn/PyD
         kNCfsHq5avSMvByhSvmT8KVD/xp9DhIo9xGmue/Khg+HzDhsxAFl8nSfnBwKIbzMkbdd
         mvIw==
X-Gm-Message-State: AOJu0YxzPRj+gHCuNp3AnULqHntUu3sAqQ5HmjT9AhO+YcYtaiNzavDw
	cNdwlSmeOm3AOXqwJQNuqDdxgCMwXrOuCstIb9jm2J9UExE2GAw+2N0KV0ajoRU1hIjxoxqKaIq
	EmX28/esNBCQJ6thR+LabNXz+q0hNqQSKzLpevTHMqyToC+0KDw==
X-Gm-Gg: ASbGncuWmgfl69FWIqfR29ShrZTlu2eUd6GNJNMyEU8bsJaIWddzailqgIgflat43MK
	heOyV5Gvo612W+Kx0zZk9DJ36+o7C/PaZL3gXjETVdZIEf2T1kofU08ziTllbdb1Lrd5QvrtI5R
	k/kRQEggFihPBLNd0FODTb2Zjy++vTHQYQNwjc5vIaN6AYi697j6yykVHYVZjxJAUbBp/N0crM0
	YrZknvICBG1RQ6cB2ij1hbObq31mjdM3vZeC0noxthDJ8x/rYe1cK0LA4cejgAcDVyQUMKHt7cs
	XWgZ
X-Received: by 2002:a05:6214:1306:b0:6cb:e648:863e with SMTP id 6a1803df08f44-6e1b2235398mr467693566d6.43.1737761764797;
        Fri, 24 Jan 2025 15:36:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGZTCC82u8gha8aTTvVH0C31HiSNCkJc/KsrvWlHVWPziBYrJs6pXOOxSJ6nbFj4xAsNPNUtg==
X-Received: by 2002:a05:6214:1306:b0:6cb:e648:863e with SMTP id 6a1803df08f44-6e1b2235398mr467693216d6.43.1737761764379;
        Fri, 24 Jan 2025 15:36:04 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e66b67debsm14930451cf.55.2025.01.24.15.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 15:36:03 -0800 (PST)
Message-ID: <f7b73f3b65377b7fd28f1f4764ea18f98056c51a.camel@redhat.com>
Subject: Re: vmx_pmu_caps_test fails on Skylake based CPUS due to read only
 LBRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 24 Jan 2025 18:36:03 -0500
In-Reply-To: <Z5Fc4d5bVf5oVlOk@google.com>
References: <c9d8269bff69f6359731d758e3b1135dedd7cc61.camel@redhat.com>
	 <Zx-z5sRKCXAXysqv@google.com>
	 <948408887cbe83cbcf05452a53d33fb5aaf79524.camel@redhat.com>
	 <Z5BDr2mm57F0vfax@google.com>
	 <dd128607c0306d21e57994ffb964514728b92f29.camel@redhat.com>
	 <Z5Fc4d5bVf5oVlOk@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-01-22 at 13:02 -0800, Sean Christopherson wrote:
> On Wed, Jan 22, 2025, Maxim Levitsky wrote:
> > On Tue, 2025-01-21 at 17:02 -0800, Sean Christopherson wrote:
> > > On Sun, Nov 03, 2024, Maxim Levitsky wrote:
> > > > On Mon, 2024-10-28 at 08:55 -0700, Sean Christopherson wrote:
> > > > > On Fri, Oct 18, 2024, Maxim Levitsky wrote:
> > > > > > Our CI found another issue, this time with vmx_pmu_caps_test.
> > > > > > 
> > > > > > On 'Intel(R) Xeon(R) Gold 6328HL CPU' I see that all LBR msrs (from/to and
> > > > > > TOS), are always read only - even when LBR is disabled - once I disable the
> > > > > > feature in DEBUG_CTL, all LBR msrs reset to 0, and you can't change their
> > > > > > value manually.  Freeze LBRS on PMI seems not to affect this behavior.
> > > 
> > > ...
> > > 
> > > > When DEBUG_CTL.LBR=1, the LBRs do work, I see all the registers update,
> > > > although TOS does seem to be stuck at one value, but it does change
> > > > sometimes, and it's non zero.
> > > > 
> > > > The FROM/TO do show healthy amount of updates 
> > > > 
> > > > Note that I read all msrs using 'rdmsr' userspace tool.
> > > 
> > > I'm pretty sure debugging via 'rdmsr', i.e. /dev/msr, isn't going to work.  I
> > > assume perf is clobbering LBR MSRs on context switch, but I haven't tracked that
> > > down to confirm (the code I see on inspecition is gated on at least one perf
> > > event using LBRs).  My guess is that there's a software bug somewhere in the
> > > perf/KVM exchange.
> > > 
> > > I confirmed that using 'rdmsr' and 'wrmsr' "loses" values, but that hacking KVM
> > > to read/write all LBRs during initialization works with LBRs disabled.

Hi!

I finally got to the very bottom of this:

First of all, your assumption that the kernel resets LBR related msrs on context switch after 'wrmsr'
program finishes execution is wrong, because the kernel will only do this if it *itself*
enables the LBR feature (that is when something like 'perf', uses a perf counter with a lbr call stack).

Writes that 'wrmsr' tool does are not something that kernel expects so it doesn't
do anything in this case.

What is happening instead, is something completely different: Turns out that to shave off something like 
50 nanoseconds, off the deep C-state entry/exit latency, some Intel CPU don't preserve LBR stack
values over these C-state entries.

Kernel PMU code even has some special code which works this around.

So, right after 'wrmsr' execution the CPU on a otherwise idle host finishes, the CPU will enter a low power state,
and 'poof', LBR state is gone.

To see this for yourself, just disable C-states

# cpupower idle-set --disable-by-latency 0

And suddenly wrmsr reads/writes the LBR stack start to work normally as expected.

This also in particular explains why I had no problems reading/writing LBR stack msrs on some older CPUs.

> > 
> > Hi,
> > 
> > OK, this is a very good piece of the puzzle.
> > 
> > I didn't expect context switch to interfere with this because I thought that
> > perf code won't touch LBRs if they are not in use. 
> > rdmsr/wrmsr programs don't do much except doing the instruction in the kernel space.
> > 
> > Is it then possible that the the fact that LBRs were left enabled by BIOS is the
> > culprit of the problem?
> > 
> > This particular test never enables LBRs, not anything in the system does this,
> 
> Ugh, but it does.  On writes to any LBR, including LBR_TOS, KVM creates a "virtual"
> LBR perf event.  KVM then relies on perf to context switch LBR MSRs, i.e. relies
> on perf to load the guest's values into hardware.  At least, I think that's what
> is supposed to happen.  AFAIK, the perf-based LBR support has never been properly
> document[*].
> 
> Anyways, my understanding of intel_pmu_handle_lbr_msrs_access() is that if the
> vCPU's LBR perf event is scheduled out or can't be created, the guest's value is
> effectively lost.  Again, I don't know the "rules" for the LBR perf event, but
> it wouldn't suprise me if your CI fails because something in the host conflicts
> with KVM's LBR perf event.

Actually you are partially wrong here too (although BIOS can be considered 'something on the host').

I was able to prove that the reason why the unit test fails *is* because BIOS left LBRs enabled:

First of all, setting LBR bit manually in DEBUG_CTL does trigger this bug 
(I use a different machine now, which doesn't have the bios bug):


# wrmsr -a 0x1d9 0x4001
# ./x86_64/vmx_pmu_caps_test 
Random seed: 0x6b8b4567
TAP version 13
1..6
# Starting 6 tests from 1 test cases.
#  RUN           vmx_pmu_caps.guest_wrmsr_perf_capabilities ...
#            OK  vmx_pmu_caps.guest_wrmsr_perf_capabilities
ok 1 vmx_pmu_caps.guest_wrmsr_perf_capabilities
#  RUN           vmx_pmu_caps.basic_perf_capabilities ...
#            OK  vmx_pmu_caps.basic_perf_capabilities
ok 2 vmx_pmu_caps.basic_perf_capabilities
#  RUN           vmx_pmu_caps.fungible_perf_capabilities ...
#            OK  vmx_pmu_caps.fungible_perf_capabilities
ok 3 vmx_pmu_caps.fungible_perf_capabilities
#  RUN           vmx_pmu_caps.immutable_perf_capabilities ...
#            OK  vmx_pmu_caps.immutable_perf_capabilities
ok 4 vmx_pmu_caps.immutable_perf_capabilities
#  RUN           vmx_pmu_caps.lbr_perf_capabilities ...
==== Test Assertion Failure ====
  x86_64/vmx_pmu_caps_test.c:202: r == v
  pid=8415 tid=8415 errno=0 - Success
     1	0x0000000000404301: __suite_lbr_perf_capabilities at vmx_pmu_caps_test.c:202
     2	 (inlined by) vmx_pmu_caps_lbr_perf_capabilities at vmx_pmu_caps_test.c:194
     3	 (inlined by) wrapper_vmx_pmu_caps_lbr_perf_capabilities at vmx_pmu_caps_test.c:194
     4	0x000000000040511a: __run_test at kselftest_harness.h:1240
     5	0x0000000000402b95: test_harness_run at kselftest_harness.h:1310
     6	 (inlined by) main at vmx_pmu_caps_test.c:246
     7	0x00007f56ba2295cf: ?? ??:0
     8	0x00007f56ba22967f: ?? ??:0
     9	0x0000000000402e44: _start at ??:?
  Set MSR_LBR_TOS to '0x7', got back '0xc'
# lbr_perf_capabilities: Test failed
#          FAIL  vmx_pmu_caps.lbr_perf_capabilities
not ok 5 vmx_pmu_caps.lbr_perf_capabilities
#  RUN           vmx_pmu_caps.perf_capabilities_unsupported ...
#            OK  vmx_pmu_caps.perf_capabilities_unsupported
ok 6 vmx_pmu_caps.perf_capabilities_unsupported
# FAILED: 5 / 6 tests passed.
# Totals: pass:5 fail:1 xfail:0 xpass:0 skip:0 error:0


Secondary I went over all places in the kernel and all of them take care to preserve DEBUG_CTL and only set/clear specific bits.

__intel_pmu_lbr_enable() and __intel_pmu_lbr_enable() are practically the only two places where DEBUGCTLMSR_LBR bit is touched,
and the test doesn't trigger them. Most likely because the test uses special 'INTEL_FIXED_VLBR_EVENT' perf event
(see intel_pmu_create_guest_lbr_event) which is not enabled while in host mode.

To double check this I traced all writes to DEBUG_CTL msr during this test and the only write is done during 'guest_wrmsr_perf_capabilities'
subtest, by vmx_vcpu_run() which just restores the value that the msr had prior to VM entry.

So, why the value that BIOS sets survives? Because as I said all code that touches DEBUG_CTL takes care to preserve all bits but
the bit which is changed, LBRs are never enabled on the host, and even the guest entry preserves host DEBUG_CTL.
Therefore the value written by BIOS survives.

So we end up with the test writing to LBR_TOS while LBRs are unexpectedly enabled, so it's not a surprise that when the test
reads back the value written, it will differ, and the test will rightfully fail.

Since we have seen this in CI, and you saw it too in your CI, I think this BIOS bug is not that rare, and so I suggest to stick 
'wrmsrl(MSR_IA32_DEBUGCTLMSR, 0)' somewhere early in a kernel boot code
or at least clear the DEBUGCTLMSR_LBR bit.

I haven't found a very good place to put this, in a way that I can be sure that x86 maintainers 
won't reject it, so I am open to your suggestions.


Best regards,
	Maxim Levitsky


> 
> [*] https://lore.kernel.org/all/Y9RUOvJ5dkCU9J8C@google.com
> 






