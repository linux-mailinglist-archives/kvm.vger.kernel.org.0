Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD0D327D87
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 12:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbhCALsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 06:48:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20752 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234193AbhCALr6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 06:47:58 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121Bb9JD027315
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 06:47:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=qaYjIdp+FNXHdRzGaWlqyVjdD/RwGrqYo8RNQ4dX64g=;
 b=qOKX4Ogj28OLC7r5rSAPAXkv4CBIzXBHJXrGbH9+ZBWhVmYsXnf7qRj0FVVIhu1jIo5q
 TuPtvw45Tfks4ljTtJORq55APlLz8CTZCtaVonHK36EfvF7FP8V9Pv1QaVJtg/3d1dKg
 iOZ8K7rqAd0xNxuVRT3mgrqZwejkD5mts/hQx1Vb1Dl7klVnk1XsKo5y2KF0v1wYaIdG
 c7TGjcvRtdB4KbLIsCPuoHaj5jeiTg1KNqmSmehnmJ7GDiOwtzsesxN7oonK18/+jFSv
 s/LIaYtlyynO7YKNjfmceEEv4Q4yPTSPczgaz+lnApBOG7XkliV7XkRNDomdsBKYX1cs 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 370v7xy822-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 06:47:13 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 121BbHmE028208
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 06:47:13 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 370v7xy81j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 06:47:12 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 121BhQMh018480;
        Mon, 1 Mar 2021 11:47:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 36ydq89tqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 11:47:11 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 121BksfX34275782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Mar 2021 11:46:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32758AE053;
        Mon,  1 Mar 2021 11:47:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2162AE051;
        Mon,  1 Mar 2021 11:47:07 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.52.26])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Mar 2021 11:47:07 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 3/6] s390x: css: extending the subchannel modifying functions
Date:   Mon,  1 Mar 2021 12:47:02 +0100
Message-Id: <1614599225-17734-4-git-send-email-pmorel@linux.ibm.com>
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

To enable or disable measurement we will need specific
modifications on the subchannel.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/css.h     |   9 +++-
 lib/s390x/css_lib.c | 100 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index fbfa034..1cb3de2 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -82,6 +82,8 @@ struct pmcw {
 	uint32_t intparm;
 #define PMCW_DNV	0x0001
 #define PMCW_ENABLE	0x0080
+#define PMCW_MBUE	0x0010
+#define PMCW_DCTME	0x0008
 #define PMCW_ISC_MASK	0x3800
 #define PMCW_ISC_SHIFT	11
 	uint16_t flags;
@@ -94,6 +96,7 @@ struct pmcw {
 	uint8_t  pom;
 	uint8_t  pam;
 	uint8_t  chpid[8];
+#define PMCW_MBF1	0x0004
 	uint32_t flags2;
 };
 #define PMCW_CHANNEL_TYPE(pmcw) (pmcw->flags2 >> 21)
@@ -101,7 +104,8 @@ struct pmcw {
 struct schib {
 	struct pmcw pmcw;
 	struct scsw scsw;
-	uint8_t  md[12];
+	uint64_t mbo;
+	uint8_t  md[4];
 } __attribute__ ((aligned(4)));
 
 struct irb {
@@ -356,4 +360,7 @@ bool chsc(void *p, uint16_t code, uint16_t len);
 #define css_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
 #define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
 
+bool css_enable_mb(int sid, uint64_t mb, uint16_t mbi, uint16_t flg, bool fmt1);
+bool css_disable_mb(int schid);
+
 #endif
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 41134dc..77b39c7 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -248,6 +248,106 @@ retry:
 	return -1;
 }
 
+/*
+ * schib_update_mb: update the subchannel Measurement Block
+ * @schid: Subchannel Identifier
+ * @mb   : 64bit address of the measurement block
+ * @mbi : the measurement block offset
+ * @flags : PMCW_MBUE to enable measurement block update
+ *	    PMCW_DCTME to enable device connect time
+ *	    0 to disable measurement
+ * @format1: set if format 1 is to be used
+ */
+static bool schib_update_mb(int schid, uint64_t mb, uint16_t mbi,
+			    uint16_t flags, bool format1)
+{
+	struct pmcw *pmcw = &schib.pmcw;
+	int cc;
+
+	/* Read the SCHIB for this subchannel */
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
+		return false;
+	}
+
+	/* Update the SCHIB to enable the measurement block */
+	if (flags) {
+		pmcw->flags |= flags;
+
+		if (format1)
+			pmcw->flags2 |= PMCW_MBF1;
+		else
+			pmcw->flags2 &= ~PMCW_MBF1;
+
+		pmcw->mbi = mbi;
+		schib.mbo = mb & ~0x3f;
+	} else {
+		pmcw->flags &= ~(PMCW_MBUE | PMCW_DCTME);
+	}
+
+	/* Tell the CSS we want to modify the subchannel */
+	cc = msch(schid, &schib);
+	if (cc) {
+		/*
+		 * If the subchannel is status pending or
+		 * if a function is in progress,
+		 * we consider both cases as errors.
+		 */
+		report_info("msch: sch %08x failed with cc=%d", schid, cc);
+		return false;
+	}
+
+	/*
+	 * Read the SCHIB again
+	 */
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report_info("stsch: updating sch %08x failed with cc=%d",
+			    schid, cc);
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * css_enable_mb: enable the subchannel Measurement Block
+ * @schid: Subchannel Identifier
+ * @mb   : 64bit address of the measurement block
+ * @format1: set if format 1 is to be used
+ * @mbi : the measurement block offset
+ * @flags : PMCW_MBUE to enable measurement block update
+ *	    PMCW_DCTME to enable device connect time
+ */
+bool css_enable_mb(int schid, uint64_t mb, uint16_t mbi, uint16_t flags,
+		   bool format1)
+{
+	int retry_count = MAX_ENABLE_RETRIES;
+	struct pmcw *pmcw = &schib.pmcw;
+
+	while (retry_count-- &&
+	       !schib_update_mb(schid, mb, mbi, flags, format1))
+		mdelay(10); /* the hardware was not ready, give it some time */
+
+	return schib.mbo == mb && pmcw->mbi == mbi;
+}
+
+/*
+ * css_disable_mb: disable the subchannel Measurement Block
+ * @schid: Subchannel Identifier
+ */
+bool css_disable_mb(int schid)
+{
+	int retry_count = MAX_ENABLE_RETRIES;
+
+	while (retry_count-- &&
+	       !schib_update_mb(schid, 0, 0, 0, 0))
+		mdelay(10); /* the hardware was not ready, give it some time */
+
+	return retry_count > 0;
+}
+
 static struct irb irb;
 
 void css_irq_io(void)
-- 
2.17.1

