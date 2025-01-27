Return-Path: <kvm+bounces-36674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 661F2A1DBB3
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 18:58:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A1EF1885890
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 17:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D5218CC15;
	Mon, 27 Jan 2025 17:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iY2QjF26"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A100317BEB6
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 17:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738000727; cv=none; b=PsPJmbABACyAK94zHPuHKUCEs43ynUBQm2QngWW+pbU9PhUgs5mRH6GSVTdt7fGMDaLtmQYcCJ7zA4HVjkt3zVOA6exTV2XT7rGyEprQZKZHwnbkkX+XxzhoEeCturiT9ie05+FzTy5YJuPyFiUVgJpKBmKi/mhhHLZF+z08C9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738000727; c=relaxed/simple;
	bh=jVdWEUwMXMMb8e6zu19lwVLxychSLZ1O8E5gSattOq4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U9elqg7xxKp9X43cAo6a0M3lG1l+/PpN0CSNjv5femHznYUB53R0ahUVxUfr6STlNP/Rte3YahwP11xHnn6AI05bgyUNxGJv590w0dzI0ClclEbeAL1/uoNoklAlHaam3T6Eqy5hyuWPMEx1ZR4J9I/XPRPOMSqMRwiM4eaG4rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iY2QjF26; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738000724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iGzh0G9g2lYzQOEH6QoebJkU9OXYeFSM4KH1K9D98Kk=;
	b=iY2QjF26j8Baem2H17B3QagWmgjyM/m9znch3TsBXDEG1HBBo77ZPBls0rb93pWfG05ebx
	Xfj+6zqkNauN3KsdKruv/YhW/mfR1v4V1CGcnMsSiVzKZsJrBVcQmVUQgVFQhpVIB2XcAO
	3ZqpEnztQRX6xoZ9laJUFVxI7V97nfo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-gZ4ZPyPMPLWvHrqEc_cnlQ-1; Mon, 27 Jan 2025 12:58:43 -0500
X-MC-Unique: gZ4ZPyPMPLWvHrqEc_cnlQ-1
X-Mimecast-MFC-AGG-ID: gZ4ZPyPMPLWvHrqEc_cnlQ
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7b6e1b036e9so461013085a.1
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 09:58:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738000722; x=1738605522;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iGzh0G9g2lYzQOEH6QoebJkU9OXYeFSM4KH1K9D98Kk=;
        b=bYg3ph/k6qJm40tVyyb2aw8D10ylDbFRVTQuLkVlU4/8c+poC8fLeURDUq+DCkkDFi
         wkCXaMmsWaa8tyMvDOzSoTggzzAq/Fit/3ZlTh2j8vEOgBYqf1MmG49icQex1hCFlR/B
         Z/gMnqSePKmdjmadvnlEpIXlbUPCrJkX3+vvF5GDxXRIgiD2jI7uDaAXBLWxXZ8M/WMm
         QlSrVuhXKWIu3mjWRjjWqzC5rcTHc7+2ztCqYyo/H5ENGRHsgtqnCM5VSe5Fz5GcgrH0
         yQoPo62LQ1X3wMJ4uML8TT5PxjvynkP+NrL9b5CioIr1ngSEGi0jMVq2L8mzBqGMLiWt
         Yj4g==
X-Gm-Message-State: AOJu0Yyw4gXihtgOii96XiP0A4/a3t8HqyBLnpJErVQq1pc4QL0K819R
	6uk/DXXzGjutauiE/vfKi2B4msY5bXAP8eRf5YODMXKQI26FsoFD9SW5Ct9MqKVe8uVtElgiVWz
	G2YdKh2sOOwRmTssOHCU6rW9C1Ys66BYCj+Ytg2NBX6XW20/9dMsTpE8a9Q==
X-Gm-Gg: ASbGncsMjo0tAwtUgQHW9AEIc2BJXRzRWh++dpUqHJPeLRnqK9pot+NPc5vij/yra9j
	v7VDxdHLSfnVrBA8VC/4xGInUDVH7ut+uCt6Yy0cPl8ooDXQ1ZQx7LOgTNyY/I15Xj5n4DMQ+aP
	lpW6y2ceCyvxDBnCVQRkZO8F2j9BbMIhnj4RrKOcNZAFgGDVY8l/ZyIGn2pT0VUb6kc28x1IQYK
	8SjXvDy4qdadtmaXQSpOaM3Z475XmFg3W6Y7cPbCzxnJ7kr3NsqpW+MMATy0WGumMjuZksjCfS1
	3DXw
X-Received: by 2002:a05:620a:29c4:b0:7b6:6c46:55b with SMTP id af79cd13be357-7be631e723emr7803652885a.7.1738000722315;
        Mon, 27 Jan 2025 09:58:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6oUW8qg5WZW2WzrO8T9lcYvjYhj3nxTXsAWctcuUg2kNmMQM/AA3bdZZzl5NHEfj4ipzWMQ==
