Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FABE100068
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 09:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfKRIgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 03:36:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726614AbfKRIgL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Nov 2019 03:36:11 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAI8WtbH113062
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 03:36:10 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wayafu4gk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 03:36:09 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 18 Nov 2019 08:36:08 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 18 Nov 2019 08:36:04 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAI8a49k61341754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 08:36:04 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03A4FA405B;
        Mon, 18 Nov 2019 08:36:04 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E355EA4062;
        Mon, 18 Nov 2019 08:36:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 18 Nov 2019 08:36:03 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 9C998E02C4; Mon, 18 Nov 2019 09:36:03 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [GIT PULL 2/5] KVM: s390: Cleanup kvm_arch_init error path
Date:   Mon, 18 Nov 2019 09:35:59 +0100
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191118083602.15835-1-borntraeger@de.ibm.com>
References: <20191118083602.15835-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111808-0012-0000-0000-000003668F8D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111808-0013-0000-0000-000021A2138D
Message-Id: <20191118083602.15835-3-borntraeger@de.ibm.com>
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-18_01:2019-11-15,2019-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911180077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Both kvm_s390_gib_destroy and debug_unregister test if the needed
pointers are not NULL and hence can be called unconditionally.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/kvm/20191002075627.3582-1-frankja@linux.ibm.com
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index f6db0f1bc867..40af442b2e15 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -453,16 +453,14 @@ static void kvm_s390_cpu_feat_init(void)
 
 int kvm_arch_init(void *opaque)
 {
-	int rc;
+	int rc = -ENOMEM;
 
 	kvm_s390_dbf = debug_register("kvm-trace", 32, 1, 7 * sizeof(long));
 	if (!kvm_s390_dbf)
 		return -ENOMEM;
 
-	if (debug_register_view(kvm_s390_dbf, &debug_sprintf_view)) {
-		rc = -ENOMEM;
-		goto out_debug_unreg;
-	}
+	if (debug_register_view(kvm_s390_dbf, &debug_sprintf_view))
+		goto out;
 
 	kvm_s390_cpu_feat_init();
 
@@ -470,19 +468,17 @@ int kvm_arch_init(void *opaque)
 	rc = kvm_register_device_ops(&kvm_flic_ops, KVM_DEV_TYPE_FLIC);
 	if (rc) {
 		pr_err("A FLIC registration call failed with rc=%d\n", rc);
-		goto out_debug_unreg;
+		goto out;
 	}
 
 	rc = kvm_s390_gib_init(GAL_ISC);
 	if (rc)
-		goto out_gib_destroy;
+		goto out;
 
 	return 0;
 
-out_gib_destroy:
-	kvm_s390_gib_destroy();
-out_debug_unreg:
-	debug_unregister(kvm_s390_dbf);
+out:
+	kvm_arch_exit();
 	return rc;
 }
 
-- 
2.21.0

