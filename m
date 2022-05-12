Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8063524929
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352148AbiELJgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbiELJfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCE87644
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:45 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9Bnbm012664
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=AmsOr2KPmHm5lThGjLKlb97+I5u6tDD6OTXf8SScSao=;
 b=U9ZFBQTa/yvm4gasOcnCmXJueywrUpC0v5rpDzuD0jO4iz5pw69h3bejbiG2PZe9IeCw
 Wa0keYteg+NgarjNNd1hUh0awSsdoeOYKE1GlCxu03FrNOgxeZNkxCBpZKr/PF0dSOFO
 9WqPShfI9E0YSvvDebiid+T8ZwJf9aWKFAuSupzen/Yc13S2/DdG1cxsKPkwqNI3eNOX
 DbmVvQPOO6GVfjT6Lqxz8SMaBkeT5s/JwVQE/uzLHOULfkbo7KlWb2VybK5EjHQb4yd+
 7tOu/DmHdA+XzVJ2fsY72Z8N2SWDbJWZBmp1BccFuMrhFC8v+uOCvunPii7nI5goeqWc rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yd1re8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:45 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9PDCr026232
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:44 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yd1re7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:44 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XMwN011806;
        Thu, 12 May 2022 09:35:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3fyrkk2n94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZdZx32768430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C3AD11C05B;
        Thu, 12 May 2022 09:35:39 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF1EE11C054;
        Thu, 12 May 2022 09:35:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:38 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 27/28] s390x: uv-guest: add share bit test
Date:   Thu, 12 May 2022 11:35:22 +0200
Message-Id: <20220512093523.36132-28-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xBXa1JCMysuRAkTTP2b145iQ0vEdLmrc
X-Proofpoint-GUID: 0boQC2D6IWKWxGWIPY83VDoDuQlZKXv9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steffen Eiden <seiden@linux.ibm.com>

The UV facility bits shared/unshared must both be set or none.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/uv-guest.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index fd2cfef1..152ad807 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -157,6 +157,16 @@ static void test_invalid(void)
 	report_prefix_pop();
 }
 
+static void test_share_bits(void)
+{
+	bool unshare = uv_query_test_call(BIT_UVC_CMD_REMOVE_SHARED_ACCESS);
+	bool share = uv_query_test_call(BIT_UVC_CMD_SET_SHARED_ACCESS);
+
+	report_prefix_push("query");
+	report(!(share ^ unshare), "share bits are identical");
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	bool has_uvc = test_facility(158);
@@ -167,6 +177,12 @@ int main(void)
 		goto done;
 	}
 
+	/*
+	 * Needs to be done before the guest-fence,
+	 * as the fence tests if both shared bits are present
+	 */
+	test_share_bits();
+
 	if (!uv_os_is_guest()) {
 		report_skip("Not a protected guest");
 		goto done;
-- 
2.36.1

