Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CE61D7DDC
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 18:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgERQHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 12:07:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28809 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728333AbgERQHo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 12:07:44 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04IG43AE069366;
        Mon, 18 May 2020 12:07:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 312aar9880-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 12:07:42 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04IG4RXQ072003;
        Mon, 18 May 2020 12:07:42 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 312aar986m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 12:07:42 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04IG651Z021985;
        Mon, 18 May 2020 16:07:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3127t5hu4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 16:07:40 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04IG7buO53870644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 16:07:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD80111C04A;
        Mon, 18 May 2020 16:07:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77FB511C058;
        Mon, 18 May 2020 16:07:37 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.158.244])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 18 May 2020 16:07:37 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v7 11/12] s390x: css: ssch/tsch with sense and interrupt
Date:   Mon, 18 May 2020 18:07:30 +0200
Message-Id: <1589818051-20549-12-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 clxscore=1015
 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 suspectscore=1 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005180134
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We add a new css_lib file to contain the I/O functions we may
share with different tests.
First function is the subchannel_enable() function.

When a channel is enabled we can start a SENSE_ID command using
the SSCH instruction to recognize the control unit and device.

This tests the success of SSCH, the I/O interruption and the TSCH
instructions.

The test expects a device with a control unit type of 0xC0CA as the
first subchannel of the CSS.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  20 ++++++
 lib/s390x/css_lib.c |  55 +++++++++++++++++
 s390x/Makefile      |   1 +
 s390x/css.c         | 145 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 221 insertions(+)
 create mode 100644 lib/s390x/css_lib.c

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index e0d3a98..f4df7bc 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -99,6 +99,19 @@ struct irb {
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
@@ -256,4 +269,11 @@ static inline struct ccw *dump_ccw(struct ccw *cp)
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
index 0000000..80b9359
--- /dev/null
+++ b/lib/s390x/css_lib.c
@@ -0,0 +1,55 @@
+/*
+ * Channel subsystem library functions
+ *
+ * Copyright (c) 2020 IBM Corp.
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
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
index 1b60a47..c94a916 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -20,8 +20,24 @@
 
 #include <css.h>
 
+#define PONG_CU_TYPE		0xc0ca
+
+struct lowcore *lowcore = (void *)0x0;
+
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
 
 static void test_enumerate(void)
 {
@@ -131,12 +147,140 @@ retry:
 	       test_device_sid, retry_count, pmcw->flags);
 }
 
+static void enable_io_isc(void)
+{
+	/* Let's enable all ISCs for I/O interrupt */
+	set_io_irq_subclass_mask(0x00000000ff000000);
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
+		report(0,
+		       "Bad io_int_param: %x expected %x",
+		       lowcore->io_int_param, test_device_sid);
+		goto pop;
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
+		report(0,
+		       "I/O interrupt, CC 1 but tsch reporting sch %08x as not status pending: %s",
+		       sid, flags);
+		break;
+	case 2:
+		report(0, "tsch returns unexpected CC 2");
+		break;
+	case 3:
+		report(0, "tsch reporting sch %08x as not operational", sid);
+		break;
+	case 0:
+		/* Stay humble on success */
+		break;
+	}
+pop:
+	report_prefix_pop();
+	lowcore->io_old_psw.mask &= ~PSW_MASK_WAIT;
+}
+
+static int start_subchannel(int code, void *data, int count,
+			    unsigned char flags)
+{
+	int ret;
+
+	report_prefix_push("start_senseid");
+	/* Build the CCW chain with a single CCW */
+	ccw[0].code = code;
+	ccw[0].flags = flags; /* No flags need to be set */
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
+		report(0,
+		       "Could not enable the subchannel: %08x",
+		       test_device_sid);
+		return;
+	}
+
+	ret = register_io_int_func(irq_io);
+	if (ret) {
+		report(0, "Could not register IRQ handler");
+		goto unreg_cb;
+	}
+
+	lowcore->io_int_param = 0;
+
+	ret = start_subchannel(CCW_CMD_SENSE_ID, &senseid, sizeof(senseid),
+			       CCW_F_SLI);
+	if (!ret) {
+		report(0, "ssch failed for SENSE ID on sch %08x",
+		       test_device_sid);
+		goto unreg_cb;
+	}
+
+	wait_for_interrupt(PSW_MASK_IO);
+
+	if (lowcore->io_int_param != test_device_sid)
+		goto unreg_cb;
+
+	report_info("reserved %02x cu_type %04x cu_model %02x dev_type %04x dev_model %02x",
+		    senseid.reserved, senseid.cu_type, senseid.cu_model,
+		    senseid.dev_type, senseid.dev_model);
+
+	report((senseid.cu_type == PONG_CU),
+	       "cu_type: expect 0x%04x got 0x%04x",
+	       PONG_CU_TYPE, senseid.cu_type);
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
 
@@ -145,6 +289,7 @@ int main(int argc, char *argv[])
 	int i;
 
 	report_prefix_push("Channel Subsystem");
+	enable_io_isc();
 	for (i = 0; tests[i].name; i++) {
 		report_prefix_push(tests[i].name);
 		tests[i].func();
-- 
2.25.1

