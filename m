Return-Path: <kvm+bounces-67738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DBD13D12C45
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:25:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 957EC301D8A3
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD07359F84;
	Mon, 12 Jan 2026 13:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lh87aMuD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QynTQ+K+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5827359FAD
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224235; cv=none; b=amYPiBujn3Oo7PIIGuGEU3qNIiZI0fZaVgkkRXAg6PajRtlAmQhnVFUMNV4PB/BEzDrOW33JTs5vmZh1EqXoIH22K+uPvIC2EoML8osn4UaJBc3FaICW/ASnX1eWRIY+S4A/MHwjEeoXFYH5V1CDZZQ3XrTRuqaxvV58S+8X568=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224235; c=relaxed/simple;
	bh=WH7g/lfXqzEE3G7j4k735JI1UZo8u2rMxEnlgtqYRF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLVCzwMW0ilOvg9GbYxr0N5UOeMiMLYBo1K3ASrxKMOwR5iLVDgVR3e8Ur83XhuAOCp2kb48uRQeMILJzaNFWU129Ts3QY1ygvo5/s2WC8D8L2MEGnpCK9wQebUJS3wnyTT/3upR2GJxY8CFHrqCkfSxCMpK+SUXjqVF3tMKq4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lh87aMuD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QynTQ+K+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zl/mQjtvR/EBMVt9nhPm03gwedh0vVVOzpLgcWm0+Gg=;
	b=Lh87aMuDpr4hIju7M+W+3l7hEn0X2DUpn6kTshrXSrI8FU5r5BNeHrclPcHSJQVUv3mY/g
	bi5y09H6/YLcS8Rt/SEF93fLWPxPLXxHezg9z4y30QZDBd4JhUDewUl/GbUWLTSS2MA7Uh
	i+F05GqS36IV/Rfa45NphU3zwcJprlU=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-pwxjjTORPdu2VFfxtC8Y2w-1; Mon, 12 Jan 2026 08:23:51 -0500
X-MC-Unique: pwxjjTORPdu2VFfxtC8Y2w-1
X-Mimecast-MFC-AGG-ID: pwxjjTORPdu2VFfxtC8Y2w_1768224231
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c56848e6f45so1497837a12.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224230; x=1768829030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zl/mQjtvR/EBMVt9nhPm03gwedh0vVVOzpLgcWm0+Gg=;
        b=QynTQ+K+fdZRSYT0A3Z1sZQC693+vl1mQ2Zd8kx6STHxxY6AiC0WhcvkYvaLvyKcTz
         Bv1Z7aQOuhAc6Y0oUW8KdXa28egOTUfVIp1VrQsuMrtns3udXfZydOtQ6IVJBJHo20t/
         poX1Ti/WtdthZXVOaHZGflGesFKjIjhCbg0AKJ7bT0VVHSs02MVi2tdRmxQMVIINOf5N
         b/pFwzu696lW6hbk0ScTtW9D14vTiBzluyOsN7R9VqwC4cvEJvFbedVugJJLiUlYwYXi
         L14Bo+7LYMlz1nqCcBQ3tevRUEkoptWm8+CueRUhGwEVJy5DrQPtDJdBMhB3vxied1wq
         GzZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224230; x=1768829030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zl/mQjtvR/EBMVt9nhPm03gwedh0vVVOzpLgcWm0+Gg=;
        b=TY7O8dbzW7sbzcbfh0ZNctsCrWtwvHF2J+29X7HuhE4TYUToMJbToFcXRCSZRAfG9T
         pv+UzJelc7R/Cu196435KESC1rvisNucWMGPqVTxulqbC34GWFuTALaVcG1DqWZLg4zD
         R6ZGhJ0lpUg9rTS4sNJ3gfQ1tuignJE20fcUbOqYbrWlyqgE4f6g+Y228nA8Ig7o7OfW
         jmCnwXomfRz7mJQQKBKzRXycVoLJ5YljDcFz8Yz91jphL11GTo2wRTFEIsZo0VN5EGvl
         IsxYABNJGXyAZzyd8V266BWmL6zxfpuipFC0NUAl96dt7iwUbV9eZDAgVkl6fHC2Fqbl
         U/PQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmFsBGkHh/K7RnATCxWR4TzxYai1QC9XVFyWcGukNvIguGgOJcDh4j2Uu+MZK4CUP1F1g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYSzKwS/o1QYoFUGJCbnW5zBGW+YjVFYOyIFRUZ7XjZNvOgYT6
	RobjrKzchTRCdgpakABy8CBkbIrTXk9b8I+Q2gnZTErPTdNJCPHAtBHSAu/rEzgJE8Bs9TRzBJ+
	CKtZOadhXX2ib8s1uhy3brA1luOANs2nUfMfICceMA/x5UtXtwM+2kw==
