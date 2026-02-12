Return-Path: <kvm+bounces-70945-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6NqQJLCvjWmz5wAAu9opvQ
	(envelope-from <kvm+bounces-70945-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:47:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A6912CAB9
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:47:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C6E7530DAE67
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B302F6910;
	Thu, 12 Feb 2026 10:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="jIlWtm+Q"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C468D2F290E;
	Thu, 12 Feb 2026 10:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770893116; cv=none; b=cOTcvfp5SAlARVFKAECDwhLjqfLazI5hJZyqPE6sQTUo57/pMBojfyt8WKlM3vUCmwaddtLenMqo4u9N6F3Letdm1OdRgStAKZpIzItUX+k1CqsFbZqdE9NOG8n/CuIiahdM4I46d3aAhaPGs4ZIMpx6Fri6VYkgWzZBXyJjtGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770893116; c=relaxed/simple;
	bh=XoAIuQBtY4J4EUGLb/rUKgsJ56NhX2g2ruMD8x1/SPE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kkiEmhmZg4Ewr0Al0Qw++k48JrBgMtCjYK4ex84/bUIy9dRn6nUS51EDhpy8xiUKwQ20SLWOI0aWYQw07U7AG089x2q2vKX6SFvHAmACHeUMGlo17Mg5TcTJ4F8wQo7FeYCbfgt5oywMEH0vFM8Uy2BU7hj8dwXed8C05xI2qxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=jIlWtm+Q; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=pf
	0C5yDLykdNWASnjiYGY5IR0zrq3MjawwlxhYYTJGw=; b=jIlWtm+QJ7WkOr8OTR
	KoYOCKppqtOifKSnOVUR0VEYX9e0nz+kXhaRpgtsj/vApta3zHQig3XpaoJPwh4I
	bUjOGcqvaKUby/4369KxC1ubn/2v4UDu3TOmZHiKzw2lwQBNAl6MulNS88KKKl2m
	mrSyyZqQ7UMo0Et6s81yG6+Rs=
Received: from 163.com (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wA38f4Tr41pL2eqLA--.10527S2;
	Thu, 12 Feb 2026 18:44:36 +0800 (CST)
From: Zhiquan Li <zhiquan_li@163.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiquan_li@163.com
Subject: [PATCH v2 0/4] KVM: x86: selftests: Add Hygon CPUs support and fix failures
Date: Thu, 12 Feb 2026 18:38:37 +0800
Message-ID: <20260212103841.171459-1-zhiquan_li@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA38f4Tr41pL2eqLA--.10527S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFWUXr4fAF45AFyfXw4fXwb_yoW8KF4rpa
	yrAw4YkF4kJ3WSka4fGr1kJr1Iyrn3CFW0qr1Utay7Za45A3Wxta1fKa1rZw1fCrWFv3ya
	vasrtr43Ga1UAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zKhF3rUUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbCwhWul2mNrxXmLgAA34
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70945-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,163.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[163.com];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[zhiquan_li@163.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 10A6912CAB9
X-Rspamd-Action: no action

This series to add support for Hygon CPUs and fix 11 KVM selftest failures
on Hygon architecture.

Patch 1 add CPU vendor detection for Hygon and add a global variable
"host_cpu_is_hygon" to identify if the test is running on a Hygon CPU.
It is the prerequisite for the following fixes.

Patch 2 add a flag to identify AMD compatible CPU and figure out the
compatible cases, so that Hygon CPUs can re-use them.
Following test failures on Hygon platform can be fixed by this patch:
- access_tracking_perf_test
- demand_paging_test
- dirty_log_perf_test
- dirty_log_test
- kvm_page_table_test
- memslot_modification_stress_test
- pre_fault_memory_test
- x86/dirty_log_page_splitting_test
- x86/fix_hypercall_test

Patch 3 fix x86/pmu_event_filter_test failure by allowing the tests for
Hygon CPUs.

Patch 4 fix x86/msrs_test failure while writing the MSR_TSC_AUX reserved
bits without RDPID support.
Sean has made a perfect solution for the issue and provided the patch.
It has been verified on Intel, AMD and Hygon platforms, no regression.

---

V1: https://lore.kernel.org/kvm/20260209041305.64906-1-zhiquan_li@163.com/T/#t

Changes since V1:
- Rebased to kvm-x86/next.
- Followed Sean's suggestion, added a flag to identify AMD compatible test
  cases, then v1/patch 2 and v1/patch 3 can be combined to v2/patch 2.
- Followed Sean's suggestion, simplified patch 4, that is v2/patch 3 now.
- Sean provided the v2/patch 4 for the issue reported by v1/patch5, I
  replaced my SoB with "Reported-by" tag.

---

Sean Christopherson (1):
  KVM: selftests: Fix reserved value WRMSR testcase for multi-feature
    MSRs

Zhiquan Li (3):
  KVM: x86: selftests: Add CPU vendor detection for Hygon
  KVM: x86: selftests: Add a flag to identify AMD compatible test cases
  KVM: x86: selftests: Allow the PMU event filter test for Hygon

 .../testing/selftests/kvm/include/x86/processor.h |  7 +++++++
 tools/testing/selftests/kvm/lib/x86/processor.c   | 15 +++++++++++----
 .../selftests/kvm/x86/fix_hypercall_test.c        |  2 +-
 tools/testing/selftests/kvm/x86/msrs_test.c       |  4 ++--
 .../selftests/kvm/x86/pmu_event_filter_test.c     |  3 ++-
 .../testing/selftests/kvm/x86/xapic_state_test.c  |  2 +-
 6 files changed, 24 insertions(+), 9 deletions(-)


base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
-- 
2.43.0