X-Received: by 2002:a05:620a:29c4:b0:7b6:6c46:55b with SMTP id af79cd13be357-7be631e723emr7803647785a.7.1738000721892;
        Mon, 27 Jan 2025 09:58:41 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be9ae7dc98sm411014585a.15.2025.01.27.09.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 09:58:41 -0800 (PST)
Message-ID: <ba1153d1860cd3c25f4d12340d25be3d33bfeae7.camel@redhat.com>
Subject: Re: vmx_pmu_caps_test fails on Skylake based CPUS due to read only
 LBRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 27 Jan 2025 12:58:40 -0500
In-Reply-To: <Z5QsbyZNkzi6qdYJ@google.com>
References: <c9d8269bff69f6359731d758e3b1135dedd7cc61.camel@redhat.com>
	 <Zx-z5sRKCXAXysqv@google.com>
	 <948408887cbe83cbcf05452a53d33fb5aaf79524.camel@redhat.com>
	 <Z5BDr2mm57F0vfax@google.com>
	 <dd128607c0306d21e57994ffb964514728b92f29.camel@redhat.com>
	 <Z5Fc4d5bVf5oVlOk@google.com>
	 <f7b73f3b65377b7fd28f1f4764ea18f98056c51a.camel@redhat.com>
	 <Z5QsbyZNkzi6qdYJ@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2025-01-24 at 16:12 -0800, Sean Christopherson wrote:
