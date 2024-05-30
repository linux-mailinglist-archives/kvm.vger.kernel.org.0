Return-Path: <kvm+bounces-18428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ACEC8D4FA7
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 18:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D43E71F2467B
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 16:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E07F21A02;
	Thu, 30 May 2024 16:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="lJwxWxGO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88D620DD2;
	Thu, 30 May 2024 16:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717085585; cv=none; b=BPO2Gfo9tuL+RdzhWYjNZ301MsCZAJDmE8/RNY0LGAFk7HjkopuUzWJH5cddnTYeBG7KkwhPjkTxMhjL4yPIb3UVuwKTpIiQ0r0KjpsOK+Ub0ZVFhFehHeQhLveqGW4sahEH+R/raK5g4LPSsmBCnjooDSzbXMPJwOO26YtT8lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717085585; c=relaxed/simple;
	bh=9IiQGWNiUF7+dAREDCz4G6Tx/dvE6Ah8nqWUgo5hX5U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=egA6dTlbx6YzdVv/EsUAjW235bWEt84PbKThzkf5TYPVDYviLnP/KndK6zFwvQxRVCZDmKfN+ajGMEIQJTWaGTKsyD6XDvL1gbXy3f0yLz+dLU+s4pkeoiBcc/bXUpT3lwYGHl8QOi6r/yrVyzXIn2RI5tmuRKLl+jUpRIYvLhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=lJwxWxGO; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1717085584; x=1748621584;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hNuvAZtuVIi0V3AiB2H74/HiKZYSwDR+SkEuIWPH2Vg=;
  b=lJwxWxGOTL88Rqsg1macOox4f+SJ1/Ps9vWKiuPBabUsLYuZ794+nzvc
   PjgDqmoYEUz6+S2doTp6PkByYUEYgUKediG1heFNXdiLRP2823bDM2ucI
   Swfse6RUaoGIu2xsRujcqdznZTZur8Hk4/I3vGoIyhOVNTaTQgMzPtM7H
   8=;
X-IronPort-AV: E=Sophos;i="6.08,201,1712620800"; 
   d="scan'208";a="729387978"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 16:12:56 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:25690]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.14.23:2525] with esmtp (Farcaster)
 id d04cab1d-b212-4b36-a5e5-f6bd3f0b265f; Thu, 30 May 2024 16:12:54 +0000 (UTC)
X-Farcaster-Flow-ID: d04cab1d-b212-4b36-a5e5-f6bd3f0b265f
Received: from EX19D007EUA003.ant.amazon.com (10.252.50.8) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Thu, 30 May 2024 16:12:54 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D007EUA003.ant.amazon.com (10.252.50.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Thu, 30 May 2024 16:12:54 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com
 (10.13.244.152) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28 via Frontend Transport; Thu, 30 May 2024 16:12:52 +0000
From: Fred Griffoul <fgriffo@amazon.co.uk>
To: <fgriffo@amazon.co.uk>
CC: Alex Williamson <alex.williamson@redhat.com>, Kevin Tian
	<kevin.tian@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, "Eric
 Auger" <eric.auger@redhat.com>, Christian Brauner <brauner@kernel.org>, Ye
 Bin <yebin10@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] vfio/pci: add msi interrupt affinity support
Date: Thu, 30 May 2024 16:12:37 +0000
Message-ID: <20240530161239.73245-1-fgriffo@amazon.co.uk>
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
to specify the affinity of a vfio pci device interrupt.

The affinity argument must be a subset of the process cpuset, otherwise
an error -EPERM is returned.

The vfio_irq_set argument shall be set-up in the following way:

- the 'flags' field have the new flag VFIO_IRQ_SET_DATA_AFFINITY set
as well as VFIO_IRQ_SET_ACTION_TRIGGER.

- the 'start' field is the device interrupt index. Only one interrupt
can be configured per ioctl().

- the variable-length array consists of one or more CPU index
encoded as __u32, the number of entries in the array is specified in the
'count' field.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 52 +++++++++++++++++++++++++++++++
 drivers/vfio/vfio_main.c          | 16 ++++++++--
 include/uapi/linux/vfio.h         | 12 +++++--
 3 files changed, 76 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 8382c5834335..2b672e2164dc 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -19,6 +19,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/cpuset.h>
 
 #include "vfio_pci_priv.h"
 
