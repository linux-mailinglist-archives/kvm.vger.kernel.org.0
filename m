Return-Path: <kvm+bounces-2942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB8457FF1F0
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:33:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 166AAB219B4
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0846451014;
	Thu, 30 Nov 2023 14:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nd87b+Co"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF7B93
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354784; x=1732890784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/4XB1+0XSfZXJW6ggYvVG8+UQ24RT1LIudOfD5YSaJw=;
  b=nd87b+ConG9yKkEy3y3r0pIAQ6enQIYkVPbicZH7YjpCDWLHnWIsg8Yf
   8Ati+jYYFU/X4ZI7UM2Mv1ZG5V1j6Z2fptjTzXfFhoUZTGwEya8DRCFxX
   kSm9K2QTy6qlnLipNkDesV4C/8AMGLTNQdbWZg74yVc9sZpwdVAz+Empz
   BH0kf2Z1SfWiBlYCoCcapTCuyAmxlPwsqKTjYQhQ/iymgbWu1qGONdJ9w
   hV9us2ZY8QWqOFaI7Q+6Qq1XsT/pCjJkurOLdec6RAS/TcfphvjjuMZAi
   kKweD4tembUSJuAzTzdskxG07A0UxHfd5xA+OzSgLUBsAbRPZbVY9ajaW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479531856"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479531856"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:33:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942729971"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942729971"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:32:54 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Alistair Francis <alistair@alistair23.me>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Bin Meng <bin.meng@windriver.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	xen-devel@lists.xenproject.org,
	qemu-arm@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 16/41] PPC/ppc-core: Limit plugged-threads and nr-threads to be equal
Date: Thu, 30 Nov 2023 22:41:38 +0800
Message-Id: <20231130144203.2307629-17-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
References: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

PPC supports CPU hotplug at core granularity, thus ppc-core only accepts
all CPUs in a core are plugged.

Check if plugged_threads and nr_threads are equal when ppc-core
realizes.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/ppc/ppc_core.c         | 18 ++++++++++++++++++
 include/hw/ppc/ppc_core.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/hw/ppc/ppc_core.c b/hw/ppc/ppc_core.c
index 4433b54af506..3857f3150052 100644
--- a/hw/ppc/ppc_core.c
+++ b/hw/ppc/ppc_core.c
@@ -53,20 +53,38 @@ static void powerpc_core_prop_set_core_id(Object *obj, Visitor *v,
     core->core_id = value;
 }
 
+static void powerpc_core_realize(DeviceState *dev, Error **errp)
+{
+    CPUCore *core = CPU_CORE(dev);
+    PowerPCCoreClass *ppc_class = POWERPC_CORE_GET_CLASS(dev);
+
+    if (core->plugged_threads != -1 &&
+        core->nr_threads != core->plugged_threads) {
+        error_setg(errp, "nr_threads and plugged-threads must be equal");
+        return;
+    }
+
+    ppc_class->parent_realize(dev, errp);
+}
+
 static void powerpc_core_class_init(ObjectClass *oc, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(oc);
+    PowerPCCoreClass *ppc_class = POWERPC_CORE_CLASS(oc);
 
     object_class_property_add(oc, "core-id", "int",
                               powerpc_core_prop_get_core_id,
                               powerpc_core_prop_set_core_id,
                               NULL, NULL);
+    device_class_set_parent_realize(dc, powerpc_core_realize,
+                                    &ppc_class->parent_realize);
 }
 
 static const TypeInfo powerpc_core_type_info = {
     .name = TYPE_POWERPC_CORE,
     .parent = TYPE_CPU_CORE,
     .abstract = true,
+    .class_size = sizeof(PowerPCCoreClass),
     .class_init = powerpc_core_class_init,
     .instance_size = sizeof(PowerPCCore),
 };
diff --git a/include/hw/ppc/ppc_core.h b/include/hw/ppc/ppc_core.h
index bcc83e426e3f..1207d220872a 100644
--- a/include/hw/ppc/ppc_core.h
+++ b/include/hw/ppc/ppc_core.h
@@ -34,6 +34,7 @@ struct PowerPCCoreClass {
     CPUCoreClass parent_class;
 
     /*< public >*/
+    DeviceRealize parent_realize;
 };
 
 struct PowerPCCore {
-- 
2.34.1


