Return-Path: <kvm+bounces-66857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C023CEAAFA
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 22:14:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0314B302034A
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 21:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3BE82FBDF0;
	Tue, 30 Dec 2025 21:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4l5riIPy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF2A2E8DFD
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 21:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767129232; cv=none; b=YJUfOm9bvku52qtgGAcwpjaPzlBSMWwt3kiCtjHhHtcnkmPuyATsCje8svt+ONB4EtPp/Qs5GUvCuUF7lgyAFh7ixSD+jevwvxaeqGJHyF4hNGiIaU2TGH/XaUmjlH9y4JNfeHE5WwFngbfiOaCurTfg4RxLZtfxQ5oZnoEH2GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767129232; c=relaxed/simple;
	bh=4OWHt1L/RDgnDQRLTt+NWAyepoS1oss9mzxFrCY79ZA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Q6Kqx5vhXwIoBgsZEhXcfT9854QXeO75rniY3Zr8lEgMiGoIlQPswwB4SprrrFPnwBTkKf6pRKsJR5tcGUMLNnlqhwxgZnNd2J9ZlPzTXMrX/9jeg57hQ/utFNmNZDq6khYpFl8kLcbl5ImA1mbh3hc53XI38NTLH/pY/e6cj+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4l5riIPy; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b90740249dso17979901b3a.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 13:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767129230; x=1767734030; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bC/ABOQDwqmqKyjeXHvximAm8LHGaEor3j6gODQEP7s=;
        b=4l5riIPyNa6BUQnIZuPdOa81eG+0ok+FJvFc9cq80VHsMct3njpbT21GSLKg7g5IC2
         BpWKnzxvkuVIz2EKe8Di8dzOWX5COyOiXwTIlz2YJHWIhjP6hiS5gd25MUTMrgQl1b3c
         MpLwNZJjV3ZQZnsrXxIJAZ+RddBq/jlQmGwM2C1DzR8oZ5zjSw66bj3CzzT9/wuSHvwz
         j1T6fTbbjgLb63usMayWZfzjbuYzeNAebo4eyXDt3rhjo8gnoJphYMCe8I+Jnj0vKhFs
         KfNSruHg9CNaL8YWK1wlYgIWKww70JykvND0WT/zTRyvVm1mWsuiUs9LG+75J2LfSIfX
         sqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767129230; x=1767734030;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bC/ABOQDwqmqKyjeXHvximAm8LHGaEor3j6gODQEP7s=;
        b=enypHvUW7TK3bwKIvuVKvAKHGHrhvWAI/4aZXZ3J8ubVATps4XBj4xCxTw+ntgriO3
         2qFhd1oEIC4A30aVgMkJiRTOuYcu6iXoJKYg4FmUeq3CHjRENwv5vl9h2SWWYrhXVV99
         H9gIn1vt5YJE4Dc5YbcgGi3eADEAFEycL4aKLZ8O7zV00DTDI1eUOlLHbAO7xyghgNFM
         k+G52gvvY0qVbTQWJ4FiTEtda/7x9af+xJoKA/yDssMjzuPpLfXO/IMWdURN9GkUbmYo
         mXTHlqWK+GIpAF3/XfaGSfDFA00PCbQz9VbvqhuQQ6xYneexXc089b+6g7JNPh6cA/ol
         VZbw==
X-Gm-Message-State: AOJu0Yz+qUBuqmWDimpvqFyJfnbhCrIKkMIFHAQuZz/RCm020alMsgFs
	3oQwCoL/+awnJRN6af0z++Yyna+W/FYpoSat4VwbyzO+Dx/QZqejMyY+62x8ngeG8Evz0FFIAkU
	k4BjeiA==
X-Google-Smtp-Source: AGHT+IG0Ik/Hr8l5UuIdJnzPjNgFwG5kojDgcf3tUWg2De+x89zJIYlfXghp0RGHfAZfITkx2zj4lCz2W10=
X-Received: from pjbmy15.prod.google.com ([2002:a17:90b:4c8f:b0:34c:e366:3f3f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e293:b0:341:d5f3:f1ac
 with SMTP id adf61e73a8af0-376a9de5b1fmr32717049637.41.1767129230504; Tue, 30
 Dec 2025 13:13:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 13:13:39 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230211347.4099600-1-seanjc@google.com>
Subject: [PATCH v2 0/8] KVM: SVM: Fix exit_code bugs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Fix (mostly benign) bugs in SVM where KVM treats exit codes as 32-bit values
instead of 64-bit values.

The most dangerous aspect of the mess is that simply fixing KVM would likely
break KVM-on-KVM setups if only L1 is patched.  To try and avoid such
breakage while also fixing KVM, I opted to have KVM retain its checks on
only bits 31:0 if KVM is running as a VM (as detected by
X86_FEATURE_HYPERVISOR).

v2: 
 - Drop the nSVM #VMEXIT fixes (already merged).
 - Collect reviews. [Yosry]
 - Fix inverted svm_is_vmrun_failure() check. [Yosry]
 - Use __print_symbolic_u64() and __print_flags_u64() in tracepoints. [Test Bot]
 - Track exit_code as a u64 in KVM selftests.
 - Make HV_SVM_EXITCODE_ENL an ull like everything else. [Michael]
 - Add a compile-time assertion to verify HV_SVM_EXITCODE_ENL == SVM_EXIT_SW.

v1: https://lore.kernel.org/all/20251113225621.1688428-1-seanjc@google.com


Sean Christopherson (8):
  KVM: SVM: Add a helper to detect VMRUN failures
  KVM: SVM: Open code handling of unexpected exits in
    svm_invoke_exit_handler()
  KVM: SVM: Check for an unexpected VM-Exit after RETPOLINE "fast"
    handling
  KVM: SVM: Filter out 64-bit exit codes when invoking exit handlers on
    bare metal
  KVM: SVM: Treat exit_code as an unsigned 64-bit value through all of
    KVM
  KVM: SVM: Limit incorrect check on SVM_EXIT_ERR to running as a VM
  KVM: SVM: Harden exit_code against being used in Spectre-like attacks
  KVM: SVM: Assert that Hyper-V's HV_SVM_EXITCODE_ENL == SVM_EXIT_SW

 arch/x86/include/asm/svm.h                    |  3 +-
 arch/x86/include/uapi/asm/svm.h               | 32 ++++++------
 arch/x86/kvm/svm/hyperv.c                     |  7 ++-
 arch/x86/kvm/svm/nested.c                     | 29 ++++-------
 arch/x86/kvm/svm/sev.c                        | 36 +++++--------
 arch/x86/kvm/svm/svm.c                        | 51 +++++++++++--------
 arch/x86/kvm/svm/svm.h                        | 12 +++--
 arch/x86/kvm/trace.h                          |  6 +--
 include/hyperv/hvgdk.h                        |  2 +-
 tools/testing/selftests/kvm/include/x86/svm.h |  3 +-
 .../kvm/x86/svm_nested_soft_inject_test.c     |  4 +-
 11 files changed, 90 insertions(+), 95 deletions(-)


base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
-- 
2.52.0.351.gbe84eed79e-goog


