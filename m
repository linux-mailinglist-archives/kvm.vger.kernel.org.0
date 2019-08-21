Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED6C97792
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 12:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfHUKsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 06:48:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727063AbfHUKsk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Aug 2019 06:48:40 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LAmRq9127711
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 06:48:39 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uh2nu50b2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 06:48:39 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 21 Aug 2019 11:48:17 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 21 Aug 2019 11:48:14 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7LAmE8S30802248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 10:48:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06727AE04D;
        Wed, 21 Aug 2019 10:48:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6E21AE045;
        Wed, 21 Aug 2019 10:48:12 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.179])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 21 Aug 2019 10:48:12 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/4] s390x: Support PSW restart boot
Date:   Wed, 21 Aug 2019 12:47:33 +0200
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190821104736.1470-1-frankja@linux.ibm.com>
References: <20190821104736.1470-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082110-4275-0000-0000-0000035B7609
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082110-4276-0000-0000-0000386D98C9
Message-Id: <20190821104736.1470-2-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a boot PSW to PSW restart new, so we can also boot via a PSW
restart.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/flat.lds | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/s390x/flat.lds b/s390x/flat.lds
index 403d967..86dffac 100644
--- a/s390x/flat.lds
+++ b/s390x/flat.lds
@@ -1,14 +1,18 @@
 SECTIONS
 {
-	/*
-	 * Initial short psw for disk boot, with 31 bit addressing for
-	 * non z/Arch environment compatibility and the instruction
-	 * address 0x10000 (cstart64.S .init).
-	 */
 	.lowcore : {
+		/*
+		 * Initial short psw for disk boot, with 31 bit addressing for
+		 * non z/Arch environment compatibility and the instruction
+		 * address 0x10000 (cstart64.S .init).
+		 */
 		. = 0;
 		 LONG(0x00080000)
 		 LONG(0x80010000)
+		 /* Restart new PSW for booting via PSW restart. */
+		 . = 0x1a0;
+		 QUAD(0x0000000180000000)
+		 QUAD(0x0000000000010000)
 	}
 	. = 0x10000;
 	.text : {
-- 
2.17.0

