Return-Path: <kvm+bounces-65828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EB72CB9079
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:05:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C280A30977CA
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930F81531F9;
	Fri, 12 Dec 2025 15:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RuESubHu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WpmEGiIj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98DE27F015
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551887; cv=none; b=tw5H4TYTbAQ5QltMp+0eZAMJtBbszeE2L4ALvO9yJQ5Tz5gUYVsvrR7pEbzWH6VqgVQKNpJe1uOmcUxyRt2prSdF2uaVL9jRiP0rNMXe9Mzf+MiMJ5Dtddyz9g4p85bum6dBjYCWQ/deNTURe700QZdg1MNk/Uitd0EdL6eKPHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551887; c=relaxed/simple;
	bh=hZtKgAbKBHDReyK3wZDQGUKvlUoMnk8XzSDtuxlBg4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvNJvEgoOjxbpth02Pswv9V/HYsgk+mwhK5Kz2B1sGBagPdsngkmh48zENxBE4V9Drw11C1sb8m+Kl97WZMt/8R8NHQtTNHDNezNyxOojXHBxtMAG+F8MI7Axqg/r8fCjx1vY/kMz8tqsjQ3kO4BBT1MHdBYKooaFEjdKYwi7nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RuESubHu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WpmEGiIj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PjEcZQ1uHJTqefFeQEkw1uWuzKF1uPikpHMJbHt4BwE=;
	b=RuESubHuIvr7XIO8mJKF+fI4jYiUoTyNfVFn3w0F/8PMtvsddB13x7l3OBPGx1DH0PSrMO
	PiW0Ehkpd3JMwWBPhWndNH1WeMph8T03SrdRpNEBx5VAKzQc7OgZQMyPif9rndgzsdsesk
	alrV5FbwCl1ZH3zhAD54KCZ0ROcEg20=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-AcKWbN7SPhe5RT0DpmiUCg-1; Fri, 12 Dec 2025 10:04:43 -0500
X-MC-Unique: AcKWbN7SPhe5RT0DpmiUCg-1
X-Mimecast-MFC-AGG-ID: AcKWbN7SPhe5RT0DpmiUCg_1765551882
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-29f8e6a5de4so3659505ad.2
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551882; x=1766156682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PjEcZQ1uHJTqefFeQEkw1uWuzKF1uPikpHMJbHt4BwE=;
        b=WpmEGiIj8QmetSwz9I8T6OerN0ZpeD9Jfpnun+fRyvC4TUk123E+Yc3E7pyc9AVfu6
         PrB3sapUOaQ+8S2DHIjYDrEEpbsQz3jrXj8gnFX4LjULjvxZPvyf0QBVDDkbF6g8bAHT
         I6S5dewR8EQ44oCHG1Kh0eSu40kaWTI5SbLO+MMP2iHBSM6uEpybXL12wz1MgeLvuDDh
         osMojuZtSB/p54WJmNolQX4FrUPpGy5WYZTbRtq4nmyXSfUCr03vDwUR1dYj5JbFiO6O
         YRzWcszplNMtRZZQiUcmNv64b3kNuQVcNw6iyFjyYp8NCHkwGQy0lSrSGF9SnVEleu2H
         3rpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551882; x=1766156682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PjEcZQ1uHJTqefFeQEkw1uWuzKF1uPikpHMJbHt4BwE=;
        b=cNalKRtrfnvd3I7bNPJfeM4Z7x7OFghoHhCTaXSljW1iJLV8ROoZ/VfZ5QplLGxtyb
         oZthPS9xxLgvJxGceVCvhcAtAGkxDDJHr+dW8OeLji2MNmJpTzbI4G5Q/Gk8AA/VywP2
         iwV004HbbQqmfyX9DQszfoq+vYZ7zZ08IC0G0CmgGagbB6iQmQYKanitBWLomV25hhFw
         TaPLOLuNbyPCcN/xeI2fabGTUf19p6GVaTRxFx4LCfnK0GGrrLzyUWu+Eh5LYN8mfk58
         EdeqNCQO+raHNU2AqcR8X15RIlZ8uvGCt8Ye5WLoaOCsB8EBsPTxGZKZ7k8avE2kKPQ9
         QZmg==
