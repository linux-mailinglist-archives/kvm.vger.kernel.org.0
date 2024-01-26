Return-Path: <kvm+bounces-7224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 034FB83E48A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:06:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46F9C1F22EB3
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45AD2E3E4;
	Fri, 26 Jan 2024 22:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hylBX4mq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F818288D8
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306715; cv=none; b=eue1w4wN4n9odlckihPac+T/AZdrbgU8UTZI2R6XUDS6mkO3jhotwju2PgwcZ9/3d9ilrgTy9xzh8Yu+ksf0eJg/vpWkxj5KzdK6jZUrvjyyl8+AImON8+ezCDL5nP4HiD2qZ8KNDYI5bFNLaz1hAd8aMAIMOx5Xs99gKQ/Qtnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306715; c=relaxed/simple;
	bh=1TVdL89RBnPjxKjnJBGja3eYFC8VSfzeuCV6snwpOMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h0AsVd4kV2py9ouPeMrge0Gb1tLb1cyPUBwuNMbtOK7UYfgK52lVQB7cSebwNC3dpMv9ZwJB3omdtxCJeviWdkSDEnYMWFZ3ehx9owetR+n9gVvH90mAq3T1H0CUbU38UkFJ81lew8TIIvkacqEvnEi8kskokfkb/8MJ5pTkrBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hylBX4mq; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40ee418e7edso13000785e9.2
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306711; x=1706911511; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O/oRcO4tifb6RNqppQVorvK9C+RbZOPQjJLz1T1FbLY=;
        b=hylBX4mq0UDZPCjuAdG2r2TrtK2m8NLInqHnQJjxUss3W9HHsVHU5JvGVUD6k2YjHx
         DYVcjS3T5rKJwLL90rcsQb+kLIM+Rd7m2gI9M9FXA2lgxHzFOGNB5BkTkQci8NfjCQFq
         03w7UVo3dz8tUcARRziNhmq+BMjLeVhRB9XWcdcu+ogGg4HasKnFHJlC4gUllpiFLIRr
         5NVDfCay60HHajpcwCaxoDbQ85nBwPRMKvtXxxxKffEZVH0LIrqcU39gbbABrFikPYzK
         Vsg2bWrLchs4m1ocpQ6FIHbMwDJVo9NZCLW9iA/CwFX5LBONQPhIy/mtjtHeBJQ0/UHQ
         Ph8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306711; x=1706911511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O/oRcO4tifb6RNqppQVorvK9C+RbZOPQjJLz1T1FbLY=;
        b=u4rpytwEtVS/3x4wKAjxjfaqH6cpDDj6U4S3K11Mpm0wfytHF7IcFh2b47uclovkjf
         uV7tQzP9lrPw+HbzPRs7aGFFu7m2F7mF96cXN/eGrq0aczuyT2x6AbqIKfgXCcZRnRI2
         iPYFoyOQ6pTe6/ANDDUnidS3RyA0CfS3pUNZr03TFLFuSsJaxTZWHVWoqNYJHQhzcIpb
         VcGyV2jnKw/ABq5Bkj4YswAKM57wAwjhqttmMFCchAL19rOegWpV96RKuOPdJFnulYsj
         bPUG80agHpDQqNhypWXlBa0qxkHX5izFfHgIcn/3xDJdAdiiy4G/rAengqieL9y77Lka
         9D4w==
X-Gm-Message-State: AOJu0YzwkKLIhX7ZunLROd6X2MHK7d/ThDGcHOgcsasds39f09xN5zmE
	Uguq0KieS1AEx4v2tHcXQVS6MIlTQl4PQ3XF1cwPuAJJgG3oHO4s+UrW7q4O3Tw=
X-Google-Smtp-Source: AGHT+IFqlZ6gejaHz+iVyCgYbo6dNxfkBfnjFlmKrgI+NEH34xUembPlE5gAMbO4+w2GB13SlMXmPA==
X-Received: by 2002:a05:600c:2d03:b0:40e:4ab2:cd75 with SMTP id x3-20020a05600c2d0300b0040e4ab2cd75mr349220wmf.74.1706306711223;
        Fri, 26 Jan 2024 14:05:11 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id cw18-20020a170906c79200b00a31636793dfsm1038645ejb.201.2024.01.26.14.05.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:05:10 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	qemu-riscv@nongnu.org,
	Eduardo Habkost <eduardo@habkost.net>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v2 10/23] target/i386: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:03:52 +0100
