Return-Path: <kvm+bounces-44512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0176EA9E20B
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 11:31:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F3581A844B4
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 09:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93A7725E45A;
	Sun, 27 Apr 2025 09:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="VNmo3uia"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB36F25DB1A;
	Sun, 27 Apr 2025 09:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745745705; cv=none; b=evlMsn6ChGAGZyMBPD20GIPgAwpgWMJmEQSDlWxOuYUOmB18g1eTQxif4Cfj52HLLoxsnKfk8rBjlycn17Wb8Vz0SJFAasgk6vnKvf6pWd7LHx1cpYBjWuI89OVpOP6ac2NQqXU5PzBquDWbAFkG3mkr0PKG+65+a4Sxs0DyWv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745745705; c=relaxed/simple;
	bh=POeWP1OeCKuZRSOpQsm5z1482Z4JAEDNnoL556x+v5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejLkiLOw4PraEyFADSZfRpjYeGhFOkxnQp2/2RyQATYah9sdyuLRXPzC7ojBOdsa7aRrXJUGDbaUpba2fTQCwIlOQHfo/YfSvBQZDX5odTA4wIi/0usVlWgJVfKZeERC3ZiWmwCljOC588V2gyLrXSG8T//nLPdHtMu2+2Ri/CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=VNmo3uia; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53R9KRRx1598826
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 27 Apr 2025 02:20:36 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53R9KRRx1598826
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745745637;
	bh=+pVPbNpNJhKlbxpDgv7RbZVuTFqKjEBhcRqOVxNg35M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNmo3uiak1noYpKTG/jLw/iJPvxthCPJphOG7oNxfBB0fU/ujY4AM6rt1iCWNcVmB
	 PkVpItnEGcCeGnjVW5id6u8fewAPR6ih7c46JrOyu+ctmHJXDsx5VdOvDr14TGh/Lb
	 PgF26Pfs59jrRsEMvx/lql25UmR2CqpIshcSLlVH4fSW899RlSygMuGqkK3a74Z/tx
	 uGL4GxEX0OQ097TNxvCv7jEIzqA5H4lGqzh2IIybrBnLRjIlIfRghl6fcpAklhsDbS
	 7pEx8/ly1QrIWFMPItt5SnDpgkaS83vH3Hk/09/rsrMY16LPtDhd0EBO4KSIszK85N
	 GhEnY34L8vjHg==
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
        dapeng1.mi@linux.intel.com, ilpo.jarvinen@linux.intel.com
Subject: [PATCH v4 02/15] x86/msr: Move rdtsc{,_ordered}() to <asm/tsc.h>
Date: Sun, 27 Apr 2025 02:20:14 -0700
Message-ID: <20250427092027.1598740-3-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250427092027.1598740-1-xin@zytor.com>
References: <20250427092027.1598740-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For some reason, there are some TSC-related functions in the MSR
header even though there is a tsc.h header.

Relocate rdtsc{,_ordered}() from <asm/msr.h> to <asm/tsc.h>, and
subsequently remove the inclusion of <asm/msr.h> in <asm/tsc.h>.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---

Change in v4:
*) Add missing includes in a different patch (Ilpo Järvinen).

Change in v3:
* Add a problem statement to the changelog (Dave Hansen).
---
 arch/x86/include/asm/msr.h | 54 ---------------------------
 arch/x86/include/asm/tsc.h | 76 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 75 insertions(+), 55 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 72a9ebc99078..2caa13830e11 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -170,60 +170,6 @@ native_write_msr_safe(u32 msr, u32 low, u32 high)
 extern int rdmsr_safe_regs(u32 regs[8]);
 extern int wrmsr_safe_regs(u32 regs[8]);
 
