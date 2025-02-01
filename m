Return-Path: <kvm+bounces-37046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 080B1A24678
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 03:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 788E41888F49
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B896135977;
	Sat,  1 Feb 2025 02:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vm8/DXOd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349195258
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 02:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738376249; cv=none; b=U+lZhGzNXZmwu5jxU6rA9BywhuGFBbEA97EDjCIdtfdQ6wj3NSLbclvBmz8mkvG+SzfVk5hlVTm0Q7VDkTjllADPUZG6e+O9UDaFJuGwmB2vD1/5Y29e2AjvgECi+A+yoRGpopD2/d3KN4ft/cVLKHAd40kjPKspeQCSzh9dJkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738376249; c=relaxed/simple;
	bh=czE4vHieuE0f098+c8QgKQmkSyW9XE5v2cPcm44Mx3I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dAQwq/1luWCh5jo4kR83YYrMmRnOrB086nV0vb4vd5tU4d62+xy3kF/smNccoV8P+wBw6fik8GWsg3hIDHoa0RYeIoEqTxrU3t2T2hqINSH6IgrKWHzRj0slVkzp90JNEEJoAWedcJhznx6FIeBYTwxe6wcnQM2F3lrOCtxZdIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vm8/DXOd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9b9981f1so7258772a91.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 18:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738376247; x=1738981047; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cq2j2i7xKbEmxmaKlx5ycVjsc6NUu7PBqfSVX6ZfTN4=;
        b=Vm8/DXOdxz24+8Ko7/FCbk1zLSWOTHwsmWZ/Ll3qRjcnMh0mbQkwe8ZdXyBwfsPgsS
         Unq0/LxfkrskfWnp5B7JJ/BOkT7DHbUZeloOXdJfRbVng37bPmVVn10ktscbna+t1VG5
         vsVDtOiaPfbpQm5c4bOQ0cfU1gW0uxK7t2btpTy7eFp9EgMQ/9l/YnoO4wUHi6hI4rgc
         X8TuMEyxELzMn+6+VCo1UXZKfQtINtoAv5Uqk8pUyvkiL99auZbLKYspYJ9My6xcyy0W
         3M2WFbNcpEWK471bC8AcIm7DtChLhzn0+4hxDlN6mL5VHspVmo1XAorK+1e5ErKSBnWr
         QTfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738376247; x=1738981047;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cq2j2i7xKbEmxmaKlx5ycVjsc6NUu7PBqfSVX6ZfTN4=;
        b=MvB8fA0j8OC5ZIkKxNi6Z6W6iXZjRiB8V5krWTUjnJw0WpftERlvT9vLP97P2Rxgrf
         /29xj5eWxhvUvbiSFayjmyXYxPvJ5e+pHLsz3FyfK3zqJo0VPf6qSyrID5bXKIy48AUv
         BaiyV39za2BGQ3Z5aio2PW9U9gbr4DKGSH7eX/9EacrE/ryM5DTOY0eCTOelAXpBXvE1
         7lblrquV5xGWNheh4vTtFP1AEPBI4AtaQvvyAb0AIrW+GS4i2Z5hUEAA1sHO17d5Y18M
         VQlvk/XGa7uzbaUeuQD7RPvbN7emefJYFSNVbz1xmezLCUtTEqp57emKLxISDFRVNi0A
         wT6A==
X-Forwarded-Encrypted: i=1; AJvYcCXnka5XCZO2kCrZavGyHUbLj/c2UgLaO85JNRc/vzxT8QlBmmc6nemEBXsi9601LJFynOE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuYq8yH2PU+xae60R23bJsZz23Lq4I48WelFeusT2GJPlPq73E
	lglELYtz8VAO3jzwR0pVA2skprEOFES8iOwvNxgT0AuygmokC3G8BqIdY9Bv32ZssUAmplzZGqj
	Mng==
