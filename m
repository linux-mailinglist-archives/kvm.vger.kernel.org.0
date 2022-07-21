Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4F157D113
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbiGUQOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbiGUQNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6717D88F24;
        Thu, 21 Jul 2022 09:13:41 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFmcYr020195;
        Thu, 21 Jul 2022 16:13:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=WWfExIT8MljTN4dlDqgpTbHxll62RWkHMhmqEhFh9Jg=;
 b=aiBQhegxmX34SpTGAXRc+zEqKXEsnBGLqXMC0h5TJlRZe0DJFcYIbmEdjlOne5+OLitf
 yyUgsHFr1hX96FrnPMuI3w68uIxXtyDo4HrmJ//m0JlHZP8f7pH7JTU4v5Mg2APWLXpt
 /AzWfK2LigwDuQIVlBkGpwgbZ6zGgx+Q5GxzfRsbkAo8DagEHba9zrLhl1/QF7Pdry45
 6Z5C9VRl52qs3jali2PLoyrTItsfBv2WpuaWidJTcxyXaGbg0YOS7igqOpmUm5OJBMMx
 OV+6x1y+7E2ziw3Gy8QLZ9/ktCFDlIamBe1a8hbd3qXeCBpzYk3MRU+v62IEMqdIBCnU sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9s4rsuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:32 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFoha0031361;
        Thu, 21 Jul 2022 16:13:31 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9s4rst6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:31 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG6rpQ002723;
        Thu, 21 Jul 2022 16:13:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3hbmy8nf1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGBbNf20513032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:11:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCF1FA405F;
        Thu, 21 Jul 2022 16:13:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 423ACA4054;
        Thu, 21 Jul 2022 16:13:25 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:25 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [GIT PULL 35/42] KVM: s390: pv: add mmu_notifier
Date:   Thu, 21 Jul 2022 18:12:55 +0200
Message-Id: <20220721161302.156182-36-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: v7MJWUStj9xGskrMpRK4kzZAokYRpNl2
X-Proofpoint-GUID: wF5PsK9WELc15hs3FJRtR11x1GqYQj8C
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
Link: https://lore.kernel.org/r/20220628135619.32410-10-imbrenda@linux.ibm.com
Message-Id: <20220628135619.32410-10-imbrenda@linux.ibm.com>
[frankja@linux.ibm.com: Conflict resolution for mmu_notifier.h include
and struct kvm_s390_pv]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/Kconfig            |  1 +
 arch/s390/kvm/kvm-s390.c         | 10 ++++++++++
 arch/s390/kvm/pv.c               | 26 ++++++++++++++++++++++++++
 4 files changed, 39 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index fca4fcf72a2a..6f9fc8bb0303 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -20,6 +20,7 @@
 #include <linux/seqlock.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/mmu_notifier.h>
 #include <asm/debug.h>
 #include <asm/cpu.h>
 #include <asm/fpu/api.h>
@@ -929,6 +930,7 @@ struct kvm_s390_pv {
 	unsigned long stor_base;
 	void *stor_var;
 	bool dumping;
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
index d10c3b163cdc..5b77c43fbb01 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -31,6 +31,7 @@
 #include <linux/sched/signal.h>
 #include <linux/string.h>
 #include <linux/pgtable.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/lowcore.h>
@@ -3198,6 +3199,15 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
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
index d18c5ccfa5dc..c063d1a9cf04 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -15,6 +15,7 @@
 #include <asm/mman.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
+#include <linux/mmu_notifier.h>
 #include "kvm-s390.h"
 
 static void kvm_s390_clear_pv_state(struct kvm *kvm)
@@ -188,6 +189,26 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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
@@ -229,6 +250,11 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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

