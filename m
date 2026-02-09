Return-Path: <kvm+bounces-70568-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WY3FJN1iiWla8AQAu9opvQ
	(envelope-from <kvm+bounces-70568-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:30:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0625510B8ED
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:30:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 49ECF300AEE6
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 04:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 286F52D6E55;
	Mon,  9 Feb 2026 04:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Yc8vvzWm"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0921F27C84E;
	Mon,  9 Feb 2026 04:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770611407; cv=none; b=tefrwUNO2ghcjJPS85CSUXEyp/qNdFLt5deAXDUpMUap/aAWV5UL6ELQD/7wjXdlxM1v0BVsJENB5CZTbJPnsc1qN3n0a6ovdUac/uAy9UNFN6O7IQ9fihPgB97S+xcwBqwp+KzNZgVCoJaxCahzUtdGzo3N0klmJ/VsIi8Ev6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770611407; c=relaxed/simple;
	bh=o9qiTqabUcEszYYfsg4Is62Jj/x8xBjHa7n1BMSgtzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOsfpeN79QKzW3NUwNSPaLlgF+YwzFQXP/T+qa3hVpzL0eyjtWDG8eiDdgNFHbS5BAqWrkV6CM7VWh8mPmwwLnV+P3FhuzyVDqpMOqbJPLQAx41nQNuFgabQHHzhS2wplIKrDBZSwrjwn6A1uQUWHeyKAcOzTaJypZi7c2t0T5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Yc8vvzWm; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=xb
	0PMGnfuKaBxrfKeA17F7puvY7wMgDlhlpI5Sayuno=; b=Yc8vvzWmAqYNw2Q4Z+
	cCZZ/WNZ0G6Vevn8K1bqgGCc9UvnJtJPeFJEs+T7UOGXBKeQAaB8vbELns3/5GMj
	UY9434fYElh8VkWAnaYMFrREpcO6qICmn1zENp2U0NHlkbxt9Z+nGSiDVrJmvh0t
	+FM6jDDNI+hqYGdRjO5LkT0ck=
Received: from 163.com (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgD3F+yvYolpOQZEQw--.25673S6;
	Mon, 09 Feb 2026 12:29:37 +0800 (CST)
From: Zhiquan Li <zhiquan_li@163.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiquan_li@163.com
Subject: [PATCH RESEND 4/5] KVM: x86: selftests: Allow the PMU event filter test for Hygon
Date: Mon,  9 Feb 2026 12:13:04 +0800
Message-ID: <20260209041305.64906-5-zhiquan_li@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260209041305.64906-1-zhiquan_li@163.com>
References: <20260209041305.64906-1-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgD3F+yvYolpOQZEQw--.25673S6
X-Coremail-Antispam: 1Uf129KBjvJXoWxJr4xtF4kWFyfKw4DJry3XFb_yoW8CF45pF
	yruw1avF48KFnxA3W8G34kWr4fAw1kWF4kt3sIgry8Zr1UJw1Iqr42ka43ta1YkFWFqw1Y
	ya47tFy5ua4UKaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziDPEDUUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbC6hGBammJYrE9WgAA3E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70568-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 0625510B8ED
X-Rspamd-Action: no action

At present, the PMU event filter test is only available for Intel and
AMD architecture conditionally, but it is applicable for Hygon
architecture as well.

Since all known Hygon processors can re-use the test cases, so it isn't
necessary to create a wrapper like other architectures, using the
"host_cpu_is_hygon" variable should be enough.

Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
---
 tools/testing/selftests/kvm/x86/pmu_event_filter_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
index 1c5b7611db24..e6badd9a2a2a 100644
--- a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
@@ -842,14 +842,14 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_MASKED_EVENTS));
 
-	TEST_REQUIRE(use_intel_pmu() || use_amd_pmu());
+	TEST_REQUIRE(use_intel_pmu() || use_amd_pmu() || host_cpu_is_hygon);
 	guest_code = use_intel_pmu() ? intel_guest_code : amd_guest_code;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	TEST_REQUIRE(sanity_check_pmu(vcpu));
 
-	if (use_amd_pmu())
+	if (use_amd_pmu() || host_cpu_is_hygon)
 		test_amd_deny_list(vcpu);
 
 	test_without_filter(vcpu);
@@ -862,7 +862,7 @@ int main(int argc, char *argv[])
 	    supports_event_mem_inst_retired() &&
 	    kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS) >= 3)
 		vcpu2 = vm_vcpu_add(vm, 2, intel_masked_events_guest_code);
-	else if (use_amd_pmu())
+	else if (use_amd_pmu() || host_cpu_is_hygon)
 		vcpu2 = vm_vcpu_add(vm, 2, amd_masked_events_guest_code);
 
 	if (vcpu2)
-- 
2.43.0