X-Google-Smtp-Source: AGHT+IEXms2W7h6OPbgfhbPe+T0bjO3rPyG4kBeOBL1XLya2FJ/dryX9qDtrHv/AVlJBJdJ2J5PBFLJRbi4=
X-Received: from pjbsw11.prod.google.com ([2002:a17:90b:2c8b:b0:2ef:a732:f48d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:258c:b0:2ee:f687:6acb
 with SMTP id 98e67ed59e1d1-2f83abd9998mr19471173a91.13.1738376247517; Fri, 31
 Jan 2025 18:17:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 18:17:02 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201021718.699411-1-seanjc@google.com>
Subject: [PATCH 00/16] x86/tsc: Try to wrangle PV clocks vs. TSC
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.amakhalov@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-hyperv@vger.kernel.org, 
	jailhouse-dev@googlegroups.com, kvm@vger.kernel.org, 
	xen-devel@lists.xenproject.org, Sean Christopherson <seanjc@google.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

Attempt to bring some amount of order to the PV clocks vs. TSC madness in
the kernel.  The primary goal of this series is to fix flaws with SNP
and TDX guests where a PV clock provided by the untrusted hypervisor is
used instead of the secure/trusted TSC that is controlled by trusted
firmware.

The secondary goal (last few patches) is to draft off of the SNP and TDX
changes to slightly modernize running under KVM.  Currently, KVM guests
will use TSC for clocksource, but not sched_clock.  And they ignore Intel's
CPUID-based TSC and CPU frequency enumeration, even when using the TSC
instead of kvmclock.  And if the host provides the core crystal frequency
in CPUID.0x15, then KVM guests can use that for the APIC timer period
instead of manually calibrating the frequency.

Lots more background: https://lore.kernel.org/all/20250106124633.1418972-13-nikunj@amd.com

This is all *very* lightly tested (borderline RFC).

Sean Christopherson (16):
  x86/tsc: Add a standalone helpers for getting TSC info from CPUID.0x15
  x86/tsc: Add standalone helper for getting CPU frequency from CPUID
  x86/tsc: Add helper to register CPU and TSC freq calibration routines
  x86/sev: Mark TSC as reliable when configuring Secure TSC
  x86/sev: Move check for SNP Secure TSC support to tsc_early_init()
  x86/tdx: Override PV calibration routines with CPUID-based calibration
  x86/acrn: Mark TSC frequency as known when using ACRN for calibration
  x86/tsc: Pass KNOWN_FREQ and RELIABLE as params to registration
  x86/tsc: Rejects attempts to override TSC calibration with lesser
    routine
  x86/paravirt: Move handling of unstable PV clocks into
    paravirt_set_sched_clock()
  x86/paravirt: Don't use a PV sched_clock in CoCo guests with trusted
    TSC
  x86/kvmclock: Mark TSC as reliable when it's constant and nonstop
  x86/kvmclock: Get CPU base frequency from CPUID when it's available
  x86/kvmclock: Get TSC frequency from CPUID when its available
  x86/kvmclock: Stuff local APIC bus period when core crystal freq comes
    from CPUID
  x86/kvmclock: Use TSC for sched_clock if it's constant and non-stop

 arch/x86/coco/sev/core.c        |  9 ++--
 arch/x86/coco/tdx/tdx.c         | 27 ++++++++--
 arch/x86/include/asm/paravirt.h |  7 ++-
 arch/x86/include/asm/tdx.h      |  2 +
 arch/x86/include/asm/tsc.h      | 67 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/acrn.c      |  5 +-
 arch/x86/kernel/cpu/mshyperv.c  | 11 +++--
 arch/x86/kernel/cpu/vmware.c    |  9 ++--
 arch/x86/kernel/jailhouse.c     |  6 +--
 arch/x86/kernel/kvmclock.c      | 88 +++++++++++++++++++++++----------
 arch/x86/kernel/paravirt.c      | 15 +++++-
 arch/x86/kernel/tsc.c           | 74 ++++++++++++++++-----------
 arch/x86/mm/mem_encrypt_amd.c   |  3 --
 arch/x86/xen/time.c             |  4 +-
 14 files changed, 243 insertions(+), 84 deletions(-)


base-commit: ebbb8be421eefbe2d47b99c2e1a6dd840d7930f9
-- 
2.48.1.362.g079036d154-goog


