Return-Path: <kvm+bounces-70570-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yDIvDeJiiWla8AQAu9opvQ
	(envelope-from <kvm+bounces-70570-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:30:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E7A5110B8F7
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:30:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7C058300E176
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 04:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E8C2E7BCC;
	Mon,  9 Feb 2026 04:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="n3iYfMtj"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70310265CDD;
	Mon,  9 Feb 2026 04:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770611407; cv=none; b=O1dz5rStyMDvBUsKFWDy5BBDS5jyzqxaCwqQsNebK2+oI/jc6C09oHpPqO65szzqfZRWD1GYDXHsJRM9JbM4xy8gZd5QEPcsDmS39uk6EOHQArtFannmNw0irxBRm8MbHrofTsJGJxBTQKi7jud8LiC3Dpyb2IqDIWlAPYfEMZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770611407; c=relaxed/simple;
	bh=C1Gob3adNCewxQzyZFbOuW9J7q14TTNkGgLRrCJ6FIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=svZ/zEVGVu5PS7OtxRDeG4Yk4/ANizhk/sSDgwyOUUKjCu5pftmbLQtFtjSuUCknFTajYaT8G1WcPK0nUkqtiSvSdEXgYlSXjWVQW6oqHWZTYcrpvIqdiYj/d70nXgV/i8ROkNBO+dp6mv5h3EXqyEeqeBMI2eVLE+0bEZ/DI0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=n3iYfMtj; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=7Z
	DxWqlw9Md/Pb6bh19k+/fmDo/i1z2nV0vxcIKxI8U=; b=n3iYfMtjZ4ItxcaqCi
	6kp40jhJ8WjXRwRdUa01YfoJXN7RcWPb6AHdcfWceG0bixkj2gfsufkdsiWaGKig
	ApGQnUV6pi+xUmwDh1RRX1MoJ6pHRk+YAWarwhRkls0QybKrHXkKS7MB+++8k2pN
	2q51luKCXAmq7Zh5PjqYUed2E=
Received: from 163.com (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgD3F+yvYolpOQZEQw--.25673S2;
	Mon, 09 Feb 2026 12:29:35 +0800 (CST)
From: Zhiquan Li <zhiquan_li@163.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiquan_li@163.com
Subject: [PATCH RESEND 0/5] KVM: x86: selftests: Add Hygon CPUs support and fix failures
Date: Mon,  9 Feb 2026 12:13:00 +0800
Message-ID: <20260209041305.64906-1-zhiquan_li@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgD3F+yvYolpOQZEQw--.25673S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFWUXr4fAF45AFyfWr4fuFg_yoW8Aw1rpa
	1fJw4YkF97Ja4SkayfJF1kArn7AFn3CF4UGr1Yyw47ArW5G3Wxtw4Iga10q3WfCr4vvr15
	Za9rGFnrWw4DJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zK-e7bUUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbCwg+AaWmJYq+JMQAA3x
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70570-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,163.com];
	FREEMAIL_FROM(0.00)[163.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhiquan_li@163.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E7A5110B8F7
X-Rspamd-Action: no action

This series to add support for Hygon CPUs and fix 11 KVM selftest failures
on Hygon architecture.

Patch 1 add CPU vendor detection for Hygon and add a global variable
"host_cpu_is_hygon" to identify if the test is running on a Hygon CPU.
It is the prerequisite for the following fixes.

Patch 2 fix x86/fix_hypercall_test test failure by altering the hypercall
instruction on Hygon CPUs.

Patch 3 fix following test failures by avoiding using the reserved
memory regions on Hygon CPUs.
- access_tracking_perf_test
- demand_paging_test
- dirty_log_perf_test
- dirty_log_test
- kvm_page_table_test
- memslot_modification_stress_test
- pre_fault_memory_test
- x86/dirty_log_page_splitting_test

Patch 4 fix x86/pmu_event_filter_test test failure by allowing the tests
for Hygon CPUs.

Patch 5 fix x86/msrs_test test failure by fixing the expectation while
writing the MSR_TSC_AUX reserved bits without RDPID support.

Zhiquan Li (5):
  KVM: x86: selftests: Add CPU vendor detection for Hygon
  KVM: x86: selftests: Alter the instruction of hypercall on Hygon
  KVM: x86: selftests: Avoid failures due to reserved memory address
    regions on Hygon
  KVM: x86: selftests: Allow the PMU event filter test for Hygon
  KVM: x86: selftests: Fix write MSR_TSC_AUX reserved bits test failure
    on Hygon

 .../selftests/kvm/include/x86/processor.h     |  6 +++++
 .../testing/selftests/kvm/lib/x86/processor.c | 12 ++++++---
 .../selftests/kvm/x86/fix_hypercall_test.c    |  2 +-
 tools/testing/selftests/kvm/x86/msrs_test.c   | 26 +++++++++++++++----
 .../selftests/kvm/x86/pmu_event_filter_test.c |  6 ++---
 5 files changed, 39 insertions(+), 13 deletions(-)


base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b

---
Re-send: rebase to v6.19

-- 
2.43.0


