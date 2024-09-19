Return-Path: <kvm+bounces-27158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 698C997C3F7
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 07:56:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3009E283649
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 05:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF7B73514;
	Thu, 19 Sep 2024 05:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DDr2X3+4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C6D6A039
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 05:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726725356; cv=none; b=Fx7nBp31i+kyXD/HbNo78QzY7XQwLgj59SgNwqzG6iq63UBWi05yT1BXq8Hi4PFNNx6iDX31N5dO2HppKJ4Bis2X/U1ExCfc0D3VqOcKvD2kXrNlF/rhAbAc1FrPtcHlaTtvpubq4sz4rwFTeKiMqbo21U9PqYOOyP/KbWtzeEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726725356; c=relaxed/simple;
	bh=/cMy+TVZMq4kWR7qIMuMwsU4jrTnlPcE1TIfBgg13Sg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rUYKgZBuIjaUlb4wk9VrHv4rVgKdslVgYIQzMBrP88hrjvNeNNC7suNrLEP9Cwn7h79/NOyhhZ5iSTkATpADnDMjbB1lO02tftdROSbv2186zBh9il2lx2DW9s/uYDc3Yk57pE+UNm/p0ekygCZhYJb3pOuymJmNdaiS/2cq530=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DDr2X3+4; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726725356; x=1758261356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/cMy+TVZMq4kWR7qIMuMwsU4jrTnlPcE1TIfBgg13Sg=;
  b=DDr2X3+4+byZfY8xvhQenvrcadP4Q71ZjfJFrRuK1aTR6opG5mvM0Dxr
   zmz85K2xxqr4bqYuytRXB7OwBXpWoz3niXPt0DHhAJ1DiQuFlEEWiXFDk
   Xt1x6nO9fBt9G+STUPCVfwY5ofivv685kJR5BAg8RBl3kNkkjCnkdmbal
   HOM62Uk5Da1bqHeNJkXaJXymLhskA+OeEKQN/6GpnlYdPBHFt0sNObU7L
   +cM+IOmJwZe27muQ7eU4V+LHX6lw34kmHMLqBv9Ex00bG2Csd1GxbNd5y
   cBncFSbPQzMDki89RlxUem4yL9YjeqUkhLuwlMDdt9aE18EvlteT00EXz
   w==;
X-CSE-ConnectionGUID: gUEog2ugRNWJw9L/AU3zQA==
X-CSE-MsgGUID: y2q3NxGTTSyot085tWII2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25813480"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25813480"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 22:55:43 -0700
X-CSE-ConnectionGUID: HLpTBuCBQpubXQuDEb2ZXA==
X-CSE-MsgGUID: hbxUqHsUT/+8D401YpRrJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="69418634"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 18 Sep 2024 22:55:37 -0700
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
Subject: [RFC v2 02/12] qdev: Introduce new device category to cover basic topology device
Date: Thu, 19 Sep 2024 14:11:18 +0800
Message-Id: <20240919061128.769139-3-zhao1.liu@intel.com>
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

Topology devices are used to define CPUs and need to be created and
realized earlier than current qemu_create_cli_devices().

Use this new catogory to identify such special devices, which allows
to create them earlier in subsequent change.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/cpu/cpu-topology.c  | 2 +-
 include/hw/qdev-core.h | 1 +
 system/qdev-monitor.c  | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/hw/cpu/cpu-topology.c b/hw/cpu/cpu-topology.c
index 3e8982ff7e6c..ce3da844a7d8 100644
--- a/hw/cpu/cpu-topology.c
+++ b/hw/cpu/cpu-topology.c
@@ -164,7 +164,7 @@ static void cpu_topo_class_init(ObjectClass *oc, void *data)
     DeviceClass *dc = DEVICE_CLASS(oc);
     CPUTopoClass *tc = CPU_TOPO_CLASS(oc);
 
-    set_bit(DEVICE_CATEGORY_CPU, dc->categories);
+    set_bit(DEVICE_CATEGORY_CPU_DEF, dc->categories);
     dc->realize = cpu_topo_realize;
 
     /*
diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
index 77223b28c788..ddcaa329e3ec 100644
--- a/include/hw/qdev-core.h
+++ b/include/hw/qdev-core.h
@@ -86,6 +86,7 @@ typedef enum DeviceCategory {
     DEVICE_CATEGORY_SOUND,
     DEVICE_CATEGORY_MISC,
     DEVICE_CATEGORY_CPU,
+    DEVICE_CATEGORY_CPU_DEF,
     DEVICE_CATEGORY_WATCHDOG,
     DEVICE_CATEGORY_MAX
 } DeviceCategory;
diff --git a/system/qdev-monitor.c b/system/qdev-monitor.c
index fe120353fedc..07863d4e650a 100644
--- a/system/qdev-monitor.c
+++ b/system/qdev-monitor.c
@@ -179,6 +179,7 @@ static void qdev_print_devinfos(bool show_no_user)
         [DEVICE_CATEGORY_SOUND]   = "Sound",
         [DEVICE_CATEGORY_MISC]    = "Misc",
         [DEVICE_CATEGORY_CPU]     = "CPU",
+        [DEVICE_CATEGORY_CPU_DEF] = "CPU Definition",
         [DEVICE_CATEGORY_WATCHDOG]= "Watchdog",
         [DEVICE_CATEGORY_MAX]     = "Uncategorized",
     };
-- 
2.34.1


