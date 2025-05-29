Return-Path: <kvm+bounces-48035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ABB6AC850F
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 105C39E573D
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:40:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC0232512C3;
	Thu, 29 May 2025 23:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S0Eoln1R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6A1B67F
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562019; cv=none; b=sUwVD6zYTHmB1iFh/0vM6acNeFOiAxmRJ7YqBRt3/i16DNIsIwMp4gdQ6ktN/F2quzTH0MWQNsN+Sa7qAJpOQVhFjQcHk1h/hHDKUGCTVn+1ffSWGV81Qfm8CiCRJsF2C9KfG2xJDe5s8Q8a4l/DyZ1L+0c0lcnOP5MSvpSLHHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562019; c=relaxed/simple;
	bh=PDS2qaPz76/rL/8fzCsxocQ9r12lDo+B0Vgg4H7FjFQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jHPorNAb1p3aHUlMY596RrYC2nhY/goiOSk7LPKL4hAEXNAnSFns5EdPBxZJ3mCfeUGT/hp8F7LtUYJDZOvATEa5bfNMnyR/pAu53u81J0lieTMWM4r+W6tNDPqPCtHcHjlx9qWsPWoGAqK9Lf3XIQFE2LifXAl1sHJ35a/Czjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S0Eoln1R; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2c3e576201so2154752a12.0
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562017; x=1749166817; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z8ins+AFrutQNW4d+L4Q+xsrhhfuXindJQZTPvefHTk=;
        b=S0Eoln1RNnGPhycC0QHLe1NMdh+wHAqbbqByqijQgmZTL9cdaKNNmVXT0zDlYsYAsE
         xaKyQfbBbad51xYRKcwY+rrL0uUD2b9quNWE7bMyxcMeEZa+B/tYvtfZxPnusy8u+T2u
         7FfRARrDEo76SlHG3Pn9j2joY2lIrM1w06vGq52Qszp1qcrKAUgervP4AD5HrAo8KPGP
         Z5pB0M15L6RH/yZLgtX7kt1PZfQQVAs7UiuXBCXikD7hQ7SyfZY1t+/ZjJRqtUrv2s6Y
         LmXd7Oee6RVcyB1DwdqzmDXbXVSrz/udpa/fL/yi2rhw3WFXC19JKIpi6TgsmStk8J0c
         JfWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562017; x=1749166817;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z8ins+AFrutQNW4d+L4Q+xsrhhfuXindJQZTPvefHTk=;
        b=mz+1USwej6oIVnTZ/lPpPV1YdRD/UUBT4ZeNxflUdjENK7Z5Uxb+lYcp7zLgaKRWGC
         AfAmcVYjh+sosKHeSk0TjAOdHcE8xCQx1LkTi3PZcjonNzhyW+OPKzOEOonAT+bs/xo/
         e+EAFDe3kDcJe+LfgXZK2mDIuncs9hDaFaWpJu7cSDhxE8LUi9AmGQkngK/F3gRI/rzU
         jvZiLadc8GCO4mInm/p9zGACih9lI61NupMpbvcb0pYU2wr7OG38DvEIdfmbr/+L4xjt
         ZIkm0vSuA5L71pNfp0GQiE6fx0Uk6w2mOTuOZXPWREJcmrhCAxKjMMPDfSgkA8OKWkvf
         8a+w==
X-Gm-Message-State: AOJu0YwuLGrN8m4w2tzHJHVGk6HIMHHy55XzA13/FR6GaR2uSZjg9RQ+
	C15RBwsK3NZoOnC66avaG9DvohRomYgqUKE7VYnKP045rQIIpZRlRDgKgFZvESvFzPJnpvXGWWZ
	jNg4+DA==
X-Google-Smtp-Source: AGHT+IELDvqIvkwAMZ+l7mRtTzo+VDBNlRpRZprs/F6/pvcARu7BOCi6An4uuHdaY7TFr3dgcElfJf2vr6E=
X-Received: from pjyd8.prod.google.com ([2002:a17:90a:dfc8:b0:311:ff0f:6962])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:164b:b0:310:8d4a:4a97
 with SMTP id 98e67ed59e1d1-31214ee68f2mr8068080a91.15.1748562017484; Thu, 29
 May 2025 16:40:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:39:45 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-1-seanjc@google.com>
Subject: [PATCH 00/28] KVM: x86: Clean up MSR interception code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Clean up KVM's MSR interception code (especially the SVM code, which is all
kinds of ugly).  The main goals are to:

 - Make the SVM and VMX APIs consistent (and sane; the current SVM APIs have
   inverted polarity).

 - Eliminate the shadow bitmaps that are used to determine intercepts on
   userspace MSR filter update.

Folks that are explicitly Cc'd, my plan/hope is to apply this in advance
of landing the CET virtualization and mediated PMU series, so that we don't
need to deal with extended the shadow bitmaps.  Any reviews/testing you can
provide to help make that happen would be greatly appreciated.

Note, this is a spiritual successor to the "Unify MSR intercepts in x86"
series that was posted last year[*], but I started the versioning back at
v1 as very, very little of the code actually survived, and there's obviously
no true unification in this series.  That series also had several bugs (that
were never pointed out on list), so I wanted to make a clean break.

FWIW, I still like the _idea_ of unified code, but with the shadow bitmaps
gone, it's not actually that much code, and the logic isn't all that complex.
In the end, I couldn't convince myself that unifying that small amount of
logic was worth taking on the complexity of generating and passing around bit
numbers and bitmap pointers to common code (or adding 4 more kvm_x86_ops hooks).

[*] https://lore.kernel.org/kvm/20241127201929.4005605-1-aaronlewis@google.com

Sean Christopherson (28):
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
  KVM: selftests: Verify KVM disable interception (for userspace) on
    filter change

 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |   2 +-
 arch/x86/kvm/lapic.h                          |   2 +
 arch/x86/kvm/svm/nested.c                     | 128 +++--
 arch/x86/kvm/svm/sev.c                        |  29 +-
 arch/x86/kvm/svm/svm.c                        | 449 ++++++------------
 arch/x86/kvm/svm/svm.h                        | 107 ++++-
 arch/x86/kvm/vmx/main.c                       |   6 +-
 arch/x86/kvm/vmx/vmx.c                        | 179 ++-----
 arch/x86/kvm/vmx/vmx.h                        |   9 -
 arch/x86/kvm/vmx/x86_ops.h                    |   2 +-
 arch/x86/kvm/x86.c                            |   8 +-
 .../kvm/x86/userspace_msr_exit_test.c         |   8 +
 13 files changed, 408 insertions(+), 523 deletions(-)


base-commit: 3f7b307757ecffc1c18ede9ee3cf9ce8101f3cc9
-- 
2.49.0.1204.g71687c7c1d-goog


