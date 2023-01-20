Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5638D675814
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 16:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjATPFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 10:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjATPFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 10:05:32 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C888B7CCC1;
        Fri, 20 Jan 2023 07:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674227131; x=1705763131;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Zn183ElO1bl64Y4pVPfF7h7rDHD+/IuJAJiKiAAXWvc=;
  b=F/0vIVpVwojTbSAlnf2veNQ3B7J09FMvOPCmAYS/wa+rX8SN9SZwu//F
   g27XxVYnlUsdx8FXerODDMbpDy6DaRZaL3aC3GBItoxhEjMNzDFtHNiMt
   gvgmlJVnNEP3sGPBrIwWceEyFKJkIBKb8AVshNFSBOJ73fvqW5FZIHANP
   iVzvG5cOsXYXT/hrVZKdA7hfxloRxb3FbQ66Vi9qQSaP6b5AJQrI2+/j4
   0FepJEMCN/xG818aDRDF7mWx8VZKknMtjjRbh1vquc0Zww9VUHaUasmQP
   5mBp8p7uwepP1pp8+fqrWjgLBj8/WSx/YTOj53x+s05xlsCUlb6HjWlXj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="309169480"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="309169480"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 07:05:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="784532388"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="784532388"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga004.jf.intel.com with ESMTP; 20 Jan 2023 07:05:30 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, pbonzini@redhat.com,
        mjrosato@linux.ibm.com
Cc:     yi.l.liu@intel.com, jgg@nvidia.com, kevin.tian@intel.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, seanjc@google.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm/vfio: Fix potential deadlock on vfio group_lock
Date:   Fri, 20 Jan 2023 07:05:28 -0800
Message-Id: <20230120150528.471752-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently it is possible that the final put of a KVM reference comes from
vfio during its device close operation.  This occurs while the vfio group
lock is held; however, if the vfio device is still in the kvm device list,
then the following call chain could result in a deadlock:

VFIO holds group->group_lock/group_rwsem
  -> kvm_put_kvm
   -> kvm_destroy_vm
    -> kvm_destroy_devices
     -> kvm_vfio_destroy
      -> kvm_vfio_file_set_kvm
       -> vfio_file_set_kvm
        -> try to hold group->group_lock/group_rwsem

The key function is the kvm_destroy_devices() which triggers destroy cb
of kvm_device_ops. It calls back to vfio and try to hold group_lock. So
if this path doesn't call back to vfio, this dead lock would be fixed.
Actually, there is a way for it. KVM provides another point to free the
kvm-vfio device which is the point when the device file descriptor is
closed. This can be achieved by providing the release cb instead of the
destroy cb. Also rename kvm_vfio_destroy() to be kvm_vfio_release().

	/*
	 * Destroy is responsible for freeing dev.
	 *
	 * Destroy may be called before or after destructors are called
	 * on emulated I/O regions, depending on whether a reference is
	 * held by a vcpu or other kvm component that gets destroyed
	 * after the emulated I/O.
	 */
	void (*destroy)(struct kvm_device *dev);

	/*
	 * Release is an alternative method to free the device. It is
	 * called when the device file descriptor is closed. Once
	 * release is called, the destroy method will not be called
	 * anymore as the device is removed from the device list of
	 * the VM. kvm->lock is held.
	 */
	void (*release)(struct kvm_device *dev);

Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 virt/kvm/vfio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 495ceabffe88..e94f3ea718e5 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -336,7 +336,7 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
 	return -ENXIO;
 }
 
-static void kvm_vfio_destroy(struct kvm_device *dev)
+static void kvm_vfio_release(struct kvm_device *dev)
 {
 	struct kvm_vfio *kv = dev->private;
 	struct kvm_vfio_group *kvg, *tmp;
@@ -363,7 +363,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type);
 static struct kvm_device_ops kvm_vfio_ops = {
 	.name = "kvm-vfio",
 	.create = kvm_vfio_create,
-	.destroy = kvm_vfio_destroy,
+	.release = kvm_vfio_release,
 	.set_attr = kvm_vfio_set_attr,
 	.has_attr = kvm_vfio_has_attr,
 };
-- 
2.34.1

