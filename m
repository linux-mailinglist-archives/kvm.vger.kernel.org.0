Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A645625785
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 11:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbiKKKAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 05:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbiKKKAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 05:00:01 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2379C67F54;
        Fri, 11 Nov 2022 01:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668160795; x=1699696795;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=qWhXfxIEV1vi5i6wA8VHdj+5Ag2yRelX1mSNHmIqtBU=;
  b=HIA0we75JIBneUqIctvQoGMNLDNaWin1c40JltkglMcRBFWqXY5cGafa
   ODnd+kIe9L2qzAFKCSLZzQGGAoYyg2k+Wz2hkn22K73q2DoemdUg6Z0aB
   BAhnpJPLIp9+QYiTQtMlQUesgCIxvmf+l5pnCyzDbX4d4g7RA2jtbNuBU
   Rek1Tof7bS5Xa9MLUNXCqNjOSfbZCM4h9WNnZO139UJNEgoRAMfoHZ1xc
   bMCXtccZCNhe8XGahx9b2CZoMl7GY0YlzCelzKbdCwVf747vfmgR2izVN
   DKI9/TO7NkqZG2w7B86C702K714rZ0aD9Zzinup+i8GMkguQ8wXZ369fl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="375831178"
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="375831178"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 01:59:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="966773398"
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="966773398"
Received: from yzhao56-desk.sh.intel.com ([10.238.200.254])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 01:59:52 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org
Cc:     zhenyuw@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 2/3] drm/i915/gvt: switch from track_flush_slot to track_remove_slot
Date:   Fri, 11 Nov 2022 17:37:10 +0800
Message-Id: <20221111093710.3270-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221111093222.3148-1-yan.y.zhao@intel.com>
References: <20221111093222.3148-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVMGT only cares about when a slot is indeed removed.
So switch to use track_remove_slot which is called when a slot is removed.

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 714221f9a131..9582d047471f 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -109,7 +109,7 @@ struct gvt_dma {
 static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		const u8 *val, int len,
 		struct kvm_page_track_notifier_node *node);
-static void kvmgt_page_track_flush_slot(struct kvm *kvm,
+static void kvmgt_page_track_remove_slot(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		struct kvm_page_track_notifier_node *node);
 
@@ -673,7 +673,7 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 	gvt_cache_init(vgpu);
 
 	vgpu->track_node.track_write = kvmgt_page_track_write;
-	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
+	vgpu->track_node.track_remove_slot = kvmgt_page_track_remove_slot;
 	kvm_get_kvm(vgpu->vfio_device.kvm);
 	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
 					 &vgpu->track_node);
@@ -1617,7 +1617,7 @@ static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 						     (void *)val, len);
 }
 
-static void kvmgt_page_track_flush_slot(struct kvm *kvm,
+static void kvmgt_page_track_remove_slot(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		struct kvm_page_track_notifier_node *node)
 {
-- 
2.17.1

