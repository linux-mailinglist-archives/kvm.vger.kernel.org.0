Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CF9509C99
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 11:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387885AbiDUJsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 05:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387839AbiDUJsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 05:48:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D8F245BE;
        Thu, 21 Apr 2022 02:45:36 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L9SZFp004892;
        Thu, 21 Apr 2022 09:45:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/pE9bxNfG6kL8HopJYYmH68KigzjetTd0Mjiknp64P8=;
 b=TsZSpZdShXfCbO4jQIfcGzJcF6XgV71JYOexrCy7P/7rkY/Dk2jrSFiy2fCKNiy1Go7X
 QlnRlq2N3K4s2i10OB9XGsg2xmKgHjfsg9gHQXFY5gxVDHDve/mlaOfd+FlwqmzjjyWT
 r6W1hn9fEjzdKmWe0ElJV/iSZWSE6nHdeEKZMw7QwNjU+39iuQ1fMsM7gSCPCG2wH1zO
 742UUSYJQJO7HQAACyAgOcwvHEuC7sfJ7ZGwuCcq0XxVembAo6WsEEwP3SowCkuV4jqy
 MTvX4ldajxCT4MUL+WOzckaS4mIfuVBcvAv6VArtXLHiHdsO0V+ct4Cnlky+cDSQTQ71 mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjjhfp3vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:36 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L9TaJi009004;
        Thu, 21 Apr 2022 09:45:35 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjjhfp3vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:35 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23L9c0wm011534;
        Thu, 21 Apr 2022 09:45:33 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3ffvt9dn55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:33 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23L9jUmp32047584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 09:45:30 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A99111C04C;
        Thu, 21 Apr 2022 09:45:30 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFBDC11C04A;
        Thu, 21 Apr 2022 09:45:29 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 09:45:29 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 2/5] s390x: lib: Add QUI getter
Date:   Thu, 21 Apr 2022 09:45:24 +0000
Message-Id: <20220421094527.32261-3-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220421094527.32261-1-seiden@linux.ibm.com>
References: <20220421094527.32261-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: B0zysBrGP3OW_S-vxBff1I3CqCa5rNvb
X-Proofpoint-GUID: Ky2CVgtt9fjj9f1H-773coWIMA5BlHSa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