Message-ID: <20240126220407.95022-11-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240126220407.95022-1-philmd@linaro.org>
References: <20240126220407.95022-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Mechanical patch produced running the command documented
in scripts/coccinelle/cpu_env.cocci_template header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/hvf/vmx.h               | 13 +++-------
 hw/i386/vmmouse.c                   |  6 ++---
 hw/i386/xen/xen-hvm.c               |  3 +--
 target/i386/arch_memory_mapping.c   |  3 +--
 target/i386/cpu-dump.c              |  3 +--
 target/i386/cpu.c                   | 37 +++++++++------------------
 target/i386/helper.c                | 39 ++++++++---------------------
 target/i386/hvf/hvf.c               |  8 ++----
 target/i386/hvf/x86.c               |  4 +--
 target/i386/hvf/x86_emu.c           |  6 ++---
 target/i386/hvf/x86_task.c          | 10 +++-----
 target/i386/hvf/x86hvf.c            |  6 ++---
 target/i386/kvm/kvm.c               |  6 ++---
 target/i386/kvm/xen-emu.c           | 32 ++++++++---------------
 target/i386/tcg/sysemu/bpt_helper.c |  3 +--
 target/i386/tcg/tcg-cpu.c           | 14 +++--------
 target/i386/tcg/user/excp_helper.c  |  3 +--
 target/i386/tcg/user/seg_helper.c   |  3 +--
 18 files changed, 59 insertions(+), 140 deletions(-)

diff --git a/target/i386/hvf/vmx.h b/target/i386/hvf/vmx.h
index 0fffcfa46c..1ad042269b 100644
--- a/target/i386/hvf/vmx.h
+++ b/target/i386/hvf/vmx.h
@@ -175,8 +175,7 @@ static inline void macvm_set_cr4(hv_vcpuid_t vcpu, uint64_t cr4)
 
 static inline void macvm_set_rip(CPUState *cpu, uint64_t rip)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
+    CPUX86State *env = cpu_env(cpu);
     uint64_t val;
 
     /* BUG, should take considering overlap.. */
@@ -196,10 +195,7 @@ static inline void macvm_set_rip(CPUState *cpu, uint64_t rip)
 
 static inline void vmx_clear_nmi_blocking(CPUState *cpu)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
-
-    env->hflags2 &= ~HF2_NMI_MASK;
+    cpu_env(cpu)->hflags2 &= ~HF2_NMI_MASK;
     uint32_t gi = (uint32_t) rvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY);
     gi &= ~VMCS_INTERRUPTIBILITY_NMI_BLOCKING;
     wvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY, gi);
@@ -207,10 +203,7 @@ static inline void vmx_clear_nmi_blocking(CPUState *cpu)
 
 static inline void vmx_set_nmi_blocking(CPUState *cpu)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
-
-    env->hflags2 |= HF2_NMI_MASK;
+    cpu_env(cpu)->hflags2 |= HF2_NMI_MASK;
     uint32_t gi = (uint32_t)rvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY);
     gi |= VMCS_INTERRUPTIBILITY_NMI_BLOCKING;
     wvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY, gi);