> On Fri, Jan 24, 2025, Maxim Levitsky wrote:
> > On Wed, 2025-01-22 at 13:02 -0800, Sean Christopherson wrote:
> > > > > > Note that I read all msrs using 'rdmsr' userspace tool.
> > > > > 
> > > > > I'm pretty sure debugging via 'rdmsr', i.e. /dev/msr, isn't going to work.  I
> > > > > assume perf is clobbering LBR MSRs on context switch, but I haven't tracked that
> > > > > down to confirm (the code I see on inspecition is gated on at least one perf
> > > > > event using LBRs).  My guess is that there's a software bug somewhere in the
> > > > > perf/KVM exchange.
> > > > > 
> > > > > I confirmed that using 'rdmsr' and 'wrmsr' "loses" values, but that hacking KVM
> > > > > to read/write all LBRs during initialization works with LBRs disabled.
> > 
> > Hi!
> > 
> > I finally got to the very bottom of this:
> > 
> > First of all, your assumption that the kernel resets LBR related msrs on
> > context switch after 'wrmsr' program finishes execution is wrong, because the
> > kernel will only do this if it *itself* enables the LBR feature (that is when
> > something like 'perf', uses a perf counter with a lbr call stack).
> > 
> > Writes that 'wrmsr' tool does are not something that kernel expects so it
> > doesn't do anything in this case.
> > 
> > What is happening instead, is something completely different: Turns out that
> > to shave off something like 50 nanoseconds, off the deep C-state entry/exit
> > latency, some Intel CPU don't preserve LBR stack values over these C-state
> > entries.
> 
> Ugh.
> 
> > > Ugh, but it does.  On writes to any LBR, including LBR_TOS, KVM creates a "virtual"
> > > LBR perf event.  KVM then relies on perf to context switch LBR MSRs, i.e. relies
> > > on perf to load the guest's values into hardware.  At least, I think that's what
> > > is supposed to happen.  AFAIK, the perf-based LBR support has never been properly
> > > document[*].
> > > 
> > > Anyways, my understanding of intel_pmu_handle_lbr_msrs_access() is that if the
> > > vCPU's LBR perf event is scheduled out or can't be created, the guest's value is
> > > effectively lost.  Again, I don't know the "rules" for the LBR perf event, but
> > > it wouldn't suprise me if your CI fails because something in the host conflicts
> > > with KVM's LBR perf event.
> > 
> > Actually you are partially wrong here too (although BIOS can be considered
> > 'something on the host').
> > 
> > I was able to prove that the reason why the unit test fails *is* because BIOS
> > left LBRs enabled:
> > 
> > First of all, setting LBR bit manually in DEBUG_CTL does trigger this bug 
> > (I use a different machine now, which doesn't have the bios bug):
> 
> ...
> 
> > ==== Test Assertion Failure ====
> >   x86_64/vmx_pmu_caps_test.c:202: r == v
> >   pid=8415 tid=8415 errno=0 - Success
> >      1	0x0000000000404301: __suite_lbr_perf_capabilities at vmx_pmu_caps_test.c:202
> >      2	 (inlined by) vmx_pmu_caps_lbr_perf_capabilities at vmx_pmu_caps_test.c:194
> >      3	 (inlined by) wrapper_vmx_pmu_caps_lbr_perf_capabilities at vmx_pmu_caps_test.c:194
> >      4	0x000000000040511a: __run_test at kselftest_harness.h:1240
> >      5	0x0000000000402b95: test_harness_run at kselftest_harness.h:1310
> >      6	 (inlined by) main at vmx_pmu_caps_test.c:246
> >      7	0x00007f56ba2295cf: ?? ??:0
> >      8	0x00007f56ba22967f: ?? ??:0
> >      9	0x0000000000402e44: _start at ??:?
> >   Set MSR_LBR_TOS to '0x7', got back '0xc'
> > # lbr_perf_capabilities: Test failed
> > #          FAIL  vmx_pmu_caps.lbr_perf_capabilities
> > not ok 5 vmx_pmu_caps.lbr_perf_capabilities
> > #  RUN           vmx_pmu_caps.perf_capabilities_unsupported ...
> > #            OK  vmx_pmu_caps.perf_capabilities_unsupported
> > ok 6 vmx_pmu_caps.perf_capabilities_unsupported
> > # FAILED: 5 / 6 tests passed.
> > # Totals: pass:5 fail:1 xfail:0 xpass:0 skip:0 error:0
> > 
> > Secondary I went over all places in the kernel and all of them take care to
> > preserve DEBUG_CTL and only set/clear specific bits.
> > 
> > __intel_pmu_lbr_enable() and __intel_pmu_lbr_enable() are practically the
> > only two places where DEBUGCTLMSR_LBR bit is touched, and the test doesn't
> > trigger them. Most likely because the test uses special
> > 'INTEL_FIXED_VLBR_EVENT' perf event (see intel_pmu_create_guest_lbr_event)
> > which is not enabled while in host mode.
> > 
> > To double check this I traced all writes to DEBUG_CTL msr during this test
> > and the only write is done during 'guest_wrmsr_perf_capabilities' subtest, by
> > vmx_vcpu_run() which just restores the value that the msr had prior to VM
> > entry.
> > 
> > So, why the value that BIOS sets survives? Because as I said all code that
> > touches DEBUG_CTL takes care to preserve all bits but the bit which is
> > changed, LBRs are never enabled on the host, and even the guest entry
> > preserves host DEBUG_CTL.  Therefore the value written by BIOS survives.
> 
> Well that's rather insane.
> 
> > So we end up with the test writing to LBR_TOS while LBRs are unexpectedly
> > enabled, so it's not a surprise that when the test reads back the value
> > written, it will differ, and the test will rightfully fail.
> > 
> > Since we have seen this in CI, and you saw it too in your CI,
> 
> Gah, that was bad reporting on my end.  The failure we saw was something else
> entirely.
> 
> > I think this BIOS bug is not that rare, and so I suggest to stick
> > 'wrmsrl(MSR_IA32_DEBUGCTLMSR, 0)' somewhere early in a kernel boot code or at
> > least clear the DEBUGCTLMSR_LBR bit.
> > 
> > I haven't found a very good place to put this, in a way that I can be sure
> > that x86 maintainers won't reject it, so I am open to your suggestions.
> 
> Compile tested only, but perf's CPU online path seems appropriate, especially
> since that path also explicitly clears LBRs.  Ensuring LBRs are stopped before
> clearing them seems logical.
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 99c590da0ae2..6e898b832d75 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -5030,8 +5030,12 @@ static void intel_pmu_cpu_starting(int cpu)
>  
>         init_debug_store_on_cpu(cpu);
>         /*
> -        * Deal with CPUs that don't clear their LBRs on power-up.
> +        * Deal with CPUs that don't clear their LBRs on power-up, and with
> +        * BIOSes that leave LBRs enabled.
>          */
> +       if (!static_cpu_has(X86_FEATURE_ARCH_LBR) && x86_pmu.lbr_nr)
> +               msr_clear_bit(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR_BIT);
> +
>         intel_pmu_lbr_reset();
>  
>         cpuc->lbr_sel = NULL;
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 3ae84c3b8e6d..bb7dd85aa6f2 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -395,7 +395,8 @@
>  #define MSR_IA32_PASID_VALID           BIT_ULL(31)
>  
>  /* DEBUGCTLMSR bits (others vary by model): */
> -#define DEBUGCTLMSR_LBR                        (1UL <<  0) /* last branch recording */
> +#define DEBUGCTLMSR_LBR_BIT            0
> +#define DEBUGCTLMSR_LBR                        (1UL <<  DEBUGCTLMSR_LBR_BIT) /* last branch recording */
>  #define DEBUGCTLMSR_BTF_SHIFT          1
>  #define DEBUGCTLMSR_BTF                        (1UL <<  1) /* single-step on branches */
>  #define DEBUGCTLMSR_BUS_LOCK_DETECT    (1UL <<  2)
> 

I did some simulated test which sets the DEBUGCTLMSR_LBR early in the boot and this patch, and it worked just fine.
I agree that intel_pmu_cpu_starting is the best place to put this workaround.

You might consider refactoring the code that deals with LBR setup into a function,
like init_debug_store_on_cpu, maybe something like init_lbrs_on_cpu, but I don't mind
that, this patch as-is, is fine as well.

If I get my hands on the machine where this originally failed, I'll test there, although
most likely this just a formality.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky





