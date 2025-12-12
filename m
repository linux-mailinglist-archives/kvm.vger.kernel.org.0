Return-Path: <kvm+bounces-65834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A7C0CB90D9
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:08:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 97ECB30BC1EA
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D01316909;
	Fri, 12 Dec 2025 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GOamY1W9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UgOtuK6s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A07285CB3
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551908; cv=none; b=WAmPtfI+JGx38jNbeOoxEeU8iTdiG8nKj9+olln9Am3elJUCoEDNOMWBIVx70wRHMZu+y2058QOG6CRmEo2LB6WIUc01ZKYvAG8TNLlBkodGGFx0yTptWFE2PKjjvLebXq+E8La/wcWRQpfR3b2/Ow2NkHHtbPZCxnLD45l4l6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551908; c=relaxed/simple;
	bh=g86eHeQOT61whooGwj+H+mVkDqWIOA3SnX51u4DrghU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsLfxPF74CIQgF+Td7VyAQoE/MeJIuN6Ape3owjHSe8B295bQhH8ERHTQ/tID7Mi29JV4KPOaqn4BjW34TucmyJ+N1zr6tp0j1UaULUZKe+5GnokDW6dO+aH6uIST3DucR1XzibhzPAeysf+O5lAGPgMW5bXHeV1aljXMWl37hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GOamY1W9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UgOtuK6s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EWbJ3b/FRgtMaf7F/qkvMf2cvadC5nmdaEsA8MbTH9w=;
	b=GOamY1W9qwZDDTLhqsmuxn56YY0glOsosl14m0iB4wCrNDhurg2QS2pim6BJQITz73UDz0
	TGFBp32KJxN6gtJKYc6JcbPCYn0jgxhyZvTiE91gjrLQPHn80MpQzdAfeiYU5bK4KJNvdo
	bjuDXNgl+NMZ4eOUwXx51QcNeMd9buU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-345-za_7ecLrPG20vEymTrgRQA-1; Fri, 12 Dec 2025 10:05:02 -0500
X-MC-Unique: za_7ecLrPG20vEymTrgRQA-1
X-Mimecast-MFC-AGG-ID: za_7ecLrPG20vEymTrgRQA_1765551901
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-29f25a008dbso6580505ad.1
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551901; x=1766156701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWbJ3b/FRgtMaf7F/qkvMf2cvadC5nmdaEsA8MbTH9w=;
        b=UgOtuK6sZd6MjfZ9kSN6tSivO9tQjmLAZ2DLW70WHZRYXkq1jQuuiDAW/WKtd4wGTH
         ZXW3huxwLCpGf/QxUgZpLqscLBeA400LYswa3ixp0VIDsq0KzCeUN4F756v/DJZ63L4X
         JEFaK9tkdXNIN+Al/wPAzBslmHZga2edz/yBGPcyU9D7KVsb7YxOUyGRAh/+ua27Wzxd
         hu8hGVocqs8cJsvGYPsShvqc5diQIn12IjmA/UgybXMIBwo19je2L/NeyhexDpQzLtHO
         rdrpff0w6sZXpmhQCMN65ew/aHSsvfWK5HYh7XWCzpaZwLBuOEyOxbImfIhnTOscGjE2
         UJ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551901; x=1766156701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EWbJ3b/FRgtMaf7F/qkvMf2cvadC5nmdaEsA8MbTH9w=;
        b=Uc5GWMG8HXUEoacW2vpiy6ar7s2oa4WyEINer7VULxsdVml6ukjBx6+dJa76vACGrG
         pCsaL21vrBH21M8nF23ZfzhMCbK2X6EzX0VCgfHPImNymY1XaEWG7dMNf2MoDWOZoP5/
         6A8QzuR4rXkQoVJ0waKmazyTV8X4HCdeGrnRSaXWeWVWhwlrzevBWKgKBXPxnv4Aa1NV
         O+Q5vDXHz0t8lHU05O6hInCjkvJ5zHzQGcxnMvg/H01Cfk1QNPS2AfNbleDkV/vJ8th9
         pRVtoO1JdNMwk8wYCm0Pfw9yMrOvjLbEvPPcn91EDJyb2y8pNgG+x15MPmd3SRvsQGG6
         vOGA==
X-Forwarded-Encrypted: i=1; AJvYcCViakIWeibeza4AqsRaVEoLL+JD8splb79JXbKPN1fd3iXIN8Aa+vX6gyciRpP813vW5UE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXrhGk/6h8YgWb7iiR4AdDDEUSEMEkVST5hOHlFoR88y4NxBy2
	wONwDreW+CYjPlGz8H4St8m6Hkb1A35p7uGOJYfc71A++pVbyrpQIzeuHWQgtHMyAPpkM7WlDX3
	UAJNMOpYgRYRFYNRYDEJc4IZ1dNbwUYoETc4uuMjx/vmCXIaX12eG8SPeTUNcNw==
X-Gm-Gg: AY/fxX7XrUhaLp/BhpweHwu01reoEYbJE0m1IuSvCDxzyvWpQtjaSJ173KgbpDYksoU
	6DqoWekvQqUAkItafHp/9KuslY/dqzYFRw1SXYMP87OF1BfakYkXDIt9yYUTBmZSgzTb3ZRpOly
	vMtNDBrlcneoEJlLzN53cZ0FAMpQUjt3eTwJqsVttcWuO3F39l+HlRGxH1Ha7PDsXsfrv/VtLnI
	eD9rUjkNEe/HmHMGdvPbobST5mMAisC5Gzx9uNF3x8DECD3frQT0br6pqVhDxjC3/zmqLF7ZsCk
	Txlzb9KBvZ796LAJX7Rv1hjzUZLfda8HmLRYtMsLu3+p0z6bCySD9HYx056q5e9/uIQGlRIcGVl
	gG06o+0FJ5KP3agj/+hdTr/Sb9AQx+oOwgEJ2ZFM6NvA=
X-Received: by 2002:a17:903:22c4:b0:29e:1415:df95 with SMTP id d9443c01a7336-29f2435fd39mr19701795ad.51.1765551900648;
        Fri, 12 Dec 2025 07:05:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGeXsVbGlfUiHlR+wSUHOyHm6iD/qWLG4BYVCfCmsPMHGb4JdQGK7Enc4RBbFandqHGXmbZ/g==
X-Received: by 2002:a17:903:22c4:b0:29e:1415:df95 with SMTP id d9443c01a7336-29f2435fd39mr19701405ad.51.1765551899951;
        Fri, 12 Dec 2025 07:04:59 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:04:59 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 11/28] accel/kvm: rebind current VCPUs to the new KVM VM file descriptor upon reset
Date: Fri, 12 Dec 2025 20:33:39 +0530
Message-ID: <20251212150359.548787-12-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20251212150359.548787-1-anisinha@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
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
 accel/kvm/kvm-all.c | 201 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 166 insertions(+), 35 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 5b854c9866..638f193626 100644
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
@@ -423,6 +429,82 @@ err:
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
+
+ err:
+    return ret;
+}
+
 static void kvm_park_vcpu(CPUState *cpu)
 {
     struct KVMParkedVcpu *vcpu;
@@ -511,19 +593,11 @@ int kvm_create_and_park_vcpu(CPUState *cpu)
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
@@ -551,39 +625,47 @@ static int do_kvm_destroy_vcpu(CPUState *cpu)
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
@@ -608,14 +690,53 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
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
@@ -2716,6 +2837,16 @@ static int kvm_reset_vmfd(MachineState *ms)
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
-- 
2.42.0


