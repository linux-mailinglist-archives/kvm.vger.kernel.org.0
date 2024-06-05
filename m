Return-Path: <kvm+bounces-18921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A76348FD224
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 17:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15FBAB25560
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E63414BFAB;
	Wed,  5 Jun 2024 15:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="og/DBGc9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640352BCF4;
	Wed,  5 Jun 2024 15:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717602947; cv=none; b=i4Hmd0rBGXUojgdPuX9cqa7Mhsi3y8pexgJiPcLKo7Gj6n+p67DcbOr8sdnWbQCgkPwKkiSBjIlP45zSgtJem6Mv3hrGigwiN/Zjp85f56jbTiXdUeUH1KMFXaopY1v6J6bsoBwHcrUhFPtNwv3Yuc3xEBSbtv3rTXrVxq9BL3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717602947; c=relaxed/simple;
	bh=Prf92QImWi6WiL0ZPJd6QMM4kHl3PnOMvYlGOOVuP68=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Wj8c0zfJ5u0/Tg4C7EwITUv5mVf3menttsQ9hslIciLSl9w1ap3BP7PZQpn92kO1rXVG2hjuMA+w5ar6tlhgO1mQ8/Kr2lA7sBj3yje6GGFDhoNdUHgAuWWvlnR7jEq9dYmk7nvP/sQmwidEtB0joTJhfrB9tZD/XLtmwwrlfbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=og/DBGc9; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1717602945; x=1749138945;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7TuQrKr1AVldqNyQPBdFqdFfeQkh+6nIpImVNRNCRW4=;
  b=og/DBGc9EgoSuE5L8pDVOCwjvTVr0CoNaezsV0TOdjFPyUrgiHR74jXO
   esNYdw6ZOnSq+njjIRQQTzGugzrcmpmHfdiN4v7hNvmIKlxTDWC99U2Im
   6blSQqVzaSIfFxlftqZHd50VD8dZZ8wj8H/NJb1HPA0BehHAyxXm6zRvF
   Q=;
X-IronPort-AV: E=Sophos;i="6.08,217,1712620800"; 
   d="scan'208";a="209862056"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2024 15:55:42 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.43.254:5513]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.11.23:2525] with esmtp (Farcaster)
 id 7dbfc11e-7231-4dec-8ab5-18c544c991ef; Wed, 5 Jun 2024 15:55:42 +0000 (UTC)
X-Farcaster-Flow-ID: 7dbfc11e-7231-4dec-8ab5-18c544c991ef
Received: from EX19D007EUA001.ant.amazon.com (10.252.50.133) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 5 Jun 2024 15:55:41 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D007EUA001.ant.amazon.com (10.252.50.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 5 Jun 2024 15:55:40 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com
 (10.13.244.152) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34 via Frontend Transport; Wed, 5 Jun 2024 15:55:39 +0000
From: Fred Griffoul <fgriffo@amazon.co.uk>
To: <fgriffo@amazon.co.uk>
CC: <griffoul@gmail.com>, Alex Williamson <alex.williamson@redhat.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>, Kevin Tian
	<kevin.tian@intel.com>, Eric Auger <eric.auger@redhat.com>, Stefan Hajnoczi
	<stefanha@redhat.com>, Christian Brauner <brauner@kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, Reinette Chatre <reinette.chatre@intel.com>, Ye Bin
	<yebin10@huawei.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] vfio/pci: add msi interrupt affinity support
Date: Wed, 5 Jun 2024 15:55:05 +0000
Message-ID: <20240605155509.53536-1-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The usual way to configure a device interrupt from userland is to write
the /proc/irq/<irq>/smp_affinity or smp_affinity_list files. When using
vfio to implement a device driver or a virtual machine monitor, this may
not be ideal: the process managing the vfio device interrupts may not be
granted root privilege, for security reasons. Thus it cannot directly
control the interrupt affinity and has to rely on an external command.

This patch extends the VFIO_DEVICE_SET_IRQS ioctl() with a new data flag
to specify the affinity of interrupts of a vfio pci device.

The CPU affinity mask argument must be a subset of the process cpuset,
otherwise an error -EPERM is returned.

The vfio_irq_set argument shall be set-up in the following way:

- the 'flags' field have the new flag VFIO_IRQ_SET_DATA_AFFINITY set
as well as VFIO_IRQ_SET_ACTION_TRIGGER.

- the variable-length 'data' field is a cpu_set_t structure, as
for the sched_setaffinity() syscall, the size of which is derived
from 'argsz'.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/vfio/pci/vfio_pci_core.c  | 26 ++++++++++++++++---
 drivers/vfio/pci/vfio_pci_intrs.c | 42 +++++++++++++++++++++++++++++++
 drivers/vfio/vfio_main.c          | 13 +++++++---
 include/uapi/linux/vfio.h         | 10 +++++++-
 4 files changed, 82 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 80cae87fff36..b89df562fb5c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1192,6 +1192,7 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 {
 	unsigned long minsz = offsetofend(struct vfio_irq_set, count);
 	struct vfio_irq_set hdr;
+	cpumask_var_t mask;
 	u8 *data = NULL;
 	int max, ret = 0;
 	size_t data_size = 0;
@@ -1207,9 +1208,21 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 		return ret;

 	if (data_size) {
-		data = memdup_user(&arg->data, data_size);
-		if (IS_ERR(data))
-			return PTR_ERR(data);
+		if (hdr.flags & VFIO_IRQ_SET_DATA_AFFINITY) {
+			if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
+				return -ENOMEM;
+
+			ret = copy_from_user(mask, &arg->data, data_size);
+			if (ret)
+				goto out;
+
+			data = (u8 *)mask;
+
+		} else {
+			data = memdup_user(&arg->data, data_size);
+			if (IS_ERR(data))
+				return PTR_ERR(data);
+		}
 	}

 	mutex_lock(&vdev->igate);
@@ -1218,7 +1231,12 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 				      hdr.count, data);

 	mutex_unlock(&vdev->igate);
