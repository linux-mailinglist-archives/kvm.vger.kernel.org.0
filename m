Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD484BFB46
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 15:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiBVOze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 09:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiBVOzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 09:55:33 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E5610C513;
        Tue, 22 Feb 2022 06:55:07 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MEDVav029560;
        Tue, 22 Feb 2022 14:55:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/pE9bxNfG6kL8HopJYYmH68KigzjetTd0Mjiknp64P8=;
 b=lBexlt8OXKHNVergtnplL/7JANXMVJBPjojzIX+xA5Vqb0rkUqgWkV4mBZGNRg7w9fAe
 16DeVowuWRw1MFm1u39f6pvLnifgl1kcOz/WBNZOLrwbH2z/rQtQcMeLrp+B9zSc7Uk8
 1Kg0RKIbr+/5xUFeEmPBr0/NBtU4vYs0LxD6dZ728HkSH+p6/2fQonOkJqcfdvFKdpqx
 NUAXwMpdWdDQomX2c15CzYfLVGFAh8vLVsdp8E/d2/JUAkNqKWZFlHkyUB0hb/VJTKAM
 dggy13MBuZ7FIikvGHbq5g3BUyVKUI1Zqt08cM30RqgrRWvbhIoEOjjSAU0h/mX8W590 wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ed1dj8u3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 14:55:07 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21MEkDvj014549;
        Tue, 22 Feb 2022 14:55:06 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ed1dj8u2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 14:55:06 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21MEgu5k011798;
        Tue, 22 Feb 2022 14:55:04 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ear692fuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 14:55:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21MEt0Zw49676786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 14:55:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC79CA405B;
        Tue, 22 Feb 2022 14:55:00 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6B99A405F;
        Tue, 22 Feb 2022 14:54:59 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Feb 2022 14:54:59 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 2/5] s390x: lib: Add QUI getter
Date:   Tue, 22 Feb 2022 14:54:53 +0000
Message-Id: <20220222145456.9956-3-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222145456.9956-1-seiden@linux.ibm.com>
References: <20220222145456.9956-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 35S3gXlq1d7OpR385bKsWLBjogRaK-eH
X-Proofpoint-ORIG-GUID: H9vbIHNxEhz-Y_jrFRHhlEEpMkgKQoGg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

