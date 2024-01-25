Return-Path: <kvm+bounces-7025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CCCDC83C942
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 18:06:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D49361C260BF
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 17:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA238137C3A;
	Thu, 25 Jan 2024 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ffBkv4NY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C1713667A
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706201835; cv=none; b=MS098E/E0aiW0x9R5qfTIL4MeJ1Ep2wdrxFhXbUBmaYAWupBbX30VTV+1i1zlGXF9R05FnXXLM8FTt/xXSdu6svdtslA42UXO984DzS6jdrZ3L8CAttmeYajS5K6p83+l4FDBN9WzwS8c6Sv0+Jawl6yeQYIMlv1/VTLt4wzgRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706201835; c=relaxed/simple;
	bh=+s4+f6KVaToKkuqpm91Lbhkm89iT115dWP063jPcSLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+P43WNPhu5ytBvtEvGRrM88/7FmBrFHcWqcerYgUyHIKBs3NU+Vgi6UKMUboBi7ja2VCGlDZ08rS8hnBVOKHl/C2VYuSZpGIX2+B6Qo9MCYKREajWSXCr5jvqWSA2EO5K4S8tPlqpL+5hS5wWKmHLnX5NzS0MtQC/Z0vraQAdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ffBkv4NY; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-40e7e2e04f0so76114515e9.1
        for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 08:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706201827; x=1706806627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frxDJ8mOODgX6KeI6KdBy7eqBvF7YFgEYnjO259YkXE=;
        b=ffBkv4NYfjCcPhiRYxk8GlTqzOhUDGG84l2C+pSpPsLpU4prQAAFoCd5GAbJuryqdU
         r4Sih0YLAtbp/n/JsxLUmHh/sX9usPSNYWmgn20fFF+hNwNGMqvgn4ww2AdlFKoelgnX
         Di0vRdoRczRVNYAZJeg4i5Cto0mhjndQH2CHgw2iQLOuzMVJZqneKC3a/4O+Uzo8XBpJ
         dN8oLc+gqm6kztF1qw/b2u8aMJC46S88QXtylHKSxQXgHSJRzPsI47Wa60tdOSMw1rE3
         hBQZ3NsGzG+sXsSEiAmKlpMkb0KF/+cTqIVNI9+bg/dYBTkBCKrlYVACYfykx313t3Yd
         SuWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706201827; x=1706806627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=frxDJ8mOODgX6KeI6KdBy7eqBvF7YFgEYnjO259YkXE=;
        b=peUglJzjV4PYSh7qeIbxvkkiDWarw9HUvbvtFZh5sqSM4UM1L7aOTpzI47PCoCCAPo
         ieGE08eOEUbk6ZXDifDZhqyQz96+nKOxF2u4P+DP4di7BT/eCao/nF8Nou0x/di+BpRg
         mPF4L36SjHIEn+hU1J/n7lhTIgBZi4XxDOb7x8eapa+XZcG/gHKwAM9XC4f/yJi5enyu
         JdeftcXYAVVvNss1rGwqqLk4gkWNdg1cMWHPxQTpXvbDVo34jROtSHByA+0XopMAvU6x
         yfYEBe6a/4EJRLFqblgMmrc6v46SdoujW8izpNOmuNsGYBPXMGLU/IiCz5XXLIjQRLSt
         PgVQ==
X-Gm-Message-State: AOJu0YzIUlLv5I+MV4X8ciCLSenJG+nESXcZtNQ851aHtpwtq/+27/SP
	PW6n8/HzQQsXDofFTaIwUoU9chd6q/4uHbx4lc5lI5krYSZoqvxI5lOqCnGaB9I=
X-Google-Smtp-Source: AGHT+IHAf1tUHg8vPCB9uxTQ0sgUXqqsojScCWzVChUpHOsLRlLkN2s5hrgmu+P5JGNhimDORxWy6Q==
X-Received: by 2002:a05:600c:6b0e:b0:40e:5aa7:769d with SMTP id jn14-20020a05600c6b0e00b0040e5aa7769dmr14683wmb.143.1706201827085;
        Thu, 25 Jan 2024 08:57:07 -0800 (PST)
Received: from m1x-phil.lan (lec62-h02-176-184-19-125.dsl.sta.abo.bbox.fr. [176.184.19.125])
        by smtp.gmail.com with ESMTPSA id g8-20020a05600c310800b0040e703ad630sm3152838wmo.22.2024.01.25.08.57.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 25 Jan 2024 08:57:06 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-s390x@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alexander Graf <agraf@csgraf.de>,
	Michael Rolnik <mrolnik@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Laurent Vivier <laurent@vivier.eu>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Chris Wulff <crwulff@gmail.com>,
	Marek Vasut <marex@denx.de>,
	Stafford Horne <shorne@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bin.meng@windriver.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
	Max Filippov <jcmvbkbc@gmail.com>,
	xen-devel@lists.xenproject.org,
	kvm@vger.kernel.org
Subject: [PATCH 2/2] bulk: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Thu, 25 Jan 2024 17:56:46 +0100
Message-ID: <20240125165648.49898-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240125165648.49898-1-philmd@linaro.org>
References: <20240125165648.49898-1-philmd@linaro.org>
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
 target/i386/hvf/vmx.h                   |  9 +++----
 hw/i386/vmmouse.c                       |  6 ++---
 hw/i386/xen/xen-hvm.c                   |  3 +--
 hw/intc/arm_gicv3_cpuif_common.c        |  3 +--
 hw/ppc/mpc8544_guts.c                   |  3 +--
 hw/ppc/pnv.c                            |  3 +--
 hw/ppc/pnv_xscom.c                      |  3 +--
 hw/ppc/ppce500_spin.c                   |  3 +--
 hw/ppc/spapr.c                          |  3 +--
 hw/ppc/spapr_caps.c                     |  6 ++---
 target/alpha/cpu.c                      | 21 +++++----------
 target/alpha/gdbstub.c                  |  6 ++---
 target/alpha/helper.c                   | 12 +++------
 target/alpha/mem_helper.c               |  9 +++----
 target/arm/cpu.c                        | 15 ++++-------
 target/arm/debug_helper.c               |  6 ++---
 target/arm/gdbstub.c                    |  6 ++---
 target/arm/gdbstub64.c                  |  6 ++---
 target/arm/helper.c                     |  9 +++----
 target/arm/hvf/hvf.c                    | 12 +++------
 target/arm/kvm.c                        |  3 +--
 target/arm/ptw.c                        |  3 +--
 target/arm/tcg/cpu32.c                  |  3 +--
 target/avr/cpu.c                        | 21 +++++----------
 target/avr/gdbstub.c                    |  6 ++---
 target/avr/helper.c                     |  9 +++----
 target/cris/cpu.c                       |  3 +--
 target/cris/gdbstub.c                   |  9 +++----
 target/cris/helper.c                    | 12 +++------
 target/cris/translate.c                 |  3 +--
 target/hppa/cpu.c                       |  6 ++---
 target/hppa/int_helper.c                |  6 ++---
 target/hppa/mem_helper.c                |  3 +--
 target/i386/arch_memory_mapping.c       |  3 +--
 target/i386/cpu-dump.c                  |  3 +--
 target/i386/cpu.c                       | 36 +++++++++----------------
 target/i386/helper.c                    | 30 +++++++--------------
 target/i386/hvf/hvf.c                   |  6 ++---
 target/i386/hvf/x86.c                   |  3 +--
 target/i386/hvf/x86_emu.c               |  6 ++---
 target/i386/hvf/x86_task.c              | 10 +++----
 target/i386/hvf/x86hvf.c                |  6 ++---
 target/i386/kvm/kvm.c                   |  6 ++---
 target/i386/kvm/xen-emu.c               | 30 +++++++--------------
 target/i386/tcg/sysemu/bpt_helper.c     |  3 +--
 target/i386/tcg/tcg-cpu.c               | 12 +++------
 target/i386/tcg/user/excp_helper.c      |  3 +--
 target/i386/tcg/user/seg_helper.c       |  3 +--
 target/m68k/cpu.c                       | 30 +++++++--------------
 target/m68k/gdbstub.c                   |  6 ++---
 target/m68k/helper.c                    |  3 +--
 target/m68k/m68k-semi.c                 |  6 ++---
 target/m68k/op_helper.c                 |  9 +++----
 target/m68k/translate.c                 |  3 +--
 target/microblaze/helper.c              |  3 +--
 target/microblaze/translate.c           |  3 +--
 target/mips/cpu.c                       |  9 +++----
 target/mips/gdbstub.c                   |  6 ++---
 target/mips/kvm.c                       | 27 +++++++------------
 target/mips/sysemu/physaddr.c           |  3 +--
 target/mips/tcg/exception.c             |  3 +--
 target/mips/tcg/op_helper.c             |  3 +--
 target/mips/tcg/sysemu/special_helper.c |  3 +--
 target/mips/tcg/sysemu/tlb_helper.c     |  6 ++---
 target/mips/tcg/translate.c             |  3 +--
 target/nios2/cpu.c                      |  9 +++----
 target/nios2/helper.c                   |  3 +--
 target/nios2/nios2-semi.c               |  6 ++---
 target/openrisc/gdbstub.c               |  3 +--
 target/openrisc/interrupt.c             |  6 ++---
 target/openrisc/translate.c             |  3 +--
 target/ppc/cpu_init.c                   |  9 +++----
 target/ppc/excp_helper.c                |  3 +--
 target/ppc/gdbstub.c                    | 12 +++------
 target/ppc/kvm.c                        |  6 ++---
 target/ppc/ppc-qmp-cmds.c               |  3 +--
 target/ppc/user_only_helper.c           |  3 +--
 target/riscv/arch_dump.c                |  6 ++---
 target/riscv/cpu.c                      | 15 ++++-------
 target/riscv/cpu_helper.c               | 13 +++------
 target/riscv/debug.c                    |  9 +++----
 target/riscv/gdbstub.c                  |  6 ++---
 target/riscv/kvm/kvm-cpu.c              |  6 ++---
 target/riscv/tcg/tcg-cpu.c              |  9 +++----
 target/riscv/translate.c                |  3 +--
 target/rx/gdbstub.c                     |  6 ++---
 target/rx/helper.c                      |  6 ++---
 target/rx/translate.c                   |  3 +--
 target/s390x/cpu-dump.c                 |  3 +--
 target/s390x/gdbstub.c                  |  6 ++---
 target/s390x/helper.c                   |  3 +--
 target/s390x/kvm/kvm.c                  |  6 ++---
 target/s390x/tcg/excp_helper.c          |  9 +++----
 target/s390x/tcg/translate.c            |  3 +--
 target/sh4/cpu.c                        | 15 ++++-------
 target/sh4/gdbstub.c                    |  6 ++---
 target/sh4/helper.c                     |  9 +++----
 target/sh4/translate.c                  |  3 +--
 target/sparc/cpu.c                      | 12 +++------
 target/sparc/gdbstub.c                  |  3 +--
 target/sparc/int32_helper.c             |  3 +--
 target/sparc/int64_helper.c             |  3 +--
 target/sparc/ldst_helper.c              |  6 ++---
 target/sparc/mmu_helper.c               | 15 ++++-------
 target/sparc/translate.c                |  3 +--
 target/tricore/cpu.c                    | 12 +++------
 target/tricore/gdbstub.c                |  6 ++---
 target/tricore/helper.c                 |  3 +--
 target/tricore/translate.c              |  3 +--
 target/xtensa/dbg_helper.c              |  3 +--
 target/xtensa/exc_helper.c              |  3 +--
 target/xtensa/gdbstub.c                 |  6 ++---
 target/xtensa/helper.c                  |  9 +++----
 target/xtensa/translate.c               |  3 +--
 114 files changed, 273 insertions(+), 548 deletions(-)

diff --git a/target/i386/hvf/vmx.h b/target/i386/hvf/vmx.h
index 0fffcfa46c..21752e6146 100644
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
@@ -196,8 +195,7 @@ static inline void macvm_set_rip(CPUState *cpu, uint64_t rip)
 
 static inline void vmx_clear_nmi_blocking(CPUState *cpu)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
+    CPUX86State *env = cpu_env(cpu);
 
     env->hflags2 &= ~HF2_NMI_MASK;
     uint32_t gi = (uint32_t) rvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY);
@@ -207,8 +205,7 @@ static inline void vmx_clear_nmi_blocking(CPUState *cpu)
 
 static inline void vmx_set_nmi_blocking(CPUState *cpu)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
+    CPUX86State *env = cpu_env(cpu);
 
     env->hflags2 |= HF2_NMI_MASK;
     uint32_t gi = (uint32_t)rvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY);
