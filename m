Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D3722C121
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 10:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgGXIsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 04:48:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:45604 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbgGXIsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 04:48:19 -0400
IronPort-SDR: Me7R6gkuIenGPzoD6rBtQtZl+GKgz8OMFG0Nz8N+btZjPf6/2gpyOgpAGMtOZ60rc7bn/fpomr
 Df+4rSoaHtYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="138742749"
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="138742749"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 01:48:18 -0700
IronPort-SDR: pgbjS0y2dFAKBp2OGg1MMzxpewRfx+AHqzmSheYz5Ye5Z9JhOnpuVPoPOVmB/ViN4aStoraeaJ
 PdcPTeWs/jzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="311335304"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jul 2020 01:48:15 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     alex.williamson@redhat.com, herbert@gondor.apana.org.au
Cc:     cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        fiona.trahe@intel.com, qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v4 3/5] vfio/pci: Add QAT devices to denylist
Date:   Fri, 24 Jul 2020 09:47:58 +0100
Message-Id: <20200724084800.6136-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200724084800.6136-1-giovanni.cabiddu@intel.com>
References: <20200724084800.6136-1-giovanni.cabiddu@intel.com>
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

This patch adds the following QAT devices to the denylist: DH895XCC,
C3XXX and C62X.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 0101f41e7834..bcc22d19ee07 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -75,6 +75,21 @@ static inline bool vfio_vga_disabled(void)
 
 static bool vfio_pci_dev_in_denylist(struct pci_dev *pdev)
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

