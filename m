Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E7A4A8157
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 10:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbiBCJTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 04:19:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52510 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237963AbiBCJTq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 04:19:46 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21388DjP013010;
        Thu, 3 Feb 2022 09:19:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/pE9bxNfG6kL8HopJYYmH68KigzjetTd0Mjiknp64P8=;
 b=PH8jRoiLHQy54uCQm9M0s7vYGMNL2oZZdvPZyPKHhUekuDZp/MenKGK/KfbHFsCtVg0A
 yz2OxhvOruSLylEWIIqflCTWtXIOUgqTwP5Oq0LL//t4zJm2gkj8jRqiZyj/0D8dUOwT
 5KSu0aTPzF7gdZAbfs/5BWBA4E7R5Y7ETSQixgjbMdGPgtqNw9zD/gPRQ5PuCkqRQ7aG
 BGd4ofLWzWE1eiwgHtZ0U4+iE6Ww2XlGIwCpmhPk/rFzZT4UpfnpBu4ZdJ4CFF4TbUfi
 8lR7/rgoA43SA70wVnXSsOmLDSSpOT3puZHHOd7CZKAbWS0IjlbLSx9joRHJnZk4gPb5 IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dyvexjr0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 09:19:45 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2139Gs8D028846;
        Thu, 3 Feb 2022 09:19:45 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dyvexjr00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 09:19:45 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2139H7wL005589;
        Thu, 3 Feb 2022 09:19:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3dvw79tbb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 09:19:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2139Jd8V31129984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 09:19:39 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFDDD52050;
        Thu,  3 Feb 2022 09:19:38 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 251C152059;
        Thu,  3 Feb 2022 09:19:38 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/4] s390x: lib: Add QUI getter
Date:   Thu,  3 Feb 2022 09:19:33 +0000
Message-Id: <20220203091935.2716-3-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220203091935.2716-1-seiden@linux.ibm.com>
References: <20220203091935.2716-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9ZFmDYAoF9kSrri2uxi9undLvteLMJsL
X-Proofpoint-GUID: Ro2bPTz2yfeb5xoL6g1Ivpi4z4HbP818
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_02,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some tests need the information provided by the QUI UVC and lib/s390x/uv.c
already has cached the qui result. Let's add a function to avoid
unnecessary QUI UVCs.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 lib/s390x/uv.c | 8 ++++++++
 lib/s390x/uv.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index 6fe11dff..602cbbfc 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -47,6 +47,14 @@ bool uv_query_test_call(unsigned int nr)
 	return test_bit_inv(nr, uvcb_qui.inst_calls_list);
 }
 
+const struct uv_cb_qui *uv_get_query_data(void)
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
index 8175d9c6..44264861 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -8,6 +8,7 @@
 bool uv_os_is_guest(void);
 bool uv_os_is_host(void);
 bool uv_query_test_call(unsigned int nr);
+const struct uv_cb_qui *uv_get_query_data(void);
 void uv_init(void);
 int uv_setup(void);
 void uv_create_guest(struct vm *vm);
-- 
2.30.2

