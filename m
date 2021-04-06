Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5588354E0B
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244343AbhDFHlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52976 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235572AbhDFHlK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:10 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367X7vR110012
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=VFoUUrvFXfI2LyAPUOKNzCd6iTo7zXv/QMVgpAYKuy4=;
 b=Zcvoyk0aKuFqXEZvfB8i5OaPz/gWSzEGB5rnDBX/Ndih7U07NN8yBlVasvUTuGJ3gssJ
 4hMDz8dCvoLRiaP0UrwQ6v/7DLR3+YiIC65inH2YCbyKTXhI51XgcTS9XKDp1+bP/2fu
 3omyd30RYMJ0Lt82tST0/9O9ALOcUx1HsHcDpjgZyFnpksNsEdcvl7AFK1zl06dY5ad1
 hVc2xT+vhpsBAVFfhQUZq4FF546BV88IDTToKk14nUb45/J+LK+Xr040ksxSd6WhmDJ2
 ndk4laVo4ubqQqkS4P1pmEAs/Sm6dchAqV7qRItGO5DOR6XJR3aEUtVSZeUhDfSkOPGN JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5kxjr35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:02 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367YaPm116928
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:01 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5kxjr2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:01 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367Wocd026267;
        Tue, 6 Apr 2021 07:41:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 37q2y9hwta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:41:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367evH445679022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 262A04C04A;
        Tue,  6 Apr 2021 07:40:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEA784C05E;
        Tue,  6 Apr 2021 07:40:56 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:56 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 06/16] s390x: lib: css: checking I/O errors
Date:   Tue,  6 Apr 2021 09:40:43 +0200
Message-Id: <1617694853-6881-7-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cc7eogare2kaHRTsuQACXaYKUkIzzcIc
X-Proofpoint-GUID: jJ3bPw-PErGiacrzFBN-CR0csp7HEW2a
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When testing I/O transaction with bad addresses we need to check
the result of the error when the I/O completed with an alert status.
The resulting status is reported in the subchannel and device
status of the IRB SCSW.

Let's provide the tests the possibility to check if the device
and the subchannel status of the IRB SCSW are set as expected.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  6 ++++--
 lib/s390x/css_lib.c | 24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 1603781..a5a8427 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -95,8 +95,9 @@ struct scsw {
 #define SCSW_DEVS_DEV_END	0x04
 #define SCSW_DEVS_SCH_END	0x08
 	uint8_t  dev_stat;
-#define SCSW_SCHS_PCI	0x80
-#define SCSW_SCHS_IL	0x40
+#define SCSW_SCHS_PCI		0x80
+#define SCSW_SCHS_IL		0x40
+#define SCSW_SCHS_PRG_CHK	0x20
 	uint8_t  sch_stat;
 	uint16_t count;
 };
@@ -318,6 +319,7 @@ int css_residual_count(unsigned int schid);
 void enable_io_isc(uint8_t isc);
 int wait_and_check_io_completion(int schid, uint32_t ctrl);
 int check_io_completion(int schid, uint32_t ctrl);
+bool check_io_errors(int schid, uint8_t dev_stat, uint8_t sch_stat);
 
 /*
  * CHSC definitions
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 97bf032..65159aa 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -552,6 +552,30 @@ end:
 	return ret;
 }
 
+/* check_io_errors:
+ * @schid: the subchannel ID
+ * @dev_stat : expected device stat flags
+ * @sch_stat : expected subchannel stat flags
+ *
+ * This routine must be called when an error occurs on CSS I/O
+ * Only report failures information and returns if we found
+ * the expected status flags.
+ */
+bool check_io_errors(int schid, uint8_t dev_stat, uint8_t sch_stat)
+{
+	if (!(irb.scsw.ctrl & SCSW_SC_ALERT)) {
+		report_info("No alert in SCSW Ctrl: %s", dump_scsw_flags(irb.scsw.ctrl));
+		report_info("schid %08x : dev_stat: %02x sch_stat: %02x", schid, irb.scsw.dev_stat, irb.scsw.sch_stat);
+		return false;
+	}
+
+	if ((dev_stat != irb.scsw.dev_stat) || (sch_stat != irb.scsw.sch_stat)) {
+		report_info("schid %08x : dev_stat: %02x sch_stat: %02x", schid, irb.scsw.dev_stat, irb.scsw.sch_stat);
+		return false;
+	}
+	return true;
+}
+
 /*
  * css_residual_count
  * Return the residual count, if it is valid.
-- 
2.17.1

