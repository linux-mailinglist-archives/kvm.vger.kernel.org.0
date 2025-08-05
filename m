Return-Path: <kvm+bounces-54033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3904DB1BA95
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4A273B36D2
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3749E29A307;
	Tue,  5 Aug 2025 19:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ePJFqYae"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA1F218AB0
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754420731; cv=none; b=syLyuQoEsbDDGrLgPzSxcEe+ALBOQHfpoXRfdPzV7k9vWIr12yf86hXmkYXnbwmSaY3Ab2AC4Ky19Heqeu2I/9HloV5wFnYiR48yIwqDaKObyJVFzU2E23lsdO2cLJBU5fN6A5hZgqJ7RsRIW+xrf2DAvItptVAFkOA4Fq9RUIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754420731; c=relaxed/simple;
	bh=a50FLnYjbryMJmdW+4ZgeVhCMzW50M8NynvFWUpALqc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jTFioVq7BmiDxeadZJqhyNsW5jp39X5RKu/5YIYHuXr48yBM/qMkLeil38173YnN7VzSladsfV56wuaPMUuznIjGdptXki9CI+xZ1WWZAmOZzbj4RzvHE5S4+V/4DKoPoZMw7IpagyPebrkSRPMGenp8Ah/xwoBYKN2PaKyRMtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ePJFqYae; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so8820174a91.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754420729; x=1755025529; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bS6lzGa+a4UoxmIiZruUwsnBpGjEnGL2s8vnSrdXcIw=;
        b=ePJFqYaeAa++tFW1n27rn0YtZfQIQKWa4eK/UO/lVxadyWZpfrUx6Sc6RelJIwic5a
         3y2DJk06gN7+HyLc2D8CMw421kUJS1qytH/Yv17Le9yA2OLo0Y53m+3mEhatwfkt9bAr
         kyNF8UraEKatezvTfpZsf9wAYKWpleWbqHCoUphn01Nh0OUNNCy5ScMRj4B5aH9rhctw
         vqVJbl3rj6FzX8H3Y6e4zF2Z8U1EGamF0yhp1EW8h/eRzkMsY9Z7z4mlQvIRMjsRsCik
         dhcNm2nNSYc06e4hfZWpq3eOVhiZO6CIvpWFklNWzmlYNCtrkGT4E0trfbnusXbOpzZM
         r2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754420729; x=1755025529;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bS6lzGa+a4UoxmIiZruUwsnBpGjEnGL2s8vnSrdXcIw=;
        b=Dv/f3zZmb3al/HtyLrFpibb+cb7K7Bbz3XgnVfK7blAQo/qMbfAlrv02FKZ7F04Ewz
         QSHsJsyZWpJzH540pAb/WkpUefGJW8Sm1aOZ13XeuKIgvtuPHIXwdsl/KndCAMakLNR6
         kKb3mtrJAUdHyYP+5wEiSU2ZefAISEVkb4cCp2JCuXhTtX0NLl0V/GH4vAu3WcK1lbGd
         JrIiS2jz5AETEbwh+LYIg17wT+VXzL9sEgpWg+/fyZ+t8wvHRDyu/ifWsZ8JA9d45B/z
         yq2euSmXQM5tanwlZLfiiwzxmq0GqoV5D7ecUVJBL9mtffP0XdVmjkcv+wwtYPGOOUg1
         YEVA==
X-Gm-Message-State: AOJu0YyBimNswJg9tIwg2vCI4gl8VIVfDwWZEsaE/72tNAs5ooI+CYxV
	UHH1PdF+dVAfQ6xJqf7p9OfKnmc3ke5QtEYilXBfPwYG9WXfN6TpxEUlSqvjacAvZsiuy/83XV/
	aadBTmA==
