Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0FB7A4127
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 08:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239846AbjIRG2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 02:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239840AbjIRG1w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 02:27:52 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721B3E6;
        Sun, 17 Sep 2023 23:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695018466; x=1726554466;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MSrTiWCIELO8HXPgO6xkqFMTU+MDvG8u2XBd/c8fIxU=;
  b=AvT01o1dlMqHsQpBgEPkGwAsK9gEPARwymeCMkXtpo7pCO3ZMjgrqpfX
   ej/OglJ1zmuqmKFIi7zyhfqM4HesmNB2E/XbKMS5tzMA+p2BVh03ZA3eJ
   tk34S1KN24ikEQTuJrXIh8KMNVfDzQ9xhYg76CPdA+ur+rsIXfsm+tlMX
   KKJB53nj/B5vlcGtlsBjy02bD4bZhPEbFux8sRdEft6FLOZKmXFlxgQ7I
   cYMBaA4UVugl6QJUcZS7IGg5Er14ZLEBxTB+JMgE1QMoT0g1c/yUfxxiY
   vJ0fSROh2mwM6YmERBDUm4atLiSOtrBS8knuZ8RXAvvU2e5xwbIYZfwYM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="378488450"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="378488450"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2023 23:27:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="815893349"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="815893349"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.186])
  by fmsmga004.fm.intel.com with ESMTP; 17 Sep 2023 23:27:40 -0700
From:   Yahui Cao <yahui.cao@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org, lingyu.liu@intel.com,
        kevin.tian@intel.com, madhu.chittim@intel.com,
        sridhar.samudrala@intel.com, alex.williamson@redhat.com,
        jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, brett.creeley@amd.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH iwl-next v3 00/13] Add E800 live migration driver
Date:   Mon, 18 Sep 2023 06:25:33 +0000
Message-Id: <20230918062546.40419-1-yahui.cao@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds vfio live migration support for Intel E810 VF devices
based on the v2 migration protocol definition series discussed here[0].

Steps to test:
1. Bind one or more E810 VF devices to the module ice_vfio_pci.ko
2. Assign the VFs to the virtual machine and enable device live migration
3. Run a workload using IAVF inside the VM, for example, iperf.
4. Migrate the VM from the source node to a destination node.

Thanks,
Yahui
[0] https://lore.kernel.org/kvm/20220224142024.147653-1-yishaih@nvidia.com/

Change log:

v2 --> v3: link [2]
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

[2] https://lore.kernel.org/intel-wired-lan/20230621091112.44945-1-lingyu.liu@intel.com/

v1 --> v2: link [1]
 - clarified comments and commit message

[1] https://lore.kernel.org/intel-wired-lan/20230620100001.5331-1-lingyu.liu@intel.com/

---

Lingyu Liu (9):
  ice: Introduce VF state ICE_VF_STATE_REPLAYING_VC for migration
  ice: Add fundamental migration init and exit function
  ice: Log virtual channel messages in PF
  ice: Add device state save/restore function for migration
  ice: Fix VSI id in virtual channel message for migration
  ice: Save and restore RX Queue head
  ice: Save and restore TX Queue head
  ice: Add device suspend function for migration
  vfio/ice: Implement vfio_pci driver for E800 devices

Xu Ting (1):
  ice: Fix missing legacy 32byte RXDID in the supported bitmap

Yahui Cao (3):
  ice: Add function to get RX queue context
  ice: Add function to get and set TX queue context
  ice: Save and restore mmio registers

 MAINTAINERS                                   |    7 +
 drivers/net/ethernet/intel/ice/Makefile       |    3 +-
 drivers/net/ethernet/intel/ice/ice.h          |    3 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  484 +++++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   11 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   23 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |    3 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   15 +
 .../net/ethernet/intel/ice/ice_migration.c    | 1344 +++++++++++++++++
 .../intel/ice/ice_migration_private.h         |   44 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |    4 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   10 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  267 ++--
 drivers/net/ethernet/intel/ice/ice_virtchnl.h |   15 +-
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    |   28 +-
 drivers/vfio/pci/Kconfig                      |    2 +
 drivers/vfio/pci/Makefile                     |    2 +
 drivers/vfio/pci/ice/Kconfig                  |   10 +
 drivers/vfio/pci/ice/Makefile                 |    4 +
 drivers/vfio/pci/ice/ice_vfio_pci.c           |  707 +++++++++
 include/linux/net/intel/ice_migration.h       |   42 +
 21 files changed, 2916 insertions(+), 112 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_migration.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_migration_private.h
 create mode 100644 drivers/vfio/pci/ice/Kconfig
 create mode 100644 drivers/vfio/pci/ice/Makefile
 create mode 100644 drivers/vfio/pci/ice/ice_vfio_pci.c
 create mode 100644 include/linux/net/intel/ice_migration.h

-- 
2.34.1

