Return-Path: <kvm+bounces-2140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB4267F243A
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 03:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15B101C2191E
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 02:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82DA914F9F;
	Tue, 21 Nov 2023 02:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZohyQsEn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4710D2;
	Mon, 20 Nov 2023 18:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700534985; x=1732070985;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fdaQz0ZM4OtUE45j2+h6jhkmPo/THh9DldmSVo5IyKs=;
  b=ZohyQsEneiD0eXFzyLKHyH/Tw01nBmIvx4hrmmBCDJ0BEqVPS5ls2UOy
   yidK1XQvIlVBbdWg91LMiRcxUQFQDsj35VwZWRnzxcnQ5dT+m+baipH8k
   uPDT5QU1/gV51ABaCm20bQi6GoCw+s8fQaP7YIjkJMvGhufBHubM8fMvc
   XOhjv9OlZ3k99I0hbBRXFI5UvXuDniTBgOwbVgLQFax8aPFyFi705Ddwe
   5aylZCjymbZI/M61mggZ8tyGNxU5K7TZK8S7ldBw92kr3Go1hCt5noJ0D
   Z9HVLfV2MHNAR/Sg/0qR1EjQcdxHjzljBtNvwwpICJ3S4SCiCcaOLZK1j
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="458245823"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="458245823"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 18:49:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="832488158"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="832488158"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.85])
  by fmsmga008.fm.intel.com with ESMTP; 20 Nov 2023 18:49:39 -0800
From: Yahui Cao <yahui.cao@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	lingyu.liu@intel.com,
	kevin.tian@intel.com,
	madhu.chittim@intel.com,
	sridhar.samudrala@intel.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	brett.creeley@amd.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Subject: [PATCH iwl-next v4 00/12] Add E800 live migration driver
Date: Tue, 21 Nov 2023 02:50:59 +0000
Message-Id: <20231121025111.257597-1-yahui.cao@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds vfio live migration support for Intel E810 VF devices
based on the v2 migration protocol definition series discussed here[0].

Steps to test:
1. Bind one or more E810 VF devices to the module ice-vfio-pci.ko
2. Assign the VFs to the virtual machine and enable device live migration
3. Run a workload using IAVF inside the VM, for example, iperf.
4. Migrate the VM from the source node to a destination node.

The series is also available for review here[1].

Thanks,
Yahui
[0] https://lore.kernel.org/kvm/20220224142024.147653-1-yishaih@nvidia.com/
[1] https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux.git/log/?h=ice_live_migration

Change log:

v4:
 - Remove unnecessary iomap from vfio variant driver
 - Change Kconfig to select VFIO_PCI_CORE for ICE_VFIO_PCI module (Alex)
 - Replace restore state with load state for naming convention
 - Remove RXDID Patch
 - Fix missed comments in Patch03
 - Remove "so" at the beginning of the sentence and fix other grammar issue.
 - Remove double init and change return logic for Patch 10
 - Change ice_migration_unlog_vf_msg comments for Patch04
 - Add r-b from Michal to Patch04 of v4
 - Change ice_migration_is_loggable_msg return value type into bool type for Patch05
 - Change naming from dirtied to dirty for Patch11
 - Use total_length to pass parameter to save/load function instead of macro for Patch12
 - Refactor timeout logic for Patch09
 - Change migration_enabled from bool into u8:1 type for Patch04
 - Fix 80 max line length limit issue and compilation warning 
 - Add r-b from Igor to all the patches of v4
 - Fix incorrect type in assignment of __le16/32 for Patch06
 - Change product name to from E800 to E810

v3: https://lore.kernel.org/intel-wired-lan/20230918062546.40419-1-yahui.cao@intel.com/
 - Add P2P support in vfio driver (Jason)
 - Remove source/destination check in vfio driver (Jason)
 - Restructure PF exported API with proper types and layering (Jason)
 - Change patchset email sender.
 - Reword commit message and comments to be more reviewer-friendly (Kevin)
 - Add s-o-b for Patch01 (Kevin)
 - Merge Patch08 into Patch04 and merge Patch13 into Patch06 (Kevin)
 - Remove uninit() in VF destroy stage for Patch 05 (Kevin)
 - change migration_active to migration_enabled (Kevin)
 - Add total_size in devstate to greatly simplify the various checks for
   Patch07 (Kevin)
 - Add magic and version in device state for Patch07 (Kevin)
 - Fix rx head init issue in Patch10 (Kevin)
 - Remove DMA access for Guest Memory at device resume stage and deprecate
   the approach to restore TX head in VF space, instead restore TX head in
   PF space and then switch context back to VF space which is transparent
   to Guest for Patch11 (Jason, Kevin)
 - Use non-interrupt mode instead of VF MSIX vector to restore TX head for
   Patch11 (Kevin)
 - Move VF pci mmio save/restore from vfio driver into PF driver
 - Add configuration match check at device resume stage (Kevin)
 - Remove sleep before stopping queue at device suspend stage (Kevin)
 - Let PF respond failure to VF if virtual channel messages logging failed (Kevin)
 - Add migration setup and description in cover letter

v2: https://lore.kernel.org/intel-wired-lan/20230621091112.44945-1-lingyu.liu@intel.com/
 - clarified comments and commit message

v1: https://lore.kernel.org/intel-wired-lan/20230620100001.5331-1-lingyu.liu@intel.com/

---


Lingyu Liu (9):
  ice: Introduce VF state ICE_VF_STATE_REPLAYING_VC for migration
  ice: Add fundamental migration init and exit function
  ice: Log virtual channel messages in PF
  ice: Add device state save/load function for migration
  ice: Fix VSI id in virtual channel message for migration
  ice: Save and load RX Queue head
  ice: Save and load TX Queue head
  ice: Add device suspend function for migration
  vfio/ice: Implement vfio_pci driver for E800 devices

Yahui Cao (3):
  ice: Add function to get RX queue context
  ice: Add function to get and set TX queue context
  ice: Save and load mmio registers

 MAINTAINERS                                   |    7 +
 drivers/net/ethernet/intel/ice/Makefile       |    1 +
 drivers/net/ethernet/intel/ice/ice.h          |    3 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  484 +++++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   11 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   23 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |    3 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   15 +
 .../net/ethernet/intel/ice/ice_migration.c    | 1378 +++++++++++++++++
 .../intel/ice/ice_migration_private.h         |   49 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |    4 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   11 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  256 ++-
 drivers/net/ethernet/intel/ice/ice_virtchnl.h |   15 +-
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    |   28 +-
 drivers/vfio/pci/Kconfig                      |    2 +
 drivers/vfio/pci/Makefile                     |    2 +
 drivers/vfio/pci/ice/Kconfig                  |   10 +
 drivers/vfio/pci/ice/Makefile                 |    4 +
 drivers/vfio/pci/ice/ice_vfio_pci.c           |  707 +++++++++
 include/linux/net/intel/ice_migration.h       |   48 +
 21 files changed, 2962 insertions(+), 99 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_migration.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_migration_private.h
 create mode 100644 drivers/vfio/pci/ice/Kconfig
 create mode 100644 drivers/vfio/pci/ice/Makefile
 create mode 100644 drivers/vfio/pci/ice/ice_vfio_pci.c
 create mode 100644 include/linux/net/intel/ice_migration.h

-- 
2.34.1


