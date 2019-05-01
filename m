Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5DE10F5F
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 00:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfEAWv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 18:51:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37312 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726167AbfEAWv2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 May 2019 18:51:28 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x41Ml8Cg078624
        for <kvm@vger.kernel.org>; Wed, 1 May 2019 18:51:26 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2s7m0yrwdb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 01 May 2019 18:51:26 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <walling@linux.ibm.com>;
        Wed, 1 May 2019 23:51:25 +0100
Received: from b01cxnp22033.gho.pok.ibm.com (9.57.198.23)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 1 May 2019 23:51:22 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x41MpL0028835918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 May 2019 22:51:22 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D09C8AC059;
        Wed,  1 May 2019 22:51:21 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9AABAC060;
        Wed,  1 May 2019 22:51:21 +0000 (GMT)
Received: from collin-T470p.pok.ibm.com (unknown [9.56.58.88])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 May 2019 22:51:21 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     cohuck@redhat.com, david@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v4 1/2] s390/setup: diag318: refactor struct
Date:   Wed,  1 May 2019 18:51:02 -0400
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556751063-21835-1-git-send-email-walling@linux.ibm.com>
References: <1556751063-21835-1-git-send-email-walling@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19050122-0064-0000-0000-000003D531BA
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011031; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01197226; UDB=6.00627920; IPR=6.00978080;
 MB=3.00026688; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-01 22:51:24
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050122-0065-0000-0000-00003D490B32
Message-Id: <1556751063-21835-2-git-send-email-walling@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-01_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905010140
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The diag318 struct introduced in include/asm/diag.h can be
reused in KVM, so let's condense the version code fields in the
diag318_info struct for easier usage and simplify it until we
can determine how the data should be formatted.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
---
 arch/s390/include/asm/diag.h | 6 ++----
 arch/s390/kernel/setup.c     | 3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/diag.h b/arch/s390/include/asm/diag.h
index 19562be..2155162 100644
--- a/arch/s390/include/asm/diag.h
+++ b/arch/s390/include/asm/diag.h
@@ -298,10 +298,8 @@ struct diag26c_mac_resp {
 union diag318_info {
 	unsigned long val;
 	struct {
-		unsigned int cpnc : 8;
-		unsigned int cpvc_linux : 24;
-		unsigned char cpvc_distro[3];
-		unsigned char zero;
+		unsigned long cpnc : 8;
+		unsigned long cpvc : 56;
 	};
 };
 
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 2c642af..cb88062 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -1011,8 +1011,7 @@ static void __init setup_control_program_code(void)
 {
 	union diag318_info diag318_info = {
 		.cpnc = CPNC_LINUX,
-		.cpvc_linux = 0,
-		.cpvc_distro = {0},
+		.cpvc = 0,
 	};
 
 	if (!sclp.has_diag318)
-- 
2.7.4

