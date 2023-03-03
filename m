Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4086A909D
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 06:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjCCFzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 00:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCCFzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 00:55:36 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D84137562;
        Thu,  2 Mar 2023 21:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677822900; x=1709358900;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nUSuvRM6b8DXxEqFX9pBbz8Bzz7M8cWsrYdVR4i/4sA=;
  b=cMtmPL7D0x9jp0qUwcXYodWtd3pWgDv+MpapvzQWrOEbTMQvCOmxTFX7
   O8Oi7GXRiFm43MnXKiLuxLt+rRiMErGAp/fygVElNPf5ZlDYO2JEId7sb
   QpAvQ6AQaajTO1+pc+QJc3vSOdQv5FEunCS5nEnN0oWb7R8CGg0OWJXXe
   OfR6rjVCMoaM7xb/aU/bjuUcOMwdzuRxyDZbtFoYv6cNicp0QnC7V87as
   yvwbHBNv2r1yvDniNdagYwLlEkHc6SYDGIRGm6i474HiZqYMncqDcwi9n
   /RjG4WUNrZKw+4/P3Q4UgjCyUraKK2jIKv9O/PcJxFyS7D/LWMwDT7bcD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="318786448"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="318786448"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 21:54:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="764295417"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="764295417"
Received: from gsd-build.iind.intel.com ([10.227.90.132])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 21:54:46 -0800
From:   "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca
Cc:     "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>
Subject: [PATCH] vfio/pci: Add DVSEC PCI Extended Config Capability to user visible list.
Date:   Fri,  3 Mar 2023 05:54:26 +0000
Message-Id: <20230303055426.2299006-1-satyanarayana.k.v.p@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel Platform Monitoring Technology (PMT) support is indicated by presence
of an Intel defined PCIe Designated Vendor Specific Extended Capabilities
(DVSEC) structure with a PMT specific ID.However DVSEC structures may also
be used by Intel to indicate support for other features. The Out Of Band Management
Services Module (OOBMSM) uses DVSEC to enumerate several features, including PMT.

The current VFIO driver does not pass DVSEC capabilities to virtual machine (VM)
which makes intel_vsec driver not to work in the VM. This series adds DVSEC
capability to user visible list to allow its use with VFIO.

Signed-off-by: K V P Satyanarayana <satyanarayana.k.v.p@intel.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 523e0144c86f..d984c0dd6cca 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -96,6 +96,7 @@ static const u16 pci_ext_cap_length[PCI_EXT_CAP_ID_MAX + 1] = {
 	[PCI_EXT_CAP_ID_SECPCI]	=	0,	/* not yet */
 	[PCI_EXT_CAP_ID_PMUX]	=	0,	/* not yet */
 	[PCI_EXT_CAP_ID_PASID]	=	0,	/* not yet */
+	[PCI_EXT_CAP_ID_DVSEC]	=	0xFF,
 };
 
 /*
@@ -1440,6 +1441,13 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
 			return PCI_TPH_BASE_SIZEOF + (sts * 2) + 2;
 		}
 		return PCI_TPH_BASE_SIZEOF;
+	case PCI_EXT_CAP_ID_DVSEC:
+		ret = pci_read_config_dword(pdev, epos + PCI_DVSEC_HEADER1, &dword);
+		if (ret)
+			return pcibios_err_to_errno(ret);
+
+		return PCI_DVSEC_HEADER1_LEN(dword);
+
 	default:
 		pci_warn(pdev, "%s: unknown length for PCI ecap %#x@%#x\n",
 			 __func__, ecap, epos);
-- 
2.34.1

