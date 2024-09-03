Return-Path: <kvm+bounces-25734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B73B969DF2
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 14:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C00CC1C22DFA
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 12:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920561D86F9;
	Tue,  3 Sep 2024 12:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HK0EC6mA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD8F1D86F7
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 12:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725367335; cv=none; b=vA9hrvVFhhoxo3UfZkJQKXQk1TkK+/jEU4BEBtQEtz7MAWuFj78D44vVTTN3sIPiiVoIa6zkt0BWEvKQDg/x+CIXiz26eU0x7Bm7R4romqwrrjjP2CB0fu3nbAdKdnYHGLbUjWQ6dX3Exh7YwkFYtB/zh1egdSsyuD4tr//Z2CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725367335; c=relaxed/simple;
	bh=LvuRG59WvDcSbKhXtTXWI7M1QnTZya38m+hIgWu6W/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjNqHmYVIXTVNHbibFfbnHK0pw5pFX6NGKVmjhcULKMSQNOMK/cbu6LNh7RqXTQ03FHC7AZm1brCK3z67ZSC1ppXlSMwVXQQ+9bptjRW732dW7mAfUEe/Ux+pNqql1w1R3URBgULEETtgXxkhhN9YKxOhMLQrhQhTZpyINsaA+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HK0EC6mA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725367332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r0as5Ez9pDXfQjAecZyDf6B3cpNpbSgXo6vc2nKXViw=;
	b=HK0EC6mAftTIAdhuZpp+0YtArwRjQYV7FP62Nh5EF9cxBqy3hyzC8OhTbNbTYdVb7/ogGm
	yISpAJF49Q6uuP8np7n2RYGhznnupjxv3lxg9g1G3pg+Sjtb0IoVfO1C0T5WZgbY4i+1FI
	RyiMYlT02c5wNK5Xsu/BM1VAfZzXM1k=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-5Eq3WSS6Otm6o_WbgN4h1Q-1; Tue, 03 Sep 2024 08:42:11 -0400
X-MC-Unique: 5Eq3WSS6Otm6o_WbgN4h1Q-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-205529c3402so28299005ad.0
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 05:42:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725367331; x=1725972131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r0as5Ez9pDXfQjAecZyDf6B3cpNpbSgXo6vc2nKXViw=;
        b=ZrZWWXyIimWzBJjnNrnrVNnWWp4RzkP2Bv/5w/bSNwNGia5gi7Q0+WHBQ/vOdyntBx
         H6S8lxk+UGnlUvpa0tWeYUYyDe+QaGVZVaMDPy2qhIonCGU5pOq6ChARAY8H2Wlc+mUj
         FxaIrJimS3XLfxKBf3NPx4w05XD64GUKQ2c0vVcO0EuhqGhh8Jnl1xB820F+RDM4XVni
         oT7uuuDOFT0+m0Noy0W3sGv3bFI8QRHNfKzETvWCIMSG/RA0jLHLTZxNfsC9Ev/fbiTG
         10MBpuHLvTA+WXynq9jU+xPCsd64RiIOqv2R9AVIUW4a0Ke0dx8NK5FHKaTOpxcC+5JO
         Jtcw==
X-Forwarded-Encrypted: i=1; AJvYcCUAes8o+wV0NRuutbwbAj97NsfqYuXfDjFi3kx0CxVWe+JIRHb99Kr+5AqGNpCX0RlGilE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiQVwD5luoP2jWvfzxn+RlYem1vQFskGYaNSmwK9zgtBbjR+PX
	iOhXgco4n/Xk3fEdEHigE+Q2uo6byZRBQJbwwbiLxZYI0YgiF8xljumNV6lsD6eZ1ZZU4X/WmRM
	6G2vo1134WY2LNe8/Z5VZAikvjn61zzkux7CoqtthjJpkGTAtbQ==
X-Received: by 2002:a17:902:d4c1:b0:205:913b:d9ad with SMTP id d9443c01a7336-205913bdac2mr36643215ad.0.1725367330560;
        Tue, 03 Sep 2024 05:42:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCl+LUoIJ3NX3VDoM316o1YCzocSyWl6ld5saLqH8chhArfps0WZWWhnAXMrWx4D3Fy/8NPw==
X-Received: by 2002:a17:902:d4c1:b0:205:913b:d9ad with SMTP id d9443c01a7336-205913bdac2mr36643035ad.0.1725367330107;
        Tue, 03 Sep 2024 05:42:10 -0700 (PDT)
