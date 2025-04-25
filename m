Return-Path: <kvm+bounces-44273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E1D9A9C1A7
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C97334C314A
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E64F2522B4;
	Fri, 25 Apr 2025 08:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="f0nyTqFF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9596024BD04;
	Fri, 25 Apr 2025 08:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745570152; cv=none; b=oFvzlDva33YeQs1ZUtDMCmCUyNyPnjQ80Ha6xPqjIM2hKs54r7gvLwY4Vt01DMzHchl4cOgL6CbqCpGY3TzyMrttzmDzKXYKj+CWS3Bl4QtlkdXUD9wSw7b3cikSBAQoYsKhNc2521jn0HfR4dS4QF6sGsP8HGoIBHebDU2ZbFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745570152; c=relaxed/simple;
	bh=08js4cQ/tImzBbVAnRy9C56aMzYPY9aXKTSZAA+hU0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m53XFDggppMOVUfAIf7Auu4eoiksKorET0Ih0xl7SzfzJ3UB/9pUC5YbExMCBJcE7W1QPW3pnHj9kfGHq0Vq8/vY16FCGhcX2VmfvQxuhBFuTUOOKCZ2/TYeRV68keegMHiM02AGcoYF1GlUJfSJkc9b3BwQJWe8TnIpSNzJzb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=f0nyTqFF; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53P8Yg5c2390085
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 25 Apr 2025 01:35:16 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53P8Yg5c2390085
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745570118;
	bh=PGgDVUVp5WEsZGmkrE1cE9ZmxybTvIy441YCsSnZyG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0nyTqFFxoNNT5zdxXz0wAG2oDnQQHR2TITjrl4/WZHGQrZGNiF1OZYbax0C2iuIx
	 CH2XXrL5uYNMptan27zhYOojgtxgK72O5RWOTmV95xgIIpIT3kSr62AOOXra9uRF6E
	 kTbsurThw7Iy4DVFR1xhvN89VcU9gmp1/l4hhWaLt3TSW9XbKcovRa9h+mP/NfqMQv
	 Pry2fZZ/3lQkv2R/rt1kUSU/HD8Pxr3Y+EPze/8OS2f48IUTb7v1i2RJSfxC9aW9TR
	 2obaMyl6yz37n/hRq5aMI5eGmJZogK/gHDlJVsHJ/MBZRP2hgoN7z0zm+fw0egbklR
	 7ZKW0NW9geX6g==
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
Subject: [PATCH v3 14/14] x86/msr: Change the function type of native_read_msr_safe()
Date: Fri, 25 Apr 2025 01:34:37 -0700
Message-ID: <20250425083442.2390017-15-xin@zytor.com>
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

Modify the function type of native_read_msr_safe() to:

    int native_read_msr_safe(u32 msr, u64 *val)

This change makes the function return an error code instead of the
MSR value, aligning it with the type of native_write_msr_safe().
Consequently, their callers can check the results in the same way.

While at it, convert leftover MSR data type "unsigned int" to u32.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/msr.h            | 21 +++++++++++----------
 arch/x86/include/asm/paravirt.h       | 19 ++++++++-----------
 arch/x86/include/asm/paravirt_types.h |  6 +++---
 arch/x86/kvm/svm/svm.c                | 19 +++++++------------
 arch/x86/xen/enlighten_pv.c           | 13 ++++++++-----
 arch/x86/xen/pmu.c                    | 14 ++++++++------
 6 files changed, 45 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 0392b9596107..e7ee51ccd82e 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -130,18 +130,22 @@ static inline u64 native_read_msr(u32 msr)
 	return val;
 }
 
-static inline u64 native_read_msr_safe(u32 msr, int *err)
+static inline int native_read_msr_safe(u32 msr, u64 *p)
 {
+	int err;
 	DECLARE_ARGS(val, low, high);
 
 	asm volatile("1: rdmsr ; xor %[err],%[err]\n"
 		     "2:\n\t"
 		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_RDMSR_SAFE, %[err])
-		     : [err] "=r" (*err), EAX_EDX_RET(val, low, high)
+		     : [err] "=r" (err), EAX_EDX_RET(val, low, high)
 		     : "c" (msr));
 	if (tracepoint_enabled(read_msr))
-		do_trace_read_msr(msr, EAX_EDX_VAL(val, low, high), *err);
-	return EAX_EDX_VAL(val, low, high);
+		do_trace_read_msr(msr, EAX_EDX_VAL(val, low, high), err);
+
+	*p = EAX_EDX_VAL(val, low, high);
+
+	return err;
 }
 
 /* Can be uninlined because referenced by paravirt */
