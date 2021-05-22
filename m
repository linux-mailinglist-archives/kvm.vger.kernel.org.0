Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CB138D283
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhEVAYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:24:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:27120 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231249AbhEVAXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:23:21 -0400
IronPort-SDR: a7SWcpXHx8XgFp3XCAELEXspmXEjkKNZLzmiDELMc7EZjE7ILFDr1jR6muv+TsusbBxDkb57Xf
 xjGdKOV+7/Qw==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="201634436"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="201634436"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:21:11 -0700
IronPort-SDR: QF/V6SSZ5KjbpoMVOKNr3+Vz2atm7msoUr2SSTfKs6IoniD3wJ4wKkOVcO11Wpf6eoE5uEaDJ8
 Lm6WE2bQNDBg==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="476324236"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:21:10 -0700
Subject: [PATCH v6 20/20] vfio: mdev: idxd: setup request interrupt
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:21:10 -0700
Message-ID: <162164287046.261970.257439178688866229.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add request interrupt support for idxd-mdev driver to support requesting
release of device.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/vfio/mdev/idxd/mdev.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index 25d1ac67b0c9..6bf2ec43656c 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -52,6 +52,8 @@ static int idxd_vdcm_get_irq_count(struct vfio_device *vdev, int type)
 {
 	if (type == VFIO_PCI_MSIX_IRQ_INDEX)
 		return VIDXD_MAX_MSIX_VECS;
+	else if (type == VFIO_PCI_REQ_IRQ_INDEX)
+		return 1;
 
 	return 0;
 }
@@ -486,6 +488,12 @@ static int idxd_vdcm_set_irqs(struct vdcm_idxd *vidxd, uint32_t flags,
 			return mdev_set_msix_trigger(mdev, index, start, count, flags, data);
 		}
 		break;
+	case VFIO_PCI_REQ_IRQ_INDEX:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			return vfio_mdev_set_req_trigger(mdev, index, start, count, flags, data);
+		}
+		break;
 	}
 
 	return -ENOTTY;
@@ -678,6 +686,7 @@ static long idxd_vdcm_ioctl(struct vfio_device *vdev, unsigned int cmd, unsigned
 
 		switch (info.index) {
 		case VFIO_PCI_MSIX_IRQ_INDEX:
+		case VFIO_PCI_REQ_IRQ_INDEX:
 			info.flags |= VFIO_IRQ_INFO_NORESIZE;
 			break;
 		default:
@@ -750,6 +759,7 @@ static const struct vfio_device_ops idxd_mdev_ops = {
 	.write = idxd_vdcm_write,
 	.mmap = idxd_vdcm_mmap,
 	.ioctl = idxd_vdcm_ioctl,
+	.request = vfio_mdev_request,
 };
 
 static ssize_t name_show(struct mdev_type *mtype, struct mdev_type_attribute *attr, char *buf)


