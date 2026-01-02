Return-Path: <kvm+bounces-66931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD02FCEEBF1
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 15:25:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9AA4C301D67E
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 14:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AA70312820;
	Fri,  2 Jan 2026 14:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="efWmseMs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEA330E857
	for <kvm@vger.kernel.org>; Fri,  2 Jan 2026 14:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767363878; cv=none; b=DYr0+c2ScERam2qiJSsBy6oLmnZwXwefRttZLXPIiwc7H00fQF7sBXLwsywKeMFChMZU+aoj9kUXM5IfRZ5/GXfWCmSPUlaT+VLk4jBcayFmYZajnxMX+JQjhxRdDZ8YaHKG9DEHj0uEvqXvz24bImyz6gTObyYZJ2SVJ2vJ4a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767363878; c=relaxed/simple;
	bh=SW0KvHxcB5Ki/WF5fTbvn7mCbva6OjKHduifm92d7qs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gPSZfWwLRqBkY/WW5QGIyeNxadyXBsMqkzYRoOGPD22TYo2Gum8//FYewdUaTD9bjubhkrRjj8Jyg01v7AYtro2UF5gBASYtGwmrM5zti4bMGf5UDRboIqFjmtBH2eN1YF0N8ycZjxbhRbZEugUfHLLzFiFAsqcJFMPYbNnoQVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=efWmseMs; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47a8195e515so73160205e9.0
        for <kvm@vger.kernel.org>; Fri, 02 Jan 2026 06:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767363874; x=1767968674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=my2o2dIzac4OWOq3Y/Xzs5/dD+yeMBpNp7+C9Ouq+1w=;
        b=efWmseMsIdBa0FjkBMPTz932H+aXyuzffRoZIknFj7y6y7Mzrw+LWajNnvFdoVkAAv
         yQuXpTzuDq1C2OvSB0D7yFwnmxfAYRkIQ26Q2t+vQ/irfuQeC5sW+5yO0dHNe9Ag/ZER
         cP4nsclq/k+q1ZfE8ghGIhk+09/iuJZ4fUzDNduA5rMv7VdqUerhvDDZ3f0a72HW8BgA
         tBlmNnFW89HUl/B3aZ1u73je5ENPEFQK4kWNx+V6wnudCaQHzNxBuMyPeRlQcuYY3Tq1
         7CnXQIhoXApiTSlOOfUcZZU7cbaYHHxYdo6eqnfH0SdbEWeuA3pNe+rHKw2e92EduyEV
         5H7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767363874; x=1767968674;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=my2o2dIzac4OWOq3Y/Xzs5/dD+yeMBpNp7+C9Ouq+1w=;
        b=S5VJJGrolID2C5DePPJFUeqTqP5iTJtYNbGvNamuIxt50EUl+bvZyJJ5HST98Tr1u1
         gQGwBu37105Sro9Rq6FBkJTcwytKjEzDQVC5sZChjIseHjBoiTFN4VbmgTMuDLWNlI+o
         m9WA92IiQnDFL3g0sVh89xq7gu9YI0i/sHsPqhepEkbqIcV1WD8zaK66/U/4vWDyy3am
         AyTUIikE1L06OTqxcCp3P6bnZKU3CYQooqxqRU+4IipjnRie+dg0JGZBb0cw/U0dGGOU
         a5SeeqGnxAAJD9qfUBDJ1ZbYaEYT69S13q9kQWQktx2mv/68QtsHsrHm6FssZSg3JZP3
         1Oeg==
X-Gm-Message-State: AOJu0YwM/LByJS6BBsY+sMiN7pHHEcqhTX1x1+VEnKBKMrA20DXwRm/+
	p46mdrLw0GIuhq6CwKs6xX4VVJogarrMFjfrdTK8AF547ETcdWeEYN8OLhP8UGk3qRw=
