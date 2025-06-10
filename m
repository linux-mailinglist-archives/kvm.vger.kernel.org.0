Return-Path: <kvm+bounces-48884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7027AD4629
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BC03166B6C
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 22:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B91D28BAB3;
	Tue, 10 Jun 2025 22:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="reOVlS3M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370EF21C19C
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596263; cv=none; b=o1XArbTY9T9yMKpjOZrV+PHAijL39nPXYINTqv6PRq7lkswGwXscWIzS/Ik76rk/Qbwdps5iNqvwnZYRUGz8NevnfCwC6D3K5ZGxEmwKrURtm8XqRRpfWFfuRfblKAHHJGZst/mDOENO+6k4m96v5EmPQaQAWXZh+4RpR6kYXPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596263; c=relaxed/simple;
	bh=PU4CQ8UGMUEtv3G8ZEF/N2DVxNwtMrUkuUQB2V2j5zY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rRiqt2pjlqgZXiYR5IKnXXlmyyzguu6LJmtMU2jw9WJ6g4icb3sM5802QWaGjU7CxrUgOsnXI1UxmfTPiszZfRco+iO8KWKpIo0qfMeu/VEIuAlA4qLjyCTQ3t4R9Qol2HgIDmcWbYjyxssrYFPVdCvFvhurMe1OX0kLA+kwdz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=reOVlS3M; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747d394f45fso4332167b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596261; x=1750201061; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R6yaQM2l+AM1elKMoXhIjARR8lysmC+imGaGP22oyE4=;
        b=reOVlS3MusRL0BYlk0adZnMePQrwXczAO0CjRgvXqaPj0+uThbDSI01fnhCyh2+xZl
         Oc/PpKBRgaR/Y4IO1O7zxM6P+uiQuykNcXP4CZhoOdS8qX5H+rrYEsKJFmPLKv6g9D33
         8FZSPG/W0stzvZEbqgfEy0peahjbp9WQEOG7htyuPplYLxjz1wUCOerMIg233XPiJXZO
         HP2SpgQZN/b4Ta6YEKVSn1H38Sjw29r547lK1opIJ5n7BOkWfBm62udv2I4HQT5ADozr
         7LJFM1/nFeLruwrw0m367kewJ6ip0KV9AeBe96W59ysJEwjTypSs8ImH/246Hjr3i0DD
         cTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596261; x=1750201061;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R6yaQM2l+AM1elKMoXhIjARR8lysmC+imGaGP22oyE4=;
        b=MWU9hT47ljCU21EjpDV5WC/EyRJtThKt43WVDfgNYYVPOnW3fLpabUvrRZB8H70JUq
         Yu+vPofEY6du1Ph1pxPhR3/SqBDNgZdRczviajdqGfnAdhbzHzR8XD0hKHM4nzVrN7f6
         sjv1JnsKlJ1cOUthQ5oHqa5W1MeKmKG38nfhSvzSpLLJoIHzauiboihh1vxPMyMJR9tL
         QmvZABv0TfLl9IrT0qtIp9rr0baZOXqofIXmtt5SKRIurpg+EUxE4i2IPKxeG+tXt6m/
         SQcJSJjPg9cogex91B31anxsASTbHVUBEf/OsJnQYx3VzOJ2pSAJ9mCGWa6gxKOOGffG
         7LPg==
X-Gm-Message-State: AOJu0Yx/M60Lve8Q3yOK8OikrFZwKgO6TVX6H8UNxXGMB4xJdO4fzMR+
	c7HS+pW1BHaanODAH3vnJls4aJiNK+RE5XGL+MOmJr2HmcOKuTKE3l8OlIU3EYmNA3hObFlzP+W
	QBLQ/nQ==
X-Google-Smtp-Source: AGHT+IGd4UPEgvAEBxaQI6Sk3pDVyN+rdP3l7ICg6WOlvax69b/h/SHGLB5WfmCZLEE2basnUXJ9Crf7+VE=
X-Received: from pgbdq15.prod.google.com ([2002:a05:6a02:f8f:b0:b2e:bad0:b462])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:728f:b0:215:db66:2a33
 with SMTP id adf61e73a8af0-21f89013cd9mr697945637.16.1749596261517; Tue, 10
 Jun 2025 15:57:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:05 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-1-seanjc@google.com>
Subject: [PATCH v2 00/32] KVM: x86: Clean up MSR interception code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Clean up KVM's MSR interception code (especially the SVM code, which is all
kinds of ugly).  The main goals are to:

 - Make the SVM and VMX APIs consistent (and sane; the current SVM APIs have
   inverted polarity).

 - Eliminate the shadow bitmaps that are used to determine intercepts on
   userspace MSR filter update.

