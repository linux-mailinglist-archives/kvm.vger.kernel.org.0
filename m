Return-Path: <kvm+bounces-69197-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBeJA9VKeGkKpQEAu9opvQ
	(envelope-from <kvm+bounces-69197-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:19:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9333B900C7
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:19:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC3BD305C8E6
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E790283FEA;
	Tue, 27 Jan 2026 05:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fFD/tUkq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="N9X/PmNC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40182242925
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491043; cv=none; b=JztHOy+f1WCVf3u4Z1DKX8qB8002K6+wLZJducCqv4wlHEhq/OZdNXeMUarw1RZoTIQV8n4YKHhOMRiCZBj7kiYDxGeKgVFrA41pLjLU7v0VJ0PTLW5+pk/1GZzuz2VWKFJQXyHE8kHtegnIiKszUz237ecyq2EHHzVnbQ9dKfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491043; c=relaxed/simple;
	bh=y2izaNVVixcZKNEfygELzxW0GJ0ItAd2doGcSjx2l2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2orSEn83DA7r/Gd0BhZNOtPLHI0v/6K34bLc4wZPVWLmY20Vz1OGkY3c+tmpoLB22zLp0o/gXlR7kovRCvG3bWMCOk1P5zMjK7eDmBt0unPwYcj8qeNFt04JpPHjR2xBqoBTv1nhLYLA3WW6yxtmcedZYb9tOhVRh0Gb08N6o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fFD/tUkq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=N9X/PmNC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZdZcekSc5vy8wLxJHCJ2z+EqJ/GXzJFP2NRW8mt0sAY=;
	b=fFD/tUkqbMsxSNXbtMlS14iCNJHdH5wwy/rGXpdNGInlzdGdXKuoYr26CCgS74/x8kzzES
	VzFHQCH4IyItDe1og6S3D2atSxFrsXFbDtMKlNhdFZMLtw7yr0XUS0AFYZN2QxIf4rW5iG
	7d7NCDrKoE27WFnxuRvg/ahjTRxOJ2A=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-fi4D0nVcOFe_hCy7ozvLQA-1; Tue, 27 Jan 2026 00:17:19 -0500
X-MC-Unique: fi4D0nVcOFe_hCy7ozvLQA-1
X-Mimecast-MFC-AGG-ID: fi4D0nVcOFe_hCy7ozvLQA_1769491038
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-352c79abf36so4360434a91.2
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491038; x=1770095838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZdZcekSc5vy8wLxJHCJ2z+EqJ/GXzJFP2NRW8mt0sAY=;
        b=N9X/PmNC9MqBCTfxuXFFDo1cr5rd6cwEdCOcuHZukfHxH5j6zQFFCCfZpLy/yWk1iI
         j8VuUsuNOlCThanjzs+cqE347S5T4OqEFXCDdFYZ2PdNF0cNlrhfFrPOnpiB/PU3Kjye
         omPyEXdoyoLN+nbVRvO5RJ0MXlEOK3k6rdjoRumDR0y3u7Rdv4Vt2yss0hHBfImHlp+T
         pCxvF6H1wErbboCBmWRbbPYGm6u4L69C12ytvDeU8tggSGkKnIyvx70ECuUkT5H3nCsU
         XR9bNks7TP1O0aHxgh9Qo+z0JQcxrCts/6OWXff0ONv0xuEzvwM3YVzjA9e/k6qlLOWY
         HGTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491038; x=1770095838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZdZcekSc5vy8wLxJHCJ2z+EqJ/GXzJFP2NRW8mt0sAY=;
        b=ZEQZGiBwPWW1sEdEi8OVK5cr7KiMz86dp6QsfXo0HmASQwxjnXZgF/+pCXtDhD7XQa
         BrXLuFPRe9fcgSsEuoug/Blh3NKOJremF+ZvMWcm/h7UUKBM7FJCEg/MPh3TSTFbe/ib
         Mp11MDl+z40bMwtVcEEj97Wxgjr/0+iPwHRkWAmmu3R2qXYRWnzbbXJ3XVt6+/7krRJl
         WuvHCb3O2DEOoEcZgNPRBbQjuuyyLiKFjg2B+UWvWuQlzG7ONX2Zdn0YTXuT39BX+UJf
         cuBzbIJvwAfk7aIXhCWZJNHw3W1Iv0pGciPOjhQRpaTBJBw8jjxYbybzkCnjov1oS36+
         lFvw==
X-Forwarded-Encrypted: i=1; AJvYcCWjTcHDON/+AD7R14QKG28VOO4OLTzVbAeCmPPqAMUi3aV4r4l5HeTnL1OBUApsT7A+weQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHCmE0TbAgzVbp8K1iE+qvgvQgtaddK0xBi8GxODXmCDBR4fE5
	qImLxfxmwvV7ZikntVthJKjC09ox541Euwe2bt4PA2Qo0s9InuKAqVu3vmDL7yFncvyWMTmJypq
	FmxTuNPMngDyOMY9q9CBBX4HUidzVjQu3PWCjD9BowT3frJfhSaag/A==
X-Gm-Gg: AZuq6aJ6u4wHfR2KNG2b1cDsv6wQ3P4CTQcO6SH7O8ghwRc//pOZbMFr+2nwFz4LkPQ
	2GmJkv7tw5cCGljFJEC0JY0U9qTYBGXKPtASqCILzG9+3ccXuYtVxKq3ttBOHhEAAbmdT2J3I4T
	BBl5+mNoAX8MlVYvLLYzvCinaYs1o5iMyGOdDUjyyMzpT+XB0cCS6/KxBnrWdZIyvX8h3yw1Tu7
	ATmKzyv82cuvaVo4LAlelFlv3f+z4zsNLcHaA6sm5hwXXNjIvM1kBUMBNbs1O1nWCY8ohucUzlL
	JR/YLqP0neTCGfJvw08AgYsMuGy8YMHpjRL8fNjbsGZ5XkhwFgc/4PBRfyJv9iDI9e/b39i0tdP
	E2qDTOPbnTJiTbtoTthf0WdyB75ePnv4CGuE/91zDSw==
X-Received: by 2002:a17:90b:2d83:b0:34c:6124:3616 with SMTP id 98e67ed59e1d1-353fed87b05mr624011a91.27.1769491038307;
        Mon, 26 Jan 2026 21:17:18 -0800 (PST)
X-Received: by 2002:a17:90b:2d83:b0:34c:6124:3616 with SMTP id 98e67ed59e1d1-353fed87b05mr623995a91.27.1769491037866;
        Mon, 26 Jan 2026 21:17:17 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:17:17 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 14/33] accel/kvm: rebind current VCPUs to the new KVM VM file descriptor upon reset
