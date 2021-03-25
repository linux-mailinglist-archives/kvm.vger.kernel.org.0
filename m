Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CDC348D34
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 10:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhCYJj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 05:39:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230095AbhCYJjQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 05:39:16 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P9XqZJ051072
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=ADsoEua9Tz+ORrO6hrA0iCPun3X2ZppWNbCpldeATDs=;
 b=oPAThf2/Ply2ck5AkFozGMMJsEArrq7TBDhe5KF74LG2ecfpDcewPLlNFsW4QNMUY3fL
 wWPufgp+EIasEAGScAw1jpeDu5CjMEdjv10Lq1OV4zNhzVXr3/C+BNycItqsmgrLv/cw
 i2be7/CcXW4/OVMWH5fPStklmKdM1MUl4xfjuCp8cL0rR5/xvXrwxTEtmNS8qgWKj7Ou
 9JxZ2ONABDFxsj6bmLqYSYaGh3ffd3u2jqBWJ3UExo1oLIFVzgefTVLTIEKN1IiyttjC
 wwPWkZqz59LXZ7oD+cTl460bNFOCMsNJDwgwx19cgpTCpFXN/sZNKg/91TyOoLwtqKiK tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gq0b1v6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:16 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12P9Xs5e051331
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:15 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gq0b1v62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 05:39:15 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12P9RLQJ018318;
        Thu, 25 Mar 2021 09:39:14 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 37d9d8tqqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:39:14 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12P9dBQY19202334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 09:39:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4047B11C04C;
        Thu, 25 Mar 2021 09:39:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F28A311C05B;
        Thu, 25 Mar 2021 09:39:10 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 09:39:10 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 7/8] s390x: css: testing halt subchannel
Date:   Thu, 25 Mar 2021 10:39:06 +0100
Message-Id: <1616665147-32084-8-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_02:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=816 phishscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

checking return values for HSCH for various configurations.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  4 ++++
 lib/s390x/css_lib.c |  4 ++++
 s390x/css.c         | 57 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index e1e9264..cf48abc 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -93,6 +93,10 @@ struct scsw {
 #define SCSW_SSCH_COMPLETED	(SCSW_CCW_FORMAT | SCSW_FC_START | \
 				 SCSW_SC_PENDING | SCSW_SC_SECONDARY | \
 				 SCSW_SC_PRIMARY)
+#define SCSW_HSCH_COMPLETED	(SCSW_CCW_FORMAT | SCSW_FC_HALT | \
+				 SCSW_SC_PENDING)
+#define SCSW_CSCH_COMPLETED	(SCSW_CCW_FORMAT | SCSW_FC_CLEAR | \
+				 SCSW_SC_PENDING)
 	uint32_t ctrl;
 	uint32_t ccw_addr;
 #define SCSW_DEVS_DEV_END	0x04
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 7c93e94..d9ed2c3 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -533,6 +533,10 @@ int check_io_completion(int schid, uint32_t ctrl)
 		goto end;
 	}
 
+	/* We do not need more check for HSCH or CSCH */
+	if (irb.scsw.ctrl & (SCSW_FC_HALT | SCSW_FC_CLEAR))
+		goto end;
+
 	if (!(irb.scsw.ctrl & (SCSW_SC_SECONDARY | SCSW_SC_PRIMARY))) {
 		report(0, "Primary or secondary status missing. Subch Ctrl: %08x",
 		       irb.scsw.ctrl);
diff --git a/s390x/css.c b/s390x/css.c
index f6890f2..ffc067e 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -56,6 +56,62 @@ static void test_enable(void)
 	report(cc == 0, "Enable subchannel %08x", test_device_sid);
 }
 
+static void test_hsch(void)
+{
+	struct orb orb = {
+		.intparm = test_device_sid,
+		.ctrl = ORB_CTRL_ISIC | ORB_CTRL_FMT | ORB_LPM_DFLT,
+	};
+	struct ccw1 *ccw;
+
+	NODEV_SKIP(test_device_sid);
+
+	senseid = alloc_io_mem(sizeof(*senseid), 0);
+	assert(senseid);
+	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
+	assert(ccw);
+	orb.cpa = (uint64_t)ccw;
+
+	/* 1- Basic HSCH */
+	report_prefix_push("HSCH on a quiet subchannel");
+	assert(css_enable(test_device_sid, 0) == 0);
+	report(hsch(test_device_sid) == 0, "subchannel halted");
+	report_prefix_pop();
+
+	/* now we check the flags */
+	report_prefix_push("Ctrl flags");
+	assert(tsch(test_device_sid, &irb) == 0);
+	report(check_io_completion(test_device_sid, SCSW_HSCH_COMPLETED) == 0, "expected");
+	report_prefix_pop();
+
+	/* 2- Check HSCH after SSCH */
+	report_prefix_push("HSCH on status pending subchannel");
+	assert(ssch(test_device_sid, &orb) == 0);
+	report(hsch(test_device_sid) == 1, "Halt subchannel should fail with CC 1");
+	assert(tsch(test_device_sid, &irb) == 0);
+	check_io_completion(test_device_sid, SCSW_SSCH_COMPLETED);
+	report_prefix_pop();
+
+	/* 3- Check HSCH after CSCH */
+	report_prefix_push("HSCH on busy on CSCH subchannel");
+	assert(csch(test_device_sid) == 0);
+	report(hsch(test_device_sid) == 1, "Halt subchannel should fail with CC 1");
+	assert(tsch(test_device_sid, &irb) == 0);
+	check_io_completion(test_device_sid, SCSW_CSCH_COMPLETED);
+	report_prefix_pop();
+
+	/* 4- Check HSCH after HSCH */
+	report_prefix_push("HSCH on busy on HSCH subchannel");
+	assert(hsch(test_device_sid) == 0);
+	report(hsch(test_device_sid) == 1, "Halt subchannel should fail with CC 1");
+	assert(tsch(test_device_sid, &irb) == 0);
+	check_io_completion(test_device_sid, SCSW_HSCH_COMPLETED);
+	report_prefix_pop();
+
+	free_io_mem(senseid, sizeof(*senseid));
+	free_io_mem(ccw, sizeof(*ccw));
+}
+
 static void test_ssch(void)
 {
 	struct orb orb = {
@@ -439,6 +495,7 @@ static struct {
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
 	{ "start subchannel", test_ssch },
+	{ "halt subchannel", test_hsch },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
-- 
2.17.1