X-Gm-Gg: AY/fxX6KSbbttpq/3tTaa2gXeJmLRWbxC30hFPXNKlrU+ugphooUNUhjrYSCZEsTz7r
	/1sE7+NEcpUC4Ng/B1xTCs8Z4nmUJeFhcjdDC7/V3tSWQ0BRu1akpaJ+AbE3Evf1aZu0XlEbNts
	hWk2eO4DcJFsS5L0Ya/OgXpR79R/JAwgfMHuWRGV87d0CtSwVGFhW4pfHbyWhqTDpwjBLo5Ep6+
	muNqKSBnj+XG59y4vErlprUhx964SKVvY3PuB+0OaLZiGqvwpAWBUAw1o0VFPlH1CZNjFM8s+EG
	+j5ewrXVCFvpTJ7D+sYL6qS48OcpEX1oNyVviriojKlTAU9jlKQLsg15+AbZ2HMyi22MDPEt1d/
	aRdZqMBRGwGp8jUOdw87i/A1ozC/0EgOmlQBGAkh58eEdRMW0g2EpLnUJ5d+ELISSep46mqp6BE
	34tNlrZ0tvpj6I/qNgy7pBpH+OkYCGaMotmnS/3iniF9ik2dcoxe/PYy1JO4dx8fWQkHZZhO7u1
	jQuuwzuHj1XjYe2EvsKYO+MLnOwqCG4
X-Google-Smtp-Source: AGHT+IHKBXGau8MPaeirsCahDaWE9JWXdxyLyEdTLY2SGjXfRl6mxef/BeRFqCvfVfgG/TbOxXbT1Q==
X-Received: by 2002:a05:600c:4511:b0:477:af74:ed64 with SMTP id 5b1f17b1804b1-47d19593992mr491692865e9.27.1767363873762;
        Fri, 02 Jan 2026 06:24:33 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be27b0d5asm806409235e9.13.2026.01.02.06.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 06:24:33 -0800 (PST)
From: Fred Griffoul <griffoul@gmail.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	vkuznets@redhat.com,
	shuah@kernel.org,
	dwmw@amazon.co.uk,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fred Griffoul <fgriffo@amazon.co.uk>
Subject: [PATCH v4 00/10] KVM: nVMX: Improve performance for unmanaged guest memory
Date: Fri,  2 Jan 2026 14:24:19 +0000
Message-ID: <20260102142429.896101-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

This patch series addresses both performance and correctness issues in
nested VMX when handling guest memory.

During nested VMX operations, L0 (KVM) accesses specific L1 guest pages
to manage L2 execution. These pages fall into two categories: pages
accessed only by L0 (such as the L1 MSR bitmap page or the eVMCS page),
and pages passed to the L2 guest via vmcs02 (such as APIC access,
virtual APIC, and posted interrupt descriptor pages).

The current implementation uses kvm_vcpu_map/unmap, which causes two
issues.

First, the current approach is missing proper invalidation handling in
critical scenarios. Enlightened VMCS (eVMCS) pages can become stale when
memslots are modified, as there is no mechanism to invalidate the cached
mappings. Similarly, APIC access and virtual APIC pages can be migrated
by the host, but without proper notification through mmu_notifier
callbacks, the mappings become invalid and can lead to incorrect
behavior.

Second, for unmanaged guest memory (memory not directly mapped by the
kernel, such as memory passed with the mem= parameter or guest_memfd for
non-CoCo VMs), this workflow invokes expensive memremap/memunmap
operations on every L2 VM entry/exit cycle. This creates significant
overhead that impacts nested virtualization performance.

This series replaces kvm_host_map with gfn_to_pfn_cache in nested VMX.
The pfncache infrastructure maintains persistent mappings as long as the
page GPA does not change, eliminating the memremap/memunmap overhead on
every VM entry/exit cycle. Additionally, pfncache provides proper
invalidation handling via mmu_notifier callbacks and memslots generation
check, ensuring that mappings are correctly updated during both memslot
updates and page migration events.

