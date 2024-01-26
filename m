Return-Path: <kvm+bounces-7223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB16583E487
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:06:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1C9A2863C9
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 434834A987;
	Fri, 26 Jan 2024 22:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z18nvbSK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4216C47A5F
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306708; cv=none; b=XmVx6gUw0p2Xxzju3ou4hoQLu/Zash9+6bH0ZDynlL6ncIQ96hYVOnpbdnu85aILtFOgmDW/FettEgg9iGyu5pygg7x4pkHUbtbJoGM8aYETkYiYeB2mP3/jJ5hhmZZ4GEvMrfzRdR30+NT8EQyNMz/oc9nFlcr5nRDO2hmsGq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306708; c=relaxed/simple;
	bh=5nN54E3QaN9fIKrh+f913xl05sgRTstRxwDwdFy3IhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rnzoZw34h6/AY6cV1FieHbxEanwjSySN1uVsw4q0PcPp9FW9sKTfa4E80H3EuzdpRXwKqc4hMBoddIKB4Pda7K9BMpp8myE5WEWnn0vvYgdGCND3xkOrRXxWjTjbS5Fys9TOfhu60irefprq0S8Mq44x/9+17Q8BjUg4L+MDRwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z18nvbSK; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a352c91457bso35497766b.1
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306704; x=1706911504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3QQAYRUB98rUN30LN98QVH8jAOd3KtarXuPYMe2XkgM=;
        b=Z18nvbSKWaF0Gq/d8zcbBVqYlURwCFc4qAbKNys5YjElN6W/aw4Zp21UfkXnT9IZ7u
         wVeH92BNJhCN27AtEddwFV2SDB/q0NPNeLLXSVCQ5MksA48c9AXcLB2uG45fg2vV4sMj
         ZV5pWor0ei/wKLi6NzGdFPB7JYonbUe+6aSGvp/HzxbFUsiivBP6YykCNTztZZEFMkfr
         lCQ4Cd9WLr+c1/l+9vQTKr1XJgAIWx38ed5mNpudkQuj/5oOvlItbzP3Az4u7aVNjEgc
         twgYe+phVTa2d/Qsh7ndSxy9nVt3vfSnoY7NNdL8oAj9kJgXovZEB8DXKsnlors5HGIQ
         +tzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306704; x=1706911504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3QQAYRUB98rUN30LN98QVH8jAOd3KtarXuPYMe2XkgM=;
        b=T7HsYagP8oCmhlJwMGVovgR0Vi/mLWmxLrEk95+bk/xKWkqlHHLuz+ccxLwhBJ14bG
         cqc6r/S/oC3tonJUZ29usIuqjhj8KhM2HS7LxaIHU9SnOnqwLRFzeD5sSnN0I9vBQE9R
         +0s5/De6712MoMgbxdhzrgkvvVHKLKD3REDcRFYWwYL/TY0B4eyRtmfrWGZek6bv9IkD
         jSTDbTaqHL1fhZ56djdAuwWysvexMB84dyQCHE1n7Wm4OYD/QZ3VUjSEi+wW6gthnhia
         /NRBJJ4tevWGqIgPUA6moR/NmQpVXTO9EkUvoIVdIc4qCjiewVC7SLlBTCUxlhB0w7pA
         JPFQ==
X-Gm-Message-State: AOJu0YyKIGyLlohDTfiC46u6l4L9TUBX9Gk7mwrd+j65nIILjZGgOO2R
	eu2p5axgnff94m/vPd16rmPdksaAzsL2DKWOuMnkTo8H9KzCTKRedAu8028ks6I=
X-Google-Smtp-Source: AGHT+IEIIvvlpHADNTO1RKLZfb2gdjMYCdObg+W0OCTSZ9/dcmxI+BdYXEzJV10rqzysi2Y4EQ2QYQ==
X-Received: by 2002:a17:906:4807:b0:a35:2758:579e with SMTP id w7-20020a170906480700b00a352758579emr567878ejq.34.1706306704551;
        Fri, 26 Jan 2024 14:05:04 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id fj17-20020a1709069c9100b00a2ada87f6a1sm1061882ejc.90.2024.01.26.14.05.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:05:04 -0800 (PST)
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
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>
Subject: [PATCH v2 09/23] target/i386/hvf: Use CPUState typedef
Date: Fri, 26 Jan 2024 23:03:51 +0100
Message-ID: <20240126220407.95022-10-philmd@linaro.org>
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

