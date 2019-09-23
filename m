Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F537BB670
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 16:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbfIWOQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 10:16:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28066 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728575AbfIWOQ0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Sep 2019 10:16:26 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8NEATNj054568
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 10:16:25 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v6x4g473f-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 10:16:20 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 23 Sep 2019 15:16:09 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 23 Sep 2019 15:16:05 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8NEFbJ930343512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 14:15:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3056A4051;
        Mon, 23 Sep 2019 14:16:04 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1A77A4040;
        Mon, 23 Sep 2019 14:16:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.36.175])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Sep 2019 14:16:03 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH] s390x: Add initial smp code
Date:   Mon, 23 Sep 2019 16:15:58 +0200
X-Mailer: git-send-email 2.17.2
In-Reply-To: <b60eee55-f013-411a-0e52-3f40a990b1c4@redhat.com>
References: <b60eee55-f013-411a-0e52-3f40a990b1c4@redhat.com>
X-TM-AS-GCONF: 00
x-cbid: 19092314-0008-0000-0000-00000319F784
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092314-0009-0000-0000-00004A38876B
Message-Id: <20190923141558.3032-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909230139
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add a rudimentary SMP library, which will scan for cpus and has
helper functions that manage the cpu state.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---

I left the setup code untouched, as I didn't want to indent too many
lines.

---
 lib/s390x/asm/arch_def.h |   8 ++
 lib/s390x/asm/sigp.h     |  28 ++++-
 lib/s390x/io.c           |   5 +-
 lib/s390x/sclp.h         |   1 +
 lib/s390x/smp.c          | 252 +++++++++++++++++++++++++++++++++++++++
 lib/s390x/smp.h          |  51 ++++++++
 s390x/Makefile           |   1 +
 s390x/cstart64.S         |   7 ++
 8 files changed, 347 insertions(+), 6 deletions(-)
 create mode 100644 lib/s390x/smp.c
 create mode 100644 lib/s390x/smp.h

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 5f8f45e..d5a7f51 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -157,6 +157,14 @@ struct cpuid {
 	uint64_t reserved : 15;
 };
 
+static inline unsigned short stap(void)
+{
+	unsigned short cpu_address;
+
+	asm volatile("stap %0" : "=Q" (cpu_address));
+	return cpu_address;
+}
+
 static inline int tprot(unsigned long addr)
 {
 	int cc;
diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
index fbd94fc..2d52313 100644
--- a/lib/s390x/asm/sigp.h
+++ b/lib/s390x/asm/sigp.h
@@ -46,14 +46,32 @@
 
 #ifndef __ASSEMBLER__
 
-static inline void sigp_stop(void)
+
+static inline int sigp(uint16_t addr, uint8_t order, unsigned long parm,
+		       uint32_t *status)
 {
-	register unsigned long status asm ("1") = 0;
-	register unsigned long cpu asm ("2") = 0;
+	register unsigned long reg1 asm ("1") = parm;
+	int cc;
 
 	asm volatile(
-		"	sigp %0,%1,0(%2)\n"
-		: "+d" (status)  : "d" (cpu), "d" (SIGP_STOP) : "cc");
+		"	sigp	%1,%2,0(%3)\n"
+		"	ipm	%0\n"
+		"	srl	%0,28\n"
+		: "=d" (cc), "+d" (reg1) : "d" (addr), "a" (order) : "cc");
+	if (status)
+		*status = reg1;
+	return cc;
+}
+
+static inline int sigp_retry(uint16_t addr, uint8_t order, unsigned long parm,
+			     uint32_t *status)
+{
+	int cc;
+
+	do {
+		cc = sigp(addr, order, parm, status);
+	} while (cc == 2);
+	return cc;
 }
 
 #endif /* __ASSEMBLER__ */
diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index becadfc..32f09b5 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -16,6 +16,7 @@
 #include <asm/facility.h>
 #include <asm/sigp.h>
 #include "sclp.h"
