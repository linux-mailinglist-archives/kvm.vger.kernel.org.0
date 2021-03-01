Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FBE327D88
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 12:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbhCALsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 06:48:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3684 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234208AbhCALr6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 06:47:58 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121Bb8gj027252
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 06:47:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=vN8FGrMViRuF0A48KejdsIHqw0H3h1UbujVuInQMUkU=;
 b=gFAp3zJNsUJX9zAge7Ug+42dHXQ1DpGfXBnnCJpYi0n1cHGVzow7+Dgj6tEgcsDUGtF4
 0q6Vk7n91cuwY9vtKlyNaakNha149p2jfXLLyLlKhIh/RbJ4iciHQlWgGLB9Yj42uv54
 sonnBqQ1u+BYIucP+k5oqJ9dVbmBBes9Ec4NzY8FKCL6Ux80qoSoDEAb3HFSh3Dh73sJ
 ER7DjqT36woHD/siZuQhntHx/83kpSc7Or0hj2FGNzoMG/RCpr8OlHcvNjcJdC6c1RUa
 wUjlbuGs+Ja28OlTaE/7wCeeCZeMUJHNPlyRqoLsTa5uQOPfv33MEYIq/g1Wk5HSN4xK 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 370v7xy828-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 06:47:14 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 121BbD6f027664
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 06:47:13 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 370v7xy81t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 06:47:13 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 121BgtJu010381;
        Mon, 1 Mar 2021 11:47:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 36ydq88xv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 11:47:11 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 121Bl9G540960438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Mar 2021 11:47:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E59BAE056;
        Mon,  1 Mar 2021 11:47:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0787AE045;
        Mon,  1 Mar 2021 11:47:08 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.52.26])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Mar 2021 11:47:08 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 5/6] s390x: css: testing measurement block format 0
Date:   Mon,  1 Mar 2021 12:47:04 +0100
Message-Id: <1614599225-17734-6-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_05:2021-02-26,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We test the update of the measurement block format 0, the
measurement block origin is calculated from the mbo argument
used by the SCHM instruction and the offset calculated using
the measurement block index of the SCHIB.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h | 12 +++++++++
 s390x/css.c     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index b8ac363..40f9efa 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -375,4 +375,16 @@ static inline void schm(void *mbo, unsigned int flags)
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
index e8f96f3..3915ed3 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -184,6 +184,71 @@ static void test_schm(void)
 	report_prefix_pop();
 }
 
+#define SCHM_UPDATE_CNT 10
+static bool start_measuring(uint64_t mbo, uint16_t mbi, bool fmt1)
+{
+	int i;
+
+	if (!css_enable_mb(test_device_sid, mbo, mbi, PMCW_MBUE, fmt1)) {
+		report(0, "Enabling measurement_block_format");
+		return false;
+	}
+
+	for (i = 0; i < SCHM_UPDATE_CNT; i++) {
+		if (!do_test_sense()) {
+			report(0, "Error during sense");
+			return false;
+		}
+	}
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
+	report(start_measuring(0, 1, false) &&
+	       mb0[1].ssch_rsch_count == SCHM_UPDATE_CNT,
+	       "SSCH measured %d", mb0[1].ssch_rsch_count);
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
@@ -194,6 +259,7 @@ static struct {
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
+	{ "measurement block format0", test_schm_fmt0 },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