X-Gm-Gg: AY/fxX5MLT6hxJRYbo7wPCnwt1nBmuDo+FIGRyTL/Cf8Jy9dCc4P5RcZIVwq7wzjnKo
	vuyFxeShKNQMzSLlFdnvI5Po8wAg5c5OOYXJ2oWdCn+JC1SPMBEKrrFtlHb/qIHmhrTZpBwZRMD
	YShyYSJthSqkwR3ZZgC0iK8A69O3NXC1YTu8vSWdTuTCJssxRjQyAH0+PurAQZWSJ0OY3gHfteJ
	ZWge9Ld+1g1jszNZtKJoXxuAoF1t6wiMGEPeIDgSY7ZivF7l5DuUc4l4C3JjG4oEBlXMId2BnZz
	5D+zwUQBdJrY7js3NCf6icwihXdbzb1xhQzbcblPf6EjqZafwhKXXTebGwyiLgr9ytmh7BbGF4T
	ax99XGlTIRQ35jTRtpAwEVmsYOdklNChRhnGiP4Co+rI=
X-Received: by 2002:a05:6a20:7291:b0:342:873d:7e62 with SMTP id adf61e73a8af0-3898f907d2dmr16152486637.29.1768224230540;
        Mon, 12 Jan 2026 05:23:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNkZpUCKhcs1ijrkrd4+d1SBMbbxDyfcLyQALQcYQ7NIvDrlosKRvZfpN7YcfBYYgnGd4PjA==
X-Received: by 2002:a05:6a20:7291:b0:342:873d:7e62 with SMTP id adf61e73a8af0-3898f907d2dmr16152464637.29.1768224230110;
        Mon, 12 Jan 2026 05:23:50 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:23:49 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 09/32] kvm/i386: implement architecture support for kvm file descriptor change
Date: Mon, 12 Jan 2026 18:52:22 +0530
Message-ID: <20260112132259.76855-10-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260112132259.76855-1-anisinha@redhat.com>
References: <20260112132259.76855-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the kvm file descriptor changes as a part of confidential guest reset,
some architecture specific setups including SEV/SEV-SNP/TDX specific setups
needs to be redone. These changes are implemented as a part of the
kvm_arch_vmfd_change_ops() call which was introduced previously.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c        | 135 +++++++++++++++++++++++++++++++----
 target/i386/kvm/trace-events |   1 +
 2 files changed, 122 insertions(+), 14 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 89f9e11d3a..4fedc621b8 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3265,14 +3265,132 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
     return 0;
 }
 
