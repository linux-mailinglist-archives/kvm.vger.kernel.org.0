Return-Path: <kvm+bounces-57151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A23AB50898
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 00:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48440566F40
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCFEB26E179;
	Tue,  9 Sep 2025 22:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UC/aiuSV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A88E264624;
	Tue,  9 Sep 2025 22:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757455212; cv=none; b=PN6uvfJrO+nOkMegbyanL/x1uoWpvS38X7vc8bPfKqT4fuxARRRSEM9swF6InagfrKaggKYk528q2V08D1HHushZkRvEhPrwaGMTGGM6QcG/jLBd16i+7v9zyF9r9bjY4yNup5NzPVM7z7Rhh9sW4knq1J5VijEAvcSFDNkwbRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757455212; c=relaxed/simple;
	bh=vDl7m9tMdR9eYVxyDAaaau41yOwKsEhqf87Oqwp/3Vs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ufpZHAytztl5xc5V9gKBzFRGZIqcwZkw2u2AorranwbOrfcqHFEFlZDpoh7jWvkkidBYbm/BuGVfr9MqJkkD/0VA/hxRUjeQXcG7lhvzzpFxCUI51RNw2inwEuVmHGDK/X4babga6WefvYJm8wPrVUj9RF6bNvkjeYOlRaZfM5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UC/aiuSV; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757455211; x=1788991211;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=vDl7m9tMdR9eYVxyDAaaau41yOwKsEhqf87Oqwp/3Vs=;
  b=UC/aiuSVHOC96A0IX40CJZnKFfdmyTT0tzwUEfn4FLdbbf/lPTsje4ul
   WxfP1QzqkNEHDlX7Iv2R4hZB6we/g8H+Ekoe38b+OQgeMRe+dD4B6qRZq
   9KK15/GDHDqHFynh8CCzfwP515dPgzt/R3ky2sAdemlIeaEuRWkFq/H3z
   Yfr5A6QcnSVToYm00Ziz+pLSeSaK1VsiU3ZrJR3xzhTN/V4+mHxOT7mwf
   VoKoBx9fZPnpjLKMwGYsG3cJAw58bcxVdQHCDbA9b7Zb4YuMiJUqPgyOP
   2u5dx1toHer50ZnHquHIgc7xj8XQvGUkCGjiC2Tne+JgJHV4z0+BxR/Ly
   Q==;
