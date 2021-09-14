Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917A540B3C1
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 17:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbhINPxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 11:53:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47567 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234534AbhINPxm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 11:53:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631634744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EVzGgOi462BggNsvkxUFt1krENMLCAYntkyOmgKfes4=;
        b=Gj4v8cic77eTsGgUKYS6fNY0kaO0G3JFDlT3BAUzouxL/bFQ4HSNj79Bk4SYY5kNuqHw/5
        cahXJVPOti6/lwi/GSkMPalqqfauBeCLUaKn3pFN8S5pipo7xDgvJJo6Q40WuS14Wtqdvq
        9TztcR+zb7EJceb7Mc1OpA3GsVGPDnA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-FrOzdBsKOb-NLFZLDBpqXA-1; Tue, 14 Sep 2021 11:52:23 -0400
X-MC-Unique: FrOzdBsKOb-NLFZLDBpqXA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE4F719253C0;
        Tue, 14 Sep 2021 15:52:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE4F05D9D3;
        Tue, 14 Sep 2021 15:52:20 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/3] gdbstub: implement NOIRQ support for single step on KVM
Date:   Tue, 14 Sep 2021 18:52:13 +0300
Message-Id: <20210914155214.105415-3-mlevitsk@redhat.com>
In-Reply-To: <20210914155214.105415-1-mlevitsk@redhat.com>
References: <20210914155214.105415-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 accel/kvm/kvm-all.c  | 25 ++++++++++++++++++
 gdbstub.c            | 60 ++++++++++++++++++++++++++++++++++++--------
 include/sysemu/kvm.h | 13 ++++++++++
 3 files changed, 88 insertions(+), 10 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 6b187e9c96..e141260796 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -169,6 +169,8 @@ bool kvm_vm_attributes_allowed;
 bool kvm_direct_msi_allowed;
 bool kvm_ioeventfd_any_length_allowed;
 bool kvm_msi_use_devid;
+bool kvm_has_guest_debug;
+int kvm_sstep_flags;
 static bool kvm_immediate_exit;
 static hwaddr kvm_max_slot_size = ~0;
 
@@ -2559,6 +2561,25 @@ static int kvm_init(MachineState *ms)
     kvm_sregs2 =
         (kvm_check_extension(s, KVM_CAP_SREGS2) > 0);
 
+    kvm_has_guest_debug =
+        (kvm_check_extension(s, KVM_CAP_SET_GUEST_DEBUG) > 0);
+
+    kvm_sstep_flags = 0;
+
+    if (kvm_has_guest_debug) {
+        /* Assume that single stepping is supported */
+        kvm_sstep_flags = SSTEP_ENABLE;
+
+        int guest_debug_flags =
+            kvm_check_extension(s, KVM_CAP_SET_GUEST_DEBUG2);
+
+        if (guest_debug_flags > 0) {
+            if (guest_debug_flags & KVM_GUESTDBG_BLOCKIRQ) {
+                kvm_sstep_flags |= SSTEP_NOIRQ;
+            }
+        }
+    }
+
     kvm_state = s;
 
     ret = kvm_arch_init(ms, s);
@@ -3188,6 +3209,10 @@ int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
 
     if (cpu->singlestep_enabled) {
         data.dbg.control |= KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLESTEP;
+
+        if (cpu->singlestep_enabled & SSTEP_NOIRQ) {
+            data.dbg.control |= KVM_GUESTDBG_BLOCKIRQ;
+        }
     }
     kvm_arch_update_guest_debug(cpu, &data.dbg);
 
diff --git a/gdbstub.c b/gdbstub.c
index 5d8e6ae3cd..48bb803bae 100644
--- a/gdbstub.c
+++ b/gdbstub.c
@@ -368,12 +368,11 @@ typedef struct GDBState {
     gdb_syscall_complete_cb current_syscall_cb;
     GString *str_buf;
     GByteArray *mem_buf;
+    int sstep_flags;
+    int supported_sstep_flags;
 } GDBState;
 
-/* By default use no IRQs and no timers while single stepping so as to
- * make single stepping like an ICE HW step.
- */
-static int sstep_flags = SSTEP_ENABLE|SSTEP_NOIRQ|SSTEP_NOTIMER;
+static GDBState gdbserver_state;
 
 /* Retrieves flags for single step mode. */
 static int get_sstep_flags(void)
@@ -385,11 +384,10 @@ static int get_sstep_flags(void)
     if (replay_mode != REPLAY_MODE_NONE) {
         return SSTEP_ENABLE;
     } else {
-        return sstep_flags;
+        return gdbserver_state.sstep_flags;
     }
 }
 
