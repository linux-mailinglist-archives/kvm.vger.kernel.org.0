Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A01FB057
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 13:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfKMMX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 07:23:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23054 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726543AbfKMMX2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 07:23:28 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADCJE81084047
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:23:27 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w8hj98r3k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:23:27 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 13 Nov 2019 12:23:25 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 12:23:22 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADCNL9J40632396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 12:23:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70DC94C04A;
        Wed, 13 Nov 2019 12:23:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 292EE4C044;
        Wed, 13 Nov 2019 12:23:21 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.55])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 12:23:21 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: [PATCH v1 4/4] s390x: Testing the Subchannel I/O read
Date:   Wed, 13 Nov 2019 13:23:19 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111312-0028-0000-0000-000003B686EA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111312-0029-0000-0000-000024798E80
Message-Id: <1573647799-30584-5-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This simple test test the I/O reading by the SUB Channel by:
- initializing the Channel SubSystem with predefined CSSID:
  0xfe000000 CSSID for a Virtual CCW
  0x00090000 SSID for CCW-PONG
- initializing the ORB pointing to a single READ CCW
- starts the STSH command with the ORB
- Expect an interrupt
- writes the read data to output

The test implements lots of traces when DEBUG is on and
tests if memory above the stack is corrupted.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h      | 244 +++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/css_dump.c | 141 +++++++++++++++++++++++++++++
 s390x/Makefile       |   2 +
 s390x/css.c          | 222 ++++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg  |   4 +
 5 files changed, 613 insertions(+)
 create mode 100644 lib/s390x/css.h
 create mode 100644 lib/s390x/css_dump.c
 create mode 100644 s390x/css.c

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
new file mode 100644
index 0000000..a7c42fd
--- /dev/null
+++ b/lib/s390x/css.h
@@ -0,0 +1,244 @@
+/*
+ * CSS definitions
+ *
+ * Copyright IBM, Corp. 2019
+ * Author: Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#ifndef CSS_H
+#define CSS_H
+
+#define CCW_F_CD	0x80
+#define CCW_F_CC	0x40
+#define CCW_F_SLI	0x20
+#define CCW_F_SKP	0x10
+#define CCW_F_PCI	0x08
+#define CCW_F_IDA	0x04
+#define CCW_F_S		0x02
+#define CCW_F_MIDA	0x01
+
+#define CCW_C_NOP	0x03
+#define CCW_C_TIC	0x08
+
+struct ccw {
+	unsigned char code;
+	unsigned char flags;
+	unsigned short count;
+	unsigned int data;
+} __attribute__ ((aligned(4)));
+
+#define ORB_M_KEY	0xf0000000
+#define ORB_F_SUSPEND	0x08000000
+#define ORB_F_STREAMING	0x04000000
+#define ORB_F_MODIFCTRL	0x02000000
+#define ORB_F_SYNC	0x01000000
+#define ORB_F_FORMAT	0x00800000
+#define ORB_F_PREFETCH	0x00400000
+#define ORB_F_INIT_IRQ	0x00200000
+#define ORB_F_ADDRLIMIT	0x00100000
+#define ORB_F_SUSP_IRQ	0x00080000
+#define ORB_F_TRANSPORT	0x00040000
+#define ORB_F_IDAW2	0x00020000
+#define ORB_F_IDAW_2K	0x00010000
+#define ORB_M_LPM	0x0000ff00
+#define ORB_F_LPM_DFLT	0x00008000
+#define ORB_F_ILSM	0x00000080
+#define ORB_F_CCW_IND	0x00000040
+#define ORB_F_ORB_EXT	0x00000001
+struct orb {
+	unsigned int	intparm;
+	unsigned int	ctrl;
+	unsigned int	cpa;
+	unsigned int	prio;
+	unsigned int	reserved[4];
+} __attribute__ ((aligned(4)));;
+
+struct scsw {
+	uint32_t ctrl;
+	uint32_t addr;
+	uint8_t  devs;
+	uint8_t  schs;
+	uint16_t count;
+};
+
+struct pmcw {
+	uint32_t intparm;
+	uint16_t flags;
+	uint16_t devnum;
+	uint8_t  lpm;
+	uint8_t  pnom;
+	uint8_t  lpum;
+	uint8_t  pim;
+	uint16_t mbi;
+	uint8_t  pom;
+	uint8_t  pam;
+	uint8_t  chpid[8];
+	uint32_t flag2;
+};
+struct schib {
+	struct pmcw pmcw;
+	struct scsw scsw;
+	uint32_t  md0;
+	uint32_t  md1;
+	uint32_t  md2;
+} __attribute__ ((aligned(4)));
+
+struct irb {
+	struct scsw scsw;
+	uint32_t esw[5];
+	uint32_t ecw[8];
+	uint32_t emw[8];
+} __attribute__ ((aligned(4)));;
+
+/* CSS low level access functions */
+
+static inline int ssch(unsigned long schid, struct orb *addr)
+{
+	register long long reg1 asm("1") = schid;
+	int ccode = -1;
+
+	asm volatile(
+		"	   ssch	0(%2)\n"
+		"0:	 ipm	 %0\n"
+		"	   srl	 %0,28\n"
+		"1:\n"
+		: "+d" (ccode)
+		: "d" (reg1), "a" (addr), "m" (*addr)
+		: "cc", "memory");
+	return ccode;
+}
+
+static inline int stsch(unsigned long schid, struct schib *addr)
+{
+	register unsigned long reg1 asm ("1") = schid;
+	int ccode;
+
+	asm volatile(
+		"	   stsch	0(%3)\n"
+		"	   ipm	 %0\n"
+		"	   srl	 %0,28"
+		: "=d" (ccode), "=m" (*addr)
+		: "d" (reg1), "a" (addr)
+		: "cc");
+	return ccode;
+}
+
+static inline int msch(unsigned long schid, struct schib *addr)
+{
+	register unsigned long reg1 asm ("1") = schid;
+	int ccode;
+
+	asm volatile(
+		"	   msch	0(%3)\n"
+		"	   ipm	 %0\n"
+		"	   srl	 %0,28"
+		: "=d" (ccode), "=m" (*addr)
+		: "d" (reg1), "a" (addr)
+		: "cc");
+	return ccode;
+}
+
+static inline int tsch(unsigned long schid, struct irb *addr)
+{
+	register unsigned long reg1 asm ("1") = schid;
+	int ccode;
+
+	asm volatile(
+		"	   tsch	0(%3)\n"
+		"	   ipm	 %0\n"
+		"	   srl	 %0,28"
+		: "=d" (ccode), "=m" (*addr)
+		: "d" (reg1), "a" (addr)
+		: "cc");
+	return ccode;
+}
+
+static inline int hsch(unsigned long schid)
+{
+	register unsigned long reg1 asm("1") = schid;
+	int ccode;
+
+	asm volatile(
+		"	hsch\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (ccode)
+		: "d" (reg1)
+		: "cc");
+	return ccode;
+}
+
+static inline int xsch(unsigned long schid)
+{
+	register unsigned long reg1 asm("1") = schid;
+	int ccode;
+
+	asm volatile(
+		"	xsch\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (ccode)
+		: "d" (reg1)
+		: "cc");
+	return ccode;
+}
+
+static inline int csch(unsigned long schid)
+{
+	register unsigned long reg1 asm("1") = schid;
+	int ccode;
+
+	asm volatile(
+		"	csch\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (ccode)
+		: "d" (reg1)
+		: "cc");
+	return ccode;
+}
+
+static inline int rsch(unsigned long schid)
+{
+	register unsigned long reg1 asm("1") = schid;
+	int ccode;
+
+	asm volatile(
+		"	rsch\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (ccode)
+		: "d" (reg1)
+		: "cc");
+	return ccode;
+}
+
+static inline int rchp(unsigned long chpid)
+{
+	register unsigned long reg1 asm("1") = chpid;
+	int ccode;
+
+	asm volatile(
+		"	rchp\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (ccode)
+		: "d" (reg1)
+		: "cc");
+	return ccode;
+}
+
+void dump_scsw(struct scsw *);
+void dump_irb(struct irb *irbp);
+void dump_pmcw_flags(uint16_t f);
+void dump_pmcw(struct pmcw *p);
+void dump_schib(struct schib *sch);
+struct ccw *dump_ccw(struct ccw *cp);
+void dump_orb(struct orb *op);
+
+extern unsigned long stacktop;
+#endif
diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
new file mode 100644
index 0000000..4f6b628
--- /dev/null
+++ b/lib/s390x/css_dump.c
@@ -0,0 +1,141 @@
+/*
+ * Channel Sub-System structures dumping
+ *
+ * Copyright (c) 2019 IBM Corp.
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Library General Public License version 2.
+ *
+ * Description:
+ * Provides the dumping functions for various structures used by subchannels:
+ * - ORB  : Operation request block, describe the I/O operation and point to
+ *          a CCW chain
+ * - CCW  : Channel Command Word, describe the data and flow control
+ * - IRB  : Interuption response Block, describe the result of an operation
+ *          hold a SCSW and several channel type dependent fields.
+ * - SCHIB: SubChannel Information Block composed of:
+ *   - SCSW: SubChannel Status Word, status of the channel as a result of an
+ *           operation when in IRB.
+ *   - PMCW: Path Management Control Word
+ * You need the QEMU ccw-pong device in QEMU to answer the I/O transfers.
+ */
+
+#include <unistd.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+
+#include <css.h>
+
+static const char *scsw_str = "kkkkslccfpixuzen";
+static const char *scsw_str2 = "1SHCrshcsdsAIPSs";
+
+void dump_scsw(struct scsw *s)
+{
+	int i;
+	uint32_t scsw = s->ctrl;
+	char line[64] = {};
+
+	for (i = 0; i < 16; i++) {
+		if ((scsw << i) & 0x80000000)
+			line[i] = scsw_str[i];
+		else
+			line[i] = '_';
+	}
+	line[i] = ' ';
+	for (; i < 32; i++) {
+		if ((scsw << i) & 0x80000000)
+			line[i + 1] = scsw_str2[i - 16];
+		else
+			line[i + 1] = '_';
+	}
+	printf("scsw->flags: %s\n", line);
+	printf("scsw->addr : %08x\n", s->addr);
+	printf("scsw->devs : %02x\n", s->devs);
+	printf("scsw->schs : %02x\n", s->schs);
+	printf("scsw->count: %04x\n", s->count);
+
+}
+
+void dump_irb(struct irb *irbp)
+{
+	int i;
+	uint32_t *p = (uint32_t *)irbp;
+
+	dump_scsw(&irbp->scsw);
+	for (i = 0; i < sizeof(*irbp)/sizeof(*p); i++, p++)
+		printf("irb[%02x] : %08x\n", i, *p);
+}
+
+static const char *pmcw_str = "11iii111ellmmdtv";
+void dump_pmcw_flags(uint16_t f)
+{
+	int i;
+	char line[32] = {};
+
+	for (i = 0; i < 16; i++) {
+		if ((f << i) & 0x8000)
+			line[i] = pmcw_str[i];
+		else
+			line[i] = '_';
+	}
+	printf("pmcw->pmcw flgs: %s\n", line);
+}
+
+void dump_pmcw(struct pmcw *p)
+{
+	int i;
+
+	printf("pmcw->intparm  : %08x\n", p->intparm);
+	printf("pmcw->flags    : %04x\n", p->flags);
+	dump_pmcw_flags(p->flags);
+	printf("pmcw->devnum   : %04x\n", p->devnum);
+	printf("pmcw->lpm      : %02x\n", p->lpm);
+	printf("pmcw->pnom     : %02x\n", p->pnom);
+	printf("pmcw->lpum     : %02x\n", p->lpum);
+	printf("pmcw->pim      : %02x\n", p->pim);
+	printf("pmcw->mbi      : %04x\n", p->mbi);
+	printf("pmcw->pom      : %02x\n", p->pom);
+	printf("pmcw->pam      : %02x\n", p->pam);
+	printf("pmcw->mbi      : %04x\n", p->mbi);
+	for (i = 0; i < 8; i++)
+		printf("pmcw->chpid[%d]: %02x\n", i, p->chpid[i]);
+	printf("pmcw->flags2  : %08x\n", p->flag2);
+}
+
+void dump_schib(struct schib *sch)
+{
+	struct pmcw *p = &sch->pmcw;
+	struct scsw *s = &sch->scsw;
+
+	printf("--SCHIB--\n");
+	dump_pmcw(p);
+	dump_scsw(s);
+}
+
+struct ccw *dump_ccw(struct ccw *cp)
+{
+	printf("CCW: code: %02x flags: %02x count: %04x data: %08x\n", cp->code,
+	    cp->flags, cp->count, cp->data);
+
+	if (cp->code == CCW_C_TIC)
+		return (struct ccw *)(long)cp->data;
+
+	return (cp->flags & CCW_F_CC) ? cp + 1 : NULL;
+}
+
+void dump_orb(struct orb *op)
+{
+	struct ccw *cp;
+
+	printf("ORB: intparm : %08x\n", op->intparm);
+	printf("ORB: ctrl    : %08x\n", op->ctrl);
+	printf("ORB: prio    : %08x\n", op->prio);
+	cp = (struct ccw *)(long) (op->cpa);
+	while (cp)
+		cp = dump_ccw(cp);
+}
+
diff --git a/s390x/Makefile b/s390x/Makefile
index 3744372..9ebbb84 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -16,6 +16,7 @@ tests += $(TEST_DIR)/diag288.elf
 tests += $(TEST_DIR)/stsi.elf
 tests += $(TEST_DIR)/skrf.elf
 tests += $(TEST_DIR)/smp.elf
