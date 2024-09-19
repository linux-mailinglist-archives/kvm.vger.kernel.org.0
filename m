Return-Path: <kvm+bounces-27103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 933D497C281
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20FB42857B0
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3598D1DA5F;
	Thu, 19 Sep 2024 01:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KFFHvW50"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A627E1CFB9
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726709993; cv=none; b=hpWykxrtPkuxBcYz3KSz2iCAZsSSZNwbZCAoxwDRGT1g4rMX2UMUg2I55iRyOggO4xafLWJm0UiPHF4PS/Uh3cZsxwmWCacJPRIPWk38QPrGFJ7YEEiO30s1Zn/gxbUP9Uo+tT946qYAtIiymk1tjGBqh3Cz8yWlGkWG1D+ynYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726709993; c=relaxed/simple;
	bh=boVKc/SUSgKzZVCNXF6Ki7YN9fmGZ9ZYevKMMyl1qEI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nH5JPheNfZtnFCT9X+RuclDV9Uq6rPVF9oY8BM2jl5SIsZEMtUZ+Y7J+zMIMYdRiCnAy4apkSUNfmB63DNiuLX/9uTKTajUdMeHYZ13t6a5n+u8PC3VYC5y2iwZ0yIqMHDwz15zZagUR9oGaFtqDdDEEJmml3zWwvr9jR6xHjYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KFFHvW50; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726709992; x=1758245992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=boVKc/SUSgKzZVCNXF6Ki7YN9fmGZ9ZYevKMMyl1qEI=;
  b=KFFHvW50ytBPb16grqB0nGxdhp4WmWgsNEzdxW5AXuqJxqnIRa/XCiLY
   04LyGPyyqBEXsoCIKwYhYpcJEIzo+Lv9oFb0uHmMHjXaJVDv1OzvKJi0g
   qrVIc+eb2YnjWfMYgkk9N/W9lzdtaZnefs3I742EsCOa4IbAvqbk33Bb4
   29OzQpe1WAzX00PvaMEtbSAmaY7WANCCG0bdKmSlkN3CDOETsQAnelngZ
   Rn+hzkhDZxEz+9jDAoWpv49LUZWalQD8yOjqyXovFN8gerG3GFwqM9cFR
   9KufRXoHRLtbnO4uPIo+UXfFd3/Dm81+Po1+axY9O2cpuTs6yOyyOgeUQ
   Q==;
X-CSE-ConnectionGUID: eaRxGHlcRjm8sD3NKBs9KQ==
X-CSE-MsgGUID: C5UmaiutTKqVH9rkj0euTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25797809"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25797809"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:39:51 -0700
X-CSE-ConnectionGUID: j2QDLduuRda1guYfMEBzhA==
X-CSE-MsgGUID: g9MJhIXaQNWqXtJKo1PT6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70058475"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:39:45 -0700
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
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 01/15] qdev: Add pointer to BusChild in DeviceState
Date: Thu, 19 Sep 2024 09:55:19 +0800
Message-Id: <20240919015533.766754-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919015533.766754-1-zhao1.liu@intel.com>
References: <20240919015533.766754-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The device topology structures based on buses are unidirectional: the
parent device can access the child device through the BusChild within
the bus, but not vice versa.

For the CPU topology tree constructed on the device-bus, it is necessary
for the child device to be able to access the parent device via the
parent bus. To address this, introduce a pointer to the BusChild, named
bus_node.

This pointer also simplifies the logic of bus_remove_child(). Instead of
the parent bus needing to traverse the children list to locate the
corresponding BusChild, it can now directly find it using the bus_node
pointer.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/qdev.c          | 29 ++++++++++++++---------------
 include/hw/qdev-core.h  |  4 ++++
 include/qemu/typedefs.h |  1 +
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/hw/core/qdev.c b/hw/core/qdev.c
index db36f54d914a..4429856eaddd 100644
--- a/hw/core/qdev.c
+++ b/hw/core/qdev.c
@@ -57,25 +57,23 @@ static void bus_free_bus_child(BusChild *kid)
 
 static void bus_remove_child(BusState *bus, DeviceState *child)
 {
-    BusChild *kid;
-
-    QTAILQ_FOREACH(kid, &bus->children, sibling) {
-        if (kid->child == child) {
-            char name[32];
+    BusChild *kid = child->bus_node;
+    char name[32];
 
-            snprintf(name, sizeof(name), "child[%d]", kid->index);
-            QTAILQ_REMOVE_RCU(&bus->children, kid, sibling);
+    if (!kid) {
+        return;
+    }
 
-            bus->num_children--;
+    snprintf(name, sizeof(name), "child[%d]", kid->index);
+    QTAILQ_REMOVE_RCU(&bus->children, kid, sibling);
+    child->bus_node = NULL;
+    bus->num_children--;
 
-            /* This gives back ownership of kid->child back to us.  */
-            object_property_del(OBJECT(bus), name);
+    /* This gives back ownership of kid->child back to us.  */
+    object_property_del(OBJECT(bus), name);
 
-            /* free the bus kid, when it is safe to do so*/
-            call_rcu(kid, bus_free_bus_child, rcu);
-            break;
-        }
-    }
+    /* free the bus kid, when it is safe to do so*/
+    call_rcu(kid, bus_free_bus_child, rcu);
 }
 
 static void bus_add_child(BusState *bus, DeviceState *child)
@@ -86,6 +84,7 @@ static void bus_add_child(BusState *bus, DeviceState *child)
     bus->num_children++;
     kid->index = bus->max_index++;
     kid->child = child;
+    child->bus_node = kid;
     object_ref(OBJECT(kid->child));
 
     QTAILQ_INSERT_HEAD_RCU(&bus->children, kid, sibling);
diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
index aa97c34a4be7..85c7d462dfba 100644
--- a/include/hw/qdev-core.h
+++ b/include/hw/qdev-core.h
@@ -253,6 +253,10 @@ struct DeviceState {
      * @parent_bus: bus this device belongs to
      */
     BusState *parent_bus;
+    /**
+     * @bus_node: bus node inserted in parent bus
+     */
+    BusChild *bus_node;
     /**
      * @gpios: QLIST of named GPIOs the device provides.
      */
diff --git a/include/qemu/typedefs.h b/include/qemu/typedefs.h
index 9d222dc37628..aef41c4e67ce 100644
--- a/include/qemu/typedefs.h
+++ b/include/qemu/typedefs.h
@@ -32,6 +32,7 @@ typedef struct BdrvDirtyBitmapIter BdrvDirtyBitmapIter;
 typedef struct BlockBackend BlockBackend;
 typedef struct BlockBackendRootState BlockBackendRootState;
 typedef struct BlockDriverState BlockDriverState;
+typedef struct BusChild BusChild;
 typedef struct BusClass BusClass;
 typedef struct BusState BusState;
 typedef struct Chardev Chardev;
-- 
2.34.1


