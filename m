Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59DCF183F90
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 04:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgCMDT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 23:19:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:29662 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbgCMDT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 23:19:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 20:19:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="278065549"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga002.fm.intel.com with ESMTP; 12 Mar 2020 20:19:56 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, zhenyuw@linux.intel.com,
        pbonzini@redhat.com, kevin.tian@intel.com, peterx@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 4/7] drm/i915/gvt: hold reference of VFIO group during opening of vgpu
Date:   Thu, 12 Mar 2020 23:10:25 -0400
Message-Id: <20200313031025.7936-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313030548.7705-1-yan.y.zhao@intel.com>
References: <20200313030548.7705-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hold reference count of the VFIO group for each vgpu at vgpu opening and
release the reference at vgpu releasing.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 074c4efb58eb..811cee28ae06 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -131,6 +131,7 @@ struct kvmgt_vdev {
 	struct work_struct release_work;
 	atomic_t released;
 	struct vfio_device *vfio_device;
+	struct vfio_group *vfio_group;
 };
 
 static inline struct kvmgt_vdev *kvmgt_vdev(struct intel_vgpu *vgpu)
@@ -792,6 +793,7 @@ static int intel_vgpu_open(struct mdev_device *mdev)
 	struct kvmgt_vdev *vdev = kvmgt_vdev(vgpu);
 	unsigned long events;
 	int ret;
+	struct vfio_group *vfio_group;
 
 	vdev->iommu_notifier.notifier_call = intel_vgpu_iommu_notifier;
 	vdev->group_notifier.notifier_call = intel_vgpu_group_notifier;
@@ -814,6 +816,14 @@ static int intel_vgpu_open(struct mdev_device *mdev)
 		goto undo_iommu;
 	}
 
+	vfio_group = vfio_group_get_external_user_from_dev(mdev_dev(mdev));
+	if (IS_ERR_OR_NULL(vfio_group)) {
+		ret = !vfio_group ? -EFAULT : PTR_ERR(vfio_group);
+		gvt_vgpu_err("vfio_group_get_external_user_from_dev failed\n");
+		goto undo_register;
+	}
+	vdev->vfio_group = vfio_group;
+
 	/* Take a module reference as mdev core doesn't take
 	 * a reference for vendor driver.
 	 */
@@ -830,6 +840,10 @@ static int intel_vgpu_open(struct mdev_device *mdev)
 	return ret;
 
 undo_group:
+	vfio_group_put_external_user(vdev->vfio_group);
+	vdev->vfio_group = NULL;
+
+undo_register:
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
 					&vdev->group_notifier);
 
@@ -884,6 +898,7 @@ static void __intel_vgpu_release(struct intel_vgpu *vgpu)
 	kvmgt_guest_exit(info);
 
 	intel_vgpu_release_msi_eventfd_ctx(vgpu);
+	vfio_group_put_external_user(vdev->vfio_group);
 
 	vdev->kvm = NULL;
 	vgpu->handle = 0;
-- 
2.17.1

