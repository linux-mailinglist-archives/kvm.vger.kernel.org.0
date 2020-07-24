Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B742322C3E0
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 12:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgGXK4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 06:56:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:6918 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbgGXK4U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 06:56:20 -0400
IronPort-SDR: gZnl9j//nozhHPzcTi6tFXGf9NFphX4+7BeYorAieU/BuFgQbvrd+Z7suiYq517Hfg23rL4Htv
 YkagLPlUg3TA==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="150675029"
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="150675029"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 03:56:19 -0700
IronPort-SDR: /4qoBCkXM4d6YKyxWH9Oz0mAgHCD0o02zZ41ydPRQ9d2VYEa1CdG4ox7Fdbo3oELzTIcdphsuw
 SaDhgtDvQyjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="284901554"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga003.jf.intel.com with ESMTP; 24 Jul 2020 03:56:16 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     alex.williamson@redhat.com, herbert@gondor.apana.org.au
Cc:     cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        fiona.trahe@intel.com, qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v5 3/5] vfio/pci: Add QAT devices to denylist
Date:   Fri, 24 Jul 2020 11:55:58 +0100
Message-Id: <20200724105600.10814-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200724105600.10814-1-giovanni.cabiddu@intel.com>
References: <20200724105600.10814-1-giovanni.cabiddu@intel.com>
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
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
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

