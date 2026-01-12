Return-Path: <kvm+bounces-67733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9123D12BEA
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:23:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8F4553002B8A
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18A7B3590AB;
	Mon, 12 Jan 2026 13:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QaJnWvIm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Llv7HcK9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C22357717
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224224; cv=none; b=pz1TSU44SaXWuzc4CZQIiXLXyRiE00gjjDUlz+gPRrOug4FaA5U2bh/NsIxW7b7/zuyktq8/vGXSxO4suvqt63i7ATxD7iOxipghbeJDX9mHazuD1XBmEa6XT8wHf0BUUIQ6pdwl7Xpo2mi7vaMY/1Z8Mv0c3HnWE2cFbTs2Ng4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224224; c=relaxed/simple;
	bh=0paGOirCsL/vMONS34iGapwfYKzeK0KrZLsJ9QWDlGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plXcdPd0DWeZoSpEdcTfs97HkKTTzHwdLkvYti3eLjlj/p1vm7xcfzQvbB4GisiYekxb8s9RYA4l8EQktQZXaHWyvrdi+OfYXX6Qz+NCwkx5sBVk0FEa+jZreaz24b4uM57aEp2bpTz1vJTYkVhTTSpI+2RmlsdKNEF0zIWmQhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QaJnWvIm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Llv7HcK9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NdnbksSUGyPUrHjkY0R7TYIIf5kvOcbV2JSCja1oOlA=;
	b=QaJnWvIm42Q7zOzaBotThTGc4f20BIU2B74O0DCWIGFP1Ra/4fFbjZanWwhWG+GZY2XJWg
	Xd9xWRknIuPMzwP9I5I+1HTu+5Kcpyo8MdDHofg+3tfvofRscyOWcvVkmNPxs4Rmop3IBL
	e3InPyEHbm57O0Lemj7Cl8IDhFuaPzw=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35--CevcsRzMCGHzMr_XJwoUQ-1; Mon, 12 Jan 2026 08:23:40 -0500
X-MC-Unique: -CevcsRzMCGHzMr_XJwoUQ-1
X-Mimecast-MFC-AGG-ID: -CevcsRzMCGHzMr_XJwoUQ_1768224219
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c1290abb178so4687353a12.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224219; x=1768829019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NdnbksSUGyPUrHjkY0R7TYIIf5kvOcbV2JSCja1oOlA=;
        b=Llv7HcK9rDTFJYaKGGNyEEm6RDTDxS+bu1d2VKoNPF6AJOGPWJoqPZVeuKS0xjIYeE
         +FT6uDOtGWki7EODas0idUC/O5BSn9YZ4FUvH12Ie1dXyLxekPx8LDNj/BruL8P1jPyE
         4YVq4N7BDbXr2q8U4EhoCkb8optON92QdvJfhdxCk34VI0pOf1fh3Aube6I+7PC2sWWr
         WpAbFnmhfkotZw5HCi5TjBlxNqFWYQ3Qv1yDtnlkXJFCs9YAwE3yX8ElHJ62RgF/1TWz
         +2agbPQ7SJZ+EUkDiDeiN4zKvhm3/hVop7xFzxNbvaRCwZqI2Ai+wEnSehjM7XLZNNWp
         FJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224219; x=1768829019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NdnbksSUGyPUrHjkY0R7TYIIf5kvOcbV2JSCja1oOlA=;
        b=NXGBDZExOAMPdTnkhp7BEr+JWoVOcdigQ6cS3b/jOkyV/zlDBHKAtwwifMoMPLVwUL
         oZr3/csr0mDZMS6lUJh7FE6IkIY1XzwHRPJikgPBoTdc2utdrnpMol07fxqolfcpuY/8
         wfjHjhNKyG2d+AAAgxiOXqMpMInYV2jp4LpGDHYx2VLx+MN1yqEcN0iiFT0eOad8EgJE
         Yfs2lNbbqEcLEByPfFCfYIHQSOWObERcRZKLAjTAQ76xCoACgMd03aD7AmwNz5qs9plY
         KlkPRoWF0qEjMCBCr3EmZcjGZOjOGGcZKzEBpTvn/1tngbMkeA61YXIGR4WVFEv9SVku
         xxZw==
X-Forwarded-Encrypted: i=1; AJvYcCWlLBRSqIlwmBzy8lr/T4Dihu/xb/YkvnovvlDRA/tVoO/j7sknMB/RknNAw9keZrXbAg0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/qrwQUNtGRu4WqHnYeDgu7vPSuXFzScT3WmqGkYKsd0I9/YAr
	1us9DScGjOOyanOU9rxWPDYiYLgeU1S38R8yq8rTCvFzPgslSanqof2NuGExnd6B1QTqvg+o5+6
	kGLqmaOTMas1xPkrL8ZbItOjyj33fd2JPtoPoWAfbzBSwwjPf9bkCxg==