-static GDBState gdbserver_state;
 
 static void init_gdbserver_state(void)
 {
@@ -399,6 +397,23 @@ static void init_gdbserver_state(void)
     gdbserver_state.str_buf = g_string_new(NULL);
     gdbserver_state.mem_buf = g_byte_array_sized_new(MAX_PACKET_LENGTH);
     gdbserver_state.last_packet = g_byte_array_sized_new(MAX_PACKET_LENGTH + 4);
+
+
+    if (kvm_enabled()) {
+        gdbserver_state.supported_sstep_flags = kvm_get_supported_sstep_flags();
+    } else {
+        gdbserver_state.supported_sstep_flags =
+            SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_NOTIMER;
+    }
+
+    /*
+     * By default use no IRQs and no timers while single stepping so as to
+     * make single stepping like an ICE HW step.
+     */
+
+    gdbserver_state.sstep_flags = SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_NOTIMER;
+    gdbserver_state.sstep_flags &= gdbserver_state.supported_sstep_flags;
+
 }
 
 #ifndef CONFIG_USER_ONLY
@@ -2017,24 +2032,44 @@ static void handle_v_commands(GArray *params, void *user_ctx)
 
 static void handle_query_qemu_sstepbits(GArray *params, void *user_ctx)
 {
-    g_string_printf(gdbserver_state.str_buf, "ENABLE=%x,NOIRQ=%x,NOTIMER=%x",
-                    SSTEP_ENABLE, SSTEP_NOIRQ, SSTEP_NOTIMER);
+    g_string_printf(gdbserver_state.str_buf, "ENABLE=%x", SSTEP_ENABLE);
+
+    if (gdbserver_state.supported_sstep_flags & SSTEP_NOIRQ) {
+        g_string_append_printf(gdbserver_state.str_buf, ",NOIRQ=%x",
+                               SSTEP_NOIRQ);
+    }
+
+    if (gdbserver_state.supported_sstep_flags & SSTEP_NOTIMER) {
+        g_string_append_printf(gdbserver_state.str_buf, ",NOTIMER=%x",
+                               SSTEP_NOTIMER);
+    }
+
     put_strbuf();
 }
 
 static void handle_set_qemu_sstep(GArray *params, void *user_ctx)
 {
+    int new_sstep_flags;
+
     if (!params->len) {
         return;
     }
 
-    sstep_flags = get_param(params, 0)->val_ul;
+    new_sstep_flags = get_param(params, 0)->val_ul;
+
+    if (new_sstep_flags  & ~gdbserver_state.supported_sstep_flags) {
+        put_packet("E22");
+        return;
+    }
+
+    gdbserver_state.sstep_flags = new_sstep_flags;
     put_packet("OK");
 }
 
 static void handle_query_qemu_sstep(GArray *params, void *user_ctx)
 {
-    g_string_printf(gdbserver_state.str_buf, "0x%x", sstep_flags);
+    g_string_printf(gdbserver_state.str_buf, "0x%x",
+                    gdbserver_state.sstep_flags);
     put_strbuf();
 }
 
@@ -3493,6 +3528,11 @@ int gdbserver_start(const char *device)
         return -1;
     }
 
+    if (kvm_enabled() && !kvm_supports_guest_debug()) {
+        error_report("gdbstub: KVM doesn't support guest debugging");
+        return -1;
+    }
+
     if (!device)
         return -1;
     if (strcmp(device, "none") != 0) {
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index b3d4538c55..9c0665363d 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -47,6 +47,8 @@ extern bool kvm_readonly_mem_allowed;
 extern bool kvm_direct_msi_allowed;
 extern bool kvm_ioeventfd_any_length_allowed;
 extern bool kvm_msi_use_devid;
+extern bool kvm_has_guest_debug;
+extern int kvm_sstep_flags;
 
 #define kvm_enabled()           (kvm_allowed)
 /**
@@ -171,6 +173,17 @@ extern bool kvm_msi_use_devid;
  */
 #define kvm_msi_devid_required() (kvm_msi_use_devid)
 
+/*
+ * Does KVM support guest debugging
+ */
+#define kvm_supports_guest_debug() (kvm_has_guest_debug)
+
+/*
+ * kvm_supported_sstep_flags
+ * Returns: SSTEP_* flags that KVM supports for guest debug
+ */
+#define kvm_get_supported_sstep_flags() (kvm_sstep_flags)
+
 #else
 
 #define kvm_enabled()           (0)
-- 
2.26.3

