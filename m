Return-Path: <kvm+bounces-27157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13CF497C3F5
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 07:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FE8C1F22191
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 05:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1008378C8D;
	Thu, 19 Sep 2024 05:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iY8yUBdV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A55C17BAF
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 05:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726725339; cv=none; b=kO3SqHBoCWaK1tjalJGgIwuzfbba1+s389wy0/l9ctt0ETbR0S18X66CBoveAL0/6abXYLZyGfiWuiTtqfaIM2uBXBKIUenCJrN7c7tKAuVhIe6vMFKukPOeX3hMXQthfFZ01fGAhnNNRn3DidUql3uWxf+cDVlxGlkehFXXDW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726725339; c=relaxed/simple;
	bh=8vg6cBFZQesBlTuKocwFM3B2ozeoI/WHoRcB8vhHX3k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mCMnvWOmI4SCsSm881a6gQBLifbz1iuEs/B0usef8v2nYU6iatPYKLS3STZweIPxh8MsrLNCHU8/ijHY78HH44oLtsfvsg9WPUZK5BrIQpg6OubPqXnYx8NlI6/SgeAIq8IWI3f7XCzoJWyWJrpRnMQAe3OECKwbh4HHu1ab+XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iY8yUBdV; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726725337; x=1758261337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8vg6cBFZQesBlTuKocwFM3B2ozeoI/WHoRcB8vhHX3k=;
  b=iY8yUBdVVtcOQCAy/0a3LGJ9a4c0/UVh0O9EIRcNqElWlBMGshD+oONg
   XtxJbdNSivGQMp9q3V4pDu5wm8+BNHLeUpnL2Czfx1Gu+Mstunmc6v8Ic
   mEaKXo0RbXtvNOXxskG4h/sjDlS1BiL4/cyNZTtX7glyX3rvfXzkJ9rdQ
   +/sRpOWIGncNjDpATrpFw/igKJyp8B+NyUBAu6wCCKPCSww8bHEOQ6GRJ
   GEN8YpcH6R97KHj7YIYORhleG4cgx8k2JfUz3eLW8eR/CUzz//ug1OQfD
   s/y6totc171NasUE42ORTIPsdwvyO40auoNWnXGhVWKe8LOWghUh54qUA
   Q==;
X-CSE-ConnectionGUID: rFiUZqlIQg+yjs8Pc06wSA==
X-CSE-MsgGUID: GXsJNhQzSRiEJ6DcXsz8SQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25813445"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25813445"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 22:55:37 -0700
X-CSE-ConnectionGUID: bQQEQDoBRhGmcoS6NdtmMA==
X-CSE-MsgGUID: oV7dFcGcTuSTNDb8wim0HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="69418610"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 18 Sep 2024 22:55:31 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 01/12] qdev: Allow qdev_device_add() to add specific category device
Date: Thu, 19 Sep 2024 14:11:17 +0800
Message-Id: <20240919061128.769139-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919061128.769139-1-zhao1.liu@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Topology devices need to be created and realized before board
initialization.

Allow qdev_device_add() to specify category to help create topology
devices early.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/net/virtio-net.c    |  2 +-
 hw/usb/xen-usb.c       |  3 ++-
 include/monitor/qdev.h |  4 ++--
 system/qdev-monitor.c  | 12 ++++++++----
 system/vl.c            |  4 ++--
 5 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index fb84d142ee29..0d92e09e9076 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -935,7 +935,7 @@ static void failover_add_primary(VirtIONet *n, Error **errp)
         return;
     }
 
