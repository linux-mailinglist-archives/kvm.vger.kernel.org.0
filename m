Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E35365FF7
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 21:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhDTTCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 15:02:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233617AbhDTTCJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 15:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618945292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f7JW/M2+fDLcAQIA4iMgswiOTLE6jzXmC9U9LbaJm8o=;
        b=X1Yw8Mn9qbjJQHTLAO9TZGgYARyMD97EFtGLPMiD0Kso2I3kE4umR7YGPYtVS8Phc6lNzP
        AK9wCJGrXdPfG80jXpb5uOcONWWU3+0N9urNQhHBgYOGCbWwKaf6u+A+XpakzEweMC/RlQ
        mAfdEmGXz4ixr2+UEadMDV8fG7jmckg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-cpWlKcUHMCS60-nqe_HCdw-1; Tue, 20 Apr 2021 15:01:30 -0400
X-MC-Unique: cpWlKcUHMCS60-nqe_HCdw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 753BC801F98;
        Tue, 20 Apr 2021 19:01:29 +0000 (UTC)
Received: from gator.home (unknown [10.40.195.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F47119726;
        Tue, 20 Apr 2021 19:01:27 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests v2 8/8] arm/arm64: psci: don't assume method is hvc
Date:   Tue, 20 Apr 2021 21:00:02 +0200
Message-Id: <20210420190002.383444-9-drjones@redhat.com>
In-Reply-To: <20210420190002.383444-1-drjones@redhat.com>
References: <20210420190002.383444-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The method can also be smc and it will be when running on bare metal.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart.S       | 22 ++++++++++++++++++++++
 arm/cstart64.S     | 22 ++++++++++++++++++++++
 arm/selftest.c     | 34 +++++++---------------------------
 lib/arm/asm/psci.h | 10 ++++++++--
 lib/arm/psci.c     | 37 +++++++++++++++++++++++++++++--------
 lib/arm/setup.c    |  2 ++
 6 files changed, 90 insertions(+), 37 deletions(-)

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
index 42ba3a3ca249..7610e28f06dd 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -109,6 +109,28 @@ start:
 
 .text
 
+/*
+ * psci_invoke_hvc / psci_invoke_smc
+ *
+ * Inputs:
+ *   x0 -- function_id
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
index 7b956bf5987d..2820c0a3afc7 100644
--- a/lib/arm/asm/psci.h
+++ b/lib/arm/asm/psci.h
@@ -3,8 +3,14 @@
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
+extern void psci_set_conduit(void);
 extern int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);
 extern void psci_system_reset(void);
 extern int cpu_psci_cpu_boot(unsigned int cpu);
diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index 936c83948b6a..168786dcf792 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -6,22 +6,23 @@
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
+extern void halt(void);
+
+static int psci_invoke_none(unsigned long function_id, unsigned long arg0,
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
@@ -56,3 +57,23 @@ void psci_system_off(void)
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
index a5ebec3c5a12..07d52d2e5fe6 100644
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

