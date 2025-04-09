Return-Path: <kvm+bounces-43031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AFA7A831DC
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 22:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6896119E7D00
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 20:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F07D212B3D;
	Wed,  9 Apr 2025 20:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B6XZa/F7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DFD101C8;
	Wed,  9 Apr 2025 20:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744230283; cv=none; b=tb1+qW/43rEYGECqPFtylexoukJD7qx9KyYk8upFTEAIhxeiC0LW+dv3icX4eA/zk2AEgmZKQXm1wVt+njmGbsOYKrUMw8eQqexTiu27zKeKzlknuXZLDa7+qLxqngWz9eA1ShVA3/FG9LUP+oeX6tDgaZg15ynLvv+ao2I+qVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744230283; c=relaxed/simple;
	bh=2DGaCu81+mksOe/jz5U+Y2o/ljB3IPRpgOi+JK/6erc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BiwtE2jutrHv+H2ou2Ashaciy2E77f3VS3lhTJ3OlPJ2qhET4xxP4OKM8QFHotSiHwGmSFsAkr24HhHzCXaFlDacJED0wnrebr/IFxoLD8fRRukZhTuXaT+QMV9P8S7tewNox4j57E8pxn2xoukJSN4TouCUR+8eSZI7ZrAN5m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B6XZa/F7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1060C4CEE2;
	Wed,  9 Apr 2025 20:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744230282;
	bh=2DGaCu81+mksOe/jz5U+Y2o/ljB3IPRpgOi+JK/6erc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B6XZa/F7bZNIT8bFQUNQw7qdEYMx6HCmSFYrqtarQ74rcJGE0P/JsYc2we3j0MloJ
	 wtNHECbv2AWikVRq6G1sKqvGmgGu47UEF2VV4kuJLzY6ti2upbs5lvbEg1Q6H3rEuu
	 fbi7nEhCharrBfRLUpOkz1IwLLY85rYADnqOanmEvX/rDKCltBZ69WPBgsPAAP+7m5
	 g4fzf1FY1Qmu8GGA5eB5n/yrZBGdOvt4p6oQTzFK3UCCJTcMNedqS3gcIk+95RAAXM
	 3zF7pFljDC3TRMwbGXX3CcAakSDXiHxxMywQz4/Eu88Mp0tzMBcl4yfynH2dSKvXGf
	 SJI2Sqg8orrww==
Date: Wed, 9 Apr 2025 15:24:41 -0500
From: Seth Forshee <sforshee@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
	linux-perf-users@vger.kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: kvm guests crash when running "perf kvm top"
Message-ID: <Z_bXiVb8prqRbqh3@do-x1carbon>
References: <Z_VUswFkWiTYI0eD@do-x1carbon>
 <Z_aovIbwdKIIBMuq@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_aovIbwdKIIBMuq@google.com>

On Wed, Apr 09, 2025 at 10:05:00AM -0700, Sean Christopherson wrote:
> On Tue, Apr 08, 2025, Seth Forshee wrote:
> > A colleague of mine reported kvm guest hangs when running "perf kvm top"
> > with a 6.1 kernel. Initially it looked like the problem might be fixed
> > in newer kernels, but it turned out to be perf changes which must avoid
> > triggering the issue. I was able to reproduce the guest crashes with
> > 6.15-rc1 in both the host and the guest when using an older version of
> > perf. A bisect of perf landed on 7b100989b4f6 "perf evlist: Remove
> > __evlist__add_default", but this doesn't look to be fixing any kind of
> > issue like this.
> > 
> > This box has an Ice Lake CPU, and we can reproduce on other Ice Lakes
> > but could not reproduce on another box with Broadwell. On Broadwell
> > guests would crash with older kernels in the host, but this was fixed by
> > 971079464001 "KVM: x86/pmu: fix masking logic for
> > MSR_CORE_PERF_GLOBAL_CTRL". That does not fix the issues we see on Ice
> > Lake.
> > 
> > When the guests crash we aren't getting any output on the serial
> > console, but I got this from a memory dump:
> 
> ...
> 
> > Oops: 0000 [#1] PREEMPT SMP NOPTI
> > BUG: kernel NULL pointer dereference, address: 000000000000002828
> 
> FWIW, this is probably slightly corrupted.  When I run with EPT disabled, to force
> KVM to intercept #PFs, the reported CR2 is 0x28.  Which is consistent with the
> guest having DS_AREA=0.  I.e. the CPU is attempting to store into the DS/PEBS
> buffer.
> 
> As suspected, the issue is PEBS.  After adding a tracepoint to capture the MSRs
> that KVM loads as part of the perf transition, it's easy to see that PEBS_ENABLE
> gets loaded with a non-zero value immediate before death, doom, and destruction.
> 
>   CPU 0: kvm_entry: vcpu 0, rip 0xffffffff81000aa0 intr_info 0x80000b0e error_code 0x00000000
>   CPU 0: kvm_perf_msr: MSR 38f: host 1000f000000fe guest 1000f000000ff
>   CPU 0: kvm_perf_msr: MSR 600: host fffffe57186af000 guest 0
>   CPU 0: kvm_perf_msr: MSR 3f2: host 0 guest 0
>   CPU 0: kvm_perf_msr: MSR 3f1: host 0 guest 1
>   CPU 0: kvm_exit: vcpu 0 reason EXCEPTION_NMI rip 0xffffffff81000aa0 info1 0x0000000000000028 intr_info 0x80000b0e error_code 0x00000000
> 
> The underlying issue is that KVM's current PMU virtualization uses perf_events
> to proxy guest events, i.e. piggybacks intel_ctrl_guest_mask, which is also used
> by host userspace to communicate exclude_host/exclude_guest.  And so perf's
> intel_guest_get_msrs() allows using PEBS for guest events, but only if perf isn't
> using PEBS for host events.
> 
> I didn't actually verify that "perf kvm top" generates for events, but I assuming
> it's creating a precise, a.k.a. PEBS, event that measures _only_ guest, i.e.
> excludes host.  That causes a false positive of sorts in intel_guest_get_msrs(),
> and ultimately results in KVM running the guest with a PEBS event enabled, even
> though the guest isn't using the (virtual) PMU.
> 
> Pre-ICX CPUs don't isolate PEBS events across the guest/host boundary, and so
> perf/KVM hard disable PEBS on VM-Enter.  And a simple (well, simple for perf)
> precise event doesn't cause problems, because perf/KVM will disable PEBS events
> that are counting the host.  I.e. if a PEBS event counts host *and* guest, it's
> "fine".
> 
> Long story short, masking PEBS_ENABLE with the guest's value (in addition to
> what perf allows) fixes the issue on my end.  Assuming testing goes well, I'll
> post this as a proper patch.
> 
> --
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index cdb19e3ba3aa..1d01fb43a337 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -4336,7 +4336,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>         arr[pebs_enable] = (struct perf_guest_switch_msr){
>                 .msr = MSR_IA32_PEBS_ENABLE,
>                 .host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
> -               .guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
> +               .guest = pebs_mask & ~cpuc->intel_ctrl_host_mask & kvm_pmu->pebs_enable,
>         };
>  
>         if (arr[pebs_enable].host) {

This fixes the issue for me, thanks!

> --
> 
> 
> > Let me know if I can provide any additional information or testing.
> 
> Uber nit: in the future, explicitly state whether a command is being run in the
> guest or host.  I had a brain fart and it took me an embarrasingly long time to
> grok that running "perf kvm top" in the guest would be nonsensical.

Apologies, I tried to make sure I differentiated between host vs guest
in my description since I know it gets confusing, but I missed that one.
I'll triple check for that in the future.

