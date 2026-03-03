Return-Path: <kvm+bounces-72455-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uMIOA50spmm/LgAAu9opvQ
	(envelope-from <kvm+bounces-72455-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:34:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0F51E7254
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:34:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EA28B3025249
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F04215055;
	Tue,  3 Mar 2026 00:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dYIE1lQL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2F2390986;
	Tue,  3 Mar 2026 00:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498071; cv=none; b=k58eYIuwsHua9pzMrO3ll9wWQhikE3KVk3eQLNaZk18W+5INFdD+wB3JVa3z4HCkDXXhpM9qjKXybIKdGIdD9iUcwR6hNmjBu1ukvekYiL+3fZlaZY5v8bhiJIXrzbaQCrugMYy8YvjFQXuaY2Hn7/EthVUkcvT0aQv/UNliAY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498071; c=relaxed/simple;
	bh=QNLvDrOLEldU6XQsPMTLJ/MXSr0kqB/onso4UjJSmt4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=af/d1bShaIjt9cfoD6bPkT8PTl3lGYQ7AqImyb5rSdrCNafucQ1C1JqvP0qmnhKr7v5xtAiUpLFjzK/9pg1m/SJimlSg5emLJC78t8GSzhddvrcPjCnBjWsVUU/OuQiMkYLFBoR0me+is5ZO2Q1GuVz9u1BgnVkAQ8Nf/b2m+Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dYIE1lQL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C62C19423;
	Tue,  3 Mar 2026 00:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498071;
	bh=QNLvDrOLEldU6XQsPMTLJ/MXSr0kqB/onso4UjJSmt4=;
	h=From:To:Cc:Subject:Date:From;
	b=dYIE1lQLyylVaDrsHoNIGqjbVtPYoL6eyc5AWIwWSGzIAAFWQZSg5YLEkGPwG7H+9
	 yoBQ8u/7pyrrFDQwCdEziidjtYvdHJZ/1axep+cRteArivGJxmS/jLAqIQzbRkFws6
	 6v8KhrgfW5npM6XA7i6cK4IzdyDR04S5HBYB1EYF7WRHEjUyCEoIVB0g/x8+31mBk/
	 ugdK8yPGp8fhLyDiD75QWXyuNH1Re7dMe5KYPLpxy6zqly2qn9zPFJ1necBcTQmC3X
	 /kByeD95Yj7Eb90X9DFDLbGZXaV3UGQg39TfwKHeFDQZPcJeq1rgjpYjENmMudfyeT
	 L4wQKOPwIcbVg==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v7 00/26] Nested SVM fixes, cleanups, and hardening
Date: Tue,  3 Mar 2026 00:33:54 +0000
Message-ID: <20260303003421.2185681-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB0F51E7254
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72455-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,cr0.pg:url]
X-Rspamd-Action: no action

A group of semi-related fixes, cleanups, and hardening patches for nSVM.
The series is essentially a group of related mini-series stitched
together for syntactic and semantic dependencies. The first 17 patches
(except patch 3) are all optimistically CC'd to stable as they are fixes
or refactoring leading up to bug fixes. Although I am not sure how much
of that will actually apply to stable trees.

Patches 1-3 here are v2 of the last 3 patches in the LBRV fixes series
[1]. The first 3 patches of [1] are already upstream.

Patches 4-12 are fixes for failure handling in the nested VMRUN and
#VMEXIT code paths.

Patches 13-17 are fixes for missing or made-up consistency checks.

Patches 18-19 are renames and cleanups.

Patches 20-25 add hardening to reading the VMCB12, caching all used
fields in the save area to prevent theoritical TOC-TOU bugs, sanitizing
used fields in the control area, and restricting accesses to the VMCB12
through guest memory.

Finally, patch 26 is a selftest for nested VMRUN and #VMEXIT failures
due to failing to map vmcb12.

