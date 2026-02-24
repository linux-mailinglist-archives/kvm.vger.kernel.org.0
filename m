Return-Path: <kvm+bounces-71676-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Ko2ORkonmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71676-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:37:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A6BE18D6FB
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:37:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6744730E97C0
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9711134CFBA;
	Tue, 24 Feb 2026 22:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHUZMGp3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBFE8F4A;
	Tue, 24 Feb 2026 22:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972461; cv=none; b=ipc/Su2c+30dBKGBMqjYe67h/zLLai9gckz+yFXZHNSrk8Q2EycsjKiTOKDFwn1fIY7GIvIQdlZ+njBm9zqw8zpmMYkWmOEdPcysLkN7TSTu7JH69A0+4SKAfvlUpJx4NUhv9/xCFOlFYCGltUO6jbh0QUj6MXjlAdB8aKwyHsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972461; c=relaxed/simple;
	bh=Z127UEFMX+xC/GQ4f7BhqeRAlZyC95G5cspFEeYWSAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZkjVx5J76UOol9dL9C2fLNxkWb8qauuMUkH2A2oTQYO29bN4KCWoHUgoNwbetg27qQzd6azz+1cjc0DrBCkJznYuTPs5AvSYTpncN9S4rfH7reYIBE9vekQ7dwH8FPNpek6spzGTKRtNO6/RWozLyFdxDcdJVVmpW3tdAdDAhMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHUZMGp3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3610BC116D0;
	Tue, 24 Feb 2026 22:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972461;
	bh=Z127UEFMX+xC/GQ4f7BhqeRAlZyC95G5cspFEeYWSAk=;
	h=From:To:Cc:Subject:Date:From;
	b=VHUZMGp3okznwL8sD3KNancaTMKOU8kZsS0uVC1bJJyYKkb5CD42bfOlbN9c7BaP7
	 a8+mHVkInCscFi8scvuHEoi+C9CewUjp8TnqlkEvewyjgM77DVUu4x1hBdpy07XhGB
	 OCOukjDFsKuT0uae8ExxEt4h0j++Q1aSgv6L23/wHsfdQzR2TObzZINgKgP4zVkYtE
	 PwCZcqJaezK6YEua7rqutKwdjYDXTWhp2RLM0fMed6Naz32piLD8pYNQcEW0xGJ3Un
	 1msOkPOkG9J66RaLlKUIqvxidORevelOYjig5mODigok/JwOb1rzLd0pNbMEAHpYMY
	 EKPJ5doJ6Nj1Q==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH 00/31] Nested SVM fixes, cleanups, and hardening
Date: Tue, 24 Feb 2026 22:33:34 +0000
Message-ID: <20260224223405.3270433-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71676-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[hcr0.pg:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4A6BE18D6FB
X-Rspamd-Action: no action

A group of semi-related fixes, cleanups, and hardening patches for nSVM.
The series is essentially a group of related mini-series stitched
together for syntactic and semantic dependencies. The first 22 patches
(except patch 3) are all optimistically CC'd to stable as they are fixes
or refactoring leading up to bug fixes. Although I am not sure how much
of that will actually apply to stable trees.

Patches 1-3 here are v2 of the last 3 patches in the LBRV fixes series
[1]. The first 3 patches of [1] are already upstream.

Patches 4-17 are fixes for failure handling in the nested VMRUN and
#VMEXIT code paths, ending with a nice unified code path for handling
VMRUN failures as suggested by Sean. Within this block, patches 7-12 are
refactoring needed for patches 13-14.

Patches 18-22 are fixes for missing or made-up consistency checks.

Patches 23-24 are renames and cleanups.

Patches 25-30 add hardening to reading the VMCB12, caching all used
fields in the save area to prevent theoritical TOC-TOU bugs, sanitizing
used fields in the control area, and restricting accesses to the VMCB12
through guest memory.

Finally, patch 31 is a selftest for nested VMRUN and #VMEXIT failures
due to failing to map vmcb12.

v5 -> v6:
- Set VMCB_LBR dirty when setting LBR registers [Yosry].
- Fix state leakage in LBR save/restore test [Kevin Cheng].
- Do not abort nested #VMEXIT flow if mapping vmcb12 or restoring L1 CR3
  fails [Sean].
- Break down the patch sanitizing control fields from vmcb12 and drop
  the ASID comment change [Sean].
- Add a selftest for VMRUN and #VMEXIT with unmappable vmcb12 [Yosry].

v5: https://lore.kernel.org/kvm/20260206190851.860662-1-yosry.ahmed@linux.dev/

Yosry Ahmed (31):
  KVM: nSVM: Avoid clearing VMCB_LBR in vmcb12
  KVM: SVM: Switch svm_copy_lbrs() to a macro
  KVM: SVM: Add missing save/restore handling of LBR MSRs
  KVM: selftests: Add a test for LBR save/restore (ft. nested)
  KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN
  KVM: nSVM: Refactor checking LBRV enablement in vmcb12 into a helper
  KVM: nSVM: Refactor writing vmcb12 on nested #VMEXIT as a helper
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
  KVM: nSVM: Add missing consistency check for EVENTINJ
  KVM: SVM: Rename vmcb->nested_ctl to vmcb->misc_ctl
  KVM: SVM: Rename vmcb->virt_ext to vmcb->misc_ctl2
  KVM: nSVM: Cache all used fields from VMCB12
  KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
  KVM: nSVM: Use PAGE_MASK to drop lower bits of bitmap GPAs from vmcb12
  KVM: nSVM: Sanitize TLB_CONTROL field when copying from vmcb12
  KVM: nSVM: Sanitize INT/EVENTINJ fields when copying from vmcb12
  KVM: nSVM: Only copy SVM_MISC_ENABLE_NP from VMCB01's misc_ctl
  KVM: selftest: Add a selftest for VMRUN/#VMEXIT with unmappable vmcb12

 arch/x86/include/asm/svm.h                    |  20 +-
 arch/x86/kvm/svm/nested.c                     | 570 +++++++++++-------
 arch/x86/kvm/svm/sev.c                        |   4 +-
 arch/x86/kvm/svm/svm.c                        |  68 ++-
 arch/x86/kvm/svm/svm.h                        |  50 +-
 arch/x86/kvm/x86.c                            |   3 +
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../selftests/kvm/include/x86/processor.h     |   5 +
 tools/testing/selftests/kvm/include/x86/svm.h |  14 +-
 tools/testing/selftests/kvm/lib/x86/svm.c     |   2 +-
 .../kvm/x86/nested_vmsave_vmload_test.c       |  16 +-
 .../selftests/kvm/x86/svm_lbr_nested_state.c  | 145 +++++
 .../kvm/x86/svm_nested_invalid_vmcb12_gpa.c   |  95 +++
 13 files changed, 711 insertions(+), 283 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c


base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
-- 
2.53.0.414.gf7e9f6c205-goog


