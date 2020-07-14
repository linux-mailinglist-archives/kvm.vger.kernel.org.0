Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B7C21E848
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 08:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgGNGgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 02:36:55 -0400
Received: from mga06.intel.com ([134.134.136.31]:13263 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbgGNGgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 02:36:53 -0400
IronPort-SDR: QSEawiaNdJv80pd3v35MdjXYvvRxQbUs3Nwtn2R3JVlVSmb0devMXAs35lamX+IqLe6j1Pe0PS
 //QZyJYnyaOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="210355843"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="210355843"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 23:36:53 -0700
IronPort-SDR: CeLXZyk83nxgbwNdGmR755/Ju4y8oPxYlfl0n4/E1Oo0g/r2TSYElfYRRCdY+tp22LWmLy9SIx
 VZ4pEB/TP7pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="299435551"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga002.jf.intel.com with ESMTP; 13 Jul 2020 23:36:49 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     alex.williamson@redhat.com, herbert@gondor.apana.org.au
Cc:     cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 3/5] vfio/pci: Add QAT devices to blocklist
Date:   Tue, 14 Jul 2020 07:36:08 +0100
Message-Id: <20200714063610.849858-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714063610.849858-1-giovanni.cabiddu@intel.com>
References: <20200714063610.849858-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current generation of Intel® QuickAssist Technology devices
are not designed to run in an untrusted environment because of the
following issues reported in the document "Intel® QuickAssist Technology
(Intel® QAT) Software for Linux" (document number 336211-014):

QATE-39220 - GEN - Intel® QAT API submissions with bad addresses that
             trigger DMA to invalid or unmapped addresses can cause a
             platform hang
QATE-7495  - GEN - An incorrectly formatted request to Intel® QAT can
             hang the entire Intel® QAT Endpoint

The document is downloadable from https://01.org/intel-quickassist-technology
at the following link:
https://01.org/sites/default/files/downloads/336211-014-qatforlinux-releasenotes-hwv1.7_0.pdf

This patch adds the following QAT devices to the blocklist: DH895XCC,
C3XXX and C62X.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index ea5904ca6cbf..dcac5408c764 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -75,6 +75,21 @@ static inline bool vfio_vga_disabled(void)
 
 static bool vfio_pci_dev_in_blocklist(struct pci_dev *pdev)
 {
+	switch (pdev->vendor) {
+	case PCI_VENDOR_ID_INTEL:
+		switch (pdev->device) {
+		case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
+		case PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF:
+		case PCI_DEVICE_ID_INTEL_QAT_C62X:
+		case PCI_DEVICE_ID_INTEL_QAT_C62X_VF:
+		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
+		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF:
+			return true;
+		default:
+			return false;
+		}
+	}
+
 	return false;
 }
 
-- 
2.26.2

