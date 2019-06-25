Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D9E552CF
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 17:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730959AbfFYPEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 11:04:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19368 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730607AbfFYPEj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jun 2019 11:04:39 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5PF4PnP007906
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 11:04:38 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tbnmxrxkv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 11:04:26 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <walling@linux.ibm.com>;
        Tue, 25 Jun 2019 16:04:10 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 25 Jun 2019 16:04:06 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5PF451o10945052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 15:04:05 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5BA8B2068;
        Tue, 25 Jun 2019 15:04:05 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A101CB2064;
        Tue, 25 Jun 2019 15:04:05 +0000 (GMT)
Received: from collin-T470p.pok.ibm.com (unknown [9.63.14.221])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jun 2019 15:04:05 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     cohuck@redhat.com, david@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v5 1/2] s390/setup: diag318: refactor struct
Date:   Tue, 25 Jun 2019 11:03:41 -0400
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561475022-18348-1-git-send-email-walling@linux.ibm.com>
References: <1561475022-18348-1-git-send-email-walling@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062515-2213-0000-0000-000003A4D308
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011328; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01223103; UDB=6.00643637; IPR=6.01004276;
 MB=3.00027462; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-25 15:04:08
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062515-2214-0000-0000-00005EFDA5EC
Message-Id: <1561475022-18348-2-git-send-email-walling@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The diag318 struct introduced in include/asm/diag.h can be
reused in KVM, so let's condense the version code fields in the
diag318_info struct for easier usage and simplify it until we
can determine how the data should be formatted.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/diag.h | 6 ++----
 arch/s390/kernel/setup.c     | 3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/diag.h b/arch/s390/include/asm/diag.h
index 0036eab..ca8f85b 100644
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
index f8544d5..b66c41f 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -1045,8 +1045,7 @@ static void __init setup_control_program_code(void)
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

