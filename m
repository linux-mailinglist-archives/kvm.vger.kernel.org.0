Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 953ED16A0D5
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 09:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgBXI5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 03:57:22 -0500
Received: from mga17.intel.com ([192.55.52.151]:28743 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbgBXI5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 03:57:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 00:57:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,479,1574150400"; 
   d="scan'208";a="231068861"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga008.fm.intel.com with ESMTP; 24 Feb 2020 00:57:19 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     zhenyuw@linux.intel.com
Cc:     alex.williamson@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, peterx@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 4/7] drm/i915/gvt: hold reference of VFIO group during opening of vgpu
Date:   Mon, 24 Feb 2020 03:47:56 -0500
Message-Id: <20200224084756.31851-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224084350.31574-1-yan.y.zhao@intel.com>
References: <20200224084350.31574-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hold reference count of the VFIO group for each vgpu at vgpu opening and
release the reference at vgpu releasing.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/gpu/drm/i915/gvt/gvt.h   |  1 +
 drivers/gpu/drm/i915/gvt/kvmgt.c | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index 0081b051d3e0..5230ac80b84c 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -219,6 +219,7 @@ struct intel_vgpu {
 		struct work_struct release_work;
 		atomic_t released;
 		struct vfio_device *vfio_device;
+		struct vfio_group *vfio_group;
 	} vdev;
 #endif
 
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index bd79a9718cc7..ed4c79cc3e09 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -747,6 +747,7 @@ static int intel_vgpu_open(struct mdev_device *mdev)
 	struct intel_vgpu *vgpu = mdev_get_drvdata(mdev);
 	unsigned long events;
 	int ret;
+	struct vfio_group *vfio_group;
 
 	vgpu->vdev.iommu_notifier.notifier_call = intel_vgpu_iommu_notifier;
 	vgpu->vdev.group_notifier.notifier_call = intel_vgpu_group_notifier;
@@ -769,6 +770,14 @@ static int intel_vgpu_open(struct mdev_device *mdev)
 		goto undo_iommu;
 	}
 
+	vfio_group = vfio_group_get_external_user_from_dev(mdev_dev(mdev));
+	if (IS_ERR_OR_NULL(vfio_group)) {
+		ret = !vfio_group ? -EFAULT : PTR_ERR(vfio_group);
+		gvt_vgpu_err("vfio_group_get_external_user_from_dev failed\n");
+		goto undo_register_group;
+	}
+	vgpu->vdev.vfio_group = vfio_group;
+
 	/* Take a module reference as mdev core doesn't take
 	 * a reference for vendor driver.
 	 */
@@ -785,6 +794,9 @@ static int intel_vgpu_open(struct mdev_device *mdev)
 	return ret;
 
 undo_group:
+	vfio_group_put_external_user(vgpu->vdev.vfio_group);
+
+undo_register_group:
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
 					&vgpu->vdev.group_notifier);
 
@@ -834,6 +846,7 @@ static void __intel_vgpu_release(struct intel_vgpu *vgpu)
 	kvmgt_guest_exit(info);
 
 	intel_vgpu_release_msi_eventfd_ctx(vgpu);
+	vfio_group_put_external_user(vgpu->vdev.vfio_group);
 
 	vgpu->vdev.kvm = NULL;
 	vgpu->handle = 0;
-- 
2.17.1