+static int xen_init_wrapper(MachineState *ms, KVMState *s);
+
 int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
 {
-    abort();
+    Error *local_err = NULL;
+    int ret;
+
+    /*
+     * Initialize confidential context, if required
+     *
+     * If no memory encryption is requested (ms->cgs == NULL) this is
+     * a no-op.
+     *
+     */
+    if (ms->cgs) {
+        ret = confidential_guest_kvm_init(ms->cgs, &local_err);
+        if (ret < 0) {
+            error_report_err(local_err);
+            return ret;
+        }
+    }
+
+    ret = kvm_vm_enable_exception_payload(s);
+    if (ret < 0) {
+        return ret;
+    }
+
+    ret = kvm_vm_enable_triple_fault_event(s);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (s->xen_version) {
+        ret = xen_init_wrapper(ms, s);
+        if (ret < 0) {
+            return ret;
+        }
+    }
+
+    ret = kvm_vm_set_identity_map_addr(s, KVM_IDENTITY_BASE);
+    if (ret < 0) {
+        return ret;
+    }
+
+    ret = kvm_vm_set_tss_addr(s, KVM_IDENTITY_BASE + 0x1000);
+    if (ret < 0) {
+        return ret;
+    }
+    ret = kvm_vm_set_nr_mmu_pages(s);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE) &&
+        x86_machine_is_smm_enabled(X86_MACHINE(ms))) {
+        memory_listener_register(&smram_listener.listener,
+                                 &smram_address_space);
+    }
+
+    if (enable_cpu_pm) {
+        ret = kvm_vm_enable_disable_exits(s);
+        if (ret < 0) {
+            error_report("kvm: guest stopping CPU not supported: %s",
+                         strerror(-ret));
+            return ret;
+        }
+    }
+
+    if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE)) {
+        X86MachineState *x86ms = X86_MACHINE(ms);
+
+        if (x86ms->bus_lock_ratelimit > 0) {
+            ret = kvm_vm_enable_bus_lock_exit(s);
+            if (ret < 0) {
+                return ret;
+            }
+        }
+        kvm_set_max_apic_id(x86ms->apic_id_limit);
+    }
+
+    if (kvm_check_extension(s, KVM_CAP_X86_NOTIFY_VMEXIT)) {
+        ret = kvm_vm_enable_notify_vmexit(s);
+        if (ret < 0) {
+            return ret;
+        }
+    }
+
+    if (kvm_vm_check_extension(s, KVM_CAP_X86_USER_SPACE_MSR)) {
+        ret = kvm_vm_enable_userspace_msr(s);
+        if (ret < 0) {
+            return ret;
+        }
+
+        if (s->msr_energy.enable == true) {
+            ret = kvm_vm_enable_energy_msrs(s);
+            if (ret < 0) {
+                return ret;
+            }
+        }
+    }
+
+    trace_kvm_arch_vmfd_change_ops();
+    return 0;
+}
+
+static int xen_init_wrapper(MachineState *ms, KVMState *s)
+{
+    int ret = 0;
+#ifdef CONFIG_XEN_EMU
+    if (!object_dynamic_cast(OBJECT(ms), TYPE_PC_MACHINE)) {
+        error_report("kvm: Xen support only available in PC machine");
+        return -ENOTSUP;
+    }
+    /* hyperv_enabled() doesn't work yet. */
+    uint32_t msr = XEN_HYPERCALL_MSR;
+    ret = kvm_xen_init(s, msr);
+#else
+    error_report("kvm: Xen support not enabled in qemu");
+    return -ENOTSUP;
+#endif
+    return ret;
 }
 
 bool kvm_arch_supports_vmfd_change(void)
 {
-    return false;
+    return true;
 }
 
 int kvm_arch_init(MachineState *ms, KVMState *s)
@@ -3308,21 +3426,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     }
 
     if (s->xen_version) {
-#ifdef CONFIG_XEN_EMU
-        if (!object_dynamic_cast(OBJECT(ms), TYPE_PC_MACHINE)) {
-            error_report("kvm: Xen support only available in PC machine");
-            return -ENOTSUP;
-        }
-        /* hyperv_enabled() doesn't work yet. */
-        uint32_t msr = XEN_HYPERCALL_MSR;
-        ret = kvm_xen_init(s, msr);
+        ret = xen_init_wrapper(ms, s);
         if (ret < 0) {
             return ret;
         }
-#else
-        error_report("kvm: Xen support not enabled in qemu");
-        return -ENOTSUP;
-#endif
     }
 
     ret = kvm_get_supported_msrs(s);
diff --git a/target/i386/kvm/trace-events b/target/i386/kvm/trace-events
index 74a6234ff7..1f4786f687 100644
--- a/target/i386/kvm/trace-events
+++ b/target/i386/kvm/trace-events
@@ -6,6 +6,7 @@ kvm_x86_add_msi_route(int virq) "Adding route entry for virq %d"
 kvm_x86_remove_msi_route(int virq) "Removing route entry for virq %d"
 kvm_x86_update_msi_routes(int num) "Updated %d MSI routes"
 kvm_hc_map_gpa_range(uint64_t gpa, uint64_t size, uint64_t attributes, uint64_t flags) "gpa 0x%" PRIx64 " size 0x%" PRIx64 " attributes 0x%" PRIx64 " flags 0x%" PRIx64
+kvm_arch_vmfd_change_ops(void) ""
 
 # xen-emu.c
 kvm_xen_hypercall(int cpu, uint8_t cpl, uint64_t input, uint64_t a0, uint64_t a1, uint64_t a2, uint64_t ret) "xen_hypercall: cpu %d cpl %d input %" PRIu64 " a0 0x%" PRIx64 " a1 0x%" PRIx64 " a2 0x%" PRIx64" ret 0x%" PRIx64
-- 
2.42.0


