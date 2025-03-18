Return-Path: <kvm+bounces-41428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 954F1A67B9B
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF7378871F2
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:04:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF06B2144A4;
	Tue, 18 Mar 2025 18:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S9H547/U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00420214225
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742321001; cv=none; b=UwKmlOUr/XC5JUutXFlgAFICzQETk0v1NFoVI6QZK9q1zOlu6X1e988lzVvZDM5oKcCKgfyLOhZV874lZbtA6NUsjfYbcHhsZCN+Rjei6JVgb7gnRv5q3IwlfHY1HnAEo387wg/poeIbxaC2Nzu9PXWVy1Tvf4wIwO7QYYSuqsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742321001; c=relaxed/simple;
	bh=eGp6y76D+26th1Qth29tiD1vANtf4Fo6XvDNs+D6Ea8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I3111Lwao1jLei8DtWy8d87WbLTKXqGcMk6DXAcZHr/irmV0jSP0aUaLS5QhwI/2OQn6N7NTlYMLCfFWe3fJqVsFjClLoLAUNfScsw7r1fkvNEM0BXnn45uWwcY3a9XCQHqwU3LyS5vdkMtnIo120TqFqd7wYUkMGPreLijDZm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S9H547/U; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2242f408320so86134115ad.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742320998; x=1742925798; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Hw3dIlV0W/clOphvZwS+ro8iXLrLQs2i5d/hFycck28=;
        b=S9H547/Uqh2Wsbyoxeo4U4T4b1m57dsLaJLtURUwdEAkzorUAQmg3Dll699iTR7a3f
         a9/FCqt/08CU53EKQwjv4ZoITZBiKYl97ykDaflVUlqUryhQtrFG5GwQ5mYEL9Aw1R/p
         Fzrd8M9UKNArwOkdf+/NTuQgFc1Xzlz8+VYzdQdC2a64qTQxhVv8nxJen0fOPq0Rja+1
         MOPVOkomeFvXYhnkBCfF+pJ3mEJW0l1FPG3J07dNdA2JaIwrICtdaQteQKDQ9SkVw7ua
         HIVp543ESLKt7YO5MiXk+Xl77Z7MvZhB7ed6MKAqzjwjknxSkKlBg0KERr4MLsKSIR31
         wAqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742320998; x=1742925798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hw3dIlV0W/clOphvZwS+ro8iXLrLQs2i5d/hFycck28=;
        b=do4Fb/T1qxTvwfMEpYlcro92aieTXJEJ8M0qc1DCkWR0siOYbsinLNU7F4V3gq/Vde
         k8VP8tUj3I4/vHSBw5VjUqTewfdDc2Rmh5iqPX9q3un8lA/86kNmkIGSdMPS4WWVEQ+y
         GdPcA/fYDuijKUpDY4Q46HETowCL5ktG5gdpo1aTz1MHZAfQxYYQTVLG3PupDEL9B81+
         ZmyqsSlKC65wAHbdZgYJKfWZn2EEOoHqyQL4I11gIup+Ru4t0/pDhG3c0K0NQQ/crGaY
         tNdEnY/XP0MplANNhLX+52Rur7aextvP0WeYiO5I6jdv22AqZWHse79lSfcsa2nWOPIH
         EiSA==
X-Gm-Message-State: AOJu0Yy5+EGPd0XrXBiQtPtttim2M/V+5qj1sq2FzOAlXd+iOSyuqazK
	cZEZazddNhZS3RNgptlflL5I60aj3ZbjibQtMTOIJXWC5YX3P+8Dax1auhJ0kMI71b52ElIkaS7
	cww==
X-Google-Smtp-Source: AGHT+IHNYr/g0m3ji9yBS+9hbhGo5xdw2oXURoWDCDny0qKJulqwWnmVFV/kBVPvfKiCxgba+qWFJ0nfXL4=
X-Received: from pfbhx5.prod.google.com ([2002:a05:6a00:8985:b0:736:79d0:fd28])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1fc4:b0:1f5:9330:2a18
 with SMTP id adf61e73a8af0-1f5c121a03dmr24805723637.23.1742320998029; Tue, 18
 Mar 2025 11:03:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Mar 2025 11:03:01 -0700
