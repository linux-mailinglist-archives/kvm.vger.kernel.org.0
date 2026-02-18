Return-Path: <kvm+bounces-71224-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sBRkE92llWn4SwIAu9opvQ
	(envelope-from <kvm+bounces-71224-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A48DB155F7E
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 385A83011BE7
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51C4630DEAA;
	Wed, 18 Feb 2026 11:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cnnm872S";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BIA2mk3v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3D82FFDD5
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771414986; cv=none; b=Dd6i09p8c+Fn266F9S5L4EUj63s0mt09C1ZBSIYrWZw8iDpF2HswwyPqPyPoLEyHQNOTC+qqlShS85XCP9gZDX5ql/b4LCngcbZbKQ+VXLHJubTvDj4n2ieemfLrCTYh4BloBeaXDjA/7YWa/+Dttf5Nf84rlDM7zKtPAWGDTzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771414986; c=relaxed/simple;
	bh=oELSwyTXYw+8KZm8yun1u/JNqIMCUhrtGc2xrlfVfWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOwIhlpyhkUmrPqPFZ3BUWLApxFwf8+fyrQ88t98lY7ZLcCnSywwRB2EoLtQEchAUQlpB0TA6GbMmVFeAJj1dBhJIu1HiyUvDNa81rdllqcAJH/9UwVcvB8JLhQh69rBW7cyTeRCuxjMmr8oP5MAJA9hmkajl4rDrDnz01HcvHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cnnm872S; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BIA2mk3v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771414984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vfhdy46mQEUlcerqq6xzArv8NlC5Gx5+51xsaBuia6g=;
	b=Cnnm872SjsAj2hQt+Y6DX3UU9I5432aGIuUVygOXFkR+Zlbm1aitZAxnzjBiyEZOMHSxyd
	t808AFo2C8vWrF7N3tFs0+PUb6H3xqlFnmKXwDaq9bAfsVWdCoEN/brbxNIKKCIwTxPAFX
	EUgqy7ueFkiFAYFDgP0N0DX3ZwLxbok=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-_Fpx-7PIO_yAHkOk6xva5w-1; Wed, 18 Feb 2026 06:43:03 -0500
X-MC-Unique: _Fpx-7PIO_yAHkOk6xva5w-1
X-Mimecast-MFC-AGG-ID: _Fpx-7PIO_yAHkOk6xva5w_1771414982
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2aae146bab0so63746775ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771414982; x=1772019782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vfhdy46mQEUlcerqq6xzArv8NlC5Gx5+51xsaBuia6g=;
        b=BIA2mk3vM7y70X734Rt8Ag6+3MhjTBVUM4hZtPqWIIXNVnpJ2q9oApT5UkzxsXCjkp
         3PxOLAya0oueQDcdMjfDrjz1ZzkGRnvb++nkuoqIlby0wB5FB203TNUz0lWLZ8IAFsqB
         q/NuyuVB9mmf8tfCkC6A7GkaPevSrZetythR8kOIl2HFb3Qc9uSO/iUDTBp1MHuOKdyC
         iPZD0QsvCOsxV3IBmVQk3E4U37YbZawyYtH+ElutH2U7Q/hD9RgG/addRI6AQUBBSZP/
         BW1c+iSl4gNWtMNVB79z9eRzy/Uyyi5G4lUsHYpOsNk7DkIpErk8xn+eBc1oD1EJRepK
         AY0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771414982; x=1772019782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vfhdy46mQEUlcerqq6xzArv8NlC5Gx5+51xsaBuia6g=;
        b=iCexjmnshSFBq9laQLNeePpO9xZQhdPEMDyp+bf8T5NZbh7Yi5OgxDmkZ+sFgv/UQ1
         bcrvUzHgQhcdKTRVXNf7WFkoVOEEQrHx21uhkrTEywaAIVyyxmqMAjP3Hvk0DhAnF2ZT
         uiQb0tVFIRNDssVtThDqa59G74nQfO90NMeEb5Zw+x1JV7ZP7F5R7AXD5c2UalDWbB/j
         BVCYKx54bKzg8hNT6oS2rtOf6mpBc5ScN+Ii5/cV/HyMzvuoUpWT4dczu5Rd+KAq7j0T
         GhccS/dioaWa+RcCXfcofVjkqBMqXw372AqkMWBvfdsVtKe5en/JgERBQYCqaONfWFC2
         Oc2w==
X-Forwarded-Encrypted: i=1; AJvYcCVA7x2r6vXDQviqrrU1FOffKVqrzZmtIuGfb9I93fZ92O3R74ebCy2iRMjuY193TQRk9pM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOiylUOLwbiPVNV1TNhNpYQJqqKowF3MqKwvNU0/6eaUt9aItX
	bC1eWqvkdI8HVuVIu/ANJMQUVSI8iQ7LfIMnx+g37IOQIvSDUG1vz9zlLQ3EBmTkrHI2hpsiKsR
	3GkANdMqKPKziTm9F1TvYvvCt/SmAeZbTAVJXPHWSzoqs1DtDkWuCVQ==
X-Gm-Gg: AZuq6aIuCMofEUiPCXuJnRUhIEhYf0XS8Ynxw19xjQq5CaSkUCQd1e68etz7EwHXKRS
	dgSVRLpGEwZeyWde3HMB+RL3nSega2KYTR9HBHTCvbRNXFqHUM0/BV0BB1jPjw4gmM8PtIiIzZF
	YE3BuBckIHI90872V4DNYKyP5MUZnmouYoyNNAzPsVJFuoF4R8lFSaKIykYy2tHFI+tpBB5YchI
	EQFgUjrNOoXi/mXPDl1EaVbuoNtPq8qh94rwQpVP9oxwj1bzyz4wQZ1ha2hsorB1MsPzgrnkyiP
	+tYaF2KysHxqibS3wTsukZRWsCLfv8UbJY+5e7p9b7q1wVzfFQURPhWHU1SvF9SJT4ukTNiSeZi
	pWHG5cTWvpyR564+B5ilStTmpKgXCEdObf/Z2vXyf2/rt/fXBsI9M
X-Received: by 2002:a17:902:d509:b0:29f:301a:f6cf with SMTP id d9443c01a7336-2ab505c056emr182651435ad.35.1771414981947;
        Wed, 18 Feb 2026 03:43:01 -0800 (PST)
X-Received: by 2002:a17:902:d509:b0:29f:301a:f6cf with SMTP id d9443c01a7336-2ab505c056emr182651275ad.35.1771414981518;
        Wed, 18 Feb 2026 03:43:01 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:43:01 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v5 05/34] accel/kvm: add changes required to support KVM VM file descriptor change
Date: Wed, 18 Feb 2026 17:11:58 +0530
Message-ID: <20260218114233.266178-6-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260218114233.266178-1-anisinha@redhat.com>
References: <20260218114233.266178-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71224-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A48DB155F7E
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
index d3aa6d6732..b0eb77c08f 100644
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
index 0d8b0c4347..14729666a0 100644
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
@@ -4015,6 +4088,7 @@ static void kvm_accel_class_init(ObjectClass *oc, const void *data)
     AccelClass *ac = ACCEL_CLASS(oc);
     ac->name = "KVM";
     ac->init_machine = kvm_init;
+    ac->rebuild_guest = kvm_reset_vmfd;
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
index 6d823a7991..a4e18734b1 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3389,6 +3389,16 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
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


