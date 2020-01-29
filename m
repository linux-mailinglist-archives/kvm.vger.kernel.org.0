Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF5214CA8B
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgA2MNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:13:35 -0500
Received: from mga18.intel.com ([134.134.136.126]:21973 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbgA2MNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:13:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:13:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="222434776"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 29 Jan 2020 04:13:32 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC v1 2/2] vfio/pci: Emulate PASID/PRI capability for VFs
Date:   Wed, 29 Jan 2020 04:18:45 -0800
Message-Id: <1580300325-86259-3-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580300325-86259-1-git-send-email-yi.l.liu@intel.com>
References: <1580300325-86259-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

Per PCIe r5.0, sec 9.3.7.14, if a PF implements the PASID Capability, the
PF PASID configuration is shared by its VFs.  VFs must not implement their
own PASID Capability.

Per PCIe r5.0, sec 9.3.7.11, VFs must not implement the PRI Capability. If
the PF implements PRI, it is shared by the VFs.

On bare metal, it has been fixed by below efforts.
to PASID/PRI are
https://lkml.org/lkml/2019/9/5/996
https://lkml.org/lkml/2019/9/5/995

This patch adds emulated PASID/PRI capabilities for VFs when assigned to
VMs via vfio-pci driver. This is required for enabling vSVA on pass-through
VFs as VFs have no PASID/PRI capability structure in its configure space.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 319 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 317 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 4b9af99..fbd20c3 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1509,11 +1509,304 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
 	return 0;
 }
 