In-Reply-To: <20250318180303.283401-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318180303.283401-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318180303.283401-7-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: SVM changes for 6.15
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Misc cleanups, a pile of fixes related to SNP's AP Creation hypercall, and
support for Idle HLT interception.

Note, Manali wrote a selftest for Idle HLT, but unfortunately it can't be
merged at this time as the test has no way to know if _KVM_ support Idle HLT;
the CPUID feature bit enumerates KVM emulation of Idle HLT for nested VMs,
and there was no strong reason to expose a module param, let alone a capability.

The following changes since commit a64dcfb451e254085a7daee5fe51bf22959d52d3:

  Linux 6.14-rc2 (2025-02-09 12:45:03 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.15

for you to fetch changes up to 4e96f010afb2815e33c9b15a695e0e0b4cb3cea6:

  KVM: SVM: Invalidate "next" SNP VMSA GPA even on failure (2025-03-03 07:34:56 -0800)

----------------------------------------------------------------
KVM SVM changes for 6.15

 - Ensure the PSP driver is initialized when both the PSP and KVM modules are
   built-in (the initcall framework doesn't handle dependencies).

 - Use long-term pins when registering encrypted memory regions, so that the
   pages are migrated out of MIGRATE_CMA/ZONE_MOVABLE and don't lead to
   excessive fragmentation.

 - Add macros and helpers for setting GHCB return/error codes.

 - Add support for Idle HLT interception, which elides interception if the vCPU
   has a pending, unmasked virtual IRQ when HLT is executed.

 - Fix a bug in INVPCID emulation where KVM fails to check for a non-canonical
   address.

 - Don't attempt VMRUN for SEV-ES+ guests if the vCPU's VMSA is invalid, e.g.
   because the vCPU was "destroyed" via SNP's AP Creation hypercall.

 - Reject SNP AP Creation if the requested SEV features for the vCPU don't
   match the VM's configured set of features.

 - Misc cleanups

----------------------------------------------------------------
Ge Yang (1):
      KVM: SEV: Use long-term pin when registering encrypted memory regions

Manali Shukla (2):
      x86/cpufeatures: Add CPUID feature bit for Idle HLT intercept
      KVM: SVM: Add Idle HLT intercept support

Melody Wang (2):
      KVM: SVM: Convert plain error code numbers to defines
      KVM: SVM: Provide helpers to set the error code

Nikunj A Dadhania (1):
      KVM: SEV: Use to_kvm_sev_info() for fetching kvm_sev_info struct

Sean Christopherson (11):
      crypto: ccp: Add external API interface for PSP module initialization
      KVM: SVM: Ensure PSP module is initialized if KVM module is built-in
      KVM: SVM: Inject #GP if memory operand for INVPCID is non-canonical
      KVM: SVM: Refuse to attempt VRMUN if an SEV-ES+ guest has an invalid VMSA
      KVM: SVM: Don't change target vCPU state on AP Creation VMGEXIT error
      KVM: SVM: Require AP's "requested" SEV_FEATURES to match KVM's view
      KVM: SVM: Simplify request+kick logic in SNP AP Creation handling
      KVM: SVM: Use guard(mutex) to simplify SNP AP Creation error handling
      KVM: SVM: Mark VMCB dirty before processing incoming snp_vmsa_gpa
      KVM: SVM: Use guard(mutex) to simplify SNP vCPU state updates
      KVM: SVM: Invalidate "next" SNP VMSA GPA even on failure

 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/sev-common.h  |  12 +-
 arch/x86/include/asm/svm.h         |   5 +-
 arch/x86/include/uapi/asm/svm.h    |   2 +
 arch/x86/kvm/svm/sev.c             | 380 +++++++++++++++++--------------------
 arch/x86/kvm/svm/svm.c             |  39 +++-
 arch/x86/kvm/svm/svm.h             |  39 +++-
 drivers/crypto/ccp/sp-dev.c        |  14 ++
 include/linux/psp-sev.h            |   9 +
 9 files changed, 269 insertions(+), 232 deletions(-)

