Return-Path: <kvm+bounces-19236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5502C90248B
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 16:50:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53C981C22B53
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 14:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D01139579;
	Mon, 10 Jun 2024 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AKOG+uIB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D9D135A7E;
	Mon, 10 Jun 2024 14:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718030889; cv=none; b=XxPePH3mAgnRMZmpL5LQwtl0rUYaIZNSI/TGaXcP0+nFxR29JPWZps9Ns+hBEg1c0GWIB1nli9hwjN12QomOXhE6c/N0bgNyt5ikf+nh1i+7ag/+hpgcWh9WX5HFF8ryNsP03FCOdaPgG7w2UBLixsw09JP2qryP6C9EEIjHJqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718030889; c=relaxed/simple;
	bh=Id0eYrZGL0JaBkLoeHCoTfXGUS8qKGnKHyCnt698f2I=;
	h=From:To:Cc:Subject:Date:Message-Id; b=KsjQjrdFY0lmhkxUAYSaDX198A0PVmGnB7lgXkQ6KfQ51D9dsfQMnoY3onDi0Zl2gdL/kxoR7dYTgkLdGqDGzhy1nThPTXyrWmfM3pgP9S895zwA7UvEBoCtm8K4gvdCNti6QOHl5TN0qNfBktgEo6ie7j7RmMbnsDMs6HGSxXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AKOG+uIB; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718030888; x=1749566888;
  h=from:to:cc:subject:date:message-id;
  bh=Id0eYrZGL0JaBkLoeHCoTfXGUS8qKGnKHyCnt698f2I=;
  b=AKOG+uIB+0BtuhOaY50HaIOfWHWu80y8ekkoqNmpI87czxMv9BPcsV+z
   MxJYm6bPD/mNST9FOs5ghBhuyYmkAKvhnkqAFinJiA4Aoe0urU7L0Ng2x
   pzEJHrI5e6Eri++azLxFH9GQZVlSLbFsulfkBM+XWvg3DpMhdd7RdwP6x
   8naE2NpyUIV7L/C7+M2iiIHhypkCpqzIl7O14fBaLRwLkPbqNNbsxfDP4
   0RzI+ze4w3OF4SjRUZqzvjqmjzP/L2BEpsG2oAXP5+ZjqBfXDnMceRc2u
   r3jmdYciKFaM1iho1LEnp/vm8zvsD294X6w1EscQXhsAlTXVNzAQJ+eoQ
   Q==;
X-CSE-ConnectionGUID: N0xAUsp3SBiYXCACr+U0Ow==
X-CSE-MsgGUID: Kg/cXSZhTGqXOPwUEhLUfw==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="18526047"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="18526047"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 07:48:07 -0700
X-CSE-ConnectionGUID: R6NIT3N/REm6/vaBn7aj7A==
X-CSE-MsgGUID: iOVXeQxiQ8WFAzyIrK8ziw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="69872049"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa002.jf.intel.com with ESMTP; 10 Jun 2024 07:48:04 -0700
From: Xin Zeng <xin.zeng@intel.com>
To: herbert@gondor.apana.org.au,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	arnd@arndb.de
Cc: linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org,
	qat-linux@intel.com,
	Xin Zeng <xin.zeng@intel.com>
Subject: [PATCH] crypto: qat - fix linking errors when PCI_IOV is disabled
Date: Mon, 10 Jun 2024 22:37:56 +0800
Message-Id: <20240610143756.2031626-1-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

When CONFIG_PCI_IOV=n, the build of the QAT vfio pci variant driver
fails reporting the following linking errors:

    ERROR: modpost: "qat_vfmig_open" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
    ERROR: modpost: "qat_vfmig_resume" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
    ERROR: modpost: "qat_vfmig_save_state" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
    ERROR: modpost: "qat_vfmig_suspend" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
    ERROR: modpost: "qat_vfmig_load_state" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
    ERROR: modpost: "qat_vfmig_reset" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
    ERROR: modpost: "qat_vfmig_save_setup" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
    ERROR: modpost: "qat_vfmig_destroy" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
    ERROR: modpost: "qat_vfmig_close" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
    ERROR: modpost: "qat_vfmig_cleanup" [drivers/vfio/pci/qat/qat_vfio_pci.ko] undefined!
    WARNING: modpost: suppressed 1 unresolved symbol warnings because there were too many)

Make live migration helpers provided by QAT PF driver always available
even if CONFIG_PCI_IOV is not selected. This does not cause any side
effect.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Closes: https://lore.kernel.org/lkml/20240607153406.60355e6c.alex.williamson@redhat.com/T/
Fixes: bb208810b1ab ("vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV VF devices")
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 6f9266edc9f1..eac73cbfdd38 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -39,7 +39,8 @@ intel_qat-objs := adf_cfg.o \
 	adf_sysfs_rl.o \
 	qat_uclo.o \
 	qat_hal.o \
-	qat_bl.o
+	qat_bl.o \
+	qat_mig_dev.o
 
 intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o \
 				adf_fw_counters.o \
@@ -56,6 +57,6 @@ intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o \
 intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_vf_isr.o adf_pfvf_utils.o \
 			       adf_pfvf_pf_msg.o adf_pfvf_pf_proto.o \
 			       adf_pfvf_vf_msg.o adf_pfvf_vf_proto.o \
-			       adf_gen2_pfvf.o adf_gen4_pfvf.o qat_mig_dev.o
+			       adf_gen2_pfvf.o adf_gen4_pfvf.o
 
 intel_qat-$(CONFIG_CRYPTO_DEV_QAT_ERROR_INJECTION) += adf_heartbeat_inject.o

base-commit: ed00b94dc9e7befd6a77038bd351e0370f73f22c
-- 
2.18.2


