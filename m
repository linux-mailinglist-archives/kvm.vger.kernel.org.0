Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9102D14EEFE
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 16:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbgAaPCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 10:02:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729214AbgAaPCc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 10:02:32 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00VF16Ep056859
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:02:31 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xvfy981bt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:02:29 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 31 Jan 2020 15:02:17 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 Jan 2020 15:02:13 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00VF1J4n47382844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 15:01:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D13FEAE045;
        Fri, 31 Jan 2020 15:02:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B582EAE058;
        Fri, 31 Jan 2020 15:02:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Jan 2020 15:02:11 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 75C33E0378; Fri, 31 Jan 2020 16:02:11 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PULL 10/12] kvm: split too big memory section on several memslots
Date:   Fri, 31 Jan 2020 16:02:05 +0100
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200131150207.73127-1-borntraeger@de.ibm.com>
References: <20200131150207.73127-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20013115-0012-0000-0000-000003828EC2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013115-0013-0000-0000-000021BEECF1
Message-Id: <20200131150207.73127-11-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_03:2020-01-31,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=2 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001310126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Igor Mammedov <imammedo@redhat.com>

Max memslot size supported by kvm on s390 is 8Tb,
move logic of splitting RAM in chunks upto 8T to KVM code.

This way it will hide KVM specific restrictions in KVM code
and won't affect board level design decisions. Which would allow
us to avoid misusing memory_region_allocate_system_memory() API
and eventually use a single hostmem backend for guest RAM.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Message-Id: <20190924144751.24149-4-imammedo@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 accel/kvm/kvm-all.c      | 122 +++++++++++++++++++++++++--------------
 include/sysemu/kvm_int.h |   1 +
 2 files changed, 80 insertions(+), 43 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index ff9b95c0d103..aabe097c410f 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -140,6 +140,7 @@ bool kvm_direct_msi_allowed;
 bool kvm_ioeventfd_any_length_allowed;
 bool kvm_msi_use_devid;
 static bool kvm_immediate_exit;