@@ -675,6 +676,54 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
+static int vfio_pci_set_msi_affinity(struct vfio_pci_core_device *vdev,
+				     unsigned int ctx_index, unsigned int count,
+				     uint32_t *cpus)
+{
+	struct vfio_pci_irq_ctx *ctx;
+	cpumask_var_t allowed_mask;
+	cpumask_var_t irq_mask;
+	unsigned int i;
+	int err = 0;
+
+	ctx = vfio_irq_ctx_get(vdev, ctx_index);
+	if (!ctx)
+		return -EINVAL;
+
+	if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	if (!zalloc_cpumask_var(&irq_mask, GFP_KERNEL)) {
+		err = -ENOMEM;
+		goto finish;
+	}
+
+	cpuset_cpus_allowed(current, allowed_mask);
+
+	for (i = 0; i < count; i++) {
+		if (cpus[i] >= nr_cpumask_bits ||
+		    !cpumask_test_cpu(cpus[i], allowed_mask)) {
+			err = -EPERM;
+			goto finish2;
+		}
+		__cpumask_set_cpu(cpus[i], irq_mask);
+	}
+
+	/* need at least 1 online cpu in the mask */
+	if (!cpumask_intersects(irq_mask, cpu_online_mask)) {
+		err = -EPERM;
+		goto finish2;
+	}
+
+	err = irq_set_affinity(ctx->producer.irq, irq_mask);
+
+finish2:
+	free_cpumask_var(irq_mask);
+finish:
+	free_cpumask_var(allowed_mask);
+	return err;
+}
+
 static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
@@ -691,6 +740,9 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 	if (!(irq_is(vdev, index) || is_irq_none(vdev)))
 		return -EINVAL;
 
+	if (flags & VFIO_IRQ_SET_DATA_AFFINITY)
+		return vfio_pci_set_msi_affinity(vdev, start, count, data);
+
 	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		int32_t *fds = data;
 		int ret;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index e97d796a54fb..5469a6f85822 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1489,7 +1489,6 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
 	minsz = offsetofend(struct vfio_irq_set, count);
 
 	if ((hdr->argsz < minsz) || (hdr->index >= max_irq_type) ||
-	    (hdr->count >= (U32_MAX - hdr->start)) ||
 	    (hdr->flags & ~(VFIO_IRQ_SET_DATA_TYPE_MASK |
 				VFIO_IRQ_SET_ACTION_TYPE_MASK)))
 		return -EINVAL;
@@ -1497,9 +1496,19 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
 	if (data_size)
 		*data_size = 0;
 
-	if (hdr->start >= num_irqs || hdr->start + hdr->count > num_irqs)
+	if (hdr->start >= num_irqs)
 		return -EINVAL;
 
+	/* For DATA_AFFINITY count is the number of cpu index */
+	if (hdr->flags & VFIO_IRQ_SET_DATA_AFFINITY) {
+		if (hdr->count > nr_cpumask_bits)
+			return -EINVAL;
+	} else {
+		if ((hdr->count >= (U32_MAX - hdr->start)) ||
+		    (hdr->start + hdr->count > num_irqs))
+			return -EINVAL;
+	}
+
 	switch (hdr->flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
 	case VFIO_IRQ_SET_DATA_NONE:
 		size = 0;
@@ -1510,6 +1519,9 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
 	case VFIO_IRQ_SET_DATA_EVENTFD:
 		size = sizeof(int32_t);
 		break;
+	case VFIO_IRQ_SET_DATA_AFFINITY:
+		size = sizeof(uint32_t);
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2b68e6cdf190..af9405060401 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -548,7 +548,8 @@ struct vfio_irq_info {
  *
  * Set signaling, masking, and unmasking of interrupts.  Caller provides
  * struct vfio_irq_set with all fields set.  'start' and 'count' indicate
- * the range of subindexes being specified.
+ * the range of subindexes being specified, except for DATA_AFFINITY as
+ * explained below.
  *
  * The DATA flags specify the type of data provided.  If DATA_NONE, the
  * operation performs the specified action immediately on the specified
@@ -580,6 +581,11 @@ struct vfio_irq_info {
  *
  * Note that ACTION_[UN]MASK specify user->kernel signaling (irqfds) while
  * ACTION_TRIGGER specifies kernel->user signaling.
+ *
+ * DATA_AFFINITY specifies the affinity for an interrupt vector. It must be set
+ * with ACTION_TRIGGER in 'flags'. The 'start' field is the device interrupt
+ * vector. The variable-length 'data' is an array of CPU index encoded as __u32,
+ * the number of entries in the array is given by the 'count' field.
  */
 struct vfio_irq_set {
 	__u32	argsz;
@@ -587,6 +593,7 @@ struct vfio_irq_set {
 #define VFIO_IRQ_SET_DATA_NONE		(1 << 0) /* Data not present */
 #define VFIO_IRQ_SET_DATA_BOOL		(1 << 1) /* Data is bool (u8) */
 #define VFIO_IRQ_SET_DATA_EVENTFD	(1 << 2) /* Data is eventfd (s32) */
+#define VFIO_IRQ_SET_DATA_AFFINITY	(1 << 6) /* Data is cpu index (u32) */
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


