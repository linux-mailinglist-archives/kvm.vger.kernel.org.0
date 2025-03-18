Return-Path: <kvm+bounces-41429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71F6DA67B97
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:07:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3955419C60DC
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB412147FB;
	Tue, 18 Mar 2025 18:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ohGOqbDy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05E92139CB
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742321002; cv=none; b=YRzKnJgZ+O2Mah6cNWF6eOqap+FvKBzL1DfpWtneHMA2iMuf+6jYsmMruJm+uqqBlQZ1q09R3X17xig0/xS7cwHu4Yd5o7BkiPW4UYMXgvvoB1FenSus+VroSG2cm2uhdSWdaz88kCBn9cZr42+Waamgc65qOk9e+j3mbZQLMGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742321002; c=relaxed/simple;
	bh=t2y7MLSmqBahZlOJbeUcz2phe/8UW6fcn4ArpDITisc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Db6ja5LBDtyGyvDsc1Be1F1sSKST+H2fRZEzcEwLwXxExzQuzLIRxZhV8YTx7wmuY3ikGliBqVnVKEi0BCkg0WWMVln8ZBc5vYXaD2IRG9o58Xao+ON9PN0Wq8T+t98T6k0w9i8Fk/OyJG+X9UcsGPLMkJIW7QmvnlAFgUmG1DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ohGOqbDy; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-223d86b4df0so169623295ad.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742320996; x=1742925796; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Bwe5cvflu2orXWbFuKj4RxdZ74SOqyjelcoad5bS8dY=;
        b=ohGOqbDyvtA1Ey7uZRI9orb1vNOoJpty44O7JNsXIOdSsTdTub6tFEEIWqUoNj4dY9
         H9AiTXmb//j9UgEUfhzS3/SVQfkaM3mxStAaiBsGJoFvC6FVkb8EYOWNqizb2SNlUGoB
         eZYrXCkLDjHdnwACvFu/MvzU0+WftPqkjnwSvDoV7HuSdFkObac6fGrJ9mZzSEbFq2HB
         8p5TwNpg5sB/RaiG2tVO6rYtO52Sg8UXssFLxuvaiUziDO1YtpHy4B1mHFyvsitaugf9
         k4A6QCecxDYUsLCd1ZAM6GnIrMBaUBQsYdCJmjMQkvQoFloLBIn4FlBPjAVZws63dlIP
         f//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742320996; x=1742925796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bwe5cvflu2orXWbFuKj4RxdZ74SOqyjelcoad5bS8dY=;
        b=B6tzk3cEmO7VISR3pE+nQnZE8anXrefay+PlslnqneJBYMcNLQoTW4DhhQ7iVb7lHF
         nMhN83Q64TOtGWN6HjQrQgtxMaxesnmtMW6IgJbcKIzIOU+aVVKIlLO7CGfp8GMBFuak
         5tC7x42gXEVn7U77BjgSQb1t2IJWmwmxK0L+0vlcMBHoKmPh8LZc8PLLb3YDcCu8e/7u
         PmwSUhc2bwye3SFJf0oJX3LeWuWFgjckRtdAjkVvkzjv7+GvSyIgi6e0iskxphBXRVYF
         Paoxnzzvjy2OA+ma55LrCsbAwKLbIPZxcRu8rF7i0JBvgKo4H88aCzD6ExnrJW28rCB2
         I7Aw==
X-Gm-Message-State: AOJu0YwkRAnDX3GnvenOKnO/bqcVqn4YEZVsSB5xtEF9wWtLI31ymXxw
	uZiR9PB2380oI8YhO/x1Ql8Wo48UAk3fDDVV+h/CfESOMRgR0FmvkFG/rypP0KfPEUEVWzEZxLe
	SdQ==
X-Google-Smtp-Source: AGHT+IGfQmVyr1s0/LsJeAHmPIC8elkfAUqC11fu17meo1RTyUGhLrsXe0YGoEmOxAeuJZ1obx5+Hnwd5XI=
X-Received: from pfef3.prod.google.com ([2002:a05:6a00:2283:b0:736:415f:3d45])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6010:b0:1ee:c390:58ac
 with SMTP id adf61e73a8af0-1fa45a6e710mr9030146637.34.1742320995991; Tue, 18
 Mar 2025 11:03:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Mar 2025 11:03:00 -0700
In-Reply-To: <20250318180303.283401-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318180303.283401-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318180303.283401-6-seanjc@google.com>
Subject: [GIT PULL] KVM: Selftests changes for 6.15, part 1
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

These are the selftests changes that were originally slated for 6.14, but got
omitted because of the mess with the Intel PMU counters failing due to the test
trying to validate architectural events on unsupported hardware.

The following changes since commit 10b2c8a67c4b8ec15f9d07d177f63b563418e948:

  Merge tag 'kvm-x86-fixes-6.13-rcN' of https://github.com/kvm-x86/linux into HEAD (2024-12-22 12:59:33 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests_6.15-1

for you to fetch changes up to 54108e73344480c3e5f3799129970009f52c59f4:

  KVM: selftests: Print out the actual Top-Down Slots count on failure (2025-02-12 08:34:56 -0800)

----------------------------------------------------------------
KVM selftests changes for 6.15, part 1

 - Misc cleanups and prep work.

 - Annotate _no_printf() with "printf" so that pr_debug() statements are
   checked by the compiler for default builds (and pr_info() when QUIET).

 - Attempt to whack the last LLC references/misses mole in the Intel PMU
   counters test by adding a data load and doing CLFLUSH{OPT} on the data
   instead of the code being executed.  The theory is that modern Intel CPUs
   have learned new code prefetching tricks that bypass the PMU counters.

 - Fix a flaw in the Intel PMU counters test where it asserts that an event is
   counting correctly without actually knowing what the event counts on the
   underlying hardware.

----------------------------------------------------------------
Chen Ni (1):
      KVM: selftests: Remove unneeded semicolon

Colton Lewis (2):
      KVM: selftests: Fix typos in x86's PMU counter test's macro variable use
      KVM: selftests: Add defines for AMD PMU CPUID features and properties

Isaku Yamahata (1):
      KVM: selftests: Add printf attribute to _no_printf()

Sean Christopherson (7):
      KVM: selftests: Use data load to trigger LLC references/misses in Intel PMU
      KVM: selftests: Add helpers for locally (un)blocking IRQs on x86
      KVM: selftests: Make Intel arch events globally available in PMU counters test
      KVM: selftests: Only validate counts for hardware-supported arch events
      KVM: selftests: Remove dead code in Intel PMU counters test
      KVM: selftests: Drop the "feature event" param from guest test helpers
      KVM: selftests: Print out the actual Top-Down Slots count on failure

 .../selftests/kvm/access_tracking_perf_test.c      |   2 +-
 tools/testing/selftests/kvm/include/test_util.h    |   2 +-
 .../testing/selftests/kvm/include/x86/processor.h  |  47 ++++++
 tools/testing/selftests/kvm/x86/hyperv_ipi.c       |   6 +-
 .../testing/selftests/kvm/x86/pmu_counters_test.c  | 158 ++++++++++++---------
 tools/testing/selftests/kvm/x86/svm_int_ctl_test.c |   5 +-
 .../selftests/kvm/x86/ucna_injection_test.c        |   2 +-
 tools/testing/selftests/kvm/x86/xapic_ipi_test.c   |   3 +-
 tools/testing/selftests/kvm/x86/xapic_state_test.c |   4 +-
 tools/testing/selftests/kvm/x86/xen_shinfo_test.c  |   5 +-
 10 files changed, 151 insertions(+), 83 deletions(-)

