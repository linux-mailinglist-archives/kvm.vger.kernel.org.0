Return-Path: <kvm+bounces-26882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73EE3978C5A
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 03:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 366DF282868
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 01:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D72CD1754B;
	Sat, 14 Sep 2024 01:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m6FzPeXU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CEDDDAB
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 01:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726276437; cv=none; b=QnTJKCCuF12th1M3q33mQamLRXRZTCN6q04ty0zYwHBn/yHdVd8VD1HHgCLo+1pwGd6mZbrXHmD4zgGqShK8C6NbFmtmWwfE8B4k660A8AxAx1Zt/Y8kw/+ChlqgrccLhQm0ZJvPrI/hIHvBj/EoPB2+jgQ/7CoGMQfuN/ayia8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726276437; c=relaxed/simple;
	bh=tbJ2fbywyEYiNK7oO5Ch4oPfiPSjK8RRgUt3VXS92eE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Flx4z6oNhODoz8xLWm6mn3Pud59x7RV8sZYdxM+vSVSS8JsvhRrHiz9cCUY4UKEDH6OheCioXHHjWHk7DCZXCuXWK9I8SydtINlv+V0Qhze1d2LDQzDVQ2PcmXMNZ6UB/s3PBwWaQ4S9WFC2JKdP3MSV4D6i9fhhMLdbP92cvzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m6FzPeXU; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7db1762d70fso1289749a12.2
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 18:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726276435; x=1726881235; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0eUzHbE7RFQ4bpUGANQPMKixAv9OiFz7ajFe5aARpWI=;
        b=m6FzPeXUXR7ZyzmstrCp8IucRWwJC/SR9UsZd7NOWL2RqkMgkABOZH3qU3Nwvkf6bU
         gaVcP0mr3xACZNKwgeQ9UdRPIAVetb6T6/OrC+Cc/SEMIOIXKI1E8mrxtslDEs9Z4fM+
         4WYRoZ2yB8HIMgUP+mZJD2FZxsFXw3+SYqR6VKSOKzIiR2J223pYdKQTnx7AkGbWxS2Z
         zEI4Uxwm7lCJMumjzpQVHFFvZymz0pkut0fq1Dd0FPmK9HrZITdwJYi26ul97zO9av9R
         7paVoSJ6M7MN1fQkFaQK1BTUIgisJVd28f3qKqXgQv8FIb7dfe1UpMuy3STKOBEhs5SX
         LsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726276435; x=1726881235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0eUzHbE7RFQ4bpUGANQPMKixAv9OiFz7ajFe5aARpWI=;
        b=nf0TnzlWzQne+Ko2VN+Xig7OyR3pM9Pu8qfG63u3U+XaWueCkzTZwai6ExXaRyQHWl
         W0K8TMQV0Lgr3WapoIomyT2y0YoHZqoU6Fs8uAokxvInWtHsgG9tsTw/jSlPAe4G41Gf
         LpAxU8dEkk4lriSn3fkMMHY4BWsE03UBmqjeRH+Aa19u9D8aIzejX5Bk+zygKawhHWWd
         scwJuJxCiSi9WQQsN2zidZBm9bp91Q1W3lH58OoTWqYWkzv9qg9dySb3W9yOCm75lSEv
         S7GHWBzZn+Qkosd+b6snmkOQkYp3vE2qppiPvp6Jwc/+gZtqeuSPCP836gZP0V5BVF+z
         378g==
X-Gm-Message-State: AOJu0YxDg00gDJtnQuN9RT2pfLBGa0smM8oYE1jusnoiMMtg4CbKlEKc
	YDkoy8Vm+lQ5tRMZCENDvhxxEpFjWCcJLjI8SH+m3OYwUChuFOHbuBwi4wCfzzENmI03lxVvvZh
	F3Q==
X-Google-Smtp-Source: AGHT+IF+PF6xPdFlEhb4A6LGdbRcTGc+bTCG8xZjyE7asr6+YExfNMxMK+LwtSqL4Xho6J9oxCdenAVMQh4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:b216:0:b0:7a2:cd4d:2a29 with SMTP id
 41be03b00d2f7-7db2f98c2a5mr9465a12.10.1726276434643; Fri, 13 Sep 2024
 18:13:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Sep 2024 18:13:43 -0700
In-Reply-To: <20240914011348.2558415-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240914011348.2558415-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240914011348.2558415-3-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.12
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The highlight is a rework of the userspace MSR access code to automatically
suppress errors on disallowed accesses to advertised-but-unsupported MSRs.
Unfortunately, actually removing all of the !host_initiated exemptions in KVM
is decidely non-trivial, so realizing most the benefits will have to wait
(though this should make life much easier for CET enabling).

The lowlight is a rework of the x2APIC ICR handling.  KVM jumped through hoops
to deal with Intel CPUs storing the full 64-bit value at the ICR offset in the
vAPIC page, and then AMD (x2AVIC) came along and continued to split the value
to the legacy ICR and ICR2 offsets.  *sigh*

The following changes since commit 47ac09b91befbb6a235ab620c32af719f8208399:

  Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.12

for you to fetch changes up to 4ca077f26d885cbc97e742a5f3572aac244a0f8a:

  KVM: x86: Remove some unused declarations (2024-09-09 20:12:43 -0700)

