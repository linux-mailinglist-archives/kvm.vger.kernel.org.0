Return-Path: <kvm+bounces-67740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EEAE0D12C93
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:28:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8599B3069608
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40D235970E;
	Mon, 12 Jan 2026 13:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NW3Onxhn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IRuolRHg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D68359705
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224243; cv=none; b=apJ5aR6FpJFTCiFfH7FBdhjMK8BAnEA4nK0cWMCaUQeLfK+NF3QRo2Zocj6IyJ0jC6FPnjoGU/1ofJOMNe+uUXgb5r9ySM3x0RmTKZ9Qvyv5Xfkbpt64QZbQRiVl+NGW08Gd5pyZRIsyLn7FpEfm+KFXx5u0CifRynm9+pIwnf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224243; c=relaxed/simple;
	bh=tcfHUEdMFb0tQiGjS30F/h/zUYfHyBMTQqziNdRibYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LuO5t3RlL7pJ9vQ4o/DpRjVZM1XljrTLR3h40fVcphMYBj9w7O8uVoYcF86Mc/gkY1LZeD0/6/hNDXP1iApDYpEVxV2JchfgW9wlVdevXJ1TXuC0qxiX0V3aD9O2KDTPhAcdPf9vYFucoRqCyXDPijyWv9TcC7ELKoeGiDJ0vnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NW3Onxhn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IRuolRHg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=huNj8LV84XiXUyf00M+KYfsVR7Qt8nLIumf0RvZ1e/M=;
	b=NW3Onxhn7PJJiiW/uJYpIKfIn8Nl34rTbq2Iyvqjcqeebo1daPRpUmvLHWSPRNI6SSOKmm
	+DfD9fZCPwRogIdRb3RsNFf9nQ+WeJ4gUsIOvYi+fOZOhKAspLhMj2z6lYoODTOdvgzGUP
	zNQF0R4er2r+F7y1H/3oK7rWkPZULHM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-260-HneRaYpkMEeju5--Rz1BYw-1; Mon, 12 Jan 2026 08:23:59 -0500
X-MC-Unique: HneRaYpkMEeju5--Rz1BYw-1
X-Mimecast-MFC-AGG-ID: HneRaYpkMEeju5--Rz1BYw_1768224238
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b630753cc38so1626862a12.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224238; x=1768829038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=huNj8LV84XiXUyf00M+KYfsVR7Qt8nLIumf0RvZ1e/M=;
        b=IRuolRHg1peZHHXPg22+6iaCoSela4XQ3/rC3Jlea1z51T+rsN99aYuXs+bwKTte6i
         IKIsIoinycvBxxAgqzVpDlf5Jc/rJbioZxHSdHrB2PVY1ermg5A04F6Yn8I/WOB6iamS
         5WeWW/ZiHQGbc7kDng9fQZO8MUFkfMi25zU+p701rUC77S1w+gEWn7SJYe8FAFBj27zR
         /qikbKETLuFzU2/39PL4RJdzbjNAFnISZsYX2Yc+WHKatISnB+x8ynnWKf/ByqQ3I6r3
         1g8YbFpR9PnxiqoIcvv7Wk6yqR2+7j/ECCL/DiMH5gFCVrTzX6gMD6FB/v0Zk8zMxpkF
         E96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224238; x=1768829038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=huNj8LV84XiXUyf00M+KYfsVR7Qt8nLIumf0RvZ1e/M=;
        b=YPhf40VH/7E21ut1Og8zu4mmJNS1COOmISofgehCPEgv97aaD1stfKd1jHL/aIrO1h
         Pc5E+AlqUxPjyHy4auFoKsNNtAfXaoX45uOV6AZeUUKK+8gDyKyzr5gGb4drbQ+DB+gM
         +sh6jaPqfL6y2DEjjE4MFNJAq+wq1HWDbpiucpJm9FZ5ibXDN3bsCT4nHQ0IZoscivcy
         jB9rCFPDU/a3l0vTD8U7qMT4eB6YHkSZ8IIRbqRvW6bUGTgctoYC3JOLJyidwAekHaLB
         yWXpETJ7FCUtCxZ2KHG7UvvUGq488TAudMjhlQUww77VVOQ8ydPzihJGGL4Jg0Od0atl
         Zi6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWzEofdl43O6ooYx5Gr9W+uaACzy5Ayde8BZxzWJFNxtWVWgUDfDsRaRc0qKo4S486/6W4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHpq9auss4znWk3mavMqCbQR5/2UuUy3ILwYx91pnNGj+7uKVK
	JF3hC+Ps8MfvLB3kUmCXjqyPHwaPUEGnzV6kIQ5tGM01tc6h/gg+TvB0p59GzFSjh8f2KMW5hf5
	esoD/qfTWvVxQa3GUGzOuFdjfpIF0qJUFiVufwGP7kpuNk/gWkmlZUw==
