Return-Path: <kvm+bounces-47109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D33CABD4FC
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:32:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AE293BF4C1
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B82DA26FA7E;
	Tue, 20 May 2025 10:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="io881stp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6662726C3BE
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747736974; cv=none; b=IPTehYO6Xs7c198G06cD4YiZk3Kt5/ZLRibzcy6Nspkpi/oygvZtB9d82pHrpDAl5xymSHFl7DCsspCOsiQ7YVRvcF4PG8GM5I1lEqzZWaSFo0pBXrrrEE31xiCOOHWGsqYve/VnwjPYwMsMU6TLCGpBHsVjFc3WuhpQBXnmn1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747736974; c=relaxed/simple;
	bh=OTa0g2q+m0xONAZ985oRQ8DaRJiUFsfwCwbWIOiPDSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdDIRs1Gg3/M1y18rQ8vodOKByyGBz1FUxc7cCrCFyvsTn3E6hO+cBP63q18hNC4mnPUFVpLc3xpkYFOaGOg4XmIZs6RGviY25xXm8sx5Id1LlLCjdm5mAyBUj0YRTD5snItt24SY3Mmq6WYpxnw8K3TDayx3Zq6wNnsz7iZQgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=io881stp; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747736974; x=1779272974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OTa0g2q+m0xONAZ985oRQ8DaRJiUFsfwCwbWIOiPDSE=;
  b=io881stpj2+Cy1W8gnutmmBl3XYWq4Ato45kSPl68AtVEzeJCFv2zEh5
   kZQHmWcv0idcOOsQ4DOCydbeEr+QrCgPv0YuW5P1xPMmyKzJd+7PESw76
   1OGItSc34l1Lp2lpjBIs8zNhBSTgdKmDNh+KEf9oZ2TQE+96SONknRSoR
   uM23QwVbEWhWhWwNLmLJ5GRIqg5E0WM0wsOB0UZWFboFS/ikcvdzciYUc
   Jko15nRP9GQvuIEXft5y8AHH0WiKOk1nb6+XHlLBaMfR3+u82GTYupKaP
   dVyDY24nccKqa6FQSLy1xrYubvPMV6f+Lo9COrTlOiO4jvRtTR9kdfydo
   A==;
X-CSE-ConnectionGUID: FVY/eN0DQpugsdtAMetl4A==
X-CSE-MsgGUID: L1ZmGaG4RqGYlYJXegtEqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49566680"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49566680"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:34 -0700
X-CSE-ConnectionGUID: j9eFD9hUQnubW4cm6fpS2Q==
X-CSE-MsgGUID: Vyb9SCSARHefsgMJnbyKSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144905299"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:30 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v5 08/10] memory: Change NotifyRamDiscard() definition to return the result
Date: Tue, 20 May 2025 18:28:48 +0800
Message-ID: <20250520102856.132417-9-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250520102856.132417-1-chenyi.qiang@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

So that the caller can check the result of NotifyRamDiscard() handler if
the operation fails.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v5:
    - Revert to use of NotifyRamDiscard()

Changes in v4:
    - Newly added.
---
 hw/vfio/listener.c           | 6 ++++--
 include/system/memory.h      | 4 ++--
 system/ram-block-attribute.c | 3 +--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/hw/vfio/listener.c b/hw/vfio/listener.c
index bfacb3d8d9..06454e0584 100644
--- a/hw/vfio/listener.c
+++ b/hw/vfio/listener.c
@@ -190,8 +190,8 @@ out:
     rcu_read_unlock();
 }
 
-static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
-                                            MemoryRegionSection *section)
+static int vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
+                                           MemoryRegionSection *section)
 {
     VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
                                                 listener);
@@ -206,6 +206,8 @@ static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
         error_report("%s: vfio_container_dma_unmap() failed: %s", __func__,
                      strerror(-ret));
     }
+
+    return ret;
 }
 
 static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
diff --git a/include/system/memory.h b/include/system/memory.h
index 83b28551c4..e5155120d9 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -518,8 +518,8 @@ struct IOMMUMemoryRegionClass {
 typedef struct RamDiscardListener RamDiscardListener;
 typedef int (*NotifyRamPopulate)(RamDiscardListener *rdl,
                                  MemoryRegionSection *section);
-typedef void (*NotifyRamDiscard)(RamDiscardListener *rdl,
-                                 MemoryRegionSection *section);
+typedef int (*NotifyRamDiscard)(RamDiscardListener *rdl,
+                                MemoryRegionSection *section);
 
 struct RamDiscardListener {
     /*
diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
index f12dd4b881..896c3d7543 100644
--- a/system/ram-block-attribute.c
+++ b/system/ram-block-attribute.c
@@ -66,8 +66,7 @@ static int ram_block_attribute_notify_discard_cb(MemoryRegionSection *section,
 {
     RamDiscardListener *rdl = arg;
 
-    rdl->notify_discard(rdl, section);
-    return 0;
+    return rdl->notify_discard(rdl, section);
 }
 
 static int
-- 
2.43.5


