Return-Path: <kvm+bounces-59564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 281D3BC096F
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 10:16:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D100D4E249B
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 08:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB022253EF;
	Tue,  7 Oct 2025 08:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CixFgN+5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9384928031D
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 08:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759824993; cv=none; b=TBxQLmxosHxNhhK+mca7XlJkljnUP9nNW1JSCFtGiEH1+yFr0JRt9byewsJOXzZGUmMFOjwu64NEx0i8fhU4EEFijcT+4iKNxhFr0Y/88TXB+K+Dm6xTuK7tMBhV3StUOoRT90SJtY+hHc4eH6MCcarcbwcCRan0ZO9VeBhTk7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759824993; c=relaxed/simple;
	bh=Fyz9IVERp+URoE2h7PJNR5Cjc6TxIQ/gP93kV7HEo/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bFQIudAmR7zMdZLxvzORKFOoovgHFIprl3VHG81MRwII3ZScEkuknI+QgcM9I7u3zM8UDYbieSnB6PUeU6ndf5o8zTTyxNi3TYL7amAqwunTN8cwfHXjcpiY7Nbhd/2VGEHUVwL05ku3gkuTK95rXmWH07Ws6IRvhvugb1udj+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CixFgN+5; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46e61ebddd6so55306745e9.0
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 01:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759824990; x=1760429790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PSS/vO/urkPdDooJB2oeDa3yztjhJ4DM7WnJ6N8yGds=;
        b=CixFgN+5ikkCHLETc+qQdzF8GuSReS3YAqbNO+8AoeRnkGTqA0rs5NjlJhULWcVMik
         ufZnYWfTzPpd73Oedwgb/P2DQoBp21YwPeX2gTae8Y4ZYiwjsFsZh8dnVvxsJWdkHqlB
         elY/uFmcTWbO+segqmEw87OsV7YoWXOF5YB4fPYFQJURP3i6MXeHWLl37wxTygTU0Xi+
         5rEbNSx4VBFMwtYzTGDvagPci3LC6cjW5X5fFTgvu+1p28gEFNI1SaDVB2vxq/UY7GAk
         aaH6YO8YKyST1vvON/CMZPqUTvEfm4ESPl56Mc75w4qu6GUS2lMrbOl7uqlNF7/h2G7X
         Xp3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759824990; x=1760429790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PSS/vO/urkPdDooJB2oeDa3yztjhJ4DM7WnJ6N8yGds=;
        b=MWtObraH31oL1P2dVhmq7gCUCBce71xeGIRl/CVEH0uNWX6DVa7WAzxhY6eZxJvkfg
         SfGo1HsNM5q8taUe8/Ygu83ryziE1CPkT72cEufjQILCEp46YU7Z6IcwR0FgXLVnaYuy
         gm1t7S3qhxjBTqMu1cQWB3KH/I1kcT9HU/pUxskwA0NqPmLePnrsv0OmljXg0f3dBY7i
         kam3DjQy5qEKODU3ZQ99Fmx1jppeui/OXXCZPOxTWWjrwGWHizsHmUpRQcRa8lKENeXf
         qN6u0RyQe22JufNQpZwqEDasY1aV3eI/gddLlDGtC/Ta9/Ku5YEVd5k5Y/PehOnA0XWc
         6ryQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/p+6YvNU3j7VIW8+9S54i5jAcEkTQQSpw2MY5uJc3NCwkjaRT+OzaEkXduwgrrJ7KKsM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGZD/OOy6+4lcDu3H8+aPgzICUtY0DvAFzeIRcVLBMxAtBpcwi
	ScMpB87tXmhUACwRsHEZyr51fIBsg5TIzpv9+tfJVGEuH1CHfwdz+HF5IDnh6Z/PuEE=
X-Gm-Gg: ASbGncsQqPfy7EoruDeREsLGfYnewnmmv+T20TxinchMaEsaDn2yHLFTbKPRaGt83Et
	KgoR3JJjS8pXzkkei3i0rYmPcZYtD7qk5oEUH6TFjqMLJIUGEPHMj701wQ8dqKcbchQR19v7W1y
	dnGBk7pj3kHfJqwgsjPHxtz9jXX2CUDb0nyhmt+LWfyn7uwo0Uyg1YDqSC+Do8T6njXEuy3jbGj
	SwJdbKWKepjUdfI6Gb7pwxPAfLqSFZC2W+fX/ijbLhoiYWPDouaXYfHsHk9sKuA67L5tUCYgWmu
	H39XOLe7jL42LeOqupIYZVwAIUg4YS3Rp1Xp54X5M6/2CMchMkIKXvcYpu6DuzF1W5DTQueOgOu
	YF4j9aYG2GnmRcbd1TISEqC5qv8ZIwJ1Jv8EyORyL61kuybhmQgwORBwT6OavSEzfEygC9j5Z7s
	BDpTPpKoyzQ8xnJvWX7Bzhmpyk
X-Google-Smtp-Source: AGHT+IGRA6KPyvhxXtzYnOvTFtl5YLGs1n5NMaDQ4KBPLj2KKkceTTHa9sfY0JuyGZTIHGBzptzjJA==
X-Received: by 2002:a05:6000:609:b0:401:70eb:eec7 with SMTP id ffacd0b85a97d-425671bc76amr9419782f8f.43.1759824989839;
        Tue, 07 Oct 2025 01:16:29 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e97f0sm24090022f8f.27.2025.10.07.01.16.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Oct 2025 01:16:29 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Weiwei Li <liwei1518@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	qemu-s390x@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	Aurelien Jarno <aurelien@aurel32.net>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	qemu-riscv@nongnu.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 2/3] accel/kvm: Introduce KvmPutState enum
Date: Tue,  7 Oct 2025 10:16:15 +0200
Message-ID: <20251007081616.68442-3-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251007081616.68442-1-philmd@linaro.org>
References: <20251007081616.68442-1-philmd@linaro.org>
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


