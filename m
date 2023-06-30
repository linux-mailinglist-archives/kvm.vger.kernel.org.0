Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C582743C7E
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 15:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjF3NSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 09:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjF3NSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 09:18:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C953A98;
        Fri, 30 Jun 2023 06:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688131092; x=1719667092;
  h=from:to:cc:subject:date:message-id;
  bh=VRlBJLiB4U/74PyzMs/6rCRVEPNOQAypBG90vq7D2EQ=;
  b=FOqCfLaIMQCKycVzik2a4oGr70hkBOCuuBc+wjl1cgIuJuVykjNAbmbW
   eyOFofSodIeePZ7Sij/NfaGnJ14p75SDPyg9cf2fGUAX66W89Nirp50+P
   vhV/BwaOTclwGib3xrQALNIYkl/+Jav/G9lJvIuBglAHGGTjKzrgC1knD
   taJzIdX8W55dWnsBrbz9xbmejSsPAVr52+Njfl6P7JdVDTo1i4NoaCGG0
   WadRMQPTPpGQa3hFbzQd7EDbwTfKg7X6ZzpRhSg+9ehqRLkp5NOhWTBpg
   dHn6B+6IGFtNFovfkCsktsoPrnQHHjwNRHHjPAKTU9/wa8DeUQas0aeRe
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="362433120"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="362433120"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 06:18:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="783077903"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="783077903"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jun 2023 06:18:07 -0700
From:   Xin Zeng <xin.zeng@intel.com>
To:     linux-crypto@vger.kernel.org, kvm@vger.kernel.org
Cc:     giovanni.cabiddu@intel.com, andriy.shevchenko@linux.intel.com,
        Xin Zeng <xin.zeng@intel.com>
Subject: [RFC 0/5] crypto: qat - enable SRIOV VF live migration
Date:   Fri, 30 Jun 2023 21:12:59 +0800
Message-Id: <20230630131304.64243-1-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This set enables live migration for Intel QAT GEN4 SRIOV Virtual
Functions (VFs). It is composed of 5 patches.
The first is a pre-requisite. It adds logic to the QAT PF driver that
allows to save and restore the state of a bank (a virtual function is a
wrapper around a bank) and drain a ring pair. The second patch adds to
the QAT PF driver a set of interfaces to allow to save and restore the
state of a VF that will be called by the modules qat_vfio_pci which will
be introduced in the last patch. The third adds HZ_PER_GHZ which will be
required by the fourth one. The fourth one implements the defined
interfaces. The last one adds a vfio pci extension specific for QAT
which intercepts the vfio device operations for a QAT VF to allow live
migration.

Here are the steps required to test the live migration of a QAT GEN4 VF:
1. Bind one or more QAT GEN4 VF devices to the module qat_vfio_pci.ko 
2. Assign the VFs to the virtual machine and enable device live
migration 
3. Run a workload using a QAT VF inside the VM, for example using qatlib
(https://github.com/intel/qatlib) 
4. Migrate the VM from the source node to a destination node

For P2P states support and AER support, we are going to implement these
in the final version. Any feedback is appreciated!

Andy Shevchenko (1):
  units: Add HZ_PER_GHZ

Siming Wan (1):
  crypto: qat - add bank save/restore and RP drain

Xin Zeng (3):
  crypto: qat - add interface for live migration
  crypto: qat - implement interface for live migration
  vfio/qat: Add vfio_pci driver for Intel QAT VF devices

 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   9 +-
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.h     |   3 +-
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |   2 +-
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |   2 +-
 .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |   2 +-
 .../intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c |   2 +-
 drivers/crypto/intel/qat/qat_common/Makefile  |   4 +-
 .../intel/qat/qat_common/adf_accel_devices.h  |  78 ++-
 .../intel/qat/qat_common/adf_gen2_hw_data.c   |  17 +-
 .../intel/qat/qat_common/adf_gen2_hw_data.h   |  10 +-
 .../intel/qat/qat_common/adf_gen4_hw_data.c   | 415 +++++++++++-
 .../intel/qat/qat_common/adf_gen4_hw_data.h   | 152 ++++-
 .../intel/qat/qat_common/adf_gen4_pfvf.c      |   7 +-
 .../intel/qat/qat_common/adf_gen4_pfvf.h      |   7 +
 .../intel/qat/qat_common/adf_gen4_vf_mig.c    | 609 ++++++++++++++++++
 .../intel/qat/qat_common/adf_mstate_mgr.c     | 267 ++++++++
 .../intel/qat/qat_common/adf_mstate_mgr.h     |  99 +++
 .../intel/qat/qat_common/adf_transport.c      |  11 +-
 .../crypto/intel/qat/qat_common/adf_vf_isr.c  |   2 +-
 .../crypto/intel/qat/qat_common/qat_vf_mig.c  | 106 +++
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |   2 +-
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |   2 +-
 drivers/vfio/pci/Kconfig                      |   2 +
 drivers/vfio/pci/Makefile                     |   1 +
 drivers/vfio/pci/qat/Kconfig                  |  13 +
 drivers/vfio/pci/qat/Makefile                 |   4 +
 drivers/vfio/pci/qat/qat_vfio_pci_main.c      | 518 +++++++++++++++
 include/linux/qat/qat_vf_mig.h                |  15 +
 include/linux/units.h                         |   6 +-
 29 files changed, 2332 insertions(+), 35 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/qat_vf_mig.c
 create mode 100644 drivers/vfio/pci/qat/Kconfig
 create mode 100644 drivers/vfio/pci/qat/Makefile
 create mode 100644 drivers/vfio/pci/qat/qat_vfio_pci_main.c
 create mode 100644 include/linux/qat/qat_vf_mig.h

-- 
2.18.2