+tests += $(TEST_DIR)/css.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
@@ -50,6 +51,7 @@ cflatobjs += lib/s390x/sclp-console.o
 cflatobjs += lib/s390x/interrupt.o
 cflatobjs += lib/s390x/mmu.o
 cflatobjs += lib/s390x/smp.o
+cflatobjs += lib/s390x/css_dump.o
 
 OBJDIRS += lib/s390x
 
diff --git a/s390x/css.c b/s390x/css.c
new file mode 100644
index 0000000..6cdaf61
--- /dev/null
+++ b/s390x/css.c
@@ -0,0 +1,222 @@
+/*
+ * Channel Sub-System tests
+ *
+ * Copyright (c) 2019 IBM Corp
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+
+#include <libcflat.h>
+#include <alloc_phys.h>
+#include <asm/page.h>
+#include <string.h>
+#include <asm/interrupt.h>
+#include <asm/arch_def.h>
+
+#include <css.h>
+
+#define PSW_PRG_MASK (PSW_MASK_IO | PSW_MASK_EA | PSW_MASK_BA)
+
+#define DEBUG 1
+#ifdef DEBUG
+#define DBG(format, arg...) \
+	printf("KT_%s:%d " format "\n", __func__, __LINE__, ##arg)
+#else
+#define DBG(format, arg...) do {} while (0)
+#endif
+
+#define CSSID_PONG	(0xfe000000 | 0x00090000)
+
+struct lowcore *lowcore = (void *)0x0;
+
+#define NB_CCW  100
+static struct ccw ccw[NB_CCW];
+
+#define NB_ORB  100
+static struct orb orb[NB_ORB];
+
+static struct irb irb;
+static struct schib schib;
+
+static char buffer[4096];
+
+static void delay(int d)
+{
+	int i, j;
+
+	while (d--)
+		for (i = 1000000; i; i--)
+			for (j = 1000000; j; j--)
+				;
+}
+
+static void set_io_irq_subclass_mask(uint64_t const new_mask)
+{
+	asm volatile (
+		"lctlg %%c6, %%c6, %[source]\n"
+		: /* No outputs */
+		: [source] "R" (new_mask));
+}
+
+static void set_system_mask(uint8_t new_mask)
+{
+	asm volatile (
+		"ssm %[source]\n"
+		: /* No outputs */
+		: [source] "R" (new_mask));
+}
+
+static void enable_io_irq(void)
+{
+	set_io_irq_subclass_mask(0x00000000ff000000);
+	set_system_mask(PSW_PRG_MASK >> 56);
+}
+
+void handle_io_int(sregs_t *regs)
+{
+	int ret = 0;
+
+	DBG("IO IRQ: subsys_id_word=%08x", lowcore->subsys_id_word);
+	DBG("......: io_int_parm   =%08x", lowcore->io_int_param);
+	DBG("......: io_int_word   =%08x", lowcore->io_int_word);
+	ret = tsch(lowcore->subsys_id_word, &irb);
+	dump_irb(&irb);
+	if (ret)
+		DBG("......: tsch retval %d", ret);
+	DBG("IO IRQ: END");
+}
+
+static void set_schib(struct schib *sch)
+{
+	struct pmcw *p = &sch->pmcw;
+
+	p->intparm = 0xdeadbeef;
+	p->devnum = 0xc0ca;
+	p->lpm = 0x80;
+	p->flags = 0x3081;
+	p->chpid[7] = 0x22;
+	p->pim = 0x0f;
+	p->pam = 0x0f;
+	p->pom = 0x0f;
+	p->lpm = 0x0f;
+	p->lpum = 0xaa;
+	p->pnom = 0xf0;
+	p->mbi = 0xaa;
+	p->mbi = 0xaaaa;
+}
+
+static void css_enable(void)
+{
+	int ret;
+
+	ret = stsch(CSSID_PONG, &schib);
+	if (ret)
+		DBG("stsch: %x\n", ret);
+	dump_schib(&schib);
+	set_schib(&schib);
+	dump_schib(&schib);
+	ret = msch(CSSID_PONG, &schib);
+	if (ret)
+		DBG("msch : %x\n", ret);
+}
+
+/* These two definitions are part of the QEMU PONG interface */
+#define PONG_WRITE 0x21
+#define PONG_READ  0x22
+
+static int css_run(int fake)
+{
+	struct orb *p = orb;
+	int cc;
+
+	if (fake)
+		return 0;
+	css_enable();
+
+	enable_io_irq();
+
+	ccw[0].code = PONG_READ;
+	ccw[0].flags = CCW_F_PCI;
+	ccw[0].count = 80;
+	ccw[0].data = (unsigned int)(unsigned long) &buffer;
+
+	p->intparm = 0xcafec0ca;
+	p->ctrl = ORB_F_INIT_IRQ|ORB_F_FORMAT|ORB_F_LPM_DFLT;
+	p->cpa = (unsigned int) (unsigned long)&ccw[0];
+
+	printf("ORB AT %p\n", orb);
+	dump_orb(p);
+	cc = ssch(CSSID_PONG, p);
+	if (cc) {
+		DBG("cc: %x\n", cc);
+		return cc;
+	}
+
+	delay(1);
+
+	stsch(CSSID_PONG, &schib);
+	dump_schib(&schib);
+	DBG("got: %s\n", buffer);
+
+	return 0;
+}
+
+#define MAX_ERRORS 10
+static int checkmem(phys_addr_t start, phys_addr_t end)
+{
+	phys_addr_t curr;
+	int err = 0;
+
+	for (curr = start; curr != end; curr += PAGE_SIZE)
+		if (memcmp((void *)start, (void *)curr, PAGE_SIZE)) {
+			report("memcmp failed %lx", true, curr);
+			if (err++ > MAX_ERRORS)
+				break;
+		}
+	return err;
+}
+
+extern unsigned long bss_end;
+
+int main(int argc, char *argv[])
+{
+	phys_addr_t base, top;
+	int check_mem = 0;
+	int err = 0;
+
+	if (argc == 2 && !strcmp(argv[1], "-i"))
+		check_mem = 1;
+
+	report_prefix_push("css");
+	phys_alloc_get_unused(&base, &top);
+
+	top = 0x08000000; /* 128MB Need to be updated */
+	base = (phys_addr_t)&stacktop;
+
+	if (check_mem)
+		memset((void *)base, 0x00, top - base);
+
+	if (check_mem)
+		err = checkmem(base, top);
+	if (err)
+		goto out;
+
+	err = css_run(0);
+	if (err)
+		goto out;
+
+	if (check_mem)
+		err = checkmem(base, top);
+
+out:
+	if (err)
+		report("Tested", 0);
+	else
+		report("Tested", 1);
+
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index f1b07cd..1755d9e 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -75,3 +75,7 @@ file = stsi.elf
 [smp]
 file = smp.elf
 extra_params =-smp 2
+
+[css]
+file = css.elf
+extra_params =-device ccw-pong
-- 
2.7.4

