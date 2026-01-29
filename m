Return-Path: <kvm+bounces-69499-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SKXLN5nDemk3+QEAu9opvQ
	(envelope-from <kvm+bounces-69499-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 03:19:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B34FAB148
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 03:19:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60B683025294
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2034035581D;
	Thu, 29 Jan 2026 02:18:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7EA5190473;
	Thu, 29 Jan 2026 02:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769653129; cv=none; b=YrbjU6y/gwHhE0YnQ4q4itoAmvtaVHqAiNYLDChPmH5bGR/v0iM0VB31MhPziRYa+K+QhcScCbEgkfQN8HL/ZYok9h9IMiv0GX+qiu4cyqFvlZgdiMSANj4CgE9nlTIWVGg3BkAPgabhppQ3z6WcnoJjmczyQZF8G0zPNsvc8fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769653129; c=relaxed/simple;
	bh=imWLegyaJny/1vo5iBqEUMVnSnATp/GFw0mOfGqOTBs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=alB6nY5PgV/C1NydPYXh3HWc5wkjSTI+NxznaHAlodqHWpdKP334zcDknvahvAN8odJEiUaO7CKC7BivS548jo/r61Hs1/qWy3AqLt6ToaXt2J0F7ZhC0j52nJeQb+1MFQ9//9k7vYnQ3HVFNfcXwHdYoaXaIzV/LbJBaxDFZ5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx68KBw3ppNcUNAA--.44781S3;
	Thu, 29 Jan 2026 10:18:41 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxbcKAw3pp0504AA--.40872S2;
	Thu, 29 Jan 2026 10:18:41 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: LoongArch: selftests: Add steal time test case
Date: Thu, 29 Jan 2026 10:18:39 +0800
Message-Id: <20260129021839.3674879-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxbcKAw3pp0504AA--.40872S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	TAGGED_FROM(0.00)[bounces-69499-lists,kvm=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: 6B34FAB148
X-Rspamd-Action: no action

LoongArch KVM supports steal time accounting now, here add steal time
test case on LoongArch.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 tools/testing/selftests/kvm/Makefile.kvm |  1 +
 tools/testing/selftests/kvm/steal_time.c | 85 ++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index ba5c2b643efa..a18c00f1a4fa 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -228,6 +228,7 @@ TEST_GEN_PROGS_loongarch += kvm_page_table_test
 TEST_GEN_PROGS_loongarch += memslot_modification_stress_test
 TEST_GEN_PROGS_loongarch += memslot_perf_test
 TEST_GEN_PROGS_loongarch += set_memory_region_test
+TEST_GEN_PROGS_loongarch += steal_time
 
 SPLIT_TESTS += arch_timer
 SPLIT_TESTS += get-reg-list
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 8edc1fca345b..ee13e8973c45 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -301,6 +301,91 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 	pr_info("\n");
 }
 
+#elif defined(__loongarch__)
+/* steal_time must have 64-byte alignment */
+#define STEAL_TIME_SIZE		((sizeof(struct kvm_steal_time) + 63) & ~63)
+#define KVM_STEAL_PHYS_VALID	BIT_ULL(0)
+
+struct kvm_steal_time {
+	__u64 steal;
+	__u32 version;
+	__u32 flags;
+	__u32 pad[12];
+};
+
+static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
+{
+	int err;
+	uint64_t val;
+	struct kvm_device_attr attr = {
+		.group = KVM_LOONGARCH_VCPU_CPUCFG,
+		.attr = CPUCFG_KVM_FEATURE,
+		.addr = (uint64_t)&val,
+	};
+
+	err = __vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &attr);
+	if (err)
+		return false;
+
+	err = __vcpu_ioctl(vcpu, KVM_GET_DEVICE_ATTR, &attr);
+	if (err)
+		return false;
+
+	return val & BIT(KVM_FEATURE_STEAL_TIME);
+}
+
+static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
+{
+	struct kvm_vm *vm = vcpu->vm;
+	uint64_t st_gpa;
+	int err;
+	struct kvm_device_attr attr = {
+		.group = KVM_LOONGARCH_VCPU_PVTIME_CTRL,
+		.attr = KVM_LOONGARCH_VCPU_PVTIME_GPA,
+		.addr = (uint64_t)&st_gpa,
+	};
+
+	/* ST_GPA_BASE is identity mapped */
+	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
+	sync_global_to_guest(vm, st_gva[i]);
+
+	err = __vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &attr);
+	TEST_ASSERT(err == 0, "No PV stealtime Feature");
+
+	st_gpa = (unsigned long)st_gva[i] | KVM_STEAL_PHYS_VALID;
+	err = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &attr);
+	TEST_ASSERT(err == 0, "Fail to set PV stealtime GPA");
+}
+
+static void guest_code(int cpu)
+{
+	struct kvm_steal_time *st = st_gva[cpu];
+	uint32_t version;
+
+	memset(st, 0, sizeof(*st));
+	GUEST_SYNC(0);
+
+	GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
+	WRITE_ONCE(guest_stolen_time[cpu], st->steal);
+	version = READ_ONCE(st->version);
+	GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
+	GUEST_SYNC(1);
+
+	GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
+	GUEST_ASSERT(version < READ_ONCE(st->version));
+	WRITE_ONCE(guest_stolen_time[cpu], st->steal);
+	GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
+	GUEST_DONE();
+}
+
+static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
+{
+	struct kvm_steal_time *st = addr_gva2hva(vm, (ulong)st_gva[vcpu_idx]);
+
+	ksft_print_msg("VCPU%d:\n", vcpu_idx);
+	ksft_print_msg("    steal:     %lld\n", st->steal);
+	ksft_print_msg("    version:   %d\n", st->version);
+}
 #endif
 
 static void *do_steal_time(void *arg)

base-commit: 8dfce8991b95d8625d0a1d2896e42f93b9d7f68d
-- 
2.39.3


