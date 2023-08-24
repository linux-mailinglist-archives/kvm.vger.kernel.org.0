Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B9E786F7F
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240791AbjHXMrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240250AbjHXMqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC957E59;
        Thu, 24 Aug 2023 05:46:44 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgmWH019888;
        Thu, 24 Aug 2023 12:46:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=+/ABv5bvw78NlqiAXaSESB9aeMK+lpYJDI8klcLdXJk=;
 b=f7TcoRq5bH9XekZmvJLi4cLwrX66PNREhsd8eSMUTfWabq/3ryMzxrTmA2m+LGFZJ38t
 bpFpNq/JvoBAkfxd9ok8xhtH/eFSs7rCvNxsOV+nLqklbqnxjRoeenmSrnTA80vpLIgn
 Y/U9b3cdFzN58vM7NirwO5Op59ktlHzQVEdu40Kn2eoYTkvtxLkUhD1LFKWhB7hQpBsM
 ICoVZCWkDZzquQdbw6+R6vbsq35mlxTis1BiEz9q6uh0KUDZRAS2GLjTVsp1It3K1t47
 bJi3rEpgxja+XlidRFWYuipAHSz/dWe2jhA7YxuSg8HpofZc/V1dmLk3HJNDvfIB9fc3 dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ey0hvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:43 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OCh7O5022481;
        Thu, 24 Aug 2023 12:46:31 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ey0h5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:31 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCT9l6016735;
        Thu, 24 Aug 2023 12:46:24 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn227xyth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:24 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkLlK18219712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:21 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8139320043;
        Thu, 24 Aug 2023 12:46:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF3522004D;
        Thu, 24 Aug 2023 12:46:20 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:20 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 17/22] KVM: s390: export kvm_s390_pv*_is_protected functions
Date:   Thu, 24 Aug 2023 14:43:26 +0200
Message-ID: <20230824124522.75408-18-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vl0wtn39tsw1hxhaKsFlctEZNw0tdATD
X-Proofpoint-GUID: 15M7DmuBNo5mCjFog2kTRiQvNI01g86L
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=747
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308240103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tony Krowiak <akrowiak@linux.ibm.com>

Export the kvm_s390_pv_is_protected and kvm_s390_pv_cpu_is_protected
functions so that they can be called from other modules that carry a
GPL-compatible license.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
Link: https://lore.kernel.org/r/20230815184333.6554-12-akrowiak@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  3 +++
 arch/s390/kvm/kvm-s390.h         | 12 ------------
 arch/s390/kvm/pv.c               | 14 ++++++++++++++
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 2bbc3d54959d..91bfecb91321 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1028,6 +1028,9 @@ static inline int sie64a(struct kvm_s390_sie_block *sie_block, u64 *rsa)
 
 extern char sie_exit;
 
+bool kvm_s390_pv_is_protected(struct kvm *kvm);
+bool kvm_s390_pv_cpu_is_protected(struct kvm_vcpu *vcpu);
+
 extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
 extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 0261d42c7d01..a7ea80cfa445 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -270,18 +270,6 @@ static inline u64 kvm_s390_pv_cpu_get_handle(struct kvm_vcpu *vcpu)
 	return vcpu->arch.pv.handle;
 }
 
-static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)
-{
-	lockdep_assert_held(&kvm->lock);
-	return !!kvm_s390_pv_get_handle(kvm);
-}
-
-static inline bool kvm_s390_pv_cpu_is_protected(struct kvm_vcpu *vcpu)
-{
-	lockdep_assert_held(&vcpu->mutex);
-	return !!kvm_s390_pv_cpu_get_handle(vcpu);
-}
-
 /* implemented in interrupt.c */
 int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 2f34c7c3c5ab..856140e9942e 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -18,6 +18,20 @@
 #include <linux/mmu_notifier.h>
 #include "kvm-s390.h"
 
+bool kvm_s390_pv_is_protected(struct kvm *kvm)
+{
+	lockdep_assert_held(&kvm->lock);
+	return !!kvm_s390_pv_get_handle(kvm);
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pv_is_protected);
+
+bool kvm_s390_pv_cpu_is_protected(struct kvm_vcpu *vcpu)
+{
+	lockdep_assert_held(&vcpu->mutex);
+	return !!kvm_s390_pv_cpu_get_handle(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pv_cpu_is_protected);
+
 /**
  * struct pv_vm_to_be_destroyed - Represents a protected VM that needs to
  * be destroyed
-- 
2.41.0

