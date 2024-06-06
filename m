Return-Path: <kvm+bounces-19017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FED78FF06C
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 17:21:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE6C5285880
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 15:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74FB1991B6;
	Thu,  6 Jun 2024 15:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="Bw/Mls7+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F084196C78;
	Thu,  6 Jun 2024 15:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717686694; cv=none; b=S818T2Q736kGajbLDQYlLXJeBDV9Xt0kXDCDkGXOB4OFxaWTGu5ygS2Kgii5f/Ec2sqDuFevK8G9Jp8bs7+ur7yVoQp5JEykJ59w73TS9PGUQ7w7An42hQpr3uuhesiQfG89U0nfo7PWtyPBKjWc/uzXzpatZJGhDmVf+6YzxsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717686694; c=relaxed/simple;
	bh=oLClCNPMBOwIEqCYHCcIcgTsA5symXpGgSGwK7I1mp4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lli+Z26XWjksqz7xznAFJ5uz5Me329jrkAnCbrzn/WA+OpvO6/arZGts1OAkvTy2qeDSM225U9vB3Zggv6zMpGUUCzsxe4ideRny7232qo5fmBLz5gl7p+AbLZwSw7UpVA2RlWtJ/fDjCDtC8C/1v3W1GoPPDXdkIP75KgejaYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=Bw/Mls7+; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1717686693; x=1749222693;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y7OMGNBU3xf1RKRryYKaOS5GooOxwOsrzKzqesFig8Y=;
  b=Bw/Mls7+Z5+Nq6iqq/Ifqtz/bvSh3hkBX2CatJlOEKRImuyYC3mnHMuZ
   jZzu8gmzH4j5m495zsA7IKPAtYbrFBNZOnaiB3Nr4sEbO9a+MHnNn701/
   QUcu6N3HXdAph6OmBs+N2pyv8d4RhQ8WNyftia/FhmrT7ekqh8VyCmRHS
   A=;
X-IronPort-AV: E=Sophos;i="6.08,219,1712620800"; 
   d="scan'208";a="731106053"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 15:11:26 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.10.100:4098]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.27.80:2525] with esmtp (Farcaster)
 id 6f1f703b-326c-41bc-8642-19683345393b; Thu, 6 Jun 2024 15:11:24 +0000 (UTC)
X-Farcaster-Flow-ID: 6f1f703b-326c-41bc-8642-19683345393b
Received: from EX19D007EUB001.ant.amazon.com (10.252.51.82) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 6 Jun 2024 15:11:24 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D007EUB001.ant.amazon.com (10.252.51.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 6 Jun 2024 15:11:23 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com
 (10.13.244.152) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34 via Frontend Transport; Thu, 6 Jun 2024 15:11:21 +0000
From: Fred Griffoul <fgriffo@amazon.co.uk>
To: <griffoul@gmail.com>
CC: Fred Griffoul <fgriffo@amazon.co.uk>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu
	<yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>, Eric Auger
	<eric.auger@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Christian
 Brauner" <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, "Reinette
 Chatre" <reinette.chatre@intel.com>, Ye Bin <yebin10@huawei.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/2] vfio/pci: add msi interrupt affinity support
Date: Thu, 6 Jun 2024 15:10:13 +0000
Message-ID: <20240606151017.41623-3-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240606151017.41623-1-fgriffo@amazon.co.uk>
References: <20240606151017.41623-1-fgriffo@amazon.co.uk>
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
 drivers/vfio/pci/vfio_pci_core.c  | 26 +++++++++++++++++----
 drivers/vfio/pci/vfio_pci_intrs.c | 39 +++++++++++++++++++++++++++++++
 drivers/vfio/vfio_main.c          | 13 +++++++----
 include/uapi/linux/vfio.h         | 10 +++++++-
 4 files changed, 79 insertions(+), 9 deletions(-)

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
index 8382c5834335..58fc751e75f1 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -19,6 +19,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/cpuset.h>
 
 #include "vfio_pci_priv.h"
 
@@ -675,6 +676,41 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
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
+	if (!cpumask_subset(irq_mask, allowed_mask)) {
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
@@ -691,6 +727,9 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
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


