Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E5438883E
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 09:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240567AbhESHmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 03:42:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238476AbhESHmB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 03:42:01 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14J7Ztdf107203;
        Wed, 19 May 2021 03:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3uZmSI77E5TGNyfkRuQlpsM6Hja+QeN+kVV0qwniZ1M=;
 b=PntznEl3JYZ7ruiC+RIQlVLj6KXmcsJPqD/qIURi2Akdd678MNd68qUnPhlwbSZZLjJD
 HxuG9wBKA6iv3MGdBH7CVpZC8gR9OFimu8Y+B0gF2oZ7oPvAzBUWXgIKdtSk/JZLbjYH
 Pbc1WYQYVhCvLvFJ5WwiBd86nbmUobEau1qHroXsYv6bvZCG5xymn9RFU6ABNbCceubU
 Fga/jAfA9WLQ8igtaY30HnJsCnFC4nGCvxIJ+dXQOgrmqk4CuSwLl3wU8c0/PtR2Qe5/
 IiODsjKRESGUOQufoCXIa1MOWx1ut3/l1S0aClQBE9Iy1Acq/7M6kgHd97F+YnvsJAae JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38mx73ggg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 03:40:41 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14J7aMuN108593;
        Wed, 19 May 2021 03:40:41 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38mx73gget-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 03:40:41 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14J7bdQM004010;
        Wed, 19 May 2021 07:40:39 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 38j5x89x73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 07:40:39 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14J7eaLB40829338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 07:40:36 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70E3AA4060;
        Wed, 19 May 2021 07:40:36 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A38CAA405C;
        Wed, 19 May 2021 07:40:35 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 May 2021 07:40:35 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/6] s390x: uv-guest: Add invalid share location test
Date:   Wed, 19 May 2021 07:40:17 +0000
Message-Id: <20210519074022.7368-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519074022.7368-1-frankja@linux.ibm.com>
References: <20210519074022.7368-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NcMP3Ne4QutKwu4WEXMCDZ2oYWUkbfzL
X-Proofpoint-ORIG-GUID: OlhwDVqisi7uqM7cQ-BGzNzJcyEVNCzT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_02:2021-05-18,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 impostorscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's also test sharing unavailable memory.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/uv-guest.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 99544442..a13669ab 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -15,6 +15,7 @@
 #include <asm/interrupt.h>
 #include <asm/facility.h>
 #include <asm/uv.h>
+#include <sclp.h>
 
 static unsigned long page;
 
@@ -99,6 +100,10 @@ static void test_sharing(void)
 	uvcb.header.len = sizeof(uvcb);
 	cc = uv_call(0, (u64)&uvcb);
 	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "share");
+	uvcb.paddr = get_ram_size() + PAGE_SIZE;
+	cc = uv_call(0, (u64)&uvcb);
+	report(cc == 1 && uvcb.header.rc == 0x101, "invalid memory");
+	uvcb.paddr = page;
 	report_prefix_pop();
 
 	report_prefix_push("unshare");
-- 
2.30.2

