Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22B13BF305
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhGHA6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:19318 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhGHA6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196696081"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196696081"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:56 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770050"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:56 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 19/44] hw/i386/e820: introduce a helper function to change type of e820
Date:   Wed,  7 Jul 2021 17:54:49 -0700
Message-Id: <57f1c8c44405aadc421bc1fd5b6cb41f55b10e20.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce a helper function, e820_change_type(), that change
the type of subregion of e820 entry.
The following patch uses it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 hw/i386/e820_memory_layout.c | 72 ++++++++++++++++++++++++++++++++++++
 hw/i386/e820_memory_layout.h |  1 +
 2 files changed, 73 insertions(+)

diff --git a/hw/i386/e820_memory_layout.c b/hw/i386/e820_memory_layout.c
index d9bb11c02a..109c4f715a 100644
--- a/hw/i386/e820_memory_layout.c
+++ b/hw/i386/e820_memory_layout.c
@@ -57,6 +57,78 @@ int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
     return e820_entries;
 }
 
+int e820_change_type(uint64_t address, uint64_t length, uint32_t type)
+{
+    size_t i;
+
+    if (type != E820_RAM) {
+        int ret = e820_append_reserve(address, length, type);
+        if (ret) {
+            return ret;
+        }
+    }
+
+    /* new "etc/e820" file -- include ram too */
+    for (i = 0; i < e820_entries; i++) {
+        struct e820_entry *e = &e820_table[i];
+        struct e820_entry tmp = {
+            .address = le64_to_cpu(e->address),
+            .length = le64_to_cpu(e->length),
+            .type = le32_to_cpu(e->type),
+        };
+        /* overlap? */
+        if (address + length < tmp.address ||
+            tmp.address + tmp.length < address) {
+            continue;
+        }
+        /*
+         * partial-overlap is not allowed.
+         * It is assumed that the region is completely contained within
+         * other region.
+         */
+        if (address < tmp.address ||
+            tmp.address + tmp.length < address + length) {
+            return -EINVAL;
+        }
+        /* only real type change is allowed. */
+        if (tmp.type == type) {
+            return -EINVAL;
+        }
+
+        if (tmp.address == address &&
+            tmp.address + tmp.length == address + length) {
+            e->type = cpu_to_le32(type);
+            return e820_entries;
+        } else if (tmp.address == address) {
+            e820_table = g_renew(struct e820_entry,
+                                 e820_table, e820_entries + 1);
+            e = &e820_table[i];
+            e->address = cpu_to_le64(tmp.address + length);
+            e820_append_entry(address, length, type);
+            return e820_entries;
+        } else if (tmp.address + tmp.length == address + length) {
+            e820_table = g_renew(struct e820_entry,
+                                 e820_table, e820_entries + 1);
+            e = &e820_table[i];
+            e->length = cpu_to_le64(tmp.length - length);
+            e820_append_entry(address, length, type);
+            return e820_entries;
+        } else {
+            e820_table = g_renew(struct e820_entry,
+                                 e820_table, e820_entries + 2);
+            e = &e820_table[i];
+            e->length = cpu_to_le64(address - tmp.address);
+            e820_append_entry(address, length, type);
+            e820_append_entry(address + length,
+                              tmp.address + tmp.length - (address + length),
+                              tmp.type);
+            return e820_entries;
+        }
+    }
+
+    return -EINVAL;
+}
+
 int e820_get_num_entries(void)
 {
     return e820_entries;
diff --git a/hw/i386/e820_memory_layout.h b/hw/i386/e820_memory_layout.h
index 2a0ceb8b9c..5f27cee476 100644
--- a/hw/i386/e820_memory_layout.h
+++ b/hw/i386/e820_memory_layout.h
@@ -33,6 +33,7 @@ extern struct e820_table e820_reserve;
 extern struct e820_entry *e820_table;
 
 int e820_add_entry(uint64_t address, uint64_t length, uint32_t type);
+int e820_change_type(uint64_t address, uint64_t length, uint32_t type);
 int e820_get_num_entries(void);
 bool e820_get_entry(int index, uint32_t type,
                     uint64_t *address, uint64_t *length);
-- 
2.25.1

