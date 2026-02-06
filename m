Return-Path: <kvm+bounces-70483-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MK7aI5E9hmnzLAQAu9opvQ
	(envelope-from <kvm+bounces-70483-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:14:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E372D102869
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:14:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7EAA830A2D49
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5DF42DFFA;
	Fri,  6 Feb 2026 19:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bbv16ARX"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A0642885E
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404959; cv=none; b=jpaS6C2ejXpdh0QYudgV5IJb6cEbQDjZ4CecR+AhO+3CE82pAwL1E2FE6vRGAiSBlu8b6zdOfF2CDsYhQ6640XyY4hdqV6dOr2BCgivTER6QZv4MFjyZCUOcc67tt4G80iEPW31n19JVCHwjdk50trQHpegjhsNG3vooSHEZrE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404959; c=relaxed/simple;
	bh=uPAuGDGjd07KIxW4y2a57kw9hRjvzs/p9kGJ3vB1W1A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fPymL6Viedzc8IlwkpCuu5Jc7VdT5SHMRMLF5daShRTlMy30x2dO/Yhjy+PipYkoG8pjacMkVCQ5C01rBWaPo6IEqqQsr+rENEhNqt4lf/p0JnF0xgQHXZA2xb3yvNG89ern5nsEWl0JYppX9kYvaLrl56CqR6/xDxQ2871DG0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bbv16ARX; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770404947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SqJ8dtVWtxDixQAKPorQw9Vpby9xzjW8ebPYq6NK1xU=;
	b=Bbv16ARX5S9f/Tl9g4MqHoab39TTY5zQSpSNInJknn+sHdpV8QzLIv84m9uplFpFq06XYN
	9+FVHmUl7iRLob1tZ54NBMma5RH+jUoCtQziAc3dGw4LFljKNlVkaM57t9Tqep7CTFGzbW
	8TwckCMOeZA4kR1W5VTg5q8wGpyH+lo=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v5 00/26] Nested SVM fixes, cleanups, and hardening
Date: Fri,  6 Feb 2026 19:08:25 +0000
Message-ID: <20260206190851.860662-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70483-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.997];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: E372D102869
X-Rspamd-Action: no action

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
- Dropped "KVM: SVM: Use BIT() and GENMASK() for definitions in svm.h"
  [Sean].
- Split the vmcb12 clean bit fix from using a macro for svm_copy_lbrs()
  [Sean].
- Dropped test comments and GUEST_PRINTF(), renamed RECORD_BRANCH(), and
  used do/while for macros [Sean].
- Renamed nested_svm_failed_vmrun() to nested_svm_vmrun_error_vmexit(),
  used WARN_ON_ONCE() instead of WARN(), and fixed build at intermediate
  patches [Sean].
- Fixed nCR3 consistency check to check NP enablement from the passed
  control area [Yosry].
- Updated the names of MISC flags [Sean].

v4: https://lore.kernel.org/kvm/20260115011312.3675857-1-yosry.ahmed@linux.dev/

[1]https://lore.kernel.org/kvm/20251108004524.1600006-1-yosry.ahmed@linux.dev/

Yosry Ahmed (26):
  KVM: nSVM: Avoid clearing VMCB_LBR in vmcb12
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
  KVM: nSVM: Cache all used fields from VMCB12
  KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
  KVM: nSVM: Sanitize control fields copied from VMCB12
  KVM: nSVM: Only copy SVM_MISC_ENABLE_NP from VMCB01's misc_ctl

 arch/x86/include/asm/svm.h                    |  18 +-
 arch/x86/kvm/svm/nested.c                     | 541 +++++++++++-------
 arch/x86/kvm/svm/sev.c                        |   4 +-
 arch/x86/kvm/svm/svm.c                        |  68 +--
 arch/x86/kvm/svm/svm.h                        |  51 +-
 arch/x86/kvm/x86.c                            |   3 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/processor.h     |   5 +
 tools/testing/selftests/kvm/include/x86/svm.h |  14 +-
 tools/testing/selftests/kvm/lib/x86/svm.c     |   2 +-
 .../kvm/x86/nested_vmsave_vmload_test.c       |  16 +-
 .../selftests/kvm/x86/svm_lbr_nested_state.c  | 146 +++++
 12 files changed, 599 insertions(+), 270 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c


base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
-- 
2.53.0.rc2.204.g2597b5adb4-goog


