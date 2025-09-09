Return-Path: <kvm+bounces-57154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B37B508A3
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 00:02:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F34D95E531A
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D624F2797B5;
	Tue,  9 Sep 2025 22:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QH0BnNyy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148A226A0A7;
	Tue,  9 Sep 2025 22:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757455215; cv=none; b=A6QoGfMdtTYvqtqojOMijcSNw+WY9TyNkWxkcjTC3rRiIbNBfIxUXM1x1dNz4hr+oJoHAOkdsWTu6cQU1D6O/VxDu5OUVI7BafIKEFtXVEUeLGy9rMWG8mx+0q+bievXJIPAr3gLRUevyjk/0zVQAYAuurhDPmMTjMMU9mi2BZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757455215; c=relaxed/simple;
	bh=Zbi2e2VvKzf88ESYqAWc3a4461r6YnvPI+Q6t4jVxPE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QLqFU9VfiStdtEe4RPl9J4s0ne0x2WBJBWuNiiF13kzBQdmZ1Ml6sI0AmqDINLhlx/+ZgRq3rvW9PNdcnofYIBNlOcNlvj24YY6wP/n+1ymDQLbhhdAwfCCYpwRa4aEiAaP8s8/02IZEAsto2j9TwX8Jt/kWuOC9Jl2xk1ePV2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QH0BnNyy; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757455213; x=1788991213;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=Zbi2e2VvKzf88ESYqAWc3a4461r6YnvPI+Q6t4jVxPE=;
  b=QH0BnNyyYZvshQlkp3uQGLebk6KSMUkvlcVmexwWeMje5NvKLBoP+GRD
   r+gcqsxstiQJwIZA43zAjoaciIAyXFjaC3ZPLcO02UpmeFpJnZ+Tli0WY
   P1EefJK/457DeZX49jwfvqdJ1YkH7e2qDTW08efuiz9W7zCZQz9qdkduV
   zqKEhKhzPc/8utAaRX8zhqLQHHtipQCL97p0FOi2J5kH/jqi2OfGtzVnh
   1BaOUPw4XOw7lB555Nz043CKa4F9H0xcuS/VvOVxjv4wU+ILJG9287+4J
   QCr5YXeOducJr6yWbuk4+Mgoe/CJNGLXTjdFhKEDH1W+pSGlUl9CMzf+Z
   A==;