X-Forwarded-Encrypted: i=1; AJvYcCXCZ97WUMOx0v/smtZWCRptgOGCyMa+SBGfmPKkbo4e1xj/uXAVp0SvkLY1z5aA+5TMlaI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpXFRTYxIBsEnkvKbDeIJR+RE9LgQTJywTgzNBGEqBJamt53M5
	KKJr9ebd9z0aI9XdLCNX+EdE2bq8dJFhGunVPv3Wf/DYtYSvPlz7/EEbm2pcIqlwj0P5thcsmH1
	+W7cLykA943zekesEKk1r61rmp7vDSPDbrjRTpRyNoC+4+4/O5jI7tg==
X-Gm-Gg: AY/fxX735r44fkP3nUFNSulg7bnL8HzKdiScgLP9D/inhZlmMpdqSFGrefo82W/rREr
	Ldf52I5N/LtolcB1al04FDp6r90t63jAZEScbvgskGBj57+ZZS34a2hsRA8nZZ1flbNSlAtqvxg
	pOSd1yz5ucr/u8a0Vy7iLnY55/JN1CGaVIue3N3a6jegoQqBxG4/UYdmunGBdARZAXc7EEHCE5j
	90T/Fwb0F4Zm3s3G/HYlAUp2Rh4Ov6UfZf0ozTakQA1hfRWAdJNUH7Mt9FgTFKBaR2lyNsKSYN6
	uGCwqoG8DPlG4JyTLYGcmRiPDS/y/2+Xn1nw+Obep91bxOR06kkYYkdchm0ib33e1kWZIkSLGGD
	jrvYv4ES4ws4hxw41qBzSAIyb5opReUUrCi0AdLOBqxI=
X-Received: by 2002:a17:903:230a:b0:2a0:81c1:6194 with SMTP id d9443c01a7336-2a081c16442mr6958435ad.47.1765551881171;
        Fri, 12 Dec 2025 07:04:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH8yblFgCzrr9m/ubmrYBSTPLesJuI39hqhYZI5/jPqA3lpx4dP+VaBeRXVg2kOQXvwTndbgA==
X-Received: by 2002:a17:903:230a:b0:2a0:81c1:6194 with SMTP id d9443c01a7336-2a081c16442mr6957515ad.47.1765551880158;
        Fri, 12 Dec 2025 07:04:40 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:04:39 -0800 (PST)
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
	Richard Henderson <richard.henderson@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Thomas Huth <thuth@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org
Subject: [PATCH v1 04/28] accel/kvm: add changes required to support KVM VM file descriptor change
Date: Fri, 12 Dec 2025 20:33:32 +0530
Message-ID: <20251212150359.548787-5-anisinha@redhat.com>
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

This change adds common kvm specific support to handle KVM VM file descriptor
change. KVM VM file descriptor can change as a part of confidential guest reset
mechanism. A new function api kvm_arch_vmfd_change_ops() per
architecture platform is added in order to implement architecture specific
changes required to support it. A subsequent patch will add x86 specific
implementation for kvm_arch_vmfd_change_ops as currently only x86 supports
confidential guest reset.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c        | 70 ++++++++++++++++++++++++++++++++++++--
 include/system/kvm.h       |  1 +
 target/arm/kvm.c           |  5 +++
 target/i386/kvm/kvm.c      |  5 +++
 target/loongarch/kvm/kvm.c |  5 +++
 target/mips/kvm.c          |  5 +++
 target/ppc/kvm.c           |  5 +++
 target/riscv/kvm/kvm-cpu.c |  5 +++
 target/s390x/kvm/kvm.c     |  5 +++
 9 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 28006d73c5..c9564bf681 100644
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
@@ -2607,6 +2611,65 @@ static int kvm_setup_dirty_ring(KVMState *s)
     return 0;
 }
 
