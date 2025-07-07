Return-Path: <kvm+bounces-51706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6A9DAFBE57
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 00:48:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84F2D4A2272
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 22:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3326B28A1F8;
	Mon,  7 Jul 2025 22:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w26HAPty"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADAC21D3CA
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 22:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751928508; cv=none; b=AzTJU3srL3bjiQGjW+Bq8NTmBjZdnps/yjRlNP0dg74jDY5wrhWVYLgD5cETZUVoZCXqj+8f8gUz3aV+5YibOStq+94ChqZz5qn2puOYACO8OdYGxGDhzIVs/LJekiWAjX5ypRPbeWs5E8BXtpO3FjhIXSCObSx9VBAlQMI4T54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751928508; c=relaxed/simple;
	bh=qTTzVQZqrUBqIzRb5vqidn4kh4nL50b+EzSDbmeigy0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tlmG+oTrvzjJeuwTUDSz5zcqw315RQ8ofzwvTLtPDyomXxMFaotqSyNVTNBF8AGRYfBFlDHnPDViXotqQFpM+cjhUmlN+XtWk9fhDfE4DSNkQNjBNVPP85DKLYG9VrxF5oj4gxZvUexhqki3aOPcV8uvq6Vqs8H2/dc0vt5bSq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w26HAPty; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23536f7c2d7so59959885ad.2
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 15:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751928506; x=1752533306; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2iVC6lDsTdmoSNx7WZ+C+NX+iZ0b1chQ7kg4FWN8O+c=;
        b=w26HAPtym+gX7BQITP90GS2kInKl4Z2LdXevcmfqhZP0rZZSodrACctyerU0m7TL7z
         6JBCLHqMpvUCYT6RfD7sFQLTO8YDNSWhnRb4//npw1Rp0ZclBGPi5NML85zyDWYynE6G
         S4E57yI8+ICApp/sUIuTyzibQRt3FpkpLPDVtdsW+l8GgYvWyJqfuQr2vN72LCYjHpER
         SEsG1QqGG71aY7KtyNnnhlOcKxNvJPo5VBIXr5HaIjva4tEwRRc2VzvVIlWaYUVWQUHc
         ciUDEitIKN3WbdsKOHFJqZB0hr02HIanEXveEWigLcwNkXlrvebh4DMiN1KlRL+Wf1U3
         IaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751928506; x=1752533306;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2iVC6lDsTdmoSNx7WZ+C+NX+iZ0b1chQ7kg4FWN8O+c=;
        b=GFMn5Rqri2HqMA3OPXg3KMmZz9q1jUjtTQbrf1a6VWgZPRutR431jnvAQKIKdOkFQh
         ot7AehIA5Xgbh4bKHF5ZmkhLaR6Pk7wCvIeWTIEVDyWmv0JS53uHqD7eBnXhPG2LPl6h
         vcq/ohnCiBliTtBh65UdEakSN7vZecjqyGsC46Ps63v4B0MooYLwQl6qUXJ6MfxySJH2
         uA1kSiisr8B/Kuo+SaULLTQasasD5Ibkk6eoQMg4re1s3FSnpXTHHwbz8FYh5wmGS3DG
         2E/tFxSMl8bjZuvA9jJIUDkqSfgb309u4TZXoBppWEoD9q7bnbUT7ppg4eyGdiJgdb0z
         bsdw==
X-Forwarded-Encrypted: i=1; AJvYcCVJZ06zMFKSuA/b7vMDdph6j85Y+3Q1N5jAxfvstqwpxuzxR0M5n/8PbSjnFzC6nqFjUmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwD7IvAFcRz8lE1EKavQ6Tn9TL8mpUlpdZDhCFML54hSkKUiI0
	obfRjW5yuNi8o3Ax0Y/jJJxXLfYqS5xBxCQ3wNzC1fdJswDHfF/Y3154lZM3Kr4c6tl2qSzvHst
	qXjCP6tOKaXr+DBkK7S4vWw==
X-Google-Smtp-Source: AGHT+IH5usXrcgv6G7UO8iG/pmDVqqZn9ALh6f8wfddQy1sUslJZlOFFJqd5ucBJzZtUqEs15wA0TBPkvJ9yjJES
X-Received: from plbjf14.prod.google.com ([2002:a17:903:268e:b0:235:ee71:80d5])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d58d:b0:234:d292:be83 with SMTP id d9443c01a7336-23c8746ffe3mr244048355ad.10.1751928506186;
 Mon, 07 Jul 2025 15:48:26 -0700 (PDT)
Date: Mon,  7 Jul 2025 22:47:13 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250707224720.4016504-1-jthoughton@google.com>
Subject: [PATCH v5 0/7] KVM: x86/mmu: Run TDP MMU NX huge page recovery under
 MMU read lock
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Sean/Paolo,

I'm finishing off Vipin's NX huge page recovery optimization for the TDP
MMU from last year. This is a respin on the series I sent a couple weeks
ago, v4. Below is a mostly unchanged cover letter from v4.