@@ -221,8 +225,8 @@ static inline int wrmsrq_safe(u32 msr, u64 val)
 /* rdmsr with exception handling */
 #define rdmsr_safe(msr, low, high)				\
 ({								\
-	int __err;						\
-	u64 __val = native_read_msr_safe((msr), &__err);	\
+	u64 __val;						\
+	int __err = native_read_msr_safe((msr), &__val);	\
 	(*low) = (u32)__val;					\
 	(*high) = (u32)(__val >> 32);				\
 	__err;							\
@@ -230,10 +234,7 @@ static inline int wrmsrq_safe(u32 msr, u64 val)
 
 static inline int rdmsrq_safe(u32 msr, u64 *p)
 {
-	int err;
-
-	*p = native_read_msr_safe(msr, &err);
-	return err;
+	return native_read_msr_safe(msr, p);
 }
 
 static __always_inline u64 rdpmc(int counter)
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index edf23bde367e..03f680d1057a 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -175,7 +175,7 @@ static inline void __write_cr4(unsigned long x)
 	PVOP_VCALL1(cpu.write_cr4, x);
 }
 
-static inline u64 paravirt_read_msr(unsigned msr)
+static inline u64 paravirt_read_msr(u32 msr)
 {
 	return PVOP_CALL1(u64, cpu.read_msr, msr);
 }
@@ -185,9 +185,9 @@ static inline void paravirt_write_msr(u32 msr, u64 val)
 	PVOP_VCALL2(cpu.write_msr, msr, val);
 }
 
-static inline u64 paravirt_read_msr_safe(unsigned msr, int *err)
+static inline int paravirt_read_msr_safe(u32 msr, u64 *val)
 {
-	return PVOP_CALL2(u64, cpu.read_msr_safe, msr, err);
+	return PVOP_CALL2(int, cpu.read_msr_safe, msr, val);
 }
 
 static inline int paravirt_write_msr_safe(u32 msr, u64 val)
@@ -225,19 +225,16 @@ static inline int wrmsrq_safe(u32 msr, u64 val)
 /* rdmsr with exception handling */
 #define rdmsr_safe(msr, a, b)				\
 ({							\
-	int _err;					\
-	u64 _l = paravirt_read_msr_safe(msr, &_err);	\
+	u64 _l;						\
+	int _err = paravirt_read_msr_safe((msr), &_l);	\
 	(*a) = (u32)_l;					\
-	(*b) = _l >> 32;				\
+	(*b) = (u32)(_l >> 32);				\
 	_err;						\
 })
 
-static inline int rdmsrq_safe(unsigned msr, u64 *p)
+static __always_inline int rdmsrq_safe(u32 msr, u64 *p)
 {
-	int err;
-
-	*p = paravirt_read_msr_safe(msr, &err);
-	return err;
+	return paravirt_read_msr_safe(msr, p);
 }
 
 static __always_inline u64 rdpmc(int counter)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 78777b78da12..b08b9d3122d6 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -91,14 +91,14 @@ struct pv_cpu_ops {
 		      unsigned int *ecx, unsigned int *edx);
 
 	/* Unsafe MSR operations.  These will warn or panic on failure. */
-	u64 (*read_msr)(unsigned int msr);
+	u64 (*read_msr)(u32 msr);
 	void (*write_msr)(u32 msr, u64 val);
 
 	/*
 	 * Safe MSR operations.
-	 * read sets err to 0 or -EIO.  write returns 0 or -EIO.
+	 * Returns 0 or -EIO.
 	 */
