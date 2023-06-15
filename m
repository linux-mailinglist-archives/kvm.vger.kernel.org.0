Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868AA7314DC
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 12:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343629AbjFOKFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 06:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245676AbjFOKFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 06:05:43 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B24270F;
        Thu, 15 Jun 2023 03:05:41 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35F9i14V004331;
        Thu, 15 Jun 2023 10:05:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=K+mZhkPdbRj2q8yxTHyFRgK9Ah0e0y6fB17mPm5uX0w=;
 b=QrtIE4RH7hlvwFBBslHxK+uNnmscixUbKhnjVDNfEMJgbU2crmfQSHuEoNIcNcCPQj5o
 u9yg5p8oFtcqjKOXI0i58S6hph2PiykPqGHjblUZn/VnHRFdEGVXvFsRWaSlg7HBmT2+
 D9Y+E/dC8doEUIxjgTVJGqwh03usBoxJJz6Ah1bW/hH9tqXiavgxiEx3fAYSEuk02p1L
 jr+bK33uWvf+KuUeW/0NJmx0Bg9d2Pf7NpkZ+xgklMec3320GhdBQuxf2Gu9wPK5L9B6
 q4LtOynr4IVz/pAP/FvHp9w5+skSQNvhqp+2il/qtPDH4ZmiO3YwjclVgIvvRuCiGc9d vQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r80908j8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 10:05:40 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35F1Rf6L001926;
        Thu, 15 Jun 2023 10:05:38 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3r4gt53gqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 10:05:38 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35FA5XNe23593656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 10:05:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2F112006E;
        Thu, 15 Jun 2023 10:05:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A45082006F;
        Thu, 15 Jun 2023 10:05:33 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jun 2023 10:05:33 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH v5 1/7] s390/uv: Always export uv_info
Date:   Thu, 15 Jun 2023 12:05:27 +0200
Message-Id: <20230615100533.3996107-2-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615100533.3996107-1-seiden@linux.ibm.com>
References: <20230615100533.3996107-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IEgszZJiE5oDdb_xOmZAUWm2v0aHVRYX
X-Proofpoint-GUID: IEgszZJiE5oDdb_xOmZAUWm2v0aHVRYX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-15_06,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 lowpriorityscore=0 phishscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM needs the struct's values to be able to provide PV support.

The uvdevice is currently guest only and will need the struct's values
for call support checking and potential future expansions.

As uv.c is only compiled with CONFIG_PGSTE or
CONFIG_PROTECTED_VIRTUALIZATION_GUEST we don't need a second check in
the code. Users of uv_info will need to fence for these two config
options for the time being.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 4ada621a2c46..5da3879001bb 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -23,12 +23,20 @@
 int __bootdata_preserved(prot_virt_guest);
 #endif
 
+/*
+ * uv_info contains both host and guest information but it's currently only
+ * expected to be used within modules if it's the KVM module or for
+ * any PV guest module.
+ *
+ * The kernel itself will write these values once in uv_query_info()
+ * and then make some of them readable via a sysfs interface.
+ */
 struct uv_info __bootdata_preserved(uv_info);
+EXPORT_SYMBOL(uv_info);
 
 #if IS_ENABLED(CONFIG_KVM)
 int __bootdata_preserved(prot_virt_host);
 EXPORT_SYMBOL(prot_virt_host);
-EXPORT_SYMBOL(uv_info);
 
 static int __init uv_init(phys_addr_t stor_base, unsigned long stor_len)
 {
-- 
2.40.1

