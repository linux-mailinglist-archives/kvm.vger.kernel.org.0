Return-Path: <kvm+bounces-49515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71796AD962B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FFF2189C806
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C724F24E4C3;
	Fri, 13 Jun 2025 20:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sCpkmZ51"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com [209.85.219.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6275F18A6DF
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846200; cv=none; b=Vz4fXyiXWRbml33ODWrr5NG1f5L93E6sN9DBd74hwZ2RinRPVpHsSFTmfO22/04t6SpQdqjoLdm9hUSOiFAJ3ctHQHVWO11Zp5aTXQUyj2/oZZI0Gm9ATmV23d8a++Cz+Lx2fovxSmsHNX7u67ErbAtWucbrs+p61Anc4ECogiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846200; c=relaxed/simple;
	bh=8gmILVzYXPmjjGUIsH9eWGR9Rra1qOYhb4nQNPz0gc4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=N4Yv6C24oIj0FCYIo5hsdlI8MxlJ1mUlanCjXOwc7HyHFK9UByr8j3EjSRhYqd88Jd2/23jAJ/KO6MWCsJcxFre7KIcciEGrkhXZ06AdXGosUWtOYJG6K6NidSU9z7pUrOJCVww48HO82aPyb//QtX0HPW7EIDGsruXK6lgokh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sCpkmZ51; arc=none smtp.client-ip=209.85.219.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qv1-f73.google.com with SMTP id 6a1803df08f44-6fad5f1e70fso48875286d6.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749846197; x=1750450997; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DX/xHz+tMRHmnLBdQrk8X6gYCRIzZ4iFb/dOIXUWY1s=;
        b=sCpkmZ51YQUmA7hCWuiTLTZpm7VwgS/G1bhJlh4SyhljRF8hUiiJqq3KN4+tnTruTu
         qZC8az7MCHBSbuPfbvHOoYeDhXkbhs2bzYkaFe1p7vBPYAioWjIgwJC7mWc5cODtgPPO
         nLnSytTgumt5PGdhTz8bLSQBk4NX32z3hu+ii/JDZwbfP5DSoQqbVk6XEn0vOts3bljg
         hSWp/7lqjgZS4inp5lh2NWL7dIB3e4km5ojbIkQgBt/spQMVXG3eBhJzxwkCVyWD/vis
         znrf/SXsGouSAHGbU/vx/0gqAPWl7fJ7sa+HgvPpyg8CSrRQakzBwsK1XU7jJZefaiAw
         ig8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749846197; x=1750450997;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DX/xHz+tMRHmnLBdQrk8X6gYCRIzZ4iFb/dOIXUWY1s=;
        b=N6MrLHktD8Z6ShkNH2/4xLTqpFHMv7gosPvSgE7Y912NVv8yOtRsrwl4I8BgJOTDhv
         TVU3F5yIyasTzSgmGIY/6zgWXVPxCbLYmbweFx12W+49SzpUlQTPu9MCIW02Aw+ZNyfP
         FtRs/fRORYTrShOQpd3GqvJCKZm5wprQmeXIOjsd0Ii9gm20/lS26z4rua4jFR1AFvjV
         0sISbS+wLLWwkko1JBSFqIhZ/dMV95QyqlqDzZTTlKNGXYojSZPSUlZPO0Ta4F6tBX1a
         o3M+is2uLBIBdz0GDlh99IEyZj873H0Wkyffcme1ZA8G+grUoUiisyW4/j6CY9s+WOdE
         7osw==
X-Forwarded-Encrypted: i=1; AJvYcCUzjjQLJLQirCER1kta/jzwutd8Q0gzlJI3FV2t2/0HgEVm/Sln1ZVI79f9BeclDBcIZRg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4Or4eJn2R+rOtUCCOZO75ICZf4KanaA+wAH/cjAL17zMQy+nC
	md0qHKDQE9n5mgCwweCY+0KNKhgAOjG9C5Fpz03wfyjUO8vpu+1ODWLmm/Y+2xCyxTpARbZ8CFq
	BUQ2IyTYJqQTQtvCkDrzIlg==
X-Google-Smtp-Source: AGHT+IHyGNtB7NefXVdv8iF+PBR2LESsvOZ54jrXgI5FfNPmf14/uKsjZFUZ5pZQkvN595I2eUBiQ9ycClKVNbdl
X-Received: from qvbqm17.prod.google.com ([2002:a05:6214:5691:b0:6fa:ffa2:11b6])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6214:434a:b0:6fa:c653:5da8 with SMTP id 6a1803df08f44-6fb473f343dmr14454936d6.0.1749846197151;
 Fri, 13 Jun 2025 13:23:17 -0700 (PDT)
Date: Fri, 13 Jun 2025 20:23:07 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613202315.2790592-1-jthoughton@google.com>
Subject: [PATCH v4 0/7] KVM: x86/mmu: Run TDP MMU NX huge page recovery under
 MMU read lock
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Sean/Paolo,

I'm finishing off Vipin's NX huge page recovery optimization for the TDP
MMU from last year.

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

 arch/x86/include/asm/kvm_host.h               |  39 ++-
 arch/x86/kvm/mmu/mmu.c                        | 175 +++++++++-----
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
 13 files changed, 646 insertions(+), 100 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/execute_perf_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/nx_huge_pages_perf_test.c


base-commit: 8046d29dde17002523f94d3e6e0ebe486ce52166
-- 
2.50.0.rc2.692.g299adb8693-goog


