Return-Path: <kvm+bounces-71716-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mPIEFp9JnmnXUQQAu9opvQ
	(envelope-from <kvm+bounces-71716-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:00:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A40318E73C
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:00:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EF2213093419
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1649245019;
	Wed, 25 Feb 2026 01:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJ8o1mVv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3C423D7CF;
	Wed, 25 Feb 2026 01:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771981200; cv=none; b=G7RecxNjw8ZTBQZ/Mv8otEtYekftmRONVUNTjlgCTvBj+2EeGCxmRWMDc8t+JE1aEeyDR6AbKxL0lGosNguaOsDSwbEMeMCPvargC6k/61JvYtB7M7JC2fBDlDMMH/8bF9a2VsGVzMZF3dlUYEY/SGhdsGcI0s0KzBMxKGurJy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771981200; c=relaxed/simple;
	bh=6awsFBVwM64ihHUtfTRmBVQcgB57/hIwK/+hKfWAJx8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EhCRVrzMlrRkvHjN0emnPmMaILY12/rB6B4C0g+8NKRH1Z5SeWkIVNUiYqekUfAtlRanG+WoxQinrZjit6ixO6ffdMr7utBwq8KHcuHpE3W5fZlOp6UOVVJVPYNo2MKzOQQUQOr2hDwjcuCkwscGEjf+nwagIIeZlrpzIIStizE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJ8o1mVv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C26C2BC86;
	Wed, 25 Feb 2026 00:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771981199;
	bh=6awsFBVwM64ihHUtfTRmBVQcgB57/hIwK/+hKfWAJx8=;
	h=From:To:Cc:Subject:Date:From;
	b=JJ8o1mVvmodZbL5vi2xwIvuBPDAka5UBV2XJh3ihkYDgUI7YewD1e8PN5GowYWu49
	 NhJ3Ajlz9HsUyz2l+JSwwbErks2PqpjDETpEjdy/sJuhXOQCO09NNkWVn+MvsTh3fh
	 IPyFRGyaZ5/xLgYd0qPIFNm1yZ5slmgML+nCSc3v6TDxgvssH+kOzrHGyDQW+ylcCV
	 RxynjK0rTVk9jubcRAlk6HYitKdehqfvtQtIsx2eL0s/Zu3ImvUYuYjqLewk2wAXlm
	 ppChsK//p0n3BJqgIYov5HdkKJhzeohDSa9Y+AiPXvY6jI6nhoHd8Uzy22dgjKdLfK
	 j3LZbNfmwKELQ==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v3 0/8] KVM: nSVM: Save/restore fixes for (Next)RIP 
Date: Wed, 25 Feb 2026 00:59:42 +0000
Message-ID: <20260225005950.3739782-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	SUBJECT_ENDS_SPACES(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71716-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1A40318E73C
X-Rspamd-Action: no action

This is a combined v3 of series [1] and v2 of series [2], as patch 1
here is a dependency of patch 5. Without patch 1, NextRIP is not sync'd
correctly to the cache, and restoring it for a guest without NRIPS is a
bug.

The series fixes two classes of save/restore bugs:
- Some fields written by the CPU are not sync'd from vmcb02 to cached
  vmcb12 after VMRUN, so are not up-to-date in KVM_GET_NESTED_STATE
  payload (fixes in patches 1 & 2, tests in patches 3 & 4).
- Ordering between KVM_SET_NESTED_STATE and KVM_SET_{S}REGS could cause
  vmcb02 to be incorrectly initialized after save+restore (fixes in
  patches 5 to 7).

Patch 8 is a reproducer for the second class of bugs, it should not be
merged.

v2 -> v3 (for series [1]):
- Dropped patch moving vmcb02->vmcb12 sync after completing interrupts.

v1 -> v2 (for series [2]):
- Move code updating NextRIP and soft IRQ RIP tracking from
  svm_prepare_switch_to_guest() to pre_svm_run().

[1]https://lore.kernel.org/kvm/20260211162842.454151-1-yosry.ahmed@linux.dev/
[2]https://lore.kernel.org/kvm/20260223154636.116671-1-yosry@kernel.org/

Yosry Ahmed (8):
  KVM: nSVM: Sync NextRIP to cached vmcb12 after VMRUN of L2
  KVM: nSVM: Sync interrupt shadow to cached vmcb12 after VMRUN of L2
  KVM: selftests: Extend state_test to check vGIF
  KVM: selftests: Extend state_test to check next_rip
  KVM: nSVM: Always use NextRIP as vmcb02's NextRIP after first L2 VMRUN
  KVM: nSVM: Delay stuffing L2's current RIP into NextRIP until vCPU run
  KVM: nSVM: Delay setting soft IRQ RIP tracking fields until vCPU run
  DO NOT MERGE: KVM: selftests: Reproduce nested RIP restore bug

 arch/x86/kvm/svm/nested.c                     | 36 +++++----
 arch/x86/kvm/svm/svm.c                        | 37 ++++++++++
 .../testing/selftests/kvm/lib/x86/processor.c |  8 +-
 tools/testing/selftests/kvm/x86/state_test.c  | 35 +++++++++
 .../kvm/x86/svm_nested_soft_inject_test.c     | 74 +++++++++++++++----
 5 files changed, 154 insertions(+), 36 deletions(-)


base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
-- 
2.53.0.414.gf7e9f6c205-goog


