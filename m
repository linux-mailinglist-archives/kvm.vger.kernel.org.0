Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A7D18E8C2
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 13:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgCVM1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 08:27:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:23953 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbgCVM1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 08:27:33 -0400
IronPort-SDR: 1AiDmzmXy41admJC3WnxMxIS/ZkYMsTrOZMxgVBkmhCwKekNUxOy8ogd0lAiWHolpCPsM6Sg2O
 WdnrTV4vNf7w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 05:27:32 -0700
IronPort-SDR: UGOINlO9ScM6KwkGezIO4BGXLoADUcKXhv4X+IQHXWbULydX4TwDMp3wBEb7uD6gxfXNxwArZm
 ynlNw9EmimTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,292,1580803200"; 
   d="scan'208";a="356846582"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2020 05:27:32 -0700
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, jean-philippe@linaro.org,
        peterx@redhat.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, hao.wu@intel.com
Subject: [PATCH v1 0/2] vfio/pci: expose device's PASID capability to VMs
Date:   Sun, 22 Mar 2020 05:33:12 -0700
Message-Id: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
Intel platforms allows address space sharing between device DMA and
applications. SVA can reduce programming complexity and enhance security.

To enable SVA, device needs to have PASID capability, which is a key
capability for SVA. This patchset exposes the device's PASID capability
to guest instead of hiding it from guest.

The second patch emulates PASID capability for VFs (Virtual Function) since
VFs don't implement such capability per PCIe spec. This patch emulates such
capability and expose to VM if the capability is enabled in PF (Physical
Function).

However, there is an open for PASID emulation. If PF driver disables PASID
capability at runtime, then it may be an issue. e.g. PF should not disable
PASID capability if there is guest using this capability on any VF related
to this PF. To solve it, may need to introduce a generic communication
framework between vfio-pci driver and PF drivers. Please feel free to give
your suggestions on it.

Regards,
Yi Liu

Changelog:
	- RFC v1 -> Patch v1:
	  Add CONFIG_PCI_ATS #ifdef control to avoid compiling error.

Liu Yi L (2):
  vfio/pci: Expose PCIe PASID capability to guest
  vfio/pci: Emulate PASID/PRI capability for VFs

 drivers/vfio/pci/vfio_pci_config.c | 327 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 324 insertions(+), 3 deletions(-)

-- 
2.7.4