X-CSE-ConnectionGUID: H94IZVThRAGvq7zJCUf/Vg==
X-CSE-MsgGUID: 3Eif7NrWRmGtIP3cXzFWIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="63584631"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="63584631"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:08 -0700
X-CSE-ConnectionGUID: +taba2B9RWiukFxANaZjEQ==
X-CSE-MsgGUID: VmtnZj3ASWK3UeOUV+/xvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172780957"
Received: from orcnseosdtjek.jf.intel.com (HELO [10.166.28.70]) ([10.166.28.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:07 -0700
From: Jacob Keller <jacob.e.keller@intel.com>
Date: Tue, 09 Sep 2025 14:57:51 -0700
Subject: [PATCH RFC net-next 2/7] ice: implement device suspension for live
 migration
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-e810-live-migration-jk-migration-tlv-v1-2-4d1dc641e31f@intel.com>
References: <20250909-e810-live-migration-jk-migration-tlv-v1-0-4d1dc641e31f@intel.com>
In-Reply-To: <20250909-e810-live-migration-jk-migration-tlv-v1-0-4d1dc641e31f@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Alex Williamson <alex.williamson@redhat.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
 Kevin Tian <kevin.tian@intel.com>, Jakub Kicinski <kuba@kernel.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org, 
 Jacob Keller <jacob.e.keller@intel.com>, 
 Aleksandr Loktionov <aleksandr.loktionov@intel.com>
X-Mailer: b4 0.15-dev-c61db
X-Developer-Signature: v=1; a=openpgp-sha256; l=3863;
 i=jacob.e.keller@intel.com; h=from:subject:message-id;
 bh=vDl7m9tMdR9eYVxyDAaaau41yOwKsEhqf87Oqwp/3Vs=;
 b=owGbwMvMwCWWNS3WLp9f4wXjabUkhowDi1PPuljKLIvjF4va1mLJW/rK/Ll1r2y/8i3+rlU+t
 6q+Wgh0lLIwiHExyIopsig4hKy8bjwhTOuNsxzMHFYmkCEMXJwCMBHzLEaGR9caul6Y+j7a68SX
 sd3N8dKZv7KztzLqKC/7J+K1+jYXJyPDv4yuiV77lzzT16h2O83WpyQc+LlkuWfsi5vFZYFMC9f
 wAQA=
X-Developer-Key: i=jacob.e.keller@intel.com; a=openpgp;
 fpr=204054A9D73390562AEC431E6A965D3E6F0F28E8

The ice_migration_suspend_dev() function will be called by the ice_vfio_pci
module to suspend the VF device in preparation for migration. It will be
called both by the initial host device before transitioning to the
STOP_COPY state, as well as by the receiving device prior to loading the
migration data.

In preparation for STOP_COPY, the device must save some state to fill out a
migration buffer payload. In this flow, the save_state parameter is set to
true. During the resume flow, the function will not need to save device
state, and will set the save_state parameter to false.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/virt/migration.c | 96 ++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/virt/migration.c b/drivers/net/ethernet/intel/ice/virt/migration.c
index f13b7674dabd..aa2e17c5be60 100644
--- a/drivers/net/ethernet/intel/ice/virt/migration.c
+++ b/drivers/net/ethernet/intel/ice/virt/migration.c
@@ -85,9 +85,103 @@ void ice_migration_uninit_dev(struct pci_dev *vf_dev)
 }
 EXPORT_SYMBOL(ice_migration_uninit_dev);
 
+/**
+ * ice_migration_suspend_dev - suspend device
+ * @vf_dev: pointer to the VF PCI device
+ * @save_state: true if the device may be preparing for live migration
+ *
+ * Suspend the VF device. If save_state is set, first save any state which is
+ * necessary for later migration.
+ *
+ * Return: 0 for success, negative for error
+ */
 int ice_migration_suspend_dev(struct pci_dev *vf_dev, bool save_state)
 {
-	return -EOPNOTSUPP;
+	struct ice_pf *pf = ice_vf_dev_to_pf(vf_dev);
+	struct ice_mig_tlv_entry *entry, *tmp;
+	struct ice_vsi *vsi;
+	struct device *dev;
+	struct ice_vf *vf;
+	int err;
+
+	if (IS_ERR(pf))
+		return PTR_ERR(pf);
+
+	vf = ice_get_vf_by_dev(pf, vf_dev);
+	if (!vf) {
+		dev_err(&vf_dev->dev, "Unable to locate VF from VF device\n");
+		return -EINVAL;
+	}
+
+	dev = ice_pf_to_dev(pf);
+
+	dev_dbg(dev, "Suspending VF %u in preparation for live migration\n",
+		vf->vf_id);
+
+	mutex_lock(&vf->cfg_lock);
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		err = -EINVAL;
+		goto err_release_cfg_lock;
+	}
+
+	if (save_state) {
+		if (!list_empty(&vf->mig_tlvs)) {
+			dev_dbg(dev, "Freeing unused migration TLVs for VF %d\n",
+				vf->vf_id);
+
+			list_for_each_entry_safe(entry, tmp, &vf->mig_tlvs,
+						 list_entry) {
+				list_del(&entry->list_entry);
+				kfree(entry);
+			}
+		}
+	}
+
+	/* Prevent VSI from queuing incoming packets by removing all filters */
+	ice_fltr_remove_all(vsi);
+	/* TODO: there's probably a better way to handle this, or it may be
+	 * unnecessary
+	 */
+	vf->num_mac = 0;
+	vsi->num_vlan = 0;
+
+	/* MAC based filter rule is disabled at this point. Set MAC to zero
+	 * to keep consistency with VF mac address info shown by ip link
+	 */
+	eth_zero_addr(vf->hw_lan_addr);
+	eth_zero_addr(vf->dev_lan_addr);
+
+	err = ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, vf->vf_id);
+	if (err)
+		dev_warn(dev, "VF %d failed to stop Tx rings. Continuing live migration regardless.\n",
+			 vf->vf_id);
+
+	err = ice_vsi_stop_all_rx_rings(vsi);
+	if (err)
+		dev_warn(dev, "VF %d failed to stop Rx rings. Continuing live migration regardless.\n",
+			 vf->vf_id);
+
+	mutex_unlock(&vf->cfg_lock);
+	ice_put_vf(vf);
+
+	return 0;
+
+err_free_mig_tlvs:
+	if (save_state) {
+		list_for_each_entry_safe(entry, tmp, &vf->mig_tlvs,
+					 list_entry) {
+			list_del(&entry->list_entry);
+			kfree(entry);
+		}
+	}
+
+err_release_cfg_lock:
+	mutex_unlock(&vf->cfg_lock);
+	ice_put_vf(vf);
+	return err;
 }
 EXPORT_SYMBOL(ice_migration_suspend_dev);
 

-- 
2.51.0.rc1.197.g6d975e95c9d7