NX huge page recovery can cause guest performance jitter, originally
noticed with network tests in Windows guests. Please see Vipin's earlier
performance results[1]. Below is some new data I have collected with the
nx_huge_pages_perf_test that I've included with this series.

The NX huge page recovery for the shadow MMU is still done under the MMU
write lock, but with the TDP MMU, we can instead do it under the MMU
read lock by:

1. Tracking the possible NX huge pages for the two MMUs separately
   (patch 1).
2. Updating the NX huge page recovery routine for the TDP MMU to
    - zap SPTEs atomically, and
    - grab tdp_mmu_pages_lock to iterate over the NX huge page list
   (patch 3).

I threw in patch 4 because it seems harmless and closer to the "right"
thing to do. Feel free to drop it if you don't agree with me. :)

I'm also grabbing David's execute_perf_test[3] while I'm at it. It was
dropped before simply because it didn't apply at the time. David's test
works well as a stress test for NX huge page recovery when NX huge page
recovery is tuned to be very aggressive.

Changes since v4[4]:
- 32-bit build fixups for patch 1 and 3.
- Small variable rename in patch 3.

Changes since v3[2]:
- Dropped the move of the `sp->nx_huge_page_disallowed` check to outside
  of the tdp_mmu_pages_lock.
- Implemented Sean's array suggestion for `possible_nx_huge_pages`.
- Implemented some other cleanup suggestions from Sean.
- Made shadow MMU not take the RCU lock in NX huge page recovery.
- Added a selftest for measuring jitter.
- Added David's execute_perf_test[3].

-- Results
$ cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
100
$ cat /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
4

$ ./nx_huge_pages_perf_test -b 16G -s anonymous_hugetlb_1gb
[Unpatched] Max fault latency: 8496724 cycles
[Unpatched] Max fault latency: 8404426 cycles
[ Patched ] Max fault latency: 49418 cycles
[ Patched ] Max fault latency: 51948 cycles

$ ./nx_huge_pages_perf_test -b 16G -s anonymous_hugetlb_2mb
[Unpatched] Max fault latency: 5320740 cycles
[Unpatched] Max fault latency: 5384554 cycles
[ Patched ] Max fault latency: 50052 cycles
[ Patched ] Max fault latency: 103774 cycles

$ ./nx_huge_pages_perf_test -b 16G -s anonymous_thp
[Unpatched] Max fault latency: 7625022 cycles
[Unpatched] Max fault latency: 6339934 cycles
[ Patched ] Max fault latency: 107976 cycles
[ Patched ] Max fault latency: 108386 cycles

$ ./nx_huge_pages_perf_test -b 16G -s anonymous
[Unpatched] Max fault latency: 143036 cycles
[Unpatched] Max fault latency: 287444 cycles
[ Patched ] Max fault latency: 274626 cycles
[ Patched ] Max fault latency: 303984 cycles

We can see about a 100x decrease in maximum fault latency for both
2M pages and 1G pages. This test is only timing writes to unmapped
pages that are not themselves currently undergoing NX huge page
recovery. The test only produces interesting results when NX huge page
recovery is actually occurring, so the parameters are tuned to make it
very likely for NX huge page recovery to occur in the middle of the
test.

Based on latest kvm/next.

[1]: https://lore.kernel.org/kvm/20240906204515.3276696-3-vipinsh@google.com/
[2]: https://lore.kernel.org/kvm/20240906204515.3276696-1-vipinsh@google.com/
[3]: https://lore.kernel.org/kvm/20221109185905.486172-2-dmatlack@google.com/
[4]: https://lore.kernel.org/kvm/20250616181144.2874709-1-jthoughton@google.com/

David Matlack (1):
  KVM: selftests: Introduce a selftest to measure execution performance

James Houghton (3):
  KVM: x86/mmu: Only grab RCU lock for nx hugepage recovery for TDP MMU
  KVM: selftests: Provide extra mmap flags in vm_mem_add()
  KVM: selftests: Add an NX huge pages jitter test

Vipin Sharma (3):
  KVM: x86/mmu: Track TDP MMU NX huge pages separately
  KVM: x86/mmu: Rename kvm_tdp_mmu_zap_sp() to better indicate its
    purpose
  KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU read lock

 arch/x86/include/asm/kvm_host.h               |  43 +++-
 arch/x86/kvm/mmu/mmu.c                        | 180 +++++++++-----
 arch/x86/kvm/mmu/mmu_internal.h               |   7 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |  49 +++-
 arch/x86/kvm/mmu/tdp_mmu.h                    |   3 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../testing/selftests/kvm/execute_perf_test.c | 199 ++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   3 +-
 .../testing/selftests/kvm/include/memstress.h |   4 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  15 +-
 tools/testing/selftests/kvm/lib/memstress.c   |  25 +-
 .../kvm/x86/nx_huge_pages_perf_test.c         | 223 ++++++++++++++++++
 .../kvm/x86/private_mem_conversions_test.c    |   2 +-
 13 files changed, 656 insertions(+), 99 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/execute_perf_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/nx_huge_pages_perf_test.c


base-commit: 8046d29dde17002523f94d3e6e0ebe486ce52166
-- 
2.50.0.727.gbf7dc18ff4-goog


