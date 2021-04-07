Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0FD3574B6
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 20:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355524AbhDGTAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 15:00:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46461 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355518AbhDGTAG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 15:00:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617821996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fq2z9Cciylm7lQWg9/xvcPW8IugFYoqpdT9buVnJ92k=;
        b=dlNDRmd/xfGozyYXE4WCgR1FduiAOOX83GhWwmmHLUQdMACZTmjaJDGtNfSn3g8klY6Y+I
        Gz1UQcEg2pGOXhji1+n9f5gLEKS44FzEj6nMhYGhmW18qB6Osw4QMYjoR/afjWE20C7E7t
        3hw9bUS13ZhK1jaT4lbujHhyBzNhZvE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-9o5buXgANw-Qg_Dcm9DpQg-1; Wed, 07 Apr 2021 14:59:55 -0400
X-MC-Unique: 9o5buXgANw-Qg_Dcm9DpQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C5761006C80;
        Wed,  7 Apr 2021 18:59:54 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A22F660C5C;
        Wed,  7 Apr 2021 18:59:51 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests 8/8] arm/arm64: psci: don't assume method is hvc
Date:   Wed,  7 Apr 2021 20:59:18 +0200
Message-Id: <20210407185918.371983-9-drjones@redhat.com>
In-Reply-To: <20210407185918.371983-1-drjones@redhat.com>
References: <20210407185918.371983-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The method can also be smc and it will be when running on bare metal.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/selftest.c     | 34 +++++++---------------------------
 lib/arm/asm/psci.h |  9 +++++++--
 lib/arm/psci.c     | 17 +++++++++++++++--
 lib/arm/setup.c    | 22 ++++++++++++++++++++++
 4 files changed, 51 insertions(+), 31 deletions(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index 4495b161cdd5..9f459ed3d571 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -400,33 +400,13 @@ static void check_vectors(void *arg __unused)
 	exit(report_summary());
 }
 
-static bool psci_check(void)
+static void psci_print(void)
 {
-	const struct fdt_property *method;
-	int node, len, ver;
-
-	node = fdt_node_offset_by_compatible(dt_fdt(), -1, "arm,psci-0.2");
-	if (node < 0) {
-		printf("PSCI v0.2 compatibility required\n");
-		return false;
-	}
-
-	method = fdt_get_property(dt_fdt(), node, "method", &len);
-	if (method == NULL) {
-		printf("bad psci device tree node\n");
-		return false;
-	}
-
-	if (len < 4 || strcmp(method->data, "hvc") != 0) {
-		printf("psci method must be hvc\n");
-		return false;
-	}
-
-	ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
-	printf("PSCI version %d.%d\n", PSCI_VERSION_MAJOR(ver),
-				       PSCI_VERSION_MINOR(ver));
-
-	return true;
+	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
+	report_info("PSCI version: %d.%d", PSCI_VERSION_MAJOR(ver),
+					  PSCI_VERSION_MINOR(ver));
+	report_info("PSCI method: %s", psci_invoke == psci_invoke_hvc ?
+				       "hvc" : "smc");
 }
 
 static void cpu_report(void *data __unused)
@@ -465,7 +445,7 @@ int main(int argc, char **argv)
 
 	} else if (strcmp(argv[1], "smp") == 0) {
 
-		report(psci_check(), "PSCI version");
+		psci_print();
 		on_cpus(cpu_report, NULL);
 		while (!cpumask_full(&ready))
 			cpu_relax();
diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
index 7b956bf5987d..e385ce27f5d1 100644
--- a/lib/arm/asm/psci.h
+++ b/lib/arm/asm/psci.h
@@ -3,8 +3,13 @@
 #include <libcflat.h>
 #include <linux/psci.h>
 
-extern int psci_invoke(unsigned long function_id, unsigned long arg0,
-		       unsigned long arg1, unsigned long arg2);
+typedef int (*psci_invoke_fn)(unsigned long function_id, unsigned long arg0,
+			      unsigned long arg1, unsigned long arg2);
+extern psci_invoke_fn psci_invoke;
+extern int psci_invoke_hvc(unsigned long function_id, unsigned long arg0,
+			   unsigned long arg1, unsigned long arg2);
+extern int psci_invoke_smc(unsigned long function_id, unsigned long arg0,
+			   unsigned long arg1, unsigned long arg2);
 extern int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);
 extern void psci_system_reset(void);
 extern int cpu_psci_cpu_boot(unsigned int cpu);
diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index 936c83948b6a..46300f30822c 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -11,9 +11,11 @@
 #include <asm/page.h>
 #include <asm/smp.h>
 
+psci_invoke_fn psci_invoke;
+
 __attribute__((noinline))
-int psci_invoke(unsigned long function_id, unsigned long arg0,
-		unsigned long arg1, unsigned long arg2)
+int psci_invoke_hvc(unsigned long function_id, unsigned long arg0,
+		    unsigned long arg1, unsigned long arg2)
 {
 	asm volatile(
 		"hvc #0"
@@ -22,6 +24,17 @@ int psci_invoke(unsigned long function_id, unsigned long arg0,
 	return function_id;
 }
 
+__attribute__((noinline))
+int psci_invoke_smc(unsigned long function_id, unsigned long arg0,
+		    unsigned long arg1, unsigned long arg2)
+{
+	asm volatile(
+		"smc #0"
+	: "+r" (function_id)
+	: "r" (arg0), "r" (arg1), "r" (arg2));
+	return function_id;
+}
+
 int psci_cpu_on(unsigned long cpuid, unsigned long entry_point)
 {
 #ifdef __arm__
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 5cda2d919d2b..e595a9e5a167 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -25,6 +25,7 @@
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
+#include <asm/psci.h>
 
 #include "io.h"
 
@@ -55,6 +56,26 @@ int mpidr_to_cpu(uint64_t mpidr)
 	return -1;
 }
 
+static void psci_set_conduit(void)
+{
+	const void *fdt = dt_fdt();
+	const struct fdt_property *method;
+	int node, len;
+
+	node = fdt_node_offset_by_compatible(fdt, -1, "arm,psci-0.2");
+	assert_msg(node >= 0, "PSCI v0.2 compatibility required");
+
+	method = fdt_get_property(fdt, node, "method", &len);
+	assert(method != NULL && len == 4);
+
+	if (strcmp(method->data, "hvc") == 0)
+		psci_invoke = psci_invoke_hvc;
+	else if (strcmp(method->data, "smc") == 0)
+		psci_invoke = psci_invoke_smc;
+	else
+		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
+}
+
 static void cpu_set(int fdtnode __unused, u64 regval, void *info __unused)
 {
 	int cpu = nr_cpus++;
@@ -259,6 +280,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	mem_regions_add_assumed();
 	mem_init(PAGE_ALIGN((unsigned long)freemem));
 
+	psci_set_conduit();
 	cpu_init();
 
 	/* cpu_init must be called before thread_info_init */
-- 
2.26.3

