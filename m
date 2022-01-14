Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844EA48E813
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 11:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240316AbiANKER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 05:04:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240267AbiANKEI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 05:04:08 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20E9rfM0001313;
        Fri, 14 Jan 2022 10:04:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yGRAOjm0Dg3WBZxSlAnJsuUfnVgsiNht/9H75ydM5O0=;
 b=H7jFnaKPvDvxOUMZpCdssR7GOQpsnA5ieqTQNaWYGPLFjrvybiWsohSZ/yK7umMLVFmQ
 DH1cWWrpt11WwaYXjz1oAqZLd5TzW1vmkePppuxjhPaYF/6gqUH1PVwsDdXi8aLxg9Zr
 hJUPsmr2xgGr40/3qZooUnAPYYus9kpAM+HMAlPibZvhGhLLwePdLKqY5EALqz0SJdTX
 tRBEMSUQAKaT32ieA+t0l4g5WM6MmmZAcuDpYixqzAHU89D2OxX+ZghG08XJKx51ZY+y
 M9Y0UxUeoplolUZzl0+z+5RGSuzobeCNmTn1Hv2Q42Bxu6lNNx0w9hyl1ZxQB28ln44O Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk6xm8664-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:07 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20E9usWT011114;
        Fri, 14 Jan 2022 10:04:07 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk6xm865f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:07 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20E9uuGd012495;
        Fri, 14 Jan 2022 10:04:04 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3df28at777-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:04 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EA3xBL44106078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 10:03:59 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9705211C054;
        Fri, 14 Jan 2022 10:03:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD3E311C050;
        Fri, 14 Jan 2022 10:03:58 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 10:03:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 4/5] s390x: smp: Allocate memory in DMA31 space
Date:   Fri, 14 Jan 2022 10:02:44 +0000
Message-Id: <20220114100245.8643-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220114100245.8643-1-frankja@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Gh3Lx6JY3VG8VV7mRTrn4-iHuLnTnRE7
X-Proofpoint-GUID: Nt705KDa9ls_eXLkNnFpJvG0t6oOSfrt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_03,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 impostorscore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The store status at address order works with 31 bit addresses so let's
use them.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/smp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 32f128b3..c91f170b 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -124,7 +124,7 @@ static void test_stop_store_status(void)
 
 static void test_store_status(void)
 {
-	struct cpu_status *status = alloc_pages(1);
+	struct cpu_status *status = alloc_pages_flags(1, AREA_DMA31);
 	uint32_t r;
 
 	report_prefix_push("store status at address");
@@ -244,7 +244,7 @@ static void test_func_initial(void)
 
 static void test_reset_initial(void)
 {
-	struct cpu_status *status = alloc_pages(0);
+	struct cpu_status *status = alloc_pages_flags(1, AREA_DMA31);
 	struct psw psw;
 	int i;
 
-- 
2.32.0

