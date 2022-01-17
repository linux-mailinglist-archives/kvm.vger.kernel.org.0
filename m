Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7FE490D15
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241324AbiAQRAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:00:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19884 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241511AbiAQRAE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 12:00:04 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HGvdn3023393
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:00:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GXB9TRB7x1l7/Lz63hixRqlO9EDs8Rv0JXVsBTk3suw=;
 b=nQFEwSqwyCX799+s7E8clqxGzg1suHKFDif/a9pCw74CgO82/jX6dr6zLUbudLv0Weuz
 VrI7lgzOqy+lGzM02j9tMj9vciIXmR2G1eLXZk2REyqqZwdWxjv394Rj82uhwez2CD0j
 kYUgd9oKQBSOCu8zg0jAj4ONDIL/5LrX01onQo01fd25AyELM7tTDSF4XUL0dpXRKmu0
 1Mq6HY62VrTQ6tApdE1rOc41o4N4ApBgi/0uB94YjLYkYa4V2NfV57LikBfg7E4V6AzQ
 yUrFsnb6sgfBAH1p/88aj24uyyBiCmSKnuduRbKqKnzzXzWS4yu8YwITYFq3xk+M3aUS Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dncefr167-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:00:03 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HH038Z032148
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:00:03 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dncefr15j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 17:00:02 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGl5Od005197;
        Mon, 17 Jan 2022 17:00:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3dknwa56y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 17:00:01 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGxteq39256546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:59:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 816C1A405F;
        Mon, 17 Jan 2022 16:59:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B8ACA4054;
        Mon, 17 Jan 2022 16:59:55 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.16])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:59:55 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 12/13] s390x: smp: Allocate memory in DMA31 space
Date:   Mon, 17 Jan 2022 17:59:48 +0100
Message-Id: <20220117165949.75964-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220117165949.75964-1-imbrenda@linux.ibm.com>
References: <20220117165949.75964-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pJYc82byQjLA8RJx_O-3OnKqSEuRkPkp
X-Proofpoint-ORIG-GUID: 82qsMGksdkK87APLF1UVCxZZwHlq8FS6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 clxscore=1015 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The store status at address order works with 31 bit addresses so let's
use them.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
[Fix order number - found by Nico Boehr]
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 329ca92d..1bbe4c31 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -121,7 +121,7 @@ static void test_stop_store_status(void)
 
 static void test_store_status(void)
 {
-	struct cpu_status *status = alloc_pages(1);
+	struct cpu_status *status = alloc_pages_flags(1, AREA_DMA31);
 	uint32_t r;
 
 	report_prefix_push("store status at address");
@@ -241,7 +241,7 @@ static void test_func_initial(void)
 
 static void test_reset_initial(void)
 {
-	struct cpu_status *status = alloc_pages(0);
+	struct cpu_status *status = alloc_pages_flags(0, AREA_DMA31);
 	struct psw psw;
 	int i;
 
-- 
2.31.1

