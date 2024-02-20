Return-Path: <kvm+bounces-9118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C8885B15E
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 04:29:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 700BA1F21C23
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 03:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C5456B76;
	Tue, 20 Feb 2024 03:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KZndW+uO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB0356773;
	Tue, 20 Feb 2024 03:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708399769; cv=none; b=qtjnbD3o1CxOexU6S1eqVik3fTiwJSc+vLMYwze3epVTE0sRIWNsyI72GnX0+ZWguASoSCdy1RG7Z+l4HU6AULuiYImqZaTJwYX0kqPcHOyoIJ9VkuxDsRQprKfXibYdbDKilDyufMDjXZcYhnsCscDVrGHR6hYp0+A4BO1g600=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708399769; c=relaxed/simple;
	bh=3ynj3ImIshmeEYw+4jYI4v+jdvX+qcufgwzspF8Fej8=;
	h=From:To:Cc:Subject:Date:Message-Id; b=c3rnH231pcC4qPskuuZ+GLjcJS8nQwwpvl8vTWZuxni3KO5crSi4XARkZb6Dp3VLGi2kAAyHuEL2Gv0pWW7M/HgcEKD7Gk2kHR742fD3NrDXu7CNebUQTgRHcyj5C/lH9YE/tq6X9ELEidogXtGtznTKasYZzx92+WKuK8zM+Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KZndW+uO; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708399768; x=1739935768;
  h=from:to:cc:subject:date:message-id;
  bh=3ynj3ImIshmeEYw+4jYI4v+jdvX+qcufgwzspF8Fej8=;
  b=KZndW+uO+1LGu2E330T6yX+3aAV5a4peYmqXaMzPp+etY9ASWFPgROTg
   k9y+KcAJY8AST2x5z4sXtNETXOYR3/Umubislddb7Cg28xspCysrgbuey
   4ximAsky3o1A+KCmS1vdXkkJAFj4YQbqzcudmYkjN2faTv3sE0hJEd69G
   R5HvYmHGnhz2AN7jiqdo5r0iu0gA1MPTjmJtduxYP0bTnl9gPsoJ/SvJ8
   yfbU+uBh62xzVfzZ/dcOp4hxbsk+iCjG0Tv4b8l0JA7nwCSjBiNJcAvOJ
   qALxjJTofHHIZkhzJ4EOo3f8Hqrq0qWRsdtf9Z8J33+sav1vtNkl83mAc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2354065"
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="2354065"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 19:29:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="9302067"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa003.jf.intel.com with ESMTP; 19 Feb 2024 19:29:24 -0800
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
Subject: [PATCH v2 00/10] crypto: qat - enable QAT GEN4 SRIOV VF live migration for QAT GEN4
Date: Tue, 20 Feb 2024 11:20:42 +0800
Message-Id: <20240220032052.66834-1-xin.zeng@intel.com>
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

Changes in v2 from v1:
https://lore.kernel.org/all/20240201153337.4033490-1-xin.zeng@intel.com
-  Add VFIO_MIGRATION_PRE_COPY support (Alex)
-  Remove unnecessary module dependancy in Kconfig (Alex)
-  Use direct function calls instead of function pointers in qat vfio
   variant driver (Jason)
-  Address the comments including uncessary pointer check and kfree,
   missing lock and direct use of pci_iov_vf_id (Shameer)
-  Change CHECK_STAT macro to avoid repeat comparison (Kamlesh)

Changes in v1 from RFC:
https://lore.kernel.org/all/20230630131304.64243-1-xin.zeng@intel.com
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
 .../intel/qat/qat_common/adf_gen4_vf_mig.c    | 1003 +++++++++++++++++
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
 drivers/vfio/pci/intel/qat/main.c             |  688 +++++++++++
 include/linux/qat/qat_mig_dev.h               |   31 +
 38 files changed, 3363 insertions(+), 387 deletions(-)
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


