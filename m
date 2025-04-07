Return-Path: <kvm+bounces-42809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E67CCA7D6EC
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A34E83BF0B7
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86881227B8C;
	Mon,  7 Apr 2025 07:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oEzuUO8N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C809225791
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012226; cv=none; b=gJ/8Jy2hJW9a0w0eP4+EAlPEw5/lttRU1JOk6DPF1YaPUCsXxMvfbTNN+nIKH4fv+aFufRpNBoHWHyS9E02zZVfmvMgXN8o2BwkGkGiveCn9lNCeC8limywLwASdhNnz/O82zEOEuv9BD08D+hV5fP4EaiKcDtzzgIwZLNe5VoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012226; c=relaxed/simple;
	bh=sVUIY4fIKGHtOSqBXZ7Rk7z5KaG5cmAGeldWUKYdfBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDMkBR6+ICiZWIBuenD+gPdCC+bn9AgAqLC3vRK+f5cd3h7jaLDK4ClAoSL4WEDJ2U9w1RuyFY5iHQrY2w0cRkSwHbO+MUUzVzC43eXvlUnriyK5odeFRle4fIseBF6dpoX0SkTvqWGbnEzJ12ws9Pi2P0urhr6gYQIStKhCXGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oEzuUO8N; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744012225; x=1775548225;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sVUIY4fIKGHtOSqBXZ7Rk7z5KaG5cmAGeldWUKYdfBY=;
  b=oEzuUO8Nyvc2sXJcRvttiQYHnG+1yyIMcz2WgikNZ7VfZsYaKDrPwRah
   mpo99hK2rYC6D3wiy/ZWl7ZniAJqSwucVDovdeA9HJganb2ZvUTYMQTlR
   8TrXaf5TXE6GDTzmOn9jN1JeH+ewA3/EXY8LtB926XKzPgKArYSwCaenR
   ftIH+TwejUxp6MNwGt52/GHKQxt6nMnQIS0VV0uUrdqne1xFX6X5tvDHx
   9LaKoufUZ7E/VaGU1vr8NTACsdqlr8yuwIBXOWrLLn8z5GLKcdo9kzJxo
   lZnZmSc6t/cJNsGAv6EMsgP/lh53YNP6VZm6VszI+yUCEJI/2DEfGzCbQ
   g==;
X-CSE-ConnectionGUID: 1Mbz6CRIS7mU/jsGsKjW0g==
X-CSE-MsgGUID: wGZZbgltRkWMTAwS898Elw==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="67857585"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="67857585"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:25 -0700
X-CSE-ConnectionGUID: zVXf4v0QRxeKIUoz8K2CEQ==
X-CSE-MsgGUID: 62JTDrV0Rx+lOH8R1pgAqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128405674"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:22 -0700
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
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v4 10/13] memory: Change NotifyStateClear() definition to return the result
Date: Mon,  7 Apr 2025 15:49:30 +0800
Message-ID: <20250407074939.18657-11-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250407074939.18657-1-chenyi.qiang@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

So that the caller can check the result of NotifyStateClear() handler if
the operation fails.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v4:
    - Newly added.
---
 hw/vfio/common.c      | 18 ++++++++++--------
 include/exec/memory.h |  4 ++--
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 48468a12c3..6e49ae597d 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -335,8 +335,8 @@ out:
     rcu_read_unlock();
 }
 
-static void vfio_state_change_notify_to_state_clear(VFIOContainerBase *bcontainer,
-                                                    MemoryRegionSection *section)
+static int vfio_state_change_notify_to_state_clear(VFIOContainerBase *bcontainer,
+                                                   MemoryRegionSection *section)
 {
     const hwaddr size = int128_get64(section->size);
     const hwaddr iova = section->offset_within_address_space;
@@ -348,24 +348,26 @@ static void vfio_state_change_notify_to_state_clear(VFIOContainerBase *bcontaine
         error_report("%s: vfio_container_dma_unmap() failed: %s", __func__,
                      strerror(-ret));
     }
+
+    return ret;
 }
 
-static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
-                                            MemoryRegionSection *section)
+static int vfio_ram_discard_notify_discard(StateChangeListener *scl,
+                                           MemoryRegionSection *section)
 {
     RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
     VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
                                                 listener);
-    vfio_state_change_notify_to_state_clear(vrdl->bcontainer, section);
+    return vfio_state_change_notify_to_state_clear(vrdl->bcontainer, section);
 }
 
-static void vfio_private_shared_notify_to_private(StateChangeListener *scl,
-                                                  MemoryRegionSection *section)
+static int vfio_private_shared_notify_to_private(StateChangeListener *scl,
+                                                 MemoryRegionSection *section)
 {
     PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
     VFIOPrivateSharedListener *vpsl = container_of(psl, VFIOPrivateSharedListener,
                                                    listener);
-    vfio_state_change_notify_to_state_clear(vpsl->bcontainer, section);
+    return vfio_state_change_notify_to_state_clear(vpsl->bcontainer, section);
 }
 
 static int vfio_state_change_notify_to_state_set(VFIOContainerBase *bcontainer,
diff --git a/include/exec/memory.h b/include/exec/memory.h
index a61896251c..9472d9e9b4 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -523,8 +523,8 @@ typedef int (*ReplayStateChange)(MemoryRegionSection *section, void *opaque);
 typedef struct StateChangeListener StateChangeListener;
 typedef int (*NotifyStateSet)(StateChangeListener *scl,
                               MemoryRegionSection *section);
-typedef void (*NotifyStateClear)(StateChangeListener *scl,
-                                 MemoryRegionSection *section);
+typedef int (*NotifyStateClear)(StateChangeListener *scl,
+                                MemoryRegionSection *section);
 
 struct StateChangeListener {
     /*
-- 
2.43.5


