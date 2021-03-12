Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D86338A6F
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 11:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbhCLKmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 05:42:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233497AbhCLKmE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 05:42:04 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CAXwN8161289
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=P50ZHWrN4azW1++K3SjCB1h07TxgYC6u/usi7dsMzlE=;
 b=o5CH6b7I2Pg8PPMJ6RgJUR5XOaOAhCOonfQEwwAhZl+kf8KlyY5MZ4wOx+HhrKVoNQm/
 bZq3cWc7sJ1tHLTjp6yQFng/bR2hMR2KDD4RW6GabNJ9jPXeHywC2d41lAfxFaM8Gswz
 vLVPXuwcgq/gIIcAtQ0QPfOBHn62eF0Hy62B5SLclWUsvUx4CR89o4ssAtmAdldlJNlp
 vMCvdRw8PFkxki+QPnxMqJyY+b9XW6e+DUK6i92upVu66a1I5n/cVPFj13YNtZJ1uSmH
 NhcjMsVT25AifAjixN1rhahhBen8RPROh0V+zu7HENQtxnoTRcvja4Zf0NAhrwRXuyKK Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774kyjf77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:04 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12CAY7b9161691
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:03 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774kyjf5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 05:42:03 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12CAfp6a010330;
        Fri, 12 Mar 2021 10:42:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 376agr1dvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 10:42:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12CAfgfj37028230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 10:41:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9BB0AE051;
        Fri, 12 Mar 2021 10:41:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 670FAAE04D;
        Fri, 12 Mar 2021 10:41:57 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.32.251])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Mar 2021 10:41:57 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v6 5/6] s390x: css: testing measurement block format 0
Date:   Fri, 12 Mar 2021 11:41:53 +0100
Message-Id: <1615545714-13747-6-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
References: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_03:2021-03-10,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We test the update of the measurement block format 0, the
measurement block origin is calculated from the mbo argument
used by the SCHM instruction and the offset calculated using
the measurement block index of the SCHIB.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h | 12 +++++++
 s390x/css.c     | 83 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 7158423..335bc70 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -374,4 +374,16 @@ static inline void schm(void *mbo, unsigned int flags)
 bool css_enable_mb(int sid, uint64_t mb, uint16_t mbi, uint16_t flg, bool fmt1);
 bool css_disable_mb(int schid);
 
+struct measurement_block_format0 {
+	uint16_t ssch_rsch_count;
+	uint16_t sample_count;
+	uint32_t device_connect_time;
+	uint32_t function_pending_time;
+	uint32_t device_disconnect_time;
+	uint32_t cu_queuing_time;
+	uint32_t device_active_only_time;
+	uint32_t device_busy_time;
+	uint32_t initial_cmd_resp_time;
+};
+
 #endif
diff --git a/s390x/css.c b/s390x/css.c
index af68266..658c5f8 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -133,6 +133,13 @@ error_ccw:
 	free_io_mem(senseid, sizeof(*senseid));
 }
 
+static void sense_id(void)
+{
+	assert(!start_ccw1_chain(test_device_sid, ccw));
+
+	assert(wait_and_check_io_completion(test_device_sid) >= 0);
+}
+
 static void css_init(void)
 {
 	assert(register_io_int_func(css_irq_io) == 0);
@@ -175,6 +182,81 @@ static void test_schm(void)
 	report_prefix_pop();
 }
 
+#define SCHM_UPDATE_CNT 10
+static bool start_measuring(uint64_t mbo, uint16_t mbi, bool fmt1)
+{
+	int i;
+
+	senseid = alloc_io_mem(sizeof(*senseid), 0);
+	assert(senseid);
+
+	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
+	assert(ccw);
+
+	if (!css_enable_mb(test_device_sid, mbo, mbi, PMCW_MBUE, fmt1)) {
+		report_abort("Enabling measurement block failed");
+		return false;
+	}
+
+	for (i = 0; i < SCHM_UPDATE_CNT; i++)
+		sense_id();
+
+	free_io_mem(ccw, sizeof(*ccw));
+	free_io_mem(senseid, sizeof(*senseid));
+
+	return true;
+}
+
+/*
+ * test_schm_fmt0:
+ * With measurement block format 0 a memory space is shared
+ * by all subchannels, each subchannel can provide an index
+ * for the measurement block facility to store the measurements.
+ */
+static void test_schm_fmt0(void)
+{
+	struct measurement_block_format0 *mb0;
+	int shared_mb_size = 2 * sizeof(struct measurement_block_format0);
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+
+	/* Allocate zeroed Measurement block */
+	mb0 = alloc_io_mem(shared_mb_size, 0);
+	if (!mb0) {
+		report_abort("measurement_block_format0 allocation failed");
+		return;
+	}
+
+	schm(NULL, 0); /* Stop any previous measurement */
+	schm(mb0, SCHM_MBU);
+
+	/* Expect success */
+	report_prefix_push("Valid MB address and index 0");
+	report(start_measuring(0, 0, false) &&
+	       mb0->ssch_rsch_count == SCHM_UPDATE_CNT,
+	       "SSCH measured %d", mb0->ssch_rsch_count);
+	report_prefix_pop();
+
+	/* Clear the measurement block for the next test */
+	memset(mb0, 0, shared_mb_size);
+
+	/* Expect success */
+	report_prefix_push("Valid MB address and index 1");
+	if (start_measuring(0, 1, false))
+		report(mb0[1].ssch_rsch_count == SCHM_UPDATE_CNT,
+		       "SSCH measured %d", mb0[1].ssch_rsch_count);
+	report_prefix_pop();
+
+	/* Stop the measurement */
+	css_disable_mb(test_device_sid);
+	schm(NULL, 0);
+
+	free_io_mem(mb0, shared_mb_size);
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -185,6 +267,7 @@ static struct {
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
+	{ "measurement block format0", test_schm_fmt0 },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

