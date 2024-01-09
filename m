Return-Path: <kvm+bounces-5884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D33A8287CB
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 15:12:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 187381F24E4B
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 14:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2B839FE3;
	Tue,  9 Jan 2024 14:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fMGogbIh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459DA39AC4
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 14:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704809488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e8e5dGjcFFUnzEKI3zb4LdS0a99YnvNh3UNoPZfhRwo=;
	b=fMGogbIh5JtADm718UnApmHCXunXDY2gPA8gJBSBvAscaUTnGF/k7jvCrUQ+eVZz8D7s1J
	NhZyWrpkxK0SvZHEEkSJKAhjTtqQM4dTsw+MVOmDCH/3TaXPuzEB1leaTmm+goD9pyjdTq
	z4qlDFoSHvcm/lTpAZyGdPa0UyQP7fI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-XKcBf3IMMg6UFizvp1kOgQ-1; Tue, 09 Jan 2024 09:11:24 -0500
X-MC-Unique: XKcBf3IMMg6UFizvp1kOgQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CF05102F223;
	Tue,  9 Jan 2024 14:11:24 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.90])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8057551E3;
	Tue,  9 Jan 2024 14:11:23 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oupton@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] KVM: selftests: Generalize check_clocksource() from kvm_clock_test
Date: Tue,  9 Jan 2024 15:11:17 +0100
Message-ID: <20240109141121.1619463-2-vkuznets@redhat.com>
In-Reply-To: <20240109141121.1619463-1-vkuznets@redhat.com>
References: <20240109141121.1619463-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Several existing x86 selftests need to check that the underlying system
clocksource is TSC or based on TSC but every test implements its own
check. As a first step towards unification, extract check_clocksource()
from kvm_clock_test and split it into two functions: arch-neutral
'sys_get_cur_clocksource()' and x86-specific 'sys_clocksource_is_tsc()'.
Fix a couple of pre-existing issues in kvm_clock_test: memory leakage in
check_clocksource() and using TEST_ASSERT() instead of TEST_REQUIRE().
The change also makes the test fail when system clocksource can't be read
from sysfs.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../testing/selftests/kvm/include/test_util.h |  2 +
 .../selftests/kvm/include/x86_64/processor.h  |  2 +
 tools/testing/selftests/kvm/lib/test_util.c   | 25 ++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 13 +++++++
 .../selftests/kvm/x86_64/kvm_clock_test.c     | 38 +------------------
 5 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 71a41fa924b7..50a5e31ba8da 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -195,4 +195,6 @@ __printf(3, 4) int guest_snprintf(char *buf, int n, const char *fmt, ...);
 
 char *strdup_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2), nonnull(1)));
 
+char *sys_get_cur_clocksource(void);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index a84863503fcb..01eec72e0d3e 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1271,4 +1271,6 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
 
+bool sys_clocksource_is_tsc(void);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 5d7f28b02d73..b8cb20cf61e9 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -392,3 +392,28 @@ char *strdup_printf(const char *fmt, ...)
 
 	return str;
 }
+
+#define CLOCKSOURCE_PATH "/sys/devices/system/clocksource/clocksource0/current_clocksource"
+
+char *sys_get_cur_clocksource(void)
+{
+	char *clk_name;
+	struct stat st;
+	FILE *fp;
+
+	fp = fopen(CLOCKSOURCE_PATH, "r");
+	TEST_ASSERT(fp, "failed to open clocksource file, errno: %d", errno);
+
+	TEST_ASSERT(!fstat(fileno(fp), &st), "failed to stat clocksource file, errno: %d",
+		    errno);
+
+	clk_name = malloc(st.st_size);
+	TEST_ASSERT(clk_name, "failed to allocate buffer to read file\n");
+
+	TEST_ASSERT(fgets(clk_name, st.st_size, fp), "failed to read clocksource file: %d",
+		    ferror(fp));
+
+	fclose(fp);
+
+	return clk_name;
+}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d8288374078e..b0c64667803d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1299,3 +1299,16 @@ void kvm_selftest_arch_init(void)
 	host_cpu_is_intel = this_cpu_is_intel();
 	host_cpu_is_amd = this_cpu_is_amd();
 }
+
+bool sys_clocksource_is_tsc(void)
+{
+	char *clk_name = sys_get_cur_clocksource();
+	bool ret = false;
+
+	if (!strcmp(clk_name, "tsc\n"))
+		ret = true;
+
+	free(clk_name);
+
+	return ret;
+}
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
index 1778704360a6..9deee8556b5c 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
@@ -132,42 +132,6 @@ static void enter_guest(struct kvm_vcpu *vcpu)
 	}
 }
 
-#define CLOCKSOURCE_PATH "/sys/devices/system/clocksource/clocksource0/current_clocksource"
-
-static void check_clocksource(void)
-{
-	char *clk_name;
-	struct stat st;
-	FILE *fp;
-
-	fp = fopen(CLOCKSOURCE_PATH, "r");
-	if (!fp) {
-		pr_info("failed to open clocksource file: %d; assuming TSC.\n",
-			errno);
-		return;
-	}
-
-	if (fstat(fileno(fp), &st)) {
-		pr_info("failed to stat clocksource file: %d; assuming TSC.\n",
-			errno);
-		goto out;
-	}
-
-	clk_name = malloc(st.st_size);
-	TEST_ASSERT(clk_name, "failed to allocate buffer to read file\n");
-
-	if (!fgets(clk_name, st.st_size, fp)) {
-		pr_info("failed to read clocksource file: %d; assuming TSC.\n",
-			ferror(fp));
-		goto out;
-	}
-
-	TEST_ASSERT(!strncmp(clk_name, "tsc\n", st.st_size),
-		    "clocksource not supported: %s", clk_name);
-out:
-	fclose(fp);
-}
-
 int main(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -179,7 +143,7 @@ int main(void)
 	flags = kvm_check_cap(KVM_CAP_ADJUST_CLOCK);
 	TEST_REQUIRE(flags & KVM_CLOCK_REALTIME);
 
-	check_clocksource();
+	TEST_REQUIRE(sys_clocksource_is_tsc());
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
-- 
2.43.0


