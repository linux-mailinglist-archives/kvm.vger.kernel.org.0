Return-Path: <kvm+bounces-71471-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SJXIMXh3nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71471-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:51:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6182C17911A
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:51:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A8B01308B9A2
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2393033CF;
	Mon, 23 Feb 2026 15:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQOhfZNV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D129612F585;
	Mon, 23 Feb 2026 15:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771861612; cv=none; b=Fj33S1CYQgv69yMgFms2oSeRviqFiewncz3qQ8DtLrPTrRH/pd16LHOENNOA8jRoHs1XDojrgIAsl5uvOJqKefJXMGhxNtCPjukzpeOK5sImBJ0n07ah+7c8EOdu2OEeap5qYENzmjLZ51FJG/+wPpb9ITH7wq+fc1zJFbXNO3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771861612; c=relaxed/simple;
	bh=A0QMHEIf9poh+N25FSN/WhFw4x9idRTJ82NeDPFY6z4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MKmEe0dENqFOn3BTlNAujJ1/GKvBFdH6W/UtT+2sxsJJgk2UWQ/0xlbHgsVJx6Gs96fhP/PrNkTJB+apGSaJj5Z7PamqTVsVvUR8+kNZRDy5QWiWE5+OvEKbF5B78vyjcIpNKd9peqBvFSS9J+24tAgPIg4uhPVjtMXhXvz45nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQOhfZNV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A59AC116D0;
	Mon, 23 Feb 2026 15:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771861612;
	bh=A0QMHEIf9poh+N25FSN/WhFw4x9idRTJ82NeDPFY6z4=;
	h=From:To:Cc:Subject:Date:From;
	b=VQOhfZNVtNC0T6xmNVSqj2CcKVhs9a3PzPuN7L8kcsrT123nfbXfLF1FIhHU6LrLX
	 8yLD16lyVHVCU8F/fGuDT7i8cQCJhmo1jcx1VwO3I/pX8kcxrSZ4cavymOjscENJXi
	 EgCk+vaJjLkx0+OIvQRbjVEQWGHlDyb+BzMt1S/moWzW5aSlznK26bxAKenyElC6FT
	 4EyubsWgZplNZPYl4llP3S1nkbLogsKz2gkdTxL7fqwCXkgeKfU1K4FXUAV+KRvmnH
	 20HpecdYInMbzTfikQECeXOEjW/k/J9PatWrFKdsOtMlTV3EZtPCnm5+ljroVSHNII
	 CePsvzmGkbjPQ==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v1 0/4] KVM: nSVM: Fix RIP usage in the control area after restore
Date: Mon, 23 Feb 2026 15:46:32 +0000
Message-ID: <20260223154636.116671-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71471-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 6182C17911A
X-Rspamd-Action: no action

Fix a few bugs in using L2's RIP to construct fields in vmcb02 after
save+restore. The main problem is that the vmcb12_rip (and maybe
vmcb12_cs_base) values passed to nested_vmcb02_prepare_control() in the
restore path are broken.

The series fixes that by delaying initializing the fields depending on
RIP and CS base until shortly before VMRUN, to use the most up-to-date
fields regardless of save+restore order.

It also fixes another bug where using vmcb12_rip is incorrect, even if
it was restored correctly (patch 1).

Patch 4 is a reproducer, not intended for merging. It modifies
svm_nested_soft_inject_test to reproduce the bug.

RFC -> v1:
- Only set NextRIP in vmcb02 if supported by the CPU [Sean].
- Rework the fixes to delay using RIP and CS base until before VMRUN,
  instead of fixing up the fields using them when RIP or CS is set
  [Sean].

RFC: https://lore.kernel.org/kvm/20260212230751.1871720-1-yosry.ahmed@linux.dev/

Yosry Ahmed (4):
  KVM: nSVM: Always use NextRIP as vmcb02's NextRIP after first L2 VMRUN
  KVM: nSVM: Delay stuffing L2's current RIP into NextRIP until vCPU run
  KVM: nSVM: Delay setting soft IRQ RIP tracking fields until vCPU run
  DO NOT MERGE: KVM: selftests: Reproduce nested RIP restore bug

 arch/x86/kvm/svm/nested.c                     | 35 ++++-----
 arch/x86/kvm/svm/svm.c                        | 28 +++++++
 .../testing/selftests/kvm/lib/x86/processor.c |  3 +
 .../kvm/x86/svm_nested_soft_inject_test.c     | 74 +++++++++++++++----
 4 files changed, 105 insertions(+), 35 deletions(-)


base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
-- 
2.53.0.345.g96ddfc5eaa-goog


