Return-Path: <kvm+bounces-70572-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OJ5jAlNjiWla8AQAu9opvQ
	(envelope-from <kvm+bounces-70572-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:32:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B42A10B930
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 05:32:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B7163032F4E
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 04:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DABF27877F;
	Mon,  9 Feb 2026 04:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="QBzsauYQ"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66B6126F3B;
	Mon,  9 Feb 2026 04:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770611420; cv=none; b=LEcCIbaW/QFkYbjtc/ThWRYaY3XqTVwlRt9lt8cwn/lq5ORVOd4l2/8CmdKikC/NIcBqlVbUyY7LJhym7Dxoj/HHUcYBme2QtLgkqMd0kkp+878LwpBxMvfys32tM0Rr2SYpWi3v9/07PqAVtZ3nDw44UmsecLQz2TkxIr0WNtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770611420; c=relaxed/simple;
	bh=C52bEq3TH6+WHwZGbu1J0ND/tgmNrbDcmiG6ddcdr3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eh9RAK31nwBJW9S+2sskNMAnA3uciQP942DT5K6YM1Rf+vDmxVKcWgMJMyzhVviHZbKPrwn7x63+BqtUQpWAxwT7lOPxObn6q/VoHB22ZHMRPFmzvsuincSJ5vyO6q9bytrXVvvtU60byjFnBS+IqCyD8U37KTyu96SY5FAf2ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=QBzsauYQ; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=7Z
	X6gO4s1/g6DTK9BvrcJ2ewwGz0oC37XJnSwSguWaE=; b=QBzsauYQJaiYyPbJMB
	NxlyZSZRmrthq4RX9KNMLoKMJAiUF8RcuCNdZf6VQgIscDiJxdsWJCbAqv2Ovhts
	LHMgL+2lLmOzGm+b2F+7syFNuj2ZuLwWMgQAvq5wxS+e2Lq7eQGPIYoHS9LvsSa/
	dl+iPLSU31THRfS9ZlFPZmXP4=
Received: from 163.com (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgD3F+yvYolpOQZEQw--.25673S3;
	Mon, 09 Feb 2026 12:29:36 +0800 (CST)
From: Zhiquan Li <zhiquan_li@163.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiquan_li@163.com
Subject: [PATCH RESEND 1/5] KVM: x86: selftests: Add CPU vendor detection for Hygon
Date: Mon,  9 Feb 2026 12:13:01 +0800
Message-ID: <20260209041305.64906-2-zhiquan_li@163.com>
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
X-CM-TRANSID:PSgvCgD3F+yvYolpOQZEQw--.25673S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxWFW5Zw48Zr1xJF4kWr1fCrg_yoW5Jw45pF
	ykAr1rKF10gFnxta4xXr4ktryxWrZ7Wa10q3yUZry3Aa12yry7Xrs7Ka4jvrZI9FWrW3s8
	Zas7tF4YgFsrZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pi89N5UUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbC6hCBammJYrA9QgAA3c
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70572-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9B42A10B930
X-Rspamd-Action: no action

Currently some KVM selftests are failed on Hygon CPUs due to missing
vendor detection and edge-case handling specific to Hygon's
architecture.

Add CPU vendor detection for Hygon and add a global variable
"host_cpu_is_hygon" as the basic facility for the following fixes.

Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
---
 tools/testing/selftests/kvm/include/x86/processor.h | 6 ++++++
 tools/testing/selftests/kvm/lib/x86/processor.c     | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 57d62a425109..9ac18e0fca54 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -21,6 +21,7 @@
 
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
+extern bool host_cpu_is_hygon;
 extern uint64_t guest_tsc_khz;
 
 #ifndef MAX_NR_CPUID_ENTRIES
@@ -701,6 +702,11 @@ static inline bool this_cpu_is_amd(void)
 	return this_cpu_vendor_string_is("AuthenticAMD");
 }
 
+static inline bool this_cpu_is_hygon(void)
+{
+	return this_cpu_vendor_string_is("HygonGenuine");
+}
+
 static inline uint32_t __this_cpu_has(uint32_t function, uint32_t index,
 				      uint8_t reg, uint8_t lo, uint8_t hi)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 36104d27f3d9..bbd3336f22eb 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -21,6 +21,7 @@
 vm_vaddr_t exception_handlers;
 bool host_cpu_is_amd;
 bool host_cpu_is_intel;
+bool host_cpu_is_hygon;
 bool is_forced_emulation_enabled;
 uint64_t guest_tsc_khz;
 
@@ -671,6 +672,7 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm, unsigned int nr_vcpus)
 
 	sync_global_to_guest(vm, host_cpu_is_intel);
 	sync_global_to_guest(vm, host_cpu_is_amd);
+	sync_global_to_guest(vm, host_cpu_is_hygon);
 	sync_global_to_guest(vm, is_forced_emulation_enabled);
 	sync_global_to_guest(vm, pmu_errata_mask);
 
@@ -1303,6 +1305,7 @@ void kvm_selftest_arch_init(void)
 {
 	host_cpu_is_intel = this_cpu_is_intel();
 	host_cpu_is_amd = this_cpu_is_amd();
+	host_cpu_is_hygon = this_cpu_is_hygon();
 	is_forced_emulation_enabled = kvm_is_forced_emulation_enabled();
 
 	kvm_init_pmu_errata();
-- 
2.43.0


