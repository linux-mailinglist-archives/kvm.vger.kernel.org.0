Return-Path: <kvm+bounces-37620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4ED7A2CA14
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:23:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E54483A743A
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 17:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C9E1957E2;
	Fri,  7 Feb 2025 17:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k6bGkzWc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B80191F95
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 17:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738949008; cv=none; b=bMiSpV7fJ3Z/CELpBIvlVTuwLdvo8WmE82QM3SxXOAhaIdNVZdQioGXEXpv1lwhOh7pgovcCQ7fZmxt4V5z9JqzifAkw3AiLS5BqOeU1iRqgP02erbUOvVdD/KbjWkjCpksS+eFmnmErnvnMA0VFNGA6UdjqQ8gv7y2IGF3kUdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738949008; c=relaxed/simple;
	bh=PQxPFXqaG62SOXmTydcGFIcOTiJY1WblAeoXwXAFCxQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=o7OkxQ49EUiJm255XRB7nUylTU0aODBsM7hCcJcY+5UqYzlHi1Q/UlxxRTctLxcRgE0zxWDbO6EuejnfRZYtAgDCh6AElDeWWS3CxhGOCq3S2PpgiGM7PmyTu7TzWW42N8JvngwxQMz3acVhMDsFFD5BDV4sPJKgOJ6LmqGKB54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k6bGkzWc; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fa228b4143so2372513a91.0
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 09:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738949006; x=1739553806; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vOcxbBJpr4MsHRRcCFUSvs0+uPDtrFbSKcqYFX6+hYs=;
        b=k6bGkzWcyJulSILZRZKhu/vAVwZ8YA1+CNezP4VdLMH2+qJZomYTFaEQGIHCMucmic
         dXlGua2i7b+81ldvzTLu5b14HF8dZFNyeO552YP76pfPjpZif9ZMaUayu1ex7idIuXBG
         DWAE2D55+PEzA8Ml4jFqfI9WN9nCjZVAe0geUNSErJGVyjUOpSvZqj0d1icJFY31pOgU
         nzXv0X6b9eFHemZMgNjgW1tk244bbl4AGVirMKb+s+41Z4A03I2JB5sHoyYE4EYDKBTK
         Hz07UhsRIeAMhwLvTIPOptOcoEEq6Wdl87Ig3emiXbaoNhkRUByp3Hgp2VhJ7ngtUobj
         BBVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738949006; x=1739553806;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vOcxbBJpr4MsHRRcCFUSvs0+uPDtrFbSKcqYFX6+hYs=;
        b=BBiyNPY0//3cmEolJ9hdbPk3YzZljCvZy1Jb5N1VSoCZw2uORP8sibhG1sGop4GRCP
         LEaAjx3kqRLzl1TEt2tg8+TQ2Vpd0GvK+qw/all62jWYEydQgqvHrhl0eLZ3P+xHJANU
         HUQXYdOHGJRpPlvwSdMd6JE51Yp5HOOAJ/K2ARpfcuvX2OMhV/vx7C1KVH1IGsIgE1n8
         memLDRwadcz4t0tr9SI95UDppGkjX8gO1/5uji5XOjBBNkVdfztTj8E61uAm5T6qok4l
         vntSq2AxOVecJhWZbEWTXZTcLHJAJgDOH3ctSMPCQQku76JoZ1FMyuF/SNI4wuDFtMCk
         W5Bw==
X-Forwarded-Encrypted: i=1; AJvYcCUMGyMRaQjMFV4c7sWBR7mDsn4zhYxzYCHjswu0xrar6K35hPJgwe7SPEnDoIt7B4nHGCw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoFsJ+9Z0rUDGmA87YFxPmVEx7PlhC3Z+0xHzdOJqdJnVU6LCG
	JXA5RwX+xSPHQXolLvmgw4rlSS+bXy2DhZ/z/XOP6F+2bdKfplWDWJXsJlSJmaAJwYuy0gkSdwb
	0Rg==
