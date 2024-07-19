Return-Path: <kvm+bounces-21966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FCBA937CED
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 21:23:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D51B3B21953
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 19:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4592114831D;
	Fri, 19 Jul 2024 19:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yFYwoxP5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205F3146D6E
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 19:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721416969; cv=none; b=TnI8/qiIhGCnOAr7rL3jMhMWfEtg/fESj2++mm2jmJ35qjZjAufXWR/dxyxUVdHSfGbrhxLBdjs1berjirlQliNhUSal8Atwbv/y5aqZu8rcvj8/TYv+iTVYFLKTwciRXcvvJk9CaYi5uZfE//qbpWpeVKgqtnrJdKSlux/O9eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721416969; c=relaxed/simple;
	bh=t2HqDmKb7mRCs02fxXbXPgeSsLUNZY6eyfK155B6aYY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uIovD8n6OPvhZObW6XRPqe2xTA7rJKwrP4c7xARRq9Y/z0vKtKJJabpj+HNZjlBho9PkdLEL+q2Dd51kDguF0Q5M2VdtLdR1XxA89E7UIR3913hnAZO5Tm13SG9zfzmKtoZJ1YtGqsx5tC97AiD3qXqD0RinpFsNb7f0a+zbFoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yFYwoxP5; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc4fcaa2e8so21764565ad.1
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 12:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721416967; x=1722021767; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Jae9ywN6nZ1lAWdDXkM/UYRtVCPU6aPPwnRG/9Xrog=;
        b=yFYwoxP56oDBUhmoStIXM6o4XFszqvP8Q0oFs311unCwcuUbJg8bpsmGUcAGycLMVA
         DFnKgIf9voDxI/QFkzMzqEo7xfO0fzi7iGAbo5Rgn7eXyKXg2TdV+RTR3d+/yTuiGVMJ
         26bsSvTv/xGy2QDNmxtzGZl96fAWcyjEORdtJTVQPRBLkguNyxrY9o81N6L3nn7Qujns
         8sZrJguf43jaGEvhaVLdPDTmJLtSEAWhuW5wWRaH8xo4i8mnuySK10YiVasdxkOpvtsf
         9zFpeA1x12wOMAYeNnWaY2HbAozuylBlyA1+mwmcujelJHh3HJ50KUL7oJ5xtmDgwHGo
         XEpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721416967; x=1722021767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Jae9ywN6nZ1lAWdDXkM/UYRtVCPU6aPPwnRG/9Xrog=;
        b=ieoFjNEkvagQobaa6qXwx2ps7LQCGKs4rVBtIxEX7LzAHVJsPiolsVDvu6rRfXLoq5
         TwYQdTv9kOeNwNAsUbpWibLL3juAh+1PFCo62DbNuu54Jq9prb9bzOU85niV+hNg2m0/
         +NVhcaM6W6hSwuqcbvfW+dVTLDrcdhSupSquJUfRTpqbF/Ir6TqoYsVvsp1jf+c/1auG
         el76aP/RmVmOLPwqPw7O09LurV8FNCxIXQOdW6ezS1Sj9Vc75bRvwUBASXD3Fyy6mzqT
         pT351zuELi2ZrjAHt8X/CRfi6Kpa/a3F0e/6i9eOWNus93jjJn01YQZml68WWaDzqTDj
         pNUg==
X-Gm-Message-State: AOJu0YypFG9uHyiGcZ0nOEJDMhupriQDmlBQhzoSme2B3cdrxdVSWs8k
	bxm9scNDVHhH9MLGgYtDFyo83LYKlH/BKiN4cqJY+Exwk7CnBGmFWYeIuhM5jtjCBrzaJTsY5b4
	09g==
X-Google-Smtp-Source: AGHT+IEdoke5zJ9xiPTrf7+QMFDpqn7WqHGQDmu/sDgiYRNNL3pZNK8fHXeBY0zx9ATu51Xcv7UZPdlKspY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ecd0:b0:1fc:5ef0:23d1 with SMTP id
 d9443c01a7336-1fd745d916fmr366215ad.7.1721416967286; Fri, 19 Jul 2024
 12:22:47 -0700 (PDT)
Date: Fri, 19 Jul 2024 12:22:46 -0700
In-Reply-To: <70137930-fea1-4d45-b453-e6ae984c4b2b@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c42bff52-1058-4bff-be90-5bab45ed57be@gmail.com>
 <ZpqgfETiBXfBfFqU@google.com> <70137930-fea1-4d45-b453-e6ae984c4b2b@gmail.com>
Message-ID: <Zpq9Bp7T_AdbVhmP@google.com>
Subject: Re: [BUG] =?utf-8?Q?arch=2Fx86=2Fkvm=2Fvmx?= =?utf-8?Q?=2Fpmu=5Fintel=2Ec=3A54=3A_error=3A_dereference_of_NULL_?=
 =?utf-8?B?4oCYcG1j4oCZ?= [CWE-476]
From: Sean Christopherson <seanjc@google.com>
To: Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
> On 7/19/24 19:21, Sean Christopherson wrote:
> > On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
> >> Hi,
> >>
> >> In the build of 6.10.0 from stable tree, the following error was detected.
> >>
> >> You see that the function get_fixed_pmc() can return NULL pointer as a result
> >> if msr is outside of [base, base + pmu->nr_arch_fixed_counters) interval.
> >>
> >> kvm_pmu_request_counter_reprogram(pmc) is then called with that NULL pointer
> >> as the argument, which expands to .../pmu.h
> >>
> >> #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
> >>
> >> which is a NULL pointer dereference in that speculative case.
> > 
> > I'm somewhat confused.  Did you actually hit a BUG() due to a NULL-pointer
> > dereference, are you speculating that there's a bug, or did you find some speculation
> > issue with the CPU?
> > 
> > It should be impossible for get_fixed_pmc() to return NULL in this case.  The
> > loop iteration is fully controlled by KVM, i.e. 'i' is guaranteed to be in the
> > ranage [0..pmu->nr_arch_fixed_counters).
> > 
> > And the input @msr is "MSR_CORE_PERF_FIXED_CTR0 +i", so the if-statement expands to:
> > 
> > 	if (MSR_CORE_PERF_FIXED_CTR0 + [0..pmu->nr_arch_fixed_counters) >= MSR_CORE_PERF_FIXED_CTR0 &&
> > 	    MSR_CORE_PERF_FIXED_CTR0 + [0..pmu->nr_arch_fixed_counters) < MSR_CORE_PERF_FIXED_CTR0 + pmu->nr_arch_fixed_counters)
> > 
> > i.e. is guaranteed to evaluate true.
> > 
> > Am I missing something?
> 
> Hi Sean,
> 
> Thank you for replying promptly.
> 
> Perhaps I should have provided the GCC error report in the first place.

Yes, though the report itself is somewhat secondary, what matters the most is how
you found the bug and how to reproduce the failure.  Critically, IIUC, this requires
analyzer-null-dereference, which AFAIK isn't even enabled by W=1, let alone a base
build.

Please see the 0-day bot's reports[*] for a fantastic example of how to report
things that are found by non-standard (by kernel standards) means.

In general, I suspect that analyzer-null-dereference will generate a _lot_ of
false positives, and is probably not worth reporting unless you are absolutely
100% certain there's a real bug.  I (and most maintainers) am happy to deal with
false positives here and there _if_ the signal to noise ratio is high.  But if
most reports are false positives, they'll likely all end up getting ignored.

[*] https://lore.kernel.org/all/202406111250.d8XtA9SC-lkp@intel.com