-	u64 (*read_msr_safe)(unsigned int msr, int *err);
+	int (*read_msr_safe)(u32 msr, u64 *val);
 	int (*write_msr_safe)(u32 msr, u64 val);
 
 	u64 (*read_pmc)(int counter);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4ef9978dce70..838606f784c9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -475,15 +475,13 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
 
 static void svm_init_erratum_383(void)
 {
-	int err;
 	u64 val;
 
 	if (!static_cpu_has_bug(X86_BUG_AMD_TLB_MMATCH))
 		return;
 
 	/* Use _safe variants to not break nested virtualization */
-	val = native_read_msr_safe(MSR_AMD64_DC_CFG, &err);
-	if (err)
+	if (native_read_msr_safe(MSR_AMD64_DC_CFG, &val))
 		return;
 
 	val |= (1ULL << 47);
@@ -648,13 +646,12 @@ static int svm_enable_virtualization_cpu(void)
 	 * erratum is present everywhere).
 	 */
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_OSVW)) {
-		uint64_t len, status = 0;
+		u64 len, status = 0;
 		int err;
 
-		len = native_read_msr_safe(MSR_AMD64_OSVW_ID_LENGTH, &err);
+		err = native_read_msr_safe(MSR_AMD64_OSVW_ID_LENGTH, &len);
 		if (!err)
-			status = native_read_msr_safe(MSR_AMD64_OSVW_STATUS,
-						      &err);
+			err = native_read_msr_safe(MSR_AMD64_OSVW_STATUS, &status);
 
 		if (err)
 			osvw_status = osvw_len = 0;
@@ -2145,14 +2142,13 @@ static int ac_interception(struct kvm_vcpu *vcpu)
 
 static bool is_erratum_383(void)
 {
-	int err, i;
+	int i;
 	u64 value;
 
 	if (!erratum_383_found)
 		return false;
 
-	value = native_read_msr_safe(MSR_IA32_MC0_STATUS, &err);
-	if (err)
+	if (native_read_msr_safe(MSR_IA32_MC0_STATUS, &value))
 		return false;
 
 	/* Bit 62 may or may not be set for this mce */
@@ -2165,8 +2161,7 @@ static bool is_erratum_383(void)
 	for (i = 0; i < 6; ++i)
 		native_write_msr_safe(MSR_IA32_MCx_STATUS(i), 0);
 
-	value = native_read_msr_safe(MSR_IA32_MCG_STATUS, &err);
-	if (!err) {
+	if (!native_read_msr_safe(MSR_IA32_MCG_STATUS, &value)) {
 		value &= ~(1ULL << 2);
 		native_write_msr_safe(MSR_IA32_MCG_STATUS, value);
 	}
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index c067d1e8a39c..0b2f5e679026 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1086,7 +1086,7 @@ static void xen_write_cr4(unsigned long cr4)
 	native_write_cr4(cr4);
 }
 
-static u64 xen_do_read_msr(unsigned int msr, int *err)
+static u64 xen_do_read_msr(u32 msr, int *err)
 {
 	u64 val = 0;	/* Avoid uninitialized value for safe variant. */
 
@@ -1094,7 +1094,7 @@ static u64 xen_do_read_msr(unsigned int msr, int *err)
 		return val;
 
 	if (err)
-		val = native_read_msr_safe(msr, err);
+		*err = native_read_msr_safe(msr, &val);
 	else
 		val = native_read_msr(msr);
 
@@ -1159,9 +1159,12 @@ static void xen_do_write_msr(u32 msr, u64 val, int *err)
 	}
 }
 
-static u64 xen_read_msr_safe(unsigned int msr, int *err)
+static int xen_read_msr_safe(u32 msr, u64 *val)
 {
-	return xen_do_read_msr(msr, err);
+	int err;
+
+	*val = xen_do_read_msr(msr, &err);
+	return err;
 }
 
 static int xen_write_msr_safe(u32 msr, u64 val)
@@ -1173,7 +1176,7 @@ static int xen_write_msr_safe(u32 msr, u64 val)
 	return err;
 }
 
-static u64 xen_read_msr(unsigned int msr)
+static u64 xen_read_msr(u32 msr)
 {
 	int err;
 
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index 6bee83018694..3e704094c97c 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -317,11 +317,12 @@ static u64 xen_amd_read_pmc(int counter)
 	uint8_t xenpmu_flags = get_xenpmu_flags();
 
 	if (!xenpmu_data || !(xenpmu_flags & XENPMU_IRQ_PROCESSING)) {
-		uint32_t msr;
-		int err;
+		u32 msr;
+		u64 val;
 
 		msr = amd_counters_base + (counter * amd_msr_step);
-		return native_read_msr_safe(msr, &err);
+		native_read_msr_safe(msr, &val);
+		return val;
 	}
 
 	ctxt = &xenpmu_data->pmu.c.amd;
@@ -338,15 +339,16 @@ static u64 xen_intel_read_pmc(int counter)
 	uint8_t xenpmu_flags = get_xenpmu_flags();
 
 	if (!xenpmu_data || !(xenpmu_flags & XENPMU_IRQ_PROCESSING)) {
-		uint32_t msr;
-		int err;
+		u32 msr;
+		u64 val;
 
 		if (counter & (1 << INTEL_PMC_TYPE_SHIFT))
 			msr = MSR_CORE_PERF_FIXED_CTR0 + (counter & 0xffff);
 		else
 			msr = MSR_IA32_PERFCTR0 + counter;
 
-		return native_read_msr_safe(msr, &err);
+		native_read_msr_safe(msr, &val);
+		return val;
 	}
 
 	ctxt = &xenpmu_data->pmu.c.intel;
-- 
2.49.0


