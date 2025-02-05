Return-Path: <kvm+bounces-37377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A85EEA298DC
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EC4E1881E1D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D9B91FE45A;
	Wed,  5 Feb 2025 18:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SlqaUgxX"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5927913D897
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779864; cv=none; b=lZtLnxLdylt/tqXLaInui4u2XWeLdIzRRJvjkIzZXFzbqZuBolHYf+zYodeCjFAeMW3+hAFKpZZ9y/zVQLN68uxSDo3ZK8cpmLs5hVFL944sjD05zZdiWg7nsu4DITpOXfvrcxKcGwfolZ2f1kxKrXFBC83SsaduG8BpSjsMKwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779864; c=relaxed/simple;
	bh=h5JP2BryQ6La04KRJax72/zZCxD3zb5ksq6AY2dGX7k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pjwPLM/47EwixqqQnrtzv2oUUM7Ihgs4a2xbAy/dmHSI412zw/YC6I2MYdMzIjWbUg5Alpw0cvN6QgXZh7SSpxj/pmfn95rnZVPrLA6NCH6hDb7LWCp64LTDdHwmoQhe52h8KkOgu3yzMpJFhGZ5QaCZ7K3GBkyvpJp7kHx3AcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SlqaUgxX; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SSaQQ6ZsNVEwjPV5fpi9CdPM1gUz5qsUb8Uq5Q1XNrY=;
	b=SlqaUgxXoAL9gJLcKrcRhl2JvoBczbpIE+nvI5SHZIZ3AAAPC+G945I9w4lgn4J8qOPzM4
	FqSE2HNZKSJgXMG2t/qN35rjqeRFsCpugDICQCDs+m+R7dmEnZMFB98Y3ieskR5hkYwmfg
	IdS+kHAz6vIBGyXmMAXCgQ5sfY+v51A=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 00/13] Optimize nSVM TLB flushes
Date: Wed,  5 Feb 2025 18:23:49 +0000
Message-ID: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Currently KVM does a TLB flush and an MMU sync on every nested
transition (L1 <-> L2), because it uses the same ASID to run both L1 and
L2.

This series addresses that by giving a separate ASID to L2, adding the
necessary TLB management for it, and properly virtualizing TLB flushes
for L1.

Patch 1 introduces a separate ASID for L2, althoug not properly handled
yet, so it keeps the unconditional flushes.

Patches 2 to 6 are some refactoring and groundwork.

Patches 7 to 12 add the actual TLB management for nSVM, some of which
are items on the TODO list in nested_svm_transition_tlb_flush().

Patch 13 finally stops the unconditional flushes on every nested
transition.

I tested this by booting an L2 and running some basic workloads,
including a CPUID microbenchmark to measure the performance improvement
(numbers in the last patch). I sent the RFC to get feedback on the
general approach, and meanwhile I will try to run more tests that could
exercise TLB flushing.

Yosry Ahmed (13):
  KVM: nSVM: Track the ASID per-VMCB
  KVM: nSVM: Rework svm_flush_tlb_asid() to operate on a given VMCB
  KVM: nSVM: Split nested_svm_transition_tlb_flush() into entry/exit fns
  KVM: SVM: Introduce helpers for updating TLB_CONTROL
  KVM: x86/mmu: rename __kvm_mmu_invalidate_addr()
  KVM: x86/mmu: Allow skipping the gva flush in
    kvm_mmu_invalidate_addr()
  KVM: nSVM: Handle INVLPGA interception correctly
  KVM: nSVM: Flush both L1 and L2 ASIDs on KVM_REQ_TLB_FLUSH
  KVM: nSVM: Handle nested TLB flush requests through TLB_CONTROL
  KVM: nSVM: Flush the TLB if L1 changes L2's ASID
  KVM: nSVM: Do not reset TLB_CONTROL in VMCB02 on nested entry
  KVM: nSVM: Service local TLB flushes before nested transitions
  KVM: nSVM: Stop bombing the TLB on nested transitions

 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/include/asm/svm.h      |  6 ---
 arch/x86/kvm/mmu/mmu.c          | 22 +++++---
 arch/x86/kvm/svm/nested.c       | 64 +++++++++++++++-------
 arch/x86/kvm/svm/sev.c          |  4 +-
 arch/x86/kvm/svm/svm.c          | 95 ++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.h          | 33 +++++++++++-
 7 files changed, 170 insertions(+), 56 deletions(-)

-- 
2.48.1.362.g079036d154-goog


