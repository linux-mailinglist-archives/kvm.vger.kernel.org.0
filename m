Return-Path: <kvm+bounces-44272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D27CCA9C19E
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:41:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA167189AEA9
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB892505CB;
	Fri, 25 Apr 2025 08:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="A/QUzZI/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D3724887E;
	Fri, 25 Apr 2025 08:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745570151; cv=none; b=SHNGszp2PJvox07Ii+BPX2CjuR+zAzSG8hrUdqo1Om+Ar1Wdy1wZ4PUxPLOLdmQEfOVw4rOku9VyMzPs1e3Bzw/aqM8OiFOEgWeNU/0gkWLRc6egRxl2+yCThMrhjIpO5qjfwjA5V6bzv9fwsdL0uUWXjdOpAyfHTMy/AFSDwZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745570151; c=relaxed/simple;
	bh=1EuKriBRc8b4ClS3R4hBmzhlZX9EemZKazft8/ds6pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8BBQ3YsX07VapfDSfChTG87Heq6YJKcE589a5MASJUAj0nYj+UsRPflzzYp4+yTPdZOOhmZarty1Iu/RpxitCU7CpIbE2k96Ma66KKkQsR6/5m7RmFFZ0P6QOCFeZxbVSzHUjo4rKTre1BcqWlWkV1WZl+61PuTmjywsPKSTO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=A/QUzZI/; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53P8Yg5a2390085
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 25 Apr 2025 01:35:12 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53P8Yg5a2390085
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745570114;
	bh=dp0os6L/8gGJ7R7+2ig+AT66kaK/KC35t7gKjESvVTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/QUzZI/IjfTqiINbtMDb11WkZZst4x6GucpCvTvL5FudXlQehstDBKpE0ft2emN9
	 tgv8h1RW5ONmdqXtiSRPRiRsATyT7009gur34vQimnYj5Puo+DabCiOwp4wEZdzA7G
	 ldt+fx4dg5AxfnxC4qIz2YKuNymRCtdBSXvPu7uUaQs6yfOXEQOVfR8n9l/+TmCqLJ
	 kRdk9ULSzYw0qbJtS/T/y6xNa0hI4Gy7wXX/zlaOM192A9zxghjzbG3C67A74xq2P8
	 kRuBbkbKwE94lDXhk3sqZxsy3nRUQtv8IBUnUA3Sk1tElESl156mvyN7lle1fI7khV
	 APYtzNj0LIQsA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com,
        dapeng1.mi@linux.intel.com
Subject: [PATCH v3 12/14] x86/pvops/msr: refactor pv_cpu_ops.write_msr{,_safe}()
Date: Fri, 25 Apr 2025 01:34:35 -0700
Message-ID: <20250425083442.2390017-13-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250425083442.2390017-1-xin@zytor.com>
References: <20250425083442.2390017-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An MSR value is represented as a 64-bit unsigned integer, with existing
MSR instructions storing it in EDX:EAX as two 32-bit segments.

The new immediate form MSR instructions, however, utilize a 64-bit
general-purpose register to store the MSR value.  To unify the usage of
all MSR instructions, let the default MSR access APIs accept an MSR
value as a single 64-bit argument instead of two 32-bit segments.

The dual 32-bit APIs are still available as convenient wrappers over the
APIs that handle an MSR value as a single 64-bit argument.

The following illustrates the updated derivation of the MSR write APIs:

                 __wrmsrq(u32 msr, u64 val)
                   /                  \
                  /                    \
           native_wrmsrq(msr, val)    native_wrmsr(msr, low, high)
                 |
                 |
           native_write_msr(msr, val)
                /          \
               /            \
       wrmsrq(msr, val)    wrmsr(msr, low, high)

When CONFIG_PARAVIRT is enabled, wrmsrq() and wrmsr() are defined on top
of paravirt_write_msr():

            paravirt_write_msr(u32 msr, u64 val)
               /             \
              /               \
          wrmsrq(msr, val)    wrmsr(msr, low, high)

paravirt_write_msr() invokes cpu.write_msr(msr, val), an indirect layer
of pv_ops MSR write call:

    If on native:

            cpu.write_msr = native_write_msr

    If on Xen:

            cpu.write_msr = xen_write_msr

Therefore, refactor pv_cpu_ops.write_msr{_safe}() to accept an MSR value
in a single u64 argument, replacing the current dual u32 arguments.

No functional change intended.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
---

