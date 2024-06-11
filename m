Return-Path: <kvm+bounces-19347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2AB79042AB
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 19:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DA3F2837EE
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 17:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D42F85A0E0;
	Tue, 11 Jun 2024 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="eeTgkTSF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6656C1CD2B;
	Tue, 11 Jun 2024 17:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718127946; cv=none; b=bj1QcTXc0dtenLzEOjOJIo2lCpz3bjGMKGIoTyM1J9TEK/mV3130/q7leH9JvHJYvaVRM6EjGmQ8c+abg/DC3RneVh9VZ7qYCQVXEauGCVTMu3DctIuMBYZHD9rMQDTKZS0AJyjnH5ta5KcnRgUpLi2w/23D4e0DWTlw6kwI4cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718127946; c=relaxed/simple;
	bh=TffUeohfdPQLAp43LWsakEtSlD8OSmDCAxIkjWVpEbs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZpsqtkBOO+NZVMgoCTJ2yyd6EkNBNLFdk1DZf/Y5Ptgk2mJzG5SSdNsD8mfNEbK8tixQLDLRjsojQ9K+QJsMwnO7g35oFfglVBAnBh6WzuoYU6n4nqpyLJvtBSJkVTfYB6qNq6/TI3ezz/AfePSCtYMKv3PO9KxQy2XioSZ4V4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=eeTgkTSF; arc=none smtp.client-ip=99.78.197.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1718127944; x=1749663944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CxIP1cX8RbojJf0gUvwYsfGSNOxjOtjKBPayNFENtxw=;
  b=eeTgkTSFHjaAptcChgpZtETTnqCmOtefy+70qL9glHGRAdSNQSXhytHa
   rsVHUDTrOzHLx8vrWRJ3x04YMBMLsawexq/enmtED/8u8rdvhlffNdWUR
   jECB8Eq6WJgVobhfY3TNcOCbcsE/E0eMeYlXuOjFzG6JycKYI0/NDSiW4
   A=;
X-IronPort-AV: E=Sophos;i="6.08,230,1712620800"; 
   d="scan'208";a="301492498"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 17:45:40 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:20292]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.35.119:2525] with esmtp (Farcaster)
 id 704b2958-af5b-40c0-9dea-ba1a9127a023; Tue, 11 Jun 2024 17:45:38 +0000 (UTC)
X-Farcaster-Flow-ID: 704b2958-af5b-40c0-9dea-ba1a9127a023
Received: from EX19D007EUA002.ant.amazon.com (10.252.50.68) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 11 Jun 2024 17:45:38 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D007EUA002.ant.amazon.com (10.252.50.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 11 Jun 2024 17:45:38 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com
 (10.13.244.152) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34 via Frontend Transport; Tue, 11 Jun 2024 17:45:34 +0000
From: Fred Griffoul <fgriffo@amazon.co.uk>
To: <griffoul@gmail.com>
CC: Fred Griffoul <fgriffo@amazon.co.uk>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Waiman Long <longman@redhat.com>, Zefan Li
	<lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier
	<maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Mark Brown
	<broonie@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Joey Gouly
	<joey.gouly@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, Jeremy Linton
	<jeremy.linton@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu
	<yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>, Eric Auger
	<eric.auger@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Christian
 Brauner" <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, "Reinette
 Chatre" <reinette.chatre@intel.com>, Ye Bin <yebin10@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <cgroups@vger.kernel.org>
Subject: [PATCH v6 2/2] vfio/pci: add interrupt affinity support
Date: Tue, 11 Jun 2024 17:44:25 +0000
Message-ID: <20240611174430.90787-3-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240611174430.90787-1-fgriffo@amazon.co.uk>
References: <20240611174430.90787-1-fgriffo@amazon.co.uk>
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

- the 'flags' field have the new flag VFIO_IRQ_SET_DATA_CPUSET set
as well as VFIO_IRQ_SET_ACTION_TRIGGER.

- the variable-length 'data' field is a cpu_set_t structure, as
for the sched_setaffinity() syscall, the size of which is derived
from 'argsz'.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/vfio/pci/vfio_pci_core.c  |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c | 41 +++++++++++++++++++++++++++++++
 drivers/vfio/vfio_main.c          | 15 ++++++++---
 include/uapi/linux/vfio.h         | 15 ++++++++++-
 4 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 80cae87fff36..fbc490703031 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1174,7 +1174,7 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 		return -EINVAL;
 	}
 
-	info.flags = VFIO_IRQ_INFO_EVENTFD;
+	info.flags = VFIO_IRQ_INFO_EVENTFD | VFIO_IRQ_INFO_CPUSET;
 
 	info.count = vfio_pci_get_irq_count(vdev, info.index);
 
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 8382c5834335..b339c42cb1c0 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -19,6 +19,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/cpuset.h>
 
 #include "vfio_pci_priv.h"
 
@@ -82,6 +83,40 @@ vfio_irq_ctx_alloc(struct vfio_pci_core_device *vdev, unsigned long index)
 	return ctx;
 }
 
