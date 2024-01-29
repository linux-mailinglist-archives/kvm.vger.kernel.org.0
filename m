Return-Path: <kvm+bounces-7348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 724EE840BFD
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:45:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1863B29228
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7868D15698B;
	Mon, 29 Jan 2024 16:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SrE7De/w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14F0664D2
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546735; cv=none; b=VQyY4uasYe3cp0TUQDka5H0LfItEKyVYivSjdEkdWk3XnoEAvmxsf+GuG1bUbYzxfQbiY8Kq7eT4lTcHKRzM2b35IRZ1oNmNSaoiyPNCvf1g1OnQIjKRLFahGYVfduW1woUcc3URH/fMNVyZmWEH0dlNU162e6kieiU7+v43WE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546735; c=relaxed/simple;
	bh=OmiibsMydLqj27Nyh8cdXftUsg08W/YAsFQQTfj9sa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=skd8tqtlP6JKgKPw65mdmDVOlFE+9zsDLaiuRPyBZijYmRMzk79JVCtJ+7XKtbBQ+SldXwHc0Kooy3drboxrBYhHb8ntkEV+r1Hmo4xSm2Z2x1NCvB7FV3VSYhun7Y+SLJl6RYlptq4NFzMh8gTMYFpBdP+OoOQrFcU1MHPKMy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SrE7De/w; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40ee9e21f89so28269235e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546732; x=1707151532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y2hw1LeDHPXoA09+Z2wFdjf4GaaZ4oIVM8gsKnpZLbQ=;
        b=SrE7De/wGEpj/OO4n+dejb4cN5qw5wEblYhuwzPqDG/6qjppnaEAZK49OGaw/czaxa
         eJKqRNyB0pfdlkXu5/dR03kvymoRUsNo8NCcOCwMicY4Q+xJY41SNPkW3dQUvXNn1PDl
         X7VYVDBWI8JuGVDlu5kttFtEt1Dnv2mnbwW5+/rjKHe7pAETlRONuVJsIovSMdQIQwQJ
         U2eu5Y6SFDcoMhdadvyF5snmxVP6R2kXFLQigFR5fAwszfxxlOsN4XMFBVKcq4Nv7kaM
         psvpEPh101rYf7vmzgFT7gR9Eyj9dWlfZhiNfzqcI1PZgpC1dkz2lKBEbhQ6NOvvGfcS
         semA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546732; x=1707151532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y2hw1LeDHPXoA09+Z2wFdjf4GaaZ4oIVM8gsKnpZLbQ=;
        b=I3QgcEtYoBjuvbHOQX4CI1fpv/DnoWNOe1ZK5TrygHlVcg+z5P8QD23h4fjnojCP55
         bebESWTybVyw6pUPOKSzO+qqdskQgXmCTNrjdlELhA4nYS7wttfm0h3lempXLSpNryCm
         kF0P2BBi0krzuETiObfrcbsEYBFPRi3Y+st/Phgg0zswAOhPrqmNKmM+9M3Q8i45D79O
         9XrLJPJLuQud9ypzzVyGx2Zf6YA6CcCtsZM2daimk3gzu0stN8IGCFhsh8hpk9Movouv
         HCRFGAwd2Z9nu+rGSKyrpHsYF6rbQFc5xeodGtRdAFqtCEDYxUe3GAdBF7mEvdMk10i8
         cUxA==
X-Gm-Message-State: AOJu0YxnR5SvkKirb0DzJJvaYr32DHMyf7nmuXqT5GdJA8Vc9HLWXMiv
	kXA6AKFLe5M3y09hJSJTNew6jLBXhMilmQriEFsQlJCjBrx2Dv/7xj8Nfd0hNmE=
X-Google-Smtp-Source: AGHT+IFVrS1YJ9J2dLNRn+st1RiqDBXNn5RMuFWm57xrM1I/AzlVfdLqJZcKs7joGZxBzXAoy74ufw==
X-Received: by 2002:a05:600c:4e8c:b0:40e:e25c:41cf with SMTP id f12-20020a05600c4e8c00b0040ee25c41cfmr5163477wmq.12.1706546732132;
        Mon, 29 Jan 2024 08:45:32 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id bs3-20020a056000070300b0033aeb7d4537sm3951432wrb.7.2024.01.29.08.45.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:45:31 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Song Gao <gaosong@loongson.cn>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v3 02/29] hw/core: Declare CPUArchId::cpu as CPUState instead of Object
