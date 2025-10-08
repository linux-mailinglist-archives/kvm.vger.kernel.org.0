Return-Path: <kvm+bounces-59621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C88B4BC344B
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 06:07:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BA95189A564
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 04:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2AA52BD5B4;
	Wed,  8 Oct 2025 04:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BulLWwTs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E56114A60C
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 04:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759896452; cv=none; b=RJ6NC7jRp+hZawJl97l4maiHYE8gq/gvV2dmDiPzfAQEy2+sYNnnQ2mLd5BdBth9fggbK7J23ZawuvhJoORGfoUhkjcIVyojU/nmN2n25ouyB8EFYxvoZ7nb04DaUGWSB3LjscQUPChlt4RTMlla+KqU5g+jLgSkPV7SlfjRL8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759896452; c=relaxed/simple;
	bh=H8gBAspog+rvYkrK39gQESc/qqPLfnYnUKfwDX7JSUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CYjYNIwKUJg/1tDxKQsenGWZWSmKuWsDm1PnD8g4ayaPe3ojDLvhVd8YMrsEAyIBXC4E/7RQ3BJ6pudvrX28ftwEDNHYJpnpm9BraeVeelH1G4JpPqKWE7ii09llphfxLFc8HxNPet+1vHTF9j0Q+btgiTb76w24N3P/HlskkRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BulLWwTs; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3f2ae6fadb4so1880881f8f.1
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 21:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759896448; x=1760501248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=38kffkV2lErlC3uVWR4z9asPuoou/DTgCFhX2fGUa90=;
        b=BulLWwTskn8p5QbgIIv7yOTQtFQenkUXYu1FkyjdEzrQ+e/wxM6JhG9qZZud5fS/zE
         4gW9Zfa3PA3TDGhjrUqUmXbCMo3s0c9rQ+Kro5Gj7fLOaW2XiMfmLN5OtdanbCr2FpNg
         X3CCNqhd1szymj8h8/E1LeHa/eltU1dEOtLkt5wZhx9FwITMMVensB/UMgkvI8aKQzQH
         +suoFLxZwIiIiNaAc58Q8ImOQxLBATvzwGAsOQuttmVpQnKs7dvwIv6LvhJgNV018C/S
         eywFLSrmJ6hoPL9j8KrWp3qhPvNma3BUvqjEdkHrI55zse8RjK4QFXjeRSC4jyPXd/8f
         lAjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759896448; x=1760501248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=38kffkV2lErlC3uVWR4z9asPuoou/DTgCFhX2fGUa90=;
        b=jgC4aWHmKw9JZI5auaHueUgWZC6BdMYie7Abo0WY6Jqyielxdz62hPR6t0oDPgAH/H
         KY/jGtBfnpAPl2TiPgR/FgEfyn7SQ2Gcq23vGSIWoQFIza2Ir23jzE7iqGFKMzKWueYW
         Rnt6uk4OLiCPFigrZAyAqY2iK2JQyn69C6uxHVEZIVj1sk1TVCFSCgm55zzoC4K3CNlF
         oTWyu3VdRzFHXp5y6DZ8D0dFXRIsWOcW2d2ed8KxD64KrE+SAg4zQxTVnlte8T8p1DfA
         51Uw4K/KFDKGLxNx4T0ENXctjDvfYREewabcd0jP4C8rZ+Aq3G07uYc/SuTH3OcKV6RP
         /OeQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7eBh15F6ACMuKGXXR29+HpBzgxqYjRf4z4WNddgaEVsXhNuzDjrwAZ6D5VKIR6XrCsYk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmpqw3otF9aZfUo+ne9d0ZmdDOVMIBSjJ1UJERHqfSmdQI4J23
	eVKvPgmME+RYlHilqN7gX0aaxyqu63ZqykyZLQ3zgNBuphBjQo8iD5X+yD73Gm9BJHg=
