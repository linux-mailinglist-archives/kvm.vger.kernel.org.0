Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4513A1674
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhFIOEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:04:50 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:40488 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237249AbhFIOEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 10:04:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1623247376; x=1654783376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=w/+ATr3PA9Lz9pE8K2OP4exA9zAHI/2G5jEfGrnBPnQ=;
  b=kAhKSUVq9ADVwUYQZnOAySmpIbJYjjqql3iqN/02MAJJyF9dxIeMv+wJ
   rG5hZ0+PNXaZ0HAUm8/FHvn9c/peft3rApY8XAYIou6+vESzGhYsbEdmF
   oe6ZZlz/uktb0gDVX5CatxZU3dXWRaIXKPpkRgtgJq8soduom4TeMTsup
   Q=;
X-IronPort-AV: E=Sophos;i="5.83,261,1616457600"; 
   d="scan'208";a="114733038"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 09 Jun 2021 14:02:48 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 683C2A064C;
        Wed,  9 Jun 2021 14:02:47 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.17) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 9 Jun 2021 14:02:43 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>,
        Siddharth Chandrasekaran <sidcha@amazon.de>
Subject: [kvm-unit-tests PATCH] x86: Add hyper-v overlay page tests
Date:   Wed, 9 Jun 2021 16:02:16 +0200
Message-ID: <20210609140217.1514-2-sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210609140217.1514-1-sidcha@amazon.de>
References: <20210609140217.1514-1-sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.17]
X-ClientProxiedBy: EX13D23UWC003.ant.amazon.com (10.43.162.81) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch series [1] starts treating hypercall code page as an overlay page
(along with the existing synic event and message pages). Add KVM unit
tests to make sure the underlying page contents are intact with various
overlay workflows.

[1]: https://www.spinics.net/lists/kvm/msg244569.html

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 x86/Makefile.common  |  3 ++
 x86/hyperv.h         |  1 +
 x86/hyperv_overlay.c | 96 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg    |  5 +++
 4 files changed, 105 insertions(+)
 create mode 100644 x86/hyperv_overlay.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 55f7f28..85dc427 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -62,6 +62,7 @@ tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
                $(TEST_DIR)/init.flat $(TEST_DIR)/smap.flat \
                $(TEST_DIR)/hyperv_synic.flat $(TEST_DIR)/hyperv_stimer.flat \
                $(TEST_DIR)/hyperv_connections.flat \
+               $(TEST_DIR)/hyperv_overlay.flat \
                $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat
 
 test_cases: $(tests-common) $(tests)
@@ -82,6 +83,8 @@ $(TEST_DIR)/hyperv_stimer.elf: $(TEST_DIR)/hyperv.o
 
 $(TEST_DIR)/hyperv_connections.elf: $(TEST_DIR)/hyperv.o
 
+$(TEST_DIR)/hyperv_overlay.elf: $(TEST_DIR)/hyperv.o
+
 arch_clean:
 	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
 	$(TEST_DIR)/.*.d lib/x86/.*.d \
diff --git a/x86/hyperv.h b/x86/hyperv.h
index e135221..6f69c29 100644
--- a/x86/hyperv.h
+++ b/x86/hyperv.h
@@ -52,6 +52,7 @@
 #define HV_X64_MSR_STIMER3_CONFIG               0x400000B6
 #define HV_X64_MSR_STIMER3_COUNT                0x400000B7
 
+#define HV_OVERLAY_ENABLE                       (1ULL << 0)
 #define HV_SYNIC_CONTROL_ENABLE                 (1ULL << 0)
 #define HV_SYNIC_SIMP_ENABLE                    (1ULL << 0)
 #define HV_SYNIC_SIEFP_ENABLE                   (1ULL << 0)
diff --git a/x86/hyperv_overlay.c b/x86/hyperv_overlay.c
new file mode 100644
index 0000000..4472f64
--- /dev/null
+++ b/x86/hyperv_overlay.c
@@ -0,0 +1,96 @@
+#include "vm.h"
+#include "hyperv.h"
+#include "alloc_page.h"
+
+/**
+ * Test if the underlying GPA contents are preserved when an
+ * overlay is mounted there.
+ */
+static int test_underlay_intact(void *page, u64 msr)
+{
+	int i;
+	u64 gpa = (u64)virt_to_phys(page);
+
+	memset(page, 0xAA, PAGE_SIZE);
+
+	/* Enable overlay */
+	wrmsr(msr, gpa | HV_OVERLAY_ENABLE);
+
+	/* Write to overlay */
+	memset(page, 0x55, PAGE_SIZE);
+
+	/* Disable overlay */
+	wrmsr(msr, 0);
+
+	for (i = 0; i < PAGE_SIZE; i++)
+		if (((u8 *)page)[i] != 0xAA)
+			return -1;
+
+	return 0;
+}
+
+/**
+ * Test if Guest OS ID reset unmounts hypercall overlay and
+ * exposes the underlying page.
+ */
+static int test_guest_os_id_reset(void *page)
+{
+	int i;
+	u64 gpa = (u64)virt_to_phys(page);
+
+	memset(page, 0xAA, PAGE_SIZE);
+
+	/* Enable overlay */
+	wrmsr(HV_X64_MSR_HYPERCALL, gpa | HV_OVERLAY_ENABLE);
+
+	/* Write to overlay */
+	memset(page, 0x55, PAGE_SIZE);
+
+	/* Guest OS ID reset forces overlay unmap */
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, 0);
+
+	for (i = 0; i < PAGE_SIZE; i++)
+		if (((u8 *)page)[i] != 0xAA)
+			return -1;
+
+	return 0;
+}
+
+int main(int ac, char **av)
+{
+	int rc;
+	void *page;
+	u64 guestid = (0x8f00ull << 48);
+
+	setup_vm();
+
+	page = alloc_page();
+	if (!page)
+		report_abort("Failed to allocate page for overlay tests");
+
+	rc = test_underlay_intact(page, HV_X64_MSR_HYPERCALL);
+	report(rc != 0, "Hypercall page before guest OS ID write");
+
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, guestid);
+	rc = test_underlay_intact(page, HV_X64_MSR_HYPERCALL);
+	report(rc == 0, "Hypercall page after guest OS ID write");
+
+	rc = test_guest_os_id_reset(page);
+	report(rc == 0, "Guest OS ID reset removes hcall overlay");
+
+	if (!synic_supported()) {
+		report_skip("Hyper-V SynIC is not supported");
+		goto summary;
+	}
+
+	rc = test_underlay_intact(page, HV_X64_MSR_SIMP);
+	report(rc == 0, "SynIC message page");
+
+	rc = test_underlay_intact(page, HV_X64_MSR_SIEFP);
+	report(rc == 0, "SynIC event page");
+
+	free_page(page);
+
+summary:
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 0698d15..330a829 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -372,6 +372,11 @@ arch = x86_64
 groups = hyperv
 check = /sys/devices/system/clocksource/clocksource0/current_clocksource=tsc
 
+[hyperv_overlay]
+file = hyperv_overlay.flat
+extra_params = -cpu kvm64,hv_vpindex,hv_synic
+groups = hyperv
+
 [intel_iommu]
 file = intel-iommu.flat
 arch = x86_64
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