diff --git a/hw/i386/vmmouse.c b/hw/i386/vmmouse.c
index a8d014d09a..eb0613bfbe 100644
--- a/hw/i386/vmmouse.c
+++ b/hw/i386/vmmouse.c
@@ -74,8 +74,7 @@ struct VMMouseState {
 
 static void vmmouse_get_data(uint32_t *data)
 {
-    X86CPU *cpu = X86_CPU(current_cpu);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(current_cpu));
 
     data[0] = env->regs[R_EAX]; data[1] = env->regs[R_EBX];
     data[2] = env->regs[R_ECX]; data[3] = env->regs[R_EDX];
@@ -84,8 +83,7 @@ static void vmmouse_get_data(uint32_t *data)
 
 static void vmmouse_set_data(const uint32_t *data)
 {
-    X86CPU *cpu = X86_CPU(current_cpu);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(current_cpu));
 
     env->regs[R_EAX] = data[0]; env->regs[R_EBX] = data[1];
     env->regs[R_ECX] = data[2]; env->regs[R_EDX] = data[3];
diff --git a/hw/i386/xen/xen-hvm.c b/hw/i386/xen/xen-hvm.c
index f42621e674..3d3ae49be5 100644
--- a/hw/i386/xen/xen-hvm.c
+++ b/hw/i386/xen/xen-hvm.c
@@ -487,8 +487,7 @@ static void regs_to_cpu(vmware_regs_t *vmport_regs, ioreq_t *req)
 
 static void regs_from_cpu(vmware_regs_t *vmport_regs)
 {
-    X86CPU *cpu = X86_CPU(current_cpu);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(current_cpu));
 
     vmport_regs->ebx = env->regs[R_EBX];
     vmport_regs->ecx = env->regs[R_ECX];
diff --git a/hw/intc/arm_gicv3_cpuif_common.c b/hw/intc/arm_gicv3_cpuif_common.c
index ff1239f65d..8572675a75 100644
--- a/hw/intc/arm_gicv3_cpuif_common.c
+++ b/hw/intc/arm_gicv3_cpuif_common.c
@@ -15,8 +15,7 @@
 
 void gicv3_set_gicv3state(CPUState *cpu, GICv3CPUState *s)
 {
-    ARMCPU *arm_cpu = ARM_CPU(cpu);
-    CPUARMState *env = &arm_cpu->env;
+    CPUARMState *env = cpu_env(cpu);
 
     env->gicv3state = (void *)s;
 };
diff --git a/hw/ppc/mpc8544_guts.c b/hw/ppc/mpc8544_guts.c
index a26e83d048..3c6a852ad4 100644
--- a/hw/ppc/mpc8544_guts.c
+++ b/hw/ppc/mpc8544_guts.c
@@ -71,8 +71,7 @@ static uint64_t mpc8544_guts_read(void *opaque, hwaddr addr,
                                   unsigned size)
 {
     uint32_t value = 0;
-    PowerPCCPU *cpu = POWERPC_CPU(current_cpu);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(CPU(current_cpu));
 
     addr &= MPC8544_GUTS_MMIO_SIZE - 1;
     switch (addr) {
diff --git a/hw/ppc/pnv.c b/hw/ppc/pnv.c
index 0297871bdd..a202b377e1 100644
--- a/hw/ppc/pnv.c
+++ b/hw/ppc/pnv.c
@@ -2294,8 +2294,7 @@ static void pnv_machine_set_hb(Object *obj, bool value, Error **errp)
 
 static void pnv_cpu_do_nmi_on_cpu(CPUState *cs, run_on_cpu_data arg)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
 
     cpu_synchronize_state(cs);
     ppc_cpu_do_system_reset(cs);
diff --git a/hw/ppc/pnv_xscom.c b/hw/ppc/pnv_xscom.c
index 805b1d0c87..ae3e87548d 100644
--- a/hw/ppc/pnv_xscom.c
+++ b/hw/ppc/pnv_xscom.c
@@ -44,8 +44,7 @@ static void xscom_complete(CPUState *cs, uint64_t hmer_bits)
      * passed for the cpu, and no CPU completion is generated.
      */
     if (cs) {
-        PowerPCCPU *cpu = POWERPC_CPU(cs);
-        CPUPPCState *env = &cpu->env;
+        CPUPPCState *env = cpu_env(cs);
 
         /*
          * TODO: Need a CPU helper to set HMER, also handle generation
diff --git a/hw/ppc/ppce500_spin.c b/hw/ppc/ppce500_spin.c
index bbce63e8a4..dfbe759481 100644
--- a/hw/ppc/ppce500_spin.c
+++ b/hw/ppc/ppce500_spin.c
@@ -90,8 +90,7 @@ static void mmubooke_create_initial_mapping(CPUPPCState *env,
 
 static void spin_kick(CPUState *cs, run_on_cpu_data data)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     SpinInfo *curspin = data.host_ptr;
     hwaddr map_size = 64 * MiB;
     hwaddr map_start;
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index e8dabc8614..d7edfc2a1a 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -3487,8 +3487,7 @@ static void spapr_machine_finalizefn(Object *obj)
 void spapr_do_system_reset_on_cpu(CPUState *cs, run_on_cpu_data arg)
 {
     SpaprMachineState *spapr = SPAPR_MACHINE(qdev_get_machine());
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
 
     cpu_synchronize_state(cs);
     /* If FWNMI is inactive, addr will be -1, which will deliver to 0x100 */
diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
index e889244e52..1dad45be10 100644
--- a/hw/ppc/spapr_caps.c
+++ b/hw/ppc/spapr_caps.c
@@ -194,8 +194,7 @@ static void cap_htm_apply(SpaprMachineState *spapr, uint8_t val, Error **errp)
 static void cap_vsx_apply(SpaprMachineState *spapr, uint8_t val, Error **errp)
 {
     ERRP_GUARD();
-    PowerPCCPU *cpu = POWERPC_CPU(first_cpu);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(CPU(first_cpu));
 
     if (!val) {
         /* TODO: We don't support disabling vsx yet */
@@ -213,8 +212,7 @@ static void cap_vsx_apply(SpaprMachineState *spapr, uint8_t val, Error **errp)
 static void cap_dfp_apply(SpaprMachineState *spapr, uint8_t val, Error **errp)
 {
     ERRP_GUARD();
-    PowerPCCPU *cpu = POWERPC_CPU(first_cpu);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(CPU(first_cpu));
 
     if (!val) {
         /* TODO: We don't support disabling dfp yet */
diff --git a/target/alpha/cpu.c b/target/alpha/cpu.c
index b8ed29e343..65a408754e 100644
--- a/target/alpha/cpu.c
+++ b/target/alpha/cpu.c
@@ -130,40 +130,35 @@ static ObjectClass *alpha_cpu_class_by_name(const char *cpu_model)
 
 static void ev4_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(CPU(obj));
 
     env->implver = IMPLVER_2106x;
 }
 
 static void ev5_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(CPU(obj));
 
     env->implver = IMPLVER_21164;
 }
 
 static void ev56_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(CPU(obj));
 
     env->amask |= AMASK_BWX;
 }
 
 static void pca56_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(CPU(obj));
 
     env->amask |= AMASK_MVI;
 }
 
 static void ev6_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(CPU(obj));
 
     env->implver = IMPLVER_21264;
     env->amask = AMASK_BWX | AMASK_FIX | AMASK_MVI | AMASK_TRAP;
@@ -171,16 +166,14 @@ static void ev6_cpu_initfn(Object *obj)
 
 static void ev67_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(CPU(obj));
 
     env->amask |= AMASK_CIX | AMASK_PREFETCH;
 }
 
 static void alpha_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(CPU(obj));
 
     env->lock_addr = -1;
 #if defined(CONFIG_USER_ONLY)
diff --git a/target/alpha/gdbstub.c b/target/alpha/gdbstub.c
index 0f8fa150f8..13694fd321 100644
--- a/target/alpha/gdbstub.c
+++ b/target/alpha/gdbstub.c
@@ -23,8 +23,7 @@
 
 int alpha_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
     uint64_t val;
     CPU_DoubleU d;
 
@@ -59,8 +58,7 @@ int alpha_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int alpha_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
     target_ulong tmp = ldtul_p(mem_buf);
     CPU_DoubleU d;
 
diff --git a/target/alpha/helper.c b/target/alpha/helper.c
index 970c869771..eeed874e5a 100644
--- a/target/alpha/helper.c
+++ b/target/alpha/helper.c
@@ -298,8 +298,7 @@ bool alpha_cpu_tlb_fill(CPUState *cs, vaddr addr, int size,
                         MMUAccessType access_type, int mmu_idx,
                         bool probe, uintptr_t retaddr)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
     target_ulong phys;
     int prot, fail;
 
@@ -325,8 +324,7 @@ bool alpha_cpu_tlb_fill(CPUState *cs, vaddr addr, int size,
 
 void alpha_cpu_do_interrupt(CPUState *cs)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
     int i = cs->exception_index;
 
     if (qemu_loglevel_mask(CPU_LOG_INT)) {
@@ -435,8 +433,7 @@ void alpha_cpu_do_interrupt(CPUState *cs)
 
 bool alpha_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
     int idx = -1;
 
     /* We never take interrupts while in PALmode.  */
@@ -487,8 +484,7 @@ void alpha_cpu_dump_state(CPUState *cs, FILE *f, int flags)
         "a0",  "a1",  "a2", "a3",  "a4", "a5", "t8", "t9",
         "t10", "t11", "ra", "t12", "at", "gp", "sp"
     };
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "PC      " TARGET_FMT_lx " PS      %02x\n",
diff --git a/target/alpha/mem_helper.c b/target/alpha/mem_helper.c
index a39b52c5dd..a8a36fa3a8 100644
--- a/target/alpha/mem_helper.c
+++ b/target/alpha/mem_helper.c
@@ -42,8 +42,7 @@ static void do_unaligned_access(CPUAlphaState *env, vaddr addr, uintptr_t retadd
 void alpha_cpu_record_sigbus(CPUState *cs, vaddr addr,
                              MMUAccessType access_type, uintptr_t retaddr)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
 
     do_unaligned_access(env, addr, retaddr);
 }
@@ -52,8 +51,7 @@ void alpha_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                    MMUAccessType access_type,
                                    int mmu_idx, uintptr_t retaddr)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
 
     do_unaligned_access(env, addr, retaddr);
     cs->exception_index = EXCP_UNALIGN;
@@ -67,8 +65,7 @@ void alpha_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr,
                                      int mmu_idx, MemTxAttrs attrs,
                                      MemTxResult response, uintptr_t retaddr)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
 
     env->trap_arg0 = addr;
     env->trap_arg1 = access_type == MMU_DATA_STORE ? 1 : 0;
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 593695b424..4900271a86 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -51,8 +51,7 @@
 
 static void arm_cpu_set_pc(CPUState *cs, vaddr value)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     if (is_a64(env)) {
         env->pc = value;
@@ -65,8 +64,7 @@ static void arm_cpu_set_pc(CPUState *cs, vaddr value)
 
 static vaddr arm_cpu_get_pc(CPUState *cs)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     if (is_a64(env)) {
         return env->pc;
@@ -994,8 +992,7 @@ static void arm_cpu_kvm_set_irq(void *opaque, int irq, int level)
 
 static bool arm_cpu_virtio_is_big_endian(CPUState *cs)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     cpu_synchronize_state(cs);
     return arm_cpu_data_is_big_endian(env);
@@ -1005,8 +1002,7 @@ static bool arm_cpu_virtio_is_big_endian(CPUState *cs)
 
 static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 {
-    ARMCPU *ac = ARM_CPU(cpu);
-    CPUARMState *env = &ac->env;
+    CPUARMState *env = cpu_env(cpu);
     bool sctlr_b;
 
     if (is_a64(env)) {
@@ -2428,8 +2424,7 @@ static Property arm_cpu_properties[] = {
 
 static const gchar *arm_gdb_arch_name(CPUState *cs)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     if (arm_feature(env, ARM_FEATURE_IWMMXT)) {
         return "iwmmxt";
diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
index 7d856acddf..cd5dbe2ffc 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -468,8 +468,7 @@ void arm_debug_excp_handler(CPUState *cs)
      * Called by core code when a watchpoint or breakpoint fires;
      * need to check which one and raise the appropriate exception.
      */
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
     CPUWatchpoint *wp_hit = cs->watchpoint_hit;
 
     if (wp_hit) {
@@ -757,8 +756,7 @@ void hw_breakpoint_update_all(ARMCPU *cpu)
 
 vaddr arm_adjust_watchpoint_address(CPUState *cs, vaddr addr, int len)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     /*
      * In BE32 system mode, target memory is stored byteswapped (on a
diff --git a/target/arm/gdbstub.c b/target/arm/gdbstub.c
index 28f546a5ff..dc6c29669c 100644
--- a/target/arm/gdbstub.c
+++ b/target/arm/gdbstub.c
@@ -40,8 +40,7 @@ typedef struct RegisterSysregXmlParam {
 
 int arm_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     if (n < 16) {
         /* Core integer register.  */
@@ -61,8 +60,7 @@ int arm_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int arm_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
     uint32_t tmp;
 
     tmp = ldl_p(mem_buf);
diff --git a/target/arm/gdbstub64.c b/target/arm/gdbstub64.c
index d7b79a6589..b9f29b0a60 100644
--- a/target/arm/gdbstub64.c
+++ b/target/arm/gdbstub64.c
@@ -24,8 +24,7 @@
 
 int aarch64_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     if (n < 31) {
         /* Core integer register.  */
@@ -45,8 +44,7 @@ int aarch64_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int aarch64_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
     uint64_t tmp;
 
     tmp = ldq_p(mem_buf);
diff --git a/target/arm/helper.c b/target/arm/helper.c
index e068d35383..a504ed0612 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -10900,8 +10900,7 @@ static void arm_cpu_do_interrupt_aarch32_hyp(CPUState *cs)
      * PSTATE A/I/F masks are set based only on the SCR.EA/IRQ/FIQ values.
      */
     uint32_t addr, mask;
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     switch (cs->exception_index) {
     case EXCP_UDEF:
@@ -10979,8 +10978,7 @@ static void arm_cpu_do_interrupt_aarch32_hyp(CPUState *cs)
 
 static void arm_cpu_do_interrupt_aarch32(CPUState *cs)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
     uint32_t addr;
     uint32_t mask;
     int new_mode;
@@ -11479,8 +11477,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
 #ifdef CONFIG_TCG
 static void tcg_handle_semihosting(CPUState *cs)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     if (is_a64(env)) {
         qemu_log_mask(CPU_LOG_INT,
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index a537a5bc94..69211d0a60 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1004,8 +1004,7 @@ void hvf_kick_vcpu_thread(CPUState *cpu)
 static void hvf_raise_exception(CPUState *cpu, uint32_t excp,
                                 uint32_t syndrome)
 {
-    ARMCPU *arm_cpu = ARM_CPU(cpu);
-    CPUARMState *env = &arm_cpu->env;
+    CPUARMState *env = cpu_env(cpu);
 
     cpu->exception_index = excp;
     env->exception.target_el = 1;
@@ -1483,8 +1482,7 @@ static bool hvf_sysreg_write_cp(CPUState *cpu, uint32_t reg, uint64_t val)
 
 static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
 {
-    ARMCPU *arm_cpu = ARM_CPU(cpu);
-    CPUARMState *env = &arm_cpu->env;
+    CPUARMState *env = cpu_env(cpu);
 
     trace_hvf_sysreg_write(reg,
                            SYSREG_OP0(reg),
@@ -2150,8 +2148,7 @@ static void hvf_put_gdbstub_debug_registers(CPUState *cpu)
  */
 static void hvf_put_guest_debug_registers(CPUState *cpu)
 {
-    ARMCPU *arm_cpu = ARM_CPU(cpu);
-    CPUARMState *env = &arm_cpu->env;
+    CPUARMState *env = cpu_env(cpu);
     hv_return_t r = HV_SUCCESS;
     int i;
 
@@ -2205,8 +2202,7 @@ static void hvf_arch_set_traps(void)
 
 void hvf_arch_update_guest_debug(CPUState *cpu)
 {
-    ARMCPU *arm_cpu = ARM_CPU(cpu);
-    CPUARMState *env = &arm_cpu->env;
+    CPUARMState *env = cpu_env(cpu);
 
     /* Check whether guest debugging is enabled */
     cpu->accel->guest_debug_enabled = cpu->singlestep_enabled ||
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 8f52b211f9..9e97c847b3 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1957,8 +1957,7 @@ int kvm_arch_destroy_vcpu(CPUState *cs)
 /* Callers must hold the iothread mutex lock */
 static void kvm_inject_arm_sea(CPUState *c)
 {
-    ARMCPU *cpu = ARM_CPU(c);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(c);
     uint32_t esr;
     bool same_el;
 
diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index 5eb3577bcd..57a761ad68 100644
--- a/target/arm/ptw.c
+++ b/target/arm/ptw.c
@@ -3528,8 +3528,7 @@ bool get_phys_addr(CPUARMState *env, target_ulong address,
 hwaddr arm_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
                                          MemTxAttrs *attrs)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
     ARMMMUIdx mmu_idx = arm_mmu_idx(env);
     ARMSecuritySpace ss = arm_security_space(env);
     S1Translate ptw = {
diff --git a/target/arm/tcg/cpu32.c b/target/arm/tcg/cpu32.c
index d9e0e2a4dd..c11c5c85c4 100644
--- a/target/arm/tcg/cpu32.c
+++ b/target/arm/tcg/cpu32.c
@@ -102,8 +102,7 @@ void aa32_max_features(ARMCPU *cpu)
 static bool arm_v7m_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     CPUClass *cc = CPU_GET_CLASS(cs);
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
     bool ret = false;
 
     /*
diff --git a/target/avr/cpu.c b/target/avr/cpu.c
index f5cbdc4a8c..3dec251767 100644
--- a/target/avr/cpu.c
+++ b/target/avr/cpu.c
@@ -43,8 +43,7 @@ static vaddr avr_cpu_get_pc(CPUState *cs)
 
 static bool avr_cpu_has_work(CPUState *cs)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(cs);
 
     return (cs->interrupt_request & (CPU_INTERRUPT_HARD | CPU_INTERRUPT_RESET))
             && cpu_interrupts_enabled(env);
@@ -53,8 +52,7 @@ static bool avr_cpu_has_work(CPUState *cs)
 static void avr_cpu_synchronize_from_tb(CPUState *cs,
                                         const TranslationBlock *tb)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(cs);
 
     tcg_debug_assert(!(cs->tcg_cflags & CF_PCREL));
     env->pc_w = tb->pc / 2; /* internally PC points to words */
@@ -64,8 +62,7 @@ static void avr_restore_state_to_opc(CPUState *cs,
                                      const TranslationBlock *tb,
                                      const uint64_t *data)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(cs);
 
     env->pc_w = data[0];
 }
@@ -165,8 +162,7 @@ static ObjectClass *avr_cpu_class_by_name(const char *cpu_model)
 
 static void avr_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "\n");
@@ -276,8 +272,7 @@ static void avr_cpu_class_init(ObjectClass *oc, void *data)
  */
 static void avr_avr5_initfn(Object *obj)
 {
-    AVRCPU *cpu = AVR_CPU(obj);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(CPU(obj));
 
     set_avr_feature(env, AVR_FEATURE_LPM);
     set_avr_feature(env, AVR_FEATURE_IJMP_ICALL);
@@ -305,8 +300,7 @@ static void avr_avr5_initfn(Object *obj)
  */
 static void avr_avr51_initfn(Object *obj)
 {
-    AVRCPU *cpu = AVR_CPU(obj);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(CPU(obj));
 
     set_avr_feature(env, AVR_FEATURE_LPM);
     set_avr_feature(env, AVR_FEATURE_IJMP_ICALL);
@@ -335,8 +329,7 @@ static void avr_avr51_initfn(Object *obj)
  */
 static void avr_avr6_initfn(Object *obj)
 {
-    AVRCPU *cpu = AVR_CPU(obj);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(CPU(obj));
 
     set_avr_feature(env, AVR_FEATURE_LPM);
     set_avr_feature(env, AVR_FEATURE_IJMP_ICALL);
diff --git a/target/avr/gdbstub.c b/target/avr/gdbstub.c
index 150344d8b9..2eeee2bf4e 100644
--- a/target/avr/gdbstub.c
+++ b/target/avr/gdbstub.c
@@ -23,8 +23,7 @@
 
 int avr_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(cs);
 
     /*  R */
     if (n < 32) {
@@ -53,8 +52,7 @@ int avr_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int avr_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(cs);
 
     /*  R */
     if (n < 32) {
diff --git a/target/avr/helper.c b/target/avr/helper.c
index fdc9884ea0..eeabefa1c0 100644
--- a/target/avr/helper.c
+++ b/target/avr/helper.c
@@ -30,8 +30,7 @@
 
 bool avr_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(cs);
 
     /*
      * We cannot separate a skip from the next instruction,
@@ -69,8 +68,7 @@ bool avr_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 
 void avr_cpu_do_interrupt(CPUState *cs)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(cs);
 
     uint32_t ret = env->pc_w;
     int vector = 0;
@@ -144,8 +142,7 @@ bool avr_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
             if (probe) {
                 page_size = 1;
             } else {
-                AVRCPU *cpu = AVR_CPU(cs);
-                CPUAVRState *env = &cpu->env;
+                CPUAVRState *env = cpu_env(cs);
                 env->fullacc = 1;
                 cpu_loop_exit_restore(cs, retaddr);
             }
diff --git a/target/cris/cpu.c b/target/cris/cpu.c
index 9ba08e8b0c..c3cdcf107f 100644
--- a/target/cris/cpu.c
+++ b/target/cris/cpu.c
@@ -142,8 +142,7 @@ static void cris_cpu_set_irq(void *opaque, int irq, int level)
 
 static void cris_disas_set_info(CPUState *cpu, disassemble_info *info)
 {
-    CRISCPU *cc = CRIS_CPU(cpu);
-    CPUCRISState *env = &cc->env;
+    CPUCRISState *env = cpu_env(cpu);
 
     if (env->pregs[PR_VR] != 32) {
         info->mach = bfd_mach_cris_v0_v10;
diff --git a/target/cris/gdbstub.c b/target/cris/gdbstub.c
index 25c0ca33a5..9e87069da8 100644
--- a/target/cris/gdbstub.c
+++ b/target/cris/gdbstub.c
@@ -23,8 +23,7 @@
 
 int crisv10_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
 
     if (n < 15) {
         return gdb_get_reg32(mem_buf, env->regs[n]);
@@ -55,8 +54,7 @@ int crisv10_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int cris_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     uint8_t srs;
 
     srs = env->pregs[PR_SRS];
@@ -90,8 +88,7 @@ int cris_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int cris_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     uint32_t tmp;
 
     if (n > 49) {
diff --git a/target/cris/helper.c b/target/cris/helper.c
index c0bf987e3e..1c3f86876f 100644
--- a/target/cris/helper.c
+++ b/target/cris/helper.c
@@ -53,8 +53,7 @@ bool cris_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        MMUAccessType access_type, int mmu_idx,
                        bool probe, uintptr_t retaddr)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     struct cris_mmu_result res;
     int prot, miss;
     target_ulong phy;
@@ -97,8 +96,7 @@ bool cris_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
 
 void crisv10_cpu_do_interrupt(CPUState *cs)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     int ex_vec = -1;
 
     D_LOG("exception index=%d interrupt_req=%d\n",
@@ -159,8 +157,7 @@ void crisv10_cpu_do_interrupt(CPUState *cs)
 
 void cris_cpu_do_interrupt(CPUState *cs)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     int ex_vec = -1;
 
     D_LOG("exception index=%d interrupt_req=%d\n",
@@ -262,8 +259,7 @@ hwaddr cris_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
 bool cris_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     CPUClass *cc = CPU_GET_CLASS(cs);
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     bool ret = false;
 
     if (interrupt_request & CPU_INTERRUPT_HARD
diff --git a/target/cris/translate.c b/target/cris/translate.c
index b3974ba0bb..a935167f00 100644
--- a/target/cris/translate.c
+++ b/target/cris/translate.c
@@ -3180,8 +3180,7 @@ void gen_intermediate_code(CPUState *cs, TranslationBlock *tb, int *max_insns,
 
 void cris_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     const char * const *regnames;
     const char * const *pregnames;
     int i;
diff --git a/target/hppa/cpu.c b/target/hppa/cpu.c
index 14e17fa9aa..07ea8ab9d8 100644
--- a/target/hppa/cpu.c
+++ b/target/hppa/cpu.c
@@ -106,8 +106,7 @@ void hppa_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                   MMUAccessType access_type, int mmu_idx,
                                   uintptr_t retaddr)
 {
-    HPPACPU *cpu = HPPA_CPU(cs);
-    CPUHPPAState *env = &cpu->env;
+    CPUHPPAState *env = cpu_env(cs);
 
     cs->exception_index = EXCP_UNALIGN;
     hppa_set_ior_and_isr(env, addr, MMU_IDX_MMU_DISABLED(mmu_idx));
@@ -145,8 +144,7 @@ static void hppa_cpu_realizefn(DeviceState *dev, Error **errp)
 static void hppa_cpu_initfn(Object *obj)
 {
     CPUState *cs = CPU(obj);
-    HPPACPU *cpu = HPPA_CPU(obj);
-    CPUHPPAState *env = &cpu->env;
+    CPUHPPAState *env = cpu_env(CPU(obj));
 
     cs->exception_index = -1;
     cpu_hppa_loaded_fr0(env);
diff --git a/target/hppa/int_helper.c b/target/hppa/int_helper.c
index efe638b36e..1dc25ada01 100644
--- a/target/hppa/int_helper.c
+++ b/target/hppa/int_helper.c
@@ -99,8 +99,7 @@ void HELPER(write_eiem)(CPUHPPAState *env, target_ulong val)
 
 void hppa_cpu_do_interrupt(CPUState *cs)
 {
-    HPPACPU *cpu = HPPA_CPU(cs);
-    CPUHPPAState *env = &cpu->env;
+    CPUHPPAState *env = cpu_env(cs);
     int i = cs->exception_index;
     uint64_t old_psw;
 
@@ -268,8 +267,7 @@ void hppa_cpu_do_interrupt(CPUState *cs)
 
 bool hppa_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    HPPACPU *cpu = HPPA_CPU(cs);
-    CPUHPPAState *env = &cpu->env;
+    CPUHPPAState *env = cpu_env(cs);
 
     if (interrupt_request & CPU_INTERRUPT_NMI) {
         /* Raise TOC (NMI) interrupt */
diff --git a/target/hppa/mem_helper.c b/target/hppa/mem_helper.c
index 4fcc612754..f50a4122b3 100644
--- a/target/hppa/mem_helper.c
+++ b/target/hppa/mem_helper.c
@@ -357,8 +357,7 @@ bool hppa_cpu_tlb_fill(CPUState *cs, vaddr addr, int size,
                        MMUAccessType type, int mmu_idx,
                        bool probe, uintptr_t retaddr)
 {
-    HPPACPU *cpu = HPPA_CPU(cs);
-    CPUHPPAState *env = &cpu->env;
+    CPUHPPAState *env = cpu_env(cs);
     HPPATLBEntry *ent;
     int prot, excp, a_prot;
     hwaddr phys;
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
index 03822d9ba8..e0ce270d48 100644
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
@@ -5140,8 +5136,7 @@ static void x86_cpuid_version_get_stepping(Object *obj, Visitor *v,
                                            const char *name, void *opaque,
                                            Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     int64_t value;
 
     value = env->cpuid_version & 0xf;
@@ -5152,8 +5147,7 @@ static void x86_cpuid_version_set_stepping(Object *obj, Visitor *v,
                                            const char *name, void *opaque,
                                            Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     const int64_t min = 0;
     const int64_t max = 0xf;
     int64_t value;
@@ -5173,8 +5167,7 @@ static void x86_cpuid_version_set_stepping(Object *obj, Visitor *v,
 
 static char *x86_cpuid_get_vendor(Object *obj, Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     char *value;
 
     value = g_malloc(CPUID_VENDOR_SZ + 1);
@@ -5186,8 +5179,7 @@ static char *x86_cpuid_get_vendor(Object *obj, Error **errp)
 static void x86_cpuid_set_vendor(Object *obj, const char *value,
                                  Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     int i;
 
     if (strlen(value) != CPUID_VENDOR_SZ) {
@@ -5208,8 +5200,7 @@ static void x86_cpuid_set_vendor(Object *obj, const char *value,
 
 static char *x86_cpuid_get_model_id(Object *obj, Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     char *value;
     int i;
 
@@ -5224,8 +5215,7 @@ static char *x86_cpuid_get_model_id(Object *obj, Error **errp)
 static void x86_cpuid_set_model_id(Object *obj, const char *model_id,
                                    Error **errp)
 {
-    X86CPU *cpu = X86_CPU(obj);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(CPU(obj));
     int c, len, i;
 
     if (model_id == NULL) {
@@ -7673,8 +7663,7 @@ static vaddr x86_cpu_get_pc(CPUState *cs)
 
 int x86_cpu_pending_interrupt(CPUState *cs, int interrupt_request)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
 #if !defined(CONFIG_USER_ONLY)
     if (interrupt_request & CPU_INTERRUPT_POLL) {
@@ -7722,8 +7711,7 @@ static bool x86_cpu_has_work(CPUState *cs)
 
 static void x86_disas_set_info(CPUState *cs, disassemble_info *info)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     info->mach = (env->hflags & HF_CS64_MASK ? bfd_mach_x86_64
                   : env->hflags & HF_CS32_MASK ? bfd_mach_i386_i386
diff --git a/target/i386/helper.c b/target/i386/helper.c
index 2070dd0dda..19fe7e56e9 100644
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
@@ -625,8 +624,7 @@ void cpu_load_efer(CPUX86State *env, uint64_t val)
 
 uint8_t x86_ldub_phys(CPUState *cs, hwaddr addr)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     MemTxAttrs attrs = cpu_get_mem_attrs(env);
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
@@ -635,8 +633,7 @@ uint8_t x86_ldub_phys(CPUState *cs, hwaddr addr)
 
 uint32_t x86_lduw_phys(CPUState *cs, hwaddr addr)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     MemTxAttrs attrs = cpu_get_mem_attrs(env);
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
@@ -645,8 +642,7 @@ uint32_t x86_lduw_phys(CPUState *cs, hwaddr addr)
 
 uint32_t x86_ldl_phys(CPUState *cs, hwaddr addr)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     MemTxAttrs attrs = cpu_get_mem_attrs(env);
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
@@ -655,8 +651,7 @@ uint32_t x86_ldl_phys(CPUState *cs, hwaddr addr)
 
 uint64_t x86_ldq_phys(CPUState *cs, hwaddr addr)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     MemTxAttrs attrs = cpu_get_mem_attrs(env);
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
@@ -665,8 +660,7 @@ uint64_t x86_ldq_phys(CPUState *cs, hwaddr addr)
 
 void x86_stb_phys(CPUState *cs, hwaddr addr, uint8_t val)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     MemTxAttrs attrs = cpu_get_mem_attrs(env);
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
@@ -675,8 +669,7 @@ void x86_stb_phys(CPUState *cs, hwaddr addr, uint8_t val)
 
 void x86_stl_phys_notdirty(CPUState *cs, hwaddr addr, uint32_t val)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     MemTxAttrs attrs = cpu_get_mem_attrs(env);
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
@@ -685,8 +678,7 @@ void x86_stl_phys_notdirty(CPUState *cs, hwaddr addr, uint32_t val)
 
 void x86_stw_phys(CPUState *cs, hwaddr addr, uint32_t val)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     MemTxAttrs attrs = cpu_get_mem_attrs(env);
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
@@ -695,8 +687,7 @@ void x86_stw_phys(CPUState *cs, hwaddr addr, uint32_t val)
 
 void x86_stl_phys(CPUState *cs, hwaddr addr, uint32_t val)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     MemTxAttrs attrs = cpu_get_mem_attrs(env);
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
@@ -705,8 +696,7 @@ void x86_stl_phys(CPUState *cs, hwaddr addr, uint32_t val)
 
 void x86_stq_phys(CPUState *cs, hwaddr addr, uint64_t val)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     MemTxAttrs attrs = cpu_get_mem_attrs(env);
     AddressSpace *as = cpu_addressspace(cs, attrs);
 
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 11ffdd4c69..c8f5cf4d84 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -159,8 +159,7 @@ static bool ept_emulation_fault(hvf_slot *slot, uint64_t gpa, uint64_t ept_qual)
 
 void hvf_arch_vcpu_destroy(CPUState *cpu)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
+    CPUX86State *env = cpu_env(cpu);
 
     g_free(env->hvf_mmio_buf);
 }
@@ -313,8 +312,7 @@ int hvf_arch_init_vcpu(CPUState *cpu)
 
 static void hvf_store_events(CPUState *cpu, uint32_t ins_len, uint64_t idtvec_info)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
+    CPUX86State *env = cpu_env(cpu);
 
     env->exception_nr = -1;
     env->exception_pending = 0;
diff --git a/target/i386/hvf/x86.c b/target/i386/hvf/x86.c
index 8ceea6398e..5794d1ef8c 100644
--- a/target/i386/hvf/x86.c
+++ b/target/i386/hvf/x86.c
@@ -128,8 +128,7 @@ bool x86_is_real(struct CPUState *cpu)
 
 bool x86_is_v8086(struct CPUState *cpu)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
-    CPUX86State *env = &x86_cpu->env;
+    CPUX86State *env = cpu_env(CPU(cpu));
     return x86_is_protected(cpu) && (env->eflags & VM_MASK);
 }
 
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
index fc2c2321ac..e7dbfe4d74 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -313,8 +313,7 @@ static int kvm_xen_set_vcpu_callback_vector(CPUState *cs)
 
 static void do_set_vcpu_callback_vector(CPUState *cs, run_on_cpu_data data)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     env->xen_vcpu_callback_vector = data.host_int;
 
@@ -325,8 +324,7 @@ static void do_set_vcpu_callback_vector(CPUState *cs, run_on_cpu_data data)
 
 static int set_vcpu_info(CPUState *cs, uint64_t gpa)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     MemoryRegionSection mrs = { .mr = NULL };
     void *vcpu_info_hva = NULL;
     int ret;
@@ -362,8 +360,7 @@ static int set_vcpu_info(CPUState *cs, uint64_t gpa)
 
 static void do_set_vcpu_info_default_gpa(CPUState *cs, run_on_cpu_data data)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     env->xen_vcpu_info_default_gpa = data.host_ulong;
 
@@ -375,8 +372,7 @@ static void do_set_vcpu_info_default_gpa(CPUState *cs, run_on_cpu_data data)
 
 static void do_set_vcpu_info_gpa(CPUState *cs, run_on_cpu_data data)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     env->xen_vcpu_info_gpa = data.host_ulong;
 
@@ -479,8 +475,7 @@ void kvm_xen_inject_vcpu_callback_vector(uint32_t vcpu_id, int type)
 /* Must always be called with xen_timers_lock held */
 static int kvm_xen_set_vcpu_timer(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     struct kvm_xen_vcpu_attr va = {
         .type = KVM_XEN_VCPU_ATTR_TYPE_TIMER,
@@ -527,8 +522,7 @@ int kvm_xen_set_vcpu_virq(uint32_t vcpu_id, uint16_t virq, uint16_t port)
 
 static void do_set_vcpu_time_info_gpa(CPUState *cs, run_on_cpu_data data)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     env->xen_vcpu_time_info_gpa = data.host_ulong;
 
@@ -538,8 +532,7 @@ static void do_set_vcpu_time_info_gpa(CPUState *cs, run_on_cpu_data data)
 
 static void do_set_vcpu_runstate_gpa(CPUState *cs, run_on_cpu_data data)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     env->xen_vcpu_runstate_gpa = data.host_ulong;
 
@@ -549,8 +542,7 @@ static void do_set_vcpu_runstate_gpa(CPUState *cs, run_on_cpu_data data)
 
 static void do_vcpu_soft_reset(CPUState *cs, run_on_cpu_data data)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     env->xen_vcpu_info_gpa = INVALID_GPA;
     env->xen_vcpu_info_default_gpa = INVALID_GPA;
@@ -1813,8 +1805,7 @@ uint16_t kvm_xen_get_evtchn_max_pirq(void)
 
 int kvm_put_xen_state(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
     uint64_t gpa;
     int ret;
 
@@ -1887,8 +1878,7 @@ int kvm_put_xen_state(CPUState *cs)
 
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
index e1405b7be9..50230fe5f4 100644
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
 
@@ -96,8 +93,7 @@ static void x86_restore_state_to_opc(CPUState *cs,
 #ifndef CONFIG_USER_ONLY
 static bool x86_debug_check_breakpoint(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
+    CPUX86State *env = cpu_env(cs);
 
     /* RF disables all architectural breakpoints. */
     return !(env->eflags & RF_MASK);
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
diff --git a/target/m68k/cpu.c b/target/m68k/cpu.c
index 1421e77c2c..c122fd96fb 100644
--- a/target/m68k/cpu.c
+++ b/target/m68k/cpu.c
@@ -117,8 +117,7 @@ static ObjectClass *m68k_cpu_class_by_name(const char *cpu_model)
 
 static void m5206_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_A);
     m68k_set_feature(env, M68K_FEATURE_MOVEFROMSR_PRIV);
@@ -127,8 +126,7 @@ static void m5206_cpu_initfn(Object *obj)
 /* Base feature set, including isns. for m68k family */
 static void m68000_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_M68K);
     m68k_set_feature(env, M68K_FEATURE_USP);
@@ -141,8 +139,7 @@ static void m68000_cpu_initfn(Object *obj)
  */
 static void m68010_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68000_cpu_initfn(obj);
     m68k_set_feature(env, M68K_FEATURE_M68010);
@@ -161,8 +158,7 @@ static void m68010_cpu_initfn(Object *obj)
  */
 static void m68020_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68010_cpu_initfn(obj);
     m68k_unset_feature(env, M68K_FEATURE_M68010);
@@ -192,8 +188,7 @@ static void m68020_cpu_initfn(Object *obj)
  */
 static void m68030_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68020_cpu_initfn(obj);
     m68k_unset_feature(env, M68K_FEATURE_M68020);
@@ -219,8 +214,7 @@ static void m68030_cpu_initfn(Object *obj)
  */
 static void m68040_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68030_cpu_initfn(obj);
     m68k_unset_feature(env, M68K_FEATURE_M68030);
@@ -240,8 +234,7 @@ static void m68040_cpu_initfn(Object *obj)
  */
 static void m68060_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68040_cpu_initfn(obj);
     m68k_unset_feature(env, M68K_FEATURE_M68040);
@@ -254,8 +247,7 @@ static void m68060_cpu_initfn(Object *obj)
 
 static void m5208_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_A);
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_APLUSC);
@@ -267,8 +259,7 @@ static void m5208_cpu_initfn(Object *obj)
 
 static void cfv4e_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_A);
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_B);
@@ -281,8 +272,7 @@ static void cfv4e_cpu_initfn(Object *obj)
 
 static void any_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_A);
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_B);
diff --git a/target/m68k/gdbstub.c b/target/m68k/gdbstub.c
index 1e5f033a12..15547e2313 100644
--- a/target/m68k/gdbstub.c
+++ b/target/m68k/gdbstub.c
@@ -23,8 +23,7 @@
 
 int m68k_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
 
     if (n < 8) {
         /* D0-D7 */
@@ -50,8 +49,7 @@ int m68k_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int m68k_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
     uint32_t tmp;
 
     tmp = ldl_p(mem_buf);
diff --git a/target/m68k/helper.c b/target/m68k/helper.c
index 14508dfa11..85f3cd1680 100644
--- a/target/m68k/helper.c
+++ b/target/m68k/helper.c
@@ -894,8 +894,7 @@ txfail:
 
 hwaddr m68k_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
     hwaddr phys_addr;
     int prot;
     int access_type;
diff --git a/target/m68k/m68k-semi.c b/target/m68k/m68k-semi.c
index b4ffb70f8b..546cff2246 100644
--- a/target/m68k/m68k-semi.c
+++ b/target/m68k/m68k-semi.c
@@ -77,8 +77,7 @@ static int host_to_gdb_errno(int err)
 
 static void m68k_semi_u32_cb(CPUState *cs, uint64_t ret, int err)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
 
     target_ulong args = env->dregs[1];
     if (put_user_u32(ret, args) ||
@@ -95,8 +94,7 @@ static void m68k_semi_u32_cb(CPUState *cs, uint64_t ret, int err)
 
 static void m68k_semi_u64_cb(CPUState *cs, uint64_t ret, int err)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
 
     target_ulong args = env->dregs[1];
     if (put_user_u32(ret >> 32, args) ||
diff --git a/target/m68k/op_helper.c b/target/m68k/op_helper.c
index 1ce850bbc5..89f0915e2e 100644
--- a/target/m68k/op_helper.c
+++ b/target/m68k/op_helper.c
@@ -441,8 +441,7 @@ static void do_interrupt_all(CPUM68KState *env, int is_hw)
 
 void m68k_cpu_do_interrupt(CPUState *cs)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
 
     do_interrupt_all(env, 0);
 }
@@ -457,8 +456,7 @@ void m68k_cpu_transaction_failed(CPUState *cs, hwaddr physaddr, vaddr addr,
                                  int mmu_idx, MemTxAttrs attrs,
                                  MemTxResult response, uintptr_t retaddr)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
 
     cpu_restore_state(cs, retaddr);
 
@@ -511,8 +509,7 @@ void m68k_cpu_transaction_failed(CPUState *cs, hwaddr physaddr, vaddr addr,
 
 bool m68k_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
 
     if (interrupt_request & CPU_INTERRUPT_HARD
         && ((env->sr & SR_I) >> SR_I_SHIFT) < env->pending_level) {
diff --git a/target/m68k/translate.c b/target/m68k/translate.c
index 4a0b0b2703..9688476a7b 100644
--- a/target/m68k/translate.c
+++ b/target/m68k/translate.c
@@ -6108,8 +6108,7 @@ static double floatx80_to_double(CPUM68KState *env, uint16_t high, uint64_t low)
 
 void m68k_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
     int i;
     uint16_t sr;
     for (i = 0; i < 8; i++) {
diff --git a/target/microblaze/helper.c b/target/microblaze/helper.c
index 98bdb82de8..bf955dd425 100644
--- a/target/microblaze/helper.c
+++ b/target/microblaze/helper.c
@@ -253,8 +253,7 @@ hwaddr mb_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
 
 bool mb_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    MicroBlazeCPU *cpu = MICROBLAZE_CPU(cs);
-    CPUMBState *env = &cpu->env;
+    CPUMBState *env = cpu_env(cs);
 
     if ((interrupt_request & CPU_INTERRUPT_HARD)
         && (env->msr & MSR_IE)
diff --git a/target/microblaze/translate.c b/target/microblaze/translate.c
index 49bfb4a0ea..1c6e4fcfe4 100644
--- a/target/microblaze/translate.c
+++ b/target/microblaze/translate.c
@@ -1800,8 +1800,7 @@ void gen_intermediate_code(CPUState *cpu, TranslationBlock *tb, int *max_insns,
 
 void mb_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    MicroBlazeCPU *cpu = MICROBLAZE_CPU(cs);
-    CPUMBState *env = &cpu->env;
+    CPUMBState *env = cpu_env(cs);
     uint32_t iflags;
     int i;
 
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index a0023edd43..1eaa42e561 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -80,8 +80,7 @@ static void fpu_dump_state(CPUMIPSState *env, FILE *f, int flags)
 
 static void mips_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "pc=0x" TARGET_FMT_lx " HI=0x" TARGET_FMT_lx
@@ -137,8 +136,7 @@ static vaddr mips_cpu_get_pc(CPUState *cs)
 
 static bool mips_cpu_has_work(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     bool has_work = false;
 
     /*
@@ -428,8 +426,7 @@ static void mips_cpu_reset_hold(Object *obj)
 
 static void mips_cpu_disas_set_info(CPUState *s, disassemble_info *info)
 {
-    MIPSCPU *cpu = MIPS_CPU(s);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(s);
 
     if (!(env->insn_flags & ISA_NANOMIPS32)) {
 #if TARGET_BIG_ENDIAN
diff --git a/target/mips/gdbstub.c b/target/mips/gdbstub.c
index 62d7b72407..169d47416a 100644
--- a/target/mips/gdbstub.c
+++ b/target/mips/gdbstub.c
@@ -25,8 +25,7 @@
 
 int mips_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
 
     if (n < 32) {
         return gdb_get_regl(mem_buf, env->active_tc.gpr[n]);
@@ -78,8 +77,7 @@ int mips_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int mips_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     target_ulong tmp;
 
     tmp = ldtul_p(mem_buf);
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index 15d0cf9adb..6c52e59f55 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -63,8 +63,7 @@ int kvm_arch_irqchip_create(KVMState *s)
 
 int kvm_arch_init_vcpu(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int ret = 0;
 
     qemu_add_vm_change_state_handler(kvm_mips_update_state, cs);
@@ -460,8 +459,7 @@ static inline int kvm_mips_change_one_reg(CPUState *cs, uint64_t reg_id,
  */
 static int kvm_mips_save_count(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     uint64_t count_ctl;
     int err, ret = 0;
 
@@ -502,8 +500,7 @@ static int kvm_mips_save_count(CPUState *cs)
  */
 static int kvm_mips_restore_count(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     uint64_t count_ctl;
     int err_dc, err, ret = 0;
 
@@ -590,8 +587,7 @@ static void kvm_mips_update_state(void *opaque, bool running, RunState state)
 
 static int kvm_mips_put_fpu_registers(CPUState *cs, int level)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int err, ret = 0;
     unsigned int i;
 
@@ -670,8 +666,7 @@ static int kvm_mips_put_fpu_registers(CPUState *cs, int level)
 
 static int kvm_mips_get_fpu_registers(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int err, ret = 0;
     unsigned int i;
 
@@ -751,8 +746,7 @@ static int kvm_mips_get_fpu_registers(CPUState *cs)
 
 static int kvm_mips_put_cp0_registers(CPUState *cs, int level)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int err, ret = 0;
 
     (void)level;
@@ -974,8 +968,7 @@ static int kvm_mips_put_cp0_registers(CPUState *cs, int level)
 
 static int kvm_mips_get_cp0_registers(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int err, ret = 0;
 
     err = kvm_mips_get_one_reg(cs, KVM_REG_MIPS_CP0_INDEX, &env->CP0_Index);
@@ -1181,8 +1174,7 @@ static int kvm_mips_get_cp0_registers(CPUState *cs)
 
 int kvm_arch_put_registers(CPUState *cs, int level)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     struct kvm_regs regs;
     int ret;
     int i;
@@ -1217,8 +1209,7 @@ int kvm_arch_put_registers(CPUState *cs, int level)
 
 int kvm_arch_get_registers(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int ret = 0;
     struct kvm_regs regs;
     int i;
diff --git a/target/mips/sysemu/physaddr.c b/target/mips/sysemu/physaddr.c
index 05990aa5bb..56380dfe6c 100644
--- a/target/mips/sysemu/physaddr.c
+++ b/target/mips/sysemu/physaddr.c
@@ -230,8 +230,7 @@ int get_physical_address(CPUMIPSState *env, hwaddr *physical,
 
 hwaddr mips_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     hwaddr phys_addr;
     int prot;
 
diff --git a/target/mips/tcg/exception.c b/target/mips/tcg/exception.c
index da49a93912..13275d1ded 100644
--- a/target/mips/tcg/exception.c
+++ b/target/mips/tcg/exception.c
@@ -79,8 +79,7 @@ void helper_wait(CPUMIPSState *env)
 
 void mips_cpu_synchronize_from_tb(CPUState *cs, const TranslationBlock *tb)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
 
     tcg_debug_assert(!(cs->tcg_cflags & CF_PCREL));
     env->active_tc.PC = tb->pc;
diff --git a/target/mips/tcg/op_helper.c b/target/mips/tcg/op_helper.c
index 98935b5e64..b57baa7ec1 100644
--- a/target/mips/tcg/op_helper.c
+++ b/target/mips/tcg/op_helper.c
@@ -279,8 +279,7 @@ void mips_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                   MMUAccessType access_type,
                                   int mmu_idx, uintptr_t retaddr)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int error_code = 0;
     int excp;
 
diff --git a/target/mips/tcg/sysemu/special_helper.c b/target/mips/tcg/sysemu/special_helper.c
index 93276f789d..7934f2ea41 100644
--- a/target/mips/tcg/sysemu/special_helper.c
+++ b/target/mips/tcg/sysemu/special_helper.c
@@ -90,8 +90,7 @@ static void debug_post_eret(CPUMIPSState *env)
 
 bool mips_io_recompile_replay_branch(CPUState *cs, const TranslationBlock *tb)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
 
     if ((env->hflags & MIPS_HFLAG_BMASK) != 0
         && !(cs->tcg_cflags & CF_PCREL) && env->active_tc.PC != tb->pc) {
diff --git a/target/mips/tcg/sysemu/tlb_helper.c b/target/mips/tcg/sysemu/tlb_helper.c
index 4ede904800..6c48c4fa80 100644
--- a/target/mips/tcg/sysemu/tlb_helper.c
+++ b/target/mips/tcg/sysemu/tlb_helper.c
@@ -910,8 +910,7 @@ bool mips_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        MMUAccessType access_type, int mmu_idx,
                        bool probe, uintptr_t retaddr)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     hwaddr physical;
     int prot;
     int ret = TLBRET_BADADDR;
@@ -1346,8 +1345,7 @@ void mips_cpu_do_interrupt(CPUState *cs)
 bool mips_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     if (interrupt_request & CPU_INTERRUPT_HARD) {
-        MIPSCPU *cpu = MIPS_CPU(cs);
-        CPUMIPSState *env = &cpu->env;
+        CPUMIPSState *env = cpu_env(cs);
 
         if (cpu_mips_hw_interrupts_enabled(env) &&
             cpu_mips_hw_interrupts_pending(env)) {
diff --git a/target/mips/tcg/translate.c b/target/mips/tcg/translate.c
index 13e43fa3b6..e74b98de1c 100644
--- a/target/mips/tcg/translate.c
+++ b/target/mips/tcg/translate.c
@@ -15628,8 +15628,7 @@ void mips_restore_state_to_opc(CPUState *cs,
                                const TranslationBlock *tb,
                                const uint64_t *data)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
 
     env->active_tc.PC = data[0];
     env->hflags &= ~MIPS_HFLAG_BMASK;
diff --git a/target/nios2/cpu.c b/target/nios2/cpu.c
index a27732bf2b..d98f1e85c5 100644
--- a/target/nios2/cpu.c
+++ b/target/nios2/cpu.c
@@ -28,16 +28,14 @@
 
 static void nios2_cpu_set_pc(CPUState *cs, vaddr value)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
+    CPUNios2State *env = cpu_env(cs);
 
     env->pc = value;
 }
 
 static vaddr nios2_cpu_get_pc(CPUState *cs)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
+    CPUNios2State *env = cpu_env(cs);
 
     return env->pc;
 }
@@ -46,8 +44,7 @@ static void nios2_restore_state_to_opc(CPUState *cs,
                                        const TranslationBlock *tb,
                                        const uint64_t *data)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
+    CPUNios2State *env = cpu_env(cs);
 
     env->pc = data[0];
 }
diff --git a/target/nios2/helper.c b/target/nios2/helper.c
index bb3b09e5a7..ac57121afc 100644
--- a/target/nios2/helper.c
+++ b/target/nios2/helper.c
@@ -287,8 +287,7 @@ void nios2_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                    MMUAccessType access_type,
                                    int mmu_idx, uintptr_t retaddr)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
+    CPUNios2State *env = cpu_env(cs);
 
     env->ctrl[CR_BADADDR] = addr;
     cs->exception_index = EXCP_UNALIGN;
diff --git a/target/nios2/nios2-semi.c b/target/nios2/nios2-semi.c
index 0b84fcb6b6..420702e293 100644
--- a/target/nios2/nios2-semi.c
+++ b/target/nios2/nios2-semi.c
@@ -75,8 +75,7 @@ static int host_to_gdb_errno(int err)
 
 static void nios2_semi_u32_cb(CPUState *cs, uint64_t ret, int err)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
+    CPUNios2State *env = cpu_env(cs);
     target_ulong args = env->regs[R_ARG1];
 
     if (put_user_u32(ret, args) ||
@@ -93,8 +92,7 @@ static void nios2_semi_u32_cb(CPUState *cs, uint64_t ret, int err)
 
 static void nios2_semi_u64_cb(CPUState *cs, uint64_t ret, int err)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
+    CPUNios2State *env = cpu_env(cs);
     target_ulong args = env->regs[R_ARG1];
 
     if (put_user_u32(ret >> 32, args) ||
diff --git a/target/openrisc/gdbstub.c b/target/openrisc/gdbstub.c
index d1074a0581..0cce8d4f92 100644
--- a/target/openrisc/gdbstub.c
+++ b/target/openrisc/gdbstub.c
@@ -23,8 +23,7 @@
 
 int openrisc_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    OpenRISCCPU *cpu = OPENRISC_CPU(cs);
-    CPUOpenRISCState *env = &cpu->env;
+    CPUOpenRISCState *env = cpu_env(cs);
 
     if (n < 32) {
         return gdb_get_reg32(mem_buf, cpu_get_gpr(env, n));
diff --git a/target/openrisc/interrupt.c b/target/openrisc/interrupt.c
index d4fdb8ce8e..b3b5b40577 100644
--- a/target/openrisc/interrupt.c
+++ b/target/openrisc/interrupt.c
@@ -29,8 +29,7 @@
 
 void openrisc_cpu_do_interrupt(CPUState *cs)
 {
-    OpenRISCCPU *cpu = OPENRISC_CPU(cs);
-    CPUOpenRISCState *env = &cpu->env;
+    CPUOpenRISCState *env = cpu_env(cs);
     int exception = cs->exception_index;
 
     env->epcr = env->pc;
@@ -105,8 +104,7 @@ void openrisc_cpu_do_interrupt(CPUState *cs)
 
 bool openrisc_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    OpenRISCCPU *cpu = OPENRISC_CPU(cs);
-    CPUOpenRISCState *env = &cpu->env;
+    CPUOpenRISCState *env = cpu_env(cs);
     int idx = -1;
 
     if ((interrupt_request & CPU_INTERRUPT_HARD) && (env->sr & SR_IEE)) {
diff --git a/target/openrisc/translate.c b/target/openrisc/translate.c
index ecff4412b7..aff53c0065 100644
--- a/target/openrisc/translate.c
+++ b/target/openrisc/translate.c
@@ -1668,8 +1668,7 @@ void gen_intermediate_code(CPUState *cs, TranslationBlock *tb, int *max_insns,
 
 void openrisc_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    OpenRISCCPU *cpu = OPENRISC_CPU(cs);
-    CPUOpenRISCState *env = &cpu->env;
+    CPUOpenRISCState *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "PC=%08x\n", env->pc);
diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index 344196a8ce..f14ca2bd25 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -7195,8 +7195,7 @@ static void ppc_cpu_reset_hold(Object *obj)
 
 static bool ppc_cpu_is_big_endian(CPUState *cs)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
 
     cpu_synchronize_state(cs);
 
@@ -7287,8 +7286,7 @@ static bool ppc_pvr_match_default(PowerPCCPUClass *pcc, uint32_t pvr, bool best)
 
 static void ppc_disas_set_info(CPUState *cs, disassemble_info *info)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
 
     if ((env->hflags >> MSR_LE) & 1) {
         info->endian = BFD_ENDIAN_LITTLE;
@@ -7446,8 +7444,7 @@ void ppc_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 #define RGPL  4
 #define RFPL  4
 
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "NIP " TARGET_FMT_lx "   LR " TARGET_FMT_lx " CTR "
diff --git a/target/ppc/excp_helper.c b/target/ppc/excp_helper.c
index 2ec6429e36..fccfefa88e 100644
--- a/target/ppc/excp_helper.c
+++ b/target/ppc/excp_helper.c
@@ -2588,8 +2588,7 @@ void ppc_cpu_do_fwnmi_machine_check(CPUState *cs, target_ulong vector)
 
 bool ppc_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     int interrupt;
 
     if ((interrupt_request & CPU_INTERRUPT_HARD) == 0) {
diff --git a/target/ppc/gdbstub.c b/target/ppc/gdbstub.c
index ec5731e5d6..fd986b1922 100644
--- a/target/ppc/gdbstub.c
+++ b/target/ppc/gdbstub.c
@@ -108,8 +108,7 @@ void ppc_maybe_bswap_register(CPUPPCState *env, uint8_t *mem_buf, int len)
 
 int ppc_cpu_gdb_read_register(CPUState *cs, GByteArray *buf, int n)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     uint8_t *mem_buf;
     int r = ppc_gdb_register_len(n);
 
@@ -152,8 +151,7 @@ int ppc_cpu_gdb_read_register(CPUState *cs, GByteArray *buf, int n)
 
 int ppc_cpu_gdb_read_register_apple(CPUState *cs, GByteArray *buf, int n)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     uint8_t *mem_buf;
     int r = ppc_gdb_register_len_apple(n);
 
@@ -206,8 +204,7 @@ int ppc_cpu_gdb_read_register_apple(CPUState *cs, GByteArray *buf, int n)
 
 int ppc_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     int r = ppc_gdb_register_len(n);
 
     if (!r) {
@@ -253,8 +250,7 @@ int ppc_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 }
 int ppc_cpu_gdb_write_register_apple(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     int r = ppc_gdb_register_len_apple(n);
 
     if (!r) {
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 26fa9d0575..7a0651b0af 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -546,8 +546,7 @@ static void kvm_sw_tlb_put(PowerPCCPU *cpu)
 
 static void kvm_get_one_spr(CPUState *cs, uint64_t id, int spr)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     /* Init 'val' to avoid "uninitialised value" Valgrind warnings */
     union {
         uint32_t u32;
@@ -581,8 +580,7 @@ static void kvm_get_one_spr(CPUState *cs, uint64_t id, int spr)
 
 static void kvm_put_one_spr(CPUState *cs, uint64_t id, int spr)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     union {
         uint32_t u32;
         uint64_t u64;
diff --git a/target/ppc/ppc-qmp-cmds.c b/target/ppc/ppc-qmp-cmds.c
index c0c137d9d7..9ac74f5c04 100644
--- a/target/ppc/ppc-qmp-cmds.c
+++ b/target/ppc/ppc-qmp-cmds.c
@@ -133,8 +133,7 @@ static int ppc_cpu_get_reg_num(const char *numstr, int maxnum, int *pregnum)
 int target_get_monitor_def(CPUState *cs, const char *name, uint64_t *pval)
 {
     int i, regnum;
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
 
     /* General purpose registers */
     if ((qemu_tolower(name[0]) == 'r') &&
diff --git a/target/ppc/user_only_helper.c b/target/ppc/user_only_helper.c
index 7ff76f7a06..a4d07a0d0d 100644
--- a/target/ppc/user_only_helper.c
+++ b/target/ppc/user_only_helper.c
@@ -27,8 +27,7 @@ void ppc_cpu_record_sigsegv(CPUState *cs, vaddr address,
                             MMUAccessType access_type,
                             bool maperr, uintptr_t retaddr)
 {
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
-    CPUPPCState *env = &cpu->env;
+    CPUPPCState *env = cpu_env(cs);
     int exception, error_code;
 
     /*
diff --git a/target/riscv/arch_dump.c b/target/riscv/arch_dump.c
index 434c8a3dbb..994709647f 100644
--- a/target/riscv/arch_dump.c
+++ b/target/riscv/arch_dump.c
@@ -68,8 +68,7 @@ int riscv_cpu_write_elf64_note(WriteCoreDumpFunction f, CPUState *cs,
                                int cpuid, DumpState *s)
 {
     struct riscv64_note note;
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     int ret, i = 0;
     const char name[] = "CORE";
 
@@ -137,8 +136,7 @@ int riscv_cpu_write_elf32_note(WriteCoreDumpFunction f, CPUState *cs,
                                int cpuid, DumpState *s)
 {
     struct riscv32_note note;
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     int ret, i;
     const char name[] = "CORE";
 
diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 8cbfc7e781..bb58acfa37 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -419,8 +419,7 @@ static void riscv_any_cpu_init(Object *obj)
 
 static void riscv_max_cpu_init(Object *obj)
 {
-    RISCVCPU *cpu = RISCV_CPU(obj);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(CPU(obj));
     RISCVMXL mlx = MXL_RV64;
 
 #ifdef TARGET_RISCV32
@@ -828,8 +827,7 @@ static void riscv_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 
 static void riscv_cpu_set_pc(CPUState *cs, vaddr value)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
 
     if (env->xl == MXL_RV32) {
         env->pc = (int32_t)value;
@@ -840,8 +838,7 @@ static void riscv_cpu_set_pc(CPUState *cs, vaddr value)
 
 static vaddr riscv_cpu_get_pc(CPUState *cs)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
 
     /* Match cpu_get_tb_cpu_state. */
     if (env->xl == MXL_RV32) {
@@ -853,8 +850,7 @@ static vaddr riscv_cpu_get_pc(CPUState *cs)
 static bool riscv_cpu_has_work(CPUState *cs)
 {
 #ifndef CONFIG_USER_ONLY
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     /*
      * Definition of the WFI instruction requires it to ignore the privilege
      * mode and delegation registers, but respect individual enables
@@ -1642,8 +1638,7 @@ static void rva22s64_profile_cpu_init(Object *obj)
 
 static const gchar *riscv_gdb_arch_name(CPUState *cs)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
 
     switch (riscv_cpu_mxl(env)) {
     case MXL_RV32:
diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
index c7cc7eb423..5c3ed07aeb 100644
--- a/target/riscv/cpu_helper.c
+++ b/target/riscv/cpu_helper.c
@@ -493,8 +493,7 @@ static int riscv_cpu_local_irq_pending(CPURISCVState *env)
 bool riscv_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     if (interrupt_request & CPU_INTERRUPT_HARD) {
-        RISCVCPU *cpu = RISCV_CPU(cs);
-        CPURISCVState *env = &cpu->env;
+        CPURISCVState *env = cpu_env(cs);
         int interruptno = riscv_cpu_local_irq_pending(env);
         if (interruptno >= 0) {
             cs->exception_index = RISCV_EXCP_INT_FLAG | interruptno;
@@ -1223,8 +1222,7 @@ void riscv_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr,
                                      int mmu_idx, MemTxAttrs attrs,
                                      MemTxResult response, uintptr_t retaddr)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
 
     if (access_type == MMU_DATA_STORE) {
         cs->exception_index = RISCV_EXCP_STORE_AMO_ACCESS_FAULT;
@@ -1244,8 +1242,7 @@ void riscv_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                    MMUAccessType access_type, int mmu_idx,
                                    uintptr_t retaddr)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     switch (access_type) {
     case MMU_INST_FETCH:
         cs->exception_index = RISCV_EXCP_INST_ADDR_MIS;
@@ -1631,9 +1628,7 @@ static target_ulong riscv_transformed_insn(CPURISCVState *env,
 void riscv_cpu_do_interrupt(CPUState *cs)
 {
 #if !defined(CONFIG_USER_ONLY)
-
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     bool write_gva = false;
     uint64_t s;
 
diff --git a/target/riscv/debug.c b/target/riscv/debug.c
index 4945d1a1f2..c8df9812be 100644
--- a/target/riscv/debug.c
+++ b/target/riscv/debug.c
@@ -757,8 +757,7 @@ target_ulong tinfo_csr_read(CPURISCVState *env)
 
 void riscv_cpu_debug_excp_handler(CPUState *cs)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
 
     if (cs->watchpoint_hit) {
         if (cs->watchpoint_hit->flags & BP_CPU) {
@@ -773,8 +772,7 @@ void riscv_cpu_debug_excp_handler(CPUState *cs)
 
 bool riscv_cpu_debug_check_breakpoint(CPUState *cs)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     CPUBreakpoint *bp;
     target_ulong ctrl;
     target_ulong pc;
@@ -832,8 +830,7 @@ bool riscv_cpu_debug_check_breakpoint(CPUState *cs)
 
 bool riscv_cpu_debug_check_watchpoint(CPUState *cs, CPUWatchpoint *wp)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     target_ulong ctrl;
     target_ulong addr;
     int trigger_type;
diff --git a/target/riscv/gdbstub.c b/target/riscv/gdbstub.c
index 58b3ace0fe..999d815b34 100644
--- a/target/riscv/gdbstub.c
+++ b/target/riscv/gdbstub.c
@@ -49,8 +49,7 @@ static const struct TypeSize vec_lanes[] = {
 
 int riscv_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     target_ulong tmp;
 
     if (n < 32) {
@@ -75,8 +74,7 @@ int riscv_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int riscv_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     int length = 0;
     target_ulong tmp;
 
diff --git a/target/riscv/kvm/kvm-cpu.c b/target/riscv/kvm/kvm-cpu.c
index 680a729cd8..cf0cae813b 100644
--- a/target/riscv/kvm/kvm-cpu.c
+++ b/target/riscv/kvm/kvm-cpu.c
@@ -171,8 +171,7 @@ static void kvm_cpu_get_misa_ext_cfg(Object *obj, Visitor *v,
 {
     KVMCPUConfig *misa_ext_cfg = opaque;
     target_ulong misa_bit = misa_ext_cfg->offset;
-    RISCVCPU *cpu = RISCV_CPU(obj);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(CPU(obj));
     bool value = env->misa_ext_mask & misa_bit;
 
     visit_type_bool(v, name, &value, errp);
@@ -184,8 +183,7 @@ static void kvm_cpu_set_misa_ext_cfg(Object *obj, Visitor *v,
 {
     KVMCPUConfig *misa_ext_cfg = opaque;
     target_ulong misa_bit = misa_ext_cfg->offset;
-    RISCVCPU *cpu = RISCV_CPU(obj);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(CPU(obj));
     bool value, host_bit;
 
     if (!visit_type_bool(v, name, &value, errp)) {
diff --git a/target/riscv/tcg/tcg-cpu.c b/target/riscv/tcg/tcg-cpu.c
index 994ca1cdf9..c7c4d9ac92 100644
--- a/target/riscv/tcg/tcg-cpu.c
+++ b/target/riscv/tcg/tcg-cpu.c
@@ -92,8 +92,7 @@ static void riscv_cpu_synchronize_from_tb(CPUState *cs,
                                           const TranslationBlock *tb)
 {
     if (!(tb_cflags(tb) & CF_PCREL)) {
-        RISCVCPU *cpu = RISCV_CPU(cs);
-        CPURISCVState *env = &cpu->env;
+        CPURISCVState *env = cpu_env(cs);
         RISCVMXL xl = FIELD_EX32(tb->flags, TB_FLAGS, XL);
 
         tcg_debug_assert(!(cs->tcg_cflags & CF_PCREL));
@@ -110,8 +109,7 @@ static void riscv_restore_state_to_opc(CPUState *cs,
                                        const TranslationBlock *tb,
                                        const uint64_t *data)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     RISCVMXL xl = FIELD_EX32(tb->flags, TB_FLAGS, XL);
     target_ulong pc;
 
@@ -1030,8 +1028,7 @@ static void cpu_get_misa_ext_cfg(Object *obj, Visitor *v, const char *name,
 {
     const RISCVCPUMisaExtConfig *misa_ext_cfg = opaque;
     target_ulong misa_bit = misa_ext_cfg->misa_bit;
-    RISCVCPU *cpu = RISCV_CPU(obj);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(CPU(obj));
     bool value;
 
     value = env->misa_ext & misa_bit;
diff --git a/target/riscv/translate.c b/target/riscv/translate.c
index 071fbad7ef..e94fb107e0 100644
--- a/target/riscv/translate.c
+++ b/target/riscv/translate.c
@@ -1265,8 +1265,7 @@ static void riscv_tr_disas_log(const DisasContextBase *dcbase,
                                CPUState *cpu, FILE *logfile)
 {
 #ifndef CONFIG_USER_ONLY
-    RISCVCPU *rvcpu = RISCV_CPU(cpu);
-    CPURISCVState *env = &rvcpu->env;
+    CPURISCVState *env = cpu_env(cpu);
 #endif
 
     fprintf(logfile, "IN: %s\n", lookup_symbol(dcbase->pc_first));
diff --git a/target/rx/gdbstub.c b/target/rx/gdbstub.c
index d7e0e6689b..f222bf003b 100644
--- a/target/rx/gdbstub.c
+++ b/target/rx/gdbstub.c
@@ -21,8 +21,7 @@
 
 int rx_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    RXCPU *cpu = RX_CPU(cs);
-    CPURXState *env = &cpu->env;
+    CPURXState *env = cpu_env(cs);
 
     switch (n) {
     case 0 ... 15:
@@ -53,8 +52,7 @@ int rx_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int rx_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    RXCPU *cpu = RX_CPU(cs);
-    CPURXState *env = &cpu->env;
+    CPURXState *env = cpu_env(cs);
     uint32_t psw;
     switch (n) {
     case 0 ... 15:
diff --git a/target/rx/helper.c b/target/rx/helper.c
index dad5fb4976..80912e8dcb 100644
--- a/target/rx/helper.c
+++ b/target/rx/helper.c
@@ -45,8 +45,7 @@ void rx_cpu_unpack_psw(CPURXState *env, uint32_t psw, int rte)
 #define INT_FLAGS (CPU_INTERRUPT_HARD | CPU_INTERRUPT_FIR)
 void rx_cpu_do_interrupt(CPUState *cs)
 {
-    RXCPU *cpu = RX_CPU(cs);
-    CPURXState *env = &cpu->env;
+    CPURXState *env = cpu_env(cs);
     int do_irq = cs->interrupt_request & INT_FLAGS;
     uint32_t save_psw;
 
@@ -122,8 +121,7 @@ void rx_cpu_do_interrupt(CPUState *cs)
 
 bool rx_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    RXCPU *cpu = RX_CPU(cs);
-    CPURXState *env = &cpu->env;
+    CPURXState *env = cpu_env(cs);
     int accept = 0;
     /* hardware interrupt (Normal) */
     if ((interrupt_request & CPU_INTERRUPT_HARD) &&
diff --git a/target/rx/translate.c b/target/rx/translate.c
index c6ce717a95..8d8d9a4677 100644
--- a/target/rx/translate.c
+++ b/target/rx/translate.c
@@ -131,8 +131,7 @@ static int bdsp_s(DisasContext *ctx, int d)
 
 void rx_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    RXCPU *cpu = RX_CPU(cs);
-    CPURXState *env = &cpu->env;
+    CPURXState *env = cpu_env(cs);
     int i;
     uint32_t psw;
 
diff --git a/target/s390x/cpu-dump.c b/target/s390x/cpu-dump.c
index ffa9e94d84..69cc9f7746 100644
--- a/target/s390x/cpu-dump.c
+++ b/target/s390x/cpu-dump.c
@@ -27,8 +27,7 @@
 
 void s390_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "PSW=mask %016" PRIx64 " addr %016" PRIx64,
diff --git a/target/s390x/gdbstub.c b/target/s390x/gdbstub.c
index 6fbfd41bc8..f02fa316e5 100644
--- a/target/s390x/gdbstub.c
+++ b/target/s390x/gdbstub.c
@@ -30,8 +30,7 @@
 
 int s390_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
 
     switch (n) {
     case S390_PSWM_REGNUM:
@@ -46,8 +45,7 @@ int s390_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int s390_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     target_ulong tmpl = ldtul_p(mem_buf);
 
     switch (n) {
diff --git a/target/s390x/helper.c b/target/s390x/helper.c
index d76c06381b..00d5d403f3 100644
--- a/target/s390x/helper.c
+++ b/target/s390x/helper.c
@@ -139,8 +139,7 @@ void do_restart_interrupt(CPUS390XState *env)
 void s390_cpu_recompute_watchpoints(CPUState *cs)
 {
     const int wp_flags = BP_CPU | BP_MEM_WRITE | BP_STOP_BEFORE_ACCESS;
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
 
     /* We are called when the watchpoints have changed. First
        remove them all.  */
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 888d6c1a1c..4ce809c5d4 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -474,8 +474,7 @@ static int can_sync_regs(CPUState *cs, int regs)
 
 int kvm_arch_put_registers(CPUState *cs, int level)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     struct kvm_fpu fpu = {};
     int r;
     int i;
@@ -601,8 +600,7 @@ int kvm_arch_put_registers(CPUState *cs, int level)
 
 int kvm_arch_get_registers(CPUState *cs)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     struct kvm_fpu fpu;
     int i, r;
 
diff --git a/target/s390x/tcg/excp_helper.c b/target/s390x/tcg/excp_helper.c
index b875bf14e5..0f48bcfdba 100644
--- a/target/s390x/tcg/excp_helper.c
+++ b/target/s390x/tcg/excp_helper.c
@@ -90,8 +90,7 @@ void HELPER(data_exception)(CPUS390XState *env, uint32_t dxc)
 static G_NORETURN
 void do_unaligned_access(CPUState *cs, uintptr_t retaddr)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
 
     tcg_s390_program_interrupt(env, PGM_SPECIFICATION, retaddr);
 }
@@ -146,8 +145,7 @@ bool s390_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        MMUAccessType access_type, int mmu_idx,
                        bool probe, uintptr_t retaddr)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     target_ulong vaddr, raddr;
     uint64_t asc, tec;
     int prot, excp;
@@ -600,8 +598,7 @@ bool s390_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 
 void s390x_cpu_debug_excp_handler(CPUState *cs)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     CPUWatchpoint *wp_hit = cs->watchpoint_hit;
 
     if (wp_hit && wp_hit->flags & BP_CPU) {
diff --git a/target/s390x/tcg/translate.c b/target/s390x/tcg/translate.c
index 8df00b7df9..9995689bc8 100644
--- a/target/s390x/tcg/translate.c
+++ b/target/s390x/tcg/translate.c
@@ -6558,8 +6558,7 @@ void s390x_restore_state_to_opc(CPUState *cs,
                                 const TranslationBlock *tb,
                                 const uint64_t *data)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     int cc_op = data[1];
 
     env->psw.addr = data[0];
diff --git a/target/sh4/cpu.c b/target/sh4/cpu.c
index 806a0ef875..786c77615e 100644
--- a/target/sh4/cpu.c
+++ b/target/sh4/cpu.c
@@ -71,8 +71,7 @@ static void superh_restore_state_to_opc(CPUState *cs,
 static bool superh_io_recompile_replay_branch(CPUState *cs,
                                               const TranslationBlock *tb)
 {
-    SuperHCPU *cpu = SUPERH_CPU(cs);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(cs);
 
     if ((env->flags & (TB_FLAG_DELAY_SLOT | TB_FLAG_DELAY_SLOT_COND))
         && !(cs->tcg_cflags & CF_PCREL) && env->pc != tb->pc) {
@@ -144,8 +143,7 @@ out:
 
 static void sh7750r_cpu_initfn(Object *obj)
 {
-    SuperHCPU *cpu = SUPERH_CPU(obj);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(CPU(obj));
 
     env->id = SH_CPU_SH7750R;
     env->features = SH_FEATURE_BCR3_AND_BCR4;
@@ -162,8 +160,7 @@ static void sh7750r_class_init(ObjectClass *oc, void *data)
 
 static void sh7751r_cpu_initfn(Object *obj)
 {
-    SuperHCPU *cpu = SUPERH_CPU(obj);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(CPU(obj));
 
     env->id = SH_CPU_SH7751R;
     env->features = SH_FEATURE_BCR3_AND_BCR4;
@@ -180,8 +177,7 @@ static void sh7751r_class_init(ObjectClass *oc, void *data)
 
 static void sh7785_cpu_initfn(Object *obj)
 {
-    SuperHCPU *cpu = SUPERH_CPU(obj);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(CPU(obj));
 
     env->id = SH_CPU_SH7785;
     env->features = SH_FEATURE_SH4A;
@@ -216,8 +212,7 @@ static void superh_cpu_realizefn(DeviceState *dev, Error **errp)
 
 static void superh_cpu_initfn(Object *obj)
 {
-    SuperHCPU *cpu = SUPERH_CPU(obj);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(CPU(obj));
 
     env->movcal_backup_tail = &(env->movcal_backup);
 }
diff --git a/target/sh4/gdbstub.c b/target/sh4/gdbstub.c
index d8e199fc06..75926d4e04 100644
--- a/target/sh4/gdbstub.c
+++ b/target/sh4/gdbstub.c
@@ -26,8 +26,7 @@
 
 int superh_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    SuperHCPU *cpu = SUPERH_CPU(cs);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(cs);
 
     switch (n) {
     case 0 ... 7:
@@ -76,8 +75,7 @@ int superh_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int superh_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    SuperHCPU *cpu = SUPERH_CPU(cs);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(cs);
 
     switch (n) {
     case 0 ... 7:
diff --git a/target/sh4/helper.c b/target/sh4/helper.c
index 5a6f653c12..86857c86f7 100644
--- a/target/sh4/helper.c
+++ b/target/sh4/helper.c
@@ -55,8 +55,7 @@ int cpu_sh4_is_cached(CPUSH4State *env, target_ulong addr)
 
 void superh_cpu_do_interrupt(CPUState *cs)
 {
-    SuperHCPU *cpu = SUPERH_CPU(cs);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(cs);
     int do_irq = cs->interrupt_request & CPU_INTERRUPT_HARD;
     int do_exp, irq_vector = cs->exception_index;
 
@@ -782,8 +781,7 @@ int cpu_sh4_is_cached(CPUSH4State * env, target_ulong addr)
 bool superh_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     if (interrupt_request & CPU_INTERRUPT_HARD) {
-        SuperHCPU *cpu = SUPERH_CPU(cs);
-        CPUSH4State *env = &cpu->env;
+        CPUSH4State *env = cpu_env(cs);
 
         /* Delay slots are indivisible, ignore interrupts */
         if (env->flags & TB_FLAG_DELAY_SLOT_MASK) {
@@ -800,8 +798,7 @@ bool superh_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                          MMUAccessType access_type, int mmu_idx,
                          bool probe, uintptr_t retaddr)
 {
-    SuperHCPU *cpu = SUPERH_CPU(cs);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(cs);
     int ret;
 
     target_ulong physical;
diff --git a/target/sh4/translate.c b/target/sh4/translate.c
index 81f825f125..4a933adad8 100644
--- a/target/sh4/translate.c
+++ b/target/sh4/translate.c
@@ -159,8 +159,7 @@ void sh4_translate_init(void)
 
 void superh_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    SuperHCPU *cpu = SUPERH_CPU(cs);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "pc=0x%08x sr=0x%08x pr=0x%08x fpscr=0x%08x\n",
diff --git a/target/sparc/cpu.c b/target/sparc/cpu.c
index befa7fc4eb..941273e833 100644
--- a/target/sparc/cpu.c
+++ b/target/sparc/cpu.c
@@ -83,8 +83,7 @@ static void sparc_cpu_reset_hold(Object *obj)
 static bool sparc_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     if (interrupt_request & CPU_INTERRUPT_HARD) {
-        SPARCCPU *cpu = SPARC_CPU(cs);
-        CPUSPARCState *env = &cpu->env;
+        CPUSPARCState *env = cpu_env(cs);
 
         if (cpu_interrupts_enabled(env) && env->interrupt_index > 0) {
             int pil = env->interrupt_index & 0xf;
@@ -613,8 +612,7 @@ static void cpu_print_cc(FILE *f, uint32_t cc)
 
 static void sparc_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     int i, x;
 
     qemu_fprintf(f, "pc: " TARGET_FMT_lx "  npc: " TARGET_FMT_lx "\n", env->pc,
@@ -711,8 +709,7 @@ static void sparc_cpu_synchronize_from_tb(CPUState *cs,
 
 static bool sparc_cpu_has_work(CPUState *cs)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
 
     return (cs->interrupt_request & CPU_INTERRUPT_HARD) &&
            cpu_interrupts_enabled(env);
@@ -749,8 +746,7 @@ static void sparc_cpu_realizefn(DeviceState *dev, Error **errp)
     CPUState *cs = CPU(dev);
     SPARCCPUClass *scc = SPARC_CPU_GET_CLASS(dev);
     Error *local_err = NULL;
-    SPARCCPU *cpu = SPARC_CPU(dev);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(CPU(dev));
 
 #if defined(CONFIG_USER_ONLY)
     /* We are emulating the kernel, which will trap and emulate float128. */
diff --git a/target/sparc/gdbstub.c b/target/sparc/gdbstub.c
index a1c8fdc4d5..5257c49a0d 100644
--- a/target/sparc/gdbstub.c
+++ b/target/sparc/gdbstub.c
@@ -29,8 +29,7 @@
 
 int sparc_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
 
     if (n < 8) {
         /* g0..g7 */
diff --git a/target/sparc/int32_helper.c b/target/sparc/int32_helper.c
index 058dd712b5..6b7d65b031 100644
--- a/target/sparc/int32_helper.c
+++ b/target/sparc/int32_helper.c
@@ -99,8 +99,7 @@ void cpu_check_irqs(CPUSPARCState *env)
 
 void sparc_cpu_do_interrupt(CPUState *cs)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     int cwp, intno = cs->exception_index;
 
     if (qemu_loglevel_mask(CPU_LOG_INT)) {
diff --git a/target/sparc/int64_helper.c b/target/sparc/int64_helper.c
index 27df9dba89..bd14c7a0db 100644
--- a/target/sparc/int64_helper.c
+++ b/target/sparc/int64_helper.c
@@ -130,8 +130,7 @@ void cpu_check_irqs(CPUSPARCState *env)
 
 void sparc_cpu_do_interrupt(CPUState *cs)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     int intno = cs->exception_index;
     trap_state *tsptr;
 
diff --git a/target/sparc/ldst_helper.c b/target/sparc/ldst_helper.c
index 09066d5487..203441bfb2 100644
--- a/target/sparc/ldst_helper.c
+++ b/target/sparc/ldst_helper.c
@@ -421,8 +421,7 @@ static void sparc_raise_mmu_fault(CPUState *cs, hwaddr addr,
                                   bool is_write, bool is_exec, int is_asi,
                                   unsigned size, uintptr_t retaddr)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     int fault_type;
 
 #ifdef DEBUG_UNASSIGNED
@@ -483,8 +482,7 @@ static void sparc_raise_mmu_fault(CPUState *cs, hwaddr addr,
                                   bool is_write, bool is_exec, int is_asi,
                                   unsigned size, uintptr_t retaddr)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
 
 #ifdef DEBUG_UNASSIGNED
     printf("Unassigned mem access to " HWADDR_FMT_plx " from " TARGET_FMT_lx
diff --git a/target/sparc/mmu_helper.c b/target/sparc/mmu_helper.c
index 453498c670..a05ee22315 100644
--- a/target/sparc/mmu_helper.c
+++ b/target/sparc/mmu_helper.c
@@ -206,8 +206,7 @@ bool sparc_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                         MMUAccessType access_type, int mmu_idx,
                         bool probe, uintptr_t retaddr)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     CPUTLBEntryFull full = {};
     target_ulong vaddr;
     int error_code = 0, access_index;
@@ -391,8 +390,7 @@ void dump_mmu(CPUSPARCState *env)
 int sparc_cpu_memory_rw_debug(CPUState *cs, vaddr address,
                               uint8_t *buf, int len, bool is_write)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     target_ulong addr = address;
     int i;
     int len1;
@@ -759,8 +757,7 @@ bool sparc_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                         MMUAccessType access_type, int mmu_idx,
                         bool probe, uintptr_t retaddr)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     CPUTLBEntryFull full = {};
     int error_code = 0, access_index;
 
@@ -898,8 +895,7 @@ hwaddr cpu_get_phys_page_nofault(CPUSPARCState *env, target_ulong addr,
 
 hwaddr sparc_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     hwaddr phys_addr;
     int mmu_idx = cpu_mmu_index(env, false);
 
@@ -916,8 +912,7 @@ G_NORETURN void sparc_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                               int mmu_idx,
                                               uintptr_t retaddr)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
 
 #ifdef TARGET_SPARC64
     env->dmmu.sfsr = build_sfsr(env, mmu_idx, access_type);
diff --git a/target/sparc/translate.c b/target/sparc/translate.c
index 9387299559..412b7d1b66 100644
--- a/target/sparc/translate.c
+++ b/target/sparc/translate.c
@@ -5406,8 +5406,7 @@ void sparc_restore_state_to_opc(CPUState *cs,
                                 const TranslationBlock *tb,
                                 const uint64_t *data)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     target_ulong pc = data[0];
     target_ulong npc = data[1];
 
diff --git a/target/tricore/cpu.c b/target/tricore/cpu.c
index 8acacdf0c0..0bbd0271a9 100644
--- a/target/tricore/cpu.c
+++ b/target/tricore/cpu.c
@@ -36,16 +36,14 @@ static const gchar *tricore_gdb_arch_name(CPUState *cs)
 
 static void tricore_cpu_set_pc(CPUState *cs, vaddr value)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
+    CPUTriCoreState *env = cpu_env(cs);
 
     env->PC = value & ~(target_ulong)1;
 }
 
 static vaddr tricore_cpu_get_pc(CPUState *cs)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
+    CPUTriCoreState *env = cpu_env(cs);
 
     return env->PC;
 }
@@ -53,8 +51,7 @@ static vaddr tricore_cpu_get_pc(CPUState *cs)
 static void tricore_cpu_synchronize_from_tb(CPUState *cs,
                                             const TranslationBlock *tb)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
+    CPUTriCoreState *env = cpu_env(cs);
 
     tcg_debug_assert(!(cs->tcg_cflags & CF_PCREL));
     env->PC = tb->pc;
@@ -64,8 +61,7 @@ static void tricore_restore_state_to_opc(CPUState *cs,
                                          const TranslationBlock *tb,
                                          const uint64_t *data)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
+    CPUTriCoreState *env = cpu_env(cs);
 
     env->PC = data[0];
 }
diff --git a/target/tricore/gdbstub.c b/target/tricore/gdbstub.c
index e8f8e5e6ea..f9309c5e27 100644
--- a/target/tricore/gdbstub.c
+++ b/target/tricore/gdbstub.c
@@ -106,8 +106,7 @@ static void tricore_cpu_gdb_write_csfr(CPUTriCoreState *env, int n,
 
 int tricore_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
+    CPUTriCoreState *env = cpu_env(cs);
 
     if (n < 16) { /* data registers */
         return gdb_get_reg32(mem_buf, env->gpr_d[n]);
@@ -121,8 +120,7 @@ int tricore_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int tricore_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
+    CPUTriCoreState *env = cpu_env(cs);
     uint32_t tmp;
 
     tmp = ldl_p(mem_buf);
diff --git a/target/tricore/helper.c b/target/tricore/helper.c
index 174f666e1e..d328414c99 100644
--- a/target/tricore/helper.c
+++ b/target/tricore/helper.c
@@ -67,8 +67,7 @@ bool tricore_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                           MMUAccessType rw, int mmu_idx,
                           bool probe, uintptr_t retaddr)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
+    CPUTriCoreState *env = cpu_env(cs);
     hwaddr physical;
     int prot;
     int ret = 0;
diff --git a/target/tricore/translate.c b/target/tricore/translate.c
index 66553d1be0..ad314bdf3c 100644
--- a/target/tricore/translate.c
+++ b/target/tricore/translate.c
@@ -95,8 +95,7 @@ enum {
 
 void tricore_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
+    CPUTriCoreState *env = cpu_env(cs);
     uint32_t psw;
     int i;
 
diff --git a/target/xtensa/dbg_helper.c b/target/xtensa/dbg_helper.c
index 497dafca71..5546c82ecd 100644
--- a/target/xtensa/dbg_helper.c
+++ b/target/xtensa/dbg_helper.c
@@ -66,8 +66,7 @@ void HELPER(wsr_ibreaka)(CPUXtensaState *env, uint32_t i, uint32_t v)
 
 bool xtensa_debug_check_breakpoint(CPUState *cs)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
     unsigned int i;
 
     if (xtensa_get_cintlevel(env) >= env->config->debug_level) {
diff --git a/target/xtensa/exc_helper.c b/target/xtensa/exc_helper.c
index 168419a505..0514c2c1f3 100644
--- a/target/xtensa/exc_helper.c
+++ b/target/xtensa/exc_helper.c
@@ -205,8 +205,7 @@ static void handle_interrupt(CPUXtensaState *env)
 /* Called from cpu_handle_interrupt with BQL held */
 void xtensa_cpu_do_interrupt(CPUState *cs)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
 
     if (cs->exception_index == EXC_IRQ) {
         qemu_log_mask(CPU_LOG_INT,
diff --git a/target/xtensa/gdbstub.c b/target/xtensa/gdbstub.c
index 4b3bfb7e59..4748fb6532 100644
--- a/target/xtensa/gdbstub.c
+++ b/target/xtensa/gdbstub.c
@@ -65,8 +65,7 @@ void xtensa_count_regs(const XtensaConfig *config,
 
 int xtensa_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
     const XtensaGdbReg *reg = env->config->gdb_regmap.reg + n;
 #ifdef CONFIG_USER_ONLY
     int num_regs = env->config->gdb_regmap.num_core_regs;
@@ -120,8 +119,7 @@ int xtensa_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int xtensa_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
     uint32_t tmp;
     const XtensaGdbReg *reg = env->config->gdb_regmap.reg + n;
 #ifdef CONFIG_USER_ONLY
diff --git a/target/xtensa/helper.c b/target/xtensa/helper.c
index a9f8907083..ca214b948a 100644
--- a/target/xtensa/helper.c
+++ b/target/xtensa/helper.c
@@ -217,8 +217,7 @@ static uint32_t check_hw_breakpoints(CPUXtensaState *env)
 
 void xtensa_breakpoint_handler(CPUState *cs)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
 
     if (cs->watchpoint_hit) {
         if (cs->watchpoint_hit->flags & BP_CPU) {
@@ -266,8 +265,7 @@ bool xtensa_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                          MMUAccessType access_type, int mmu_idx,
                          bool probe, uintptr_t retaddr)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
     uint32_t paddr;
     uint32_t page_size;
     unsigned access;
@@ -297,8 +295,7 @@ void xtensa_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr, vaddr addr,
                                       int mmu_idx, MemTxAttrs attrs,
                                       MemTxResult response, uintptr_t retaddr)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
 
     cpu_restore_state(cs, retaddr);
     HELPER(exception_cause_vaddr)(env, env->pc,
diff --git a/target/xtensa/translate.c b/target/xtensa/translate.c
index 87947236ca..426dcb6169 100644
--- a/target/xtensa/translate.c
+++ b/target/xtensa/translate.c
@@ -1248,8 +1248,7 @@ void gen_intermediate_code(CPUState *cpu, TranslationBlock *tb, int *max_insns,
 
 void xtensa_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
     xtensa_isa isa = env->config->isa;
     int i, j;
 
-- 
2.41.0


