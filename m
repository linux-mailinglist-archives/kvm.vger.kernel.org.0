Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42632183F94
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 04:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgCMDVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 23:21:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:10778 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbgCMDVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 23:21:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 20:21:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="278065929"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga002.fm.intel.com with ESMTP; 12 Mar 2020 20:21:20 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, zhenyuw@linux.intel.com,
        pbonzini@redhat.com, kevin.tian@intel.com, peterx@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 6/7] drm/i915/gvt: switch to user vfio_group_pin/upin_pages
Date:   Thu, 12 Mar 2020 23:11:51 -0400
Message-Id: <20200313031151.8042-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313030548.7705-1-yan.y.zhao@intel.com>
References: <20200313030548.7705-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

substitute vfio_pin_pages() and vfio_unpin_pages() with
vfio_group_pin_pages() and vfio_group_unpin_pages(), so that
it will not go through looking up, checking, referencing,
dereferencing of VFIO group in each call.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index cee7376ba39d..eee530453aa6 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -152,6 +152,7 @@ static void gvt_unpin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
 		unsigned long size)
 {
 	struct drm_i915_private *i915 = vgpu->gvt->gt->i915;
+	struct kvmgt_vdev *vdev = kvmgt_vdev(vgpu);
 	int total_pages;
 	int npage;
 	int ret;
@@ -161,7 +162,7 @@ static void gvt_unpin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
 	for (npage = 0; npage < total_pages; npage++) {
 		unsigned long cur_gfn = gfn + npage;
 
-		ret = vfio_unpin_pages(mdev_dev(kvmgt_vdev(vgpu)->mdev), &cur_gfn, 1);
+		ret = vfio_group_unpin_pages(vdev->vfio_group, &cur_gfn, 1);
 		drm_WARN_ON(&i915->drm, ret != 1);
 	}
 }
@@ -170,6 +171,7 @@ static void gvt_unpin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
 static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
 		unsigned long size, struct page **page)
 {
+	struct kvmgt_vdev *vdev = kvmgt_vdev(vgpu);
 	unsigned long base_pfn = 0;
 	int total_pages;
 	int npage;
@@ -184,8 +186,8 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
 		unsigned long cur_gfn = gfn + npage;
 		unsigned long pfn;
 
-		ret = vfio_pin_pages(mdev_dev(kvmgt_vdev(vgpu)->mdev), &cur_gfn, 1,
-				     IOMMU_READ | IOMMU_WRITE, &pfn);
+		ret = vfio_group_pin_pages(vdev->vfio_group, &cur_gfn, 1,
+					   IOMMU_READ | IOMMU_WRITE, &pfn);
 		if (ret != 1) {
 			gvt_vgpu_err("vfio_pin_pages failed for gfn 0x%lx, ret %d\n",
 				     cur_gfn, ret);
-- 
2.17.1