Date: Tue, 27 Jan 2026 10:45:42 +0530
Message-ID: <20260127051612.219475-15-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260127051612.219475-1-anisinha@redhat.com>
References: <20260127051612.219475-1-anisinha@redhat.com>
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
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69197-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9333B900C7
X-Rspamd-Action: no action

Confidential guests needs to generate a new KVM file descriptor upon virtual
machine reset. Existing VCPUs needs to be reattached to this new
KVM VM file descriptor. As a part of this, new VCPU file descriptors against
this new KVM VM file descriptor needs to be created and re-initialized.
Resources allocated against the old VCPU fds needs to be released. This change
makes this happen.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c    | 200 +++++++++++++++++++++++++++++++++--------
 accel/kvm/trace-events |   1 +
 2 files changed, 166 insertions(+), 35 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 538a4cc731..d43a363488 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -127,6 +127,10 @@ static NotifierList kvm_irqchip_change_notifiers =
 static NotifierWithReturnList register_vmfd_changed_notifiers =
     NOTIFIER_WITH_RETURN_LIST_INITIALIZER(register_vmfd_changed_notifiers);
 
+static int map_kvm_run(KVMState *s, CPUState *cpu, Error **errp);
+static int map_kvm_dirty_gfns(KVMState *s, CPUState *cpu, Error **errp);
+static int vcpu_unmap_regions(KVMState *s, CPUState *cpu);
+
 struct KVMResampleFd {
     int gsi;
     EventNotifier *resample_event;
@@ -420,6 +424,83 @@ err:
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
@@ -508,19 +589,11 @@ int kvm_create_and_park_vcpu(CPUState *cpu)
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
@@ -548,39 +621,47 @@ static int do_kvm_destroy_vcpu(CPUState *cpu)
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
@@ -605,14 +686,53 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
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
@@ -2710,6 +2830,16 @@ static int kvm_reset_vmfd(MachineState *ms)
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


