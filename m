Return-Path: <kvm+bounces-70904-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uOEtOIxyjWn42gAAu9opvQ
	(envelope-from <kvm+bounces-70904-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A73F12A966
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 144C8308EEF5
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2AB128C862;
	Thu, 12 Feb 2026 06:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MD4dot7b";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="G+qCjEBQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949A328BAB9
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877557; cv=none; b=EX8r0TNHvWbZSBMG19loYylKkrlh1BTk59ZKgF4CeJSQ0TemXcbkvszG42QU42FTlagJqO3LrSZWoJvNdp8AGCGuxbpasjmIru1jxm6utCDAxMoLCS5qKiSmqmB/yhvIgNKvGViHjivSKnxqMoRoWbvqVxwYApru6YjwSGugrcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877557; c=relaxed/simple;
	bh=rh0TEAWjgYuqWpdXcTKGWf0OXP741pk1GsoZQOumwfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oy9egEdX8OSkx+ckW+fW6FEnEhKwQ41f8Ep7/ADD7+HmNBMlSh9MZYak13Ip5C6MGqNYIiTlCAlhHZfKcNx8XJVx7muHvO+JzGU1rFYdKAp4qYvEg0bgp6sPgetfxT/c3VeAjQtpaidGXsG/8Hmmp87swUv1vNnr36SzsPAU70w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MD4dot7b; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=G+qCjEBQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J/oOoBR4IfX+ZbFVC/5tNcGKvnGUc2oW6vwtrqPYGD4=;
	b=MD4dot7bFyL4d+oKd2i6KKGzQwNwfvzjfT2vDjdq4iP86hs604F6midtf+1u9bHgbZAGgY
	qYLMpIQPEA7WnLh063lzeybam7KVbIgsSABF5gujs0RHiLARRxlWbLFP8ajT+mF4ax6HDH
	RaKv1ecP9goUWBuS6uvAimLKa67fOc8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-qqA9DSEyNB22fzXZkcSsoA-1; Thu, 12 Feb 2026 01:25:52 -0500
X-MC-Unique: qqA9DSEyNB22fzXZkcSsoA-1
X-Mimecast-MFC-AGG-ID: qqA9DSEyNB22fzXZkcSsoA_1770877552
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a755a780caso11316765ad.0
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877551; x=1771482351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J/oOoBR4IfX+ZbFVC/5tNcGKvnGUc2oW6vwtrqPYGD4=;
        b=G+qCjEBQ5SDenvcweoglq7Roq3kyC5aGan59dgW0kr2tBSvSgfVUNV3tANZIGeqVpP
         136ctuA4068OsplkNicEjcX+taZllOtQIM20knuD2zF1e37fkMP3c7/71xR39Lo3CIg+
         eBB6ngUQg77EX2QnHeXsYIlzXPXQ6fwcQWakZEmp3lP0VWmk3tjSfHVUvCX8we/Wkc5r
         RUXCksdEIOnGrbUxB8KjeScXE8wLZnvsW9x8rbBMpTQMHqG4SjtcD/c2Y1eZvo+sqBgf
         ucQMrl8DHmuax1jc3l6Daz+0Lm8GYNuRJAsNdsBYTW7PBgpKTv0LnILRjvB7aGT7+t1P
         rwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877551; x=1771482351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J/oOoBR4IfX+ZbFVC/5tNcGKvnGUc2oW6vwtrqPYGD4=;
        b=EniLv72iAnweZ4an9HUXItiwum3ZPz6pTDe/u5JkAhgO6/y2kPze/CSMudO3WX0XNN
         7PngDZp8L2QalmpnKp7xrRxh0lrhGo87yF4afPVc/2cuYQh4xf5k/jQY8nvZyvSydCaV
         W2skl2Y4nJ3frleGAvuM3Q/boQObtbNanOnQQsQvMIlscaVk0r3Lz1hr1QvhvxpFK3rT
         WOd/ltJqE0a6xIcGKeT0JJKosQAejL0DMleGP6R4xvHvowim1SgM3a+EhhT5oafNIUJl
         /EGPjlRMu8oI+EyaDBQU7mddb0rR/tiL8IB3fulGe+8h26ApYCeWPEyg9MKaZfushhf7
         K2Pw==
X-Forwarded-Encrypted: i=1; AJvYcCWjTs4H7a49t9YNj49pUjoWFzPPnZaQL59fy2ZXQr4ULblZVxrP8eGa/CfW3fka+tY5SrY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUbSGNYe3+r3+g8xc/nWaocR7EyQJsPmB4qmQnCYRY45ndRSo7
	Z+fWz+JajX9f3+mnRtdkrWmULS2IPmP+GeOsBx6TkMNnYOwHtA69A0nc18cBBajUxkEHcVV1TWx
	oDCJ9mNzcHe0qYydH++m4CVfdBNJjj2aUuJCbIIaF+G171hQpQNRGyBdG2TtafQ==
X-Gm-Gg: AZuq6aJ8oOjykI3XxZeostbJVSHN47d4RalHoNh6kKTYZLpBimJ1mgzjaeQojlkM6TB
	9nagv6DKlJvHoq8Xg2CQv935wVoShrcSoBCsitOYWHy0HEVqJJrlQSUkFoZnJTuZU75o2v7hPht
	IGpw0sbGQBiVEQYaHREvh2CK1ITKGRQNOhy9ctxJSUT0H0h3rGPiX3l8a3pzJ9TSmkf2DyRIIhm
	Pfwm6jLDlcHF2FI2X6lgSXwpGyLfbKLOJk75gEDX0Op6q+rbKH0r1N6ZdZH59sTgosjrAMJASdi
	JxWIQXdVAg4RDrOTJ137nwI6JKHFcM7R3KvvwUGCAelP0sY9glUPTVQLz5AOAeyCan0IN1ptskj
	7AnDUEU8F2RYuy0gOYA+avqJ1ovjKN6lOirh8q34usSrrhPTVDfHj0YQ=
X-Received: by 2002:a17:902:e948:b0:2aa:f5b4:9a2e with SMTP id d9443c01a7336-2ab3a667bacmr14492465ad.11.1770877551318;
        Wed, 11 Feb 2026 22:25:51 -0800 (PST)
X-Received: by 2002:a17:902:e948:b0:2aa:f5b4:9a2e with SMTP id d9443c01a7336-2ab3a667bacmr14492235ad.11.1770877550902;
        Wed, 11 Feb 2026 22:25:50 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:25:50 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v4 05/31] accel/kvm: add changes required to support KVM VM file descriptor change