As an example, a microbenchmark using memslot_perf_test with 8192
memslots demonstrates huge improvements in nested VMX operations with
unmanaged guest memory (this is a synthetic benchmark run on
AWS EC2 Nitro instances, and the results are not representative of
typical nested virtualization workloads):

                        Before          After           Improvement
  map:                  26.12s          1.54s           ~17x faster
  unmap:                40.00s          0.017s          ~2353x faster
  unmap chunked:        10.07s          0.005s          ~2014x faster

The series is organized as follows:

Patches 1-5 handle the L1 MSR bitmap page and system pages (APIC access,
virtual APIC, and posted interrupt descriptor). Patch 1 converts the MSR
bitmap to use gfn_to_pfn_cache. Patches 2-3 restore and complete
"guest-uses-pfn" support in pfncache. Patch 4 converts the system pages
to use gfn_to_pfn_cache. Patch 5 adds a selftest for cache invalidation
and memslot updates.

Patches 6-7 add enlightened VMCS support. Patch 6 avoids accessing eVMCS
fields after they are copied into the cached vmcs12 structure. Patch 7
converts eVMCS page mapping to use gfn_to_pfn_cache.

Patches 8-10 implement persistent nested context to handle L2 vCPU
multiplexing and migration between L1 vCPUs. Patch 8 introduces the
nested context management infrastructure. Patch 9 integrates pfncache
with persistent nested context. Patch 10 adds a selftest for this L2
vCPU context switching.

v4:
 - Rebase on kvm/next required additional vapic handling in patch 4
   and a tiny fix in patch 5.
 - Fix patch 9 to re-assign vcpu to pfncache if the nested
   context has been recycled, and to clear the vcpu context in
   free_nested().

v3:
  - fixed warnings reported by kernel test robot in patches 7 and 8.

v2:
  - Extended series to support enlightened VMCS (eVMCS).
  - Added persistent nested context for improved L2 vCPU handling.
  - Added additional selftests.

Suggested-by: dwmw@amazon.co.uk


Fred Griffoul (10):
  KVM: nVMX: Implement cache for L1 MSR bitmap
  KVM: pfncache: Restore guest-uses-pfn support
  KVM: x86: Add nested state validation for pfncache support
  KVM: nVMX: Implement cache for L1 APIC pages
  KVM: selftests: Add nested VMX APIC cache invalidation test
  KVM: nVMX: Cache evmcs fields to ensure consistency during VM-entry
  KVM: nVMX: Replace evmcs kvm_host_map with pfncache
  KVM: x86: Add nested context management
  KVM: nVMX: Use nested context for pfncache persistence
  KVM: selftests: Add L2 vcpu context switch test

 arch/x86/include/asm/kvm_host.h               |  32 ++
 arch/x86/include/uapi/asm/kvm.h               |   2 +
 arch/x86/kvm/Makefile                         |   2 +-
 arch/x86/kvm/nested.c                         | 199 +++++++
 arch/x86/kvm/vmx/hyperv.c                     |   5 +-
 arch/x86/kvm/vmx/hyperv.h                     |  33 +-
 arch/x86/kvm/vmx/nested.c                     | 499 ++++++++++++++----
 arch/x86/kvm/vmx/vmx.c                        |   8 +
 arch/x86/kvm/vmx/vmx.h                        |  16 +-
 arch/x86/kvm/x86.c                            |  19 +-
 include/linux/kvm_host.h                      |  34 +-
 include/linux/kvm_types.h                     |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../selftests/kvm/x86/vmx_apic_update_test.c  | 302 +++++++++++
 .../selftests/kvm/x86/vmx_l2_switch_test.c    | 416 +++++++++++++++
 virt/kvm/kvm_main.c                           |   3 +-
 virt/kvm/kvm_mm.h                             |   6 +-
 virt/kvm/pfncache.c                           |  43 +-
 18 files changed, 1496 insertions(+), 126 deletions(-)
 create mode 100644 arch/x86/kvm/nested.c
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apic_update_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_l2_switch_test.c


base-commit: 0499add8efd72456514c6218c062911ccc922a99
--
2.43.0


