Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B129148E80D
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 11:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240245AbiANKEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 05:04:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26590 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240230AbiANKED (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 05:04:03 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20E9vMY6005792;
        Fri, 14 Jan 2022 10:04:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6YzQxXLxULPozQR2B75k8E9INuorwpI9TsEqOzM9S1A=;
 b=sWHtNp93WRyozlojlbLdfT57ygcTWNr9gyGFiMCdiW02yjc9n8YDHKJWcy+GbHAkeHGS
 OqGRjPa8IhlZQ/KPEFA8sDZjTIP3Sui5IyrsgcLCgNrsCpzVkd/1q3fFZ0/1g3FOkZLg
 7Hxyq4tkPitEJx/KB4ThEgSAkIVC5DEQ1xEjfIvnOkV6xSGE30bAzlpJxJNMyazoIA9M
 TjV4OiRt0YbmnrrE46qddQZTfjLLgfjSF1LwZCZHIJWJjp6lvogL7xzyQsmHHm9Exljw
 +JgHS+V9nrtoElHljHo/ioFR+M6zszEjfFw8JGw212vzP8XjkOrtAZkYVreTvsZZNOVx ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk70g04pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:02 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20E9xi93011010;
        Fri, 14 Jan 2022 10:04:02 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk70g04p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20E9uoN8017972;
        Fri, 14 Jan 2022 10:04:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3df1vjw7hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:00 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EA3vjA32965022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 10:03:57 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B7D011C050;
        Fri, 14 Jan 2022 10:03:57 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9069B11C054;
        Fri, 14 Jan 2022 10:03:56 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 10:03:56 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 2/5] s390x: css: Skip if we're not run by qemu
Date:   Fri, 14 Jan 2022 10:02:42 +0000
Message-Id: <20220114100245.8643-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220114100245.8643-1-frankja@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I0CMSxujYpqpazRCi4YIuBk7MnpgyqOI
X-Proofpoint-ORIG-GUID: OABQ0EBPMLmKkn-IcamBrM8lnO1u32-R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_03,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=908
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's no guarantee that we even find a device at the address we're
testing for if we're not running under QEMU.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/css.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/s390x/css.c b/s390x/css.c
index 881206ba..c24119b4 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -15,6 +15,7 @@
 #include <interrupt.h>
 #include <asm/arch_def.h>
 #include <alloc_page.h>
+#include <vm.h>
 
 #include <malloc_io.h>
 #include <css.h>
@@ -350,6 +351,12 @@ int main(int argc, char *argv[])
 {
 	int i;
 
+	/* There's no guarantee where our devices are without qemu */
+	if (!vm_is_kvm() && !vm_is_tcg()) {
+		report_skip("Not running under QEMU");
+		goto done;
+	}
+
 	report_prefix_push("Channel Subsystem");
 	enable_io_isc(0x80 >> IO_SCH_ISC);
 	for (i = 0; tests[i].name; i++) {
@@ -357,7 +364,8 @@ int main(int argc, char *argv[])
 		tests[i].func();
 		report_prefix_pop();
 	}
-	report_prefix_pop();
 
+done:
+	report_prefix_pop();
 	return report_summary();
 }
-- 
2.32.0

