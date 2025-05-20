Return-Path: <kvm+bounces-47111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7F6ABD522
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:35:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 000B04C2F67
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B6C27AC40;
	Tue, 20 May 2025 10:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b3S5Oxe9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C1225524F
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747736985; cv=none; b=AeOTKMVvQDOw6iqEIWnAx6ZLsIelJMX1/gWH+jnxUZxtO6puc4Lx9q2d3gXF2R4EwLdaemjsa9VtcVmcgoPIBEA6HDikbAfrkOAsxZKP0ctv4xj5YjrqBK95LgwifoPgFILFkcFXplbJ1wWosfrk4lU4NURTGFptT48vRZWhSso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747736985; c=relaxed/simple;
	bh=QVe4ZfDlF+KN1Ku+/Uhd92OOHuL5O75EpmRDC6Ka9Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcGhcagrxrYyMTI0DQkjFHRseTyAHuyz8LAW7MqpJkkAhvIIF13qYxyoShXFG8IPPaq20t+udbvXbP2AWQjjKsRFD0zJ6UgTG3izB/ro/0CiQTO5bJtl/7JshsAPRgbKchNAYFKKttCnu7uRHNeYnAZLOIiTlHqkPZb1MOKf2pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b3S5Oxe9; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747736981; x=1779272981;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QVe4ZfDlF+KN1Ku+/Uhd92OOHuL5O75EpmRDC6Ka9Vw=;
  b=b3S5Oxe9Q0vVoxlWgFXqHZPbAvZD/skSBo3ZXQ7rp/0AnF84S9866TPB
   uRz1jsgusxxUnfAITv6drubkGJrIGNS0qZSoegrHul02Dlk8oS2IfMPSp
   MOpZ7b4Devw943d1C2vEv7l2fy6HjQS8pCdUxWjujdnBjMwYLSYGwX/ch
   Xbx7vzgLFHbCnbuEeI035mgyqQuMixfP3ZJnSvY7OhHTqcBEP15MtAelu
   IuhokjeyjWAhCzNwVlTKVsGUdsSJ2/7WTN2repVofPdhlpOhI4VwkdhXe
   RRgb8wzDggxAUWCfWo2Txx9M0LkCNOr0hyGgNP6o7mLEwZtRphN5P1UcR
   g==;
X-CSE-ConnectionGUID: wIaVwm2mR8KP0bBZEah1JA==
X-CSE-MsgGUID: ZfOkoPU2TsymODDyBkpL+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49566696"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49566696"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:41 -0700
X-CSE-ConnectionGUID: HXt5MnjgSyC7CFljN6GtVg==
X-CSE-MsgGUID: SuPLIgPaTYODvzo/5Z8fdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144905325"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:37 -0700
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
Subject: [PATCH v5 10/10] ram-block-attribute: Add more error handling during state changes
Date: Tue, 20 May 2025 18:28:50 +0800
Message-ID: <20250520102856.132417-11-chenyi.qiang@intel.com>
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

The current error handling is simple with the following assumption:
- QEMU will quit instead of resuming the guest if kvm_convert_memory()
  fails, thus no need to do rollback.
- The convert range is required to be in the desired state. It is not
  allowed to handle the mixture case.
- The conversion from shared to private is a non-failure operation.

This is sufficient for now as complext error handling is not required.
For future extension, add some potential error handling.
- For private to shared conversion, do the rollback operation if
  ram_block_attribute_notify_to_populated() fails.
- For shared to private conversion, still assert it as a non-failure
  operation for now. It could be an easy fail path with in-place
  conversion, which will likely have to retry the conversion until it
  works in the future.
- For mixture case, process individual blocks for ease of rollback.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 system/ram-block-attribute.c | 116 +++++++++++++++++++++++++++--------
 1 file changed, 90 insertions(+), 26 deletions(-)

diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
index 387501b569..0af3396aa4 100644
--- a/system/ram-block-attribute.c
+++ b/system/ram-block-attribute.c
@@ -289,7 +289,12 @@ static int ram_block_attribute_notify_to_discard(RamBlockAttribute *attr,
         }
         ret = rdl->notify_discard(rdl, &tmp);
         if (ret) {
-            break;
+            /*
+             * The current to_private listeners (VFIO dma_unmap and
+             * KVM set_attribute_private) are non-failing operations.
+             * TODO: add rollback operations if it is allowed to fail.
+             */
+            g_assert(ret);
         }
     }
 
