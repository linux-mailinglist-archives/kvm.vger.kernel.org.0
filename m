Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B266643CE2
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 06:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbiLFF6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 00:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbiLFF63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 00:58:29 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075D21ADB1;
        Mon,  5 Dec 2022 21:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670306309; x=1701842309;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nLZI0skm1dszqhAO48j8Bg824jpCNH+WDBB/e0YlLoE=;
  b=IZfljVk5hN8iFC6U5IN3LxsFbyAuRLb+WJ1Lmp84jeBRKHKQAHC6VN5J
   3EhaRRx4n4GWDRHAlee5WD1+N9OslBD+WN7ysrG9l+yrfWwol++Gfw0Oz
   hDeo19hLZhBLkQCCVAmN/KvKRccPBQm2m1/HgwscxDx2mmMleneSndLsn
   LLKuYldDMHWJirAY10jyJlm6YI2qSlc6f6vX6MKgKQc8M9Y07v/d4EGdJ
   IcTL8MrrpLoBpoHrK+Yto82UuRw5vsZXyfRQnyJx0YyHqsezmOc3qulL8
   bpbdYGNTHX2sLYQ8+iYjkMNPtwrGj1UmcXQ4KmdneN6ssX28pLPCAIOu7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="378706577"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="378706577"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 21:58:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="648211171"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="648211171"
Received: from leirao-pc.bj.intel.com ([10.238.156.101])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2022 21:58:23 -0800
From:   Lei Rao <lei.rao@intel.com>
To:     kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, hch@lst.de,
        sagi@grimberg.me, alex.williamson@redhat.com, cohuck@redhat.com,
        jgg@ziepe.ca, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org
Cc:     eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com,
        Lei Rao <lei.rao@intel.com>
Subject: [RFC PATCH 0/5] Add new VFIO PCI driver for NVMe devices
Date:   Tue,  6 Dec 2022 13:58:11 +0800
Message-Id: <20221206055816.292304-1-lei.rao@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some devices, such as Infrastructure Processing Units (IPUs) and Data
Processing Units (DPUs), expose SR-IOV capable NVMe devices to the host.
Its VF devices support live migration via specific NVMe commands issued
through the PF's device's admin queue.

One of the problems is there are no standardized NVMe live migration
commands to make our patches spec compliant, which prevents us from
creating a spec-compliant implementation. So we've created a reference
implantation based on the Vendor-specific command fields of the protocol.
We want these commands to be standardized so that the implementation will
be spec compliant in future versions and use this RFC as a basis for the
same.

More importantly, we provide our work to help the community and start the
discussion, so everyone can participate and benefit from our work in
NVMe Live Migration implementation and help drive on standardization
efforts.

This series implements the specific vfio-pci driver to support live
migration of NVMe devices. Adds a new interface in the general
NVMe driver to receive the VF device's commands submission to the PF
device's admin queue. And also documents the details of NVMe device
live migration commands.

Any feedback and comments are greatly appreciated.

Lei Rao (5):
  nvme-pci: add function nvme_submit_vf_cmd to issue admin commands for
    VF driver.
  nvme-vfio: add new vfio-pci driver for NVMe device
  nvme-vfio: enable the function of VFIO live migration.
  nvme-vfio: check if the hardware supports live migration
  nvme-vfio: Add a document for the NVMe device

 drivers/nvme/host/pci.c        |  18 +
 drivers/vfio/pci/Kconfig       |   2 +
 drivers/vfio/pci/Makefile      |   2 +
 drivers/vfio/pci/nvme/Kconfig  |  10 +
 drivers/vfio/pci/nvme/Makefile |   3 +
 drivers/vfio/pci/nvme/nvme.c   | 636 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/nvme/nvme.h   | 111 ++++++
 drivers/vfio/pci/nvme/nvme.txt | 278 ++++++++++++++
 8 files changed, 1060 insertions(+)
 create mode 100644 drivers/vfio/pci/nvme/Kconfig
 create mode 100644 drivers/vfio/pci/nvme/Makefile
 create mode 100644 drivers/vfio/pci/nvme/nvme.c
 create mode 100644 drivers/vfio/pci/nvme/nvme.h
 create mode 100644 drivers/vfio/pci/nvme/nvme.txt

-- 
2.34.1

