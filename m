Return-Path: <kvm+bounces-9319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 398A385E243
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 17:00:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AA181C21868
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 16:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664F282C94;
	Wed, 21 Feb 2024 15:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eiV55Yhx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED9782869;
	Wed, 21 Feb 2024 15:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708531139; cv=none; b=bpCMkvVnqrzKcSPglxyU43B4GGjwDNe2hDo/Vbt4JAp0WHKtHWus1m68zYVRBlnZbC34hHgXsVfCmrkjmEfoRufRyWkCIgck+sIAVG2TlXVpA8LX0Gw+UwDVFSpkGrlAermLO4e+vTxpZkqu4nVt5HvW1e+z7+BPPimBH30/QbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708531139; c=relaxed/simple;
	bh=kO+x8f1GcY1UOI/mEjLp3C52JBVsivM06TIuI/siDAY=;
	h=From:To:Cc:Subject:Date:Message-Id; b=fKJ627jyV9KZAdhTFupaL4bljNIU8DHR/txTS9STNuHh61ePRwUQmdmBsRgLckbg0HtgGEHAl+wAg6z9YKHQJhCn7nTDmesvVDLW2Lq3Dys/UJtmrKHZJ9Zs8VfKx1vkvjhkqWT6gdfp0w9QPWBsje0ofN4NTQ5uJaQDdZX2qCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eiV55Yhx; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708531137; x=1740067137;
  h=from:to:cc:subject:date:message-id;
  bh=kO+x8f1GcY1UOI/mEjLp3C52JBVsivM06TIuI/siDAY=;
  b=eiV55YhxzVSojQQ0+NymtjByafR5qiPVMcNx0jmOB+0p2h06KzIYaO2l
   EmcsVT39dEnVOcW6HlXJjVXrn/DZLcx8lA5phW4lsz3KTU3l5w1t6XoPM
   TaaPeCjD1a9QOmwIFcQsGYSwo3OrjNPD5QwYM+onrTKP2QA2Y0BeehhyC
   m8qZHfZUVcHk5rl8W5fd9rRzUjvgw86ZEJ3rOiox/36KlgMbxVD0oCDVk
   1GAM7S3mG8+Bnr6o640YCxy7874yIfGCdOmBB8x6Fqe53npnHLCPCjpd5
   kT8FWlmIWg7pU9L53rTfjNmLrfCNrGpO7WKixgsoWkDExSjPEjFm6u+eH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="2568655"
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="2568655"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 07:58:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="9760781"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmviesa004.fm.intel.com with ESMTP; 21 Feb 2024 07:58:41 -0800
From: Xin Zeng <xin.zeng@intel.com>
To: herbert@gondor.apana.org.au,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com
Cc: linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org,
	qat-linux@intel.com,
	Xin Zeng <xin.zeng@intel.com>
Subject: [PATCH v3 00/10] crypto: qat - enable QAT GEN4 SRIOV VF live migration for QAT GEN4
Date: Wed, 21 Feb 2024 23:49:58 +0800
Message-Id: <20240221155008.960369-1-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

This set enables live migration for Intel QAT GEN4 SRIOV Virtual
Functions (VFs).
It is composed of 10 patches. Patch 1~6 refactor the original QAT PF
driver implementation which will be reused by the following patches.
Patch 7 introduces the logic to the QAT PF driver that allows to save
and restore the state of a bank (a QAT VF is a wrapper around banks) and
drain a ring pair. Patch 8 adds the QAT PF driver a set of interfaces to
allow to save and restore the state of a VF that will be called by the
module qat_vfio_pci which will be introduced in the last patch. Patch 9
implements the defined device interfaces. The last one adds a vfio pci
extension specific for QAT which intercepts the vfio device operations
for a QAT VF to allow live migration.

