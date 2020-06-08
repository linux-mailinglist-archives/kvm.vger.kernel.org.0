Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131D01F143B
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 10:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgFHINU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 04:13:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33072 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729121AbgFHINO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 04:13:14 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05883BaA045554;
        Mon, 8 Jun 2020 04:13:13 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g74svuar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 04:13:12 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05883a7Y047402;
        Mon, 8 Jun 2020 04:13:12 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g74svu9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 04:13:12 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05885Gs5027598;
        Mon, 8 Jun 2020 08:13:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 31g2s7uh78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 08:13:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0588D8DB3342836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jun 2020 08:13:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AFE84C044;
        Mon,  8 Jun 2020 08:13:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA2584C050;
        Mon,  8 Jun 2020 08:13:07 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.43.245])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jun 2020 08:13:07 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v8 12/12] s390x: css: ssch/tsch with sense and interrupt
Date:   Mon,  8 Jun 2020 10:13:01 +0200
Message-Id: <1591603981-16879-13-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_03:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 adultscore=0 priorityscore=1501 suspectscore=1
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080057
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After a channel is enabled we start a SENSE_ID command using
the SSCH instruction to recognize the control unit and device.

This tests the success of SSCH, the I/O interruption and the TSCH
instructions.

The SENSE_ID command response is tested to report 0xff inside
its reserved field and to report the same control unit type
as the cu_type kernel argument.

Without the cu_type kernel argument, the test expects a device
with a default control unit type of 0x3832, a.k.a virtio-net-ccw.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  20 ++++++
 lib/s390x/css_lib.c |  46 ++++++++++++++
 s390x/css.c         | 149 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 214 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 33caaa0..2a01f05 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -101,6 +101,19 @@ struct irb {
 	uint32_t emw[8];
 } __attribute__ ((aligned(4)));
 
+#define CCW_CMD_SENSE_ID	0xe4
+#define CSS_SENSEID_COMMON_LEN	8
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
@@ -254,4 +267,11 @@ int css_enumerate(void);
 #define MAX_ENABLE_RETRIES      5
 int css_enable(int schid);
 
+
+/* Library functions */
+int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
+int start_subchannel(unsigned int sid, int code, void *data, int count,
+		     unsigned char flags);
+int sch_read_len(int sid);
+
 #endif
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 831a116..935af49 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -128,3 +128,49 @@ retry:
 		    schid, retry_count, pmcw->flags);
 	return -1;
 }
+
+int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw)
+{
+	struct orb orb = {
+		.intparm = sid,
+		.ctrl = ORB_CTRL_ISIC|ORB_CTRL_FMT|ORB_LPM_DFLT,
+		.cpa = (unsigned int) (unsigned long)ccw,
+	};
+
+	return ssch(sid, &orb);
+}
+
+/*
+ * In the next revisions we will implement the possibility to handle
+ * CCW chains doing this we will need to work with ccw1 pointers.
+ * For now we only need a unique CCW.
+ */
+static struct ccw1 unique_ccw;
+
+int start_subchannel(unsigned int sid, int code, void *data, int count,
+		     unsigned char flags)
+{
+	int cc;
+	struct ccw1 *ccw = &unique_ccw;
+
+	report_prefix_push("start_senseid");
+	/* Build the CCW chain with a single CCW */
+	ccw->code = code;
+	ccw->flags = flags; /* No flags need to be set */
+	ccw->count = count;
+	ccw->data_address = (int)(unsigned long)data;
+
+	cc = start_ccw1_chain(sid, ccw);
+	if (cc) {
+		report(0, "start_ccw_chain failed ret=%d", cc);
+		report_prefix_pop();
+		return cc;
+	}
+	report_prefix_pop();
+	return 0;
+}
+
+int sch_read_len(int sid)
+{
+	return unique_ccw.count;
+}
diff --git a/s390x/css.c b/s390x/css.c
index 6f58d4a..79c997d 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -16,10 +16,26 @@
 #include <string.h>
 #include <interrupt.h>
 #include <asm/arch_def.h>
+#include <kernel-args.h>
 
 #include <css.h>
 
+#define DEFAULT_CU_TYPE		0x3832
+static unsigned long cu_type = DEFAULT_CU_TYPE;
+
+struct lowcore *lowcore = (void *)0x0;
+
 static int test_device_sid;
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
@@ -57,20 +73,151 @@ static void test_enable(void)
 		report(1, "Subchannel %08x enabled", test_device_sid);
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
+/*
+ * test_sense
+ * Pre-requisits:
+ * - We need the test device as the first recognized
+ *   device by the enumeration.
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
+	ret = css_enable(test_device_sid);
+	if (ret) {
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
+	memset(&senseid, 0, sizeof(senseid));
+	ret = start_subchannel(test_device_sid, CCW_CMD_SENSE_ID,
+			       &senseid, sizeof(senseid), CCW_F_SLI);
+	if (ret) {
+		report(0, "ssch failed for SENSE ID on sch %08x with cc %d",
+		       test_device_sid, ret);
+		goto unreg_cb;
+	}
+
+	wait_for_interrupt(PSW_MASK_IO);
+
+	ret = sch_read_len(test_device_sid);
+	if (ret < CSS_SENSEID_COMMON_LEN) {
+		report(0,
+		       "ssch succeeded for SENSE ID but report a too short length: %d",
+		       ret);
+		goto unreg_cb;
+	}
+
+	if (senseid.reserved != 0xff) {
+		report(0,
+		       "ssch succeeded for SENSE ID but reports garbage: %x",
+		       senseid.reserved);
+		goto unreg_cb;
+	}
+
+	if (lowcore->io_int_param != test_device_sid)
+		goto unreg_cb;
+
+	report_info("senseid length read: %d", ret);
+	report_info("reserved %02x cu_type %04x cu_model %02x dev_type %04x dev_model %02x",
+		    senseid.reserved, senseid.cu_type, senseid.cu_model,
+		    senseid.dev_type, senseid.dev_model);
+
+	report((senseid.cu_type == cu_type),
+	       "cu_type: expect 0x%04x got 0x%04x",
+	       (uint16_t) cu_type, senseid.cu_type);
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
 
+static unsigned long value;
+
 int main(int argc, char *argv[])
 {
-	int i;
+	int i, ret;
+
+	ret = kernel_arg(argc, argv, "cu_type=", &value);
+	if (!ret)
+		cu_type = (uint16_t)value;
+	else
+		report_info("Using cu_type default value: 0x%04lx", cu_type);
 
 	report_prefix_push("Channel Subsystem");
+	enable_io_isc();
 	for (i = 0; tests[i].name; i++) {
 		report_prefix_push(tests[i].name);
 		tests[i].func();
-- 
2.25.1

