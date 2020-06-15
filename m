Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7955E1F938A
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 11:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbgFOJch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 05:32:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729284AbgFOJcN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 05:32:13 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05F83gHc050172;
        Mon, 15 Jun 2020 05:32:12 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31n301qwj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 05:32:12 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05F8qE5D029843;
        Mon, 15 Jun 2020 05:32:12 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31n301qwh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 05:32:12 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05F9M1DT013399;
        Mon, 15 Jun 2020 09:32:09 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 31mpe7u8wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 09:32:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05F9Uokg57278828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 09:30:50 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 730D952054;
        Mon, 15 Jun 2020 09:32:07 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.1.141])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1EE1A5204F;
        Mon, 15 Jun 2020 09:32:07 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v9 11/12] s390x: css: msch, enable test
Date:   Mon, 15 Jun 2020 11:32:00 +0200
Message-Id: <1592213521-19390-12-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_01:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 cotscore=-2147483648 bulkscore=0 mlxscore=0 suspectscore=1 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A second step when testing the channel subsystem is to prepare a channel
for use.
This includes:
- Get the current subchannel Information Block (SCHIB) using STSCH
- Update it in memory to set the ENABLE bit
- Tell the CSS that the SCHIB has been modified using MSCH
- Get the SCHIB from the CSS again to verify that the subchannel is
  enabled.
- If the command succeeds but subchannel is not enabled retry a
  predefined retries count.
- If the command fails, report the failure and do not retry, even
  if cc indicates a busy/status pending as we do not expect this.

This tests the MSCH instruction to enable a channel succesfuly.
This some retries are done and in case of error, and if the retries
count is exceeded, a report is made.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css_lib.c | 60 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/css.c         | 15 ++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index b0a0294..06a76db 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -15,6 +15,7 @@
 #include <string.h>
 #include <interrupt.h>
 #include <asm/arch_def.h>
+#include <asm/time.h>
 
 #include <css.h>
 
@@ -68,3 +69,62 @@ out:
 		    scn, scn_found, dev_found);
 	return schid;
 }
+
+int css_enable(int schid)
+{
+	struct pmcw *pmcw = &schib.pmcw;
+	int retry_count = 0;
+	int cc;
+
+	/* Read the SCHIB for this subchannel */
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report_info("stsch failed with cc=%d", cc);
+		return cc;
+	}
+
+	if (pmcw->flags & PMCW_ENABLE) {
+		report_info("stsch: sch %08x already enabled", schid);
+		return 0;
+	}
+
+retry:
+	/* Update the SCHIB to enable the channel */
+	pmcw->flags |= PMCW_ENABLE;
+
+	/* Tell the CSS we want to modify the subchannel */
+	cc = msch(schid, &schib);
+	if (cc) {
+		/*
+		 * If the subchannel is status pending or
+		 * if a function is in progress,
+		 * we consider both cases as errors.
+		 */
+		report_info("msch failed with cc=%d", cc);
+		return cc;
+	}
+
+	/*
+	 * Read the SCHIB again to verify the enablement
+	 */
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report_info("stsch failed with cc=%d", cc);
+		return cc;
+	}
+
+	if (pmcw->flags & PMCW_ENABLE) {
+		report_info("Subchannel %08x enabled after %d retries",
+			    schid, retry_count);
+		return 0;
+	}
+
+	if (retry_count++ < MAX_ENABLE_RETRIES) {
+		mdelay(10); /* the hardware was not ready, give it some time */
+		goto retry;
+	}
+
+	report_info("msch: enabling sch %08x failed after %d retries. pmcw flags: %x",
+		    schid, retry_count, pmcw->flags);
+	return -1;
+}
diff --git a/s390x/css.c b/s390x/css.c
index 230adf5..6948d73 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -31,11 +31,26 @@ static void test_enumerate(void)
 	report(0, "No I/O device found");
 }
 
+static void test_enable(void)
+{
+	int cc;
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+
+	cc = css_enable(test_device_sid);
+
+	report(cc == 0, "Enable subchannel %08x", test_device_sid);
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
 } tests[] = {
 	{ "enumerate (stsch)", test_enumerate },
+	{ "enable (msch)", test_enable },
 	{ NULL, NULL }
 };
 
-- 
2.25.1

