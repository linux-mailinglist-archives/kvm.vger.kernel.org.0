Return-Path: <kvm+bounces-32288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 845199D52E6
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:56:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45799281C00
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 18:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E1BE1DE4D9;
	Thu, 21 Nov 2024 18:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VptYPwhn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6021BF7E5
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215202; cv=none; b=pytCSxRZh2/oyDEK58tHM+aUbvF09me5eMkd7BJmd1oIVRdhEJ1Z6lAmx5D6PMfpvWu/uQZ2NvHwHyEKfspteb/OhqseHRBcmxtT/mSOfImmNTbpdaGIOmo1euq2MYMHZMWRnWQFBUM1VPDCymMTzlpOhseipHyHj56KT/VKyqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215202; c=relaxed/simple;
	bh=VFdt9cilaiyxS1TXoF0548lV9YvYhKTjRGbWjbjdNe4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ehiGs0fmE9Ip8HYeIAu047v98eFV6Mgvef+m+bf4gFkqha5QucQit0DsEGl34PltYRObQF/ZEfCfSrWGik0m0yJLCuZFkGuNbWKSSrOaaA7sU5jI3tIwKGeMXTAZewErYIposyDC2F7KzOdGkENr18MF1JlA+wziZ90zz83xnIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VptYPwhn; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-72463e726b3so1266210b3a.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215198; x=1732819998; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5+lzBQC5Ttw9j6ggXls2txYNDG8DC9c3ckF1XngrbFM=;
        b=VptYPwhnZjlbM7SJkKKxGWxJ7tKKaIPO+Ql37o3Q4XbpHnEnJ48UGNO4UWvNXSdlQF
         BZwRf7cxGNGWdX9lXMAiAR4mQs5mLpt6FtJBDIHAXrMtnRARri6yaBYIaQd8umunhNch
         MYXLxisDVjvXgb/OHGUNvYQlwt4cnHhdrPR6XcZIhyE3Rc+4UqMJhMlU1M3XK/2gswwg
         l6uOixXYBAFEZNxxGOXLPHZc5uRZAK6jAfSj80oTqVksZkCawf8nzozH22lm6Oud8/CD
         N9N5zDGrXH2XH8ZCDdZrdzAixhzcoc8zrtLN8llqsMiIo71b7ATyT4lAGAXDstjZtgV2
         CWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215198; x=1732819998;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5+lzBQC5Ttw9j6ggXls2txYNDG8DC9c3ckF1XngrbFM=;
        b=jzhzaGiRmfQI6KJspyTVugxC/WksNhaA4UngFteXZJ90LDes3FP5uMg6fZaux+H17G
         HT9XABAjVgi1tTjKqi3i8tfmlGBo1Pj03szazoIXCQfIAgj1fNrZJXAnQ/hEU49LYvw/
         RiMWCnEoCSovpF+4vC40NF0jPbf2zF+6fiiL0g/JzdqWL7SQZsMinIgFX0EFVQJTvHIO
         4tWqSy0PT4qjyGpBFAAy/bOVVlLG4aSmGxOSb7I9QydR6bCyAa3IdeEoTgOiuKpoCZLJ
         Kt1rze/Jlt4QzOZNtDjvMyloeje+JldTRVZ0Qz/bSxt/F3yugdk7ntNtaQokLA4E8nIi
         9nNw==
X-Forwarded-Encrypted: i=1; AJvYcCUMw77dBlJoH0kWxM6bH7KP17YF6LMPF+QBSiJjzy2zQl5f+bhdAZD2Hcgmmnzzhpzynbk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIIsql++jvgQAnYBzKDzwSJzXVoGdLwAByRoTWEhh8752iz9pD
	dX2e+CyytV+hkjOf/dMrMvBcFcEy8mQvdNC/J1glpgsC/BAI5sv9Tn/Dahz1pYcBhA4wudv5wpw
	GN9XmKw==
X-Google-Smtp-Source: AGHT+IEQVIhgBrxcrY39bxedIn0TvpboCw05sUP5QffbMKzXRZU6fQePTnsrcLehryI6ThvkNhu3SeWxP9T/
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:aa7:818f:0:b0:724:c7a7:2d60 with SMTP id
 d2e1a72fcca58-724df70931amr10b3a.6.1732215197723; Thu, 21 Nov 2024 10:53:17
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:52:52 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-1-mizhang@google.com>
Subject: [RFC PATCH 00/22] KVM: x86: Virtualize IA32_APERF and IA32_MPERF MSRs
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Linux guests read IA32_APERF and IA32_MPERF on every scheduler tick
(250 Hz by default) to measure their effective CPU frequency. To avoid
the overhead of intercepting these frequent MSR reads, allow the guest
to read them directly by loading guest values into the hardware MSRs.