X-CSE-ConnectionGUID: NCaQgkyeSKO3pn9+Y27ydQ==
X-CSE-MsgGUID: 8FJkW35cQYOYMaC7a7JjNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="63584668"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="63584668"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:09 -0700
X-CSE-ConnectionGUID: l72Vu2WKSk6+qgZjp+zxcg==
X-CSE-MsgGUID: YAUTIRX/QWal3k5073zBYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172780968"
Received: from orcnseosdtjek.jf.intel.com (HELO [10.166.28.70]) ([10.166.28.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:08 -0700
From: Jacob Keller <jacob.e.keller@intel.com>
Date: Tue, 09 Sep 2025 14:57:54 -0700
Subject: [PATCH RFC net-next 5/7] ice: add remaining migration TLVs
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-e810-live-migration-jk-migration-tlv-v1-5-4d1dc641e31f@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=28999;
 i=jacob.e.keller@intel.com; h=from:subject:message-id;
 bh=Zbi2e2VvKzf88ESYqAWc3a4461r6YnvPI+Q6t4jVxPE=;
 b=owGbwMvMwCWWNS3WLp9f4wXjabUkhowDi1NP1jE/KOa6sScwfcpN0diXdbO1p8gpfu5dsf6Gt
 2nJVNn0jlIWBjEuBlkxRRYFh5CV140nhGm9cZaDmcPKBDKEgYtTACYS/Y3hr7zcrz+OWjpKvU1R
 LML381/K82Vszb2i3rDaaM4a47OOGxn+KZf1pETGGBoGH/BfsPhTZgrDJDUrDysRBh717ognPsu
 4AQ==
X-Developer-Key: i=jacob.e.keller@intel.com; a=openpgp;
 fpr=204054A9D73390562AEC431E6A965D3E6F0F28E8

Add a handful of remaining TLVs to complete the migration payload data
including:

 * ICE_MIG_TLV_MBX_REGS

   This TLV contains the VF mailbox registers data to migrate and restore
   the mailbox queue to its appropriate state.

 * ICE_MIG_TLV_STATS

   This TLV contains the VF statistics to ensure that the original and
   target VM maintain the same stat counts.

 * ICE_MIG_TLV_RSS

   This TLV contains the RSS information from the original host, ensuring
   that such configuration is applied on the new host.

 * ICE_MIG_TLV_VLAN_FILTERS

   This TLV contains all the VLAN filters currently programmed into
   hardware by the VF. It is sent as a single variable length flexible
   array instead of as individual TLVs per VLAN to avoid a 4-byte overhead
   per-VLAN.

 * ICE_MIG_TLV_MAC_FILTERS

   This TLV contains all of the MAC filters currently programmed into the
   hardware by the VF. As with VLANs, it is sent as a flexible array to
   avoid too much overhead when there are many filters.

Add functions to save and restore this data appropriately during the live
migration process.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |   8 +
 .../net/ethernet/intel/ice/virt/migration_tlv.h    | 133 +++++
 drivers/net/ethernet/intel/ice/virt/migration.c    | 616 +++++++++++++++++++++
 3 files changed, 757 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index dd520aa4d1d6..954d671aee64 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -39,8 +39,16 @@
 #define PF_FW_ATQLEN_ATQVFE_M			BIT(28)
 #define PF_FW_ATQLEN_ATQOVFL_M			BIT(29)
 #define PF_FW_ATQLEN_ATQCRIT_M			BIT(30)
+#define VF_MBX_ARQBAH(_VF)			(0x0022B800 + ((_VF) * 4))
+#define VF_MBX_ARQBAL(_VF)			(0x0022B400 + ((_VF) * 4))
+#define VF_MBX_ARQH(_VF)			(0x0022C000 + ((_VF) * 4))
 #define VF_MBX_ARQLEN(_VF)			(0x0022BC00 + ((_VF) * 4))
+#define VF_MBX_ARQT(_VF)			(0x0022C400 + ((_VF) * 4))
+#define VF_MBX_ATQBAH(_VF)			(0x0022A400 + ((_VF) * 4))
+#define VF_MBX_ATQBAL(_VF)			(0x0022A000 + ((_VF) * 4))
+#define VF_MBX_ATQH(_VF)			(0x0022AC00 + ((_VF) * 4))
 #define VF_MBX_ATQLEN(_VF)			(0x0022A800 + ((_VF) * 4))
+#define VF_MBX_ATQT(_VF)			(0x0022B000 + ((_VF) * 4))
 #define PF_FW_ATQLEN_ATQENABLE_M		BIT(31)
 #define PF_FW_ATQT				0x00080400
 #define PF_MBX_ARQBAH				0x0022E400
diff --git a/drivers/net/ethernet/intel/ice/virt/migration_tlv.h b/drivers/net/ethernet/intel/ice/virt/migration_tlv.h
index 3e10e53868b2..183555cda9b3 100644
--- a/drivers/net/ethernet/intel/ice/virt/migration_tlv.h
+++ b/drivers/net/ethernet/intel/ice/virt/migration_tlv.h
@@ -82,6 +82,16 @@ struct ice_migration_tlv {
  * @ICE_MIG_TLV_MSIX_REGS: MSI-X register data for the VF. Appears once per
  * MSI-X interrupt, including the miscellaneous interrupt for the mailbox.
  *
+ * @ICE_MIG_TLV_MBX_REGS: Mailbox register data for the VF.
+ *
+ * @ICE_MIG_TLV_STATS: Current statistics counts of the VF.
+ *
+ * @ICE_MIG_TLV_RSS: RSS configuration for the VF.
+ *
+ * @ICE_MIG_TLV_VLAN_FILTERS: VLAN filter information.
+ *
+ * @ICE_MIG_TLV_MAC_FILTERS: MAC filter information.
+ *
  * @NUM_ICE_MIG_TLV: Number of known TLV types. Any type equal to or larger
  * than this value is unrecognized by this version.
  *
@@ -97,6 +107,11 @@ enum ice_migration_tlvs {
 	ICE_MIG_TLV_TX_QUEUE,
 	ICE_MIG_TLV_RX_QUEUE,
 	ICE_MIG_TLV_MSIX_REGS,
+	ICE_MIG_TLV_MBX_REGS,
+	ICE_MIG_TLV_STATS,
+	ICE_MIG_TLV_RSS,
+	ICE_MIG_TLV_VLAN_FILTERS,
+	ICE_MIG_TLV_MAC_FILTERS,
 
 	/* Add new types above here */
 	NUM_ICE_MIG_TLV
@@ -258,6 +273,119 @@ struct ice_mig_msix_regs {
 	u16 vector_id;
 } __packed;
 
+/**
+ * struct ice_mig_stats - Hardware statistics counts from migrating VF
+ * @rx_bytes: total nr received bytes (gorc)
+ * @rx_unicast: total nr received unicast packets (uprc)
+ * @rx_multicast: total nr received multicast packets (mprc)
+ * @rx_broadcast: total nr received broadcast packets (bprc)
+ * @rx_discards: total nr packets discarded on receipt (rdpc)
+ * @rx_unknown_protocol: total nr Rx packets with unrecognized protocol (rupp)
+ * @tx_bytes: total nr transmitted bytes (gotc)
+ * @tx_unicast: total nr transmitted unicast packets (uptc)
+ * @tx_multicast: total nr transmitted multicast packets (mptc)
+ * @tx_broadcast: total nr transmitted broadcast packets (bptc)
+ * @tx_discards: total nr packets discarded on transmit (tdpc)
+ * @tx_errors: total number of transmit errors (tepc)
+ */
+struct ice_mig_stats {
+	u64 rx_bytes;
+	u64 rx_unicast;
+	u64 rx_multicast;
+	u64 rx_broadcast;
+	u64 rx_discards;
+	u64 rx_unknown_protocol;
+	u64 tx_bytes;
+	u64 tx_unicast;
+	u64 tx_multicast;
+	u64 tx_broadcast;
+	u64 tx_discards;
+	u64 tx_errors;
+} __packed;
+
+/**
+ * struct ice_mig_mbx_regs - PF<->VF Mailbox register data for the VF
+ * @atq_head: the head position of the VF AdminQ Tx ring
+ * @atq_tail: the tail position of the VF AdminQ Tx ring
+ * @atq_bal: lower 32-bits of the VF AdminQ Tx ring base address
+ * @atq_bah: upper 32-bits of the VF AdminQ Tx ring base address
+ * @atq_len: length of the VF AdminQ Tx ring
+ * @arq_head: the head position of the VF AdminQ Rx ring
+ * @arq_tail: the tail position of the VF AdminQ Tx ring
+ * @arq_bal: lower 32-bits of the VF AdminQ Rx ring base address
+ * @arq_bah: upper 32-bits of the VF AdminQ Rx ring base address
+ * @arq_len: length of the VF AdminQ Rx ring
+ */
+struct ice_mig_mbx_regs {
+	u32 atq_head;
+	u32 atq_tail;
+	u32 atq_bal;
+	u32 atq_bah;
+	u32 atq_len;
+	u32 arq_head;
+	u32 arq_tail;
+	u32 arq_bal;
+	u32 arq_bah;
+	u32 arq_len;
+} __packed;
+
+/**
+ * struct ice_mig_rss - RSS configuration for the migrating VF
+ * @hashcfg: RSS Hash filter configuration
+ * @key: RSS key
+ * @lut_size: size of the RSS lookup table
+ * @hfunc: RSS hash function selected
+ * @lut: RSS lookup table configuration
+ */
+struct ice_mig_rss {
+	u64 hashcfg;
+	/* TODO: Can this key change size? Should this be a plain buffer
+	 * instead of the struct?
+	 */
+	struct ice_aqc_get_set_rss_keys key;
+	u16 lut_size;
+	u8 hfunc;
+	u8 lut[] __counted_by(lut_size);
+} __packed;
+
+/**
+ * struct ice_mig_vlan_filter - VLAN filter information
+ * @tpid: VLAN TPID
+ * @vid: VLAN ID
+ */
+struct ice_mig_vlan_filter {
+	u16 tpid;
+	u16 vid;
+} __packed;
+
+/**
+ * struct ice_mig_vlan_filters - List of VLAN filters for the VF
+ * @num_vlans: number of VLANs for this VF
+ * @vlans: VLAN data
+ */
+struct ice_mig_vlan_filters {
+	u16 num_vlans;
+	struct ice_mig_vlan_filter vlans[] __counted_by(num_vlans);
+} __packed;
+
+/**
+ * struct ice_mig_mac_filter - MAC address data for a VF filter
+ * @mac_addr: the MAC address
+ */
+struct ice_mig_mac_filter {
+	u8 mac_addr[ETH_ALEN];
+} __packed;
+
+/**
+ * struct ice_mig_mac_filters - List of MAC filters for the VF
+ * @num_macs: number of MAC filters for this VF
+ * @macs: MAC address data
+ */
+struct ice_mig_mac_filters {
+	u16 num_macs;
+	struct ice_mig_mac_filter macs[] __counted_by(num_macs);
+} __packed;
+
 /**
  * ice_mig_tlv_type - Convert a TLV type to its number
  * @p: the TLV structure type
@@ -273,6 +401,11 @@ struct ice_mig_msix_regs {
 		 struct ice_mig_tx_queue : ICE_MIG_TLV_TX_QUEUE,	\
 		 struct ice_mig_rx_queue : ICE_MIG_TLV_RX_QUEUE,	\
 		 struct ice_mig_msix_regs : ICE_MIG_TLV_MSIX_REGS,	\
+		 struct ice_mig_mbx_regs : ICE_MIG_TLV_MBX_REGS,	\
+		 struct ice_mig_stats : ICE_MIG_TLV_STATS,		\
+		 struct ice_mig_rss : ICE_MIG_TLV_RSS,			\
+		 struct ice_mig_vlan_filters : ICE_MIG_TLV_VLAN_FILTERS,\
+		 struct ice_mig_mac_filters : ICE_MIG_TLV_MAC_FILTERS,	\
 		 default : ICE_MIG_TLV_END)
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/virt/migration.c b/drivers/net/ethernet/intel/ice/virt/migration.c
index e59eb99b20da..a9f6d3019c0c 100644
--- a/drivers/net/ethernet/intel/ice/virt/migration.c
+++ b/drivers/net/ethernet/intel/ice/virt/migration.c
@@ -401,6 +401,320 @@ static int ice_migration_save_msix_regs(struct ice_vf *vf,
 	return err;
 }
 
+/**
+ * ice_migration_save_mbx_regs - Save Mailbox registers
+ * @vf: pointer to the VF being migrated
+ *
+ * Save the mailbox registers for communicating with VF in preparation for
+ * live migration.
+ *
+ * Return: 0 for success, negative for error
+ */
+static int ice_migration_save_mbx_regs(struct ice_vf *vf)
+{
+	struct ice_mig_mbx_regs *mbx_regs;
+	struct ice_hw *hw = &vf->pf->hw;
+
+	lockdep_assert_held(&vf->cfg_lock);
+
+	mbx_regs = ice_mig_alloc_tlv(mbx_regs);
+	if (!mbx_regs)
+		return -ENOMEM;
+
+	mbx_regs->atq_head = rd32(hw, VF_MBX_ATQH(vf->vf_id));
+	mbx_regs->atq_tail = rd32(hw, VF_MBX_ATQT(vf->vf_id));
+	mbx_regs->atq_bal = rd32(hw, VF_MBX_ATQBAL(vf->vf_id));
+	mbx_regs->atq_bah = rd32(hw, VF_MBX_ATQBAH(vf->vf_id));
+	mbx_regs->atq_len = rd32(hw, VF_MBX_ATQLEN(vf->vf_id));
+
+	mbx_regs->arq_head = rd32(hw, VF_MBX_ARQH(vf->vf_id));
+	mbx_regs->arq_tail = rd32(hw, VF_MBX_ARQT(vf->vf_id));
+	mbx_regs->arq_bal = rd32(hw, VF_MBX_ARQBAL(vf->vf_id));
+	mbx_regs->arq_bah = rd32(hw, VF_MBX_ARQBAH(vf->vf_id));
+	mbx_regs->arq_len = rd32(hw,  VF_MBX_ARQLEN(vf->vf_id));
+
+	ice_mig_tlv_add_tail(mbx_regs, &vf->mig_tlvs);
+
+	return 0;
+}
+
+/**
+ * ice_migration_save_stats - Save VF statistics counters
+ * @vf: pointer to the VF being migrated
+ * @vsi: the VSI for this VF
+ *
+ * Update and save the current statistics values for the VF.
+ *
+ * Return: 0 for success, negative for error
+ */
+static int ice_migration_save_stats(struct ice_vf *vf, struct ice_vsi *vsi)
+{
+	struct ice_mig_stats *stats;
+
+	lockdep_assert_held(&vf->cfg_lock);
+
+	stats = ice_mig_alloc_tlv(stats);
+	if (!stats)
+		return -ENOMEM;
+
+	ice_update_eth_stats(vsi);
+
+	stats->rx_bytes = vsi->eth_stats.rx_bytes;
+	stats->rx_unicast = vsi->eth_stats.rx_unicast;
+	stats->rx_multicast = vsi->eth_stats.rx_multicast;
+	stats->rx_broadcast = vsi->eth_stats.rx_broadcast;
+	stats->rx_discards = vsi->eth_stats.rx_discards;
+	stats->rx_unknown_protocol = vsi->eth_stats.rx_unknown_protocol;
+	stats->tx_bytes = vsi->eth_stats.tx_bytes;
+	stats->tx_unicast = vsi->eth_stats.tx_unicast;
+	stats->tx_multicast = vsi->eth_stats.tx_multicast;
+	stats->tx_broadcast = vsi->eth_stats.tx_broadcast;
+	stats->tx_discards = vsi->eth_stats.tx_discards;
+	stats->tx_errors = vsi->eth_stats.tx_errors;
+
+	ice_mig_tlv_add_tail(stats, &vf->mig_tlvs);
+
+	return 0;
+}
+
+/**
+ * ice_migration_save_rss - Save RSS configuration during suspend
+ * @vf: pointer to the VF being migrated
+ * @vsi: the VSI for this VF
+ *
+ * Save the RSS configuration for this VF, including the hash function, hash
+ * set configuration, lookup table, and RSS key.
+ *
+ * Return: 0 on success, or an error code on failure.
+ */
+static int ice_migration_save_rss(struct ice_vf *vf, struct ice_vsi *vsi)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_hw *hw = &vf->pf->hw;
+	struct ice_mig_rss *rss;
+
+	lockdep_assert_held(&vf->cfg_lock);
+
+	/* Skip RSS if its not supported by this PF */
+	if (!test_bit(ICE_FLAG_RSS_ENA, vf->pf->flags)) {
+		dev_dbg(dev, "RSS is not supported by the PF\n");
+		return 0;
+	}
+
+	dev_dbg(dev, "Saving RSS config for VF %u\n",
+		vf->vf_id);
+
+	/* When ice PF supports variable RSS LUT sizes, this will need to be
+	 * updated. For now, the PF enforces a strict table size of
+	 * ICE_LUT_VSI_SIZE.
+	 */
+	rss = ice_mig_alloc_flex_tlv(rss, lut, ICE_LUT_VSI_SIZE);
+	if (!rss)
+		return -ENOMEM;
+
+	rss->hashcfg = vf->rss_hashcfg;
+	rss->hfunc = vsi->rss_hfunc;
+	rss->lut_size = ICE_LUT_VSI_SIZE;
+	ice_aq_get_rss_key(hw, vsi->idx, &rss->key);
+	ice_get_rss_lut(vsi, rss->lut, ICE_LUT_VSI_SIZE);
+
+	ice_mig_tlv_add_tail(rss, &vf->mig_tlvs);
+
+	return 0;
+}
+
+/**
+ * ice_migration_save_vlan_filters - Save all VLAN filters used by VF
+ * @vf: pointer to the VF being migrated
+ * @vsi: the VSI for this VF
+ *
+ * Save the VLAN filters configured for the VF when suspending it for live
+ * migration.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int ice_migration_save_vlan_filters(struct ice_vf *vf,
+					   struct ice_vsi *vsi)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_fltr_mgmt_list_entry *fm_entry;
+	struct ice_mig_vlan_filters *vlan_filters;
+	struct ice_hw *hw = &vf->pf->hw;
+	struct list_head *rule_head;
+	struct ice_switch_info *sw;
+	int vlan_idx;
+
+	lockdep_assert_held(&vf->cfg_lock);
+
+	if (!vsi->num_vlan)
+		return 0;
+
+	dev_dbg(dev, "Saving %u VLANs for VF %d\n",
+		vsi->num_vlan, vf->vf_id);
+
+	/* Ensure variable size TLV is aligned to 4 bytes */
+	vlan_filters = ice_mig_alloc_flex_tlv(vlan_filters, vlans,
+					      vsi->num_vlan);
+	if (!vlan_filters)
+		return -ENOMEM;
+
+	vlan_filters->num_vlans = vsi->num_vlan;
+
+	sw = hw->switch_info;
+	rule_head = &sw->recp_list[ICE_SW_LKUP_VLAN].filt_rules;
+
+	mutex_lock(&sw->recp_list[ICE_SW_LKUP_VLAN].filt_rule_lock);
+
+	list_for_each_entry(fm_entry, rule_head, list_entry) {
+		struct ice_mig_vlan_filter *vlan;
+
+		/* ignore anything that isn't a VLAN VSI filter */
+		if (fm_entry->fltr_info.lkup_type != ICE_SW_LKUP_VLAN ||
+		    (fm_entry->fltr_info.fltr_act != ICE_FWD_TO_VSI &&
+		     fm_entry->fltr_info.fltr_act != ICE_FWD_TO_VSI_LIST))
+			continue;
+
+		if (fm_entry->vsi_count < 2 && !fm_entry->vsi_list_info &&
+		    fm_entry->fltr_info.fltr_act == ICE_FWD_TO_VSI) {
+			/* Check if ICE_FWD_TO_VSI matches this VSI */
+			if (fm_entry->fltr_info.vsi_handle != vsi->idx)
+				continue;
+		} else if (fm_entry->vsi_list_info &&
+			   fm_entry->fltr_info.fltr_act == ICE_FWD_TO_VSI_LIST) {
+			/* Check if ICE_FWD_TO_VSI_LIST matches this VSI */
+			if (!test_bit(vsi->idx,
+				      fm_entry->vsi_list_info->vsi_map))
+				continue;
+		} else {
+			dev_dbg(dev, "Ignoring malformed filter entry that doesn't look like either a VSI or VSI list filter.\n");
+			continue;
+		}
+
+		/* We shouldn't hit this, assuming num_vlan is consistent with
+		 * the actual number of entries in the table.
+		 */
+		if (vlan_idx >= vsi->num_vlan) {
+			dev_warn(dev, "VF VSI claims to have %d VLAN filters but we found more than that in the switch table. Some filters might be lost in migration\n",
+				 vsi->num_vlan);
+			break;
+		}
+
+		vlan = &vlan_filters->vlans[vlan_idx];
+		vlan->vid = fm_entry->fltr_info.l_data.vlan.vlan_id;
+		if (fm_entry->fltr_info.l_data.vlan.tpid_valid)
+			vlan->tpid = fm_entry->fltr_info.l_data.vlan.tpid;
+		else
+			vlan->tpid = ETH_P_8021Q;
+
+		vlan_idx++;
+	}
+
+	if (vlan_idx != vsi->num_vlan) {
+		dev_warn(dev, "VSI had %u VLANs, but we only found %u VLANs\n",
+			 vsi->num_vlan, vlan_idx);
+		vlan_filters->num_vlans = vlan_idx;
+	}
+
+	ice_mig_tlv_add_tail(vlan_filters, &vf->mig_tlvs);
+
+	mutex_unlock(&sw->recp_list[ICE_SW_LKUP_VLAN].filt_rule_lock);
+
+	return 0;
+}
+
+/**
+ * ice_migration_save_mac_filters - Save MAC filters used by VF
+ * @vf: pointer to the VF being migrated
+ * @vsi: the VSI for this VF
+ *
+ * Save the MAC filters configured for the VF when suspending it for live
+ * migration.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int ice_migration_save_mac_filters(struct ice_vf *vf,
+					  struct ice_vsi *vsi)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_fltr_mgmt_list_entry *fm_entry;
+	struct ice_mig_mac_filters *mac_filters;
+	struct ice_hw *hw = &vf->pf->hw;
+	struct list_head *rule_head;
+	struct ice_switch_info *sw;
+	int mac_idx;
+
+	lockdep_assert_held(&vf->cfg_lock);
+
+	if (!vf->num_mac)
+		return 0;
+
+	dev_dbg(dev, "Saving %u MAC filters for VF %u\n",
+		vf->num_mac, vf->vf_id);
+
+	/* Ensure variable size TLV is aligned to 4 bytes */
+	mac_filters = ice_mig_alloc_flex_tlv(mac_filters, macs,
+					     vf->num_mac);
+	if (!mac_filters)
+		return -ENOMEM;
+
+	mac_filters->num_macs = vf->num_mac;
+
+	sw = hw->switch_info;
+	rule_head = &sw->recp_list[ICE_SW_LKUP_MAC].filt_rules;
+
+	mutex_lock(&sw->recp_list[ICE_SW_LKUP_MAC].filt_rule_lock);
+
+	mac_idx = 0;
+	list_for_each_entry(fm_entry, rule_head, list_entry) {
+		/* ignore anything that isn't a MAC VSI filter */
+		if (fm_entry->fltr_info.lkup_type != ICE_SW_LKUP_MAC ||
+		    (fm_entry->fltr_info.fltr_act != ICE_FWD_TO_VSI &&
+		     fm_entry->fltr_info.fltr_act != ICE_FWD_TO_VSI_LIST))
+			continue;
+
+		if (fm_entry->vsi_count < 2 && !fm_entry->vsi_list_info &&
+		    fm_entry->fltr_info.fltr_act == ICE_FWD_TO_VSI) {
+			/* Check if ICE_FWD_TO_VSI matches this VSI */
+			if (fm_entry->fltr_info.vsi_handle != vsi->idx)
+				continue;
+		} else if (fm_entry->vsi_list_info &&
+			   fm_entry->fltr_info.fltr_act == ICE_FWD_TO_VSI_LIST) {
+			/* Check if ICE_FWD_TO_VSI_LIST matches this VSI */
+			if (!test_bit(vsi->idx,
+				      fm_entry->vsi_list_info->vsi_map))
+				continue;
+		} else {
+			dev_dbg(dev, "Ignoring malformed filter entry that doesn't look like either a VSI or VSI list filter.\n");
+			continue;
+		}
+
+		/* We shouldn't hit this, assuming num_mac is consistent with
+		 * the actual number of entries in the table.
+		 */
+		if (mac_idx >= vf->num_mac) {
+			dev_warn(dev, "VF claims to have %d MAC filters but we found more than that in the switch table. Some filters might be lost in migration\n",
+				 vf->num_mac);
+			break;
+		}
+
+		ether_addr_copy(mac_filters->macs[mac_idx].mac_addr,
+				fm_entry->fltr_info.l_data.mac.mac_addr);
+		mac_idx++;
+	}
+
+	if (mac_idx != vf->num_mac) {
+		dev_warn(dev, "VF VSI had %u MAC filters, but we only found %u MAC filters\n",
+			 vf->num_mac, mac_idx);
+		mac_filters->num_macs = mac_idx;
+	}
+
+	ice_mig_tlv_add_tail(mac_filters, &vf->mig_tlvs);
+
+	mutex_unlock(&sw->recp_list[ICE_SW_LKUP_MAC].filt_rule_lock);
+
+	return 0;
+}
+
 /**
  * ice_migration_suspend_dev - suspend device
  * @vf_dev: pointer to the VF PCI device
@@ -463,6 +777,17 @@ int ice_migration_suspend_dev(struct pci_dev *vf_dev, bool save_state)
 		if (err)
 			goto err_free_mig_tlvs;
 
+		err = ice_migration_save_rss(vf, vsi);
+		if (err)
+			goto err_free_mig_tlvs;
+
+		err = ice_migration_save_vlan_filters(vf, vsi);
+		if (err)
+			goto err_free_mig_tlvs;
+
+		err = ice_migration_save_mac_filters(vf, vsi);
+		if (err)
+			goto err_free_mig_tlvs;
 	}
 
 	/* Prevent VSI from queuing incoming packets by removing all filters */
@@ -498,6 +823,16 @@ int ice_migration_suspend_dev(struct pci_dev *vf_dev, bool save_state)
 		err = ice_migration_save_tx_queues(vf, vsi);
 		if (err)
 			goto err_free_mig_tlvs;
+
+		/* Save mailbox registers */
+		err = ice_migration_save_mbx_regs(vf);
+		if (err)
+			goto err_free_mig_tlvs;
+
+		/* Save current VF statistics */
+		err = ice_migration_save_stats(vf, vsi);
+		if (err)
+			goto err_free_mig_tlvs;
 	}
 
 	mutex_unlock(&vf->cfg_lock);