-    dev = qdev_device_add_from_qdict(n->primary_opts,
+    dev = qdev_device_add_from_qdict(n->primary_opts, NULL,
                                      n->primary_opts_from_json,
                                      &err);
     if (err) {
diff --git a/hw/usb/xen-usb.c b/hw/usb/xen-usb.c
index 13901625c0c8..e4168b1fec7e 100644
--- a/hw/usb/xen-usb.c
+++ b/hw/usb/xen-usb.c
@@ -766,7 +766,8 @@ static void usbback_portid_add(struct usbback_info *usbif, unsigned port,
     qdict_put_str(qdict, "hostport", portname);
     opts = qemu_opts_from_qdict(qemu_find_opts("device"), qdict,
                                 &error_abort);
-    usbif->ports[port - 1].dev = USB_DEVICE(qdev_device_add(opts, &local_err));
+    usbif->ports[port - 1].dev = USB_DEVICE(
+                                     qdev_device_add(opts, NULL, &local_err));
     if (!usbif->ports[port - 1].dev) {
         qobject_unref(qdict);
         xen_pv_printf(&usbif->xendev, 0,
diff --git a/include/monitor/qdev.h b/include/monitor/qdev.h
index 1d57bf657794..f5fd6e6c1ffc 100644
--- a/include/monitor/qdev.h
+++ b/include/monitor/qdev.h
@@ -8,8 +8,8 @@ void hmp_info_qdm(Monitor *mon, const QDict *qdict);
 void qmp_device_add(QDict *qdict, QObject **ret_data, Error **errp);
 
 int qdev_device_help(QemuOpts *opts);
-DeviceState *qdev_device_add(QemuOpts *opts, Error **errp);
-DeviceState *qdev_device_add_from_qdict(const QDict *opts,
+DeviceState *qdev_device_add(QemuOpts *opts, long *category, Error **errp);
+DeviceState *qdev_device_add_from_qdict(const QDict *opts, long *category,
                                         bool from_json, Error **errp);
 
 /**
diff --git a/system/qdev-monitor.c b/system/qdev-monitor.c
index 457dfd05115e..fe120353fedc 100644
--- a/system/qdev-monitor.c
+++ b/system/qdev-monitor.c
@@ -632,7 +632,7 @@ const char *qdev_set_id(DeviceState *dev, char *id, Error **errp)
     return prop->name;
 }
 
-DeviceState *qdev_device_add_from_qdict(const QDict *opts,
+DeviceState *qdev_device_add_from_qdict(const QDict *opts, long *category,
                                         bool from_json, Error **errp)
 {
     ERRP_GUARD();
@@ -655,6 +655,10 @@ DeviceState *qdev_device_add_from_qdict(const QDict *opts,
         return NULL;
     }
 
+    if (category && !test_bit(*category, dc->categories)) {
+        return NULL;
+    }
+
     /* find bus */
     path = qdict_get_try_str(opts, "bus");
     if (path != NULL) {
@@ -767,12 +771,12 @@ err_del_dev:
 }
 
 /* Takes ownership of @opts on success */
-DeviceState *qdev_device_add(QemuOpts *opts, Error **errp)
+DeviceState *qdev_device_add(QemuOpts *opts, long *category, Error **errp)
 {
     QDict *qdict = qemu_opts_to_qdict(opts, NULL);
     DeviceState *ret;
 
-    ret = qdev_device_add_from_qdict(qdict, false, errp);
+    ret = qdev_device_add_from_qdict(qdict, category, false, errp);
     if (ret) {
         qemu_opts_del(opts);
     }
@@ -897,7 +901,7 @@ void qmp_device_add(QDict *qdict, QObject **ret_data, Error **errp)
         qemu_opts_del(opts);
         return;
     }
-    dev = qdev_device_add(opts, errp);
+    dev = qdev_device_add(opts, NULL, errp);
     if (!dev) {
         /*
          * Drain all pending RCU callbacks. This is done because
diff --git a/system/vl.c b/system/vl.c
index 193e7049ccbe..c40364e2f091 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -1212,7 +1212,7 @@ static int device_init_func(void *opaque, QemuOpts *opts, Error **errp)
 {
     DeviceState *dev;
 
-    dev = qdev_device_add(opts, errp);
+    dev = qdev_device_add(opts, NULL, errp);
     if (!dev && *errp) {
         error_report_err(*errp);
         return -1;
@@ -2665,7 +2665,7 @@ static void qemu_create_cli_devices(void)
          * from the start, so call qdev_device_add_from_qdict() directly for
          * now.
          */
-        dev = qdev_device_add_from_qdict(opt->opts, true, &error_fatal);
+        dev = qdev_device_add_from_qdict(opt->opts, NULL, true, &error_fatal);
         object_unref(OBJECT(dev));
         loc_pop(&opt->loc);
     }
-- 
2.34.1