Date: Mon, 29 Jan 2024 17:44:44 +0100
Message-ID: <20240129164514.73104-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240129164514.73104-1-philmd@linaro.org>
References: <20240129164514.73104-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Do not accept any Object for CPUArchId::cpu field,
restrict it to CPUState type.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/boards.h        | 2 +-
 hw/core/machine.c          | 4 ++--
 hw/i386/x86.c              | 2 +-
 hw/loongarch/virt.c        | 2 +-
 hw/ppc/spapr.c             | 5 ++---
 hw/s390x/s390-virtio-ccw.c | 2 +-
 6 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/hw/boards.h b/include/hw/boards.h
index bcfde8a84d..8b8f6d5c00 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -120,7 +120,7 @@ typedef struct CPUArchId {
     uint64_t arch_id;
     int64_t vcpus_count;
     CpuInstanceProperties props;
-    Object *cpu;
+    CPUState *cpu;
     const char *type;
 } CPUArchId;
 
diff --git a/hw/core/machine.c b/hw/core/machine.c
index fb5afdcae4..854cf00a9b 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -716,7 +716,7 @@ HotpluggableCPUList *machine_query_hotpluggable_cpus(MachineState *machine)
     mc->possible_cpu_arch_ids(machine);
 
     for (i = 0; i < machine->possible_cpus->len; i++) {
-        Object *cpu;
+        CPUState *cpu;
         HotpluggableCPU *cpu_item = g_new0(typeof(*cpu_item), 1);
 
         cpu_item->type = g_strdup(machine->possible_cpus->cpus[i].type);
@@ -726,7 +726,7 @@ HotpluggableCPUList *machine_query_hotpluggable_cpus(MachineState *machine)
 
         cpu = machine->possible_cpus->cpus[i].cpu;
         if (cpu) {
-            cpu_item->qom_path = object_get_canonical_path(cpu);
+            cpu_item->qom_path = object_get_canonical_path(OBJECT(cpu));
         }
         QAPI_LIST_PREPEND(head, cpu_item);
     }
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 2b6291ad8d..19464ea971 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -221,7 +221,7 @@ void x86_cpu_plug(HotplugHandler *hotplug_dev,
     }
 
     found_cpu = x86_find_cpu_slot(MACHINE(x86ms), cpu->apic_id, NULL);
-    found_cpu->cpu = OBJECT(dev);
+    found_cpu->cpu = CPU(dev);
 out:
     error_propagate(errp, local_err);
 }
diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
index c9a680e61a..524a53de06 100644
--- a/hw/loongarch/virt.c
+++ b/hw/loongarch/virt.c
@@ -811,7 +811,7 @@ static void loongarch_init(MachineState *machine)
     for (i = 0; i < possible_cpus->len; i++) {
         cpu = cpu_create(machine->cpu_type);
         cpu->cpu_index = i;
-        machine->possible_cpus->cpus[i].cpu = OBJECT(cpu);
+        machine->possible_cpus->cpus[i].cpu = cpu;
         lacpu = LOONGARCH_CPU(cpu);
         lacpu->phy_id = machine->possible_cpus->cpus[i].arch_id;
     }
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index e8dabc8614..0b77aa5514 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -3985,7 +3985,6 @@ static void spapr_core_plug(HotplugHandler *hotplug_dev, DeviceState *dev)
     SpaprMachineClass *smc = SPAPR_MACHINE_CLASS(mc);
     SpaprCpuCore *core = SPAPR_CPU_CORE(OBJECT(dev));
     CPUCore *cc = CPU_CORE(dev);
-    CPUState *cs;
     SpaprDrc *drc;
     CPUArchId *core_slot;
     int index;
@@ -4019,7 +4018,7 @@ static void spapr_core_plug(HotplugHandler *hotplug_dev, DeviceState *dev)
         }
     }
 
-    core_slot->cpu = OBJECT(dev);
+    core_slot->cpu = CPU(dev);
 
     /*
      * Set compatibility mode to match the boot CPU, which was either set
@@ -4035,7 +4034,7 @@ static void spapr_core_plug(HotplugHandler *hotplug_dev, DeviceState *dev)
 
     if (smc->pre_2_10_has_unused_icps) {
         for (i = 0; i < cc->nr_threads; i++) {
-            cs = CPU(core->threads[i]);
+            CPUState *cs = CPU(core->threads[i]);
             pre_2_10_vmstate_unregister_dummy_icp(cs->cpu_index);
         }
     }
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index c99682b07d..69e39e13ff 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -324,7 +324,7 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
     ERRP_GUARD();
 
     g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
-    ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
+    ms->possible_cpus->cpus[cpu->env.core_id].cpu = CPU(dev);
 
     if (s390_has_topology()) {
         s390_topology_setup_cpu(ms, cpu, errp);
-- 
2.41.0


