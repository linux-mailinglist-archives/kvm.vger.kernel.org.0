Return-Path: <kvm+bounces-68111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B074D21F35
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:13:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A362E303806B
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A35D23DEB6;
	Thu, 15 Jan 2026 01:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NjDHYfqL"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1793D25776
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439611; cv=none; b=bm3cNgkhKVi/R7nnGhaaZkdKeZHMryGzeAdu4bFZQ1sFB7DrRm+KCf7KUHyK1IddmteF8a6vC2tMsFvi5KPLq1dOO3d0zTA/uaQjIuMq8QsZxbIRAIfrUaYUt/+ix750DN4Rqk6uAltit3td7dPpGLxkhjtbZl3/UWh+M3iwA9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439611; c=relaxed/simple;
	bh=fQqA2Bi7beoaqKROaXncLZ1Lzr3jWy523lQs0sPZ5GY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rlfwBdGykxTCG6oh/4jy2O0NkV9mLGQN9mheQKH0jPI5VzXyAQLoQg5GH+lmuu86KYF9eR1g2qhMw9imiBju3agEQG9Rn7ha5ygswePeEKt8+jme1Sm4bvfCaJGydfllG4KCQVFUF7L+JFJQXUGfBA3FBIonbhUt2zR5x4nANhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NjDHYfqL; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kOQ4VzmQ9V/wQV3/Huk+MrK5n+USrgmzREJM0lZRg+c=;
	b=NjDHYfqLR0B6SrO2YhWbQEqDAntPjXXRa6J6FizyD2wALz007bhpA0/95d0dI1YLjDE4hT
	ruTAN7d+YK/Z/wP+hDtc2XrVSaodadCQaqA7U/rk6xOqMasd7/xP8Q7gU/skTfH0K1C+oe
	/UBuEKfLiWwgYWymrVuZbQwZknvqrB0=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v4 00/26] Nested SVM fixes, cleanups, and hardening
Date: Thu, 15 Jan 2026 01:12:46 +0000
Message-ID: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A group of semi-related fixes, cleanups, and hardening patches for nSVM.
This series doubled in size between v2 and v3, but it's Sean's fault for
finding more bugs that needed fixing.

The series is essentially a group of related mini-series stitched
together for syntactic and semantic dependencies. The first 19 patches
(except patch 3) are all optimistically CC'd to stable as they are fixes
or refactoring leading up to bug fixes. Although I am not sure how much
of that will actually apply to stable trees.

Patches 1-3 here are v2 of the last 3 patches in the LBRV fixes series
[1]. The first 3 patches of [1] are already upstream.

Patches 4-14 are fixes for failure handling in the nested VMRUN and
#VMEXIT code paths, ending with a nice unified code path for handling
VMRUN failures as suggested by Sean. Within this block, patches 7-12 are
refactoring needed for patches 13-14.

Patches 15-19 are fixes for missing or made-up consistency checks.

Patches 20-22 are renames and cleanups.

Patches 23-26 add hardening to reading the VMCB12, caching all used
fields in the save area to prevent theoritical TOC-TOU bugs, sanitizing
used fields in the control area, and restricting accesses to the VMCB12
through guest memory.

v3 -> v4:
- Proerply leave guest mode on failed VMRUN [2].
- Fixed baseline and rebased on top of kvm-x86/next.

v3: https://lore.kernel.org/kvm/20251215192722.3654335-1-yosry.ahmed@linux.dev/

[1]https://lore.kernel.org/kvm/20251108004524.1600006-1-yosry.ahmed@linux.dev/
[2]https://lore.kernel.org/kvm/timpvklyyl5juo5ajjzuxwazc5w2t6ffcx7llnv6f2a5qzot3b@hnj3wqwtla6c/

Yosry Ahmed (26):
  KVM: SVM: Switch svm_copy_lbrs() to a macro
  KVM: SVM: Add missing save/restore handling of LBR MSRs
  KVM: selftests: Add a test for LBR save/restore (ft. nested)
  KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN
  KVM: nSVM: Triple fault if mapping VMCB12 fails on nested #VMEXIT
  KVM: nSVM: Triple fault if restore host CR3 fails on nested #VMEXIT
  KVM: nSVM: Drop nested_vmcb_check_{save/control}() wrappers
  KVM: nSVM: Call enter_guest_mode() before switching to VMCB02
  KVM: nSVM: Make nested_svm_merge_msrpm() return an errno
  KVM: nSVM: Call nested_svm_merge_msrpm() from enter_svm_guest_mode()
  KVM: nSVM: Call nested_svm_init_mmu_context() before switching to
    VMCB02
  KVM: nSVM: Refactor minimal #VMEXIT handling out of
    nested_svm_vmexit()
  KVM: nSVM: Unify handling of VMRUN failures with proper cleanup
  KVM: nSVM: Clear EVENTINJ field in VMCB12 on nested #VMEXIT
  KVM: nSVM: Drop the non-architectural consistency check for NP_ENABLE
  KVM: nSVM: Add missing consistency check for nCR3 validity
  KVM: nSVM: Add missing consistency check for hCR0.PG and NP_ENABLE
  KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS
  KVM: nSVM: Add missing consistency check for event_inj
  KVM: SVM: Rename vmcb->nested_ctl to vmcb->misc_ctl
  KVM: SVM: Rename vmcb->virt_ext to vmcb->misc_ctl2
  KVM: SVM: Use BIT() and GENMASK() for definitions in svm.h
  KVM: nSVM: Cache all used fields from VMCB12
  KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
  KVM: nSVM: Sanitize control fields copied from VMCB12
  KVM: nSVM: Only copy NP_ENABLE from VMCB01's misc_ctl

 arch/x86/include/asm/svm.h                    |  96 ++--
 arch/x86/kvm/svm/nested.c                     | 540 +++++++++++-------
 arch/x86/kvm/svm/sev.c                        |   4 +-
 arch/x86/kvm/svm/svm.c                        |  68 +--
 arch/x86/kvm/svm/svm.h                        |  51 +-
 arch/x86/kvm/x86.c                            |   3 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/processor.h     |   5 +
 tools/testing/selftests/kvm/include/x86/svm.h |  14 +-
 tools/testing/selftests/kvm/lib/x86/svm.c     |   2 +-
 .../selftests/kvm/x86/svm_lbr_nested_state.c  | 155 +++++
 11 files changed, 636 insertions(+), 303 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c


base-commit: f62b64b970570c92fe22503b0cdc65be7ce7fc7c
-- 
2.52.0.457.g6b5491de43-goog


