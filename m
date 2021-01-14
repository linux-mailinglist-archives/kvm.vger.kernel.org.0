Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721362F5614
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbhANBln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:41:43 -0500
Received: from mga05.intel.com ([192.55.52.43]:51491 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727184AbhANBlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 20:41:42 -0500
IronPort-SDR: mH9n4n3hcY8emYU04IYSsu3z9oSu6hiCVzgmjJKqZT+cQUnS4eIITShvvN7cbsvhfm0W8NRKLO
 Vwvo/pr3A3bg==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="263084524"
X-IronPort-AV: E=Sophos;i="5.79,345,1602572400"; 
   d="scan'208";a="263084524"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 17:38:18 -0800
IronPort-SDR: 70ByEuj6ZUTxoobpwmM7DnqLWj+gPglSHAzdk1Zcl51BXOPdoBO9ptYytiJ7aJ9FshTQjUNI11
 332Cn7+I7AeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,345,1602572400"; 
   d="scan'208";a="569582482"
Received: from allen-box.sh.intel.com ([10.239.159.28])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jan 2021 17:38:11 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     tglx@linutronix.de, ashok.raj@intel.com, kevin.tian@intel.com,
        dave.jiang@intel.com, megha.dey@intel.com, dwmw2@infradead.org
Cc:     alex.williamson@redhat.com, bhelgaas@google.com,
        dan.j.williams@intel.com, will@kernel.org, joro@8bytes.org,
        dmaengine@vger.kernel.org, eric.auger@redhat.com,
        jacob.jun.pan@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        kwankhede@nvidia.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        maz@kernel.org, mona.hossain@intel.com, netanelg@mellanox.com,
        parav@mellanox.com, pbonzini@redhat.com, rafael@kernel.org,
        samuel.ortiz@intel.com, sanjay.k.kumar@intel.com,
        shahafs@mellanox.com, tony.luck@intel.com, vkoul@kernel.org,
        yan.y.zhao@linux.intel.com, yi.l.liu@intel.com, leon@kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [RFC PATCH v3 0/2] Add platform check for subdevice irq domain
Date:   Thu, 14 Jan 2021 09:30:01 +0800
Message-Id: <20210114013003.297050-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Learnt from the discussions in this thread:

https://lore.kernel.org/linux-pci/160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com/

The device IMS (Interrupt Message Storage) should not be enabled in any
virtualization environments unless there is a HYPERCALL domain which
makes the changes in the message store monitored by the hypervisor.

As the initial step, we allow the IMS to be enabled only if we are
running on the bare metal. It's easy to enable IMS in the virtualization
environments if above preconditions are met in the future.

This series is only for comments purpose. We will include it in the Intel
IMS implementation later once we reach a consensus.

Change log:
v2->v3:
 - v2:
   https://lore.kernel.org/linux-pci/20210106022749.2769057-1-baolu.lu@linux.intel.com/
 - Add all identified heuristics so far.

v1->v2:
 - v1:
   https://lore.kernel.org/linux-pci/20201210004624.345282-1-baolu.lu@linux.intel.com/
 - Rename probably_on_bare_metal() with on_bare_metal();
 - Some vendors might use the same name for both bare metal and virtual
   environment. Before we add vendor specific code to distinguish
   between them, let's return false in on_bare_metal(). This won't
   introduce any regression. The only impact is that the coming new
   platform msi feature won't be supported until the vendor specific code
   is provided.

Best regards,
baolu

Lu Baolu (2):
  iommu: Add capability IOMMU_CAP_VIOMMU
  platform-msi: Add platform check for subdevice irq domain

 arch/x86/pci/common.c        | 71 ++++++++++++++++++++++++++++++++++++
 drivers/base/platform-msi.c  |  8 ++++
 drivers/iommu/intel/iommu.c  | 20 ++++++++++
 drivers/iommu/virtio-iommu.c |  9 +++++
 include/linux/iommu.h        |  1 +
 include/linux/msi.h          |  1 +
 6 files changed, 110 insertions(+)

-- 
2.25.1

