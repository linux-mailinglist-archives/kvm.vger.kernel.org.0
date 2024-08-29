Return-Path: <kvm+bounces-25386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D586A964B34
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 18:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E1B228672D
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DF6D1B5EB6;
	Thu, 29 Aug 2024 16:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z/16b3O8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8940F1B3B1D
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 16:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724948010; cv=none; b=QV9gh2O4ZUpsckRJewZtdTOAHV+rdctWQASp3QmlIunGu3DUVIisquKEFxXSO+lL7f5/HwwzQsCSVpXdloJ5LbMxAFFsaidUkso6uEbwQvecL2YnitkYfroEHa5ztxwxTB1bwt2PPoajQXJ8iZw2f34mWhfZ6xNqJ4hpJrtIGiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724948010; c=relaxed/simple;
	bh=0yy5iUoKy2vrtGKhr9hc57BtnHqHx2r4t7m4HfQ00Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOiwknedJkJ0UY5xIjZZVDy9JbPblvCc1SIXCpfshug54SybtDCsG1CmhnPGKwyR207cF+ik1fDUuBKlL7W60+xFnWmq+cTIRH1onQNxWf6b50A3xchMGXv/wnNf/jI/fpCNeY31MzxGEp5QpHk/Yak//lioljq8lrXXg/k5sFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z/16b3O8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724948007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=35i3askJsl1I70Dcy0TfHIaK8iQIge/3kjnUMPnNyR0=;
	b=Z/16b3O8sM2FcMjBxc1X/r3ftuvtXy+5l2RSxotj7cgbtQg+Z20Uf1U3kabfCbX7hjFy/Y
	0CmD4WcnptrWkj78YY8lnGZffYvsFKaRZjxpvzdXuhN7Lnc++yzgc0RUzN569oFJIXXCc6
	pxOz6j7FeWT5tYm9CxUXI5LQCp/FfZU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-lSj4oPAcN3Wh95k1f_pyaQ-1; Thu,
 29 Aug 2024 12:13:21 -0400
X-MC-Unique: lSj4oPAcN3Wh95k1f_pyaQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68DEF19560A2;
	Thu, 29 Aug 2024 16:13:20 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.81])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D80861955BE3;
	Thu, 29 Aug 2024 16:13:15 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	treding@nvidia.com,
	vbhadram@nvidia.com,
	jonathanh@nvidia.com,
	mperttunen@nvidia.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	alex.williamson@redhat.com,
	clg@redhat.com,
	alexandre.torgue@foss.st.com,
	joabreu@synopsys.com
Cc: msalter@redhat.com
Subject: [RFC PATCH 2/5] vfio_platform: reset: Prepare for additional reset ops
Date: Thu, 29 Aug 2024 18:11:06 +0200
Message-ID: <20240829161302.607928-3-eric.auger@redhat.com>
In-Reply-To: <20240829161302.607928-1-eric.auger@redhat.com>
References: <20240829161302.607928-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Reset modules currently offer a single reset function that gets
called on open, close and VFIO_DEVICE_RESET ioctl.

For more complex devices this infrastructure looks too simplistic.
Indeed some resources may be needed from the open() until the close(),
like clocks, resets. A single function does not allow that setup.

So let's encapsulate the current reset function into an ops struct
that will be soon extended with new open and close callbacks.

Existing reset modules are adapted.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 .../platform/reset/vfio_platform_amdxgbe.c    |  7 +++-
 .../reset/vfio_platform_calxedaxgmac.c        |  7 +++-
 drivers/vfio/platform/vfio_platform_common.c  | 36 ++++++++++---------
 drivers/vfio/platform/vfio_platform_private.h | 30 ++++++++++------
 4 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
index abdca900802d..6d1b641480f4 100644
--- a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
+++ b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
@@ -109,7 +109,12 @@ static int vfio_platform_amdxgbe_reset(struct vfio_platform_device *vdev)
 	return 0;
 }
 
