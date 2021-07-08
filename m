Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BA53BF306
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhGHA6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:19320 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230199AbhGHA6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196696080"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196696080"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:56 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770047"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:55 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 18/44] hw/i386: refactor e820_add_entry()
Date:   Wed,  7 Jul 2021 17:54:48 -0700
Message-Id: <876d3849f5293e7902df6e6f1dc8e89662b42a6b.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

The following patch will utilize this refactoring.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 hw/i386/e820_memory_layout.c | 42 ++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/hw/i386/e820_memory_layout.c b/hw/i386/e820_memory_layout.c
index bcf9eaf837..d9bb11c02a 100644
--- a/hw/i386/e820_memory_layout.c
+++ b/hw/i386/e820_memory_layout.c
@@ -14,31 +14,45 @@ static size_t e820_entries;
 struct e820_table e820_reserve;
 struct e820_entry *e820_table;
 
-int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
+static int e820_append_reserve(uint64_t address, uint64_t length, uint32_t type)
 {
     int index = le32_to_cpu(e820_reserve.count);
     struct e820_entry *entry;
 
-    if (type != E820_RAM) {
-        /* old FW_CFG_E820_TABLE entry -- reservations only */
-        if (index >= E820_NR_ENTRIES) {
-            return -EBUSY;
-        }
-        entry = &e820_reserve.entry[index++];
+    /* old FW_CFG_E820_TABLE entry -- reservations only */
+    if (index >= E820_NR_ENTRIES) {
+        return -EBUSY;
+    }
+    entry = &e820_reserve.entry[index++];
 
-        entry->address = cpu_to_le64(address);
-        entry->length = cpu_to_le64(length);
-        entry->type = cpu_to_le32(type);
+    entry->address = cpu_to_le64(address);
+    entry->length = cpu_to_le64(length);
+    entry->type = cpu_to_le32(type);
 
-        e820_reserve.count = cpu_to_le32(index);
-    }
+    e820_reserve.count = cpu_to_le32(index);
+    return 0;
+}
 
-    /* new "etc/e820" file -- include ram too */
-    e820_table = g_renew(struct e820_entry, e820_table, e820_entries + 1);
+static void e820_append_entry(uint64_t address, uint64_t length, uint32_t type)
+{
     e820_table[e820_entries].address = cpu_to_le64(address);
     e820_table[e820_entries].length = cpu_to_le64(length);
     e820_table[e820_entries].type = cpu_to_le32(type);
     e820_entries++;
+}
+
+int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
+{
+    if (type != E820_RAM) {
+        int ret = e820_append_reserve(address, length, type);
+        if (ret) {
+            return ret;
+        }
+    }
+
+    /* new "etc/e820" file -- include ram too */
+    e820_table = g_renew(struct e820_entry, e820_table, e820_entries + 1);
+    e820_append_entry(address, length, type);
 
     return e820_entries;
 }
-- 
2.25.1

