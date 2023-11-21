Return-Path: <kvm+bounces-2150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D8A7F245D
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 03:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5071A28292A
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 02:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C31D1A599;
	Tue, 21 Nov 2023 02:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PeDlf3uy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E474EE3;
	Mon, 20 Nov 2023 18:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700535035; x=1732071035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sGKE6kuIb+hb0CTMJZeKnZPATK+YHZfkRj39W2TIkQA=;
  b=PeDlf3uy6kBWxQf2WjS0ax8xQODnoRaT6HZLkrzL68NrPjJZXwT/o5sD
   XcW22EKRRIchPAwsriuf9aAXF/+c++6tKSVxosvTNG90sYwta343vwDEn
   ld9nOAcktV2DmQPphbx7dwOlC0bQNClVKHlR1nD6lsDrbr4EPu6lHagqF
   VQnySxobZa9KE5i3S0AD6eQnU1CcIi2WUoyBisUCItKYlajpcGvzFK4tB
   PuavZyXcOPFxEZAXGGJHmLxn2C0NeaTMRYZXxoayUFd8Gy3EPmI43hpjo
   nAmz+wm4sOnlxr+W+l780gFR1EUaQ1n4UgtYnHy1buh2Ddu5oAKN9Pday
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="458246136"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="458246136"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 18:50:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="832488585"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="832488585"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.85])
  by fmsmga008.fm.intel.com with ESMTP; 20 Nov 2023 18:50:25 -0800
From: Yahui Cao <yahui.cao@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	lingyu.liu@intel.com,
	kevin.tian@intel.com,
	madhu.chittim@intel.com,
	sridhar.samudrala@intel.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	brett.creeley@amd.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Subject: [PATCH iwl-next v4 10/12] ice: Add device suspend function for migration
Date: Tue, 21 Nov 2023 02:51:09 +0000
Message-Id: <20231121025111.257597-11-yahui.cao@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231121025111.257597-1-yahui.cao@intel.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lingyu Liu <lingyu.liu@intel.com>

Device suspend handler is called by vfio driver before saving device
state. Typical operation includes stopping TX/RX queue.

Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
---
 .../net/ethernet/intel/ice/ice_migration.c    | 69 +++++++++++++++++++
 include/linux/net/intel/ice_migration.h       |  6 ++
 2 files changed, 75 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_migration.c b/drivers/net/ethernet/intel/ice/ice_migration.c
index 082ae2b79f60..a11cd0d3ad3d 100644
--- a/drivers/net/ethernet/intel/ice/ice_migration.c
+++ b/drivers/net/ethernet/intel/ice/ice_migration.c
@@ -2,6 +2,8 @@
 /* Copyright (C) 2018-2023 Intel Corporation */
 
 #include "ice.h"
+#include "ice_lib.h"
+#include "ice_fltr.h"
 #include "ice_base.h"
 #include "ice_txrx_lib.h"
 
@@ -274,6 +276,73 @@ u32 ice_migration_supported_caps(void)
 	return VIRTCHNL_VF_MIGRATION_SUPPORT_FEATURE;
 }
 
+/**
+ * ice_migration_suspend_dev - suspend device
+ * @pf: pointer to PF of migration device
+ * @vf_id: VF index of migration device
+ *
+ * Return 0 for success, negative for error
+ */
+int ice_migration_suspend_dev(struct ice_pf *pf, int vf_id)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_vsi *vsi;
+	struct ice_vf *vf;
+	int ret;
+
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf) {
+		dev_err(dev, "Unable to locate VF from VF ID%d\n", vf_id);
+		return -EINVAL;
+	}
+
+	if (!test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states)) {
+		ret = 0;
+		goto out_put_vf;
+	}
+
+	if (vf->virtchnl_msg_num > VIRTCHNL_MSG_MAX) {
+		dev_err(dev, "SR-IOV live migration disabled on VF %d. Migration buffer exceeded\n",
+			vf->vf_id);
+		ret = -EIO;
+		goto out_put_vf;
+	}
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		ret = -EINVAL;
+		goto out_put_vf;
+	}
+
+	/* Prevent VSI from queuing incoming packets by removing all filters */
+	ice_fltr_remove_all(vsi);
+
+	/* MAC based filter rule is disabled at this point. Set MAC to zero
+	 * to keep consistency with VF mac address info shown by ip link
+	 */
+	eth_zero_addr(vf->hw_lan_addr);
+	eth_zero_addr(vf->dev_lan_addr);
+
+	ret = ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, vf->vf_id);
+	if (ret) {
+		dev_err(dev, "VF %d failed to stop tx rings\n", vf->vf_id);
+		ret = -EIO;
+		goto out_put_vf;
+	}
+	ret = ice_vsi_stop_all_rx_rings(vsi);
+	if (ret) {
+		dev_err(dev, "VF %d failed to stop rx rings\n", vf->vf_id);
+		ret = -EIO;
+		goto out_put_vf;
+	}
+
+out_put_vf:
+	ice_put_vf(vf);
+	return ret;
+}
+EXPORT_SYMBOL(ice_migration_suspend_dev);
+
 /**
  * ice_migration_save_rx_head - save rx head into device state buffer
  * @vf: pointer to VF structure
diff --git a/include/linux/net/intel/ice_migration.h b/include/linux/net/intel/ice_migration.h
index a142b78283a8..47f46dca07ae 100644
--- a/include/linux/net/intel/ice_migration.h
+++ b/include/linux/net/intel/ice_migration.h
@@ -14,6 +14,7 @@ int ice_migration_save_devstate(struct ice_pf *pf, int vf_id,
 				u8 *buf, u64 buf_sz);
 int ice_migration_load_devstate(struct ice_pf *pf, int vf_id,
 				const u8 *buf, u64 buf_sz);
+int ice_migration_suspend_dev(struct ice_pf *pf, int vf_id);
 #else
 static inline struct ice_pf *ice_migration_get_pf(struct pci_dev *pdev)
 {
@@ -37,6 +38,11 @@ static inline int ice_migration_load_devstate(struct ice_pf *pf, int vf_id,
 {
 	return 0;
 }
+
+static inline int ice_migration_suspend_dev(struct ice_pf *pf, int vf_id)
+{
+	return 0;
+}
 #endif /* CONFIG_ICE_VFIO_PCI */
 
 #endif /* _ICE_MIGRATION_H_ */
-- 
2.34.1