+static int vfio_fill_custom_vconfig_bytes(struct vfio_pci_device *vdev,
+					int offset, uint8_t *data, int size)
+{
+	int ret = 0, data_offset = 0;
+
+	while (size) {
+		int filled;
+
+		if (size >= 4 && !(offset % 4)) {
+			__le32 *dwordp = (__le32 *)&vdev->vconfig[offset];
+			u32 dword;
+
+			memcpy(&dword, data + data_offset, 4);
+			*dwordp = cpu_to_le32(dword);
+			filled = 4;
+		} else if (size >= 2 && !(offset % 2)) {
+			__le16 *wordp = (__le16 *)&vdev->vconfig[offset];
+			u16 word;
+
+			memcpy(&word, data + data_offset, 2);
+			*wordp = cpu_to_le16(word);
+			filled = 2;
+		} else {
+			u8 *byte = &vdev->vconfig[offset];
+
+			memcpy(byte, data + data_offset, 1);
+			filled = 1;
+		}
+
+		offset += filled;
+		data_offset += filled;
+		size -= filled;
+	}
+
+	return ret;
+}
+
+static int vfio_pci_get_ecap_content(struct pci_dev *pdev,
+					int cap, int cap_len, u8 *content)
+{
+	int pos, offset, len = cap_len, ret = 0;
+
+	pos = pci_find_ext_capability(pdev, cap);
+	if (!pos)
+		return -EINVAL;
+
+	offset = 0;
+	while (len) {
+		int fetched;
+
+		if (len >= 4 && !(pos % 4)) {
+			u32 *dwordp = (u32 *) (content + offset);
+			u32 dword;
+			__le32 *dwptr = (__le32 *) &dword;
+
+			ret = pci_read_config_dword(pdev, pos, &dword);
+			if (ret)
+				return ret;
+			*dwordp = le32_to_cpu(*dwptr);
+			fetched = 4;
+		} else if (len >= 2 && !(pos % 2)) {
+			u16 *wordp = (u16 *) (content + offset);
+			u16 word;
+			__le16 *wptr = (__le16 *) &word;
+
+			ret = pci_read_config_word(pdev, pos, &word);
+			if (ret)
+				return ret;
+			*wordp = le16_to_cpu(*wptr);
+			fetched = 2;
+		} else {
+			u8 *byte = (u8 *) (content + offset);
+
+			ret = pci_read_config_byte(pdev, pos, byte);
+			if (ret)
+				return ret;
+			fetched = 1;
+		}
+
+		pos += fetched;
+		offset += fetched;
+		len -= fetched;
+	}
+
+	return ret;
+}
+
+struct vfio_pci_pasid_cap_data {
+	u32 id:16;
+	u32 version:4;
+	u32 next:12;
+	union {
+		u16 cap_reg_val;
+		struct {
+			u16 rsv1:1;
+			u16 execs:1;
+			u16 prvs:1;
+			u16 rsv2:5;
+			u16 pasid_bits:5;
+			u16 rsv3:3;
+		};
+	} cap_reg;
+	union {
+		u16 control_reg_val;
+		struct {
+			u16 paside:1;
+			u16 exece:1;
+			u16 prve:1;
+			u16 rsv4:13;
+		};
+	} control_reg;
+};
+
+static int vfio_pci_add_pasid_cap(struct vfio_pci_device *vdev,
+				    struct pci_dev *pdev,
+				    u16 epos, u16 *next, __le32 **prevp)
+{
+	u8 *map = vdev->pci_config_map;
+	int ecap = PCI_EXT_CAP_ID_PASID;
+	int len = pci_ext_cap_length[ecap];
+	struct vfio_pci_pasid_cap_data pasid_cap;
+	struct vfio_pci_pasid_cap_data vpasid_cap;
+	int ret;
+
+	/*
+	 * If no cap filled in this function, should make sure the next
+	 * pointer points to current epos.
+	 */
+	*next = epos;
+
+	if (!len) {
+		pr_info("%s: VF %s hiding PASID capability\n",
+				__func__, dev_name(&vdev->pdev->dev));
+		ret = 0;
+		goto out;
+	}
+
+	/* Add PASID capability*/
+	ret = vfio_pci_get_ecap_content(pdev, ecap,
+					len, (u8 *)&pasid_cap);
+	if (ret)
+		goto out;
+
+	if (!pasid_cap.control_reg.paside) {
+		pr_debug("%s: its PF's PASID capability is not enabled\n",
+			dev_name(&vdev->pdev->dev));
+		ret = 0;
+		goto out;
+	}
+
+	memcpy(&vpasid_cap, &pasid_cap, len);
+
+	vpasid_cap.id = 0x18;
+	vpasid_cap.next = 0;
+	/* clear the control reg for guest */
+	memset(&vpasid_cap.control_reg, 0x0,
+			sizeof(vpasid_cap.control_reg));
+
+	memset(map + epos, vpasid_cap.id, len);
+	ret = vfio_fill_custom_vconfig_bytes(vdev, epos,
+					(u8 *)&vpasid_cap, len);
+	if (!ret) {
+		/*
+		 * Successfully filled in PASID cap, update
+		 * the next offset in previous cap header,
+		 * and also update caller about the offset
+		 * of next cap if any.
+		 */
+		u32 val = epos;
+		**prevp &= cpu_to_le32(~(0xffcU << 20));
+		**prevp |= cpu_to_le32(val << 20);
+		*prevp = (__le32 *)&vdev->vconfig[epos];
+		*next = epos + len;
+	}
+
+out:
+	return ret;
+}
+
+struct vfio_pci_pri_cap_data {
+	u32 id:16;
+	u32 version:4;
+	u32 next:12;
+	union {
+		u16 control_reg_val;
+		struct {
+			u16 enable:1;
+			u16 reset:1;
+			u16 rsv1:14;
+		};
+	} control_reg;
+	union {
+		u16 status_reg_val;
+		struct {
+			u16 rf:1;
+			u16 uprgi:1;
+			u16 rsv2:6;
+			u16 stop:1;
+			u16 rsv3:6;
+			u16 pasid_required:1;
+		};
+	} status_reg;
+	u32 prq_capacity;
+	u32 prq_quota;
+};
+
+static int vfio_pci_add_pri_cap(struct vfio_pci_device *vdev,
+				    struct pci_dev *pdev,
+				    u16 epos, u16 *next, __le32 **prevp)
+{
+	u8 *map = vdev->pci_config_map;
+	int ecap = PCI_EXT_CAP_ID_PRI;
+	int len = pci_ext_cap_length[ecap];
+	struct vfio_pci_pri_cap_data pri_cap;
+	struct vfio_pci_pri_cap_data vpri_cap;
+	int ret;
+
+	/*
+	 * If no cap filled in this function, should make sure the next
+	 * pointer points to current epos.
+	 */
+	*next = epos;
+
+	if (!len) {
+		pr_info("%s: VF %s hiding PRI capability\n",
+				__func__, dev_name(&vdev->pdev->dev));
+		ret = 0;
+		goto out;
+	}
+
+	/* Add PASID capability*/
+	ret = vfio_pci_get_ecap_content(pdev, ecap,
+					len, (u8 *)&pri_cap);
+	if (ret)
+		goto out;
+
+	if (!pri_cap.control_reg.enable) {
+		pr_debug("%s: its PF's PRI capability is not enabled\n",
+			dev_name(&vdev->pdev->dev));
+		ret = 0;
+		goto out;
+	}
+
+	memcpy(&vpri_cap, &pri_cap, len);
+
+	vpri_cap.id = 0x19;
+	vpri_cap.next = 0;
+	/* clear the control reg for guest */
+	memset(&vpri_cap.control_reg, 0x0,
+			sizeof(vpri_cap.control_reg));
+
+	memset(map + epos, vpri_cap.id, len);
+	ret = vfio_fill_custom_vconfig_bytes(vdev, epos,
+					(u8 *)&vpri_cap, len);
+	if (!ret) {
+		/*
+		 * Successfully filled in PASID cap, update
+		 * the next offset in previous cap header,
+		 * and also update caller about the offset
+		 * of next cap if any.
+		 */
+		u32 val = epos;
+		**prevp &= cpu_to_le32(~(0xffcU << 20));
+		**prevp |= cpu_to_le32(val << 20);
+		*prevp = (__le32 *)&vdev->vconfig[epos];
+		*next = epos + len;
+	}
+
+out:
+	return ret;
+}
+
+static int vfio_pci_add_emulated_cap_for_vf(struct vfio_pci_device *vdev,
+			struct pci_dev *pdev, u16 start_epos, __le32 *prev)
+{
+	__le32 *__prev = prev;
+	u16 epos = start_epos, epos_next = start_epos;
+	int ret = 0;
+
+	/* Add PASID capability*/
+	ret = vfio_pci_add_pasid_cap(vdev, pdev, epos,
+					&epos_next, &__prev);
+	if (ret)
+		return ret;
+
+	/* Add PRI capability */
+	epos = epos_next;
+	ret = vfio_pci_add_pri_cap(vdev, pdev, epos,
+				   &epos_next, &__prev);
+
+	return ret;
+}
+
 static int vfio_ecap_init(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u8 *map = vdev->pci_config_map;
-	u16 epos;
+	u16 epos, epos_max;
 	__le32 *prev = NULL;
 	int loops, ret, ecaps = 0;
 
@@ -1521,6 +1814,7 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
 		return 0;
 
 	epos = PCI_CFG_SPACE_SIZE;
+	epos_max = PCI_CFG_SPACE_SIZE;
 
 	loops = (pdev->cfg_size - PCI_CFG_SPACE_SIZE) / PCI_CAP_SIZEOF;
 
@@ -1545,6 +1839,9 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
 			}
 		}
 
