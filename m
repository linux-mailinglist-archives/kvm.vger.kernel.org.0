Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C278165D1D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 13:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgBTMA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 07:00:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59348 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728002AbgBTMAy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 07:00:54 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KBxEZ6133126
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 07:00:53 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8ubx5bjc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 07:00:52 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 20 Feb 2020 12:00:50 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 20 Feb 2020 12:00:48 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KC0l0o37224916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 12:00:47 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1C49AE068;
        Thu, 20 Feb 2020 12:00:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B76EAE065;
        Thu, 20 Feb 2020 12:00:46 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.41])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 12:00:46 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 09/10] s390x: css: ssch/tsch with sense and interrupt
Date:   Thu, 20 Feb 2020 13:00:42 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
References: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20022012-0020-0000-0000-000003ABE7D4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022012-0021-0000-0000-00002203ED0B
Message-Id: <1582200043-21760-10-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_03:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We add a new css_lib file to contain the I/O function we may
share with different tests.
First function is the subchannel_enable() function.

When a channel is enabled we can start a SENSE ID command using
the SSCH instruction to recognize the control unit and device.

This tests the success of SSCH, the I/O interruption and the TSCH
instructions.

The test expects a device with a control unit type of 0xC0CA as the
first subchannel of the CSS.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |   1 +
 lib/s390x/asm/time.h     |  10 +++
 lib/s390x/css.h          |  20 ++++++
 lib/s390x/css_lib.c      |  55 ++++++++++++++
 s390x/Makefile           |   1 +
 s390x/css.c              | 152 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 239 insertions(+)
 create mode 100644 lib/s390x/css_lib.c

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 863c2bf..ab3fc9d 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -10,6 +10,7 @@
 #ifndef _ASM_S390X_ARCH_DEF_H_
 #define _ASM_S390X_ARCH_DEF_H_
 
+#define PSW_MASK_IO			0x0200000000000000UL
 #define PSW_MASK_EXT			0x0100000000000000UL
 #define PSW_MASK_DAT			0x0400000000000000UL
 #define PSW_MASK_PSTATE			0x0001000000000000UL
diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
index 25c7a3c..d3e4eab 100644
--- a/lib/s390x/asm/time.h
+++ b/lib/s390x/asm/time.h
@@ -23,4 +23,14 @@ static inline uint64_t get_clock_ms(void)
 	return (clk >> (63 - 51)) / 1000;
 }
 
+static inline void delay(unsigned long ms)
+{
+	unsigned long startclk;
+
+	startclk = get_clock_ms();
+	for (;;)
+		if (get_clock_ms() - startclk > ms)
+			break;
+}
+
 #endif
diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 448e597..b6ab0ba 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -97,6 +97,19 @@ struct irb {
 	uint32_t emw[8];
 } __attribute__ ((aligned(4)));
 
+#define CCW_CMD_SENSE_ID	0xe4
+#define PONG_CU			0xc0ca
+struct senseid {
+	/* common part */
+	uint8_t reserved;        /* always 0x'FF' */
+	uint16_t cu_type;        /* control unit type */
+	uint8_t cu_model;        /* control unit model */
+	uint16_t dev_type;       /* device type */
+	uint8_t dev_model;       /* device model */
+	uint8_t unused;          /* padding byte */
+	uint8_t padding[256 - 10]; /* Extra padding for CCW */
+} __attribute__ ((aligned(4))) __attribute__ ((packed));
+
 /* CSS low level access functions */
 
 static inline int ssch(unsigned long schid, struct orb *addr)
@@ -254,4 +267,11 @@ static inline struct ccw *dump_ccw(struct ccw *cp)
 	return NULL;
 }
 #endif /* DEBUG_CSS */
+
+#define SID_ONE         0x00010000
+
+/* Library functions */
+int enable_subchannel(unsigned int sid);
+int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
+
 #endif
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
new file mode 100644
index 0000000..15d767a
--- /dev/null
+++ b/lib/s390x/css_lib.c
@@ -0,0 +1,55 @@
+/*
+ * Channel subsystem library functions
+ *
+ * Copyright (c) 2019 IBM Corp.
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Library General Public License version 2.
+ */
+#include <stdint.h>
+#include <stddef.h>
+#include <css.h>
+
+int enable_subchannel(unsigned int sid)
+{
+	struct schib schib;
+	struct pmcw *pmcw = &schib.pmcw;
+	int try_count = 5;
+	int cc;
+
+	if (!(sid & SID_ONE))
+		return -1;
+
+	cc = stsch(sid, &schib);
+	if (cc)
+		return -cc;
+
+	do {
+		pmcw->flags |= PMCW_ENABLE;
+
+		cc = msch(sid, &schib);
+		if (cc)
+			return -cc;
+
+		cc = stsch(sid, &schib);
+		if (cc)
+			return -cc;
+
+	} while (!(pmcw->flags & PMCW_ENABLE) && --try_count);
+
+	return try_count;
+}
+
+int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw)
+{
+	struct orb orb;
+
+	orb.intparm = sid;
+	orb.ctrl = ORB_F_INIT_IRQ|ORB_F_FORMAT|ORB_F_LPM_DFLT;
+	orb.cpa = (unsigned int) (unsigned long)ccw;
+
+	return ssch(sid, &orb);
+}
diff --git a/s390x/Makefile b/s390x/Makefile
index baebf18..166cb5c 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -53,6 +53,7 @@ cflatobjs += lib/s390x/interrupt.o
 cflatobjs += lib/s390x/mmu.o
 cflatobjs += lib/s390x/smp.o
 cflatobjs += lib/s390x/css_dump.o
