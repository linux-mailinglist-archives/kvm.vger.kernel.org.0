Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993F757CCDA
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiGUOHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiGUOHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:07:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E6D43E4A
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:07:17 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LE2Eit022253
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lQKrRUrtuw0R9VXc2fRz0pwxqAsLT/cE+UZgmoWjlPA=;
 b=i7oBAcH6GPkb0LZrF/+5lhBYNmNcK2fIOmvotAPd/APYkLSj+fVBIcK5OrAHXCnXOTpo
 1xY+gDYkpYOe/P2f2nJVbgjTpZIXW7vT7awENxIU6zDoUKSvzgY4LeXwLosW3V4BJ7lw
 xqxzQd1xPo83jQrTEAICucNv3TWKuVkvhEpTltoN7JdusqBzQBrAOpCXMtHcT13Lyjvz
 ifOVaFM9KY/k7T01K5xg2sMoL7Yj8jt4BDMikRfm2OQxTq4sbe5Hj4Mn+J1KArZPH5Sw
 1LlXlLeG7xNK9ziDtpwUC0jGFNAfE5+H3ii9vJF0RjItjJ1M52H2N8bTN3DcJnXgHv4A MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf87909u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:13 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LE2nTE025330
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:11 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf87909gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:10 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LE75l4031146;
        Thu, 21 Jul 2022 14:07:05 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3hbmy8y6gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LE7ECX32375256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 14:07:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 134B14C04E;
        Thu, 21 Jul 2022 14:07:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD5964C046;
        Thu, 21 Jul 2022 14:07:01 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 14:07:01 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 01/12] s390x: Fix sclp facility bit numbers
Date:   Thu, 21 Jul 2022 16:06:50 +0200
Message-Id: <20220721140701.146135-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721140701.146135-1-imbrenda@linux.ibm.com>
References: <20220721140701.146135-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DTclubTCNzHmksqgmjZhzqA-ZINQL1rq
X-Proofpoint-ORIG-GUID: GXAlrwTN99Wg7bFWYAH9VgqcqxWRFbfZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

sclp_feat_check takes care of adjusting the bit numbering such that they
can be defined as they are in the documentation.

Fixes: 4dd649c8 ("lib: s390x: sclp: Extend feature probing")
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20220621143015.748290-2-scgl@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sclp.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index e48a5a3d..3488f4d2 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -134,13 +134,13 @@ struct sclp_facilities {
 };
 
 /* bit number within a certain byte */
-#define SCLP_FEAT_85_BIT_GSLS		7
-#define SCLP_FEAT_98_BIT_KSS		0
-#define SCLP_FEAT_116_BIT_64BSCAO	7
-#define SCLP_FEAT_116_BIT_CMMA		6
-#define SCLP_FEAT_116_BIT_ESCA		3
-#define SCLP_FEAT_117_BIT_PFMFI		6
-#define SCLP_FEAT_117_BIT_IBS		5
+#define SCLP_FEAT_85_BIT_GSLS		0
+#define SCLP_FEAT_98_BIT_KSS		7
+#define SCLP_FEAT_116_BIT_64BSCAO	0
+#define SCLP_FEAT_116_BIT_CMMA		1
+#define SCLP_FEAT_116_BIT_ESCA		4
+#define SCLP_FEAT_117_BIT_PFMFI		1
+#define SCLP_FEAT_117_BIT_IBS		2
 
 typedef struct ReadInfo {
 	SCCBHeader h;
-- 
2.36.1

