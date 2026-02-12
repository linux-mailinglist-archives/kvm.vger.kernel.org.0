Return-Path: <kvm+bounces-71023-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iBt1Dx5ejmmdBwEAu9opvQ
	(envelope-from <kvm+bounces-71023-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:11:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A076B131AC7
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:11:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B78CD31B0390
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 23:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23BD52F12C5;
	Thu, 12 Feb 2026 23:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ApQBC10h"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B303375AE
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 23:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770937708; cv=none; b=CgfaDQB00bOxPJnhFIO6p2MoJ5BKTJs4AcCmBrHGx0OQr8EnWhvNbdMWkpymzstIrOZwrvGCWYlTa96gY/6uaAydtu8qPMIEiV3f2WF2xtFxupYNouC6j+EVJ2NLRjCp46R6D9jgelKwEHXhMDFEA8+8LWZQREnlJ5GTH/U6rt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770937708; c=relaxed/simple;
	bh=2XjmFFT0nAD5yJLXJYlL6c5+k5i32jAwKOw0MaTZIEg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FejkX2ex33W4DQM6iUfFOj6R9/mVDnuTXqtxOhI/imdPrOHxbjVUJBavfl79FfO5xI1LdSluEG7cmoAlg9A3mnHOteDxsJu0T8ZIOCorujiFQ3KQYP+U077q7jXVUazSY6m8bo77n2OhPIYRXoyJMwp5tV/TsWLKEdHAEnoUB50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ApQBC10h; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770937694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=on+ccZ1SuHeXZ8tfm5/Ig0TJ69aIC29yD8YFAu/BSoY=;
	b=ApQBC10hCa5P20KBhodZbPaweWCJ/mhsbAyfjuyZTD15sZvlWpbRzUqgUV6GCOc84pzzJe
	jAZTDuElPvgPhbZs7PP+Wi+vbTEWJHWjlGP2pX5g8Oc8PbuhPWHlNkLc8iMD7pOy3IJkio
	O1UWpmNhz3BrQGxN+tZL9ccuOfpl6ck=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 0/5] KVM: nSVM: Fix RIP usage in the control area after restore
Date: Thu, 12 Feb 2026 23:07:46 +0000
Message-ID: <20260212230751.1871720-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71023-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:mid,linux.dev:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A076B131AC7
X-Rspamd-Action: no action

Fix a few bugs in using L2's RIP to construct fields in vmcb02 after
save+restore. The main problem is that the vmcb12_rip (and
vmcb12_cs_base) values passed to nested_vmcb02_prepare_control() in the
restore path are broken.

The series fixes that by using the correct RIP (and CS) values to
construct the relevant fields, whether nested state is restored before
or after regs/sregs.

It also fixes another bug where using vmcb12_rip is incorrect, even if
it was restored correctly (patch 1).

The series is an RFC mainly because I am not sure if the approach taken
in patch 4 is the correct way to do this, but otherwise it should be
good to go (I just jinxed it didn't I).

Patch 5 is a reproducer, not intended for merging. It modifies
svm_nested_soft_inject_test to reproduce the bug. Patch 2 makes the
reproducer passes, but if the ordering of vcpu_regs_set() and
vcpu_nested_state_set() is switched, then it only passes after patch 4.

Yosry Ahmed (5):
  KVM: nSVM: Do not use L2's RIP for vmcb02's NextRIP after first L2
    VMRUN
  KVM: nSVM: Use the correct RIP when restoring vmcb02's control area
  KVM: nSVM: Move updating NextRIP and soft IRQ RIPs into a helper
  KVM: SVM: Recalculate nested RIPs after restoring REGS/SREGS
  DO NOT MERGE: KVM: selftests: Reproduce nested RIP restore bug

 arch/x86/include/asm/kvm-x86-ops.h            |  1 +
 arch/x86/include/asm/kvm_host.h               |  1 +
 arch/x86/kvm/svm/nested.c                     | 64 ++++++++++------
 arch/x86/kvm/svm/svm.c                        | 21 ++++++
 arch/x86/kvm/svm/svm.h                        |  2 +
 arch/x86/kvm/x86.c                            |  2 +
 .../testing/selftests/kvm/lib/x86/processor.c |  3 +
 .../kvm/x86/svm_nested_soft_inject_test.c     | 74 +++++++++++++++----
 8 files changed, 129 insertions(+), 39 deletions(-)


base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
-- 
2.53.0.273.g2a3d683680-goog


