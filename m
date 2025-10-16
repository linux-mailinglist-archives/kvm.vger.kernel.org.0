Return-Path: <kvm+bounces-60208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1356BE4E1F
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:39:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AF485E197A
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71C502E0B60;
	Thu, 16 Oct 2025 17:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="bKthQqDs"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster4-host7-snip4-8.eps.apple.com [57.103.78.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A412222AC
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.78.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760636341; cv=none; b=uKBcVPC0Mwb1YKwfUEtMB7tppjujurouMSUNDkX9qNJAglYFGPoYC693QGwFRNJusLOPSoOb7LPgWk0OUwPOt/q4QtZWZHLBqhIu2oUuzkdOFzf/w7JR0G5r9rjqda4tR6Duyx18TMfJURmN3bfQ03JfuKJ5IaMrKbbE3cMQHdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760636341; c=relaxed/simple;
	bh=OE2hwoOCYPObfwNPRMToqzZNdcNS6M53rhFuFuhCWrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UN24rrNoayzNzk9QH41DOPMli3NHX5l+PjLDWGjZxymRGAduLNwH6WfJnP/fBxZa+hbVYkkL7sbnkVRjxUR4/e4oia/KNqSWQ2jeP+alba7lPM678QAcuvNissACKtM+gwvlmSSTaZmKqwsn7DlW9KUbxPK/6WK+ohQZO2133SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=bKthQqDs; arc=none smtp.client-ip=57.103.78.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id 8C5701800178;
	Thu, 16 Oct 2025 17:38:53 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=82UyicUDYmPvjVI7F//cuPe+s0EfvftNMhuinirR7JM=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=bKthQqDsYnu5LsI7ILj38DNSSupusq5zAnHGCVp4ISpY0LiFPnIjgVc9HtCnm5hyuI0ftJtux9O6NM9hnRNap6vNdXSnTwz32t/y7fPr6KdDlxMPfvaZjdJvOwg/v+NmQrS1GFPI4jx4MKydm1q0bhbx0b+9J8NzQrF7FuD3KGKVdxapO9x5wmby8tWLnnwoCnPhP/j6wKE0hOIhaqcsfo3PNUvi9lWWvJVIjkPK65Ls8CYG2jgtO73PDDFpOVYz3ng6jw6l+O8Zreun8fx+frWN6FfGxHsufbnIR+pX5ydba5TR+Eimlx2zrJU3/uxsyk6ChepOqnmruzGSxtEr/Q==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id 9740C180009D;
	Thu, 16 Oct 2025 17:38:49 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Igor Mammedov <imammedo@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Ani Sinha <anisinha@redhat.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Zhao Liu <zhao1.liu@intel.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>
Subject: [PATCH v8 13/24] whpx: change memory management logic
Date: Thu, 16 Oct 2025 19:37:52 +0200
Message-ID: <20251016173803.65764-14-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251016173803.65764-1-mohamed@unpredictable.fr>
References: <20251016173803.65764-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyOCBTYWx0ZWRfX38ZlQHx7hEDZ
 dOGp6eLTl3YWrMxZUhhH40ahLxaChVM/5E1I+FNgFqdoaR1dQ5jyGbYlQGhrqDerOv0dGl4kJuM
 ErcjAO6AbIqYt0EmiFdRpFRQzAJa4kX9GQZffq+51bT6lwWwkOzYylUNdQUHx86l9/jFdka9h30
 DoxPLg7/LtILvmx244HEWsKxj+O5caem2dRmL41tAjA0MrjYMUHTofAPFib/zhgHmW3947fX1Xw
 HkmfYtAcNwSks3iCDXJqFY4lPi+jMi7xrn01c/d+RaKMRzb1b5P01Jdplhg8tBi5dXDdJP5kM=
X-Proofpoint-GUID: KWZ7rnSZgz3kIevxdj-my4kU95fNqWhD
X-Proofpoint-ORIG-GUID: KWZ7rnSZgz3kIevxdj-my4kU95fNqWhD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 suspectscore=0 clxscore=1030 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160128
X-JNJ: AAAAAAAB/NfokEn246SdWICx7kLD1xmWFX/4amWxU6gRcPHcwmOET0p2KHrmAu6v0zwOTJPAKjLHPr083vunzpzxvtDrRjRg1r/kqYi2N0fgMj7nWVsf5vV/pADk6Ua86DTOB65JhvUufskVorN7q7p3UkzokYkv4YdjJf/9bXydwV0eudTetzORUGfaw5Zh0x0eKUskUwGKdYTaqe+WijDwpAlGqslHBeSx3SgPLYGPKVaQLMejvhEkKXBmY9dRvJKZ5LuS+8KBWhASrFd9Qepd9Bv0F/tpdMjLChxZOQ3m/jliRb03t7UdxjOHI+mtamYshan/WfFmNvcYPIU81BU2pGHBst3onirXzN4mV/iPHejkyPtUFKoelVW0rXNJcYtvxiLmBbjYJlEomPTm077VUV6xc40S6L6DmH0xZ5VJ6bYarISJmp9MNYIgAvvX62gCNW71E+Gy2b4nGRj2/jK6M8b//xw6ZrrBETAX9VnK9+LyqIjRZd5iXit6xKyJEBup/o7KsiXh2BLM812SyNsBT4q3Y5KG19HGenVfu8yp84fzkdRQ1XR3oouWQJbRawV4RfZYhE1dsaElFplxI3IDsY8+b9NDKrs4KwJmtpko/dm9V5A2//lW3oskIomlrN+BuxW4S26B90FkPprGOQQHTgBNaPgx+jHgc8umDjnt+N93ynJQOiFkfjuFwrq3IU/vxZ4cok88ncBUACVggqohaAnhbzOx29eZm+KcqLeE+iCDoPBU4vK08L5FxqWxfKsMzn/gdQzphFrTXKvuAd2BKtJPaedD4R7tqdS8RTT/xd4btGHWZqYA568eC6t3EFC00REiJIIh5atueOmYyw/j2ds6PfOxjRGOoebuIyvx+21LfkDrq+EXHdf9yOObxADHA9bB80ZNB3H17xnI

This allows edk2 to work on Arm, although u-boot is still not functional.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 accel/whpx/whpx-common.c | 97 ++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 63 deletions(-)

diff --git a/accel/whpx/whpx-common.c b/accel/whpx/whpx-common.c
index c69792e638..afc325aa28 100644
--- a/accel/whpx/whpx-common.c
+++ b/accel/whpx/whpx-common.c
@@ -258,89 +258,60 @@ void whpx_vcpu_kick(CPUState *cpu)
  * Memory support.
  */
 
-static void whpx_update_mapping(hwaddr start_pa, ram_addr_t size,
-                                void *host_va, int add, int rom,
-                                const char *name)
+static void whpx_set_phys_mem(MemoryRegionSection *section, bool add)
 {
     struct whpx_state *whpx = &whpx_global;
-    HRESULT hr;
-
-    /*
-    if (add) {
-        printf("WHPX: ADD PA:%p Size:%p, Host:%p, %s, '%s'\n",
-               (void*)start_pa, (void*)size, host_va,
-               (rom ? "ROM" : "RAM"), name);
-    } else {
-        printf("WHPX: DEL PA:%p Size:%p, Host:%p,      '%s'\n",
-               (void*)start_pa, (void*)size, host_va, name);
-    }
-    */
-
-    if (add) {
-        hr = whp_dispatch.WHvMapGpaRange(whpx->partition,
-                                         host_va,
-                                         start_pa,
-                                         size,
-                                         (WHvMapGpaRangeFlagRead |
-                                          WHvMapGpaRangeFlagExecute |
-                                          (rom ? 0 : WHvMapGpaRangeFlagWrite)));
-    } else {
-        hr = whp_dispatch.WHvUnmapGpaRange(whpx->partition,
-                                           start_pa,
-                                           size);
-    }
-
-    if (FAILED(hr)) {
-        error_report("WHPX: Failed to %s GPA range '%s' PA:%p, Size:%p bytes,"
-                     " Host:%p, hr=%08lx",
-                     (add ? "MAP" : "UNMAP"), name,
-                     (void *)(uintptr_t)start_pa, (void *)size, host_va, hr);
+    MemoryRegion *area = section->mr;
+    bool writable = !area->readonly && !area->rom_device;
+    WHV_MAP_GPA_RANGE_FLAGS flags;
+    uint64_t page_size = qemu_real_host_page_size();
+    uint64_t gva = section->offset_within_address_space;
+    uint64_t size = int128_get64(section->size);
+    HRESULT res;
+    void *mem;
+
+    if (!memory_region_is_ram(area)) {
+        if (writable) {
+            return;
+        } else if (!memory_region_is_romd(area)) {
+             add = false;
+        }
     }
-}
 
-static void whpx_process_section(MemoryRegionSection *section, int add)
-{
-    MemoryRegion *mr = section->mr;
-    hwaddr start_pa = section->offset_within_address_space;
-    ram_addr_t size = int128_get64(section->size);
-    unsigned int delta;
-    uint64_t host_va;
-
-    if (!memory_region_is_ram(mr)) {
-        return;
+    if (!QEMU_IS_ALIGNED(size, page_size) ||
+        !QEMU_IS_ALIGNED(gva, page_size)) {
+        /* Not page aligned, so we can not map as RAM */
+        add = false;
     }
 
-    delta = qemu_real_host_page_size() - (start_pa & ~qemu_real_host_page_mask());
-    delta &= ~qemu_real_host_page_mask();
-    if (delta > size) {
-        return;
-    }
-    start_pa += delta;
-    size -= delta;
-    size &= qemu_real_host_page_mask();
-    if (!size || (start_pa & ~qemu_real_host_page_mask())) {
+    if (!add) {
+        res = whp_dispatch.WHvUnmapGpaRange(whpx->partition,
+                gva, size);
         return;
     }
 
-    host_va = (uintptr_t)memory_region_get_ram_ptr(mr)
-            + section->offset_within_region + delta;
+    flags = WHvMapGpaRangeFlagRead | WHvMapGpaRangeFlagExecute
+     | (writable ? WHvMapGpaRangeFlagWrite : 0);
+    mem = memory_region_get_ram_ptr(area) + section->offset_within_region;
 
-    whpx_update_mapping(start_pa, size, (void *)(uintptr_t)host_va, add,
-                        memory_region_is_rom(mr), mr->name);
+    res = whp_dispatch.WHvMapGpaRange(whpx->partition,
+         mem, gva, size, flags);
+    if (!SUCCEEDED(res)) {
+        error_report("WHPX: failed to map GPA range");
+        abort();
+    }
 }
 
 static void whpx_region_add(MemoryListener *listener,
                            MemoryRegionSection *section)
 {
-    memory_region_ref(section->mr);
-    whpx_process_section(section, 1);
+    whpx_set_phys_mem(section, true);
 }
 
 static void whpx_region_del(MemoryListener *listener,
                            MemoryRegionSection *section)
 {
-    whpx_process_section(section, 0);
-    memory_region_unref(section->mr);
+    whpx_set_phys_mem(section, false);
 }
 
 static void whpx_transaction_begin(MemoryListener *listener)
-- 
2.50.1 (Apple Git-155)