X-Gm-Gg: AY/fxX6D+yyfV5UfzwWDEx2souJK9ZjqH1Zy83xuZvAFz51I6xr9wNwmc7Ua3Wqh+8z
	rc5MX9iJinMsFCVTX8W7gkesOniHE9lOI1B6NZ6qrECL04X+nV1POSIv6250nahoSdeCeHtYFRH
	PW3dmt0ccVI4BxcndhVgpD+vUhINw+ds6Mvx0VBwagZnTNQNk9TO503qrdq5z5HWM0hbJep1L6M
	FNvRHgbFI0aYsl9kQs5A4EmiV8kl62L0y6EaaTbPyxaLeuv+B717jvfWPVMfFYrAFzYb1C7xvQ8
	bYGVFKvDzjUQBfAuQ46hni9PAv3YatMz1UcBfvQNGMtEjmJlOAwTAw9FLnRqVfwDBhNcaK7XE3q
	Yx6gFVUUdu/N2QjzY+XTUnw+cVyPS1iwGmzSrVKLB51U=
X-Received: by 2002:a05:6a21:6da0:b0:364:1339:97c2 with SMTP id adf61e73a8af0-3898f8ccd38mr17616493637.14.1768224238068;
        Mon, 12 Jan 2026 05:23:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKybBdHQbkuvgP5WuAflGvMiKUzNXddTr/0WDGSHVn7QeibNA2vw07SBmyCrL1qhYe3JMUog==
X-Received: by 2002:a05:6a21:6da0:b0:364:1339:97c2 with SMTP id adf61e73a8af0-3898f8ccd38mr17616470637.14.1768224237608;
        Mon, 12 Jan 2026 05:23:57 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:23:57 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 12/32] accel/kvm: rebind current VCPUs to the new KVM VM file descriptor upon reset
Date: Mon, 12 Jan 2026 18:52:25 +0530
Message-ID: <20260112132259.76855-13-anisinha@redhat.com>
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

Confidential guests needs to generate a new KVM file descriptor upon virtual
machine reset. Existing VCPUs needs to be reattached to this new
KVM VM file descriptor. As a part of this, new VCPU file descriptors against
this new KVM VM file descriptor needs to be created and re-initialized.
Resources allocated against the old VCPU fds needs to be released. This change
makes this happen.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c    | 202 ++++++++++++++++++++++++++++++++++-------
 accel/kvm/trace-events |   1 +
 2 files changed, 168 insertions(+), 35 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 367968427b..2bd4dcd43b 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -130,6 +130,12 @@ static NotifierWithReturnList register_vmfd_changed_notifiers =
 static NotifierWithReturnList register_vmfd_pre_change_notifiers =
     NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vmfd_pre_change_notifiers);
 
+static int kvm_rebind_vcpus(Error **errp);
+
+static int map_kvm_run(KVMState *s, CPUState *cpu, Error **errp);
+static int map_kvm_dirty_gfns(KVMState *s, CPUState *cpu, Error **errp);
+static int vcpu_unmap_regions(KVMState *s, CPUState *cpu);
+
 struct KVMResampleFd {
     int gsi;
     EventNotifier *resample_event;
@@ -423,6 +429,83 @@ err:
     return ret;
 }
 