+static hwaddr kvm_max_slot_size = ~0;
 
 static const KVMCapabilityInfo kvm_required_capabilites[] = {
     KVM_CAP_INFO(USER_MEMORY),
@@ -437,7 +438,7 @@ static int kvm_slot_update_flags(KVMMemoryListener *kml, KVMSlot *mem,
 static int kvm_section_update_flags(KVMMemoryListener *kml,
                                     MemoryRegionSection *section)
 {
-    hwaddr start_addr, size;
+    hwaddr start_addr, size, slot_size;
     KVMSlot *mem;
     int ret = 0;
 
@@ -448,13 +449,18 @@ static int kvm_section_update_flags(KVMMemoryListener *kml,
 
     kvm_slots_lock(kml);
 
-    mem = kvm_lookup_matching_slot(kml, start_addr, size);
-    if (!mem) {
-        /* We don't have a slot if we want to trap every access. */
-        goto out;
-    }
+    while (size && !ret) {
+        slot_size = MIN(kvm_max_slot_size, size);
+        mem = kvm_lookup_matching_slot(kml, start_addr, slot_size);
+        if (!mem) {
+            /* We don't have a slot if we want to trap every access. */
+            goto out;
+        }
 
-    ret = kvm_slot_update_flags(kml, mem, section->mr);
+        ret = kvm_slot_update_flags(kml, mem, section->mr);
+        start_addr += slot_size;
+        size -= slot_size;
+    }
 
 out:
     kvm_slots_unlock(kml);
@@ -527,11 +533,15 @@ static int kvm_physical_sync_dirty_bitmap(KVMMemoryListener *kml,
     struct kvm_dirty_log d = {};
     KVMSlot *mem;
     hwaddr start_addr, size;
+    hwaddr slot_size, slot_offset = 0;
     int ret = 0;
 
     size = kvm_align_section(section, &start_addr);
-    if (size) {
-        mem = kvm_lookup_matching_slot(kml, start_addr, size);
+    while (size) {
+        MemoryRegionSection subsection = *section;
+
+        slot_size = MIN(kvm_max_slot_size, size);
+        mem = kvm_lookup_matching_slot(kml, start_addr, slot_size);
         if (!mem) {
             /* We don't have a slot if we want to trap every access. */
             goto out;
@@ -549,11 +559,11 @@ static int kvm_physical_sync_dirty_bitmap(KVMMemoryListener *kml,
          * So for now, let's align to 64 instead of HOST_LONG_BITS here, in
          * a hope that sizeof(long) won't become >8 any time soon.
          */
-        size = ALIGN(((mem->memory_size) >> TARGET_PAGE_BITS),
-                     /*HOST_LONG_BITS*/ 64) / 8;
         if (!mem->dirty_bmap) {
+            hwaddr bitmap_size = ALIGN(((mem->memory_size) >> TARGET_PAGE_BITS),
+                                        /*HOST_LONG_BITS*/ 64) / 8;
             /* Allocate on the first log_sync, once and for all */
-            mem->dirty_bmap = g_malloc0(size);
+            mem->dirty_bmap = g_malloc0(bitmap_size);
         }
 
         d.dirty_bitmap = mem->dirty_bmap;
@@ -564,7 +574,13 @@ static int kvm_physical_sync_dirty_bitmap(KVMMemoryListener *kml,
             goto out;
         }
 
-        kvm_get_dirty_pages_log_range(section, d.dirty_bitmap);
+        subsection.offset_within_region += slot_offset;
+        subsection.size = int128_make64(slot_size);
+        kvm_get_dirty_pages_log_range(&subsection, d.dirty_bitmap);
+
+        slot_offset += slot_size;
+        start_addr += slot_size;
+        size -= slot_size;
     }
 out:
     return ret;
@@ -972,6 +988,14 @@ kvm_check_extension_list(KVMState *s, const KVMCapabilityInfo *list)
     return NULL;
 }
 
+void kvm_set_max_memslot_size(hwaddr max_slot_size)
+{
+    g_assert(
+        ROUND_UP(max_slot_size, qemu_real_host_page_size) == max_slot_size
+    );
+    kvm_max_slot_size = max_slot_size;
+}
+
 static void kvm_set_phys_mem(KVMMemoryListener *kml,
                              MemoryRegionSection *section, bool add)
 {
@@ -979,7 +1003,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
     int err;
     MemoryRegion *mr = section->mr;
     bool writeable = !mr->readonly && !mr->rom_device;
-    hwaddr start_addr, size;
+    hwaddr start_addr, size, slot_size;
     void *ram;
 
     if (!memory_region_is_ram(mr)) {
@@ -1004,41 +1028,52 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
     kvm_slots_lock(kml);
 
     if (!add) {
-        mem = kvm_lookup_matching_slot(kml, start_addr, size);
-        if (!mem) {
-            goto out;
-        }
-        if (mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
-            kvm_physical_sync_dirty_bitmap(kml, section);
-        }
+        do {
+            slot_size = MIN(kvm_max_slot_size, size);
+            mem = kvm_lookup_matching_slot(kml, start_addr, slot_size);
+            if (!mem) {
+                goto out;
+            }
+            if (mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+                kvm_physical_sync_dirty_bitmap(kml, section);
+            }
 
-        /* unregister the slot */
-        g_free(mem->dirty_bmap);
-        mem->dirty_bmap = NULL;
-        mem->memory_size = 0;
-        mem->flags = 0;
-        err = kvm_set_user_memory_region(kml, mem, false);
-        if (err) {
-            fprintf(stderr, "%s: error unregistering slot: %s\n",
-                    __func__, strerror(-err));
-            abort();
-        }
+            /* unregister the slot */
+            g_free(mem->dirty_bmap);
+            mem->dirty_bmap = NULL;
+            mem->memory_size = 0;
+            mem->flags = 0;
+            err = kvm_set_user_memory_region(kml, mem, false);
+            if (err) {
+                fprintf(stderr, "%s: error unregistering slot: %s\n",
+                        __func__, strerror(-err));
+                abort();
+            }
+            start_addr += slot_size;
+            size -= slot_size;
+        } while (size);
         goto out;
     }
 
     /* register the new slot */
-    mem = kvm_alloc_slot(kml);
-    mem->memory_size = size;
-    mem->start_addr = start_addr;
-    mem->ram = ram;
-    mem->flags = kvm_mem_flags(mr);
+    do {
+        slot_size = MIN(kvm_max_slot_size, size);
+        mem = kvm_alloc_slot(kml);
+        mem->memory_size = slot_size;
+        mem->start_addr = start_addr;
+        mem->ram = ram;
+        mem->flags = kvm_mem_flags(mr);
 
-    err = kvm_set_user_memory_region(kml, mem, true);
-    if (err) {
-        fprintf(stderr, "%s: error registering slot: %s\n", __func__,
-                strerror(-err));
-        abort();
-    }
+        err = kvm_set_user_memory_region(kml, mem, true);
+        if (err) {
+            fprintf(stderr, "%s: error registering slot: %s\n", __func__,
+                    strerror(-err));
+            abort();
+        }
+        start_addr += slot_size;
+        ram += slot_size;
+        size -= slot_size;
+    } while (size);
 
 out:
     kvm_slots_unlock(kml);
@@ -2878,6 +2913,7 @@ static bool kvm_accel_has_memory(MachineState *ms, AddressSpace *as,
 
     for (i = 0; i < kvm->nr_as; ++i) {
         if (kvm->as[i].as == as && kvm->as[i].ml) {
+            size = MIN(kvm_max_slot_size, size);
             return NULL != kvm_lookup_matching_slot(kvm->as[i].ml,
                                                     start_addr, size);
         }
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 72b2d1b3aea5..ac2d1f8b5682 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -41,4 +41,5 @@ typedef struct KVMMemoryListener {
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
                                   AddressSpace *as, int as_id);
 
+void kvm_set_max_memslot_size(hwaddr max_slot_size);
 #endif
-- 
2.21.0

