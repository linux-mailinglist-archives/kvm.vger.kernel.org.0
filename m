Return-Path: <kvm+bounces-66004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A0F4BCBF8AC
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:29:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7D27E3032FDA
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20DE332918;
	Mon, 15 Dec 2025 19:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZyXFmDHQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399B6327790
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826871; cv=none; b=Gj8VqYv5gOLD33bp9iNv0KtJYx4aAuaZ1UQfEqo+fwldadtMvCjVH8xBf3zsIgiJ+Nb+9jC6ojcOxhLbA7dgCNq7rMyo8/qOkYRILUgWHxgvKr5cGtfsqVRGBkFiY1Bx3UZYdFp6alTQfg0/jL2v3ZdzuF7KjFOA5hN1DjIUjj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826871; c=relaxed/simple;
	bh=hjitnraVC2kjbWNPdp7s+94AsN9SLQUX7HosMfkYnxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DI9XlOQ2Ck7UD01loXal4NTMyzU9fkEjmpyr5c5eB7BHG71Bjvpa+6andmRDXO63HBybU//25K85pdIGCPb9/PlfAyrMrzUFk9Un7B6tStPdmLJHq721Ao/eVRgl6sIodtjFdiWZv16t40nD2aV2rmpmCotnBdfEoIX3Z0FbSKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZyXFmDHQ; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x4RcMsavL8X9izNjBQA5DLXQXAwKz3oWlqtVxkHPLic=;
	b=ZyXFmDHQ1wjsJocoRbbN7AdG0zqnNr6WcutyqRuFR5+Itxi4xEjvdEfqqs79b9gKpAhJiD
	Tlh2oHEDJhZEmKFKgMM8Od4DJI8hga3tkCJHSU0T2fwdzHt3Z16LuERHA7QJjyxj9vfoH+
	jmKiQpFHJ5AeeXC5tR7hajKAXxw9mfg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 00/26] Nested SVM fixes, cleanups, and hardening
Date: Mon, 15 Dec 2025 19:26:55 +0000
Message-ID: <20251215192722.3654335-2-yosry.ahmed@linux.dev>
In-Reply-To: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
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

Patches 1-3 here are v2 of the last 3 patches in in the LBRV fixes
series [1]. The first 3 patches of [1] are already in kvm/master. The
rest of this series is v2 of [2].

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

v2 -> v3:
- Dropped updating nested_npt_enabled() to check
  guest_cpu_cap_has(X86_FEATURE_NPT), instead clear the NP_ENABLE bit in
  the cached VMCB12 if the guest vCPU doesn't have X86_FEATURE_NPT.
- Patches 4-14 are all new, mostly from reviews on v2.
- The consistency checks were split into several patches, one per added
  or removed consistency check.
- Added a patch to cleanup definitions in svm.h as suggested by Sean,
  separate from introducing new definitions.
- Patch 'KVM: nSVM: Simplify nested_svm_vmrun()' was organically dropped
  as the simplifications happened incrementally across other patches.
- Patch 'KVM: nSVM: Sanitize control fields copied from VMCB12' was
  reworked to do the sanitization when copying to the cached VMCB12 (as
  opposed to when constructing the VMCB02).

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
 arch/x86/kvm/svm/nested.c                     | 536 +++++++++++-------
 arch/x86/kvm/svm/sev.c                        |   4 +-
 arch/x86/kvm/svm/svm.c                        |  68 +--
 arch/x86/kvm/svm/svm.h                        |  51 +-
 arch/x86/kvm/x86.c                            |   3 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/processor.h     |   5 +
 tools/testing/selftests/kvm/include/x86/svm.h |  14 +-
 .../selftests/kvm/x86/svm_lbr_nested_state.c  | 155 +++++
 10 files changed, 631 insertions(+), 302 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c

base-commit: 58e10b63777d0aebee2cf4e6c67e1a83e7edbe0f
-- 
2.52.0.239.gd5f0c6e74e-goog


