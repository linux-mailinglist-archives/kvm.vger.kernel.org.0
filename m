Return-Path: <kvm+bounces-43020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 329AFA82D34
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 19:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C29C94651ED
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 17:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E9D276028;
	Wed,  9 Apr 2025 17:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0IsSIN+f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B8F270EA2
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 17:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744218305; cv=none; b=pdv5/MKZrzWPcd9Ov6AA00a7Ngh8MV9twPfM0r5fLNpJgbeLMZNe30Pv/1we3jTlwOdiVnRNWg0Rc8Apd9oLnMIyF9hluTbmSOQzhEWNNJBAoMeCe/5CNWb9qRW2JvxCYm1bZm2wSXXSBJ01YWniIA/IPjfSPAu6W82+ikUFPx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744218305; c=relaxed/simple;
	bh=i8Zg1guA//+lhxQK2uTFZZPpwn6JYVZCVdGXPvWgvFc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iuH3cGbEvcLDqLq2ZMVqgmOBfgwvMiDbZnBVfrd3mlVbZJWZpw6dbNllaNii+RYYYP6vlH2t1HkfkECqBjZipgh5PZbqzT5dWe83ElUqlV+HfEWBdq7bKMuwTVBfiYmdjfllnfLTzE0e0ipPU8TH38JFhOARhgH6GYrzmUDtgaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0IsSIN+f; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff854a2541so6352607a91.0
        for <kvm@vger.kernel.org>; Wed, 09 Apr 2025 10:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744218302; x=1744823102; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oX5AQF1CWc875K1riqzQPEOYHtRRRjW13afP6TGJ4O4=;
        b=0IsSIN+foHLBkITJENDX/YJAi9MUPbipmO/Erfw8eJc3MdYMcX20am2zMClvksq+80
         rNRDHrt8qHn3dOoufQWyxQBngufLqPPfW12kMCpl4P0av6ZFt+94srxwEvhmSyXv2tdI
         xxsjvACiF6u8sAiT6twwjG1RwpplCq2WdIAHtN6onRsr9OCpQDisYqWyrGe08/Vt7qBn
         C39Y0NXcjziMYmb7icAszXryAihzbHS3RMaAwxmIHGnA/LjFQjP/0CTlBHgTKxDDhsiN
         Dbs1x2XD5KLxDs41GGeCk9424ssbLjg7DCxe8gJAHhAAxpB44nHu4qrPrY1zKr/ogSiB
         UdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744218302; x=1744823102;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oX5AQF1CWc875K1riqzQPEOYHtRRRjW13afP6TGJ4O4=;
        b=jyknCNADK4MMnidIboTMXTwoMXXWSvr3xWWluoF+GQU+KafjlHYK7qVT2Ts2v5e3XK
         tdJWP298gVTRIykw2Lww+/+jiITmcKRqx7RReO1ZTp2RCKH37L+Cbc118vYuNNYRLc+r
         oastSOU5GIBdS07xFU5bR9ub+M9K7lvuRj4MjME/UDHXolD/QC4HeiOTYKgldfS+dEKx
         b8WcgpP3p19MS9pdWZqittHnqpmEI/DWJ9Yo+gonRA5fFLcsKynumTJVB5avbGE6edaZ
         26nqJQCwu9D1iIdc2aSBaTGV21ITu63nRMSLwEFYcLZYqoEFMl1zboRS6H/honqQGK2K
         z/mw==
X-Forwarded-Encrypted: i=1; AJvYcCXiePdJlOBPPzAQXP6LCEop9ps3OFA3TDhJgKmPMUPCHG1BYMM7calXuDaC+U1p0tZRcDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLnFDQjH+2BOyMgtlYaPheH1rJPKSBmBA5812HISYIo6i0FybB
	Cdl5oskl6RZkyGXPleZRS8Vk89k8clImK7U9usvMoOgnsjMBkteZcfIQ9dfvuoYkawYbOk3PBaZ
	BgQ==
