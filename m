Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334FA49E464
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 15:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242112AbiA0OQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 09:16:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24714 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242036AbiA0OQM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 09:16:12 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20RE8eFV037125;
        Thu, 27 Jan 2022 14:16:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=z+ByTVogD5JnSKLtT6xHKnBAcMiHPySlmHZ65OBn4WA=;
 b=NT6w4zO75dCUbU9XQEJvOFuIbltre4JZSIu4krMApBxrSGYOsyy2tG1Ua4mj5VL4tmku
 rrZ/oS+R59ZQWpVcwLYekAJPrCt8i5z3zFYRo/6y37oVhOC8giHDj4kYMMi/f49SnzFb
 fz17QXxUWBK0ae/y4UwDJwmTGktFImNqRCdn35Ri6O4XoBNYCzBJuTsOmGv+ecHgP+eo
 pude5J59ViUQTmfxWcod+fpYF9Nf3U9U0p3RhF3iqUp7ER8zQ3x+1IB+fEaDM9y2MUou
 Vf6XP41bn8LIOSH4W9kazOmRrnhr4bUCkdOs58gG/tBv1hzpN5Q1ILrMC5sWXp7zqTi7 YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dutr9k34n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:16:11 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20RE8bmD036941;
        Thu, 27 Jan 2022 14:16:10 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dutr9k33r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:16:10 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20REDBFd024439;
        Thu, 27 Jan 2022 14:16:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3dr9j9xn1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:16:08 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20REG4F540567176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 14:16:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C7F352074;
        Thu, 27 Jan 2022 14:16:04 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EB12B52063;
        Thu, 27 Jan 2022 14:16:02 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/4] s390x: lib: Add QUI getter
Date:   Thu, 27 Jan 2022 14:15:57 +0000
Message-Id: <20220127141559.35250-3-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127141559.35250-1-seiden@linux.ibm.com>
References: <20220127141559.35250-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NJasE8LCu95zSZI1RsLx1AiG1uOHHPkq
X-Proofpoint-ORIG-GUID: 5ZnLHZdHEXDyUtmSMWGvVYJuRFeS3FIH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some tests need the information provided by the QUI UVC and lib/s390x/uv.c
already has cached the qui result. Let's add a function to avoid
unnecessary  QUI UVCs.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 lib/s390x/uv.c | 10 +++++++++-
 lib/s390x/uv.h |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index 6fe11dff..5625a1ee 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -2,7 +2,7 @@
 /*
  * Ultravisor related functionality
  *
- * Copyright 2020 IBM Corp.
+ * Copyright 2020, 2022 IBM Corp.
  *
  * Authors:
  *    Janosch Frank <frankja@linux.ibm.com>
@@ -47,6 +47,14 @@ bool uv_query_test_call(unsigned int nr)
 	return test_bit_inv(nr, uvcb_qui.inst_calls_list);
 }
 
+const struct uv_cb_qui *uv_get_info(void)
+{
+	/* Query needs to be called first */
+	assert(uvcb_qui.header.rc);
+
+	return &uvcb_qui;
+}
+
 int uv_setup(void)
 {
 	if (!test_facility(158))
diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 8175d9c6..e9935fd2 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -8,6 +8,7 @@
 bool uv_os_is_guest(void);
 bool uv_os_is_host(void);
 bool uv_query_test_call(unsigned int nr);
+const struct uv_cb_qui *uv_get_info(void);
 void uv_init(void);
 int uv_setup(void);
 void uv_create_guest(struct vm *vm);
-- 
2.30.2

