Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587A814CA8D
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgA2MNj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:13:39 -0500
Received: from mga18.intel.com ([134.134.136.126]:21973 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbgA2MNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:13:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:13:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="222434770"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 29 Jan 2020 04:13:32 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC v1 0/2] vfio/pci: expose device's PASID capability to VMs
Date:   Wed, 29 Jan 2020 04:18:43 -0800
Message-Id: <1580300325-86259-1-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Liu Yi L (2):
  vfio/pci: Expose PCIe PASID capability to guest
  vfio/pci: Emulate PASID/PRI capability for VFs

 drivers/vfio/pci/vfio_pci_config.c | 321 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 318 insertions(+), 3 deletions(-)

-- 
2.7.4