Change in v2:
* Spell out the reason why use a single u64 argument to pass the MSR
  value in the lowest level APIs (Andrew Cooper).
---
 arch/x86/include/asm/msr.h            | 35 ++++++++++++---------------
 arch/x86/include/asm/paravirt.h       | 27 +++++++++++----------
 arch/x86/include/asm/paravirt_types.h |  4 +--
 arch/x86/kernel/kvmclock.c            |  2 +-
 arch/x86/kvm/svm/svm.c                | 15 +++---------
 arch/x86/xen/enlighten_pv.c           | 30 +++++++++--------------
 6 files changed, 46 insertions(+), 67 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 7b9713a49d59..0392b9596107 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -92,12 +92,12 @@ static __always_inline u64 __rdmsr(u32 msr)
 	return EAX_EDX_VAL(val, low, high);
 }
 
-static __always_inline void __wrmsr(u32 msr, u32 low, u32 high)
+static __always_inline void __wrmsrq(u32 msr, u64 val)
 {
 	asm volatile("1: wrmsr\n"
 		     "2:\n"
 		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_WRMSR)
-		     : : "c" (msr), "a"(low), "d" (high) : "memory");
+		     : : "c" (msr), "a" ((u32)val), "d" ((u32)(val >> 32)) : "memory");
 }
 
 #define native_rdmsr(msr, val1, val2)			\
@@ -113,11 +113,10 @@ static __always_inline u64 native_rdmsrq(u32 msr)
 }
 
 #define native_wrmsr(msr, low, high)			\
-	__wrmsr(msr, low, high)
+	__wrmsrq((msr), (u64)(high) << 32 | (low))
 
 #define native_wrmsrq(msr, val)				\
-	__wrmsr((msr), (u32)((u64)(val)),		\
-		       (u32)((u64)(val) >> 32))
+	__wrmsrq((msr), (val))
 
 static inline u64 native_read_msr(u32 msr)
 {
@@ -146,11 +145,8 @@ static inline u64 native_read_msr_safe(u32 msr, int *err)
 }
 
 /* Can be uninlined because referenced by paravirt */
-static inline void notrace
-native_write_msr(u32 msr, u32 low, u32 high)
+static inline void notrace native_write_msr(u32 msr, u64 val)
 {
-	u64 val = (u64)high << 32 | low;
-
 	native_wrmsrq(msr, val);
 
 	if (tracepoint_enabled(write_msr))
@@ -158,8 +154,7 @@ native_write_msr(u32 msr, u32 low, u32 high)
 }
 
 /* Can be uninlined because referenced by paravirt */
-static inline int notrace
-native_write_msr_safe(u32 msr, u32 low, u32 high)
+static inline int notrace native_write_msr_safe(u32 msr, u64 val)
 {
 	int err;
 
@@ -167,10 +162,10 @@ native_write_msr_safe(u32 msr, u32 low, u32 high)
 		     "2:\n\t"
 		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_WRMSR_SAFE, %[err])
 		     : [err] "=a" (err)
-		     : "c" (msr), "0" (low), "d" (high)
+		     : "c" (msr), "0" ((u32)val), "d" ((u32)(val >> 32))
 		     : "memory");
 	if (tracepoint_enabled(write_msr))
-		do_trace_write_msr(msr, ((u64)high << 32 | low), err);
+		do_trace_write_msr(msr, val, err);
 	return err;
 }
 
@@ -206,7 +201,7 @@ do {								\
 
 static inline void wrmsr(u32 msr, u32 low, u32 high)
 {
-	native_write_msr(msr, low, high);
+	native_write_msr(msr, (u64)high << 32 | low);
 }
 
 #define rdmsrq(msr, val)			\
@@ -214,13 +209,13 @@ static inline void wrmsr(u32 msr, u32 low, u32 high)
 
 static inline void wrmsrq(u32 msr, u64 val)
 {
-	native_write_msr(msr, (u32)(val & 0xffffffffULL), (u32)(val >> 32));
+	native_write_msr(msr, val);
 }
 
 /* wrmsr with exception handling */
-static inline int wrmsr_safe(u32 msr, u32 low, u32 high)
+static inline int wrmsrq_safe(u32 msr, u64 val)
 {
-	return native_write_msr_safe(msr, low, high);
+	return native_write_msr_safe(msr, val);
 }
 
 /* rdmsr with exception handling */
@@ -264,11 +259,11 @@ static __always_inline void wrmsrns(u32 msr, u64 val)
 }
 
 /*
- * 64-bit version of wrmsr_safe():
+ * Dual u32 version of wrmsrq_safe():
  */
