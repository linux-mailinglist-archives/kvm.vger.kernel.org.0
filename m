Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5545011B430
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 16:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731095AbfLKPq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 10:46:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387630AbfLKPqU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 10:46:20 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBFhOvL085130
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 10:46:19 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wtdp4hw69-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 10:46:19 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 11 Dec 2019 15:46:17 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Dec 2019 15:46:14 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBBFkDqL34799708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 15:46:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DF2F4C040;
        Wed, 11 Dec 2019 15:46:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00D744C04A;
        Wed, 11 Dec 2019 15:46:13 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Dec 2019 15:46:12 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v4 8/9] s390x: css: ssch/tsch with sense and interrupt
Date:   Wed, 11 Dec 2019 16:46:09 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121115-0016-0000-0000-000002D3DDDE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121115-0017-0000-0000-00003335FDDB
Message-Id: <1576079170-7244-9-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_04:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=1
 priorityscore=1501 mlxscore=0 phishscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110132
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a channel is enabled we can start a SENSE command using the SSCH
instruction to recognize the control unit and device.

This tests the success of SSCH, the I/O interruption and the TSCH
instructions.

The test expects a device with a control unit type of 0xC0CA as the
first subchannel of the CSS.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h |  13 ++++
 s390x/css.c     | 175 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 188 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 06f048b..983e502 100644
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
+} __attribute__ ((aligned(8)));
+
 /* CSS low level access functions */
 
 static inline int ssch(unsigned long schid, struct orb *addr)
diff --git a/s390x/css.c b/s390x/css.c
index b8824ad..7b9bdb1 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -22,9 +22,23 @@
 #include <asm/time.h>
 
 #define SID_ONE		0x00010000
+#define PSW_PRG_MASK (PSW_MASK_IO | PSW_MASK_EA | PSW_MASK_BA)
+
+#define CSS_TEST_INT_PARAM	0xcafec0ca
+#define PONG_CU_TYPE		0xc0ca
+
+struct lowcore *lowcore = (void *)0x0;
 
 static struct schib schib;
 static int test_device_sid;
+#define NUM_CCW  100
+static struct ccw1 ccw[NUM_CCW];
+#define NUM_ORB  100
+static struct orb orb[NUM_ORB];
+static struct irb irb;
+#define BUF_SZ  0x1000
+static char buffer[BUF_SZ] __attribute__ ((aligned(8)));
+static struct senseid senseid;
 
 static inline void delay(unsigned long ms)
 {
@@ -37,6 +51,22 @@ static inline void delay(unsigned long ms)
 	}
 }
 
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
 static void test_enumerate(void)
 {
 	struct pmcw *pmcw = &schib.pmcw;
@@ -128,12 +158,157 @@ static void test_enable(void)
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
+	if (lowcore->io_int_param != CSS_TEST_INT_PARAM) {
+		report(0, "Bad io_int_param: %x", lowcore->io_int_param);
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
+		report(0, "IRB scsw flags: %s", flags);
+		goto pop;
+	case 2:
+		report(0, "TSCH return unexpected CC 2");
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
+static int start_subchannel(int code, char *data, int count)
+{
+	int ret;
+	struct pmcw *p = &schib.pmcw;
+	struct orb *orb_p = &orb[0];
+
+	/* Verify that a test subchannel has been set */
+	if (!test_device_sid) {
+		report_skip("No device");
+		return 0;
+	}
+
+	if ((unsigned long)data >= 0x80000000UL) {
+		report(0, "Data above 2G! %p", data);
+		return 0;
+	}
+
+	/* Verify that the subchannel has been enabled */
+	ret = stsch(test_device_sid, &schib);
+	if (ret) {
+		report(0, "Err %d on stsch on sid %08x", ret, test_device_sid);
+		return 0;
+	}
+	if (!(p->flags & PMCW_ENABLE)) {
+		report_skip("Device (sid %08x) not enabled", test_device_sid);
+		return 0;
+	}
+
+	report_prefix_push("ssch");
+	/* Build the CCW chain with a single CCW */
+	ccw[0].code = code;
+	ccw[0].flags = 0; /* No flags need to be set */
+	ccw[0].count = count;
+	ccw[0].data_address = (int)(unsigned long)data;
+	orb_p->intparm = CSS_TEST_INT_PARAM;
+	orb_p->ctrl = ORB_F_INIT_IRQ|ORB_F_FORMAT|ORB_F_LPM_DFLT;
+	if ((unsigned long)&ccw[0] >= 0x80000000UL) {
+		report(0, "CCW above 2G! %016lx", (unsigned long)&ccw[0]);
+		report_prefix_pop();
+		return 0;
+	}
+	orb_p->cpa = (unsigned int) (unsigned long)&ccw[0];
+
+	ret = ssch(test_device_sid, orb_p);
+	if (ret) {
+		report(0, "ssch cc=%d", ret);
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
+ * - device by the enumeration.
+ * - ./s390x-run s390x/css.elf -device ccw-pong,cu_type=0xc0ca
+ */
+static void test_sense(void)
+{
+	int ret;
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
+	ret = start_subchannel(CCW_CMD_SENSE_ID, buffer, sizeof(senseid));
+	if (!ret) {
+		report(0, "start_subchannel failed");
+		goto unreg_cb;
+	}
+
+	delay(100);
+	if (lowcore->io_int_param != CSS_TEST_INT_PARAM) {
+		report(0, "cu_type: expect 0x%08x, got 0x%08x",
+		       CSS_TEST_INT_PARAM, lowcore->io_int_param);
+		goto unreg_cb;
+	}
+
+	senseid.cu_type = buffer[2] | (buffer[1] << 8);
+
+	/* Sense ID is non packed cut_type is at offset +1 byte */
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