X-Gm-Gg: ASbGncvoa7vGJxcMA7KCoRcOwElEdgt9L8SPJEiIDkUVhg24espnlaAZQmlnlHEifge
	npeg/lGLT3TUXh2SuUTbUW+NL/XvERvvs1pR/fSgbjKQD+GJ1XjxmG4TfbkkaeJK03xlRDMAh0w
	wMkkoGpZYK0hGNLNzGP3tT8LIUbyELqdVNOoUQTGDBzOKjy/dbkU6A61mJYtyWSleKG8QNZvRdJ
	URbEPNy9a10e8cw5vDnMqC8ffNQWLEmH+338luMwZWbVTOvh5xyHk93+ckoaq+1vJmJOuNzWGq/
	84lPTSp1A2EV+z2ytSouw0ax6cHr6FsdaqgNRuzbVt26QfMC1RuIXPcxyC5UyIQc535MeGuntgV
	rUmsfuUTiUCw15u9z3nZylJYGQyVEAejyWr0SogwlyEOvCDUt8nTIam+d0YYudegf40RIwl21hs
	05TU07UDPbCZtRPX8rmi9Qdv5m
X-Google-Smtp-Source: AGHT+IEjireXPYDFN5r5KL8SDKpNkPNM5DCX9kjzg8yEWglxLdmj8M2IlvqnxmQ39KU5FQlqPqmuOg==
X-Received: by 2002:a05:6000:2c0c:b0:3e0:a5a2:ec9b with SMTP id ffacd0b85a97d-4266e8dd3b6mr1013001f8f.52.1759896448280;
        Tue, 07 Oct 2025 21:07:28 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8ab8fdsm27584189f8f.15.2025.10.07.21.07.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Oct 2025 21:07:27 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org,
	kvm@vger.kernel.org,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-s390x@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Song Gao <gaosong@loongson.cn>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 2/3] accel/kvm: Introduce KvmPutState enum
Date: Wed,  8 Oct 2025 06:07:13 +0200
Message-ID: <20251008040715.81513-3-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251008040715.81513-1-philmd@linaro.org>
References: <20251008040715.81513-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Join the 3 KVM_PUT_*_STATE definitions in a single enum.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
---
 include/system/kvm.h       | 16 +++++++++-------
 target/i386/kvm/kvm.c      |  6 +++---
 target/loongarch/kvm/kvm.c |  4 ++--
 target/mips/kvm.c          |  6 +++---
 target/ppc/kvm.c           |  2 +-
 target/riscv/kvm/kvm-cpu.c |  2 +-
 target/s390x/kvm/kvm.c     |  2 +-
 7 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/system/kvm.h b/include/system/kvm.h
index 4fc09e38910..8f9eecf044c 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -340,14 +340,16 @@ int kvm_arch_process_async_events(CPUState *cpu);
 
 int kvm_arch_get_registers(CPUState *cpu, Error **errp);
 
-/* state subset only touched by the VCPU itself during runtime */
-#define KVM_PUT_RUNTIME_STATE   1
-/* state subset modified during VCPU reset */
-#define KVM_PUT_RESET_STATE     2
-/* full state set, modified during initialization or on vmload */
-#define KVM_PUT_FULL_STATE      3
+typedef enum kvm_put_state {
+    /* state subset only touched by the VCPU itself during runtime */
+    KVM_PUT_RUNTIME_STATE = 1,
+    /* state subset modified during VCPU reset */
+    KVM_PUT_RESET_STATE = 2,
+    /* full state set, modified during initialization or on vmload */
+    KVM_PUT_FULL_STATE = 3,
+} KvmPutState;
 
-int kvm_arch_put_registers(CPUState *cpu, int level, Error **errp);
+int kvm_arch_put_registers(CPUState *cpu, KvmPutState level, Error **errp);
 
 int kvm_arch_get_default_type(MachineState *ms);
 
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6a3a1c1ed8e..d06f55938cd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3911,7 +3911,7 @@ static void kvm_init_msrs(X86CPU *cpu)
     assert(kvm_buf_set_msrs(cpu) == 0);
 }
 
-static int kvm_put_msrs(X86CPU *cpu, int level)
+static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
 {
     CPUX86State *env = &cpu->env;
     int i;
@@ -5031,7 +5031,7 @@ static int kvm_get_apic(X86CPU *cpu)
     return 0;
 }
 
-static int kvm_put_vcpu_events(X86CPU *cpu, int level)
+static int kvm_put_vcpu_events(X86CPU *cpu, KvmPutState level)
 {
     CPUState *cs = CPU(cpu);
     CPUX86State *env = &cpu->env;
@@ -5274,7 +5274,7 @@ static int kvm_get_nested_state(X86CPU *cpu)
     return ret;
 }
 