X-Google-Smtp-Source: AGHT+IHtKk+I6CjiXseOd50XgDWMmjujWmhaISGeVrM7QdPNRD38ZmcvZcY1czgAsTeMYVLsyWS8xRRgOkA=
X-Received: from pjbsv3.prod.google.com ([2002:a17:90b:5383:b0:2da:5868:311c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2685:b0:2f5:5bc6:a78d
 with SMTP id 98e67ed59e1d1-2f9ff78641amr13455568a91.3.1738949005804; Fri, 07
 Feb 2025 09:23:25 -0800 (PST)
Date: Fri, 7 Feb 2025 09:23:24 -0800
In-Reply-To: <20250201021718.699411-17-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201021718.699411-1-seanjc@google.com> <20250201021718.699411-17-seanjc@google.com>
Message-ID: <Z6ZBjNdoULymGgxz@google.com>
Subject: Re: [PATCH 16/16] x86/kvmclock: Use TSC for sched_clock if it's
 constant and non-stop
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, 
	xen-devel@lists.xenproject.org, Nikunj A Dadhania <nikunj@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"

Dropping a few people/lists whose emails are bouncing.

On Fri, Jan 31, 2025, Sean Christopherson wrote:
> @@ -369,6 +369,11 @@ void __init kvmclock_init(void)
>  #ifdef CONFIG_X86_LOCAL_APIC
>  	x86_cpuinit.early_percpu_clock_init = kvm_setup_secondary_clock;
>  #endif
> +	/*
> +	 * Save/restore "sched" clock state even if kvmclock isn't being used
> +	 * for sched_clock, as kvmclock is still used for wallclock and relies
> +	 * on these hooks to re-enable kvmclock after suspend+resume.

This is wrong, wallclock is a different MSR entirely.

> +	 */
>  	x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
>  	x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;

And usurping sched_clock save/restore is *really* wrong if kvmclock isn't being
used as sched_clock, because when TSC is reset on suspend/hiberation, not doing
tsc_{save,restore}_sched_clock_state() results in time going haywire.

Subtly, that issue goes all the way back to patch "x86/paravirt: Don't use a PV
sched_clock in CoCo guests with trusted TSC" because pulling the rug out from
under kvmclock leads to the same problem.

The whole PV sched_clock scheme is a disaster.

Hyper-V overrides the save/restore callbacks, but _also_ runs the old TSC callbacks,
because Hyper-V doesn't ensure that it's actually using the Hyper-V clock for
sched_clock.  And the code is all kinds of funky, because it tries to keep the
x86 code isolated from the generic HV clock code, but (a) there's already x86 PV
specific code in drivers/clocksource/hyperv_timer.c, and (b) splitting the code
means that Hyper-V overides the sched_clock save/restore hooks even when PARAVIRT=n,
i.e. when HV clock can't possibly be used as sched_clock.

VMware appears to be buggy and doesn't do have offset adjustments, and also lets
the TSC callbacks run.

I can't tell if Xen is broken, or if it's the sanest of the bunch.  Xen does
save/restore things a la kvmclock, but only in the Xen PV suspend path.  So if
the "normal" suspend/hibernate paths are unreachable, Xen is sane.  If not, Xen
is quite broken.

To make matters worse, kvmclock is a mess and has existing bugs.  The BSP's clock
is disabled during syscore_suspend() (via kvm_suspend()), but only re-enabled in
the sched_clock callback.  So if suspend is aborted due to a late wakeup, the BSP
will run without its clock enabled, which "works" only because KVM-the-hypervisor
is kind enough to not clobber the shared memory when the clock is disabled.  But
over time, I would expect time on the BSP to drift from APs.

And then there's this crud:

  #ifdef CONFIG_X86_LOCAL_APIC
	x86_cpuinit.early_percpu_clock_init = kvm_setup_secondary_clock;
  #endif

which (a) should be guarded by CONFIG_SMP, not X86_LOCAL_APIC, and (b) is only
actually needed when kvmclock is sched_clock, because timekeeping doesn't actually
need to start that early.  But of course kvmclock craptastic handling of suspend
and resume makes untangling that more difficult than it needs to be.

The icing on the cake is that after cleaning up all the hacks, and having
kvmclock hook clocksource.suspend/resume like it should, suspend/resume under
kvmclock corrupts wall clock time because timekeeping_resume() reads the persistent
clock before resuming clocksource clocks, and the stupid kvmclock wall clock subtly
consumes the clocksource/system clock.  *sigh*

I have yet more patches to clean all of this up.  The series is rather unwieldly,
as it's now sitting at 38 patches (ugh), but I don't see a way to chunk it up in
a meaningful way, because everything is so intertwined.  :-/

