Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19820383237
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239391AbhEQOqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:46:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59768 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239966AbhEQOlE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 10:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621262386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lKQftPj3Z5ZtmkJxYxKgI7TzaslR2+NzJjnxrqZSNLo=;
        b=A4Fa0kgq7OWXK7c3ERsgn/48VhQh85juS0fVjkUrHAT3V4d5gCzbQWX+ZSmYX8ha0ZeHZ5
        8PFrnO1Rco0QjAbJMLYFPDQ0Rjx3uaXpBmtqfvVB+Tclk2/gZQygBiuFb3DXBLmPnkhEQ5
        FRh8/BRXqd00+J7ML6goVJ/3v5d4WFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-pEykzksvPta1ZCfCF0rKiw-1; Mon, 17 May 2021 10:39:44 -0400
X-MC-Unique: pEykzksvPta1ZCfCF0rKiw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 244BD1020C54;
        Mon, 17 May 2021 14:39:21 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8E685DDAD;
        Mon, 17 May 2021 14:39:19 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 10/10] arm/arm64: psci: Don't assume method is hvc
Date:   Mon, 17 May 2021 16:39:00 +0200
Message-Id: <20210517143900.747013-11-drjones@redhat.com>
In-Reply-To: <20210517143900.747013-1-drjones@redhat.com>
References: <20210517143900.747013-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The method can be smc in addition to hvc, and it will be when running
on bare metal. Additionally, we move the invocations to assembly so
we don't have to rely on compiler assumptions. We also fix the
prototype of psci_invoke. function_id should be an unsigned int, not
an unsigned long.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart.S       | 22 ++++++++++++++++++++++
 arm/cstart64.S     | 22 ++++++++++++++++++++++
 arm/selftest.c     | 34 +++++++---------------------------
 lib/arm/asm/psci.h | 10 ++++++++--
 lib/arm/psci.c     | 35 +++++++++++++++++++++++++++--------
 lib/arm/setup.c    |  2 ++
 6 files changed, 88 insertions(+), 37 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 446966de350d..2401d92cdadc 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -95,6 +95,28 @@ start:
 
 .text
 
+/*
+ * psci_invoke_hvc / psci_invoke_smc
+ *
+ * Inputs:
+ *   r0 -- function_id
+ *   r1 -- arg0
+ *   r2 -- arg1
+ *   r3 -- arg2
+ *
+ * Outputs:
+ *   r0 -- return code
+ */
+.globl psci_invoke_hvc
+psci_invoke_hvc:
+	hvc	#0
+	mov	pc, lr
+
+.globl psci_invoke_smc
+psci_invoke_smc:
+	smc	#0
+	mov	pc, lr
+
 enable_vfp:
 	/* Enable full access to CP10 and CP11: */
 	mov	r0, #(3 << 22 | 3 << 20)
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 42ba3a3ca249..e4ab7d06251e 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -109,6 +109,28 @@ start:
 
 .text
 
+/*
+ * psci_invoke_hvc / psci_invoke_smc
+ *
+ * Inputs:
+ *   w0 -- function_id
+ *   x1 -- arg0
+ *   x2 -- arg1
+ *   x3 -- arg2
+ *
+ * Outputs:
+ *   x0 -- return code
+ */
+.globl psci_invoke_hvc
+psci_invoke_hvc:
+	hvc	#0
+	ret
+
+.globl psci_invoke_smc
+psci_invoke_smc:
+	smc	#0
+	ret
+
 get_mmu_off:
 	adrp	x0, auxinfo
 	ldr	x0, [x0, :lo12:auxinfo + 8]
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
index 7b956bf5987d..cf03449ba665 100644
--- a/lib/arm/asm/psci.h
+++ b/lib/arm/asm/psci.h
@@ -3,8 +3,14 @@
 #include <libcflat.h>
 #include <linux/psci.h>
 
-extern int psci_invoke(unsigned long function_id, unsigned long arg0,
-		       unsigned long arg1, unsigned long arg2);
+typedef int (*psci_invoke_fn)(unsigned int function_id, unsigned long arg0,
+			      unsigned long arg1, unsigned long arg2);
+extern psci_invoke_fn psci_invoke;
+extern int psci_invoke_hvc(unsigned int function_id, unsigned long arg0,
+			   unsigned long arg1, unsigned long arg2);
+extern int psci_invoke_smc(unsigned int function_id, unsigned long arg0,
+			   unsigned long arg1, unsigned long arg2);
+extern void psci_set_conduit(void);
 extern int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);
 extern void psci_system_reset(void);
 extern int cpu_psci_cpu_boot(unsigned int cpu);
diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index 936c83948b6a..9c031a122e9b 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -6,22 +6,21 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#include <devicetree.h>
 #include <asm/psci.h>
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/smp.h>
 
-__attribute__((noinline))
-int psci_invoke(unsigned long function_id, unsigned long arg0,
-		unsigned long arg1, unsigned long arg2)
+static int psci_invoke_none(unsigned int function_id, unsigned long arg0,
+			    unsigned long arg1, unsigned long arg2)
 {
-	asm volatile(
-		"hvc #0"
-	: "+r" (function_id)
-	: "r" (arg0), "r" (arg1), "r" (arg2));
-	return function_id;
+	printf("No PSCI method configured! Can't invoke...\n");
+	return PSCI_RET_NOT_PRESENT;
 }
 
+psci_invoke_fn psci_invoke = psci_invoke_none;
+
 int psci_cpu_on(unsigned long cpuid, unsigned long entry_point)
 {
 #ifdef __arm__
@@ -56,3 +55,23 @@ void psci_system_off(void)
 	int err = psci_invoke(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
 	printf("CPU%d unable to do system off (error = %d)\n", smp_processor_id(), err);
 }
+
+void psci_set_conduit(void)
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
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 86f054304baf..bcdf0d78c2e2 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -25,6 +25,7 @@
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
+#include <asm/psci.h>
 
 #include "io.h"
 
@@ -266,6 +267,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	mem_regions_add_assumed();
 	mem_init(PAGE_ALIGN((unsigned long)freemem));
 
+	psci_set_conduit();
 	cpu_init();
 
 	/* cpu_init must be called before thread_info_init */
-- 
2.30.2

