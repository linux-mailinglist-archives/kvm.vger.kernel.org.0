Return-Path: <kvm+bounces-43791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF63DA96203
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:40:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FBCF1787AC
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5070E27CCD3;
	Tue, 22 Apr 2025 08:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="XB6Bl9mX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B5327602A;
	Tue, 22 Apr 2025 08:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310247; cv=none; b=FQL2lOVvKHMpUmych7GkmfU6rFV3834pMdDk/ZM5HAhLwfDT3PVCJbesfnXjX6eaFv/UYZ574FB2iOHWvLIdmv6uDXM7qFLaIIot69xucqTPg9LVseopyuFlVKMA99jx9bkgXQTYqoacWUq7zAsWcLO1m6wc8Lth0KekrWk/2zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310247; c=relaxed/simple;
	bh=5wx8H1tAUABFL0N5zHR+KyW0uy4a3ORxSLie2AmMVUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghYx1KlNO/w2XME8CnvEe4ZV4IItxuSeGirv2NcWXwu4Uk+27hqp4FC7C7HWlwGuEGp9XonyBhOot5lYa6CkgibjRQmTFAHQOjUypAOCASCSbOv5rDaJkmgYAR2LBbOr70R9/Osci0dbx8nexQ1DTvC9SW5tNRkOvTtQLjK75uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=XB6Bl9mX; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9U1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:22:53 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9U1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310174;
	bh=tKwShxS8SnH3+r0XrY4puuThpPUtqn9sxGzBAvLv2qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XB6Bl9mXdDXZ6uItIj7HmLj7+SgdGBr4//8M02L9kJyhIy3nGwHmq06Q+9ILpfIlb
	 DSW1MBRBqfeODTFbogdeHWzIgmLXyURs0ZW2ugh2lPSGw0OKHOrvNKtbLD+nZ4lrTa
	 qIuGgzEaupHFGvAC+Tbg8gTVGMhiiY1uK2ST8DoPpunwIb7quo5Cjs7FvMp7lz3q7O
	 pE6XjV47oI+sHnWs9sPDeMj+IBucjeTvRUtGK5ilXHJsQnNbtPFggDyMZFoo2A4oNo
	 14+LS6Gf83CPkNWu/aX+A7mTB9LH5hngobXqbCOjg1NK53i/1WPuQwdrG5HQPub9ZJ
	 /825s1gxrDgXw==
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
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 16/34] x86/msr: Change function type of native_read_msr_safe()
Date: Tue, 22 Apr 2025 01:21:57 -0700
Message-ID: <20250422082216.1954310-17-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change function type of native_read_msr_safe() to

    int native_read_msr_safe(u32 msr, u64 *val)

to make it the same as the type of native_write_msr_safe().

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/msr.h            | 21 +++++++++++----------
 arch/x86/include/asm/paravirt_types.h |  4 ++--
 arch/x86/kvm/svm/svm.c                | 19 +++++++------------
 arch/x86/xen/enlighten_pv.c           |  9 ++++++---
 arch/x86/xen/pmu.c                    | 14 ++++++++------
 5 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index dd1114053173..c955339be9c9 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -135,18 +135,22 @@ static inline u64 native_read_msr(u32 msr)
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
@@ -242,8 +246,8 @@ static inline int wrmsrq_safe(u32 msr, u64 val)
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
@@ -251,10 +255,7 @@ static inline int wrmsrq_safe(u32 msr, u64 val)
 
 static inline int rdmsrq_safe(u32 msr, u64 *p)
 {
-	int err;
-
-	*p = native_read_msr_safe(msr, &err);
-	return err;
+	return native_read_msr_safe(msr, p);
 }
 #endif	/* !CONFIG_PARAVIRT_XXL */
 
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 91b3423d36ce..d2db38c32bc5 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -96,9 +96,9 @@ struct pv_cpu_ops {
 
 	/*
 	 * Safe MSR operations.
-	 * read sets err to 0 or -EIO.  write returns 0 or -EIO.
+	 * Returns 0 or -EIO.
 	 */
-	u64 (*read_msr_safe)(unsigned int msr, int *err);
+	int (*read_msr_safe)(unsigned int msr, u64 *val);
 	int (*write_msr_safe)(u32 msr, u64 val);
 
 	void (*start_context_switch)(struct task_struct *prev);
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
index 052f68c92111..195e6501a000 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1095,7 +1095,7 @@ static u64 xen_do_read_msr(unsigned int msr, int *err)
 		return val;
 
 	if (err)
-		val = native_read_msr_safe(msr, err);
+		*err = native_read_msr_safe(msr, &val);
 	else
 		val = native_read_msr(msr);
 
@@ -1162,9 +1162,12 @@ static void xen_do_write_msr(u32 msr, u64 val, int *err)
 	}
 }
 
-static u64 xen_read_msr_safe(unsigned int msr, int *err)
+static int xen_read_msr_safe(unsigned int msr, u64 *val)
 {
-	return xen_do_read_msr(msr, err);
+	int err;
+
+	*val = xen_do_read_msr(msr, &err);
+	return err;
 }
 
 static int xen_write_msr_safe(u32 msr, u64 val)
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index afb02f43ee3f..ee908dfcff48 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -319,11 +319,12 @@ static u64 xen_amd_read_pmc(int counter)
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
@@ -340,15 +341,16 @@ static u64 xen_intel_read_pmc(int counter)
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