-	kfree(data);
+
+out:
+	if (hdr.flags & VFIO_IRQ_SET_DATA_AFFINITY)
+		free_cpumask_var(mask);
+	else
+		kfree(data);

 	return ret;
 }
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 8382c5834335..f42ad116134c 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -19,6 +19,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/cpuset.h>

 #include "vfio_pci_priv.h"

@@ -675,6 +676,44 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 	return 0;
 }

+static int vfio_pci_set_msi_affinity(struct vfio_pci_core_device *vdev,
+				     unsigned int start, unsigned int count,
+				     struct cpumask *irq_mask)
+{
+	struct vfio_pci_irq_ctx *ctx;
+	cpumask_var_t allowed_mask;
+	unsigned int i;
+	int err = 0;
+
+	if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	cpuset_cpus_allowed(current, allowed_mask);
+
+	/* need at least 1 online cpu in the mask */
+	if (!cpumask_subset(irq_mask, allowed_mask) ||
+	    !cpumask_intersects(irq_mask, cpu_online_mask)) {
+		err = -EPERM;
+		goto finish;
+	}
+
+	for (i = start; i < start + count; i++) {
+		ctx = vfio_irq_ctx_get(vdev, i);
+		if (!ctx) {
+			err = -EINVAL;
+			break;
+		}
+
+		err = irq_set_affinity(ctx->producer.irq, irq_mask);
+		if (err)
+			break;
+	}
+
+finish:
+	free_cpumask_var(allowed_mask);
+	return err;
+}
+
 static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
@@ -691,6 +730,9 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 	if (!(irq_is(vdev, index) || is_irq_none(vdev)))
 		return -EINVAL;

+	if (flags & VFIO_IRQ_SET_DATA_AFFINITY)
+		return vfio_pci_set_msi_affinity(vdev, start, count, data);
+
 	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		int32_t *fds = data;
 		int ret;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index e97d796a54fb..e87131d45059 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1505,23 +1505,28 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
 		size = 0;
 		break;
 	case VFIO_IRQ_SET_DATA_BOOL:
-		size = sizeof(uint8_t);
+		size = hdr->count * sizeof(uint8_t);
 		break;
 	case VFIO_IRQ_SET_DATA_EVENTFD:
-		size = sizeof(int32_t);
+		size = hdr->count * sizeof(int32_t);
+		break;
+	case VFIO_IRQ_SET_DATA_AFFINITY:
+		size = hdr->argsz - minsz;
+		if (size > cpumask_size())
+			size = cpumask_size();
 		break;
 	default:
 		return -EINVAL;
 	}

 	if (size) {
-		if (hdr->argsz - minsz < hdr->count * size)
+		if (hdr->argsz - minsz < size)
 			return -EINVAL;

 		if (!data_size)
 			return -EINVAL;

-		*data_size = hdr->count * size;
+		*data_size = size;
 	}

 	return 0;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2b68e6cdf190..5ba2ca223550 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -580,6 +580,12 @@ struct vfio_irq_info {
  *
  * Note that ACTION_[UN]MASK specify user->kernel signaling (irqfds) while
  * ACTION_TRIGGER specifies kernel->user signaling.
+ *
+ * DATA_AFFINITY specifies the affinity for the range of interrupt vectors.
+ * It must be set with ACTION_TRIGGER in 'flags'. The variable-length 'data'
+ * array is a CPU affinity mask 'cpu_set_t' structure, as for the
+ * sched_setaffinity() syscall argument: the 'argsz' field is used to check
+ * the actual cpu_set_t size.
  */
 struct vfio_irq_set {
 	__u32	argsz;
@@ -587,6 +593,7 @@ struct vfio_irq_set {
 #define VFIO_IRQ_SET_DATA_NONE		(1 << 0) /* Data not present */
 #define VFIO_IRQ_SET_DATA_BOOL		(1 << 1) /* Data is bool (u8) */
 #define VFIO_IRQ_SET_DATA_EVENTFD	(1 << 2) /* Data is eventfd (s32) */
+#define VFIO_IRQ_SET_DATA_AFFINITY	(1 << 6) /* Data is cpu_set_t */
 #define VFIO_IRQ_SET_ACTION_MASK	(1 << 3) /* Mask interrupt */
 #define VFIO_IRQ_SET_ACTION_UNMASK	(1 << 4) /* Unmask interrupt */
 #define VFIO_IRQ_SET_ACTION_TRIGGER	(1 << 5) /* Trigger interrupt */
@@ -599,7 +606,8 @@ struct vfio_irq_set {

 #define VFIO_IRQ_SET_DATA_TYPE_MASK	(VFIO_IRQ_SET_DATA_NONE | \
 					 VFIO_IRQ_SET_DATA_BOOL | \
-					 VFIO_IRQ_SET_DATA_EVENTFD)
+					 VFIO_IRQ_SET_DATA_EVENTFD | \
+					 VFIO_IRQ_SET_DATA_AFFINITY)
 #define VFIO_IRQ_SET_ACTION_TYPE_MASK	(VFIO_IRQ_SET_ACTION_MASK | \
 					 VFIO_IRQ_SET_ACTION_UNMASK | \
 					 VFIO_IRQ_SET_ACTION_TRIGGER)
--
2.40.1