QEMU coding style recommend using structure typedefs:
https://www.qemu.org/docs/master/devel/style.html#typedefs

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/hvf/x86.h       | 26 +++++++++++++-------------
 target/i386/hvf/x86_descr.h | 14 +++++++-------
 target/i386/hvf/x86_emu.h   |  4 ++--
 target/i386/hvf/x86_mmu.h   |  6 +++---
 target/i386/hvf/x86.c       | 26 +++++++++++++-------------
 target/i386/hvf/x86_descr.c |  8 ++++----
 target/i386/hvf/x86_mmu.c   | 14 +++++++-------
 7 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/target/i386/hvf/x86.h b/target/i386/hvf/x86.h
index 947b98da41..3570f29aa9 100644
--- a/target/i386/hvf/x86.h
+++ b/target/i386/hvf/x86.h
@@ -248,30 +248,30 @@ typedef struct x68_segment_selector {
 #define BH(cpu)        RH(cpu, R_EBX)
 
 /* deal with GDT/LDT descriptors in memory */
-bool x86_read_segment_descriptor(struct CPUState *cpu,
+bool x86_read_segment_descriptor(CPUState *cpu,
                                  struct x86_segment_descriptor *desc,
                                  x68_segment_selector sel);
-bool x86_write_segment_descriptor(struct CPUState *cpu,
+bool x86_write_segment_descriptor(CPUState *cpu,
                                   struct x86_segment_descriptor *desc,
                                   x68_segment_selector sel);
 
-bool x86_read_call_gate(struct CPUState *cpu, struct x86_call_gate *idt_desc,
+bool x86_read_call_gate(CPUState *cpu, struct x86_call_gate *idt_desc,
                         int gate);
 
 /* helpers */
-bool x86_is_protected(struct CPUState *cpu);
-bool x86_is_real(struct CPUState *cpu);
-bool x86_is_v8086(struct CPUState *cpu);
-bool x86_is_long_mode(struct CPUState *cpu);
-bool x86_is_long64_mode(struct CPUState *cpu);
-bool x86_is_paging_mode(struct CPUState *cpu);
-bool x86_is_pae_enabled(struct CPUState *cpu);
+bool x86_is_protected(CPUState *cpu);
+bool x86_is_real(CPUState *cpu);
+bool x86_is_v8086(CPUState *cpu);
+bool x86_is_long_mode(CPUState *cpu);
+bool x86_is_long64_mode(CPUState *cpu);
+bool x86_is_paging_mode(CPUState *cpu);
+bool x86_is_pae_enabled(CPUState *cpu);
 
 enum X86Seg;
-target_ulong linear_addr(struct CPUState *cpu, target_ulong addr, enum X86Seg seg);
-target_ulong linear_addr_size(struct CPUState *cpu, target_ulong addr, int size,
+target_ulong linear_addr(CPUState *cpu, target_ulong addr, enum X86Seg seg);
+target_ulong linear_addr_size(CPUState *cpu, target_ulong addr, int size,
                               enum X86Seg seg);
-target_ulong linear_rip(struct CPUState *cpu, target_ulong rip);
+target_ulong linear_rip(CPUState *cpu, target_ulong rip);
 
 static inline uint64_t rdtscp(void)
 {
diff --git a/target/i386/hvf/x86_descr.h b/target/i386/hvf/x86_descr.h
index c356932fa4..9f06014b56 100644
--- a/target/i386/hvf/x86_descr.h
+++ b/target/i386/hvf/x86_descr.h
@@ -29,29 +29,29 @@ typedef struct vmx_segment {
 } vmx_segment;
 
 /* deal with vmstate descriptors */
-void vmx_read_segment_descriptor(struct CPUState *cpu,
+void vmx_read_segment_descriptor(CPUState *cpu,
                                  struct vmx_segment *desc, enum X86Seg seg);
 void vmx_write_segment_descriptor(CPUState *cpu, struct vmx_segment *desc,
                                   enum X86Seg seg);
 
-x68_segment_selector vmx_read_segment_selector(struct CPUState *cpu,
+x68_segment_selector vmx_read_segment_selector(CPUState *cpu,
                                                enum X86Seg seg);
-void vmx_write_segment_selector(struct CPUState *cpu,
+void vmx_write_segment_selector(CPUState *cpu,
                                 x68_segment_selector selector,
                                 enum X86Seg seg);
 
-uint64_t vmx_read_segment_base(struct CPUState *cpu, enum X86Seg seg);
-void vmx_write_segment_base(struct CPUState *cpu, enum X86Seg seg,
+uint64_t vmx_read_segment_base(CPUState *cpu, enum X86Seg seg);
+void vmx_write_segment_base(CPUState *cpu, enum X86Seg seg,
                             uint64_t base);
 
-void x86_segment_descriptor_to_vmx(struct CPUState *cpu,
+void x86_segment_descriptor_to_vmx(CPUState *cpu,
                                    x68_segment_selector selector,
                                    struct x86_segment_descriptor *desc,
                                    struct vmx_segment *vmx_desc);
 
 uint32_t vmx_read_segment_limit(CPUState *cpu, enum X86Seg seg);
 uint32_t vmx_read_segment_ar(CPUState *cpu, enum X86Seg seg);
-void vmx_segment_to_x86_descriptor(struct CPUState *cpu,
+void vmx_segment_to_x86_descriptor(CPUState *cpu,
                                    struct vmx_segment *vmx_desc,
                                    struct x86_segment_descriptor *desc);
 
diff --git a/target/i386/hvf/x86_emu.h b/target/i386/hvf/x86_emu.h
index 4b846ba80e..8bd97608c4 100644
--- a/target/i386/hvf/x86_emu.h
+++ b/target/i386/hvf/x86_emu.h
@@ -26,8 +26,8 @@
 void init_emu(void);
 bool exec_instruction(CPUX86State *env, struct x86_decode *ins);
 
-void load_regs(struct CPUState *cpu);
-void store_regs(struct CPUState *cpu);
+void load_regs(CPUState *cpu);
+void store_regs(CPUState *cpu);
 
 void simulate_rdmsr(CPUX86State *env);
 void simulate_wrmsr(CPUX86State *env);
diff --git a/target/i386/hvf/x86_mmu.h b/target/i386/hvf/x86_mmu.h
index 9ae8a548de..9447ae072c 100644
--- a/target/i386/hvf/x86_mmu.h
+++ b/target/i386/hvf/x86_mmu.h
@@ -36,9 +36,9 @@
 #define MMU_PAGE_US             (1 << 2)
 #define MMU_PAGE_NX             (1 << 3)
 
-bool mmu_gva_to_gpa(struct CPUState *cpu, target_ulong gva, uint64_t *gpa);
+bool mmu_gva_to_gpa(CPUState *cpu, target_ulong gva, uint64_t *gpa);
 
-void vmx_write_mem(struct CPUState *cpu, target_ulong gva, void *data, int bytes);
-void vmx_read_mem(struct CPUState *cpu, void *data, target_ulong gva, int bytes);
+void vmx_write_mem(CPUState *cpu, target_ulong gva, void *data, int bytes);
+void vmx_read_mem(CPUState *cpu, void *data, target_ulong gva, int bytes);
 
 #endif /* X86_MMU_H */
diff --git a/target/i386/hvf/x86.c b/target/i386/hvf/x86.c
index 8ceea6398e..80e36136d0 100644
--- a/target/i386/hvf/x86.c
+++ b/target/i386/hvf/x86.c
@@ -46,7 +46,7 @@
    return ar;
 }*/
 
-bool x86_read_segment_descriptor(struct CPUState *cpu,
+bool x86_read_segment_descriptor(CPUState *cpu,
                                  struct x86_segment_descriptor *desc,
                                  x68_segment_selector sel)
 {
@@ -76,7 +76,7 @@ bool x86_read_segment_descriptor(struct CPUState *cpu,
     return true;
 }
 
-bool x86_write_segment_descriptor(struct CPUState *cpu,
+bool x86_write_segment_descriptor(CPUState *cpu,
                                   struct x86_segment_descriptor *desc,
                                   x68_segment_selector sel)
 {
@@ -99,7 +99,7 @@ bool x86_write_segment_descriptor(struct CPUState *cpu,
     return true;
 }
 
-bool x86_read_call_gate(struct CPUState *cpu, struct x86_call_gate *idt_desc,
+bool x86_read_call_gate(CPUState *cpu, struct x86_call_gate *idt_desc,
                         int gate)
 {
     target_ulong base  = rvmcs(cpu->accel->fd, VMCS_GUEST_IDTR_BASE);
@@ -115,30 +115,30 @@ bool x86_read_call_gate(struct CPUState *cpu, struct x86_call_gate *idt_desc,
     return true;
 }
 
-bool x86_is_protected(struct CPUState *cpu)
+bool x86_is_protected(CPUState *cpu)
 {
     uint64_t cr0 = rvmcs(cpu->accel->fd, VMCS_GUEST_CR0);
     return cr0 & CR0_PE_MASK;
 }
 
-bool x86_is_real(struct CPUState *cpu)
+bool x86_is_real(CPUState *cpu)
 {
     return !x86_is_protected(cpu);
 }
 
-bool x86_is_v8086(struct CPUState *cpu)
+bool x86_is_v8086(CPUState *cpu)
 {
     X86CPU *x86_cpu = X86_CPU(cpu);
     CPUX86State *env = &x86_cpu->env;
     return x86_is_protected(cpu) && (env->eflags & VM_MASK);
 }
 
-bool x86_is_long_mode(struct CPUState *cpu)
+bool x86_is_long_mode(CPUState *cpu)
 {
     return rvmcs(cpu->accel->fd, VMCS_GUEST_IA32_EFER) & MSR_EFER_LMA;
 }
 
-bool x86_is_long64_mode(struct CPUState *cpu)
+bool x86_is_long64_mode(CPUState *cpu)
 {
     struct vmx_segment desc;
     vmx_read_segment_descriptor(cpu, &desc, R_CS);
@@ -146,24 +146,24 @@ bool x86_is_long64_mode(struct CPUState *cpu)
     return x86_is_long_mode(cpu) && ((desc.ar >> 13) & 1);
 }
 
-bool x86_is_paging_mode(struct CPUState *cpu)
+bool x86_is_paging_mode(CPUState *cpu)
 {
     uint64_t cr0 = rvmcs(cpu->accel->fd, VMCS_GUEST_CR0);
     return cr0 & CR0_PG_MASK;
 }
 
-bool x86_is_pae_enabled(struct CPUState *cpu)
+bool x86_is_pae_enabled(CPUState *cpu)
 {
     uint64_t cr4 = rvmcs(cpu->accel->fd, VMCS_GUEST_CR4);
     return cr4 & CR4_PAE_MASK;
 }
 
-target_ulong linear_addr(struct CPUState *cpu, target_ulong addr, X86Seg seg)
+target_ulong linear_addr(CPUState *cpu, target_ulong addr, X86Seg seg)
 {
     return vmx_read_segment_base(cpu, seg) + addr;
 }
 
-target_ulong linear_addr_size(struct CPUState *cpu, target_ulong addr, int size,
+target_ulong linear_addr_size(CPUState *cpu, target_ulong addr, int size,
                               X86Seg seg)
 {
     switch (size) {
@@ -179,7 +179,7 @@ target_ulong linear_addr_size(struct CPUState *cpu, target_ulong addr, int size,
     return linear_addr(cpu, addr, seg);
 }
 
-target_ulong linear_rip(struct CPUState *cpu, target_ulong rip)
+target_ulong linear_rip(CPUState *cpu, target_ulong rip)
 {
     return linear_addr(cpu, rip, R_CS);
 }
diff --git a/target/i386/hvf/x86_descr.c b/target/i386/hvf/x86_descr.c
index c2d2e9ee84..5a9e8d307c 100644
--- a/target/i386/hvf/x86_descr.c
+++ b/target/i386/hvf/x86_descr.c
@@ -67,12 +67,12 @@ x68_segment_selector vmx_read_segment_selector(CPUState *cpu, X86Seg seg)
     return sel;
 }
 
-void vmx_write_segment_selector(struct CPUState *cpu, x68_segment_selector selector, X86Seg seg)
+void vmx_write_segment_selector(CPUState *cpu, x68_segment_selector selector, X86Seg seg)
 {
     wvmcs(cpu->accel->fd, vmx_segment_fields[seg].selector, selector.sel);
 }
 
-void vmx_read_segment_descriptor(struct CPUState *cpu, struct vmx_segment *desc, X86Seg seg)
+void vmx_read_segment_descriptor(CPUState *cpu, struct vmx_segment *desc, X86Seg seg)
 {
     desc->sel = rvmcs(cpu->accel->fd, vmx_segment_fields[seg].selector);
     desc->base = rvmcs(cpu->accel->fd, vmx_segment_fields[seg].base);
@@ -90,7 +90,7 @@ void vmx_write_segment_descriptor(CPUState *cpu, struct vmx_segment *desc, X86Se
     wvmcs(cpu->accel->fd, sf->ar_bytes, desc->ar);
 }
 
-void x86_segment_descriptor_to_vmx(struct CPUState *cpu, x68_segment_selector selector, struct x86_segment_descriptor *desc, struct vmx_segment *vmx_desc)
+void x86_segment_descriptor_to_vmx(CPUState *cpu, x68_segment_selector selector, struct x86_segment_descriptor *desc, struct vmx_segment *vmx_desc)
 {
     vmx_desc->sel = selector.sel;
     vmx_desc->base = x86_segment_base(desc);
@@ -107,7 +107,7 @@ void x86_segment_descriptor_to_vmx(struct CPUState *cpu, x68_segment_selector se
                     desc->type;
 }
 
-void vmx_segment_to_x86_descriptor(struct CPUState *cpu, struct vmx_segment *vmx_desc, struct x86_segment_descriptor *desc)
+void vmx_segment_to_x86_descriptor(CPUState *cpu, struct vmx_segment *vmx_desc, struct x86_segment_descriptor *desc)
 {
     x86_set_segment_limit(desc, vmx_desc->limit);
     x86_set_segment_base(desc, vmx_desc->base);
diff --git a/target/i386/hvf/x86_mmu.c b/target/i386/hvf/x86_mmu.c
index 8cd08622a1..649074a7d2 100644
--- a/target/i386/hvf/x86_mmu.c
+++ b/target/i386/hvf/x86_mmu.c
@@ -49,7 +49,7 @@ struct gpt_translation {
     bool exec_access;
 };
 
-static int gpt_top_level(struct CPUState *cpu, bool pae)
+static int gpt_top_level(CPUState *cpu, bool pae)
 {
     if (!pae) {
         return 2;
@@ -73,7 +73,7 @@ static inline int pte_size(bool pae)
 }
 
 
-static bool get_pt_entry(struct CPUState *cpu, struct gpt_translation *pt,
+static bool get_pt_entry(CPUState *cpu, struct gpt_translation *pt,
                          int level, bool pae)
 {
     int index;
@@ -95,7 +95,7 @@ static bool get_pt_entry(struct CPUState *cpu, struct gpt_translation *pt,
 }
 
 /* test page table entry */
-static bool test_pt_entry(struct CPUState *cpu, struct gpt_translation *pt,
+static bool test_pt_entry(CPUState *cpu, struct gpt_translation *pt,
                           int level, bool *is_large, bool pae)
 {
     uint64_t pte = pt->pte[level];
@@ -166,7 +166,7 @@ static inline uint64_t large_page_gpa(struct gpt_translation *pt, bool pae)
 
 
 
-static bool walk_gpt(struct CPUState *cpu, target_ulong addr, int err_code,
+static bool walk_gpt(CPUState *cpu, target_ulong addr, int err_code,
                      struct gpt_translation *pt, bool pae)
 {
     int top_level, level;
@@ -205,7 +205,7 @@ static bool walk_gpt(struct CPUState *cpu, target_ulong addr, int err_code,
 }
 
 
-bool mmu_gva_to_gpa(struct CPUState *cpu, target_ulong gva, uint64_t *gpa)
+bool mmu_gva_to_gpa(CPUState *cpu, target_ulong gva, uint64_t *gpa)
 {
     bool res;
     struct gpt_translation pt;
@@ -225,7 +225,7 @@ bool mmu_gva_to_gpa(struct CPUState *cpu, target_ulong gva, uint64_t *gpa)
     return false;
 }
 
-void vmx_write_mem(struct CPUState *cpu, target_ulong gva, void *data, int bytes)
+void vmx_write_mem(CPUState *cpu, target_ulong gva, void *data, int bytes)
 {
     uint64_t gpa;
 
@@ -246,7 +246,7 @@ void vmx_write_mem(struct CPUState *cpu, target_ulong gva, void *data, int bytes
     }
 }
 
-void vmx_read_mem(struct CPUState *cpu, void *data, target_ulong gva, int bytes)
+void vmx_read_mem(CPUState *cpu, void *data, target_ulong gva, int bytes)
 {
     uint64_t gpa;
 
-- 
2.41.0


