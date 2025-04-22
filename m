Return-Path: <kvm+bounces-43764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD277A96156
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96C6017B9EE
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B2A25DB0F;
	Tue, 22 Apr 2025 08:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="N6j53RZd"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CF025484B;
	Tue, 22 Apr 2025 08:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310232; cv=none; b=MJ2w1H0bcJw8XD0MSqWTd5uDwMUKBZ2hU4HqFz0il8EoWgBY+wfVnRIyvyXln3rHExlmIHnD5iPiJEKD0kQQnaJirzL6dCMUrwhPHhaPfUNuc2ep94YGKfaa0wUEAkOETbVZ4vwwkhrUCXZQW61Z9BvBg32G3Z+pCayWDcW+ozA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310232; c=relaxed/simple;
	bh=pb7DxqE8fahU4/PYdnnj4sfsCEZ82VcTsq5O/G9NAD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzEFAUmOy5xULH3/nNIvNWUNj0bDfSIBhDs6rkuziSvfssW6Wy4LpFdRPf7UKiu/yxRE0k4F4CxHhlQ+9m6pXdQfmDmHh2xL+mb6QlA3V/9R7koNoaZz5cUrWGKVWGBJcF99pyMdsG/10Z79vC98TC7Kdx02k8QSeNVaNOMiiL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=N6j53RZd; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9i1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:23:21 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9i1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310203;
	bh=KF9UoUhpkeUaxol5GmRaBP0wotoAE475jYCZa+6vJrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6j53RZda7Hnrm3Z8UyJWyl2m7EfT1Jh76ZttRjn46pCv8YaQQ+xpoMdgq0mPnpKT
	 EwUMoOWhnYnb1/5hgNgmETHvL/rJmUEuW/oCXN9+U/55daY2aP+9r3mvUTRZj/8bsV
	 Hiuiyy+A89g2q4kl9x9SYelhIwx/krb/rTlGpcOePi8Lcb7Yrrt0i5MwE/MwittSk8
	 DUwskE+3zk5l9DH1aLljDwGukqrX7eL9Kc94LgWeRGlyrPWt2CjUbcUdgwBwaB+ifk
	 emZJByhMB2HFpmTeT9i0/P2Ha3s458mTGVQRX0DFn5l6yAdmgruipzB9tsCHO66Px/
	 QI5yU9wp4aydw==
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
Subject: [RFC PATCH v2 30/34] x86/msr: Rename native_rdmsr() to native_rdmsr_no_trace()
Date: Tue, 22 Apr 2025 01:22:11 -0700
Message-ID: <20250422082216.1954310-31-xin@zytor.com>
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

native_rdmsr() doesn't do trace thus can be used in noinstr context,
rename it to native_rdmsr_no_trace() to make it explicit.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/microcode.h      | 2 +-
 arch/x86/include/asm/msr.h            | 8 ++++----
 arch/x86/kernel/cpu/microcode/amd.c   | 2 +-
 arch/x86/kernel/cpu/microcode/core.c  | 2 +-
 arch/x86/kernel/cpu/microcode/intel.c | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index da482f430d80..d581fdaf1f36 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -69,7 +69,7 @@ static inline u32 intel_get_microcode_revision(void)
 	native_cpuid_eax(1);
 
 	/* get the current revision from MSR 0x8B */
-	native_rdmsr(MSR_IA32_UCODE_REV, dummy, rev);
+	native_rdmsr_no_trace(MSR_IA32_UCODE_REV, dummy, rev);
 
 	return rev;
 }
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 050d750a5ab7..dfaac42b6258 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -158,9 +158,9 @@ static __always_inline bool is_msr_imm_insn(void *ip)
  *                            /     \                                |
  *                           /       \                               |
  *        native_rdmsrq_no_trace()    native_read_msr_safe()         |
- *                   /    \                                          |
- *                  /      \                                         |
- *      native_rdmsr()    native_read_msr()                          |
+ *                   /      \                                        |
+ *                  /        \                                       |
+ * native_rdmsr_no_trace()    native_read_msr()                      |
  *                                                                   |
  *                                                                   |
  *                                                                   |
@@ -256,7 +256,7 @@ static __always_inline u64 native_rdmsrq_no_trace(u32 msr)
 	return val;
 }
 
-#define native_rdmsr(msr, low, high)			\
+#define native_rdmsr_no_trace(msr, low, high)		\
 do {							\
 	u64 __val = native_rdmsrq_no_trace(msr);	\
 	(void)((low) = (u32)__val);			\
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 41c553396500..f1f275ddab57 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -256,7 +256,7 @@ static u32 get_patch_level(void)
 {
 	u32 rev, dummy __always_unused;
 
-	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
+	native_rdmsr_no_trace(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
 	return rev;
 }
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index b3658d11e7b6..9bda8fd987ab 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -84,7 +84,7 @@ static bool amd_check_current_patch_level(void)
 	u32 lvl, dummy, i;
 	u32 *levels;
 
-	native_rdmsr(MSR_AMD64_PATCH_LEVEL, lvl, dummy);
+	native_rdmsr_no_trace(MSR_AMD64_PATCH_LEVEL, lvl, dummy);
 
 	levels = final_levels;
 
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 26e13dc4cedd..c0307b1ad63d 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -78,7 +78,7 @@ void intel_collect_cpu_info(struct cpu_signature *sig)
 		unsigned int val[2];
 
 		/* get processor flags from MSR 0x17 */
-		native_rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
+		native_rdmsr_no_trace(MSR_IA32_PLATFORM_ID, val[0], val[1]);
 		sig->pf = 1 << ((val[1] >> 18) & 7);
 	}
 }
-- 
2.49.0


