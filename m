Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464D514F873
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 16:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgBAP3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 10:29:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42800 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726593AbgBAP3G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 1 Feb 2020 10:29:06 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 011FJej1109470
        for <kvm@vger.kernel.org>; Sat, 1 Feb 2020 10:29:05 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xwa7ujf6s-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2020 10:29:04 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Sat, 1 Feb 2020 15:29:03 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 1 Feb 2020 15:29:01 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 011FT0IN53805286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 1 Feb 2020 15:29:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 898B75204F;
        Sat,  1 Feb 2020 15:29:00 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.30.110])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C69135204E;
        Sat,  1 Feb 2020 15:28:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 4/7] s390x: Add cpu id to interrupt error prints
Date:   Sat,  1 Feb 2020 10:28:48 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200201152851.82867-1-frankja@linux.ibm.com>
References: <20200201152851.82867-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020115-0008-0000-0000-0000034ED4C3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020115-0009-0000-0000-00004A6F5AE5
Message-Id: <20200201152851.82867-5-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-01_03:2020-01-31,2020-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0
 mlxlogscore=941 lowpriorityscore=0 bulkscore=0 mlxscore=0 suspectscore=1
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002010113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's good to know which cpu broke the test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/interrupt.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index ccb376a..3a40cac 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -109,8 +109,8 @@ void handle_pgm_int(void)
 	if (!pgm_int_expected) {
 		/* Force sclp_busy to false, otherwise we will loop forever */
 		sclp_handle_ext();
-		report_abort("Unexpected program interrupt: %d at %#lx, ilen %d\n",
-			     lc->pgm_int_code, lc->pgm_old_psw.addr,
+		report_abort("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
+			     lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
 			     lc->pgm_int_id);
 	}
 
@@ -122,8 +122,8 @@ void handle_ext_int(void)
 {
 	if (!ext_int_expected &&
 	    lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
-		report_abort("Unexpected external call interrupt (code %#x): at %#lx",
-			     lc->ext_int_code, lc->ext_old_psw.addr);
+		report_abort("Unexpected external call interrupt (code %#x): on cpu %d at %#lx",
+			     lc->ext_int_code, stap(), lc->ext_old_psw.addr);
 		return;
 	}
 
@@ -140,18 +140,18 @@ void handle_ext_int(void)
 
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