-static inline int wrmsrq_safe(u32 msr, u64 val)
+static inline int wrmsr_safe(u32 msr, u32 low, u32 high)
 {
-	return wrmsr_safe(msr, (u32)val,  (u32)(val >> 32));
+	return wrmsrq_safe(msr, (u64)high << 32 | low);
 }
 
 struct msr __percpu *msrs_alloc(void);
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index f272c4bd3d5b..edf23bde367e 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -180,10 +180,9 @@ static inline u64 paravirt_read_msr(unsigned msr)
 	return PVOP_CALL1(u64, cpu.read_msr, msr);
 }
 
-static inline void paravirt_write_msr(unsigned msr,
-				      unsigned low, unsigned high)
+static inline void paravirt_write_msr(u32 msr, u64 val)
 {
-	PVOP_VCALL3(cpu.write_msr, msr, low, high);
+	PVOP_VCALL2(cpu.write_msr, msr, val);
 }
 
 static inline u64 paravirt_read_msr_safe(unsigned msr, int *err)
@@ -191,10 +190,9 @@ static inline u64 paravirt_read_msr_safe(unsigned msr, int *err)
 	return PVOP_CALL2(u64, cpu.read_msr_safe, msr, err);
 }
 
-static inline int paravirt_write_msr_safe(unsigned msr,
-					  unsigned low, unsigned high)
+static inline int paravirt_write_msr_safe(u32 msr, u64 val)
 {
-	return PVOP_CALL3(int, cpu.write_msr_safe, msr, low, high);
+	return PVOP_CALL2(int, cpu.write_msr_safe, msr, val);
 }
 
 #define rdmsr(msr, val1, val2)			\
@@ -204,22 +202,25 @@ do {						\
 	val2 = _l >> 32;			\
 } while (0)
 
-#define wrmsr(msr, val1, val2)			\
-do {						\
-	paravirt_write_msr(msr, val1, val2);	\
-} while (0)
+static __always_inline void wrmsr(u32 msr, u32 low, u32 high)
+{
+	paravirt_write_msr(msr, (u64)high << 32 | low);
+}
 
 #define rdmsrq(msr, val)			\
 do {						\
 	val = paravirt_read_msr(msr);		\
 } while (0)
 
-static inline void wrmsrq(unsigned msr, u64 val)
+static inline void wrmsrq(u32 msr, u64 val)
 {
-	wrmsr(msr, (u32)val, (u32)(val>>32));
+	paravirt_write_msr(msr, val);
 }
 