X-Google-Smtp-Source: AGHT+IHuXgga47QgLpiDcAb7ecTVo2jB0HFPscDo4Uwpkl9uNuR9J8wQh7clBJZ+ZAj0PIKE9mft2wsX57U=
X-Received: from pjpo11.prod.google.com ([2002:a17:90a:9f8b:b0:31f:6ddd:ef5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4984:b0:31f:1db2:69b1
 with SMTP id 98e67ed59e1d1-321162b5186mr21688924a91.18.1754420729216; Tue, 05
 Aug 2025 12:05:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 12:05:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805190526.1453366-1-seanjc@google.com>
Subject: [PATCH 00/18] KVM: x86: Fastpath cleanups and PMU prep work
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"

This is a prep series for the mediated PMU, and for Xin's series to add
support for the immediate forms of RDMSR and WRMSRNS (I'll post a v3 of
that series on top of this).

The first half cleans up a variety of warts and flaws in the VM-Exit fastpath
handlers.  The second half cleans up the PMU code related to "triggering"
instruction retired and branches retired events.  The end goal of the two
halves (other than general cleanup) is to be able bail from the fastpath when
using the mediated PMU and the guest is counting instructions retired, with
minimal overhead, e.g. without having to acquire SRCU.

Because the mediated PMU context switches PMU state _outside_ of the fastpath,
the mediated PMU won't be able to increment PMCs in the fastpath, and so won't
be able to skip emulated instructions in the fastpath if the vCPU is counting
instructions retired.

The last patch to handle INVD in the fastpath is a bit dubious.  It works just
fine, but it's dangerously close to "just because we can, doesn't mean we
should" territory.  I added INVD to the fastpath before I realized that
MSR_IA32_TSC_DEADLINE could be handled in the fastpath irrespective of the
VMX preemption timer, i.e. on AMD CPUs.  But being able to use INVD to test
the fastpath is still super convenient, as there are no side effects (unless
someone ran the test on bare metal :-D), no register constraints, and no
vCPU model requirements.  So, I kept it, because I couldn't come up with a
good reason not to.

Sean Christopherson (18):
  KVM: SVM: Skip fastpath emulation on VM-Exit if next RIP isn't valid
  KVM: x86: Add kvm_icr_to_lapic_irq() helper to allow for fastpath IPIs
  KVM: x86: Only allow "fast" IPIs in fastpath WRMSR(X2APIC_ICR) handler
  KVM: x86: Drop semi-arbitrary restrictions on IPI type in fastpath
  KVM: x86: Unconditionally handle MSR_IA32_TSC_DEADLINE in fastpath
    exits
  KVM: x86: Acquire SRCU in WRMSR fastpath iff instruction needs to be
    skipped
  KVM: x86: Unconditionally grab data from EDX:EAX in WRMSR fastpath
  KVM: x86: Fold WRMSR fastpath helpers into the main handler
  KVM: x86/pmu: Move kvm_init_pmu_capability() to pmu.c
  KVM: x86/pmu: Add wrappers for counting emulated instructions/branches
  KVM: x86/pmu: Calculate set of to-be-emulated PMCs at time of WRMSRs
  KVM: x86/pmu: Rename pmc_speculative_in_use() to
    pmc_is_locally_enabled()
  KVM: x86/pmu: Open code pmc_event_is_allowed() in its callers
  KVM: x86/pmu: Drop redundant check on PMC being globally enabled for
    emulation
  KVM: x86/pmu: Drop redundant check on PMC being locally enabled for
    emulation
  KVM: x86/pmu: Rename check_pmu_event_filter() to
    pmc_is_event_allowed()
  KVM: x86: Push acquisition of SRCU in fastpath into
    kvm_pmu_trigger_event()
  KVM: x86: Add a fastpath handler for INVD

 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/lapic.c            |  59 ++++++++----
 arch/x86/kvm/lapic.h            |   3 +-
 arch/x86/kvm/pmu.c              | 155 +++++++++++++++++++++++++-------
 arch/x86/kvm/pmu.h              |  60 ++-----------
 arch/x86/kvm/svm/svm.c          |  14 ++-
 arch/x86/kvm/vmx/nested.c       |   2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |   2 +-
 arch/x86/kvm/vmx/vmx.c          |   2 +
 arch/x86/kvm/x86.c              |  85 +++++-------------
 arch/x86/kvm/x86.h              |   1 +
 11 files changed, 218 insertions(+), 168 deletions(-)


base-commit: 196d9e72c4b0bd68b74a4ec7f52d248f37d0f030
-- 
2.50.1.565.gc32cd1483b-goog