Here are the steps required to test the live migration of a QAT GEN4 VF:
1. Bind one or more QAT GEN4 VF devices to the module qat_vfio_pci.ko 
2. Assign the VFs to the virtual machine and enable device live
migration 
3. Run a workload using a QAT VF inside the VM, for example using qatlib
(https://github.com/intel/qatlib) 
4. Migrate the VM from the source node to a destination node

Changes in v3 from v2: https://lore.kernel.org/kvm/20240220032052.66834-1-xin.zeng@intel.com
-  Use state_mutex directly instead of unnecessary deferred_reset
   mode (Jason)

Changes in v2 from v1: https://lore.kernel.org/all/20240201153337.4033490-1-xin.zeng@intel.com
-  Add VFIO_MIGRATION_PRE_COPY support (Alex)
-  Remove unnecessary module dependancy in Kconfig (Alex)
-  Use direct function calls instead of function pointers in qat vfio
   variant driver (Jason)
-  Address the comments including uncessary pointer check and kfree,
   missing lock and direct use of pci_iov_vf_id (Shameer)
-  Change CHECK_STAT macro to avoid repeat comparison (Kamlesh)

Changes in v1 from RFC: https://lore.kernel.org/all/20230630131304.64243-1-xin.zeng@intel.com
-  Address comments including the right module dependancy in Kconfig,
   source file name and module description (Alex)
-  Added PCI error handler and P2P state handler (Suggested by Kevin)
-  Refactor the state check duing loading ring state (Kevin) 
-  Fix missed call to vfio_put_device in the error case (Breet)
-  Migrate the shadow states in PF driver
-  Rebase on top of 6.8-rc1

Giovanni Cabiddu (2):
  crypto: qat - adf_get_etr_base() helper
  crypto: qat - relocate CSR access code

Siming Wan (3):
  crypto: qat - rename get_sla_arr_of_type()
  crypto: qat - expand CSR operations for QAT GEN4 devices
  crypto: qat - add bank save and restore flows

Xin Zeng (5):
  crypto: qat - relocate and rename 4xxx PF2VM definitions
  crypto: qat - move PFVF compat checker to a function
  crypto: qat - add interface for live migration
  crypto: qat - implement interface for live migration
  vfio/qat: Add vfio_pci driver for Intel QAT VF devices

 MAINTAINERS                                   |    8 +
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |    3 +
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |    5 +
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |    1 +
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |    1 +
 .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |    1 +
 .../intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c |    1 +
 drivers/crypto/intel/qat/qat_common/Makefile  |    6 +-
 .../intel/qat/qat_common/adf_accel_devices.h  |   88 ++
 .../intel/qat/qat_common/adf_common_drv.h     |   10 +
 .../qat/qat_common/adf_gen2_hw_csr_data.c     |  101 ++
 .../qat/qat_common/adf_gen2_hw_csr_data.h     |   86 ++
 .../intel/qat/qat_common/adf_gen2_hw_data.c   |   97 --
 .../intel/qat/qat_common/adf_gen2_hw_data.h   |   76 --
 .../qat/qat_common/adf_gen4_hw_csr_data.c     |  231 ++++
 .../qat/qat_common/adf_gen4_hw_csr_data.h     |  188 +++
 .../intel/qat/qat_common/adf_gen4_hw_data.c   |  380 +++++--
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |  127 +--
 .../intel/qat/qat_common/adf_gen4_pfvf.c      |    8 +-
 .../intel/qat/qat_common/adf_gen4_vf_mig.c    | 1010 +++++++++++++++++
 .../intel/qat/qat_common/adf_gen4_vf_mig.h    |   10 +
 .../intel/qat/qat_common/adf_mstate_mgr.c     |  318 ++++++
 .../intel/qat/qat_common/adf_mstate_mgr.h     |   89 ++
 .../intel/qat/qat_common/adf_pfvf_pf_proto.c  |    8 +-
 .../intel/qat/qat_common/adf_pfvf_utils.h     |   11 +
 drivers/crypto/intel/qat/qat_common/adf_rl.c  |   10 +-
 drivers/crypto/intel/qat/qat_common/adf_rl.h  |    2 +
 .../crypto/intel/qat/qat_common/adf_sriov.c   |    7 +-
 .../intel/qat/qat_common/adf_transport.c      |    4 +-
 .../crypto/intel/qat/qat_common/qat_mig_dev.c |  130 +++
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |    1 +
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |    1 +
 drivers/vfio/pci/Kconfig                      |    2 +
 drivers/vfio/pci/Makefile                     |    2 +
 drivers/vfio/pci/intel/qat/Kconfig            |   12 +
 drivers/vfio/pci/intel/qat/Makefile           |    3 +
 drivers/vfio/pci/intel/qat/main.c             |  663 +++++++++++
 include/linux/qat/qat_mig_dev.h               |   31 +
 38 files changed, 3345 insertions(+), 387 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/qat_mig_dev.c
 create mode 100644 drivers/vfio/pci/intel/qat/Kconfig
 create mode 100644 drivers/vfio/pci/intel/qat/Makefile
 create mode 100644 drivers/vfio/pci/intel/qat/main.c
 create mode 100644 include/linux/qat/qat_mig_dev.h


base-commit: a821f4cadc99272701016641bc821182fdfca289
-- 
2.18.2