+		if (epos_max <= (epos + len))
+			epos_max = epos + len;
+
 		if (!len) {
 			pci_info(pdev, "%s: hiding ecap %#x@%#x\n",
 				 __func__, ecap, epos);
@@ -1604,6 +1901,16 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
 	if (!ecaps)
 		*(u32 *)&vdev->vconfig[PCI_CFG_SPACE_SIZE] = 0;
 
+	if (pdev->is_virtfn) {
+		struct pci_dev *physfn = pdev->physfn;
+
+		ret = vfio_pci_add_emulated_cap_for_vf(vdev,
+					physfn, epos_max, prev);
+		if (ret)
+			pr_info("%s, failed to add special caps for VF %s\n",
+				__func__, dev_name(&vdev->pdev->dev));
+	}
+
 	return 0;
 }
 
@@ -1748,6 +2055,13 @@ static size_t vfio_pci_cap_remaining_dword(struct vfio_pci_device *vdev,
 	return i;
 }
 
+static bool vfio_pci_need_virt_perm(struct pci_dev *pdev, u8 cap_id)
+{
+	return (pdev->is_virtfn &&
+		(cap_id == PCI_EXT_CAP_ID_PASID ||
+		 cap_id == PCI_EXT_CAP_ID_PRI));
+}
+
 static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
 				 size_t count, loff_t *ppos, bool iswrite)
 {
@@ -1781,7 +2095,8 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
 	if (cap_id == PCI_CAP_ID_INVALID) {
 		perm = &unassigned_perms;
 		cap_start = *ppos;
-	} else if (cap_id == PCI_CAP_ID_INVALID_VIRT) {
+	} else if (cap_id == PCI_CAP_ID_INVALID_VIRT ||
+		   vfio_pci_need_virt_perm(pdev, cap_id)) {
 		perm = &virt_perms;
 		cap_start = *ppos;
 	} else {
-- 
2.7.4

