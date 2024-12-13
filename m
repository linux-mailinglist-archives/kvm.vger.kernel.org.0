Return-Path: <kvm+bounces-33694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D019F0532
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:09:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77C6B282252
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 07:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D56418F2F8;
	Fri, 13 Dec 2024 07:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g0EvWFj7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F060218FDB2
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 07:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734073770; cv=none; b=gFoWIZ8Nlbcay1wlyUqB4CscXAr2UuM3i2gDO3T+V29XFyqnT8956yQEgJVtsb1Y3sOJB0bS8yj8c67gAwIgziB9ul8rVKtSP3qkFerW13MKdg29415Mg9reYZLFxybj+ruQ8do2PVYVy07d3O17qcUemix61mjba0cY3b0OPSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734073770; c=relaxed/simple;
	bh=vCYpc1Vq5+niHLJ2a/1T5SIiwGkK2cfUHuX+/Tv813o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQ+6akhQbfhiWvcTE8HftlZTPQNq7Y20drim/PAB9Hr4qdMvY/KHNkXuUv9pK5HLsW6wvadFW2JIdGyXml1o6ciDsF7waaNNnAuT9Pphyrr82KCVqxqycD5Xi4Mg50JxiW+BGHYVOezxFmQ2v9mnQUDTRhjJycx0YaKSa0KFfJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g0EvWFj7; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734073769; x=1765609769;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vCYpc1Vq5+niHLJ2a/1T5SIiwGkK2cfUHuX+/Tv813o=;
  b=g0EvWFj7BUgGvlgeiPOxFr/XPShO8MGMiqSz061LtdAfee2+6On27uDS
   hMOtM9MdQsfEA3ifXaiYVR0XJyz4hXMHwihyBErVEt5SFMnVTtnW+EJOL
   Xa430H4zBbFOUdv/sulpqcAcfzRRsGDqzASl5tMQCcel+JW6Wrw2rfWT+
   3tL7NimRJiIGiEP8hePpx0ljyOBcoU94tsrrotEl1ZnQscb6VN3ARf/Fv
   kyzPVD1/2PLH/rmSTnttYTgzGC7j8NcY4ee5qlUG26PAFoF3o/7NKIsu8
   mH8o8mIbdKR2v6Pz8/oTpBdIv6DlJkMvcLY65Eb5fQkRpFab60IpPMOnk
   A==;
X-CSE-ConnectionGUID: 2aDDxuxURnum7lT9tXO4/Q==
X-CSE-MsgGUID: 4gWqIqgbStysNeIPO0PBHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="51937088"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="51937088"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:29 -0800
X-CSE-ConnectionGUID: PkxAlT9xTnSNCm03DXVOsw==
X-CSE-MsgGUID: Z1jMnQXCQzuVd9eD3SkzhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="96365565"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:26 -0800
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [PATCH 4/7] KVM: Notify the state change event during shared/private conversion
Date: Fri, 13 Dec 2024 15:08:46 +0800
Message-ID: <20241213070852.106092-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241213070852.106092-1-chenyi.qiang@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a helper to trigger the state_change() callback of the class.
Once exit to userspace to convert the page from private to shared or
vice versa at runtime, notify the event via the helper so that other
registered subsystems like VFIO can be notified.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 accel/kvm/kvm-all.c                  |  4 ++++
 include/sysemu/guest-memfd-manager.h | 15 +++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 52425af534..38f41a98a5 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -48,6 +48,7 @@
 #include "kvm-cpus.h"
 #include "sysemu/dirtylimit.h"
 #include "qemu/range.h"
+#include "sysemu/guest-memfd-manager.h"
 
 #include "hw/boards.h"
 #include "sysemu/stats.h"
@@ -3080,6 +3081,9 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
     rb = qemu_ram_block_from_host(addr, false, &offset);
 
+    guest_memfd_manager_state_change(GUEST_MEMFD_MANAGER(mr->rdm), offset,
+                                     size, to_private);
+
     if (to_private) {
         if (rb->page_size != qemu_real_host_page_size()) {
             /*
diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/guest-memfd-manager.h
index f4b175529b..9dc4e0346d 100644
--- a/include/sysemu/guest-memfd-manager.h
+++ b/include/sysemu/guest-memfd-manager.h
@@ -46,4 +46,19 @@ struct GuestMemfdManagerClass {
                         bool shared_to_private);
 };
 
+static inline int guest_memfd_manager_state_change(GuestMemfdManager *gmm, uint64_t offset,
+                                                   uint64_t size, bool shared_to_private)
+{
+    GuestMemfdManagerClass *klass;
+
+    g_assert(gmm);
+    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
+
+    if (klass->state_change) {
+        return klass->state_change(gmm, offset, size, shared_to_private);
+    }
+
+    return 0;
+}
+
 #endif
-- 
2.43.5


