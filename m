Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8EC13D99C
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 13:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgAPMFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 07:05:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726898AbgAPMFe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jan 2020 07:05:34 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00GBvqeA035317
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 07:05:32 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xhbpt5dbp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 07:05:32 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 16 Jan 2020 12:05:30 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 Jan 2020 12:05:28 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00GC5RGl52822078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 12:05:27 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F9EE5204E;
        Thu, 16 Jan 2020 12:05:27 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 26D7552050;
        Thu, 16 Jan 2020 12:05:26 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/7] s390x: Add cpu id to interrupt error prints
Date:   Thu, 16 Jan 2020 07:05:09 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116120513.2244-1-frankja@linux.ibm.com>
References: <20200116120513.2244-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20011612-0016-0000-0000-000002DDD8FB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011612-0017-0000-0000-000033407087
Message-Id: <20200116120513.2244-4-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_03:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=804
 impostorscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=1 malwarescore=0 priorityscore=1501 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001160103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's good to know which cpu broke the test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/interrupt.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 05f30be..773752a 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -107,8 +107,8 @@ static void fixup_pgm_int(void)
 void handle_pgm_int(void)
 {
 	if (!pgm_int_expected)
-		report_abort("Unexpected program interrupt: %d at %#lx, ilen %d\n",
-			     lc->pgm_int_code, lc->pgm_old_psw.addr,
+		report_abort("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
+			     lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
 			     lc->pgm_int_id);
 
 	pgm_int_expected = false;
@@ -119,8 +119,8 @@ void handle_ext_int(void)
 {
 	if (!ext_int_expected &&
 	    lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
-		report_abort("Unexpected external call interrupt (code %#x): at %#lx",
-			     lc->ext_int_code, lc->ext_old_psw.addr);
+		report_abort("Unexpected external call interrupt (code %#x): on cpu %d at %#lx",
+			     stap(), lc->ext_int_code, lc->ext_old_psw.addr);
 		return;
 	}
 
@@ -137,18 +137,18 @@ void handle_ext_int(void)
 
 void handle_mcck_int(void)
 {
-	report_abort("Unexpected machine check interrupt: at %#lx",
-		     lc->mcck_old_psw.addr);
+	report_abort("Unexpected machine check interrupt: on cpu %d at %#lx",
+		     stap(), lc->mcck_old_psw.addr);
 }
 
 void handle_io_int(void)
 {
-	report_abort("Unexpected io interrupt: at %#lx",
-		     lc->io_old_psw.addr);
+	report_abort("Unexpected io interrupt: on cpu %d at %#lx",
+		     stap(), lc->io_old_psw.addr);
 }
 
 void handle_svc_int(void)
 {
-	report_abort("Unexpected supervisor call interrupt: at %#lx",
-		     lc->svc_old_psw.addr);
+	report_abort("Unexpected supervisor call interrupt: on cpu %d at %#lx",
+		     stap(), lc->svc_old_psw.addr);
 }
-- 
2.20.1

