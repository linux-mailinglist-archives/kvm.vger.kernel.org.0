Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD8F77D242
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239244AbjHOSoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239255AbjHOSn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:43:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3129DF1;
        Tue, 15 Aug 2023 11:43:56 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FISt1x009860;
        Tue, 15 Aug 2023 18:43:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JYpfJmXiJZO35VR7mij0Ciq6rjeA571Ky+xxtKLHHJg=;
 b=cONcF40BVSRd0G1jkLfGaRZ5ta4w4cJi93g/aurbL3vUyGIj8B1r/h1gOoEfpWbbFbWp
 PMUW+WBEypNpgq0+KCF3SAaLdZOP2L4yozQqEMXyWorC/ekOvnmIyqMwFztJtpg/L1YZ
 d4zIYH1ZAp+oIeMF99KhT1l0UKH5/qGOxH7sK4M0y5mo/ZiJuv0hOY9GynAPgHFCjHo+
 HS35tF4rGFLV8Xq9eR5MZaBtvm3rZlz0l1npB9ljnKSJiAM1dtky9Yatefvl9+IepyCZ
 70xJiWcdkEfrJAvuoLaFRod3xI+3ojJcXMLUm0SYkH2V/NSljR4HU3WDm3qXKfihPx2H Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgep28bjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:53 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FIT6lt010887;
        Tue, 15 Aug 2023 18:43:53 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgep28bj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:53 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FHRcF5003439;
        Tue, 15 Aug 2023 18:43:52 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3semdsffpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:52 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FIhpRK49480030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 18:43:51 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CE405804E;
        Tue, 15 Aug 2023 18:43:51 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14B755803F;
        Tue, 15 Aug 2023 18:43:50 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.75.177])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 18:43:49 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH 11/12] kvm: s390: export kvm_s390_pv*_is_protected functions
Date:   Tue, 15 Aug 2023 14:43:32 -0400
Message-Id: <20230815184333.6554-12-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230815184333.6554-1-akrowiak@linux.ibm.com>
References: <20230815184333.6554-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wcPwbtIKSmuolCDdoeBu18AUK6cfsF5e
X-Proofpoint-ORIG-GUID: TIhRuabTZWv77mBDzwRct2SYYrdXU2Ms
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 mlxlogscore=945 spamscore=0 suspectscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308150167
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export the kvm_s390_pv_is_protected and kvm_s390_pv_cpu_is_protected
functions so that they can be called from other modules that carry a
GPL-compatible license.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
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
index bf1fdc7bf89e..8d3f39a8a11e 100644
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
2.39.3