v6 -> v7:
- Dropped unification of VMRUN failure paths and refactoring patches
  leading up to it, consistency checks are now moved into the helper
  copying vmcb12 to cache instead of enter_svm_guest_mode().
- Clear reserved bits in dbgctl in KVM_SET_NESTED_STATE.
- Dropped consistency check on hCR0 as CR0.PG is already checked.
- Dropped redundant check on CR4.PAE in new CS consistency check.
- Correctly cache clean bits from vmcb12.
- Update selftest to use a single VMRUN instruction and avoid missing
  post-VMRUN L1 registers restore.

v6: https://lore.kernel.org/kvm/20260224223405.3270433-1-yosry@kernel.org/

[1]https://lore.kernel.org/kvm/20251108004524.1600006-1-yosry.ahmed@linux.dev/

Yosry Ahmed (26):
  KVM: nSVM: Avoid clearing VMCB_LBR in vmcb12
  KVM: SVM: Switch svm_copy_lbrs() to a macro
  KVM: SVM: Add missing save/restore handling of LBR MSRs
  KVM: selftests: Add a test for LBR save/restore (ft. nested)
  KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN
  KVM: nSVM: Refactor checking LBRV enablement in vmcb12 into a helper
  KVM: nSVM: Refactor writing vmcb12 on nested #VMEXIT as a helper
  KVM: nSVM: Triple fault if mapping VMCB12 fails on nested #VMEXIT
  KVM: nSVM: Triple fault if restore host CR3 fails on nested #VMEXIT
  KVM: nSVM: Clear GIF on nested #VMEXIT(INVALID)
  KVM: nSVM: Clear EVENTINJ fields in vmcb12 on nested #VMEXIT
  KVM: nSVM: Clear tracking of L1->L2 NMI and soft IRQ on nested #VMEXIT
  KVM: nSVM: Drop nested_vmcb_check_{save/control}() wrappers
  KVM: nSVM: Drop the non-architectural consistency check for NP_ENABLE
  KVM: nSVM: Add missing consistency check for nCR3 validity
  KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS
  KVM: nSVM: Add missing consistency check for EVENTINJ
  KVM: SVM: Rename vmcb->nested_ctl to vmcb->misc_ctl
  KVM: SVM: Rename vmcb->virt_ext to vmcb->misc_ctl2
  KVM: nSVM: Cache all used fields from VMCB12
  KVM: nSVM: Restrict mapping vmcb12 on nested VMRUN
  KVM: nSVM: Use PAGE_MASK to drop lower bits of bitmap GPAs from vmcb12
  KVM: nSVM: Sanitize TLB_CONTROL field when copying from vmcb12
  KVM: nSVM: Sanitize INT/EVENTINJ fields when copying from vmcb12
  KVM: nSVM: Only copy SVM_MISC_ENABLE_NP from VMCB01's misc_ctl
  KVM: selftest: Add a selftest for VMRUN/#VMEXIT with unmappable vmcb12

 arch/x86/include/asm/svm.h                    |  20 +-
 arch/x86/kvm/svm/nested.c                     | 459 +++++++++++-------
 arch/x86/kvm/svm/sev.c                        |   4 +-
 arch/x86/kvm/svm/svm.c                        |  72 +--
 arch/x86/kvm/svm/svm.h                        |  50 +-
 arch/x86/kvm/x86.c                            |   3 +
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../selftests/kvm/include/x86/processor.h     |   5 +
 tools/testing/selftests/kvm/include/x86/svm.h |  14 +-
 tools/testing/selftests/kvm/lib/x86/svm.c     |   2 +-
 .../kvm/x86/nested_vmsave_vmload_test.c       |  16 +-
 .../selftests/kvm/x86/svm_lbr_nested_state.c  | 145 ++++++
 .../kvm/x86/svm_nested_invalid_vmcb12_gpa.c   |  98 ++++
 13 files changed, 644 insertions(+), 246 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c


base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
-- 
2.53.0.473.g4a7958ca14-goog