-module_vfio_reset_handler("amd,xgbe-seattle-v1a", vfio_platform_amdxgbe_reset);
+static const struct vfio_platform_reset_ops
+vfio_platform_amdxgbe_reset_ops = {
+	.reset = vfio_platform_amdxgbe_reset,
+};
+
+module_vfio_reset_handler("amd,xgbe-seattle-v1a", vfio_platform_amdxgbe_reset_ops);
 
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
index 63cc7f0b2e4a..392a8579f491 100644
--- a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
+++ b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
@@ -66,7 +66,12 @@ static int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
 	return 0;
 }
 
-module_vfio_reset_handler("calxeda,hb-xgmac", vfio_platform_calxedaxgmac_reset);
+static const struct vfio_platform_reset_ops
+vfio_platform_calxedaxgmac_reset_ops = {
+	.reset = vfio_platform_calxedaxgmac_reset,
+};
+
+module_vfio_reset_handler("calxeda,hb-xgmac", vfio_platform_calxedaxgmac_reset_ops);
 
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 6861f977fd5b..3be08e58365b 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -28,23 +28,23 @@
 static LIST_HEAD(reset_list);
 static DEFINE_MUTEX(driver_lock);
 
-static vfio_platform_reset_fn_t vfio_platform_lookup_reset(const char *compat,
-					struct module **module)
+static const struct vfio_platform_reset_ops *
+vfio_platform_lookup_reset(const char *compat, struct module **module)
 {
+	const struct vfio_platform_reset_ops *ops = NULL;
 	struct vfio_platform_reset_node *iter;
-	vfio_platform_reset_fn_t reset_fn = NULL;
 
 	mutex_lock(&driver_lock);
 	list_for_each_entry(iter, &reset_list, link) {
 		if (!strcmp(iter->compat, compat) &&
 			try_module_get(iter->owner)) {
 			*module = iter->owner;
-			reset_fn = iter->of_reset;
+			ops = &iter->ops;
 			break;
 		}
 	}
 	mutex_unlock(&driver_lock);
-	return reset_fn;
+	return ops;
 }
 
 static int vfio_platform_acpi_probe(struct vfio_platform_device *vdev,
@@ -106,7 +106,7 @@ static bool vfio_platform_has_reset(struct vfio_platform_device *vdev)
 	if (VFIO_PLATFORM_IS_ACPI(vdev))
 		return vfio_platform_acpi_has_reset(vdev);
 
-	return vdev->of_reset ? true : false;
+	return vdev->reset_ops ? true : false;
 }
 
 static int vfio_platform_get_reset(struct vfio_platform_device *vdev)
@@ -114,15 +114,15 @@ static int vfio_platform_get_reset(struct vfio_platform_device *vdev)
 	if (VFIO_PLATFORM_IS_ACPI(vdev))
 		return vfio_platform_acpi_has_reset(vdev) ? 0 : -ENOENT;
 
-	vdev->of_reset = vfio_platform_lookup_reset(vdev->compat,
-						    &vdev->reset_module);
-	if (!vdev->of_reset) {
+	vdev->reset_ops = vfio_platform_lookup_reset(vdev->compat,
+						     &vdev->reset_module);
+	if (!vdev->reset_ops) {
 		request_module("vfio-reset:%s", vdev->compat);
-		vdev->of_reset = vfio_platform_lookup_reset(vdev->compat,
-							&vdev->reset_module);
+		vdev->reset_ops = vfio_platform_lookup_reset(vdev->compat,
+							     &vdev->reset_module);
 	}
 
-	return vdev->of_reset ? 0 : -ENOENT;
+	return vdev->reset_ops ? 0 : -ENOENT;
 }
 
 static void vfio_platform_put_reset(struct vfio_platform_device *vdev)
@@ -130,7 +130,7 @@ static void vfio_platform_put_reset(struct vfio_platform_device *vdev)
 	if (VFIO_PLATFORM_IS_ACPI(vdev))
 		return;
 
-	if (vdev->of_reset)
+	if (vdev->reset_ops)
 		module_put(vdev->reset_module);
 }
 
