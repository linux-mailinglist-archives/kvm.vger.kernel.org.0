Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA5D6BE33A
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 09:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjCQIX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 04:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjCQIXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 04:23:17 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98679D5A44;
        Fri, 17 Mar 2023 01:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679041375; x=1710577375;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f8DXY+pVVHfCkMB1JHs3DE65L96pEtB89jOaYuZ7eoY=;
  b=U9R9kNDcrPO2zTS8hv/DNwkQHmb4wym1kuOB71S4DDiOl11vWim4ssQn
   Yn5bboQcRdUkCm33uXFETIGYmEqJzfhy+YKY6eltiQkrxG4ZHXQl+dneM
   3B4CcZ+bAdXVxccvBJjcbrM0c2gdjBAyaW3scA6PIqvvqKO3MDfpYrsyj
   WlqkLUNHZE9+wAP4YIXntSGMI7j14LS9ph5m8Lb3qSyG4RT3DHqBO2IR4
   HuiAk6Lw1fAXHBChIZ56fGOv+PkNbL7W2fTrWVS3SugU9ga7r1yO/C3+M
   rcHakIdqQ0t4vEuxlcnkW3jx6Z3Jh/6I1NKmiqIeyCJakjor1/2gciNew
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="403081807"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="403081807"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 01:22:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="680220217"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="680220217"
Received: from gsd-build.iind.intel.com ([10.227.90.132])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 01:22:31 -0700
From:   "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, michal.winiarski@intel.com,
        dave.jiang@intel.com, ashok.raj@intel.com
Cc:     "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>
Subject: [PATCH v2] vfio/pci: Add DVSEC PCI Extended Config Capability to user visible list.
Date:   Fri, 17 Mar 2023 08:22:22 +0000
Message-Id: <20230317082222.3355912-1-satyanarayana.k.v.p@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Designated Vendor-Specific Extended Capability (DVSEC Capability) is an
optional Extended Capability that is permitted to be implemented by any PCI
Express Function. This allows PCI Express component vendors to use
the Extended Capability mechanism to expose vendor-specific registers that can
be present in components by a variety of vendors. A DVSEC Capability structure
can tell vendor-specific software which features a particular component
supports.

An example usage of DVSEC is Intel Platform Monitoring Technology (PMT) for
enumerating and accessing hardware monitoring capabilities on a device.
PMT encompasses three device monitoring features, Telemetry (device metrics),
Watcher (sampling/tracing), and Crashlog. The DVSEC is used to discover these
features and provide a BAR offset to their registers with the Intel vendor code.

The current VFIO driver does not pass DVSEC capabilities to Virtual Machine (VM)
which makes PMT not to work inside the virtual machine. This series adds DVSEC
capability to user visible list to allow its use with VFIO. VFIO supports
passing of Vendor Specific Extended Capability (VSEC) and raw write access to
device. DVSEC also passed to VM in the same way as of VSEC.

Signed-off-by: K V P Satyanarayana <satyanarayana.k.v.p@intel.com>

Changes since Version V2:
- Added support for raw pci write for DVSEC same as VSEC.
---
 drivers/vfio/pci/vfio_pci_config.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 523e0144c86f..948cdd464f4e 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -96,6 +96,7 @@ static const u16 pci_ext_cap_length[PCI_EXT_CAP_ID_MAX + 1] = {
 	[PCI_EXT_CAP_ID_SECPCI]	=	0,	/* not yet */
 	[PCI_EXT_CAP_ID_PMUX]	=	0,	/* not yet */
 	[PCI_EXT_CAP_ID_PASID]	=	0,	/* not yet */
+	[PCI_EXT_CAP_ID_DVSEC]	=	0xFF,
 };
 
 /*
@@ -1101,6 +1102,7 @@ int __init vfio_pci_init_perm_bits(void)
 	ret |= init_pci_ext_cap_err_perm(&ecap_perms[PCI_EXT_CAP_ID_ERR]);
 	ret |= init_pci_ext_cap_pwr_perm(&ecap_perms[PCI_EXT_CAP_ID_PWR]);
 	ecap_perms[PCI_EXT_CAP_ID_VNDR].writefn = vfio_raw_config_write;
+	ecap_perms[PCI_EXT_CAP_ID_DVSEC].writefn = vfio_raw_config_write;
 
 	if (ret)
 		vfio_pci_uninit_perm_bits();
@@ -1440,6 +1442,11 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
 			return PCI_TPH_BASE_SIZEOF + (sts * 2) + 2;
 		}
 		return PCI_TPH_BASE_SIZEOF;
+	case PCI_EXT_CAP_ID_DVSEC:
+		ret = pci_read_config_dword(pdev, epos + PCI_DVSEC_HEADER1, &dword);
+		if (ret)
+			return pcibios_err_to_errno(ret);
+		return PCI_DVSEC_HEADER1_LEN(dword);
 	default:
 		pci_warn(pdev, "%s: unknown length for PCI ecap %#x@%#x\n",
 			 __func__, ecap, epos);
-- 
2.34.1

