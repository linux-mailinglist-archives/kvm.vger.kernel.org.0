Return-Path: <kvm+bounces-27159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE4F697C3F9
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 07:56:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73E431F21E4A
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 05:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87F4B79B84;
	Thu, 19 Sep 2024 05:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DqARAk3a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B16770E2
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 05:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726725359; cv=none; b=gbSt+yEgCyjoQQR0Cyk2UCTynakLGJCdaHvZXYslkhfB8bdmmlfb+tsd4k0fjAsu9+BgEs8v6Dep293VS0ZjbUH24GumQYdNulczaSChjX7sZNI4zYpweDLZkMLQl25AQJ9D/e9h2XhdTLwZJJB0uHD37NAjhR6wBHi/4VRXK+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726725359; c=relaxed/simple;
	bh=CwVrpvp1WDScgEYLWjHPu+YgDBg0b3NbDgIP9DAGUe8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u/LX8b/FufF94S0SfX2D7HRxxJhIlL++2gn53U6gMpRxoZsSO1TcEBH4NKAnxgopqG80lGfQh9kR8/0G9KqYrTVRYmEu3rMWct4QS/mHcRg/rz/Gha/ab591zOJS30gFCcI87Qj3PzltsD/F21QBnMSpioTCw8sVddyfsAtXv1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DqARAk3a; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726725358; x=1758261358;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CwVrpvp1WDScgEYLWjHPu+YgDBg0b3NbDgIP9DAGUe8=;
  b=DqARAk3a+tebAtLi/0AXsxlEumkDKpfrSwCpJ1miUgReCLL5NRlp/bEJ
   S+111QEl01+nx127jdRG+2aaSNs9E404Zzo3fjRLYyHzH3kVdDHmdNCwV
   p9kfp/QHR/uaKitvpivECUG++RQQuDxBRqAFjsCsgFD3byM3qSc2m+63D
   PRgYA/PibwJ2GlD0tSxjskZtxrlv/GgXtXKp7VhuHXmXmOYR2UUVzYaqO
   gcNYCWJaH3B5LkL0cmnrN+/fowlN6j6viijN8ebb1H0fNPz7suTEfcVPd
   WuLKKUWyuQB0OMgmv1jLitr8yoItiF6ZfjkoLs0v7WiD3d8Q3oN1vSmuX
   w==;
X-CSE-ConnectionGUID: n9BPunHfT2+GPHbswDhamA==
X-CSE-MsgGUID: AzgwMHMdTp6p5ePznh15Dw==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25813513"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25813513"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 22:55:49 -0700
X-CSE-ConnectionGUID: cnG4W7PSTWykvtbW1B+1LQ==
X-CSE-MsgGUID: X7u2e1dAQ1u80SUmmx+ZsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="69418644"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 18 Sep 2024 22:55:43 -0700
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
Subject: [RFC v2 03/12] system/vl: Create CPU topology devices from CLI early
Date: Thu, 19 Sep 2024 14:11:19 +0800
Message-Id: <20240919061128.769139-4-zhao1.liu@intel.com>
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

Custom topology will allow user to build CPU topology from CLI totally,
and this replaces machine's default CPU creation process (*_init_cpus()
in MachineClass.init()).

For the machine's initialization, there may be CPU dependencies in the
remaining initialization after the CPU creation.

To address such dependencies, create the CPU topology device (including
CPU devices) from the CLI earlier, so that the latter part of machine
initialization can be separated after qemu_add_cli_devices_early().

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 system/vl.c | 55 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff --git a/system/vl.c b/system/vl.c
index c40364e2f091..8540454aa1c2 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -1211,8 +1211,9 @@ static int device_help_func(void *opaque, QemuOpts *opts, Error **errp)
 static int device_init_func(void *opaque, QemuOpts *opts, Error **errp)
 {
     DeviceState *dev;
+    long *category = opaque;
 
-    dev = qdev_device_add(opts, NULL, errp);
+    dev = qdev_device_add(opts, category, errp);
     if (!dev && *errp) {
         error_report_err(*errp);
         return -1;
@@ -2623,6 +2624,36 @@ static void qemu_init_displays(void)
     }
 }
 
+static void qemu_add_devices(long *category)
+{
+    DeviceOption *opt;
+
+    qemu_opts_foreach(qemu_find_opts("device"),
+                      device_init_func, category, &error_fatal);
+    QTAILQ_FOREACH(opt, &device_opts, next) {
+        DeviceState *dev;
+        loc_push_restore(&opt->loc);
+        /*
+         * TODO Eventually we should call qmp_device_add() here to make sure it
+         * behaves the same, but QMP still has to accept incorrectly typed
+         * options until libvirt is fixed and we want to be strict on the CLI
+         * from the start, so call qdev_device_add_from_qdict() directly for
+         * now.
+         */
+        dev = qdev_device_add_from_qdict(opt->opts, category,
+                                         true, &error_fatal);
+        object_unref(OBJECT(dev));
+        loc_pop(&opt->loc);
+    }
+}
+
+static void qemu_add_cli_devices_early(void)
+{
+    long category = DEVICE_CATEGORY_CPU_DEF;
+
+    qemu_add_devices(&category);
+}
+
 static void qemu_init_board(void)
 {
     /* process plugin before CPUs are created, but once -smp has been parsed */
@@ -2631,6 +2662,9 @@ static void qemu_init_board(void)
     /* From here on we enter MACHINE_PHASE_INITIALIZED.  */
     machine_run_board_init(current_machine, mem_path, &error_fatal);
 
+    /* Create CPU topology device if any. */
+    qemu_add_cli_devices_early();
+
     drive_check_orphaned();
 
     realtime_init();
@@ -2638,8 +2672,6 @@ static void qemu_init_board(void)
 
 static void qemu_create_cli_devices(void)
 {
-    DeviceOption *opt;
-
     soundhw_init();
 
     qemu_opts_foreach(qemu_find_opts("fw_cfg"),
@@ -2653,22 +2685,7 @@ static void qemu_create_cli_devices(void)
 
     /* init generic devices */
     rom_set_order_override(FW_CFG_ORDER_OVERRIDE_DEVICE);
-    qemu_opts_foreach(qemu_find_opts("device"),
-                      device_init_func, NULL, &error_fatal);
-    QTAILQ_FOREACH(opt, &device_opts, next) {
-        DeviceState *dev;
-        loc_push_restore(&opt->loc);
-        /*
-         * TODO Eventually we should call qmp_device_add() here to make sure it
-         * behaves the same, but QMP still has to accept incorrectly typed
-         * options until libvirt is fixed and we want to be strict on the CLI
-         * from the start, so call qdev_device_add_from_qdict() directly for
-         * now.
-         */
-        dev = qdev_device_add_from_qdict(opt->opts, NULL, true, &error_fatal);
-        object_unref(OBJECT(dev));
-        loc_pop(&opt->loc);
-    }
+    qemu_add_devices(NULL);
     rom_reset_order_override();
 }
 
-- 
2.34.1


