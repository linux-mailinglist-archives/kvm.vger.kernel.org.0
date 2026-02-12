Return-Path: <kvm+bounces-70910-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KEkoG8xyjWk+2wAAu9opvQ
	(envelope-from <kvm+bounces-70910-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DF15312A9F9
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 89EC930E441A
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF98F28BAB9;
	Thu, 12 Feb 2026 06:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="el2udbjH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MvqBfgyE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CE3288C3F
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877582; cv=none; b=LFHxc6KH/u6qqFLIJuVZcTQazLN2veV0Qj1WYmzt2IWwtUvKgMXOfEuAErMEWEB1veNHqZ0v/LaOLOmhnNatnKTjOhJz5Eo074MMk/qfQGGptZ8idMsv3l8FMUmfpmIMM7JJUdAL0TyPj6xQLAH9lvCAVUImgBRG1dSSAKCSsZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877582; c=relaxed/simple;
	bh=mE6+YBWke9x/ToZV41PPmK7563TxMe/GB7YhszEz25M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEsN9hWbf1UXnDLA6jnQojmsTq6yEojwOV4UF0D61F4p/Duo2/oUEew7MI0w8Tv8gsdII3M/QabaftkXnJkPYdGRrL5JgVbmL9Df0R2fwNE7vouY3ww0QWqKSLVnjUNR8b3yyNfX5/zX8mvAM7s2gVs5J/oF3IrKSxfc7TlusI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=el2udbjH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MvqBfgyE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=npi3eP36456mUDuK+ax2iLB1NMn8InaMo9diT4vHZh4=;
	b=el2udbjHwBtLw+s7RRymsfKtnzJZm7W2n5J6btcXliF0FFTOszj/yVkFamNtDjzr8PHb+S
	5/Q8uNxX7GkruSEUHe05jsOEwjxwfv9N+7cRObeZih+PTKwLJzyZMFFWYAtuBGKrA4FLcI
	VsMhbMgi1BWSNa6TIQCoim7bPP6GLXg=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319--mqWgEuyNcyOflSy16ZPow-1; Thu, 12 Feb 2026 01:26:17 -0500
X-MC-Unique: -mqWgEuyNcyOflSy16ZPow-1
X-Mimecast-MFC-AGG-ID: -mqWgEuyNcyOflSy16ZPow_1770877576
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-354be486779so5792231a91.0
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877576; x=1771482376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=npi3eP36456mUDuK+ax2iLB1NMn8InaMo9diT4vHZh4=;
        b=MvqBfgyEApDEB6jcPNtbtUxEI15yJh3tAX2jUa5ru6HHidUOF7+iGhSji9DfxblZSo
         0BZK0Xi8wAJT1qPWThyvHIELhudMQbbM8WEo5z84vSr/gyFneGsIXIdzwNHPNwNzoqTM
         qoC1wwi176rEP7k3qZDFDggZrxC5/hfHyRkQeaTFtXIYzMPDD51FoclGGbTXtTQ+v7kr
         NRebGHqbml1Ll3OCkylWO+M2Wf/1jsXsMhH/oeSmmzpR/1jaqDJnRGbRpJy9rbiZrCJ6
         quaa7GWz/UMs9RVpo13Rx3gmNbycNkAaxWlAvTrAM46yBamQjL0AIY9Vm8cyCgxwuQV8
         +29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877576; x=1771482376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=npi3eP36456mUDuK+ax2iLB1NMn8InaMo9diT4vHZh4=;
        b=HOFqvG8Q1eDARqqI3BfW7L4Oz65jzHdokC0kq1/BwEAQdQch1ikyQK8Yoa2iv1wj7W
         zS3HDKi/Ba2w7QG6Qk2OMk+a6RhaLI7qRdLIXlOcHyVrBNlUWjEsZPMUXB1My23avw0d
         PjSGiyiu7ZgI/iiYT/ED2FoLTTyT9oG0biUs3BgMaGO6cjfU3psUCtrK0G0dOkVuR03U
         Ciaiv2QuNrHDXhSBcIF1kc7J+cIwvRlYe5FQlBS/bQut1leDPZ4sosjzvO1BFKp3qeoM
         IQTMhZw6zMOkVvKBl7rTjmYL5moUneW1BeR+uGQvYnd/6ilKX6wOtDw1qvQvPq5LAak6
         0B7g==
X-Forwarded-Encrypted: i=1; AJvYcCXHktLA74eL/Csl40zOFi9mDYCGD0gqQaFHjmGVH065Ujb/xICwSsqgZvZ86/P0E6/Pk1I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKLePEFDqCEmt7qVfFPqkuiNNK2LjiGPIUmOBqj9L5k9X4JIsO
	5RS75wclQcVYAcNC/KhJQWdvSP6p0WCPdN2BBZmIU8BWWu+hKBlQW8Ar6/Yuue8xdub0jzeIbQV
	8EzBFg6yU7VjaEk9BOrlSJxTF9GZaT84q7hFxcziObCn9upISE2fbJw==
X-Gm-Gg: AZuq6aID1rMtPyDpHKR7SIG8kvdwOc3x3WClW7XKkQGupxLaBlSsyUNWZ/jDj031KlZ
	vyLBadSvLhwdFORoz0bBkbiSSz/2+opnSdz/rKZ9ZbFmldGFFrcNSNh+2Mb2rGaiTpAV6aI8Dan
	7Qbuy2jm/sR5oxOSXJGT80u+BEk6VQmJHK6xmaPFx+siAgMUXHQQXjFVW12+UCE8L8WB/ZrDwwz
	jP1wadmDc/K3idw66fvwEukLXt9QkEIgzCKOdFj8cNw3JLNwe5F6kPZmU0HPCJcnmtf4b30fkcT
	rn8YM4S5GeReYmo1dbmYh9Z7FK+7FZDkfelhSLefrliIgHS68kleyCni72ZYW9UNZQxGtkiDdj7
	DvI9K9DpXWR1nV0NpfzjRmSflgsc0s+O8BLfHsJ0r4BoUvvS05liaPJk=
X-Received: by 2002:a17:90b:5403:b0:340:c179:3657 with SMTP id 98e67ed59e1d1-35693dd1630mr1151667a91.33.1770877576484;
        Wed, 11 Feb 2026 22:26:16 -0800 (PST)
X-Received: by 2002:a17:90b:5403:b0:340:c179:3657 with SMTP id 98e67ed59e1d1-35693dd1630mr1151648a91.33.1770877576087;
        Wed, 11 Feb 2026 22:26:16 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:26:15 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 13/31] accel/kvm: rebind current VCPUs to the new KVM VM file descriptor upon reset