diff --git a/hw/i386/vmmouse.c b/hw/i386/vmmouse.c
index a8d014d09a..f292a14a15 100644
--- a/hw/i386/vmmouse.c
+++ b/hw/i386/vmmouse.c
@@ -74,8 +74,7 @@ struct VMMouseState {
 
 static void vmmouse_get_data(uint32_t *data)
 {
-    X86CPU *cpu = X86_CPU(current_cpu);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(current_cpu);
 
     data[0] = env->regs[R_EAX]; data[1] = env->regs[R_EBX];
     data[2] = env->regs[R_ECX]; data[3] = env->regs[R_EDX];
@@ -84,8 +83,7 @@ static void vmmouse_get_data(uint32_t *data)
 
 static void vmmouse_set_data(const uint32_t *data)
 {
-    X86CPU *cpu = X86_CPU(current_cpu);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(current_cpu);
 
     env->regs[R_EAX] = data[0]; env->regs[R_EBX] = data[1];
     env->regs[R_ECX] = data[2]; env->regs[R_EDX] = data[3];
diff --git a/hw/i386/xen/xen-hvm.c b/hw/i386/xen/xen-hvm.c
index f42621e674..61e5060117 100644
--- a/hw/i386/xen/xen-hvm.c
+++ b/hw/i386/xen/xen-hvm.c
@@ -487,8 +487,7 @@ static void regs_to_cpu(vmware_regs_t *vmport_regs, ioreq_t *req)
 
 static void regs_from_cpu(vmware_regs_t *vmport_regs)
 {
-    X86CPU *cpu = X86_CPU(current_cpu);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(current_cpu);
 
     vmport_regs->ebx = env->regs[R_EBX];
     vmport_regs->ecx = env->regs[R_ECX];
diff --git a/target/i386/arch_memory_mapping.c b/target/i386/arch_memory_mapping.c
index d1ff659128..c0604d5956 100644
--- a/target/i386/arch_memory_mapping.c
+++ b/target/i386/arch_memory_mapping.c
@@ -269,8 +269,7 @@ static void walk_pml5e(MemoryMappingList *list, AddressSpace *as,
 bool x86_cpu_get_memory_mapping(CPUState *cs, MemoryMappingList *list,
                                 Error **errp)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     int32_t a20_mask;
 
     if (!cpu_paging_enabled(cs)) {
diff --git a/target/i386/cpu-dump.c b/target/i386/cpu-dump.c
index 40697064d9..5459d84abd 100644
--- a/target/i386/cpu-dump.c
+++ b/target/i386/cpu-dump.c
@@ -343,8 +343,7 @@ void x86_cpu_dump_local_apic_state(CPUState *cs, int flags)
 
 void x86_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     int eflags, i, nb;
     char cc_op_name[32];
     static const char *seg_name[6] = { "ES", "CS", "SS", "DS", "FS", "GS" };
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 03822d9ba8..4702bff071 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5062,8 +5062,7 @@ static void x86_cpuid_version_get_family(Object *obj, Visitor *v,
                                          const char *name, void *opaque,
                                          Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     int64_t value;
 
     value = (env->cpuid_version >> 8) & 0xf;
@@ -5077,8 +5076,7 @@ static void x86_cpuid_version_set_family(Object *obj, Visitor *v,
                                          const char *name, void *opaque,
                                          Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     const int64_t min = 0;
     const int64_t max = 0xff + 0xf;
     int64_t value;
@@ -5104,8 +5102,7 @@ static void x86_cpuid_version_get_model(Object *obj, Visitor *v,
                                         const char *name, void *opaque,
                                         Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     int64_t value;
 
     value = (env->cpuid_version >> 4) & 0xf;
@@ -5117,8 +5114,7 @@ static void x86_cpuid_version_set_model(Object *obj, Visitor *v,
                                         const char *name, void *opaque,
                                         Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     const int64_t min = 0;
     const int64_t max = 0xff;
     int64_t value;
@@ -5140,11 +5136,9 @@ static void x86_cpuid_version_get_stepping(Object *obj, Visitor *v,
                                            const char *name, void *opaque,
                                            Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
     int64_t value;
 
-    value = env->cpuid_version & 0xf;
+    value = cpu_env(CPU(obj))->cpuid_version & 0xf;
     visit_type_int(v, name, &value, errp);
 }
 
@@ -5152,8 +5146,7 @@ static void x86_cpuid_version_set_stepping(Object *obj, Visitor *v,
                                            const char *name, void *opaque,
                                            Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     const int64_t min = 0;
     const int64_t max = 0xf;
     int64_t value;
@@ -5173,8 +5166,7 @@ static void x86_cpuid_version_set_stepping(Object *obj, Visitor *v,
 
 static char *x86_cpuid_get_vendor(Object *obj, Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     char *value;
 
     value = g_malloc(CPUID_VENDOR_SZ + 1);
@@ -5186,8 +5178,7 @@ static char *x86_cpuid_get_vendor(Object *obj, Error **errp)
 static void x86_cpuid_set_vendor(Object *obj, const char *value,
                                  Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     int i;
 
     if (strlen(value) != CPUID_VENDOR_SZ) {
@@ -5208,8 +5199,7 @@ static void x86_cpuid_set_vendor(Object *obj, const char *value,
 
 static char *x86_cpuid_get_model_id(Object *obj, Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     char *value;
     int i;
 
@@ -5224,8 +5214,7 @@ static char *x86_cpuid_get_model_id(Object *obj, Error **errp)
 static void x86_cpuid_set_model_id(Object *obj, const char *model_id,
                                    Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     int c, len, i;
 
     if (model_id == NULL) {
@@ -7673,8 +7662,7 @@ static vaddr x86_cpu_get_pc(CPUState *cs)
 
 int x86_cpu_pending_interrupt(CPUState *cs, int interrupt_request)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
 #if !defined(CONFIG_USER_ONLY)
     if (interrupt_request & CPU_INTERRUPT_POLL) {
@@ -7722,8 +7710,7 @@ static bool x86_cpu_has_work(CPUState *cs)
 
 static void x86_disas_set_info(CPUState *cs, disassemble_info *info)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     info->mach = (env->hflags & HF_CS64_MASK ? bfd_mach_x86_64
                   : env->hflags & HF_CS32_MASK ? bfd_mach_i386_i386
diff --git a/target/i386/helper.c b/target/i386/helper.c
index 2070dd0dda..1e519c8b13 100644
--- a/target/i386/helper.c
+++ b/target/i386/helper.c
@@ -230,8 +230,7 @@ void cpu_x86_update_cr4(CPUX86State *env, uint32_t new_cr4)
 hwaddr x86_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
                                          MemTxAttrs *attrs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     target_ulong pde_addr, pte_addr;
     uint64_t pte;
     int32_t a20_mask;
@@ -625,9 +624,7 @@ void cpu_load_efer(CPUX86State *env, uint64_t val)
 
 uint8_t x86_ldub_phys(CPUState *cs, hwaddr addr)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
-    MemTxAttrs attrs = cpu_get_mem_attrs(env);
+    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
     return address_space_ldub(as, addr, attrs, NULL);
@@ -635,9 +632,7 @@ uint8_t x86_ldub_phys(CPUState *cs, hwaddr addr)
 
 uint32_t x86_lduw_phys(CPUState *cs, hwaddr addr)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
-    MemTxAttrs attrs = cpu_get_mem_attrs(env);
+    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
     return address_space_lduw(as, addr, attrs, NULL);
@@ -645,9 +640,7 @@ uint32_t x86_lduw_phys(CPUState *cs, hwaddr addr)
 
 uint32_t x86_ldl_phys(CPUState *cs, hwaddr addr)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
-    MemTxAttrs attrs = cpu_get_mem_attrs(env);
+    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
     return address_space_ldl(as, addr, attrs, NULL);
@@ -655,9 +648,7 @@ uint32_t x86_ldl_phys(CPUState *cs, hwaddr addr)
 
 uint64_t x86_ldq_phys(CPUState *cs, hwaddr addr)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
-    MemTxAttrs attrs = cpu_get_mem_attrs(env);
+    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
     return address_space_ldq(as, addr, attrs, NULL);
@@ -665,9 +656,7 @@ uint64_t x86_ldq_phys(CPUState *cs, hwaddr addr)
 
 void x86_stb_phys(CPUState *cs, hwaddr addr, uint8_t val)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
-    MemTxAttrs attrs = cpu_get_mem_attrs(env);
+    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
     address_space_stb(as, addr, val, attrs, NULL);
@@ -675,9 +664,7 @@ void x86_stb_phys(CPUState *cs, hwaddr addr, uint8_t val)
 
 void x86_stl_phys_notdirty(CPUState *cs, hwaddr addr, uint32_t val)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
-    MemTxAttrs attrs = cpu_get_mem_attrs(env);
+    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
     address_space_stl_notdirty(as, addr, val, attrs, NULL);
@@ -685,9 +672,7 @@ void x86_stl_phys_notdirty(CPUState *cs, hwaddr addr, uint32_t val)
 
 void x86_stw_phys(CPUState *cs, hwaddr addr, uint32_t val)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
-    MemTxAttrs attrs = cpu_get_mem_attrs(env);
+    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
     address_space_stw(as, addr, val, attrs, NULL);
@@ -695,9 +680,7 @@ void x86_stw_phys(CPUState *cs, hwaddr addr, uint32_t val)
 
 void x86_stl_phys(CPUState *cs, hwaddr addr, uint32_t val)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
-    MemTxAttrs attrs = cpu_get_mem_attrs(env);
+    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
     address_space_stl(as, addr, val, attrs, NULL);
@@ -705,9 +688,7 @@ void x86_stl_phys(CPUState *cs, hwaddr addr, uint32_t val)
 
 void x86_stq_phys(CPUState *cs, hwaddr addr, uint64_t val)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
-    MemTxAttrs attrs = cpu_get_mem_attrs(env);
+    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
     address_space_stq(as, addr, val, attrs, NULL);
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 11ffdd4c69..772578e3f4 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -159,10 +159,7 @@ static bool ept_emulation_fault(hvf_slot *slot, uint64_t gpa, uint64_t ept_qual)
 
 void hvf_arch_vcpu_destroy(CPUState *cpu)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
-
-    g_free(env->hvf_mmio_buf);
+    g_free(cpu_env(cpu)->hvf_mmio_buf);
 }
 
 static void init_tsc_freq(CPUX86State *env)
@@ -313,8 +310,7 @@ int hvf_arch_init_vcpu(CPUState *cpu)
 
 static void hvf_store_events(CPUState *cpu, uint32_t ins_len, uint64_t idtvec_info)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
+    CPUX86State *env = cpu_env(cpu);
 
     env->exception_nr = -1;
     env->exception_pending = 0;
diff --git a/target/i386/hvf/x86.c b/target/i386/hvf/x86.c
index 80e36136d0..932635232b 100644
--- a/target/i386/hvf/x86.c
+++ b/target/i386/hvf/x86.c
@@ -128,9 +128,7 @@ bool x86_is_real(CPUState *cpu)
 
 bool x86_is_v8086(CPUState *cpu)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
-    return x86_is_protected(cpu) && (env->eflags & VM_MASK);
+    return x86_is_protected(cpu) && (cpu_env(cpu)->eflags & VM_MASK);
 }
 
 bool x86_is_long_mode(CPUState *cpu)
diff --git a/target/i386/hvf/x86_emu.c b/target/i386/hvf/x86_emu.c
index 3a3f0a50d0..0d13b32f91 100644
--- a/target/i386/hvf/x86_emu.c
+++ b/target/i386/hvf/x86_emu.c
@@ -1419,8 +1419,7 @@ static void init_cmd_handler()
 
 void load_regs(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     int i = 0;
     RRX(env, R_EAX) = rreg(cs->accel->fd, HV_X86_RAX);
@@ -1442,8 +1441,7 @@ void load_regs(CPUState *cs)
 
 void store_regs(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     int i = 0;
     wreg(cs->accel->fd, HV_X86_RAX, RAX(env));
diff --git a/target/i386/hvf/x86_task.c b/target/i386/hvf/x86_task.c
index f09bfbdda5..c173e9d883 100644
--- a/target/i386/hvf/x86_task.c
+++ b/target/i386/hvf/x86_task.c
@@ -33,8 +33,7 @@
 // TODO: taskswitch handling
 static void save_state_to_tss32(CPUState *cpu, struct x86_tss_segment32 *tss)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
+    CPUX86State *env = cpu_env(cpu);
 
     /* CR3 and ldt selector are not saved intentionally */
     tss->eip = (uint32_t)env->eip;
@@ -58,8 +57,7 @@ static void save_state_to_tss32(CPUState *cpu, struct x86_tss_segment32 *tss)
 
 static void load_state_from_tss32(CPUState *cpu, struct x86_tss_segment32 *tss)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
+    CPUX86State *env = cpu_env(cpu);
 
     wvmcs(cpu->accel->fd, VMCS_GUEST_CR3, tss->cr3);
 
@@ -128,9 +126,7 @@ void vmx_handle_task_switch(CPUState *cpu, x68_segment_selector tss_sel, int rea
     uint32_t desc_limit;
     struct x86_call_gate task_gate_desc;
     struct vmx_segment vmx_seg;
-
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
+    CPUX86State *env = cpu_env(cpu);
 
     x86_read_segment_descriptor(cpu, &next_tss_desc, tss_sel);
     x86_read_segment_descriptor(cpu, &curr_tss_desc, old_tss_sel);
diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
index 3b1ef5f49a..1e7fd587fe 100644
--- a/target/i386/hvf/x86hvf.c
+++ b/target/i386/hvf/x86hvf.c
@@ -238,8 +238,7 @@ void hvf_get_msrs(CPUState *cs)
 
 int hvf_put_registers(CPUState *cs)
 {
-    X86CPU *x86cpu = X86_CPU(cs);
-    CPUX86State *env = &x86cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     wreg(cs->accel->fd, HV_X86_RAX, env->regs[R_EAX]);
     wreg(cs->accel->fd, HV_X86_RBX, env->regs[R_EBX]);
@@ -282,8 +281,7 @@ int hvf_put_registers(CPUState *cs)
 
 int hvf_get_registers(CPUState *cs)
 {
-    X86CPU *x86cpu = X86_CPU(cs);
-    CPUX86State *env = &x86cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     env->regs[R_EAX] = rreg(cs->accel->fd, HV_X86_RAX);
     env->regs[R_EBX] = rreg(cs->accel->fd, HV_X86_RBX);
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 76a66246eb..e4f1c62888 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -754,8 +754,7 @@ static inline bool freq_within_bounds(int freq, int target_freq)
 
 static int kvm_arch_set_tsc_khz(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     int r, cur_freq;
     bool set_ioctl = false;
 
@@ -5369,8 +5368,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
 
 bool kvm_arch_stop_on_emulation_error(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     kvm_cpu_synchronize_state(cs);
     return !(env->cr[0] & CR0_PE_MASK) ||
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index fc2c2321ac..10350a22d1 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -313,10 +313,7 @@ static int kvm_xen_set_vcpu_callback_vector(CPUState *cs)
 
 static void do_set_vcpu_callback_vector(CPUState *cs, run_on_cpu_data data)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
-
-    env->xen_vcpu_callback_vector = data.host_int;
+    cpu_env(cs)->xen_vcpu_callback_vector = data.host_int;
 
     if (kvm_xen_has_cap(EVTCHN_SEND)) {
         kvm_xen_set_vcpu_callback_vector(cs);
@@ -325,8 +322,7 @@ static void do_set_vcpu_callback_vector(CPUState *cs, run_on_cpu_data data)
 
 static int set_vcpu_info(CPUState *cs, uint64_t gpa)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     MemoryRegionSection mrs = { .mr = NULL };
     void *vcpu_info_hva = NULL;
     int ret;
@@ -362,8 +358,7 @@ static int set_vcpu_info(CPUState *cs, uint64_t gpa)
 
 static void do_set_vcpu_info_default_gpa(CPUState *cs, run_on_cpu_data data)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     env->xen_vcpu_info_default_gpa = data.host_ulong;
 
@@ -375,8 +370,7 @@ static void do_set_vcpu_info_default_gpa(CPUState *cs, run_on_cpu_data data)
 
 static void do_set_vcpu_info_gpa(CPUState *cs, run_on_cpu_data data)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     env->xen_vcpu_info_gpa = data.host_ulong;
 
@@ -479,8 +473,7 @@ void kvm_xen_inject_vcpu_callback_vector(uint32_t vcpu_id, int type)
 /* Must always be called with xen_timers_lock held */
 static int kvm_xen_set_vcpu_timer(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     struct kvm_xen_vcpu_attr va = {
         .type = KVM_XEN_VCPU_ATTR_TYPE_TIMER,
@@ -527,8 +520,7 @@ int kvm_xen_set_vcpu_virq(uint32_t vcpu_id, uint16_t virq, uint16_t port)
 
 static void do_set_vcpu_time_info_gpa(CPUState *cs, run_on_cpu_data data)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     env->xen_vcpu_time_info_gpa = data.host_ulong;
 
@@ -538,8 +530,7 @@ static void do_set_vcpu_time_info_gpa(CPUState *cs, run_on_cpu_data data)
 
 static void do_set_vcpu_runstate_gpa(CPUState *cs, run_on_cpu_data data)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     env->xen_vcpu_runstate_gpa = data.host_ulong;
 
@@ -549,8 +540,7 @@ static void do_set_vcpu_runstate_gpa(CPUState *cs, run_on_cpu_data data)
 
 static void do_vcpu_soft_reset(CPUState *cs, run_on_cpu_data data)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     env->xen_vcpu_info_gpa = INVALID_GPA;
     env->xen_vcpu_info_default_gpa = INVALID_GPA;
@@ -1813,8 +1803,7 @@ uint16_t kvm_xen_get_evtchn_max_pirq(void)
 
 int kvm_put_xen_state(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     uint64_t gpa;
     int ret;
 
@@ -1887,8 +1876,7 @@ int kvm_put_xen_state(CPUState *cs)
 
 int kvm_get_xen_state(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     uint64_t gpa;
     int ret;
 
diff --git a/target/i386/tcg/sysemu/bpt_helper.c b/target/i386/tcg/sysemu/bpt_helper.c
index 4d96a48a3c..90d6117497 100644
--- a/target/i386/tcg/sysemu/bpt_helper.c
+++ b/target/i386/tcg/sysemu/bpt_helper.c
@@ -208,8 +208,7 @@ bool check_hw_breakpoints(CPUX86State *env, bool force_dr6_update)
 
 void breakpoint_handler(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     if (cs->watchpoint_hit) {
         if (cs->watchpoint_hit->flags & BP_CPU) {
diff --git a/target/i386/tcg/tcg-cpu.c b/target/i386/tcg/tcg-cpu.c
index e1405b7be9..8f8fd6529d 100644
--- a/target/i386/tcg/tcg-cpu.c
+++ b/target/i386/tcg/tcg-cpu.c
@@ -29,8 +29,7 @@
 
 static void x86_cpu_exec_enter(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     CC_SRC = env->eflags & (CC_O | CC_S | CC_Z | CC_A | CC_P | CC_C);
     env->df = 1 - (2 * ((env->eflags >> 10) & 1));
@@ -40,8 +39,7 @@ static void x86_cpu_exec_enter(CPUState *cs)
 
 static void x86_cpu_exec_exit(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     env->eflags = cpu_compute_eflags(env);
 }
@@ -65,8 +63,7 @@ static void x86_restore_state_to_opc(CPUState *cs,
                                      const TranslationBlock *tb,
                                      const uint64_t *data)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     int cc_op = data[1];
     uint64_t new_pc;
 
@@ -96,11 +93,8 @@ static void x86_restore_state_to_opc(CPUState *cs,
 #ifndef CONFIG_USER_ONLY
 static bool x86_debug_check_breakpoint(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
-
     /* RF disables all architectural breakpoints. */
-    return !(env->eflags & RF_MASK);
+    return !(cpu_env(cs)->eflags & RF_MASK);
 }
 #endif
 
diff --git a/target/i386/tcg/user/excp_helper.c b/target/i386/tcg/user/excp_helper.c
index b3bdb7831a..bfcae9f39e 100644
--- a/target/i386/tcg/user/excp_helper.c
+++ b/target/i386/tcg/user/excp_helper.c
@@ -26,8 +26,7 @@ void x86_cpu_record_sigsegv(CPUState *cs, vaddr addr,
                             MMUAccessType access_type,
                             bool maperr, uintptr_t ra)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     /*
      * The error_code that hw reports as part of the exception frame
diff --git a/target/i386/tcg/user/seg_helper.c b/target/i386/tcg/user/seg_helper.c
index c45f2ac2ba..2f89dbb51e 100644
--- a/target/i386/tcg/user/seg_helper.c
+++ b/target/i386/tcg/user/seg_helper.c
@@ -78,8 +78,7 @@ static void do_interrupt_user(CPUX86State *env, int intno, int is_int,
 
 void x86_cpu_do_interrupt(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     /* if user mode only, we simulate a fake exception
        which will be handled outside the cpu execution
-- 
2.41.0


