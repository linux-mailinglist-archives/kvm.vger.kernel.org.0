Return-Path: <kvm+bounces-64800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CEDEC8C8EB
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:35:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 21A334E6399
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEDCE21CA0D;
	Thu, 27 Nov 2025 01:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X/5Ad+ee"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148851D61A3;
	Thu, 27 Nov 2025 01:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207303; cv=none; b=tz9CpBLZ37Lsd3rVDa9bT4d07xc9kjpD0hFktb1YmXEcEA5a/Ve+LxBldzUzUi2NVs0lVeX/UgfFdl7hn6TOb3ooAV2yx6drbLNmEz8b90Bh71hcChS/DEKjodCaUGAc0s8pYpN8T/EGU4Yu0aPS1nvez++lm8Fiz6cWbEtRyN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207303; c=relaxed/simple;
	bh=sXzd1UGd1y2lkMRPc58ecp9YYArysoVxGcFcxJnwN/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K5Z4heki9oxrPp1z1m3/+BKhkF81nBVi8jmP2/uSg2k6/JOo/riJrwzwWplA4njm32uMYezLO52gfQ9KmV/uZkrz5s24C4zFwEGrIVU0AolnLVtK3sAfa6q+w1yvvJ+pTmc4J9hiCLwxN5W+sZBWij+hLUog63lw/UNfy5W3ooc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X/5Ad+ee; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vmmt09iPxqZyV52+QC1J4rrIkhh2TivBKtc0adxQinA=;
	b=X/5Ad+eeRrs3bWfUaIM/CdyYxuWv3tCIwH8UhlrOkaDrFLk0cXlCAO3xgfIiJ8Y//pUZty
	pdm4ciJ8n8dxPOfpBtVgGrinrlzi1zlbYG+Q46O8FxgBIxBLSqftl5L/wkv6IRElGd9L6b
	H5helDLhJiscWZp04G3x416sZmOfmZI=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 00/16] Add Nested NPT support in selftests
Date: Thu, 27 Nov 2025 01:34:24 +0000
Message-ID: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This series adds support for nested NPT, then extends vmx_dirty_log_test
and kvm_dirty_log_test (with -n, using memstress) to cover nested SVM.

Patches 1-5 are cleanups and prep.

Patches 6-7 introduce a new data structure, kvm_mmu, that is used by virt
mapping functions for guest page tables.

Patches 8-11 add a nested kvm_mmu for nested EPTs, which are now shared
between all vCPUs, and reuses the virt mapping functions for EPTs.

Patches 12-14 add the support for nested NPTs, which becomes simple
after all the above prep work.

Patches 15-16 extend the existing selftests exercising nested EPTs to
also cover nested NPTs.

v2 -> v3:
- Dropped the patches that landed in kvm-x86.
- Reshuffled some patches and cleanups.
- Introduced kvm_mmu data structures to hold the root, page table
  levels, and page table masks (Sean).
- Extended memstress as well to cover nested SVM.

v2: https://lore.kernel.org/kvm/20251021074736.1324328-1-yosry.ahmed@linux.dev/

Yosry Ahmed (16):
  KVM: selftests: Make __vm_get_page_table_entry() static
  KVM: selftests: Stop passing a memslot to nested_map_memslot()
  KVM: selftests: Rename nested TDP mapping functions
  KVM: selftests: Kill eptPageTablePointer
  KVM: selftests: Stop setting AD bits on nested EPTs on creation
  KVM: selftests: Introduce struct kvm_mmu
  KVM: selftests: Move PTE bitmasks to kvm_mmu
  KVM: selftests: Use a nested MMU to share nested EPTs between vCPUs
  KVM: selftests: Stop passing VMX metadata to TDP mapping functions
  KVM: selftests: Reuse virt mapping functions for nested EPTs
  KVM: selftests: Move TDP mapping functions outside of vmx.c
  KVM: selftests: Allow kvm_cpu_has_ept() to be called on AMD CPUs
  KVM: selftests: Add support for nested NPTs
  KVM: selftests: Set the user bit on nested NPT PTEs
  KVM: selftests: Extend vmx_dirty_log_test to cover SVM
  KVM: selftests: Extend memstress to run on nested SVM

 tools/testing/selftests/kvm/Makefile.kvm      |   2 +-
 .../selftests/kvm/include/x86/kvm_util_arch.h |   7 +
 .../selftests/kvm/include/x86/processor.h     |  68 ++++-
 .../selftests/kvm/include/x86/svm_util.h      |   9 +
 tools/testing/selftests/kvm/include/x86/vmx.h |  16 +-
 .../testing/selftests/kvm/lib/x86/memstress.c |  68 +++--
 .../testing/selftests/kvm/lib/x86/processor.c | 217 ++++++++++++---
 tools/testing/selftests/kvm/lib/x86/svm.c     |  25 ++
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 256 ++++--------------
 ...rty_log_test.c => nested_dirty_log_test.c} |  87 ++++--
 10 files changed, 428 insertions(+), 327 deletions(-)
 rename tools/testing/selftests/kvm/x86/{vmx_dirty_log_test.c => nested_dirty_log_test.c} (67%)


base-commit: 115d5de2eef32ac5cd488404b44b38789362dbe6
-- 
2.52.0.158.g65b55ccf14-goog