----------------------------------------------------------------
KVM x86 misc changes for 6.12

 - Advertise AVX10.1 to userspace (effectively prep work for the "real" AVX10
   functionality that is on the horizon).

 - Rework common MSR handling code to suppress errors on userspace accesses to
   unsupported-but-advertised MSRs.  This will allow removing (almost?) all of
   KVM's exemptions for userspace access to MSRs that shouldn't exist based on
   the vCPU model (the actual cleanup is non-trivial future work).

 - Rework KVM's handling of x2APIC ICR, again, because AMD (x2AVIC) splits the
   64-bit value into the legacy ICR and ICR2 storage, whereas Intel (APICv)
   stores the entire 64-bit value a the ICR offset.

 - Fix a bug where KVM would fail to exit to userspace if one was triggered by
   a fastpath exit handler.

 - Add fastpath handling of HLT VM-Exit to expedite re-entering the guest when
   there's already a pending wake event at the time of the exit.

 - Finally fix the RSM vs. nested VM-Enter WARN by forcing the vCPU out of
   guest mode prior to signalling SHUTDOWN (architecturally, the SHUTDOWN is
   supposed to hit L1, not L2).

----------------------------------------------------------------
Li Chen (1):
      KVM: x86: Use this_cpu_ptr() in kvm_user_return_msr_cpu_online

Sean Christopherson (26):
      KVM: SVM: Disallow guest from changing userspace's MSR_AMD64_DE_CFG value
      KVM: x86: Move MSR_TYPE_{R,W,RW} values from VMX to x86, as enums
      KVM: x86: Rename KVM_MSR_RET_INVALID to KVM_MSR_RET_UNSUPPORTED
      KVM: x86: Refactor kvm_x86_ops.get_msr_feature() to avoid kvm_msr_entry
      KVM: x86: Rename get_msr_feature() APIs to get_feature_msr()
      KVM: x86: Refactor kvm_get_feature_msr() to avoid struct kvm_msr_entry
      KVM: x86: Funnel all fancy MSR return value handling into a common helper
      KVM: x86: Hoist x86.c's global msr_* variables up above kvm_do_msr_access()
      KVM: x86: Suppress failures on userspace access to advertised, unsupported MSRs
      KVM: x86: Suppress userspace access failures on unsupported, "emulated" MSRs
      KVM: x86: Enforce x2APIC's must-be-zero reserved ICR bits
      KVM: x86: Move x2APIC ICR helper above kvm_apic_write_nodecode()
      KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for AMD (x2AVIC)
      KVM: selftests: Open code vcpu_run() equivalent in guest_printf test
      KVM: selftests: Report unhandled exceptions on x86 as regular guest asserts
      KVM: selftests: Add x86 helpers to play nice with x2APIC MSR #GPs
      KVM: selftests: Skip ICR.BUSY test in xapic_state_test if x2APIC is enabled
      KVM: selftests: Test x2APIC ICR reserved bits
      KVM: selftests: Verify the guest can read back the x2APIC ICR it wrote
      KVM: selftests: Play nice with AMD's AVIC errata
      KVM: x86: Re-enter guest if WRMSR(X2APIC_ICR) fastpath is successful
      KVM: x86: Dedup fastpath MSR post-handling logic
      KVM: x86: Exit to userspace if fastpath triggers one on instruction skip
      KVM: x86: Reorganize code in x86.c to co-locate vCPU blocking/running helpers
      KVM: x86: Add fastpath handling of HLT VM-Exits
      KVM: x86: Forcibly leave nested if RSM to L2 hits shutdown

Tao Su (1):
      KVM: x86: Advertise AVX10.1 CPUID to userspace

Thorsten Blum (1):
      KVM: x86: Optimize local variable in start_sw_tscdeadline()

Yue Haibing (1):
      KVM: x86: Remove some unused declarations

 arch/x86/include/asm/cpuid.h                       |   1 +
 arch/x86/include/asm/kvm-x86-ops.h                 |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   5 +-
 arch/x86/kvm/cpuid.c                               |  30 +-
 arch/x86/kvm/lapic.c                               |  75 +-
 arch/x86/kvm/lapic.h                               |   1 -
 arch/x86/kvm/mmu.h                                 |   2 -
 arch/x86/kvm/mmu/mmu_internal.h                    |   2 -
 arch/x86/kvm/reverse_cpuid.h                       |   8 +
 arch/x86/kvm/smm.c                                 |  24 +-
 arch/x86/kvm/svm/svm.c                             |  44 +-
 arch/x86/kvm/vmx/main.c                            |   4 +-
 arch/x86/kvm/vmx/vmx.c                             |  10 +-
 arch/x86/kvm/vmx/vmx.h                             |   4 -
 arch/x86/kvm/vmx/x86_ops.h                         |   2 +-
 arch/x86/kvm/x86.c                                 | 841 +++++++++++----------
 arch/x86/kvm/x86.h                                 |  28 +-
 tools/testing/selftests/kvm/guest_print_test.c     |  19 +-
 tools/testing/selftests/kvm/include/x86_64/apic.h  |  21 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   8 +-
 .../selftests/kvm/x86_64/xapic_state_test.c        |  54 +-
 21 files changed, 681 insertions(+), 504 deletions(-)