X-Google-Smtp-Source: AGHT+IEem0Cj1DZoksj+te/q+i7fjk/ApWH/IZlQdD3zb/NnN621mHgFseqow65YuvbIXi3Fri1358Ay9cM=
X-Received: from pjbqn13.prod.google.com ([2002:a17:90b:3d4d:b0:2ff:5752:a78f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2704:b0:2ff:52e1:c4b4
 with SMTP id 98e67ed59e1d1-306dd5789d1mr3720511a91.32.1744218302030; Wed, 09
 Apr 2025 10:05:02 -0700 (PDT)
Date: Wed, 9 Apr 2025 10:05:00 -0700
In-Reply-To: <Z_VUswFkWiTYI0eD@do-x1carbon>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Z_VUswFkWiTYI0eD@do-x1carbon>
Message-ID: <Z_aovIbwdKIIBMuq@google.com>
Subject: Re: kvm guests crash when running "perf kvm top"
From: Sean Christopherson <seanjc@google.com>
To: Seth Forshee <sforshee@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, 
	linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 08, 2025, Seth Forshee wrote:
> A colleague of mine reported kvm guest hangs when running "perf kvm top"
> with a 6.1 kernel. Initially it looked like the problem might be fixed
> in newer kernels, but it turned out to be perf changes which must avoid
> triggering the issue. I was able to reproduce the guest crashes with
> 6.15-rc1 in both the host and the guest when using an older version of
> perf. A bisect of perf landed on 7b100989b4f6 "perf evlist: Remove
> __evlist__add_default", but this doesn't look to be fixing any kind of
> issue like this.
> 
> This box has an Ice Lake CPU, and we can reproduce on other Ice Lakes
> but could not reproduce on another box with Broadwell. On Broadwell
> guests would crash with older kernels in the host, but this was fixed by
> 971079464001 "KVM: x86/pmu: fix masking logic for
> MSR_CORE_PERF_GLOBAL_CTRL". That does not fix the issues we see on Ice
> Lake.
> 
> When the guests crash we aren't getting any output on the serial
> console, but I got this from a memory dump:

...

> Oops: 0000 [#1] PREEMPT SMP NOPTI
> BUG: kernel NULL pointer dereference, address: 000000000000002828

FWIW, this is probably slightly corrupted.  When I run with EPT disabled, to force
KVM to intercept #PFs, the reported CR2 is 0x28.  Which is consistent with the
guest having DS_AREA=0.  I.e. the CPU is attempting to store into the DS/PEBS
buffer.

As suspected, the issue is PEBS.  After adding a tracepoint to capture the MSRs
that KVM loads as part of the perf transition, it's easy to see that PEBS_ENABLE
gets loaded with a non-zero value immediate before death, doom, and destruction.

  CPU 0: kvm_entry: vcpu 0, rip 0xffffffff81000aa0 intr_info 0x80000b0e error_code 0x00000000
  CPU 0: kvm_perf_msr: MSR 38f: host 1000f000000fe guest 1000f000000ff
  CPU 0: kvm_perf_msr: MSR 600: host fffffe57186af000 guest 0
  CPU 0: kvm_perf_msr: MSR 3f2: host 0 guest 0
  CPU 0: kvm_perf_msr: MSR 3f1: host 0 guest 1
  CPU 0: kvm_exit: vcpu 0 reason EXCEPTION_NMI rip 0xffffffff81000aa0 info1 0x0000000000000028 intr_info 0x80000b0e error_code 0x00000000

The underlying issue is that KVM's current PMU virtualization uses perf_events
to proxy guest events, i.e. piggybacks intel_ctrl_guest_mask, which is also used
by host userspace to communicate exclude_host/exclude_guest.  And so perf's
intel_guest_get_msrs() allows using PEBS for guest events, but only if perf isn't
using PEBS for host events.

I didn't actually verify that "perf kvm top" generates for events, but I assuming
it's creating a precise, a.k.a. PEBS, event that measures _only_ guest, i.e.
excludes host.  That causes a false positive of sorts in intel_guest_get_msrs(),
and ultimately results in KVM running the guest with a PEBS event enabled, even
though the guest isn't using the (virtual) PMU.

Pre-ICX CPUs don't isolate PEBS events across the guest/host boundary, and so
perf/KVM hard disable PEBS on VM-Enter.  And a simple (well, simple for perf)
precise event doesn't cause problems, because perf/KVM will disable PEBS events
that are counting the host.  I.e. if a PEBS event counts host *and* guest, it's
"fine".

Long story short, masking PEBS_ENABLE with the guest's value (in addition to
what perf allows) fixes the issue on my end.  Assuming testing goes well, I'll
post this as a proper patch.

--
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index cdb19e3ba3aa..1d01fb43a337 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4336,7 +4336,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
        arr[pebs_enable] = (struct perf_guest_switch_msr){
                .msr = MSR_IA32_PEBS_ENABLE,
                .host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
-               .guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
+               .guest = pebs_mask & ~cpuc->intel_ctrl_host_mask & kvm_pmu->pebs_enable,
        };
 
        if (arr[pebs_enable].host) {
--


> Let me know if I can provide any additional information or testing.

Uber nit: in the future, explicitly state whether a command is being run in the
guest or host.  I had a brain fart and it took me an embarrasingly long time to
grok that running "perf kvm top" in the guest would be nonsensical.