Date: Thu, 12 Feb 2026 11:54:49 +0530
Message-ID: <20260212062522.99565-6-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260212062522.99565-1-anisinha@redhat.com>
References: <20260212062522.99565-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70904-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5A73F12A966
X-Rspamd-Action: no action

This change adds common kvm specific support to handle KVM VM file descriptor
change. KVM VM file descriptor can change as a part of confidential guest reset
mechanism. A new function api kvm_arch_on_vmfd_change() per
architecture platform is added in order to implement architecture specific
changes required to support it. A subsequent patch will add x86 specific
implementation for kvm_arch_on_vmfd_change() as currently only x86 supports
confidential guest reset.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 MAINTAINERS            |  6 ++++
 accel/kvm/kvm-all.c    | 80 ++++++++++++++++++++++++++++++++++++++++--
 accel/kvm/trace-events |  1 +
 include/system/kvm.h   |  3 ++
 stubs/kvm.c            | 22 ++++++++++++
 stubs/meson.build      |  1 +
 target/i386/kvm/kvm.c  | 10 ++++++
 7 files changed, 120 insertions(+), 3 deletions(-)
 create mode 100644 stubs/kvm.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 65ac60b86b..a88901a7d7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -152,6 +152,12 @@ F: tools/i386/
 F: tests/functional/i386/
 F: tests/functional/x86_64/
 
+X86 VM file descriptor change on reset test
+M: Ani Sinha <anisinha@redhat.com>
+M: Paolo Bonzini <pbonzini@redhat.com>
+S: Maintained
+F: stubs/kvm.c
+
 Guest CPU cores (TCG)
 ---------------------
 Overall TCG CPUs
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 8301a512e7..46243cfcf2 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2415,11 +2415,9 @@ void kvm_irqchip_set_qemuirq_gsi(KVMState *s, qemu_irq irq, int gsi)
     g_hash_table_insert(s->gsimap, irq, GINT_TO_POINTER(gsi));
 }
 
-static void kvm_irqchip_create(KVMState *s)
+static void do_kvm_irqchip_create(KVMState *s)
 {
     int ret;
-
-    assert(s->kernel_irqchip_split != ON_OFF_AUTO_AUTO);
     if (kvm_check_extension(s, KVM_CAP_IRQCHIP)) {
         ;
     } else if (kvm_check_extension(s, KVM_CAP_S390_IRQCHIP)) {
@@ -2452,7 +2450,13 @@ static void kvm_irqchip_create(KVMState *s)
         fprintf(stderr, "Create kernel irqchip failed: %s\n", strerror(-ret));
         exit(1);
     }
+}
 
