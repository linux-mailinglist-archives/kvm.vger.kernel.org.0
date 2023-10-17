Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892A77CB91F
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 05:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbjJQDVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 23:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbjJQDVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 23:21:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588A49F;
        Mon, 16 Oct 2023 20:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697512869; x=1729048869;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=laaAssHt8V3R6F9hNgPsAVESR40dtu6/j3R2Nhzmd3s=;
  b=LsokCLPHq56br8Inw/AMe2M2Iai6F4VcIPTn4HF4LmamTAIqQlMvgqGV
   s3P9uSv+CiPiLAdaWU2EQVlx99zd+ieiDrNuXPHmjLFvB2tVIsCQ+L2r1
   C3WbEZBNNaS6mnZ/qnbo9d+DURinfYx0vb/sVlJoxLfP526nx0+gQFEX1
   h7STgWUuJb7rYRXLTznyolpf95ZwqIq388mlWGtE9F3jCI/ojAucE1ekm
   599lbKCiMiHrl6lLJ2Pif/EuiM45GF4lKlSWwFNFiTR2L+V9+K1gpkOl8
   CcTpMf7aDpv7WCWPnCR/1Ip9TIPrSedH8OD2LIyBK4fkZ1c+wdRproCYp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="389560769"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="389560769"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 20:21:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826269892"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="826269892"
Received: from sqa-gate.sh.intel.com (HELO spr-2s5.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2023 20:21:05 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Tina Zhang <tina.zhang@intel.com>
Subject: [RFC PATCH 00/12] iommu/vt-d: Remove superfluous IOMMU IOTLB invalidations
Date:   Tue, 17 Oct 2023 11:20:32 +0800
Message-Id: <20231017032045.114868-1-tina.zhang@intel.com>
X-Mailer: git-send-email 2.39.3
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

This series based on "Share sva" patch-set[1], aims to remove superfluous
IOMMU IOTLB invalidations in VT-d driver.

In the current VT-d driver, IOMMU IOTLB invalidation commands and
device-TLB commands are performed per device, which leads to superfluous
IOTLB invalidations. For example, if there are four devices behind a IOMMU
are attached to one sva domain (which could be a common case in
virtualization scenarios where one virtual IOMMU working for all the
virtual devices), four IOTLB invalidation commands and four device-IOTLB
invalidation commands will be issued. However, only one IOTLB invalidation
command and four device-IOTLB invalidation commands are necessary.
Superfluous IOMMU IOTLB invalidations impact run-time performance.

Although the goal could be built straight-forwardly in the current VT-d
driver, some refactoring works are considered necessary before landing the
one solving the problem of redundant IOTLB invalidations:

1) VT-d driver uses different structures to keep attached device info.
For default domain, it uses struct dev_pasids_info and some related fields
of struct dmar_domain. For sva domain, it uses struct intel_svm and
struct intel_svm_dev. The reason of it is because previously the sva
domain is not shared among devices behind different IOMMUs and
therefore dmar_domain and its fields cannot be used globally to keep
all attached device info. After the patch-set[1] gets acceptance, sva
domain is global to the attached devices. Thus, retiring struct
intel_svm/intel_svm_dev is the main refactoring work of this patch-set.

2) Most logic of intel_svm_set_dev_pasid() can be covered by
intel_iommu_set_dev_pasid(). Refactoring both intel_svm_set_dev_pasid()
and intel_iommu_set_dev_pasid() and let the former call the latter for
set_dev_pasid operation to avoid duplicating code.

3) Last but not least, struct mmu_notifier is proposed to iommu_domain.
This is a change to IOMMU core, which helps to centralize info required by
sva to sva domain and therefore can help cleanup the code in IOMMU drivers.

This patchset is on github per-iommu_IOTLB_invalidation branch[2].

[1]: https://lore.kernel.org/linux-iommu/20231017004802.109618-1-tina.zhang@intel.com/
[2]: https://github.com/TinaZhangZW/linux/tree/per-iommu_IOTLB_invalidation

Tina Zhang (12):
  iommu/vt-d: Retire the treatment for revoking PASIDs with pending
    pgfaults
  iommu/vt-d: Remove initialization for dynamically heap-allocated
    rcu_head
  iommu/vt-d: Retire intel_svm_bind_mm()
  iommu/vt-d: Make dev_to_intel_iommu() helper global
  iommu/vt-d: Retire struct intel_svm_dev
  iommu: Add mmu_notifier to sva domain
  iommu/vt-d: Retire struct intel_svm
  iommu/vt-d: Use RCU for dev_pasids list updates in
    set/remove_dev_pasid()
  iommu/vt-d: Refactor intel_iommu_set_dev_pasid()
  iommu/vt-d: Refactor intel_iommu_remove_dev_pasid()
  iommu/vt-d: Use intel_iommu_set_dev_pasid() for sva domain
  iommu/vt-d: Remove superfluous IOMMU IOTLB invalidations

 drivers/iommu/intel/iommu.c |  91 +++++++++----
 drivers/iommu/intel/iommu.h |  30 ++---
 drivers/iommu/intel/svm.c   | 261 ++++++++----------------------------
 include/linux/iommu.h       |   2 +
 4 files changed, 128 insertions(+), 256 deletions(-)

-- 
2.39.3