@@ -219,9 +219,9 @@ static int vfio_platform_call_reset(struct vfio_platform_device *vdev,
 	if (VFIO_PLATFORM_IS_ACPI(vdev)) {
 		dev_info(vdev->device, "reset\n");
 		return vfio_platform_acpi_call_reset(vdev, extra_dbg);
-	} else if (vdev->of_reset) {
+	} else if (vdev->reset_ops && vdev->reset_ops->reset) {
 		dev_info(vdev->device, "reset\n");
-		return vdev->of_reset(vdev);
+		return vdev->reset_ops->reset(vdev);
 	}
 
 	dev_warn(vdev->device, "no reset function found!\n");
@@ -686,13 +686,15 @@ void __vfio_platform_register_reset(struct vfio_platform_reset_node *node)
 EXPORT_SYMBOL_GPL(__vfio_platform_register_reset);
 
 void vfio_platform_unregister_reset(const char *compat,
-				    vfio_platform_reset_fn_t fn)
+				    struct vfio_platform_reset_ops ops)
 {
 	struct vfio_platform_reset_node *iter, *temp;
 
 	mutex_lock(&driver_lock);
 	list_for_each_entry_safe(iter, temp, &reset_list, link) {
-		if (!strcmp(iter->compat, compat) && (iter->of_reset == fn)) {
+		if (!strcmp(iter->compat, compat) &&
+		    !memcmp(&iter->ops, &ops,
+			    sizeof(struct vfio_platform_reset_ops))) {
 			list_del(&iter->link);
 			break;
 		}
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 20d67634bc41..90c99d2e70f4 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -65,18 +65,26 @@ struct vfio_platform_device {
 	struct resource*
 		(*get_resource)(struct vfio_platform_device *vdev, int i);
 	int	(*get_irq)(struct vfio_platform_device *vdev, int i);
-	int	(*of_reset)(struct vfio_platform_device *vdev);
 
+	const struct vfio_platform_reset_ops *reset_ops;
 	bool				reset_required;
 };
 
-typedef int (*vfio_platform_reset_fn_t)(struct vfio_platform_device *vdev);
+/**
+ * struct vfio_platform_reset_ops - reset ops
+ *
+ * @reset:	reset function (required)
+ */
+struct vfio_platform_reset_ops {
+	int (*reset)(struct vfio_platform_device *vdev);
+};
+
 
 struct vfio_platform_reset_node {
 	struct list_head link;
 	char *compat;
 	struct module *owner;
-	vfio_platform_reset_fn_t of_reset;
+	struct vfio_platform_reset_ops ops;
 };
 
 int vfio_platform_init_common(struct vfio_platform_device *vdev);
@@ -104,29 +112,29 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 
 void __vfio_platform_register_reset(struct vfio_platform_reset_node *n);
 void vfio_platform_unregister_reset(const char *compat,
-				    vfio_platform_reset_fn_t fn);
+				    struct vfio_platform_reset_ops ops);
 
 struct vfio_platform_region *
 vfio_platform_get_region(struct vfio_platform_device *vdev, const char *name);
 
-#define vfio_platform_register_reset(__compat, __reset)		\
-static struct vfio_platform_reset_node __reset ## _node = {	\
+#define vfio_platform_register_reset(__compat, __ops)		\
+static struct vfio_platform_reset_node __ops ## _node = {	\
 	.owner = THIS_MODULE,					\
 	.compat = __compat,					\
-	.of_reset = __reset,					\
+	.ops = __ops,						\
 };								\
-__vfio_platform_register_reset(&__reset ## _node)
+__vfio_platform_register_reset(&__ops ## _node)
 
-#define module_vfio_reset_handler(compat, reset)		\
+#define module_vfio_reset_handler(compat, ops)			\
 MODULE_ALIAS("vfio-reset:" compat);				\
 static int __init reset ## _module_init(void)			\
 {								\
-	vfio_platform_register_reset(compat, reset);		\
+	vfio_platform_register_reset(compat, ops);		\
 	return 0;						\
 };								\
 static void __exit reset ## _module_exit(void)			\
 {								\
-	vfio_platform_unregister_reset(compat, reset);		\
+	vfio_platform_unregister_reset(compat, ops);		\
 };								\
 module_init(reset ## _module_init);				\
 module_exit(reset ## _module_exit)
-- 
2.41.0