+static int kvm_rebind_vcpus(Error **errp)
+{
+    CPUState *cpu;
+    unsigned long vcpu_id;
+    KVMState *s = kvm_state;
+    int kvm_fd, ret = 0;
+
+    CPU_FOREACH(cpu) {
+        vcpu_id = kvm_arch_vcpu_id(cpu);
+
+        if (cpu->kvm_fd) {
+            close(cpu->kvm_fd);
+        }
+
+        ret = kvm_arch_destroy_vcpu(cpu);
+        if (ret < 0) {
+            goto err;
+        }
+
+        if (s->coalesced_mmio_ring == (void *)cpu->kvm_run + PAGE_SIZE) {
+            s->coalesced_mmio_ring = NULL;
+        }
+
+        ret = vcpu_unmap_regions(s, cpu);
+        if (ret < 0) {
+            goto err;
+        }
+
+        ret = kvm_arch_pre_create_vcpu(cpu, errp);
+        if (ret < 0) {
+            goto err;
+        }
+
+        kvm_fd = kvm_vm_ioctl(s, KVM_CREATE_VCPU, vcpu_id);
+        if (kvm_fd < 0) {
+            error_report("KVM_CREATE_VCPU IOCTL failed for vCPU %lu (%s)",
+                         vcpu_id, strerror(kvm_fd));
+            return kvm_fd;
+        }
+
+        cpu->kvm_fd = kvm_fd;
+
+        cpu->vcpu_dirty = false;
+        cpu->dirty_pages = 0;
+        cpu->throttle_us_per_full = 0;
+
+        ret = map_kvm_run(s, cpu, errp);
+        if (ret < 0) {
+            goto err;
+        }
+
+        if (s->kvm_dirty_ring_size) {
+            ret = map_kvm_dirty_gfns(s, cpu, errp);
+            if (ret < 0) {
+                goto err;
+            }
+        }
+
+        ret = kvm_arch_init_vcpu(cpu);
+        if (ret < 0) {
+            error_setg_errno(errp, -ret,
+                             "kvm_init_vcpu: kvm_arch_init_vcpu failed (%lu)",
+                             vcpu_id);
+        }
+
+        close(cpu->kvm_vcpu_stats_fd);
+        cpu->kvm_vcpu_stats_fd = kvm_vcpu_ioctl(cpu, KVM_GET_STATS_FD, NULL);
+        kvm_init_cpu_signals(cpu);
+
+        kvm_cpu_synchronize_post_init(cpu);
+    }
+    trace_kvm_rebind_vcpus();
+
+ err:
+    return ret;
+}
+
 static void kvm_park_vcpu(CPUState *cpu)
 {
     struct KVMParkedVcpu *vcpu;
@@ -511,19 +594,11 @@ int kvm_create_and_park_vcpu(CPUState *cpu)
     return ret;
 }
 
-static int do_kvm_destroy_vcpu(CPUState *cpu)
+static int vcpu_unmap_regions(KVMState *s, CPUState *cpu)
 {
-    KVMState *s = kvm_state;
     int mmap_size;
     int ret = 0;
 
-    trace_kvm_destroy_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
-
-    ret = kvm_arch_destroy_vcpu(cpu);
-    if (ret < 0) {
-        goto err;
-    }
-
     mmap_size = kvm_ioctl(s, KVM_GET_VCPU_MMAP_SIZE, 0);
     if (mmap_size < 0) {
         ret = mmap_size;
@@ -551,39 +626,47 @@ static int do_kvm_destroy_vcpu(CPUState *cpu)
         cpu->kvm_dirty_gfns = NULL;
     }
 
-    kvm_park_vcpu(cpu);
-err:
+ err:
     return ret;
 }
 