X-Gm-Gg: AY/fxX61D1JKnryr66YxZLeBFNGjF6ADqIF7nW4afYMS/uX18CuPyphFBW+eBFHEC+s
	BuSFbDkca2feWYUIVjk0jOEkQRQafwttXlz+vJ4XuprG6o0KABPB9pw8Zu++CUJZpGrbBGeBXS0
	xgN9nQOeCbFIbAihrsUeH4rIGRV49DyYbcJhqpSciJr2t/PyS9p5ixHW87otgabWeaiVZdeYwIs
	3ny2Kjl2Rmidbt8M4lWUzkBS3vAadL9xwedJQzbXp6zRi6JXlTG+60SvU5m5+Vu+vdSGj+EwaJh
	iyxY/FhilFW3MAkQ1+4bA7V5X0pahEzKGsRaVvRZKbA4rqGUrgbj8JzU87hd5fztfM86Ih/KfVD
	2m0bCG2gvmhA/Wr8AcerM+fLu8ZwFhEjBQvVBdAOpc7Y=
X-Received: by 2002:a05:6a20:4320:b0:371:5a31:e486 with SMTP id adf61e73a8af0-3898f8f5575mr16343774637.6.1768224219100;
        Mon, 12 Jan 2026 05:23:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEcv47eltF1dqyqoHkRdnfdwpRjEXwbJhJgpR2WonnKMpNVeugyliTsyRBpgsUG9mJ4idnyIg==
X-Received: by 2002:a05:6a20:4320:b0:371:5a31:e486 with SMTP id adf61e73a8af0-3898f8f5575mr16343740637.6.1768224218597;
        Mon, 12 Jan 2026 05:23:38 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:23:38 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Song Gao <gaosong@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org
Subject: [PATCH v2 04/32] accel/kvm: add changes required to support KVM VM file descriptor change
Date: Mon, 12 Jan 2026 18:52:17 +0530
Message-ID: <20260112132259.76855-5-anisinha@redhat.com>
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

This change adds common kvm specific support to handle KVM VM file descriptor
change. KVM VM file descriptor can change as a part of confidential guest reset
mechanism. A new function api kvm_arch_vmfd_change_ops() per
architecture platform is added in order to implement architecture specific
changes required to support it. A subsequent patch will add x86 specific
implementation for kvm_arch_vmfd_change_ops as currently only x86 supports
confidential guest reset.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c        | 80 ++++++++++++++++++++++++++++++++++++--
 accel/kvm/trace-events     |  1 +
 include/system/kvm.h       |  2 +
 target/arm/kvm.c           | 10 +++++
 target/i386/kvm/kvm.c      | 10 +++++
 target/loongarch/kvm/kvm.c | 10 +++++
 target/mips/kvm.c          | 10 +++++
 target/ppc/kvm.c           | 10 +++++
 target/riscv/kvm/kvm-cpu.c | 10 +++++
 target/s390x/kvm/kvm.c     | 10 +++++
 10 files changed, 150 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f85eb42d78..762f302551 100644
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
+    ret = kvm_arch_vmfd_change_ops(ms, s);
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
index 8f9eecf044..a5ab22421d 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -358,6 +358,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s);
 int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp);
 int kvm_arch_init_vcpu(CPUState *cpu);
 int kvm_arch_destroy_vcpu(CPUState *cpu);
+bool kvm_arch_supports_vmfd_change(void);
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s);
 
 #ifdef TARGET_KVM_HAVE_RESET_PARKED_VCPU
 void kvm_arch_reset_parked_vcpu(unsigned long vcpu_id, int kvm_fd);
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 48f853fff8..10cd94a57d 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1569,6 +1569,16 @@ void kvm_arch_init_irq_routing(KVMState *s)
 {
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 int kvm_arch_irqchip_create(KVMState *s)
 {
     if (kvm_kernel_irqchip_split()) {
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 3fdb2a3f62..6aa17cecba 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3253,6 +3253,16 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
     return 0;
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
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
diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
index ef3359ced9..9d5c73f3a3 100644
--- a/target/loongarch/kvm/kvm.c
+++ b/target/loongarch/kvm/kvm.c
@@ -1312,6 +1312,16 @@ int kvm_arch_irqchip_create(KVMState *s)
     return kvm_check_extension(s, KVM_CAP_DEVICE_CTRL);
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
 {
 }
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index a85e162409..fbef498bd7 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -44,6 +44,16 @@ unsigned long kvm_arch_vcpu_id(CPUState *cs)
     return cs->cpu_index;
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
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
     /* MIPS has 128 signals */
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 3b2f1077da..7cdc0d09f4 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -180,6 +180,16 @@ int kvm_arch_irqchip_create(KVMState *s)
     return 0;
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 static int kvm_arch_sync_sregs(PowerPCCPU *cpu)
 {
     CPUPPCState *cenv = &cpu->env;
diff --git a/target/riscv/kvm/kvm-cpu.c b/target/riscv/kvm/kvm-cpu.c
index 5d792563b9..548ea3aeab 100644
--- a/target/riscv/kvm/kvm-cpu.c
+++ b/target/riscv/kvm/kvm-cpu.c
@@ -1545,6 +1545,16 @@ int kvm_arch_irqchip_create(KVMState *s)
     return kvm_check_extension(s, KVM_CAP_DEVICE_CTRL);
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 int kvm_arch_process_async_events(CPUState *cs)
 {
     return 0;
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index bd6c440aef..6374246416 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -393,6 +393,16 @@ int kvm_arch_irqchip_create(KVMState *s)
     return 0;
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
+bool kvm_arch_supports_vmfd_change(void)
+{
+    return false;
+}
+
 unsigned long kvm_arch_vcpu_id(CPUState *cpu)
 {
     return cpu->cpu_index;
-- 
2.42.0