Date: Thu, 12 Feb 2026 11:54:57 +0530
Message-ID: <20260212062522.99565-14-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70910-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DF15312A9F9
X-Rspamd-Action: no action

Confidential guests needs to generate a new KVM file descriptor upon virtual
machine reset. Existing VCPUs needs to be reattached to this new
KVM VM file descriptor. As a part of this, new VCPU file descriptors against
this new KVM VM file descriptor needs to be created and re-initialized.
Resources allocated against the old VCPU fds needs to be released. This change
makes this happen.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c    | 215 +++++++++++++++++++++++++++++++++--------
 accel/kvm/trace-events |   1 +
 2 files changed, 174 insertions(+), 42 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index a6ff16a037..5e81bf8ad2 100644
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
@@ -420,6 +424,90 @@ err:
     return ret;
 }
 
+static void kvm_create_vcpu_internal(CPUState *cpu, KVMState *s, int kvm_fd)
+{
+    cpu->kvm_fd = kvm_fd;
+    cpu->kvm_state = s;
+    if (!s->guest_state_protected) {
+        cpu->vcpu_dirty = true;
+    }
+    cpu->dirty_pages = 0;
+    cpu->throttle_us_per_full = 0;
+
+    return;
+}
+
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
+        kvm_create_vcpu_internal(cpu, s, kvm_fd);
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
@@ -483,13 +571,7 @@ static int kvm_create_vcpu(CPUState *cpu)
         }
     }
 
-    cpu->kvm_fd = kvm_fd;
-    cpu->kvm_state = s;
-    if (!s->guest_state_protected) {
-        cpu->vcpu_dirty = true;
-    }
-    cpu->dirty_pages = 0;
-    cpu->throttle_us_per_full = 0;
+    kvm_create_vcpu_internal(cpu, s, kvm_fd);
 
     trace_kvm_create_vcpu(cpu->cpu_index, vcpu_id, kvm_fd);
 
@@ -508,19 +590,11 @@ int kvm_create_and_park_vcpu(CPUState *cpu)
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
@@ -548,39 +622,47 @@ static int do_kvm_destroy_vcpu(CPUState *cpu)
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
@@ -605,14 +687,53 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
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
@@ -2707,6 +2828,16 @@ static int kvm_reset_vmfd(MachineState *ms)
     }
     assert(!err);
 
+    /*
+     * rebind new vcpu fds with the new kvm fds
+     * These can only be called after kvm_arch_on_vmfd_change()
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


