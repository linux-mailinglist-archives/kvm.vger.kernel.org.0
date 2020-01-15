Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD86C13B896
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 05:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbgAOEEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 23:04:12 -0500
Received: from mga06.intel.com ([134.134.136.31]:26364 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728879AbgAOEEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 23:04:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 20:04:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,321,1574150400"; 
   d="scan'208";a="217983429"
Received: from unknown (HELO joy-OptiPlex-7040.sh.intel.com) ([10.239.13.9])
  by orsmga008.jf.intel.com with ESMTP; 14 Jan 2020 20:04:09 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     zhenyuw@linux.intel.com
Cc:     alex.williamson@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, peterx@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 2/2] drm/i915/gvt: subsitute kvm_read/write_guest with vfio_dma_rw
Date:   Tue, 14 Jan 2020 22:54:55 -0500
Message-Id: <20200115035455.12417-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200115034132.2753-1-yan.y.zhao@intel.com>
References: <20200115034132.2753-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a device model, it is better to read/write guest memory using vfio
interface, so that vfio is able to maintain dirty info of device IOVAs.

Compared to kvm interfaces kvm_read/write_guest(), vfio_dma_rw() has ~600
cycles more overhead on average.

-------------------------------------
|    interface     | avg cpu cycles |
|-----------------------------------|
| kvm_write_guest  |     1554       |
| ----------------------------------|
| kvm_read_guest   |     707        |
|-----------------------------------|
| vfio_dma_rw(w)   |     2274       |
|-----------------------------------|
| vfio_dma_rw(r)   |     1378       |
-------------------------------------

Comparison of benchmarks scores are as blow:
------------------------------------------------------
|  avg score  | kvm_read/write_guest  | vfio_dma_rw  |
|----------------------------------------------------|
|   Glmark2   |         1284          |    1296      |
|----------------------------------------------------|
|  Lightsmark |         61.24         |    61.27     |
|----------------------------------------------------|
|  OpenArena  |         140.9         |    137.4     |
|----------------------------------------------------|
|   Heaven    |          671          |     670      |
------------------------------------------------------
No obvious performance downgrade found.

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index bd79a9718cc7..17edc9a7ff05 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1966,31 +1966,19 @@ static int kvmgt_rw_gpa(unsigned long handle, unsigned long gpa,
 			void *buf, unsigned long len, bool write)
 {
 	struct kvmgt_guest_info *info;
-	struct kvm *kvm;
-	int idx, ret;
-	bool kthread = current->mm == NULL;
+	int ret;
+	struct intel_vgpu *vgpu;
+	struct device *dev;
 
 	if (!handle_valid(handle))
 		return -ESRCH;
 
 	info = (struct kvmgt_guest_info *)handle;
-	kvm = info->kvm;
-
-	if (kthread) {
-		if (!mmget_not_zero(kvm->mm))
-			return -EFAULT;
-		use_mm(kvm->mm);
-	}
-
-	idx = srcu_read_lock(&kvm->srcu);
-	ret = write ? kvm_write_guest(kvm, gpa, buf, len) :
-		      kvm_read_guest(kvm, gpa, buf, len);
-	srcu_read_unlock(&kvm->srcu, idx);
+	vgpu = info->vgpu;
+	dev = mdev_dev(vgpu->vdev.mdev);
 
-	if (kthread) {
-		unuse_mm(kvm->mm);
-		mmput(kvm->mm);
-	}
+	ret = write ? vfio_dma_rw(dev, gpa, buf, len, true) :
+			vfio_dma_rw(dev, gpa, buf, len, false);
 
 	return ret;
 }
-- 
2.17.1