-int kvm_arch_put_registers(CPUState *cpu, int level, Error **errp)
+int kvm_arch_put_registers(CPUState *cpu, KvmPutState level, Error **errp)
 {
     X86CPU *x86_cpu = X86_CPU(cpu);
     int ret;
diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
index 45292edcb1c..32cd7c5d003 100644
--- a/target/loongarch/kvm/kvm.c
+++ b/target/loongarch/kvm/kvm.c
@@ -325,7 +325,7 @@ static int kvm_loongarch_get_csr(CPUState *cs)
     return ret;
 }
 
-static int kvm_loongarch_put_csr(CPUState *cs, int level)
+static int kvm_loongarch_put_csr(CPUState *cs, KvmPutState level)
 {
     int ret = 0;
     CPULoongArchState *env = cpu_env(cs);
@@ -763,7 +763,7 @@ int kvm_arch_get_registers(CPUState *cs, Error **errp)
     return ret;
 }
 
-int kvm_arch_put_registers(CPUState *cs, int level, Error **errp)
+int kvm_arch_put_registers(CPUState *cs, KvmPutState level, Error **errp)
 {
     int ret;
     static int once;
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index 450947c3fa5..912cd5dfa0e 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -590,7 +590,7 @@ static void kvm_mips_update_state(void *opaque, bool running, RunState state)
     }
 }
 
-static int kvm_mips_put_fpu_registers(CPUState *cs, int level)
+static int kvm_mips_put_fpu_registers(CPUState *cs, KvmPutState level)
 {
     CPUMIPSState *env = cpu_env(cs);
     int err, ret = 0;
@@ -749,7 +749,7 @@ static int kvm_mips_get_fpu_registers(CPUState *cs)
 }
 
 
-static int kvm_mips_put_cp0_registers(CPUState *cs, int level)
+static int kvm_mips_put_cp0_registers(CPUState *cs, KvmPutState level)
 {
     CPUMIPSState *env = cpu_env(cs);
     int err, ret = 0;
@@ -1177,7 +1177,7 @@ static int kvm_mips_get_cp0_registers(CPUState *cs)
     return ret;
 }
 
-int kvm_arch_put_registers(CPUState *cs, int level, Error **errp)
+int kvm_arch_put_registers(CPUState *cs, KvmPutState level, Error **errp)
 {
     CPUMIPSState *env = cpu_env(cs);
     struct kvm_regs regs;
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 2521ff65c6c..cd60893a17d 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -907,7 +907,7 @@ int kvmppc_put_books_sregs(PowerPCCPU *cpu)
     return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_SREGS, &sregs);
 }
 
-int kvm_arch_put_registers(CPUState *cs, int level, Error **errp)
+int kvm_arch_put_registers(CPUState *cs, KvmPutState level, Error **errp)
 {
     PowerPCCPU *cpu = POWERPC_CPU(cs);
     CPUPPCState *env = &cpu->env;
diff --git a/target/riscv/kvm/kvm-cpu.c b/target/riscv/kvm/kvm-cpu.c
index 187c2c9501e..75ca3fb9fd9 100644
--- a/target/riscv/kvm/kvm-cpu.c
+++ b/target/riscv/kvm/kvm-cpu.c
@@ -1369,7 +1369,7 @@ int kvm_riscv_sync_mpstate_to_kvm(RISCVCPU *cpu, int state)
     return 0;
 }
 
-int kvm_arch_put_registers(CPUState *cs, int level, Error **errp)
+int kvm_arch_put_registers(CPUState *cs, KvmPutState level, Error **errp)
 {
     int ret = 0;
 
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 491cc5f9756..916dac1f14e 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -468,7 +468,7 @@ static int can_sync_regs(CPUState *cs, int regs)
 #define KVM_SYNC_REQUIRED_REGS (KVM_SYNC_GPRS | KVM_SYNC_ACRS | \
                                 KVM_SYNC_CRS | KVM_SYNC_PREFIX)
 
-int kvm_arch_put_registers(CPUState *cs, int level, Error **errp)
+int kvm_arch_put_registers(CPUState *cs, KvmPutState level, Error **errp)
 {
     CPUS390XState *env = cpu_env(cs);
     struct kvm_fpu fpu = {};
-- 
2.51.0