v2:
 - Add a patch to set MSR_IA32_SPEC_CTRL interception as appropriate. [Chao]
 - Add a patch to cleanup {svm,vmx}_disable_intercept_for_msr() once the
   dust has settled. [Dapeng]
 - Return -ENOSPC if msrpm_offsets[] is full. [Chao]
 - Free iopm_pages directly instead of bouncing through iopm_base. [Chao]
 - Check for "offset == MSR_INVALID" before using offset. [Chao]
 - Temporarily keep MSR_IA32_DEBUGCTLMSR in the nested list. [Chao]
 - Add a comment to explain nested_svm_msrpm_merge_offsets. [Chao]
 - Add a patch to shift the IOPM allocation to avoid having to unwind it.
 - Init nested_svm_msrpm_merge_offsets iff nested=1. [Chao]
 - Add a helper to dedup alloc+init of MSRPM and IOPM.
 - Tag merge_msrs as "static" and "__initconst". [Paolo]
 - Rework helpers to use fewer macros. [Paolo]
 - Account for each MSRPM byte covering 4 MSRs. [Paolo]
 - Opportunistically use cpu_feature_enabled(). [Xin]
 - Fully remove MAX_DIRECT_ACCESS_MSRS, MSRPM_OFFSETS, and msrpm_offsets.
   [Francesco]
 - Fix typos. [Dapeng, Chao]
 - Collect reviews. [Chao, Dapeng, Xin]

v1: https://lore.kernel.org/all/20250529234013.3826933-1-seanjc@google.com

v0: https://lore.kernel.org/kvm/20241127201929.4005605-1-aaronlewis@google.com

Sean Christopherson (32):
  KVM: SVM: Disable interception of SPEC_CTRL iff the MSR exists for the
    guest
  KVM: SVM: Allocate IOPM pages after initial setup in
    svm_hardware_setup()
  KVM: SVM: Don't BUG if setting up the MSR intercept bitmaps fails
  KVM: SVM: Tag MSR bitmap initialization helpers with __init
  KVM: SVM: Use ARRAY_SIZE() to iterate over direct_access_msrs
  KVM: SVM: Kill the VM instead of the host if MSR interception is buggy
  KVM: x86: Use non-atomic bit ops to manipulate "shadow" MSR intercepts
  KVM: SVM: Massage name and param of helper that merges vmcb01 and
    vmcb12 MSRPMs
  KVM: SVM: Clean up macros related to architectural MSRPM definitions
  KVM: nSVM: Use dedicated array of MSRPM offsets to merge L0 and L1
    bitmaps
  KVM: nSVM: Omit SEV-ES specific passthrough MSRs from L0+L1 bitmap
    merge
  KVM: nSVM: Don't initialize vmcb02 MSRPM with vmcb01's "always
    passthrough"
  KVM: SVM: Add helpers for accessing MSR bitmap that don't rely on
    offsets
  KVM: SVM: Implement and adopt VMX style MSR intercepts APIs
  KVM: SVM: Pass through GHCB MSR if and only if VM is an SEV-ES guest
  KVM: SVM: Drop "always" flag from list of possible passthrough MSRs
  KVM: x86: Move definition of X2APIC_MSR() to lapic.h
  KVM: VMX: Manually recalc all MSR intercepts on userspace MSR filter
    change
  KVM: SVM: Manually recalc all MSR intercepts on userspace MSR filter
    change
  KVM: x86: Rename msr_filter_changed() => recalc_msr_intercepts()
  KVM: SVM: Rename init_vmcb_after_set_cpuid() to make it intercepts
    specific
  KVM: SVM: Fold svm_vcpu_init_msrpm() into its sole caller
  KVM: SVM: Merge "after set CPUID" intercept recalc helpers
  KVM: SVM: Drop explicit check on MSRPM offset when emulating SEV-ES
    accesses
  KVM: SVM: Move svm_msrpm_offset() to nested.c
  KVM: SVM: Store MSRPM pointer as "void *" instead of "u32 *"
  KVM: nSVM: Access MSRPM in 4-byte chunks only for merging L0 and L1
    bitmaps
  KVM: SVM: Return -EINVAL instead of MSR_INVALID to signal out-of-range
    MSR
  KVM: nSVM: Merge MSRPM in 64-bit chunks on 64-bit kernels
  KVM: SVM: Add a helper to allocate and initialize permissions bitmaps
  KVM: x86: Simplify userspace filter logic when disabling MSR
    interception
  KVM: selftests: Verify KVM disable interception (for userspace) on
    filter change

 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |   2 +-
 arch/x86/kvm/lapic.h                          |   2 +
 arch/x86/kvm/svm/nested.c                     | 126 +++--
 arch/x86/kvm/svm/sev.c                        |  29 +-
 arch/x86/kvm/svm/svm.c                        | 490 ++++++------------
 arch/x86/kvm/svm/svm.h                        | 102 +++-
 arch/x86/kvm/vmx/main.c                       |   6 +-
 arch/x86/kvm/vmx/vmx.c                        | 202 ++------
 arch/x86/kvm/vmx/vmx.h                        |   9 -
 arch/x86/kvm/vmx/x86_ops.h                    |   2 +-
 arch/x86/kvm/x86.c                            |   8 +-
 .../kvm/x86/userspace_msr_exit_test.c         |   8 +
 13 files changed, 426 insertions(+), 562 deletions(-)


base-commit: 61374cc145f4a56377eaf87c7409a97ec7a34041
-- 
2.50.0.rc0.642.g800a2b2222-goog