+static int kvm_reset_vmfd(MachineState *ms)
+{
+    KVMState *s;
+    KVMMemoryListener *kml;
+    int ret, type;
+    Error *err = NULL;
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
+
+    return ret;
+}
+
 static int kvm_init(AccelState *as, MachineState *ms)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
@@ -4014,6 +4077,7 @@ static void kvm_accel_class_init(ObjectClass *oc, const void *data)
     AccelClass *ac = ACCEL_CLASS(oc);
     ac->name = "KVM";
     ac->init_machine = kvm_init;
+    ac->reset_vmfd = kvm_reset_vmfd;
     ac->has_memory = kvm_accel_has_memory;
     ac->allowed = &kvm_allowed;
     ac->gdbstub_supported_sstep_flags = kvm_gdbstub_sstep_flags;
diff --git a/include/system/kvm.h b/include/system/kvm.h
index 8f9eecf044..ade13dd8cc 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -358,6 +358,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s);
 int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp);
 int kvm_arch_init_vcpu(CPUState *cpu);
 int kvm_arch_destroy_vcpu(CPUState *cpu);
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s);
 
 #ifdef TARGET_KVM_HAVE_RESET_PARKED_VCPU
 void kvm_arch_reset_parked_vcpu(unsigned long vcpu_id, int kvm_fd);
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 0d57081e69..919bf95ae1 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1568,6 +1568,11 @@ void kvm_arch_init_irq_routing(KVMState *s)
 {
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
 int kvm_arch_irqchip_create(KVMState *s)
 {
     if (kvm_kernel_irqchip_split()) {
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 02819de625..cdfcb70f40 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3252,6 +3252,11 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
     return 0;
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
+{
+    abort();
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     int ret;
diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
index 26e40c9bdc..4171781346 100644
--- a/target/loongarch/kvm/kvm.c
+++ b/target/loongarch/kvm/kvm.c
@@ -1312,6 +1312,11 @@ int kvm_arch_irqchip_create(KVMState *s)
     return kvm_check_extension(s, KVM_CAP_DEVICE_CTRL);
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
+{
+    return 0;
+}
+
 void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
 {
 }
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index 912cd5dfa0..28730da06b 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -44,6 +44,11 @@ unsigned long kvm_arch_vcpu_id(CPUState *cs)
     return cs->cpu_index;
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
+{
+    return 0;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     /* MIPS has 128 signals */
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 43124bf1c7..a48dc7670b 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -180,6 +180,11 @@ int kvm_arch_irqchip_create(KVMState *s)
     return 0;
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
+{
+    return 0;
+}
+
 static int kvm_arch_sync_sregs(PowerPCCPU *cpu)
 {
     CPUPPCState *cenv = &cpu->env;
diff --git a/target/riscv/kvm/kvm-cpu.c b/target/riscv/kvm/kvm-cpu.c
index 47e672c7aa..ca384a8b85 100644
--- a/target/riscv/kvm/kvm-cpu.c
+++ b/target/riscv/kvm/kvm-cpu.c
@@ -1545,6 +1545,11 @@ int kvm_arch_irqchip_create(KVMState *s)
     return kvm_check_extension(s, KVM_CAP_DEVICE_CTRL);
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
+{
+    return 0;
+}
+
 int kvm_arch_process_async_events(CPUState *cs)
 {
     return 0;
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 916dac1f14..671c854634 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -393,6 +393,11 @@ int kvm_arch_irqchip_create(KVMState *s)
     return 0;
 }
 
+int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
+{
+    return 0;
+}
+
 unsigned long kvm_arch_vcpu_id(CPUState *cpu)
 {
     return cpu->cpu_index;
-- 
2.42.0