@@ -300,7 +305,7 @@ static int
 ram_block_attribute_notify_to_populated(RamBlockAttribute *attr,
                                         uint64_t offset, uint64_t size)
 {
-    RamDiscardListener *rdl;
+    RamDiscardListener *rdl, *rdl2;
     int ret = 0;
 
     QLIST_FOREACH(rdl, &attr->rdl_list, next) {
@@ -315,6 +320,20 @@ ram_block_attribute_notify_to_populated(RamBlockAttribute *attr,
         }
     }
 
+    if (ret) {
+        /* Notify all already-notified listeners. */
+        QLIST_FOREACH(rdl2, &attr->rdl_list, next) {
+            MemoryRegionSection tmp = *rdl2->section;
+
+            if (rdl == rdl2) {
+                break;
+            }
+            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+                continue;
+            }
+            rdl2->notify_discard(rdl2, &tmp);
+        }
+    }
     return ret;
 }
 
@@ -353,6 +372,9 @@ int ram_block_attribute_state_change(RamBlockAttribute *attr, uint64_t offset,
     const int block_size = ram_block_attribute_get_block_size(attr);
     const unsigned long first_bit = offset / block_size;
     const unsigned long nbits = size / block_size;
+    const uint64_t end = offset + size;
+    unsigned long bit;
+    uint64_t cur;
     int ret = 0;
 
     if (!ram_block_attribute_is_valid_range(attr, offset, size)) {
@@ -361,32 +383,74 @@ int ram_block_attribute_state_change(RamBlockAttribute *attr, uint64_t offset,
         return -1;
     }
 
-    /* Already discard/populated */
-    if ((ram_block_attribute_is_range_discard(attr, offset, size) &&
-         to_private) ||
-        (ram_block_attribute_is_range_populated(attr, offset, size) &&
-         !to_private)) {
-        return 0;
-    }
-
-    /* Unexpected mixture */
-    if ((!ram_block_attribute_is_range_populated(attr, offset, size) &&
-         to_private) ||
-        (!ram_block_attribute_is_range_discard(attr, offset, size) &&
-         !to_private)) {
-        error_report("%s, the range is not all in the desired state: "
-                     "(offset 0x%lx, size 0x%lx), %s",
-                     __func__, offset, size,
-                     to_private ? "private" : "shared");
-        return -1;
-    }
-
     if (to_private) {
-        bitmap_clear(attr->bitmap, first_bit, nbits);
-        ret = ram_block_attribute_notify_to_discard(attr, offset, size);
+        if (ram_block_attribute_is_range_discard(attr, offset, size)) {
+            /* Already private */
+        } else if (!ram_block_attribute_is_range_populated(attr, offset,
+                                                           size)) {
+            /* Unexpected mixture: process individual blocks */
+            for (cur = offset; cur < end; cur += block_size) {
+                bit = cur / block_size;
+                if (!test_bit(bit, attr->bitmap)) {
+                    continue;
+                }
+                clear_bit(bit, attr->bitmap);
+                ram_block_attribute_notify_to_discard(attr, cur, block_size);
+            }
+        } else {
+            /* Completely shared */
+            bitmap_clear(attr->bitmap, first_bit, nbits);
+            ram_block_attribute_notify_to_discard(attr, offset, size);
+        }
     } else {
-        bitmap_set(attr->bitmap, first_bit, nbits);
-        ret = ram_block_attribute_notify_to_populated(attr, offset, size);
+        if (ram_block_attribute_is_range_populated(attr, offset, size)) {
+            /* Already shared */
+        } else if (!ram_block_attribute_is_range_discard(attr, offset, size)) {
+            /* Unexpected mixture: process individual blocks */
+            unsigned long *modified_bitmap = bitmap_new(nbits);
+
+            for (cur = offset; cur < end; cur += block_size) {
+                bit = cur / block_size;
+                if (test_bit(bit, attr->bitmap)) {
+                    continue;
+                }
+                set_bit(bit, attr->bitmap);
+                ret = ram_block_attribute_notify_to_populated(attr, cur,
+                                                           block_size);
+                if (!ret) {
+                    set_bit(bit - first_bit, modified_bitmap);
+                    continue;
+                }
+                clear_bit(bit, attr->bitmap);
+                break;
+            }
+
+            if (ret) {
+                /*
+                 * Very unexpected: something went wrong. Revert to the old
+                 * state, marking only the blocks as private that we converted
+                 * to shared.
+                 */
+                for (cur = offset; cur < end; cur += block_size) {
+                    bit = cur / block_size;
+                    if (!test_bit(bit - first_bit, modified_bitmap)) {
+                        continue;
+                    }
+                    assert(test_bit(bit, attr->bitmap));
+                    clear_bit(bit, attr->bitmap);
+                    ram_block_attribute_notify_to_discard(attr, cur,
+                                                          block_size);
+                }
+            }
+            g_free(modified_bitmap);
+        } else {
+            /* Complete private */
+            bitmap_set(attr->bitmap, first_bit, nbits);
+            ret = ram_block_attribute_notify_to_populated(attr, offset, size);
+            if (ret) {
+                bitmap_clear(attr->bitmap, first_bit, nbits);
+            }
+        }
     }
 
     return ret;
-- 
2.43.5