+cflatobjs += lib/s390x/css_lib.o
 
 OBJDIRS += lib/s390x
 
diff --git a/s390x/css.c b/s390x/css.c
index aeee951..b9805a9 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -22,9 +22,34 @@
 #include <asm/time.h>
 
 #define SID_ONE		0x00010000
+#define PSW_PRG_MASK (PSW_MASK_IO | PSW_MASK_EA | PSW_MASK_BA)
+
+#define PONG_CU_TYPE		0xc0ca
+
+struct lowcore *lowcore = (void *)0x0;
 
 static struct schib schib;
 static int test_device_sid;
+#define NUM_CCW  100
+static struct ccw1 ccw[NUM_CCW];
+static struct irb irb;
+static struct senseid senseid;
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
 
 static void test_enumerate(void)
 {
@@ -115,12 +140,139 @@ static void test_enable(void)
 	report(1, "Tested");
 }
 
+static void enable_io_irq(void)
+{
+	/* Let's enable all ISCs for I/O interrupt */
+	set_io_irq_subclass_mask(0x00000000ff000000);
+	set_system_mask(PSW_PRG_MASK >> 56);
+}
+
+static void irq_io(void)
+{
+	int ret = 0;
+	char *flags;
+	int sid;
+
+	report_prefix_push("Interrupt");
+	/* Lowlevel set the SID as interrupt parameter. */
+	if (lowcore->io_int_param != test_device_sid) {
+		report(0, "Bad io_int_param: %x expected %x", lowcore->io_int_param, test_device_sid);
+		report_prefix_pop();
+		return;
+	}
+	report_prefix_pop();
+
+	report_prefix_push("tsch");
+	sid = lowcore->subsys_id_word;
+	ret = tsch(sid, &irb);
+	switch (ret) {
+	case 1:
+		dump_irb(&irb);
+		flags = dump_scsw_flags(irb.scsw.ctrl);
+		report(0, "I/O interrupt, but sch not status pending: %s", flags);
+		goto pop;
+	case 2:
+		report(0, "TSCH returns unexpected CC 2");
+		goto pop;
+	case 3:
+		report(0, "Subchannel %08x not operational", sid);
+		goto pop;
+	case 0:
+		/* Stay humble on success */
+		break;
+	}
+pop:
+	report_prefix_pop();
+}
+
+static int start_subchannel(int code, void *data, int count)
+{
+	int ret;
+
+	report_prefix_push("start_senseid");
+	/* Build the CCW chain with a single CCW */
+	ccw[0].code = code;
+	ccw[0].flags = 0; /* No flags need to be set */
+	ccw[0].count = count;
+	ccw[0].data_address = (int)(unsigned long)data;
+
+	ret = start_ccw1_chain(test_device_sid, ccw);
+	if (ret) {
+		report(0, "start_ccw_chain failed ret=%d", ret);
+		report_prefix_pop();
+		return 0;
+	}
+	report_prefix_pop();
+	return 1;
+}
+
+/*
+ * test_sense
+ * Pre-requisits:
+ * - We need the QEMU PONG device as the first recognized
+ *   device by the enumeration.
+ * - ./s390x-run s390x/css.elf -device ccw-pong,cu_type=0xc0ca
+ */
+static void test_sense(void)
+{
+	int ret;
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+
+	ret = enable_subchannel(test_device_sid);
+	if (ret < 0) {
+		report(0, "Could not enable the subchannel: %08x", test_device_sid);
+		return;
+	}
+
+	ret = register_io_int_func(irq_io);
+	if (ret) {
+		report(0, "Could not register IRQ handler");
+		goto unreg_cb;
+	}
+
+	enable_io_irq();
+	lowcore->io_int_param = 0;
+
+	ret = start_subchannel(CCW_CMD_SENSE_ID, &senseid, sizeof(senseid));
+	if (!ret) {
+		report(0, "start_senseid failed");
+		goto unreg_cb;
+	}
+
+	/* 100ms should be enough for the interruption to fire */
+	delay(100);
+	if (lowcore->io_int_param != test_device_sid) {
+		report(0, "No interrupts. io_int_param: expect 0x%08x, got 0x%08x",
+		       test_device_sid, lowcore->io_int_param);
+		goto unreg_cb;
+	}
+
+	report_info("reserved %02x cu_type %04x cu_model %02x dev_type %04x dev_model %02x\n",
+		    senseid.reserved, senseid.cu_type, senseid.cu_model,
+		    senseid.dev_type, senseid.dev_model);
+
+	if (senseid.cu_type == PONG_CU)
+		report(1, "cu_type: expect 0x%04x got 0x%04x",
+		       PONG_CU_TYPE, senseid.cu_type);
+	else
+		report(0, "cu_type: expect 0x%04x got 0x%04x",
+		       PONG_CU_TYPE, senseid.cu_type);
+
+unreg_cb:
+	unregister_io_int_func(irq_io);
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
 } tests[] = {
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
+	{ "sense (ssch/tsch)", test_sense },
 	{ NULL, NULL }
 };
 
-- 
2.17.0