-void kvm_destroy_vcpu(CPUState *cpu)
-{
-    if (do_kvm_destroy_vcpu(cpu) < 0) {
-        error_report("kvm_destroy_vcpu failed");
-        exit(EXIT_FAILURE);
-    }
-}
-
-int kvm_init_vcpu(CPUState *cpu, Error **errp)
+static int do_kvm_destroy_vcpu(CPUState *cpu)
 {
     KVMState *s = kvm_state;
-    int mmap_size;
-    int ret;
+    int ret = 0;
 
-    trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
+    trace_kvm_destroy_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
 
-    ret = kvm_arch_pre_create_vcpu(cpu, errp);
+    ret = kvm_arch_destroy_vcpu(cpu);
     if (ret < 0) {
         goto err;
     }
 
-    ret = kvm_create_vcpu(cpu);
+    /* If I am the CPU that created coalesced_mmio_ring, then discard it */
+    if (s->coalesced_mmio_ring == (void *)cpu->kvm_run + PAGE_SIZE) {
+        s->coalesced_mmio_ring = NULL;
+    }
+
+    ret = vcpu_unmap_regions(s, cpu);
     if (ret < 0) {
-        error_setg_errno(errp, -ret,
-                         "kvm_init_vcpu: kvm_create_vcpu failed (%lu)",
-                         kvm_arch_vcpu_id(cpu));
         goto err;
     }
+    kvm_park_vcpu(cpu);
+err:
+    return ret;
+}
+
+void kvm_destroy_vcpu(CPUState *cpu)
+{
+    if (do_kvm_destroy_vcpu(cpu) < 0) {
+        error_report("kvm_destroy_vcpu failed");
+        exit(EXIT_FAILURE);
+    }
+}
+
+static int map_kvm_run(KVMState *s, CPUState *cpu, Error **errp)
+{
+    int mmap_size, ret = 0;
 
     mmap_size = kvm_ioctl(s, KVM_GET_VCPU_MMAP_SIZE, 0);
     if (mmap_size < 0) {
@@ -608,14 +691,53 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
             (void *)cpu->kvm_run + s->coalesced_mmio * PAGE_SIZE;
     }
 
+ err:
+    return ret;
+}
+
+static int map_kvm_dirty_gfns(KVMState *s, CPUState *cpu, Error **errp)
+{
+    int ret = 0;
+    /* Use MAP_SHARED to share pages with the kernel */
+    cpu->kvm_dirty_gfns = mmap(NULL, s->kvm_dirty_ring_bytes,
+                               PROT_READ | PROT_WRITE, MAP_SHARED,
+                               cpu->kvm_fd,
+                               PAGE_SIZE * KVM_DIRTY_LOG_PAGE_OFFSET);
+    if (cpu->kvm_dirty_gfns == MAP_FAILED) {
+        ret = -errno;
+    }
+
+    return ret;
+}
+
+int kvm_init_vcpu(CPUState *cpu, Error **errp)
+{
+    KVMState *s = kvm_state;
+    int ret;
+
+    trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
+
+    ret = kvm_arch_pre_create_vcpu(cpu, errp);
+    if (ret < 0) {
+        goto err;
+    }
+
+    ret = kvm_create_vcpu(cpu);
+    if (ret < 0) {
+        error_setg_errno(errp, -ret,
+                         "kvm_init_vcpu: kvm_create_vcpu failed (%lu)",
+                         kvm_arch_vcpu_id(cpu));
+        goto err;
+    }
+
+    ret = map_kvm_run(s, cpu, errp);
+    if (ret < 0) {
+        goto err;
+    }
+
     if (s->kvm_dirty_ring_size) {
-        /* Use MAP_SHARED to share pages with the kernel */
-        cpu->kvm_dirty_gfns = mmap(NULL, s->kvm_dirty_ring_bytes,
-                                   PROT_READ | PROT_WRITE, MAP_SHARED,
-                                   cpu->kvm_fd,
-                                   PAGE_SIZE * KVM_DIRTY_LOG_PAGE_OFFSET);
-        if (cpu->kvm_dirty_gfns == MAP_FAILED) {
-            ret = -errno;
+        ret = map_kvm_dirty_gfns(s, cpu, errp);
+        if (ret < 0) {
             goto err;
         }
     }
@@ -2726,6 +2848,16 @@ static int kvm_reset_vmfd(MachineState *ms)
     }
     assert(!err);
 
+    /*
+     * rebind new vcpu fds with the new kvm fds
+     * These can only be called after kvm_arch_vmfd_change_ops()
+     */
+    ret = kvm_rebind_vcpus(&err);
+    if (ret < 0) {
+        return ret;
+    }
+    assert(!err);
+
     /* these can be only called after ram_block_rebind() */
     memory_listener_register(&kml->listener, &address_space_memory);
     memory_listener_register(&kvm_io_listener, &address_space_io);
diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
index e4beda0148..4a8921c632 100644
--- a/accel/kvm/trace-events
+++ b/accel/kvm/trace-events
@@ -15,6 +15,7 @@ kvm_park_vcpu(int cpu_index, unsigned long arch_cpu_id) "index: %d id: %lu"
 kvm_unpark_vcpu(unsigned long arch_cpu_id, const char *msg) "id: %lu %s"
 kvm_irqchip_commit_routes(void) ""
 kvm_reset_vmfd(void) ""
+kvm_rebind_vcpus(void) ""
 kvm_irqchip_add_msi_route(char *name, int vector, int virq) "dev %s vector %d virq %d"
 kvm_irqchip_update_msi_route(int virq) "Updating MSI route virq=%d"
 kvm_irqchip_release_virq(int virq) "virq %d"
-- 
2.42.0