Received: from localhost.localdomain ([115.96.207.26])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-20515542350sm80222025ad.213.2024.09.03.05.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 05:42:09 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH 1/2] kvm/i386: refactor kvm_arch_init and split it into smaller functions
Date: Tue,  3 Sep 2024 18:11:42 +0530
Message-ID: <20240903124143.39345-2-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240903124143.39345-1-anisinha@redhat.com>
References: <20240903124143.39345-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_arch_init() enables a lot of vm capabilities. Refactor them into separate
smaller functions. Energy MSR related operations also moved to its own
function. There should be no functional impact.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 337 ++++++++++++++++++++++++++----------------
 1 file changed, 211 insertions(+), 126 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 503e8d956e..574c62c21a 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2997,10 +2997,197 @@ int kvm_arch_get_default_type(MachineState *ms)
     return 0;
 }
 
+static int kvm_vm_enable_exception_payload(KVMState *s)
+{
+    int ret = 0;
+    has_exception_payload = kvm_check_extension(s, KVM_CAP_EXCEPTION_PAYLOAD);
+    if (has_exception_payload) {
+        ret = kvm_vm_enable_cap(s, KVM_CAP_EXCEPTION_PAYLOAD, 0, true);
+        if (ret < 0) {
+            error_report("kvm: Failed to enable exception payload cap: %s",
+                         strerror(-ret));
+        }
+    }
+
+    return ret;
+}
+
+static int kvm_vm_enable_triple_fault_event(KVMState *s)
+{
+    int ret = 0;
+    has_triple_fault_event = \
+        kvm_check_extension(s,
+                            KVM_CAP_X86_TRIPLE_FAULT_EVENT);
+    if (has_triple_fault_event) {
+        ret = kvm_vm_enable_cap(s, KVM_CAP_X86_TRIPLE_FAULT_EVENT, 0, true);
+        if (ret < 0) {
+            error_report("kvm: Failed to enable triple fault event cap: %s",
+                         strerror(-ret));
+        }
+    }
+    return ret;
+}
+
+static int kvm_vm_set_identity_map_addr(KVMState *s, uint64_t *identity_base)
+{
+    /*
+     * On older Intel CPUs, KVM uses vm86 mode to emulate 16-bit code directly.
+     * In order to use vm86 mode, an EPT identity map and a TSS  are needed.
+     * Since these must be part of guest physical memory, we need to allocate
+     * them, both by setting their start addresses in the kernel and by
+     * creating a corresponding e820 entry. We need 4 pages before the BIOS,
+     * so this value allows up to 16M BIOSes.
+     */
+    *identity_base = 0xfeffc000;
+    return kvm_vm_ioctl(s, KVM_SET_IDENTITY_MAP_ADDR, identity_base);
+}
+
+static int kvm_vm_set_nr_mmu_pages(KVMState *s)
+{
+    uint64_t shadow_mem;
+    int ret = 0;
+    shadow_mem = object_property_get_int(OBJECT(s),
+                                         "kvm-shadow-mem",
+                                         &error_abort);
+    if (shadow_mem != -1) {
+        shadow_mem /= 4096;
+        ret = kvm_vm_ioctl(s, KVM_SET_NR_MMU_PAGES, shadow_mem);
+    }
+    return ret;
+}
+
+static int kvm_vm_set_tss_addr(KVMState *s, uint64_t identity_base)
+{
+    /* Set TSS base one page after EPT identity map. */
+    return kvm_vm_ioctl(s, KVM_SET_TSS_ADDR, identity_base);
+}
+
+static int kvm_vm_enable_disable_exits(KVMState *s)
+{
+    int disable_exits = kvm_check_extension(s, KVM_CAP_X86_DISABLE_EXITS);
+/* Work around for kernel header with a typo. TODO: fix header and drop. */
+#if defined(KVM_X86_DISABLE_EXITS_HTL) && !defined(KVM_X86_DISABLE_EXITS_HLT)
+#define KVM_X86_DISABLE_EXITS_HLT KVM_X86_DISABLE_EXITS_HTL
+#endif
+    if (disable_exits) {
+        disable_exits &= (KVM_X86_DISABLE_EXITS_MWAIT |
+                          KVM_X86_DISABLE_EXITS_HLT |
+                          KVM_X86_DISABLE_EXITS_PAUSE |
+                          KVM_X86_DISABLE_EXITS_CSTATE);
+    }
+
+    return kvm_vm_enable_cap(s, KVM_CAP_X86_DISABLE_EXITS, 0,
+                             disable_exits);
+}
+
+static int kvm_vm_enable_bus_lock_exit(KVMState *s)
+{
+    int ret = 0;
+    ret = kvm_check_extension(s, KVM_CAP_X86_BUS_LOCK_EXIT);
+    if (!(ret & KVM_BUS_LOCK_DETECTION_EXIT)) {
+        error_report("kvm: bus lock detection unsupported");
+        return -ENOTSUP;
+    }
+    ret = kvm_vm_enable_cap(s, KVM_CAP_X86_BUS_LOCK_EXIT, 0,
+                            KVM_BUS_LOCK_DETECTION_EXIT);
+    if (ret < 0) {
+        error_report("kvm: Failed to enable bus lock detection cap: %s",
+                     strerror(-ret));
+    }
+
+    return ret;
+}
+
+static int kvm_vm_enable_notify_vmexit(KVMState *s)
+{
+    int ret = 0;
+    if (!kvm_check_extension(s, KVM_CAP_X86_NOTIFY_VMEXIT)) {
+        error_report("kvm: notify vmexit unsupported");
+        return -ENOTSUP;
+    }
+
+    if (s->notify_vmexit != NOTIFY_VMEXIT_OPTION_DISABLE) {
+        uint64_t notify_window_flags =
+            ((uint64_t)s->notify_window << 32) |
+            KVM_X86_NOTIFY_VMEXIT_ENABLED |
+            KVM_X86_NOTIFY_VMEXIT_USER;
+        ret = kvm_vm_enable_cap(s, KVM_CAP_X86_NOTIFY_VMEXIT, 0,
+                                notify_window_flags);
+        if (ret < 0) {
+            error_report("kvm: Failed to enable notify vmexit cap: %s",
+                         strerror(-ret));
+        }
+    }
+    return ret;
+}
+
+static int kvm_vm_enable_userspace_msr(KVMState *s)
+{
+    int ret;
+
+    if (!kvm_vm_check_extension(s, KVM_CAP_X86_USER_SPACE_MSR)) {
+        error_report("kvm: userspace MSR not supported");
+        return -ENOTSUP;
+    }
+
+    ret = kvm_vm_enable_cap(s, KVM_CAP_X86_USER_SPACE_MSR, 0,
+                            KVM_MSR_EXIT_REASON_FILTER);
+    if (ret < 0) {
+        error_report("Could not enable user space MSRs: %s",
+                     strerror(-ret));
+        exit(1);
+    }
+
+    if (!kvm_filter_msr(s, MSR_CORE_THREAD_COUNT,
+                        kvm_rdmsr_core_thread_count, NULL)) {
+        error_report("Could not install MSR_CORE_THREAD_COUNT handler!");
+        exit(1);
+    }
+
+    return 0;
+}
+
+static void kvm_vm_enable_energy_msrs(KVMState *s)
+{
+    bool r;
+    if (s->msr_energy.enable == true) {
+        r = kvm_filter_msr(s, MSR_RAPL_POWER_UNIT,
+                           kvm_rdmsr_rapl_power_unit, NULL);
+        if (!r) {
+            error_report("Could not install MSR_RAPL_POWER_UNIT \
+                                handler");
+            exit(1);
+        }
+
+        r = kvm_filter_msr(s, MSR_PKG_POWER_LIMIT,
+                           kvm_rdmsr_pkg_power_limit, NULL);
+        if (!r) {
+            error_report("Could not install MSR_PKG_POWER_LIMIT \
+                                handler");
+            exit(1);
+        }
+
+        r = kvm_filter_msr(s, MSR_PKG_POWER_INFO,
+                           kvm_rdmsr_pkg_power_info, NULL);
+        if (!r) {
+            error_report("Could not install MSR_PKG_POWER_INFO \
+                                handler");
+            exit(1);
+        }
+        r = kvm_filter_msr(s, MSR_PKG_ENERGY_STATUS,
+                           kvm_rdmsr_pkg_energy_status, NULL);
+        if (!r) {
+            error_report("Could not install MSR_PKG_ENERGY_STATUS \
+                                handler");
+            exit(1);
+        }
+    }
+    return;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     uint64_t identity_base = 0xfffbc000;
-    uint64_t shadow_mem;
     int ret;
     struct utsname utsname;
     Error *local_err = NULL;
@@ -3030,24 +3217,14 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
     hv_vpindex_settable = kvm_check_extension(s, KVM_CAP_HYPERV_VP_INDEX);
 
-    has_exception_payload = kvm_check_extension(s, KVM_CAP_EXCEPTION_PAYLOAD);
-    if (has_exception_payload) {
-        ret = kvm_vm_enable_cap(s, KVM_CAP_EXCEPTION_PAYLOAD, 0, true);
-        if (ret < 0) {
-            error_report("kvm: Failed to enable exception payload cap: %s",
-                         strerror(-ret));
-            return ret;
-        }
+    ret = kvm_vm_enable_exception_payload(s);
+    if (ret < 0) {
+        return ret;
     }
 
-    has_triple_fault_event = kvm_check_extension(s, KVM_CAP_X86_TRIPLE_FAULT_EVENT);
-    if (has_triple_fault_event) {
-        ret = kvm_vm_enable_cap(s, KVM_CAP_X86_TRIPLE_FAULT_EVENT, 0, true);
-        if (ret < 0) {
-            error_report("kvm: Failed to enable triple fault event cap: %s",
-                         strerror(-ret));
-            return ret;
-        }
+    ret = kvm_vm_enable_triple_fault_event(s);
+    if (ret < 0) {
+        return ret;
     }
 
     if (s->xen_version) {
@@ -3078,22 +3255,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     uname(&utsname);
     lm_capable_kernel = strcmp(utsname.machine, "x86_64") == 0;
 
-    /*
-     * On older Intel CPUs, KVM uses vm86 mode to emulate 16-bit code directly.
-     * In order to use vm86 mode, an EPT identity map and a TSS  are needed.
-     * Since these must be part of guest physical memory, we need to allocate
-     * them, both by setting their start addresses in the kernel and by
-     * creating a corresponding e820 entry. We need 4 pages before the BIOS,
-     * so this value allows up to 16M BIOSes.
-     */
-    identity_base = 0xfeffc000;
-    ret = kvm_vm_ioctl(s, KVM_SET_IDENTITY_MAP_ADDR, &identity_base);
+    ret = kvm_vm_set_identity_map_addr(s, &identity_base);
     if (ret < 0) {
         return ret;
     }
 
-    /* Set TSS base one page after EPT identity map. */
-    ret = kvm_vm_ioctl(s, KVM_SET_TSS_ADDR, identity_base + 0x1000);
+    ret = kvm_vm_set_tss_addr(s, identity_base + 0x1000);
     if (ret < 0) {
         return ret;
     }
@@ -3101,13 +3268,9 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     /* Tell fw_cfg to notify the BIOS to reserve the range. */
     e820_add_entry(identity_base, 0x4000, E820_RESERVED);
 
-    shadow_mem = object_property_get_int(OBJECT(s), "kvm-shadow-mem", &error_abort);
-    if (shadow_mem != -1) {
-        shadow_mem /= 4096;
-        ret = kvm_vm_ioctl(s, KVM_SET_NR_MMU_PAGES, shadow_mem);
-        if (ret < 0) {
-            return ret;
-        }
+    ret = kvm_vm_set_nr_mmu_pages(s);
+    if (ret < 0) {
+        return ret;
     }
 
     if (kvm_check_extension(s, KVM_CAP_X86_SMM) &&
@@ -3118,20 +3281,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     }
 
     if (enable_cpu_pm) {
-        int disable_exits = kvm_check_extension(s, KVM_CAP_X86_DISABLE_EXITS);
-/* Work around for kernel header with a typo. TODO: fix header and drop. */
-#if defined(KVM_X86_DISABLE_EXITS_HTL) && !defined(KVM_X86_DISABLE_EXITS_HLT)
-#define KVM_X86_DISABLE_EXITS_HLT KVM_X86_DISABLE_EXITS_HTL
-#endif
-        if (disable_exits) {
-            disable_exits &= (KVM_X86_DISABLE_EXITS_MWAIT |
-                              KVM_X86_DISABLE_EXITS_HLT |
-                              KVM_X86_DISABLE_EXITS_PAUSE |
-                              KVM_X86_DISABLE_EXITS_CSTATE);
-        }
-
-        ret = kvm_vm_enable_cap(s, KVM_CAP_X86_DISABLE_EXITS, 0,
-                                disable_exits);
+        ret = kvm_vm_enable_disable_exits(s);
         if (ret < 0) {
             error_report("kvm: guest stopping CPU not supported: %s",
                          strerror(-ret));
@@ -3142,16 +3292,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         X86MachineState *x86ms = X86_MACHINE(ms);
 
         if (x86ms->bus_lock_ratelimit > 0) {
-            ret = kvm_check_extension(s, KVM_CAP_X86_BUS_LOCK_EXIT);
-            if (!(ret & KVM_BUS_LOCK_DETECTION_EXIT)) {
-                error_report("kvm: bus lock detection unsupported");
-                return -ENOTSUP;
-            }
-            ret = kvm_vm_enable_cap(s, KVM_CAP_X86_BUS_LOCK_EXIT, 0,
-                                    KVM_BUS_LOCK_DETECTION_EXIT);
+            ret = kvm_vm_enable_bus_lock_exit(s);
             if (ret < 0) {
-                error_report("kvm: Failed to enable bus lock detection cap: %s",
-                             strerror(-ret));
                 return ret;
             }
             ratelimit_init(&bus_lock_ratelimit_ctrl);
@@ -3160,80 +3302,23 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
-    if (s->notify_vmexit != NOTIFY_VMEXIT_OPTION_DISABLE &&
-        kvm_check_extension(s, KVM_CAP_X86_NOTIFY_VMEXIT)) {
-            uint64_t notify_window_flags =
-                ((uint64_t)s->notify_window << 32) |
-                KVM_X86_NOTIFY_VMEXIT_ENABLED |
-                KVM_X86_NOTIFY_VMEXIT_USER;
-            ret = kvm_vm_enable_cap(s, KVM_CAP_X86_NOTIFY_VMEXIT, 0,
-                                    notify_window_flags);
-            if (ret < 0) {
-                error_report("kvm: Failed to enable notify vmexit cap: %s",
-                             strerror(-ret));
-                return ret;
-            }
+    ret = kvm_vm_enable_notify_vmexit(s);
+    if (ret < 0) {
+        return ret;
     }
-    if (kvm_vm_check_extension(s, KVM_CAP_X86_USER_SPACE_MSR)) {
-        bool r;
 
-        ret = kvm_vm_enable_cap(s, KVM_CAP_X86_USER_SPACE_MSR, 0,
-                                KVM_MSR_EXIT_REASON_FILTER);
-        if (ret) {
-            error_report("Could not enable user space MSRs: %s",
-                         strerror(-ret));
-            exit(1);
-        }
-
-        r = kvm_filter_msr(s, MSR_CORE_THREAD_COUNT,
-                           kvm_rdmsr_core_thread_count, NULL);
-        if (!r) {
-            error_report("Could not install MSR_CORE_THREAD_COUNT handler: %s",
-                         strerror(-ret));
-            exit(1);
+    if (kvm_vm_check_extension(s, KVM_CAP_X86_USER_SPACE_MSR)) {
+        ret = kvm_vm_enable_userspace_msr(s);
+        if (ret < 0) {
+            return ret;
         }
 
         if (s->msr_energy.enable == true) {
-            r = kvm_filter_msr(s, MSR_RAPL_POWER_UNIT,
-                               kvm_rdmsr_rapl_power_unit, NULL);
-            if (!r) {
-                error_report("Could not install MSR_RAPL_POWER_UNIT \
-                                handler: %s",
-                             strerror(-ret));
-                exit(1);
-            }
-
-            r = kvm_filter_msr(s, MSR_PKG_POWER_LIMIT,
-                               kvm_rdmsr_pkg_power_limit, NULL);
-            if (!r) {
-                error_report("Could not install MSR_PKG_POWER_LIMIT \
-                                handler: %s",
-                             strerror(-ret));
-                exit(1);
-            }
-
-            r = kvm_filter_msr(s, MSR_PKG_POWER_INFO,
-                               kvm_rdmsr_pkg_power_info, NULL);
-            if (!r) {
-                error_report("Could not install MSR_PKG_POWER_INFO \
-                                handler: %s",
-                             strerror(-ret));
+            kvm_vm_enable_energy_msrs(s);
+            if (kvm_msr_energy_thread_init(s, ms)) {
+                error_report("kvm : error RAPL feature requirement not met");
                 exit(1);
             }
-            r = kvm_filter_msr(s, MSR_PKG_ENERGY_STATUS,
-                               kvm_rdmsr_pkg_energy_status, NULL);
-            if (!r) {
-                error_report("Could not install MSR_PKG_ENERGY_STATUS \
-                                handler: %s",
-                             strerror(-ret));
-                exit(1);
-            }
-            r = kvm_msr_energy_thread_init(s, ms);
-            if (r) {
-                error_report("kvm : error RAPL feature requirement not meet");
-                exit(1);
-            }
-
         }
     }
 
-- 
2.42.0


