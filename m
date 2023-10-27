Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D450B7D9E68
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345983AbjJ0RBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345941AbjJ0RBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291EF1A1;
        Fri, 27 Oct 2023 10:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426086; x=1729962086;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=15lJMwbf/gDQp6s/rBs3T3D7+FEeslB9BPq+GkkAYEI=;
  b=SmrIIn2A/YLuwEC7+iKRNoPt1gockL23VWzsa0JEu32LmCJoo6x8VW6z
   2iIo61t8btJqvoGqYHzdmGMxHzm1byNFiPhGYgo6PnpGnbyYu/vE8Ka0S
   Z53/PvX2o0b2/hluNnJa8UbWTjG7K03MtQO13ZOyNZ9MMA9rvGtT88OG7
   YIODQwoSQx7Uwsas9sTnzIdMEwoa/g4/5tBWUh/ihowOAPBxmDHWTKeKf
   0Nkbc3QrZf362//nHGPx3vaR/+tPzCpST0RdSfttSVnhPlhZS1gk1QgS+
   dT1WqPEb/D59+k1o7K82MDSU3Ee9EH/AopEoLjwfmxg4jp0j1a3B3sKfW
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611847"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611847"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988149"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988149"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:13 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 03/26] vfio/pci: Use unsigned int instead of unsigned
Date:   Fri, 27 Oct 2023 10:00:35 -0700
Message-Id: <640dad3021715f4585f0c0ccb57224826cc82b68.1698422237.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1698422237.git.reinette.chatre@intel.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

checkpatch.pl warns about usage of bare unsigned.

Change unsigned to unsigned int as a preparatory change
to avoid checkpatch.pl producing several warnings as
the work adding support for backends to VFIO interrupt
management progress.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- Include vfio_msi_set_block() in changes.

Note to maintainers:
After this change checkpatch.pl still has a few complaints
about existing code using int32_t instead of s32. This was
not changed and these warnings remain.

 drivers/vfio/pci/vfio_pci_intrs.c | 42 ++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index b5b1c09bef25..9f4f3ab48f87 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -503,8 +503,9 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
-static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
-			      unsigned count, int32_t *fds, bool msix)
+static int vfio_msi_set_block(struct vfio_pci_core_device *vdev,
+			      unsigned int start, unsigned int count,
+			      int32_t *fds, bool msix)
 {
 	unsigned int i, j;
 	int ret = 0;
@@ -553,8 +554,9 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
  * IOCTL support
  */
 static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
@@ -584,8 +586,8 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
-				  unsigned index, unsigned start,
-				  unsigned count, uint32_t flags, void *data)
+				  unsigned int index, unsigned int start,
+				  unsigned int count, uint32_t flags, void *data)
 {
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
@@ -604,8 +606,9 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
-				     unsigned index, unsigned start,
-				     unsigned count, uint32_t flags, void *data)
+				     unsigned int index, unsigned int start,
+				     unsigned int count, uint32_t flags,
+				     void *data)
 {
 	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_intx_disable(vdev);
@@ -647,8 +650,9 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
@@ -755,8 +759,9 @@ static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
 }
 
 static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (!pci_is_pcie(vdev->pdev))
 		return -ENOTTY;
@@ -769,8 +774,9 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (index != VFIO_PCI_REQ_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
@@ -780,11 +786,11 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
 }
 
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
-			    unsigned index, unsigned start, unsigned count,
-			    void *data)
+			    unsigned int index, unsigned int start,
+			    unsigned int count, void *data)
 {
-	int (*func)(struct vfio_pci_core_device *vdev, unsigned index,
-		    unsigned start, unsigned count, uint32_t flags,
+	int (*func)(struct vfio_pci_core_device *vdev, unsigned int index,
+		    unsigned int start, unsigned int count, uint32_t flags,
 		    void *data) = NULL;
 
 	switch (index) {
-- 
2.34.1