+static void kvm_irqchip_create(KVMState *s)
+{
+    assert(s->kernel_irqchip_split != ON_OFF_AUTO_AUTO);
+
+    do_kvm_irqchip_create(s);
     kvm_kernel_irqchip = true;
     /* If we have an in-kernel IRQ chip then we must have asynchronous
      * interrupt delivery (though the reverse is not necessarily true)
@@ -2607,6 +2611,75 @@ static int kvm_setup_dirty_ring(KVMState *s)
     return 0;
 }
 
+static int kvm_reset_vmfd(MachineState *ms)
+{
+    KVMState *s;
+    KVMMemoryListener *kml;
+    int ret = 0, type;
+    Error *err = NULL;
+
+    /*
+     * bail if the current architecture does not support VM file
+     * descriptor change.
+     */
+    if (!kvm_arch_supports_vmfd_change()) {
+        error_report("This target architecture does not support KVM VM "
+                     "file descriptor change.");
+        return -EOPNOTSUPP;
+    }
+
+    s = KVM_STATE(ms->accelerator);
+    kml = &s->memory_listener;
+
+    memory_listener_unregister(&kml->listener);
+    memory_listener_unregister(&kvm_io_listener);
+
+    if (s->vmfd >= 0) {
+        close(s->vmfd);
+    }
+
+    type = find_kvm_machine_type(ms);
+    if (type < 0) {
+        return -EINVAL;
+    }
+
+    ret = do_kvm_create_vm(s, type);
+    if (ret < 0) {
+        return ret;
+    }
+
+    s->vmfd = ret;
+
+    kvm_setup_dirty_ring(s);
+
+    /* rebind memory to new vm fd */
+    ret = ram_block_rebind(&err);
+    if (ret < 0) {
+        return ret;
+    }
+    assert(!err);
+
+    ret = kvm_arch_on_vmfd_change(ms, s);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (s->kernel_irqchip_allowed) {
+        do_kvm_irqchip_create(s);
+    }
+
+    /* these can be only called after ram_block_rebind() */
+    memory_listener_register(&kml->listener, &address_space_memory);
+    memory_listener_register(&kvm_io_listener, &address_space_io);
+
+    /*
+     * kvm fd has changed. Commit the irq routes to KVM once more.
+     */
+    kvm_irqchip_commit_routes(s);
+    trace_kvm_reset_vmfd();
+    return ret;
+}
+
 static int kvm_init(AccelState *as, MachineState *ms)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
@@ -4014,6 +4087,7 @@ static void kvm_accel_class_init(ObjectClass *oc, const void *data)
     AccelClass *ac = ACCEL_CLASS(oc);
     ac->name = "KVM";
     ac->init_machine = kvm_init;
+    ac->reset_vmfd = kvm_reset_vmfd;
     ac->has_memory = kvm_accel_has_memory;
     ac->allowed = &kvm_allowed;
     ac->gdbstub_supported_sstep_flags = kvm_gdbstub_sstep_flags;
diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
index e43d18a869..e4beda0148 100644
--- a/accel/kvm/trace-events
+++ b/accel/kvm/trace-events
@@ -14,6 +14,7 @@ kvm_destroy_vcpu(int cpu_index, unsigned long arch_cpu_id) "index: %d id: %lu"
 kvm_park_vcpu(int cpu_index, unsigned long arch_cpu_id) "index: %d id: %lu"
 kvm_unpark_vcpu(unsigned long arch_cpu_id, const char *msg) "id: %lu %s"
 kvm_irqchip_commit_routes(void) ""
+kvm_reset_vmfd(void) ""
 kvm_irqchip_add_msi_route(char *name, int vector, int virq) "dev %s vector %d virq %d"
 kvm_irqchip_update_msi_route(int virq) "Updating MSI route virq=%d"
 kvm_irqchip_release_virq(int virq) "virq %d"
diff --git a/include/system/kvm.h b/include/system/kvm.h
index 8f9eecf044..5fc7251fd9 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -456,6 +456,9 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
 
 #endif /* COMPILING_PER_TARGET */
 
+bool kvm_arch_supports_vmfd_change(void);
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s);
+
 void kvm_cpu_synchronize_state(CPUState *cpu);
 
 void kvm_init_cpu_signals(CPUState *cpu);
diff --git a/stubs/kvm.c b/stubs/kvm.c
new file mode 100644
index 0000000000..2db61d89a7
--- /dev/null
+++ b/stubs/kvm.c
@@ -0,0 +1,22 @@
+/*
+ * kvm target arch specific stubs
+ *
+ * Copyright (c) 2026 Red Hat, Inc.
+ *
+ * Author:
+ *   Ani Sinha <anisinha@redhat.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#include "qemu/osdep.h"
+#include "system/kvm.h"
+
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
diff --git a/stubs/meson.build b/stubs/meson.build
index 8a07059500..6ae478bacc 100644
--- a/stubs/meson.build
+++ b/stubs/meson.build
@@ -74,6 +74,7 @@ if have_system
   if igvm.found()
     stub_ss.add(files('igvm.c'))
   endif
+  stub_ss.add(files('kvm.c'))
   stub_ss.add(files('target-get-monitor-def.c'))
   stub_ss.add(files('target-monitor-defs.c'))
   stub_ss.add(files('win32-kbd-hook.c'))
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index da1ed3b62a..83c15f098e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3252,6 +3252,16 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
     return 0;
 }
 
+int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     int ret;
-- 
2.42.0