@@ -1397,6 +1732,272 @@ ice_migration_load_msix_regs(struct ice_vf *vf, struct ice_vsi *vsi,
 	return 0;
 }
 
+/**
+ * ice_migration_load_mbx_regs - Load mailbox registers from migration payload
+ * @vf: pointer to the VF being migrated to
+ * @mbx_regs: the mailbox register data from migration payload
+ *
+ * Load the mailbox register configuration from the migration payload and
+ * initialize the target VF.
+ */
+static void ice_migration_load_mbx_regs(struct ice_vf *vf,
+					const struct ice_mig_mbx_regs *mbx_regs)
+{
+	struct ice_hw *hw = &vf->pf->hw;
+
+	lockdep_assert_held(&vf->cfg_lock);
+
+	wr32(hw, VF_MBX_ATQH(vf->vf_id), mbx_regs->atq_head);
+	wr32(hw, VF_MBX_ATQT(vf->vf_id), mbx_regs->atq_tail);
+	wr32(hw, VF_MBX_ATQBAL(vf->vf_id), mbx_regs->atq_bal);
+	wr32(hw, VF_MBX_ATQBAH(vf->vf_id), mbx_regs->atq_bah);
+	wr32(hw, VF_MBX_ATQLEN(vf->vf_id), mbx_regs->atq_len);
+
+	wr32(hw, VF_MBX_ARQH(vf->vf_id), mbx_regs->arq_head);
+	wr32(hw, VF_MBX_ARQT(vf->vf_id), mbx_regs->arq_tail);
+	wr32(hw, VF_MBX_ARQBAL(vf->vf_id), mbx_regs->arq_bal);
+	wr32(hw, VF_MBX_ARQBAH(vf->vf_id), mbx_regs->arq_bah);
+	wr32(hw, VF_MBX_ARQLEN(vf->vf_id), mbx_regs->arq_len);
+}
+
+/**
+ * ice_migration_load_stats - Load VF statistics from migration buffer
+ * @vf: pointer to the VF being migrated to
+ * @vsi: the VSI for this VF
+ * @stats: the statistics values from the migration buffer.
+ *
+ * Load the VF statistics from the migration buffer, and re-initialize HW
+ * stats offsets to match.
+ */
+static void ice_migration_load_stats(struct ice_vf *vf, struct ice_vsi *vsi,
+				     const struct ice_mig_stats *stats)
+{
+	lockdep_assert_held(&vf->cfg_lock);
+
+	vsi->eth_stats.rx_bytes = stats->rx_bytes;
+	vsi->eth_stats.rx_unicast = stats->rx_unicast;
+	vsi->eth_stats.rx_multicast = stats->rx_multicast;
+	vsi->eth_stats.rx_broadcast = stats->rx_broadcast;
+	vsi->eth_stats.rx_discards = stats->rx_discards;
+	vsi->eth_stats.rx_unknown_protocol = stats->rx_unknown_protocol;
+	vsi->eth_stats.tx_bytes = stats->tx_bytes;
+	vsi->eth_stats.tx_unicast = stats->tx_unicast;
+	vsi->eth_stats.tx_multicast = stats->tx_multicast;
+	vsi->eth_stats.tx_broadcast = stats->tx_broadcast;
+	vsi->eth_stats.tx_discards = stats->tx_discards;
+	vsi->eth_stats.tx_errors = stats->tx_errors;
+
+	/* Force the stats offsets to reload so that reported statistics
+	 * exactly match the values from the migration buffer.
+	 */
+	vsi->stat_offsets_loaded = false;
+	ice_update_eth_stats(vsi);
+}
+
+/**
+ * ice_migration_load_rss - Load VF RSS configuration from migration buffer
+ * @vf: pointer to the VF being migrated to
+ * @vsi: the VSI for this VF
+ * @rss: the RSS configuration from the migration buffer
+ *
+ * Load the VF RSS configuration from the migration buffer, and configure the
+ * target VF to match.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+static int ice_migration_load_rss(struct ice_vf *vf, struct ice_vsi *vsi,
+				  const struct ice_mig_rss *rss)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_hw *hw = &vf->pf->hw;
+	int err;
+
+	if (!test_bit(ICE_FLAG_RSS_ENA, vf->pf->flags)) {
+		dev_err(dev, "RSS is not supported by the PF\n");
+		return -EOPNOTSUPP;
+	}
+
+	dev_dbg(dev, "Loading RSS configuration for VF %u\n", vf->vf_id);
+
+	err = ice_set_rss_key(vsi, (u8 *)&rss->key);
+	if (err) {
+		dev_dbg(dev, "Failed to set RSS key for VF %d, err %d\n",
+			vf->vf_id, err);
+		return err;
+	}
+
+	err = ice_set_rss_lut(vsi, (u8 *)rss->lut, rss->lut_size);
+	if (err) {
+		dev_dbg(dev, "Failed to set RSS lookup table for VF %d, err %d\n",
+			vf->vf_id, err);
+		return err;
+	}
+
+	err = ice_set_rss_hfunc(vsi, rss->hfunc);
+	if (err) {
+		dev_dbg(dev, "Failed to set RSS hash function for VF %d, err %d\n",
+			vf->vf_id, err);
+		return err;
+	}
+
+	err = ice_rem_vsi_rss_cfg(hw, vsi->idx);
+	if (err && !rss->hashcfg) {
+		/* only report failure to clear the current RSS configuration
+		 * if that was clearly the migrated VF's intention.
+		 */
+		dev_dbg(dev, "Failed to clear RSS hash configuration for VF %d, err %d\n",
+			vf->vf_id, err);
+		return err;
+	}
+
+	if (!rss->hashcfg)
+		return 0;
+
+	err = ice_add_avf_rss_cfg(hw, vsi, rss->hashcfg);
+	if (err) {
+		dev_dbg(dev, "Failed to set RSS hash configuration for VF %d, err %d\n",
+			vf->vf_id, err);
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_migration_load_vlan_filters - Load VLAN filters from migration buffer
+ * @vf: pointer to the VF being migrated to
+ * @vsi: the VSI for this VF
+ * @vlan_filters: VLAN filters from the migration payload
+ *
+ * Load the VLAN filters from the migration payload and program the target VF
+ * to match.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+static int
+ice_migration_load_vlan_filters(struct ice_vf *vf, struct ice_vsi *vsi,
+				const struct ice_mig_vlan_filters *vlan_filters)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_vsi_vlan_ops *vlan_ops;
+	struct ice_hw *hw = &vf->pf->hw;
+	int err;
+
+	dev_dbg(dev, "Loading %u VLANs for VF %d\n",
+		vlan_filters->num_vlans, vf->vf_id);
+
+	for (int idx = 0; idx < vlan_filters->num_vlans; idx++) {
+		const struct ice_mig_vlan_filter *entry;
+		struct ice_vlan vlan;
+
+		entry = &vlan_filters->vlans[idx];
+		vlan = ICE_VLAN(entry->tpid, entry->vid, 0);
+
+		/* ice_vsi_add_vlan converts -EEXIST errors from
+		 * ice_fltr_add_vlan() into a successful return.
+		 */
+		err = ice_vsi_add_vlan(vsi, &vlan);
+		if (err) {
+			dev_dbg(dev, "Failed to add VLAN %d for VF %d, err %d\n",
+				entry->vid, vf->vf_id, err);
+			return err;
+		}
+
+		/* We're re-adding the hardware vlan filters. The VF can
+		 * either add outer VLANs (in DVM), or inner VLANs (in
+		 * SVM). In SVM, we only enable promiscuous if the port VLAN
+		 * is hot set.
+		 */
+		if (ice_is_vlan_promisc_allowed(vf) &&
+		    (ice_is_dvm_ena(hw) || !ice_vf_is_port_vlan_ena(vf))) {
+			err = ice_vf_ena_vlan_promisc(vf, vsi, &vlan);
+			if (err) {
+				dev_dbg(dev, "Failed to enable promiscuous filter on VLAN %d for VF %d, err %d\n",
+					entry->vid, vf->vf_id, err);
+				return err;
+			}
+		}
+	}
+
+	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
+
+	if (ice_vsi_has_non_zero_vlans(vsi)) {
+		err = vlan_ops->ena_rx_filtering(vsi);
+		if (err) {
+			dev_dbg(dev, "Failed to enable VLAN pruning, err %d\n",
+				err);
+			return err;
+		}
+
+		if (vf->spoofchk) {
+			err = vlan_ops->ena_tx_filtering(vsi);
+			if (err) {
+				dev_dbg(dev, "Failed to enable VLAN anti-spoofing, err %d\n",
+					err);
+				return err;
+			}
+		}
+	} else {
+		/* Disable VLAN filtering when only VLAN 0 is left */
+		vlan_ops->dis_tx_filtering(vsi);
+		vlan_ops->dis_rx_filtering(vsi);
+	}
+
+	if (vsi->num_vlan != vlan_filters->num_vlans)
+		dev_dbg(dev, "VF %d has %d VLAN filters, but we expected to have %d\n",
+			vf->vf_id, vsi->num_vlan, vlan_filters->num_vlans);
+
+	return 0;
+}
+
+/**
+ * ice_migration_load_mac_filters - Load MAC filters from migration buffer
+ * @vf: pointer to the VF being migrated to
+ * @vsi: the VSI for this VF
+ * @mac_filters: MAC address filters from the migration payload
+ *
+ * Load the MAC filters from the migration payload and program them into the
+ * target VF.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+static int
+ice_migration_load_mac_filters(struct ice_vf *vf, struct ice_vsi *vsi,
+			       const struct ice_mig_mac_filters *mac_filters)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+
+	dev_dbg(dev, "Loading %u MAC filters for VF %d\n",
+		mac_filters->num_macs, vf->vf_id);
+
+	for (int idx = 0; idx < mac_filters->num_macs; idx++) {
+		const struct ice_mig_mac_filter *entry;
+		int err;
+
+		entry = &mac_filters->macs[idx];
+
+		err = ice_fltr_add_mac(vsi, entry->mac_addr, ICE_FWD_TO_VSI);
+		if (!err) {
+			vf->num_mac++;
+		} else if (err == -EEXIST) {
+			/* Ignore duplicate filters, since initial filters may
+			 * already exist due to the resetting when loading the
+			 * VF information TLV.
+			 */
+		} else {
+			dev_dbg(dev, "Failed to add MAC %pM for VF %d, err %d\n",
+				entry->mac_addr, vf->vf_id, err);
+			return err;
+		}
+	}
+
+	if (vf->num_mac != mac_filters->num_macs)
+		dev_dbg(dev, "VF %d has %d MAC filters, but we expected to have %d\n",
+			vf->vf_id, vf->num_mac, mac_filters->num_macs);
+
+	return 0;
+}
+
 /**
  * ice_migration_load_devstate - Load device state into the target VF
  * @vf_dev: pointer to the VF PCI device
@@ -1493,6 +2094,21 @@ int ice_migration_load_devstate(struct pci_dev *vf_dev, const void *buf,
 		case ICE_MIG_TLV_MSIX_REGS:
 			err = ice_migration_load_msix_regs(vf, vsi, data);
 			break;
+		case ICE_MIG_TLV_MBX_REGS:
+			ice_migration_load_mbx_regs(vf, data);
+			break;
+		case ICE_MIG_TLV_STATS:
+			ice_migration_load_stats(vf, vsi, data);
+			break;
+		case ICE_MIG_TLV_RSS:
+			err = ice_migration_load_rss(vf, vsi, data);
+			break;
+		case ICE_MIG_TLV_VLAN_FILTERS:
+			err = ice_migration_load_vlan_filters(vf, vsi, data);
+			break;
+		case ICE_MIG_TLV_MAC_FILTERS:
+			err = ice_migration_load_mac_filters(vf, vsi, data);
+			break;
 		default:
 			dev_dbg(dev, "Unexpected TLV %d in payload?\n",
 				tlv->type);

-- 
2.51.0.rc1.197.g6d975e95c9d7


