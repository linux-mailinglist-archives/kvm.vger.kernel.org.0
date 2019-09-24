Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FEEBC81B
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 14:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504973AbfIXMpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 08:45:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504964AbfIXMpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 08:45:52 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 51C45300D20B;
        Tue, 24 Sep 2019 12:45:52 +0000 (UTC)
Received: from dritchie.redhat.com (unknown [10.33.36.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DEAA608C2;
        Tue, 24 Sep 2019 12:45:37 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     mst@redhat.com, imammedo@redhat.com, marcel.apfelbaum@gmail.com,
        pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>
Subject: [PATCH v4 5/8] fw_cfg: add "modify" functions for all types
Date:   Tue, 24 Sep 2019 14:44:30 +0200
Message-Id: <20190924124433.96810-6-slp@redhat.com>
In-Reply-To: <20190924124433.96810-1-slp@redhat.com>
References: <20190924124433.96810-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 24 Sep 2019 12:45:52 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows to alter the contents of an already added item.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
 hw/nvram/fw_cfg.c         | 29 +++++++++++++++++++++++++++
 include/hw/nvram/fw_cfg.h | 42 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/hw/nvram/fw_cfg.c b/hw/nvram/fw_cfg.c
index 7dc3ac378e..aef1727250 100644
--- a/hw/nvram/fw_cfg.c
+++ b/hw/nvram/fw_cfg.c
@@ -690,6 +690,15 @@ void fw_cfg_add_string(FWCfgState *s, uint16_t key, const char *value)
     fw_cfg_add_bytes(s, key, g_memdup(value, sz), sz);
 }
 
+void fw_cfg_modify_string(FWCfgState *s, uint16_t key, const char *value)
+{
+    size_t sz = strlen(value) + 1;
+    char *old;
+
+    old = fw_cfg_modify_bytes_read(s, key, g_memdup(value, sz), sz);
+    g_free(old);
+}
+
 void fw_cfg_add_i16(FWCfgState *s, uint16_t key, uint16_t value)
 {
     uint16_t *copy;
@@ -720,6 +729,16 @@ void fw_cfg_add_i32(FWCfgState *s, uint16_t key, uint32_t value)
     fw_cfg_add_bytes(s, key, copy, sizeof(value));
 }
 
+void fw_cfg_modify_i32(FWCfgState *s, uint16_t key, uint32_t value)
+{
+    uint32_t *copy, *old;
+
+    copy = g_malloc(sizeof(value));
+    *copy = cpu_to_le32(value);
+    old = fw_cfg_modify_bytes_read(s, key, copy, sizeof(value));
+    g_free(old);
+}
+
 void fw_cfg_add_i64(FWCfgState *s, uint16_t key, uint64_t value)
 {
     uint64_t *copy;
@@ -730,6 +749,16 @@ void fw_cfg_add_i64(FWCfgState *s, uint16_t key, uint64_t value)
     fw_cfg_add_bytes(s, key, copy, sizeof(value));
 }
 
+void fw_cfg_modify_i64(FWCfgState *s, uint16_t key, uint64_t value)
+{
+    uint64_t *copy, *old;
+
+    copy = g_malloc(sizeof(value));
+    *copy = cpu_to_le64(value);
+    old = fw_cfg_modify_bytes_read(s, key, copy, sizeof(value));
+    g_free(old);
+}
+
 void fw_cfg_set_order_override(FWCfgState *s, int order)
 {
     assert(s->fw_cfg_order_override == 0);
diff --git a/include/hw/nvram/fw_cfg.h b/include/hw/nvram/fw_cfg.h
index 80e435d303..b5291eefad 100644
--- a/include/hw/nvram/fw_cfg.h
+++ b/include/hw/nvram/fw_cfg.h
@@ -98,6 +98,20 @@ void fw_cfg_add_bytes(FWCfgState *s, uint16_t key, void *data, size_t len);
  */
 void fw_cfg_add_string(FWCfgState *s, uint16_t key, const char *value);
 
+/**
+ * fw_cfg_modify_string:
+ * @s: fw_cfg device being modified
+ * @key: selector key value for new fw_cfg item
+ * @value: NUL-terminated ascii string
+ *
+ * Replace the fw_cfg item available by selecting the given key. The new
+ * data will consist of a dynamically allocated copy of the provided string,
+ * including its NUL terminator. The data being replaced, assumed to have
+ * been dynamically allocated during an earlier call to either
+ * fw_cfg_add_string() or fw_cfg_modify_string(), is freed before returning.
+ */
+void fw_cfg_modify_string(FWCfgState *s, uint16_t key, const char *value);
+
 /**
  * fw_cfg_add_i16:
  * @s: fw_cfg device being modified
@@ -136,6 +150,20 @@ void fw_cfg_modify_i16(FWCfgState *s, uint16_t key, uint16_t value);
  */
 void fw_cfg_add_i32(FWCfgState *s, uint16_t key, uint32_t value);
 
+/**
+ * fw_cfg_modify_i32:
+ * @s: fw_cfg device being modified
+ * @key: selector key value for new fw_cfg item
+ * @value: 32-bit integer
+ *
+ * Replace the fw_cfg item available by selecting the given key. The new
+ * data will consist of a dynamically allocated copy of the given 32-bit
+ * value, converted to little-endian representation. The data being replaced,
+ * assumed to have been dynamically allocated during an earlier call to
+ * either fw_cfg_add_i32() or fw_cfg_modify_i32(), is freed before returning.
+ */
+void fw_cfg_modify_i32(FWCfgState *s, uint16_t key, uint32_t value);
+
 /**
  * fw_cfg_add_i64:
  * @s: fw_cfg device being modified
@@ -148,6 +176,20 @@ void fw_cfg_add_i32(FWCfgState *s, uint16_t key, uint32_t value);
  */
 void fw_cfg_add_i64(FWCfgState *s, uint16_t key, uint64_t value);
 
+/**
+ * fw_cfg_modify_i64:
+ * @s: fw_cfg device being modified
+ * @key: selector key value for new fw_cfg item
+ * @value: 64-bit integer
+ *
+ * Replace the fw_cfg item available by selecting the given key. The new
+ * data will consist of a dynamically allocated copy of the given 64-bit
+ * value, converted to little-endian representation. The data being replaced,
+ * assumed to have been dynamically allocated during an earlier call to
+ * either fw_cfg_add_i64() or fw_cfg_modify_i64(), is freed before returning.
+ */
+void fw_cfg_modify_i64(FWCfgState *s, uint16_t key, uint64_t value);
+
 /**
  * fw_cfg_add_file:
  * @s: fw_cfg device being modified
-- 
2.21.0

