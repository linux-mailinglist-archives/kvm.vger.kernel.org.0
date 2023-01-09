Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC7C66310A
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 21:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237715AbjAIULJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 15:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237591AbjAIUKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 15:10:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BCEDF4;
        Mon,  9 Jan 2023 12:10:51 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309JI64o031270;
        Mon, 9 Jan 2023 20:10:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vHxtIZVNhh1Xt+rXy3HWXJ4MJLBlSbXgyKBEB0LRDyA=;
 b=So2+siRKzoLNWU/BTwDQgxfOT/hhxrjoI263w98bub0CrYm1zQqvY81F5lW/u2Oo2BPk
 Fa9y+UUeaiXma8p4bP5jEq/+4sJv8C4snheoW+/KAbHBBJQEqtsvL+Zga+QBY6lUc4eu
 sQbHZ3C76glHCVdtVNvzwiXT34CACjgeFAoYzoUDCTj41NWojtJCQCKMOHH4bvnmwRWL
 lkAdgUsUYYjIxRfis0m+racwNvWqLZloHmq37gDvqCRMsIi1lrgLwMPWaRp9jDAMaLi+
 3xKqtYpSKN9S0fx0FxTfPDaPoCTxzmlAqOJMPCDAteU5LW0GnTp4/KIU6k47w/mNFREH EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n0rya14dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 20:10:47 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 309Jw26E002748;
        Mon, 9 Jan 2023 20:10:46 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n0rya14df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 20:10:46 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 309Ipw3X021901;
        Mon, 9 Jan 2023 20:10:45 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3my0c7s31c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 20:10:45 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 309KAhYx8520276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Jan 2023 20:10:43 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52F4E5804E;
        Mon,  9 Jan 2023 20:10:43 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 263735803F;
        Mon,  9 Jan 2023 20:10:41 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.65.251.44])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  9 Jan 2023 20:10:41 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, pbonzini@redhat.com
Cc:     jgg@nvidia.com, cohuck@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: async kvm_destroy_vm for vfio devices
Date:   Mon,  9 Jan 2023 15:10:36 -0500
Message-Id: <20230109201037.33051-2-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230109201037.33051-1-mjrosato@linux.ibm.com>
References: <20230109201037.33051-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tdfzrYQRmVh1fRlcbDJIR3XrFlvpcnTo
X-Proofpoint-GUID: 7iW8hCGahZOrmV06uujJOxGDrV1T4EEc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_14,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 spamscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently it is possible that the final put of a KVM reference comes from
vfio during its device close operation.  This occurs while the vfio group
lock is held; however, if the vfio device is still in the kvm device list,
then the following call chain could result in a deadlock:

kvm_put_kvm
 -> kvm_destroy_vm
  -> kvm_destroy_devices
   -> kvm_vfio_destroy
    -> kvm_vfio_file_set_kvm
     -> vfio_file_set_kvm
      -> group->group_lock/group_rwsem

Avoid this scenario by adding kvm_put_kvm_async which will perform the
kvm_destroy_vm asynchronously if the refcount reaches 0.

Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c  |  6 +++++-
 drivers/s390/crypto/vfio_ap_ops.c |  7 ++++++-
 include/linux/kvm_host.h          |  3 +++
 virt/kvm/kvm_main.c               | 22 ++++++++++++++++++++++
 4 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 8ae7039b3683..24511c877572 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -703,7 +703,11 @@ static void intel_vgpu_close_device(struct vfio_device *vfio_dev)
 
 	kvm_page_track_unregister_notifier(vgpu->vfio_device.kvm,
 					   &vgpu->track_node);
-	kvm_put_kvm(vgpu->vfio_device.kvm);
+	/*
+	 * Avoid possible deadlock on any currently-held vfio lock by
+	 * ensuring the potential kvm_destroy_vm call is done asynchronously
+	 */
+	kvm_put_kvm_async(vgpu->vfio_device.kvm);
 
 	kvmgt_protect_table_destroy(vgpu);
 	gvt_cache_destroy(vgpu);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e93bb9c468ce..a37b2baefb36 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1574,7 +1574,12 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 
 		kvm_arch_crypto_clear_masks(kvm);
 		vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
-		kvm_put_kvm(kvm);
+		/*
+		 * Avoid possible deadlock on any currently-held vfio lock by
+		 * ensuring the potential kvm_destroy_vm call is done
+		 * asynchronously
+		 */
+		kvm_put_kvm_async(kvm);
 		matrix_mdev->kvm = NULL;
 
 		release_update_locks_for_kvm(kvm);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4f26b244f6d0..2ef6a5102265 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -34,6 +34,7 @@
 #include <linux/instrumentation.h>
 #include <linux/interval_tree.h>
 #include <linux/rbtree.h>
+#include <linux/workqueue.h>
 #include <linux/xarray.h>
 #include <asm/signal.h>
 
@@ -793,6 +794,7 @@ struct kvm {
 	struct kvm_stat_data **debugfs_stat_data;
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
+	struct work_struct async_work;
 	pid_t userspace_pid;
 	bool override_halt_poll_ns;
 	unsigned int max_halt_poll_ns;
@@ -963,6 +965,7 @@ void kvm_exit(void);
 void kvm_get_kvm(struct kvm *kvm);
 bool kvm_get_kvm_safe(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
+void kvm_put_kvm_async(struct kvm *kvm);
 bool file_is_kvm(struct file *file);
 void kvm_put_kvm_no_destroy(struct kvm *kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13e88297f999..fbe8d127028b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1353,6 +1353,28 @@ void kvm_put_kvm(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_put_kvm);
 
+static void kvm_put_async_fn(struct work_struct *work)
+{
+	struct kvm *kvm = container_of(work, struct kvm,
+				       async_work);
+
+	kvm_destroy_vm(kvm);
+}
+
+/*
+ * Put a reference but only destroy the vm asynchronously.  Can be used in
+ * cases where the caller holds a mutex that could cause deadlock if
+ * kvm_destroy_vm is triggered
+ */
+void kvm_put_kvm_async(struct kvm *kvm)
+{
+	if (refcount_dec_and_test(&kvm->users_count)) {
+		INIT_WORK(&kvm->async_work, kvm_put_async_fn);
+		schedule_work(&kvm->async_work);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_put_kvm_async);
+
 /*
  * Used to put a reference that was taken on behalf of an object associated
  * with a user-visible file descriptor, e.g. a vcpu or device, if installation
-- 
2.39.0