+static int vfio_pci_set_affinity(struct vfio_pci_core_device *vdev,
+				 unsigned int start, unsigned int count,
+				 struct cpumask *irq_mask)
+{
+	cpumask_var_t allowed_mask;
+	int irq, err = 0;
+	unsigned int i;
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
+		irq = pci_irq_vector(vdev->pdev, i);
+		if (irq < 0) {
+			err = -EINVAL;
+			break;
+		}
+
+		err = irq_set_affinity(irq, irq_mask);
+		if (err)
+			break;
+	}
+
+finish:
+	free_cpumask_var(allowed_mask);
+	return err;
+}
+
 /*
  * INTx
  */
@@ -665,6 +700,9 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 	if (!is_intx(vdev))
 		return -EINVAL;
 
+	if (flags & VFIO_IRQ_SET_DATA_CPUSET)
+		return vfio_pci_set_affinity(vdev, start, count, data);
+
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
 		vfio_send_intx_eventfd(vdev, vfio_irq_ctx_get(vdev, 0));
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
@@ -713,6 +751,9 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 	if (!irq_is(vdev, index))
 		return -EINVAL;
 
+	if (flags & VFIO_IRQ_SET_DATA_CPUSET)
+		return vfio_pci_set_affinity(vdev, start, count, data);
+
 	for (i = start; i < start + count; i++) {
 		ctx = vfio_irq_ctx_get(vdev, i);
 		if (!ctx)
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index e97d796a54fb..2e4f4e37cf89 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1505,23 +1505,30 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
 		size = 0;
 		break;
 	case VFIO_IRQ_SET_DATA_BOOL:
-		size = sizeof(uint8_t);
+		size = size_mul(hdr->count, sizeof(uint8_t));
 		break;
 	case VFIO_IRQ_SET_DATA_EVENTFD:
-		size = sizeof(int32_t);
+		size = size_mul(hdr->count, sizeof(int32_t));
+		break;
+	case VFIO_IRQ_SET_DATA_CPUSET:
+		size = hdr->argsz - minsz;
+		if (size < cpumask_size())
+			return -EINVAL;
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
index 2b68e6cdf190..d2edf6b725f8 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -530,6 +530,10 @@ struct vfio_region_info_cap_nvlink2_lnkspd {
  * Absence of the NORESIZE flag indicates that vectors can be enabled
  * and disabled dynamically without impacting other vectors within the
  * index.
+ *
+ * The CPUSET flag indicates the interrupt index supports setting
+ * its affinity with a cpu_set_t configured with the SET_IRQ
+ * ioctl().
  */
 struct vfio_irq_info {
 	__u32	argsz;
@@ -538,6 +542,7 @@ struct vfio_irq_info {
 #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
 #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
 #define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
+#define VFIO_IRQ_INFO_CPUSET		(1 << 4)
 	__u32	index;		/* IRQ index */
 	__u32	count;		/* Number of IRQs within this index */
 };
@@ -580,6 +585,12 @@ struct vfio_irq_info {
  *
  * Note that ACTION_[UN]MASK specify user->kernel signaling (irqfds) while
  * ACTION_TRIGGER specifies kernel->user signaling.
+ *
+ * DATA_CPUSET specifies the affinity for the range of interrupt vectors.
+ * It must be set with ACTION_TRIGGER in 'flags'. The variable-length 'data'
+ * array is the CPU affinity mask represented as a 'cpu_set_t' structure, as
+ * for the sched_setaffinity() syscall argument: the 'argsz' field is used
+ * to check the actual cpu_set_t size.
  */
 struct vfio_irq_set {
 	__u32	argsz;
@@ -587,6 +598,7 @@ struct vfio_irq_set {
 #define VFIO_IRQ_SET_DATA_NONE		(1 << 0) /* Data not present */
 #define VFIO_IRQ_SET_DATA_BOOL		(1 << 1) /* Data is bool (u8) */
 #define VFIO_IRQ_SET_DATA_EVENTFD	(1 << 2) /* Data is eventfd (s32) */
+#define VFIO_IRQ_SET_DATA_CPUSET	(1 << 6) /* Data is cpu_set_t */
 #define VFIO_IRQ_SET_ACTION_MASK	(1 << 3) /* Mask interrupt */
 #define VFIO_IRQ_SET_ACTION_UNMASK	(1 << 4) /* Unmask interrupt */
 #define VFIO_IRQ_SET_ACTION_TRIGGER	(1 << 5) /* Trigger interrupt */
@@ -599,7 +611,8 @@ struct vfio_irq_set {
 
 #define VFIO_IRQ_SET_DATA_TYPE_MASK	(VFIO_IRQ_SET_DATA_NONE | \
 					 VFIO_IRQ_SET_DATA_BOOL | \
-					 VFIO_IRQ_SET_DATA_EVENTFD)
+					 VFIO_IRQ_SET_DATA_EVENTFD | \
+					 VFIO_IRQ_SET_DATA_CPUSET)
 #define VFIO_IRQ_SET_ACTION_TYPE_MASK	(VFIO_IRQ_SET_ACTION_MASK | \
 					 VFIO_IRQ_SET_ACTION_UNMASK | \
 					 VFIO_IRQ_SET_ACTION_TRIGGER)
-- 
2.40.1


