Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8735441BAC
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 14:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhKAN0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 09:26:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231284AbhKAN0X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 09:26:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635773029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dlfkfR7valJmupC8LTq2dvfX9MmFTnhGhlCiE80Vxfs=;
        b=CClH4UaWiewIXJCmZvRo7PI7i2h9Kiw/GPhS7KXRorlRBh85j9s2TykGf74d1GCHsiXwt1
        UrFyXoN4rhMSVvQj7DmGbHdZ1/03W/jmQV6PaYJTq8icpnI2755lXtNPy+lq/0GH3EjBXz
        oDArV1OzZvIHCeK6XgZskR5UVYAsQnw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-8jVxb51DMluVr4epqV-TWQ-1; Mon, 01 Nov 2021 09:23:46 -0400
X-MC-Unique: 8jVxb51DMluVr4epqV-TWQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DB16100B3B2;
        Mon,  1 Nov 2021 13:23:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A33B960C0F;
        Mon,  1 Nov 2021 13:23:24 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/3] gdbstub: implement NOIRQ support for single step on KVM
Date:   Mon,  1 Nov 2021 15:22:59 +0200
Message-Id: <20211101132300.192584-3-mlevitsk@redhat.com>
In-Reply-To: <20211101132300.192584-1-mlevitsk@redhat.com>
References: <20211101132300.192584-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 accel/kvm/kvm-all.c  | 25 ++++++++++++++++++
 gdbstub.c            | 62 ++++++++++++++++++++++++++++++++++++--------
 include/sysemu/kvm.h | 15 +++++++++++
 3 files changed, 91 insertions(+), 11 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 5558786d3d..a92c12da6f 100644
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
 
@@ -2562,6 +2564,25 @@ static int kvm_init(MachineState *ms)
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
@@ -3191,6 +3212,10 @@ int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
 
     if (cpu->singlestep_enabled) {
         data.dbg.control |= KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLESTEP;
+
+        if (cpu->singlestep_enabled & SSTEP_NOIRQ) {
+            data.dbg.control |= KVM_GUESTDBG_BLOCKIRQ;
+        }
     }
     kvm_arch_update_guest_debug(cpu, &data.dbg);
 
diff --git a/gdbstub.c b/gdbstub.c
index 36b85aa50e..ad088fbd3e 100644
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
@@ -505,7 +520,7 @@ static int gdb_continue_partial(char *newstates)
     CPU_FOREACH(cpu) {
         if (newstates[cpu->cpu_index] == 's') {
             trace_gdbstub_op_stepping(cpu->cpu_index);
-            cpu_single_step(cpu, sstep_flags);
+            cpu_single_step(cpu, get_sstep_flags());
         }
     }
     gdbserver_state.running_state = 1;
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
index b3d4538c55..2eb5b4d68d 100644
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
@@ -188,6 +201,8 @@ extern bool kvm_msi_use_devid;
 #define kvm_direct_msi_enabled() (false)
 #define kvm_ioeventfd_any_length_enabled() (false)
 #define kvm_msi_devid_required() (false)
+#define kvm_supports_guest_debug() (false)
+#define kvm_get_supported_sstep_flags() (0)
 
 #endif  /* CONFIG_KVM_IS_POSSIBLE */
 
-- 
2.26.3