+#include "smp.h"
 
 extern char ipl_args[];
 uint8_t stfl_bytes[NR_STFL_BYTES] __attribute__((aligned(8)));
@@ -37,12 +38,14 @@ void setup(void)
 	setup_facilities();
 	sclp_console_setup();
 	sclp_memory_setup();
+	smp_setup();
 }
 
 void exit(int code)
 {
+	smp_teardown();
 	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
 	while (1) {
-		sigp_stop();
+		sigp(0, SIGP_STOP, 0, NULL);
 	}
 }
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 98c482a..4e69845 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -19,6 +19,7 @@
 #define SCLP_CMD_CODE_MASK                      0xffff00ff
 
 /* SCLP command codes */
+#define SCLP_READ_CPU_INFO			0x00010001
 #define SCLP_CMDW_READ_SCP_INFO                 0x00020001
 #define SCLP_CMDW_READ_SCP_INFO_FORCED          0x00120001
 #define SCLP_READ_STORAGE_ELEMENT_INFO          0x00040001
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
new file mode 100644
index 0000000..7602886
--- /dev/null
+++ b/lib/s390x/smp.c
@@ -0,0 +1,252 @@
+/*
+ * s390x smp
+ * Based on Linux's arch/s390/kernel/smp.c and
+ * arch/s390/include/asm/sigp.h
+ *
+ * Copyright (c) 2019 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+#include <libcflat.h>
+#include <asm/arch_def.h>
+#include <asm/sigp.h>
+#include <asm/page.h>
+#include <asm/barrier.h>
+#include <asm/spinlock.h>
+#include <asm/asm-offsets.h>
+
+#include <alloc.h>
+#include <alloc_page.h>
+
+#include "smp.h"
+#include "sclp.h"
+
+static char cpu_info_buffer[PAGE_SIZE] __attribute__((__aligned__(4096)));
+static struct cpu *cpus;
+static struct cpu *cpu0;
+static struct spinlock lock;
+
+extern void smp_cpu_setup_state(void);
+
+int smp_query_num_cpus(void)
+{
+	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
+	return info->nr_configured;
+}
+
+struct cpu *smp_cpu_from_addr(uint16_t addr)
+{
+	int i, num = smp_query_num_cpus();
+
+	for (i = 0; i < num; i++) {
+		if (cpus[i].addr == addr)
+			return &cpus[i];
+	}
+	return NULL;
+}
+
+bool smp_cpu_stopped(uint16_t addr)
+{
+	uint32_t status;
+
+	if (sigp(addr, SIGP_SENSE, 0, &status) != SIGP_CC_STATUS_STORED)
+		return false;
+	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
+}
+
+bool smp_cpu_running(uint16_t addr)
+{
+	if (sigp(addr, SIGP_SENSE_RUNNING, 0, NULL) != SIGP_CC_STATUS_STORED)
+		return true;
+	/* Status stored condition code is equivalent to cpu not running. */
+	return false;
+}
+
+static int smp_cpu_stop_nolock(uint16_t addr, bool store)
+{
+	struct cpu *cpu;
+	uint8_t order = store ? SIGP_STOP_AND_STORE_STATUS : SIGP_STOP;
+
+	cpu = smp_cpu_from_addr(addr);
+	if (!cpu || cpu == cpu0)
+		return -1;
+
+	if (sigp_retry(addr, order, 0, NULL))
+		return -1;
+
+	while (!smp_cpu_stopped(addr))
+		mb();
+	cpu->active = false;
+	return 0;
+}
+
+int smp_cpu_stop(uint16_t addr)
+{
+	int rc;
+
+	spin_lock(&lock);
+	rc = smp_cpu_stop_nolock(addr, false);
+	spin_unlock(&lock);
+	return rc;
+}
+
+int smp_cpu_stop_store_status(uint16_t addr)
+{
+	int rc;
+
+	spin_lock(&lock);
+	rc = smp_cpu_stop_nolock(addr, true);
+	spin_unlock(&lock);
+	return rc;
+}
+
+int smp_cpu_restart(uint16_t addr)
+{
+	int rc = -1;
+	struct cpu *cpu;
+
+	spin_lock(&lock);
+	cpu = smp_cpu_from_addr(addr);
+	if (cpu) {
+		rc = sigp(addr, SIGP_RESTART, 0, NULL);
+		cpu->active = true;
+	}
+	spin_unlock(&lock);
+	return rc;
+}
+
+int smp_cpu_start(uint16_t addr, struct psw psw)
+{
+	int rc = -1;
+	struct cpu *cpu;
+	struct lowcore *lc;
+
+	spin_lock(&lock);
+	cpu = smp_cpu_from_addr(addr);
+	if (cpu) {
+		lc = cpu->lowcore;
+		lc->restart_new_psw.mask = psw.mask;
+		lc->restart_new_psw.addr = psw.addr;
+		rc = sigp(addr, SIGP_RESTART, 0, NULL);
+	}
+	spin_unlock(&lock);
+	return rc;
+}
+
+int smp_cpu_destroy(uint16_t addr)
+{
+	struct cpu *cpu;
+	int rc;
+
+	spin_lock(&lock);
+	rc = smp_cpu_stop_nolock(addr, false);
+	if (!rc) {
+		cpu = smp_cpu_from_addr(addr);
+		free_pages(cpu->lowcore, 2 * PAGE_SIZE);
+		free_pages(cpu->stack, 4 * PAGE_SIZE);
+		cpu->lowcore = (void *)-1UL;
+		cpu->stack = (void *)-1UL;
+	}
+	spin_unlock(&lock);
+	return rc;
+}
+
+int smp_cpu_setup(uint16_t addr, struct psw psw)
+{
+	struct lowcore *lc;
+	struct cpu *cpu;
+	int rc = -1;
+
+	spin_lock(&lock);
+
+	if (!cpus)
+		goto out;
+
+	cpu = smp_cpu_from_addr(addr);
+
+	if (!cpu || cpu->active)
+		goto out;
+
+	sigp_retry(cpu->addr, SIGP_INITIAL_CPU_RESET, 0, NULL);
+
+	lc = alloc_pages(1);
+	cpu->lowcore = lc;
+	memset(lc, 0, PAGE_SIZE * 2);
+	sigp_retry(cpu->addr, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
+
+	/* Copy all exception psws. */
+	memcpy(lc, cpu0->lowcore, 512);
+
+	/* Setup stack */
+	cpu->stack = (uint64_t *)alloc_pages(2);
+
+	/* Start without DAT and any other mask bits. */
+	cpu->lowcore->sw_int_grs[14] = psw.addr;
+	cpu->lowcore->sw_int_grs[15] = (uint64_t)cpu->stack + (PAGE_SIZE * 4);
+	lc->restart_new_psw.mask = 0x0000000180000000UL;
+	lc->restart_new_psw.addr = (uint64_t)smp_cpu_setup_state;
+	lc->sw_int_cr0 = 0x0000000000040000UL;
+
+	/* Start processing */
+	rc = sigp_retry(cpu->addr, SIGP_RESTART, 0, NULL);
+	if (!rc)
+		cpu->active = true;
+
+out:
+	spin_unlock(&lock);
+	return rc;
+}
+
+/*
+ * Disregarding state, stop all cpus that once were online except for
+ * calling cpu.
+ */
+void smp_teardown(void)
+{
+	int i = 0;
+	uint16_t this_cpu = stap();
+	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
+
+	spin_lock(&lock);
+	for (; i < info->nr_configured; i++) {
+		if (cpus[i].active &&
+		    cpus[i].addr != this_cpu) {
+			sigp_retry(cpus[i].addr, SIGP_STOP, 0, NULL);
+		}
+	}
+	spin_unlock(&lock);
+}
+
+/*Expected to be called from boot cpu */
+extern uint64_t *stackptr;
+void smp_setup(void)
+{
+	int i = 0;
+	unsigned short cpu0_addr = stap();
+	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
+
+	spin_lock(&lock);
+	sclp_mark_busy();
+	info->h.length = PAGE_SIZE;
+	sclp_service_call(SCLP_READ_CPU_INFO, cpu_info_buffer);
+
+	if (smp_query_num_cpus() > 1)
+		printf("SMP: Initializing, found %d cpus\n", info->nr_configured);
+
+	cpus = calloc(info->nr_configured, sizeof(cpus));
+	for (i = 0; i < info->nr_configured; i++) {
+		cpus[i].addr = info->entries[i].address;
+		cpus[i].active = false;
+		if (info->entries[i].address == cpu0_addr) {
+			cpu0 = &cpus[i];
+			cpu0->stack = stackptr;
+			cpu0->lowcore = (void *)0;
+			cpu0->active = true;
+		}
+	}
+	spin_unlock(&lock);
+}
diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
new file mode 100644
index 0000000..4476c31
--- /dev/null
+++ b/lib/s390x/smp.h
@@ -0,0 +1,51 @@
+/*
+ * s390x smp
+ *
+ * Copyright (c) 2019 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+#ifndef SMP_H
+#define SMP_H
+
+struct cpu {
+	struct lowcore *lowcore;
+	uint64_t *stack;
+	uint16_t addr;
+	bool active;
+};
+
+struct cpu_status {
+    uint64_t    fprs[16];                       /* 0x0000 */
+    uint64_t    grs[16];                        /* 0x0080 */
+    struct psw  psw;                            /* 0x0100 */
+    uint8_t     pad_0x0110[0x0118 - 0x0110];    /* 0x0110 */
+    uint32_t    prefix;                         /* 0x0118 */
+    uint32_t    fpc;                            /* 0x011c */
+    uint8_t     pad_0x0120[0x0124 - 0x0120];    /* 0x0120 */
+    uint32_t    todpr;                          /* 0x0124 */
+    uint64_t    cputm;                          /* 0x0128 */
+    uint64_t    ckc;                            /* 0x0130 */
+    uint8_t     pad_0x0138[0x0140 - 0x0138];    /* 0x0138 */
+    uint32_t    ars[16];                        /* 0x0140 */
+    uint64_t    crs[16];                        /* 0x0384 */
+};
+
+int smp_query_num_cpus(void);
+struct cpu *smp_cpu_from_addr(uint16_t addr);
+bool smp_cpu_stopped(uint16_t addr);
+bool smp_cpu_running(uint16_t addr);
+int smp_cpu_restart(uint16_t addr);
+int smp_cpu_start(uint16_t addr, struct psw psw);
+int smp_cpu_stop(uint16_t addr);
+int smp_cpu_stop_store_status(uint16_t addr);
+int smp_cpu_destroy(uint16_t addr);
+int smp_cpu_setup(uint16_t addr, struct psw psw);
+void smp_teardown(void);
+void smp_setup(void);
+
+#endif
diff --git a/s390x/Makefile b/s390x/Makefile
index 96033dd..d83dd0b 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -48,6 +48,7 @@ cflatobjs += lib/s390x/sclp.o
 cflatobjs += lib/s390x/sclp-console.o
 cflatobjs += lib/s390x/interrupt.o
 cflatobjs += lib/s390x/mmu.o
+cflatobjs += lib/s390x/smp.o
 
 OBJDIRS += lib/s390x
 
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 36f7cab..5dc1577 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -172,6 +172,13 @@ diag308_load_reset:
 	lhi	%r2, 1
 	br	%r14
 
+.globl smp_cpu_setup_state
+smp_cpu_setup_state:
+	xgr	%r1, %r1
+	lmg     %r0, %r15, GEN_LC_SW_INT_GRS
+	lctlg   %c0, %c0, GEN_LC_SW_INT_CR0
+	br	%r14
+
 pgm_int:
 	SAVE_REGS
 	brasl	%r14, handle_pgm_int
-- 
2.17.2

