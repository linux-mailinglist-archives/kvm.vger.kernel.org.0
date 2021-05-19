Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADCA38896B
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 10:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245198AbhESI3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 04:29:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12846 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245221AbhESI3I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 04:29:08 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14J8QXut190855;
        Wed, 19 May 2021 04:27:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/7fHZroyKfU8SZVt6NSn3aOB9/srw2XN+Jf9KaYE0Dc=;
 b=GmWZXUsBb6ngKvxWxU2oxg+j0SpV5wcvbjtgjLqCPbaGU5gKkyDQEphreDSGknzdvc20
 K3TpiAk1Leh6KryTB9K3SgpL4FJ46KM7gZTGShGcV8O1IE3YpMdYw9Ay/PZfa/MkKxWn
 ySTO3mUYpW+9bKlGV3vjaOhcA9zrq54zC7xL9u6OgnyvpJwucmZK9zVzBVNGG+lf3QtJ
 GlWTLjNySSgqo31IgjtAZl8ITEwGoLuTNPkI18d2Rir9He1lW07YTZHiC4l797ql+Oge
 pvtr2ebjleUh61nYk1DHY94lxFUGBiUuW75Qc6kU/VX/j/f+Tx3cy6VF//q1qQbyZdOI qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38my5vg13b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:27:48 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14J8QeTE191165;
        Wed, 19 May 2021 04:27:48 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38my5vg12h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:27:48 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14J8RkWn016742;
        Wed, 19 May 2021 08:27:46 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 38m19srf82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 08:27:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14J8REA334668820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 08:27:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0C344203F;
        Wed, 19 May 2021 08:27:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AFB342042;
        Wed, 19 May 2021 08:27:42 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 May 2021 08:27:41 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/3] s390x: cpumodel: FMT2 and FMT4 SCLP test
Date:   Wed, 19 May 2021 08:26:48 +0000
Message-Id: <20210519082648.46803-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519082648.46803-1-frankja@linux.ibm.com>
References: <20210519082648.46803-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _z8RXeMMoPlIMk26WEZ4iDL3rOD0myLp
X-Proofpoint-ORIG-GUID: fccSkQblVWqcjtPS-Ss7vxYLqMbJo_U1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_02:2021-05-18,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SCLP is also part of the cpumodel, so we need to make sure that the
features indicated via read info / read cpu info are correct.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 s390x/cpumodel.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
index 4dd8b96f..67bb6543 100644
--- a/s390x/cpumodel.c
+++ b/s390x/cpumodel.c
@@ -2,14 +2,81 @@
 /*
  * Test the known dependencies for facilities
  *
- * Copyright 2019 IBM Corp.
+ * Copyright 2019, 2021 IBM Corp.
  *
  * Authors:
  *    Christian Borntraeger <borntraeger@de.ibm.com>
+ *    Janosch Frank <frankja@linux.ibm.com>
  */
 
 #include <asm/facility.h>
 #include <vm.h>
+#include <sclp.h>
+#include <uv.h>
+#include <asm/uv.h>
+
+static void test_sclp_missing_sief2_implications(void)
+{
+	/* Virtualization related facilities */
+	report(!sclp_facilities.has_64bscao, "!64bscao");
+	report(!sclp_facilities.has_pfmfi, "!pfmfi");
+	report(!sclp_facilities.has_gsls, "!gsls");
+	report(!sclp_facilities.has_cmma, "!cmma");
+	report(!sclp_facilities.has_esca, "!esca");
+	report(!sclp_facilities.has_kss, "!kss");
+	report(!sclp_facilities.has_ibs, "!ibs");
+
+	/* Virtualization related facilities reported via CPU entries */
+	report(!sclp_facilities.has_sigpif, "!sigpif");
+	report(!sclp_facilities.has_sief2, "!sief2");
+	report(!sclp_facilities.has_skeyi, "!skeyi");
+	report(!sclp_facilities.has_siif, "!siif");
+	report(!sclp_facilities.has_cei, "!cei");
+	report(!sclp_facilities.has_ib, "!ib");
+}
+
+static void test_sclp_features_fmt4(void)
+{
+	/*
+	 * STFLE facilities are handled by the Ultravisor but SCLP
+	 * facilities are advertised by the hypervisor.
+	 */
+	report_prefix_push("PV guest implies");
+
+	/* General facilities */
+	report(!sclp_facilities.has_diag318, "!diag318");
+
+	/*
+	 * Virtualization related facilities, all of which are
+	 * unavailable because there's no virtualization support in a
+	 * protected guest.
+	 */
+	test_sclp_missing_sief2_implications();
+
+	report_prefix_pop();
+}
+
+static void test_sclp_features_fmt2(void)
+{
+	if (sclp_facilities.has_sief2)
+		return;
+
+	report_prefix_push("!sief2 implies");
+	test_sclp_missing_sief2_implications();
+	report_prefix_pop();
+}
+
+static void test_sclp_features(void)
+{
+	report_prefix_push("sclp");
+
+	if (uv_os_is_guest())
+		test_sclp_features_fmt4();
+	else
+		test_sclp_features_fmt2();
+
+	report_prefix_pop();
+}
 
 static struct {
 	int facility;
@@ -60,6 +127,8 @@ int main(void)
 	}
 	report_prefix_pop();
 
+	test_sclp_features();
+
 	report_prefix_pop();
 	return report_summary();
 }
-- 
2.30.2

