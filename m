Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1929153C579
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 08:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241965AbiFCG5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 02:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241802AbiFCG5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 02:57:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC48100D;
        Thu,  2 Jun 2022 23:56:56 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2536hmr4031257;
        Fri, 3 Jun 2022 06:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nsBlNp11SaBNkoYS6W0XaE7NNohptPb9EKep9NhfNqw=;
 b=kaxwPu17bFo6lQj2iZ5HxpKqcBcpb7iVaowgJOti2krbfDRbNdvoAwukv5YwtdcDPSBo
 3YKIVMMQ/Z+UZdAbLC+t6nhozgE+DhDzpNpoLYc1nKKSkv3y/UixQqFF+KBfrjrYZDQ2
 /wwz7cGo5ljaBAVYpUdbxvqQxutXDF3JDg4Sz7hag1d5XETzmeyMAQWX37LRJY2AVeAT
 xKHlaDeYodG7LwS+dcm4rH92FQSzD1773D8qj0y8+4FJFIgw9GQlpS5AVb85QcoEMzay
 Nz7biC00/iuM4Vpx9S+KZ2VeKHwYpnJNGsq60QeWEQGhKZeReEnkFZw5sbWkMTdDCkRS lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfd9r85s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:56 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2536obBJ020119;
        Fri, 3 Jun 2022 06:56:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfd9r85rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2536pU16007387;
        Fri, 3 Jun 2022 06:56:53 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3gbc7h81x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:53 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2536uiuT19857830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 06:56:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F43142042;
        Fri,  3 Jun 2022 06:56:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F3574203F;
        Fri,  3 Jun 2022 06:56:50 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 06:56:50 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v11 10/19] KVM: s390: pv: add mmu_notifier
Date:   Fri,  3 Jun 2022 08:56:36 +0200
Message-Id: <20220603065645.10019-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603065645.10019-1-imbrenda@linux.ibm.com>
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: K5Je0-6LEf7iQ0WXHQjTLCCmiRhXJe5q
X-Proofpoint-GUID: JtiWep8X7ZDMF0lPSJjESrjOQz67RCIs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_01,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030027
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
index 8973985593a9..fe1fa896def7 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -31,6 +31,7 @@
 #include <linux/sched/signal.h>
 #include <linux/string.h>
 #include <linux/pgtable.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/lowcore.h>
@@ -2937,6 +2938,15 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
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

