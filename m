Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF796348D31
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 10:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhCYJjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 05:39:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229461AbhCYJjO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 05:39:14 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P9Xp49051000
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=ZpyJi2Gq+gX3DUflwv+yFRHfQtDPzyYMP7ZyBf1wSPo=;
 b=IztsAevd6hb0QWtHKCyiNm/ujDr0teiX3+ACMQsqce/9qPNQ8jhCnNvhlkKpOpfuUCiv
 W5nI2FGCYrrUpEaM/8ACUitZL15IXZhG/7NIpD9oavHnV47FDodIwMNwxyI1cQAy7MFM
 Y+w59VqlNfKazZcVkguAg6Z4ZaeSCTEaeEcFTnoKFw6B0V0bXtMUzg6i/5VP4yebwjdA
 i/fT+X0PxLQFUPVbkj33vGnEobV+6HA2sK1JXCRGYDQyzKDupT0sBHpAw8YiznuViGAb
 asupvEyrO4z8T1yRcdTSIbh+FbYKGdN8xV6tdPg470G6aXj4wz367M68DCz3i39a1RjZ tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gq0b1v5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:14 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12P9XsWL051328
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:13 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gq0b1v4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 05:39:13 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12P9R9ml007119;
        Thu, 25 Mar 2021 09:39:12 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 37d99rd6y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:39:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12P9d9h935979544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 09:39:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D2AF11C054;
        Thu, 25 Mar 2021 09:39:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFF9611C05B;
        Thu, 25 Mar 2021 09:39:08 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 09:39:08 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/8] s390x: lib: css: disabling a subchannel
Date:   Thu, 25 Mar 2021 10:39:00 +0100
Message-Id: <1616665147-32084-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_02:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some tests require to disable a subchannel.
Let's implement the css_disable() function.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/css.h     |  1 +
 lib/s390x/css_lib.c | 67 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 7e3d261..b0de3a3 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -284,6 +284,7 @@ int css_enumerate(void);
 #define IO_SCH_ISC      3
 int css_enable(int schid, int isc);
 bool css_enabled(int schid);
+int css_disable(int schid);
 
 /* Library functions */
 int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index efc7057..f5c4f37 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -186,6 +186,73 @@ bool css_enabled(int schid)
 	}
 	return true;
 }
+
+/*
+ * css_disable: disable the subchannel
+ * @schid: Subchannel Identifier
+ * Return value:
+ *   On success: 0
+ *   On error the CC of the faulty instruction
+ *      or -1 if the retry count is exceeded.
+ */
+int css_disable(int schid)
+{
+	struct pmcw *pmcw = &schib.pmcw;
+	int retry_count = 0;
+	int cc;
+
+	/* Read the SCHIB for this subchannel */
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
+		return cc;
+	}
+
+	if (!(pmcw->flags & PMCW_ENABLE)) {
+		report_info("stsch: sch %08x already disabled", schid);
+		return 0;
+	}
+
+retry:
+	/* Update the SCHIB to disable the subchannel */
+	pmcw->flags &= ~PMCW_ENABLE;
+
+	/* Tell the CSS we want to modify the subchannel */
+	cc = msch(schid, &schib);
+	/*
+	 * If the subchannel is status pending or if a function is in progress,
+	 * we consider both cases as errors.
+	 */
+	if (cc) {
+		report_info("msch: sch %08x failed with cc=%d", schid, cc);
+		return cc;
+	}
+
+	/* Read the SCHIB again to verify the enablement */
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report_info("stsch: updating sch %08x failed with cc=%d",
+			    schid, cc);
+		return cc;
+	}
+
+	if (!(pmcw->flags & PMCW_ENABLE)) {
+		if (retry_count)
+			report_info("stsch: sch %08x successfully disabled after %d retries",
+				    schid, retry_count);
+		return 0;
+	}
+
+	if (retry_count++ < MAX_ENABLE_RETRIES) {
+		/* the hardware was not ready, give it some time */
+		mdelay(10);
+		goto retry;
+	}
+
+	report_info("msch: modifying sch %08x failed after %d retries. pmcw flags: %04x",
+		    schid, retry_count, pmcw->flags);
+	return -1;
+}
 /*
  * css_enable: enable the subchannel with the specified ISC
  * @schid: Subchannel Identifier
-- 
2.17.1