These MSRs are continuously running counters whose values must be
carefully tracked during all vCPU state transitions:
- Guest IA32_APERF advances only during guest execution
- Guest IA32_MPERF advances at the TSC frequency whenever the vCPU is
  in C0 state, even when not actively running
- Host kernel access is redirected through get_host_[am]perf() which
  adds per-CPU offsets to the hardware MSR values
- Remote MSR reads through /dev/cpu/*/msr also account for these
  offsets

Guest values persist in hardware while the vCPU is loaded and
running. Host MSR values are restored on vcpu_put (either at KVM_RUN
completion or when preempted) and when transitioning to halt state.

Note that guest TSC scaling via KVM_SET_TSC_KHZ is not supported, as
it would require either intercepting MPERF reads on Intel (where MPERF
ticks at host rate regardless of guest TSC scaling) or significantly
complicating the cycle accounting on AMD.

The host must have both CONSTANT_TSC and NONSTOP_TSC capabilities
since these ensure stable TSC frequency across C-states and P-states,
which is required for accurate background MPERF accounting.

Jim Mattson (14):
  x86/aperfmperf: Introduce get_host_[am]perf()
  x86/aperfmperf: Introduce set_guest_[am]perf()
  x86/aperfmperf: Introduce restore_host_[am]perf()
  x86/msr: Adjust remote reads of IA32_[AM]PERF by the per-cpu host
    offset
  KVM: x86: Introduce kvm_vcpu_make_runnable()
  KVM: x86: INIT may transition from HALTED to RUNNABLE
  KVM: nSVM: Nested #VMEXIT may transition from HALTED to RUNNABLE
  KVM: nVMX: Nested VM-exit may transition from HALTED to RUNNABLE
  KVM: x86: Make APERFMPERF a governed feature
  KVM: x86: Initialize guest [am]perf at vcpu power-on
  KVM: x86: Load guest [am]perf when leaving halt state
  KVM: x86: Introduce kvm_user_return_notifier_register()
  KVM: x86: Restore host IA32_[AM]PERF on userspace return
  KVM: x86: Update aperfmperf on host-initiated MP_STATE transitions

Mingwei Zhang (8):
  KVM: x86: Introduce KVM_X86_FEATURE_APERFMPERF
  KVM: x86: Load guest [am]perf into hardware MSRs at vcpu_load()
  KVM: x86: Save guest [am]perf checkpoint on HLT
  KVM: x86: Save guest [am]perf checkpoint on vcpu_put()
  KVM: x86: Allow host and guest access to IA32_[AM]PERF
  KVM: VMX: Pass through guest reads of IA32_[AM]PERF
  KVM: SVM: Pass through guest reads of IA32_[AM]PERF
  KVM: x86: Enable guest usage of X86_FEATURE_APERFMPERF

 arch/x86/include/asm/kvm_host.h  |  11 ++
 arch/x86/include/asm/topology.h  |  10 ++
 arch/x86/kernel/cpu/aperfmperf.c |  65 +++++++++++-
 arch/x86/kvm/cpuid.c             |  12 ++-
 arch/x86/kvm/governed_features.h |   1 +
 arch/x86/kvm/lapic.c             |   5 +-
 arch/x86/kvm/reverse_cpuid.h     |   6 ++
 arch/x86/kvm/svm/nested.c        |   2 +-
 arch/x86/kvm/svm/svm.c           |   7 ++
 arch/x86/kvm/svm/svm.h           |   2 +-
 arch/x86/kvm/vmx/nested.c        |   2 +-
 arch/x86/kvm/vmx/vmx.c           |   7 ++
 arch/x86/kvm/vmx/vmx.h           |   2 +-
 arch/x86/kvm/x86.c               | 171 ++++++++++++++++++++++++++++---
 arch/x86/lib/msr-smp.c           |  11 ++
 drivers/cpufreq/amd-pstate.c     |   4 +-
 drivers/cpufreq/intel_pstate.c   |   5 +-
 17 files changed, 295 insertions(+), 28 deletions(-)


base-commit: 0a9b9d17f3a781dea03baca01c835deaa07f7cc3
-- 
2.47.0.371.ga323438b13-goog


