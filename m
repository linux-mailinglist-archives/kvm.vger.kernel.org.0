Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9634E738987
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbjFUPgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbjFUPeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:34:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A481FCF;
        Wed, 21 Jun 2023 08:34:25 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LFPS8k009988;
        Wed, 21 Jun 2023 15:34:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=wYVI+zazgRf/RITto1ufSmGWhRHchTtSnFJuftgMiWc=;
 b=cf6A5JeJWWOXgTe+lG323rMbGRz5qaiWdHgE6uL7qXuo9WO/C9/nCE0DWJkHKn5YHDBM
 vlZCMUzLeysKsiPVwDFAjWh/X/kUBCPiC2j4tFmFj4YzSxal8XafhlM33yjWhRltpvwo
 6IuwzXyXMHDyfZTY0eavYU2Nl0AhtQkUAbv+aP7A4u8uYRScaw/UjDQprqm8uWZHsk6n
 qJdOTaf2ZHdUuO6dqktyzx/yFdBWPDXjKqZG1upECaZAb3hoeHxTKuzUPZJzsDI906Yt
 KsfK/Xd341OFzIgzTzjc4NomNElLtVthhezSST5N1qwNz+LltymNZ/0zCLpBUxt0OpJQ 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3u70ajc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:24 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35LFPoSf010394;
        Wed, 21 Jun 2023 15:34:24 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3u70aff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:24 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35L5H21o006673;
        Wed, 21 Jun 2023 15:34:21 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3r94f5255t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:21 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35LFYIR862062986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 15:34:18 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14AF020049;
        Wed, 21 Jun 2023 15:34:18 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A318A20043;
        Wed, 21 Jun 2023 15:34:17 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.33.34])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Jun 2023 15:34:17 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, nrb@linux.ibm.com, pmorel@linux.ibm.com
Subject: [GIT PULL 05/11] s390/uv: Always export uv_info
Date:   Wed, 21 Jun 2023 17:29:11 +0200
Message-ID: <20230621153227.57250-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230621153227.57250-1-frankja@linux.ibm.com>
References: <20230621153227.57250-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dy2Gu4GfsuKaeWImE-E2Rd_G-p6WOTCJ
X-Proofpoint-ORIG-GUID: CZcIpO5iuQRbInDoPxmI_kBuU1mKcXNQ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_08,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0
 clxscore=1015 adultscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306210131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steffen Eiden <seiden@linux.ibm.com>

KVM needs the struct's values to be able to provide PV support.

The uvdevice is currently guest only and will need the struct's values
for call support checking and potential future expansions.

As uv.c is only compiled with CONFIG_PGSTE or
CONFIG_PROTECTED_VIRTUALIZATION_GUEST we don't need a second check in
the code. Users of uv_info will need to fence for these two config
options for the time being.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230615100533.3996107-2-seiden@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20230615100533.3996107-2-seiden@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index cb2ee06df286..e320a382fa85 100644
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
2.41.0

