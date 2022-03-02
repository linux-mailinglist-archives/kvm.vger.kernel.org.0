Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382F44CAD32
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242119AbiCBSNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244488AbiCBSMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:12:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAB2D0074;
        Wed,  2 Mar 2022 10:11:58 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222I8hi9014056;
        Wed, 2 Mar 2022 18:11:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=37v4zNmVmmHdBQjOevLVgi90PzA6Rz3tllIuy6fK9BI=;
 b=hwcT6q+uT542KHR3Itteag/NEBjsrm8opeSRRpV7MX0GLjPIuwNXEoqXrwDzxVN0MKcw
 8IgTQKtPjfqI6lRlb0ppcKnTUyxX3xn4L2JihbBu3Y22B7LBhJ5OZTGDTHZ9yNYU6hZH
 2dCTlj6gng/zbCw0RNgyBmhi2tK3O6zNjynWqch2yzB8OhUtecp38h2ry2bvT2ZPGS0N
 dBB/q9dTQo2WDMm2SOMeQexhwHE3BmttsscbKUw+My6o+klGpBSlOZGyq9wCme6+yMRa
 525L8UgeAJK5KIT/8ocqJuC+07b6qCHHfUZL5eUn0vpsZznJy8xgoYFmjJH5UiXh/cKC 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ej9stdsr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:58 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222GI2IK002374;
        Wed, 2 Mar 2022 18:11:57 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ej9stdsph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:57 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222I9L3q030189;
        Wed, 2 Mar 2022 18:11:53 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3egbj1aq9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:53 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222IBoPr50069980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 18:11:50 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10E5852051;
        Wed,  2 Mar 2022 18:11:50 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.5.37])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 884F75204F;
        Wed,  2 Mar 2022 18:11:49 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v8 10/17] KVM: s390: pv: add mmu_notifier
Date:   Wed,  2 Mar 2022 19:11:36 +0100
Message-Id: <20220302181143.188283-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302181143.188283-1-imbrenda@linux.ibm.com>
References: <20220302181143.188283-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GHnkH1XOI-llThQbdH1Gr4x1-ixts6se
X-Proofpoint-ORIG-GUID: 8vqvn6fHrBz6aFbgOaYfQ_m-xfQ4Iw0q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an mmu_notifier for protected VMs. The callback function is
triggered when the mm is torn down, and will attempt to convert all
protected vCPUs to non-protected. This allows the mm teardown to use
the destroy page UVC instead of export.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/kvm-s390.c         |  5 ++++-
 arch/s390/kvm/pv.c               | 26 ++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a22c9266ea05..1bccb8561ba9 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -19,6 +19,7 @@
 #include <linux/kvm.h>
 #include <linux/seqlock.h>
 #include <linux/module.h>
+#include <linux/mmu_notifier.h>
 #include <asm/debug.h>
 #include <asm/cpu.h>
 #include <asm/fpu/api.h>
@@ -921,6 +922,7 @@ struct kvm_s390_pv {
 	u64 guest_len;
 	unsigned long stor_base;
 	void *stor_var;
+	struct mmu_notifier mmu_notifier;
 };
 
 struct kvm_arch{
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 21fcca09e9bf..446f89db93a1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -32,6 +32,7 @@
 #include <linux/sched/signal.h>
 #include <linux/string.h>
 #include <linux/pgtable.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/lowcore.h>
@@ -2833,8 +2834,10 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	 * can mess with the pv state. To avoid lockdep_assert_held from
 	 * complaining we do not use kvm_s390_pv_is_protected.
 	 */
-	if (kvm_s390_pv_get_handle(kvm))
+	if (kvm_s390_pv_get_handle(kvm)) {
 		kvm_s390_pv_deinit_vm(kvm, &rc, &rrc);
+		mmu_notifier_unregister(&kvm->arch.pv.mmu_notifier, kvm->mm);
+	}
 	debug_unregister(kvm->arch.dbf);
 	free_page((unsigned long)kvm->arch.sie_page2);
 	if (!kvm_is_ucontrol(kvm))
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 76ef33a277d3..788b96b36931 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -14,6 +14,7 @@
 #include <asm/mman.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
+#include <linux/mmu_notifier.h>
 #include "kvm-s390.h"
 
 static void kvm_s390_clear_pv_state(struct kvm *kvm)
@@ -192,6 +193,26 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	return -EIO;
 }
 
+static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
+					     struct mm_struct *mm)
+{
+	struct kvm *kvm = container_of(subscription, struct kvm, arch.pv.mmu_notifier);
+	u16 dummy;
+
+	/*
+	 * No locking is needed since this is the last thread of the last user of this
+	 * struct mm.
+	 * When the struct kvm gets deinitialized, this notifier is also
+	 * unregistered. This means that if this notifier runs, then the
+	 * struct kvm is still valid.
+	 */
+	kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
+}
+
+static const struct mmu_notifier_ops kvm_s390_pv_mmu_notifier_ops = {
+	.release = kvm_s390_pv_mmu_notifier_release,
+};
+
 int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	struct uv_cb_cgc uvcb = {
@@ -233,6 +254,11 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 		return -EIO;
 	}
 	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
+	/* Add the notifier only once. No races because we hold kvm->lock */
+	if (kvm->arch.pv.mmu_notifier.ops != &kvm_s390_pv_mmu_notifier_ops) {
+		kvm->arch.pv.mmu_notifier.ops = &kvm_s390_pv_mmu_notifier_ops;
+		mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
+	}
 	return 0;
 }
 
-- 
2.34.1