-/**
- * rdtsc() - returns the current TSC without ordering constraints
- *
- * rdtsc() returns the result of RDTSC as a 64-bit integer.  The
- * only ordering constraint it supplies is the ordering implied by
- * "asm volatile": it will put the RDTSC in the place you expect.  The
- * CPU can and will speculatively execute that RDTSC, though, so the
- * results can be non-monotonic if compared on different CPUs.
- */
-static __always_inline u64 rdtsc(void)
-{
-	DECLARE_ARGS(val, low, high);
-
-	asm volatile("rdtsc" : EAX_EDX_RET(val, low, high));
-
-	return EAX_EDX_VAL(val, low, high);
-}
-
-/**
- * rdtsc_ordered() - read the current TSC in program order
- *
- * rdtsc_ordered() returns the result of RDTSC as a 64-bit integer.
- * It is ordered like a load to a global in-memory counter.  It should
- * be impossible to observe non-monotonic rdtsc_unordered() behavior
- * across multiple CPUs as long as the TSC is synced.
- */
-static __always_inline u64 rdtsc_ordered(void)
-{
-	DECLARE_ARGS(val, low, high);
-
-	/*
-	 * The RDTSC instruction is not ordered relative to memory
-	 * access.  The Intel SDM and the AMD APM are both vague on this
-	 * point, but empirically an RDTSC instruction can be
-	 * speculatively executed before prior loads.  An RDTSC
-	 * immediately after an appropriate barrier appears to be
-	 * ordered as a normal load, that is, it provides the same
-	 * ordering guarantees as reading from a global memory location
-	 * that some other imaginary CPU is updating continuously with a
-	 * time stamp.
-	 *
-	 * Thus, use the preferred barrier on the respective CPU, aiming for
-	 * RDTSCP as the default.
-	 */
-	asm volatile(ALTERNATIVE_2("rdtsc",
-				   "lfence; rdtsc", X86_FEATURE_LFENCE_RDTSC,
-				   "rdtscp", X86_FEATURE_RDTSCP)
-			: EAX_EDX_RET(val, low, high)
-			/* RDTSCP clobbers ECX with MSR_TSC_AUX. */
-			:: "ecx");
-
-	return EAX_EDX_VAL(val, low, high);
-}
-
 static inline u64 native_read_pmc(int counter)
 {
 	DECLARE_ARGS(val, low, high);
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 94408a784c8e..13335a130edf 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -7,7 +7,81 @@
 
 #include <asm/cpufeature.h>
 #include <asm/processor.h>
-#include <asm/msr.h>
+
+/*
+ * both i386 and x86_64 returns 64-bit value in edx:eax, but gcc's "A"
+ * constraint has different meanings. For i386, "A" means exactly
+ * edx:eax, while for x86_64 it doesn't mean rdx:rax or edx:eax. Instead,
+ * it means rax *or* rdx.
+ */
+#ifdef CONFIG_X86_64
+/* Using 64-bit values saves one instruction clearing the high half of low */
+#define DECLARE_ARGS(val, low, high)	unsigned long low, high
+#define EAX_EDX_VAL(val, low, high)	((low) | (high) << 32)
+#define EAX_EDX_RET(val, low, high)	"=a" (low), "=d" (high)
+#else
+#define DECLARE_ARGS(val, low, high)	u64 val
+#define EAX_EDX_VAL(val, low, high)	(val)
+#define EAX_EDX_RET(val, low, high)	"=A" (val)
+#endif
+
+/**
+ * rdtsc() - returns the current TSC without ordering constraints
+ *
+ * rdtsc() returns the result of RDTSC as a 64-bit integer.  The
+ * only ordering constraint it supplies is the ordering implied by
+ * "asm volatile": it will put the RDTSC in the place you expect.  The
+ * CPU can and will speculatively execute that RDTSC, though, so the
+ * results can be non-monotonic if compared on different CPUs.
+ */
+static __always_inline u64 rdtsc(void)
+{
+	DECLARE_ARGS(val, low, high);
+
+	asm volatile("rdtsc" : EAX_EDX_RET(val, low, high));
+
+	return EAX_EDX_VAL(val, low, high);
+}
+
+/**
+ * rdtsc_ordered() - read the current TSC in program order
+ *
+ * rdtsc_ordered() returns the result of RDTSC as a 64-bit integer.
+ * It is ordered like a load to a global in-memory counter.  It should
+ * be impossible to observe non-monotonic rdtsc_unordered() behavior
+ * across multiple CPUs as long as the TSC is synced.
+ */
+static __always_inline u64 rdtsc_ordered(void)
+{
+	DECLARE_ARGS(val, low, high);
+
+	/*
+	 * The RDTSC instruction is not ordered relative to memory
+	 * access.  The Intel SDM and the AMD APM are both vague on this
+	 * point, but empirically an RDTSC instruction can be
+	 * speculatively executed before prior loads.  An RDTSC
+	 * immediately after an appropriate barrier appears to be
+	 * ordered as a normal load, that is, it provides the same
+	 * ordering guarantees as reading from a global memory location
+	 * that some other imaginary CPU is updating continuously with a
+	 * time stamp.
+	 *
+	 * Thus, use the preferred barrier on the respective CPU, aiming for
+	 * RDTSCP as the default.
+	 */
+	asm volatile(ALTERNATIVE_2("rdtsc",
+				   "lfence; rdtsc", X86_FEATURE_LFENCE_RDTSC,
+				   "rdtscp", X86_FEATURE_RDTSCP)
+			: EAX_EDX_RET(val, low, high)
+			/* RDTSCP clobbers ECX with MSR_TSC_AUX. */
+			:: "ecx");
+
+	return EAX_EDX_VAL(val, low, high);
+}
+
+#undef DECLARE_ARGS
+#undef EAX_EDX_VAL
+#undef EAX_EDX_RET
 
 /*
  * Standard way to access the cycle counter.
-- 
2.49.0