-#define wrmsr_safe(msr, a, b)	paravirt_write_msr_safe(msr, a, b)
+static inline int wrmsrq_safe(u32 msr, u64 val)
+{
+	return paravirt_write_msr_safe(msr, val);
+}
 
 /* rdmsr with exception handling */
 #define rdmsr_safe(msr, a, b)				\
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 631c306ce1ff..78777b78da12 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -92,14 +92,14 @@ struct pv_cpu_ops {
 
 	/* Unsafe MSR operations.  These will warn or panic on failure. */
 	u64 (*read_msr)(unsigned int msr);
-	void (*write_msr)(unsigned int msr, unsigned low, unsigned high);
+	void (*write_msr)(u32 msr, u64 val);
 
 	/*
 	 * Safe MSR operations.
 	 * read sets err to 0 or -EIO.  write returns 0 or -EIO.
 	 */
 	u64 (*read_msr_safe)(unsigned int msr, int *err);
-	int (*write_msr_safe)(unsigned int msr, unsigned low, unsigned high);
+	int (*write_msr_safe)(u32 msr, u64 val);
 
 	u64 (*read_pmc)(int counter);
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 0af797930ccb..ca0a49eeac4a 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -196,7 +196,7 @@ static void kvm_setup_secondary_clock(void)
 void kvmclock_disable(void)
 {
 	if (msr_kvm_system_time)
-		native_write_msr(msr_kvm_system_time, 0, 0);
+		native_write_msr(msr_kvm_system_time, 0);
 }
 
 static void __init kvmclock_init_mem(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 67657b3a36ce..4ef9978dce70 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -475,7 +475,6 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
 
 static void svm_init_erratum_383(void)
 {
-	u32 low, high;
 	int err;
 	u64 val;
 
@@ -489,10 +488,7 @@ static void svm_init_erratum_383(void)
 
 	val |= (1ULL << 47);
 
-	low  = lower_32_bits(val);
-	high = upper_32_bits(val);
-
-	native_write_msr_safe(MSR_AMD64_DC_CFG, low, high);
+	native_write_msr_safe(MSR_AMD64_DC_CFG, val);
 
 	erratum_383_found = true;
 }
@@ -2167,17 +2163,12 @@ static bool is_erratum_383(void)
 
 	/* Clear MCi_STATUS registers */
 	for (i = 0; i < 6; ++i)
-		native_write_msr_safe(MSR_IA32_MCx_STATUS(i), 0, 0);
+		native_write_msr_safe(MSR_IA32_MCx_STATUS(i), 0);
 
 	value = native_read_msr_safe(MSR_IA32_MCG_STATUS, &err);
 	if (!err) {
-		u32 low, high;
-
 		value &= ~(1ULL << 2);
-		low    = lower_32_bits(value);
-		high   = upper_32_bits(value);
-
-		native_write_msr_safe(MSR_IA32_MCG_STATUS, low, high);
+		native_write_msr_safe(MSR_IA32_MCG_STATUS, value);
 	}
 
 	/* Flush tlb to evict multi-match entries */
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index c247e7689bc3..c067d1e8a39c 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1110,10 +1110,8 @@ static u64 xen_do_read_msr(unsigned int msr, int *err)
 	return val;
 }
 
-static void set_seg(u32 which, u32 low, u32 high)
+static void set_seg(u32 which, u64 base)
 {
-	u64 base = ((u64)high << 32) | low;
-
 	if (HYPERVISOR_set_segment_base(which, base))
 		WARN(1, "Xen set_segment_base(%u, %llx) failed\n", which, base);
 }
@@ -1123,22 +1121,19 @@ static void set_seg(u32 which, u32 low, u32 high)
  * With err == NULL write_msr() semantics are selected.
  * Supplying an err pointer requires err to be pre-initialized with 0.
  */
-static void xen_do_write_msr(unsigned int msr, unsigned int low,
-			     unsigned int high, int *err)
+static void xen_do_write_msr(u32 msr, u64 val, int *err)
 {
-	u64 val;
-
 	switch (msr) {
 	case MSR_FS_BASE:
-		set_seg(SEGBASE_FS, low, high);
+		set_seg(SEGBASE_FS, val);
 		break;
 
 	case MSR_KERNEL_GS_BASE:
-		set_seg(SEGBASE_GS_USER, low, high);
+		set_seg(SEGBASE_GS_USER, val);
 		break;
 
 	case MSR_GS_BASE:
-		set_seg(SEGBASE_GS_KERNEL, low, high);
+		set_seg(SEGBASE_GS_KERNEL, val);
 		break;
 
 	case MSR_STAR:
@@ -1154,15 +1149,13 @@ static void xen_do_write_msr(unsigned int msr, unsigned int low,
 		break;
 
 	default:
-		val = (u64)high << 32 | low;
-
 		if (pmu_msr_chk_emulated(msr, &val, false))
 			return;
 
 		if (err)
-			*err = native_write_msr_safe(msr, low, high);
+			*err = native_write_msr_safe(msr, val);
 		else
-			native_write_msr(msr, low, high);
+			native_write_msr(msr, val);
 	}
 }
 
@@ -1171,12 +1164,11 @@ static u64 xen_read_msr_safe(unsigned int msr, int *err)
 	return xen_do_read_msr(msr, err);
 }
 
-static int xen_write_msr_safe(unsigned int msr, unsigned int low,
-			      unsigned int high)
+static int xen_write_msr_safe(u32 msr, u64 val)
 {
 	int err = 0;
 
-	xen_do_write_msr(msr, low, high, &err);
+	xen_do_write_msr(msr, val, &err);
 
 	return err;
 }
@@ -1188,11 +1180,11 @@ static u64 xen_read_msr(unsigned int msr)
 	return xen_do_read_msr(msr, xen_msr_safe ? &err : NULL);
 }
 
-static void xen_write_msr(unsigned int msr, unsigned low, unsigned high)
+static void xen_write_msr(u32 msr, u64 val)
 {
 	int err;
 
-	xen_do_write_msr(msr, low, high, xen_msr_safe ? &err : NULL);
+	xen_do_write_msr(msr, val, xen_msr_safe ? &err : NULL);
 }
 
 /* This is called once we have the cpu_possible_mask */
-- 
2.49.0


