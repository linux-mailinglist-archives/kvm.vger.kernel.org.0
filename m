Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5C955E7DE
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347041AbiF1N4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346927AbiF1N4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:56:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48A333362;
        Tue, 28 Jun 2022 06:56:30 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SDB0qp016651;
        Tue, 28 Jun 2022 13:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3P7BoWHuK6KWnf/a5LWzOGbKKQ6lJZQ8pwtl92e4Gj4=;
 b=Ru3MeQALpYiBCStR/50cCGRxoZpZ8bFNBUJRwi6J582FCZEfj/TK/v+1FDjyDAs95NLO
 Thn5wdRDfa10c+Kup0RibgZH5l7U3XJ5xv7zGh5y7OoW49Sv+PMQTQ96Eh6PJ8o0aRjT
 Egygb1+rCcW/mYeSsn9jlvsIpsdL+lF6XHTvNu/S/5ifwPAAM8s5T6gOokhiOXHVNGFE
 04S/RH6TXJhvcUXD50D/wNLCYuv+sXvISY5XgZcqLr7Td4i/MYZmOYp9noXCLn3WL2nl
 LS5RT2S4u3xAjiewnsp9Lns8Hn57Utup3gpRRsOZgdKAlhsD5P0utglZW3zqUXTbg9QW PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h01tjb25q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:30 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SDBLPE017745;
        Tue, 28 Jun 2022 13:56:29 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h01tjb24j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:29 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SDqHAF006588;
        Tue, 28 Jun 2022 13:56:27 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3gwt093pdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SDuOlY15728954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 13:56:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E376E4C046;
        Tue, 28 Jun 2022 13:56:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8564C4C044;
        Tue, 28 Jun 2022 13:56:23 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 13:56:23 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v12 09/18] KVM: s390: pv: add mmu_notifier
Date:   Tue, 28 Jun 2022 15:56:10 +0200
Message-Id: <20220628135619.32410-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628135619.32410-1-imbrenda@linux.ibm.com>
References: <20220628135619.32410-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Yb25RlAb1D7mowwcMeUv0zmB3A-OzUEU
X-Proofpoint-ORIG-GUID: pEXhCiUzK3jAL8dhEazCSxuZ-pIKgiTS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an mmu_notifier for protected VMs. The callback function is
triggered when the mm is torn down, and will attempt to convert all
protected vCPUs to non-protected. This allows the mm teardown to use
the destroy page UVC instead of export.

Also make KVM select CONFIG_MMU_NOTIFIER, needed to use mmu_notifiers.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/Kconfig            |  1 +
 arch/s390/kvm/kvm-s390.c         | 10 ++++++++++
 arch/s390/kvm/pv.c               | 26 ++++++++++++++++++++++++++
 4 files changed, 39 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 766028d54a3e..5824efe5fc9d 100644
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
@@ -923,6 +924,7 @@ struct kvm_s390_pv {
 	u64 guest_len;
 	unsigned long stor_base;
 	void *stor_var;
+	struct mmu_notifier mmu_notifier;
 };
 
 struct kvm_arch{
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 2e84d3922f7c..33f4ff909476 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -34,6 +34,7 @@ config KVM
 	select SRCU
 	select KVM_VFIO
 	select INTERVAL_TREE
+	select MMU_NOTIFIER
 	help
 	  Support hosting paravirtualized guest machines using the SIE
 	  virtualization capability on the mainframe. This should work
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 40e61631b13d..6b63e0605a51 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -31,6 +31,7 @@
 #include <linux/sched/signal.h>
 #include <linux/string.h>
 #include <linux/pgtable.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/lowcore.h>
@@ -2928,6 +2929,15 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	 */
 	if (kvm_s390_pv_get_handle(kvm))
 		kvm_s390_pv_deinit_vm(kvm, &rc, &rrc);
+	/*
+	 * Remove the mmu notifier only when the whole KVM VM is torn down,
+	 * and only if one was registered to begin with. If the VM is
+	 * currently not protected, but has been previously been protected,
+	 * then it's possible that the notifier is still registered.
+	 */
+	if (kvm->arch.pv.mmu_notifier.ops)
+		mmu_notifier_unregister(&kvm->arch.pv.mmu_notifier, kvm->mm);
+
 	debug_unregister(kvm->arch.dbf);
 	free_page((unsigned long)kvm->arch.sie_page2);
 	if (!kvm_is_ucontrol(kvm))
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 9eca80afedce..da1bae111fb1 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -14,6 +14,7 @@
 #include <asm/mman.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
+#include <linux/mmu_notifier.h>
 #include "kvm-s390.h"
 
 static void kvm_s390_clear_pv_state(struct kvm *kvm)
@@ -187,6 +188,26 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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
@@ -228,6 +249,11 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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
2.36.1

