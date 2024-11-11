Return-Path: <kvm+bounces-31500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B21B59C42D1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 17:42:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2163B2A1BD
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EA101A4F22;
	Mon, 11 Nov 2024 16:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tDCoWnrI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDAE1A0B13;
	Mon, 11 Nov 2024 16:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731343182; cv=none; b=ZskzV7yJE1nE7ZvYnilPXIXSyYbchw075SpAj5rk+qDu1ftVaIK+G2qDSb17Gu2KTuJ0u6wg3sHvY63R6zTVyjxUAdImtRq3yWd116Z7fpVEpOgcE5INjnpvIgWx4U5kp8ur9wzHK2i/Jx+QbVRb1VqCk4dOMkXvrdI52SR/4XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731343182; c=relaxed/simple;
	bh=41oxJ5fykYMjyLxmhvNwa/DNFouyIpJaqEOFrvTA7G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0YUcCcatShdbtiXyp3T80UAo9MOT4pbBgaVNt3HvTMBl91coHjDq2QOj7q0KxdycAM6fSzQlEQ+/K1+grdvFd/3B+Fz1Yreo3XMXprAy8GDH/j4ANwJhIXqHFpV2XoSkIMFO1nCCCbSitGZ4zP1TevvzPu8JS/JbfN948dc0qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tDCoWnrI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D093C4CED4;
	Mon, 11 Nov 2024 16:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731343182;
	bh=41oxJ5fykYMjyLxmhvNwa/DNFouyIpJaqEOFrvTA7G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDCoWnrI6N8SU8BOGyxwXfTfWxc6BfccU3vGOsmYNxoVpbBS66PURLYTetZD9UuEp
	 wHBHB5P0JwZeV44Im4te9lfhVriItNchB/ZfQPo2ACWq4ak+5B0iKZ+RjY9yg5jBd8
	 y+n3kP9uF7kRfKCXN3l61t78apdHKcwcb2bqBUMhH+CX8DMTaiCxWFHKranYbxRpgW
	 oWHEbhwoKgJemP3GX6Ve3c0iXX+kGfIiHfh26QVkZSZ9h1lhVBcEHZUaTiS8nFlGln
	 Kl4k02AayEG2L45/9R1xpDWaRRKwKSQYVLuwYDqlWzNsT8ATDEAkb1gLJfAPry7ep+
	 eRQJt8DZzoovA==
From: Amit Shah <amit@kernel.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-doc@vger.kernel.org
Cc: amit.shah@amd.com,
	thomas.lendacky@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	jpoimboe@kernel.org,
	pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com,
	kai.huang@intel.com,
	sandipan.das@amd.com,
	boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com,
	david.kaplan@amd.com,
	dwmw@amazon.co.uk,
	andrew.cooper3@citrix.com
Subject: [RFC PATCH v2 2/3] x86: cpu/bugs: add support for AMD ERAPS feature
Date: Mon, 11 Nov 2024 17:39:12 +0100
Message-ID: <20241111163913.36139-3-amit@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241111163913.36139-1-amit@kernel.org>
References: <20241111163913.36139-1-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amit Shah <amit.shah@amd.com>

Remove explicit RET stuffing / filling on VMEXITs and context
switches on AMD CPUs with the ERAPS feature (Zen5+).

With the Enhanced Return Address Prediction Security feature,  any of
the following conditions triggers a flush of the RSB (aka RAP in AMD
manuals) in hardware:
* context switch (e.g., move to CR3)
* TLB flush
* some writes to CR4

The feature also explicitly tags host and guest addresses in the RSB -
eliminating the need for explicit flushing of the RSB on VMEXIT.

[RFC note: We'll wait for the APM to be updated with the real wording,
but assuming it's going to say the ERAPS feature works the way described
above, let's continue the discussion re: when the kernel currently calls
FILL_RETURN_BUFFER, and what dropping it entirely means.

Dave Hansen pointed out __switch_to_asm fills the RSB each time it's
called, so let's address the cases there:

1. user->kernel switch: Switching from userspace to kernelspace, and
   then using user-stuffed RSB entries in the kernel is not possible
   thanks to SMEP.  We can safely drop the FILL_RETURN_BUFFER call for
   this case.  In fact, this is how the original code was when dwmw2
   added it originally in c995efd5a.  So while this case currently
   triggers an RSB flush (and will not after this ERAPS patch), the
   current flush isn't necessary for AMD systems with SMEP anyway.

2. user->user or kernel->kernel: If a user->user switch does not result
   in a CR3 change, it's a different thread in the same process context.
   That's the same case for kernel->kernel switch.  In this case, the
   RSB entries are still valid in that context, just not the correct
   ones in the new thread's context.  It's difficult to imagine this
   being a security risk.  The current code clearing it, and this patch
   not doing so for AMD-with-ERAPS, isn't a concern as far as I see.
]

Feature mentioned in AMD PPR 57238.  Will be resubmitted once APM is
public - which I'm told is imminent.

Signed-off-by: Amit Shah <amit.shah@amd.com>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |  5 ++--
 arch/x86/include/asm/cpufeatures.h            |  1 +
 arch/x86/include/asm/nospec-branch.h          | 12 ++++++++
 arch/x86/kernel/cpu/bugs.c                    | 29 ++++++++++++++-----
 4 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index 132e0bc6007e..647c10c0307a 100644
--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -417,9 +417,10 @@ The possible values in this file are:
 
   - Return stack buffer (RSB) protection status:
 
-  =============   ===========================================
+  =============   ========================================================
   'RSB filling'   Protection of RSB on context switch enabled
-  =============   ===========================================
+  'ERAPS'         Hardware RSB flush on context switches + guest/host tags
+  =============   ========================================================
 
   - EIBRS Post-barrier Return Stack Buffer (PBRSB) protection status:
 
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 913fd3a7bac6..665032b12871 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -458,6 +458,7 @@
 #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* Automatic IBRS */
 #define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* SMM_CTL MSR is not present */
 
+#define X86_FEATURE_ERAPS		(20*32+24) /* Enhanced RAP / RSB / RAS Security */
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 96b410b1d4e8..f5ee7fc71db5 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -117,6 +117,18 @@
  * We define a CPP macro such that it can be used from both .S files and
  * inline assembly. It's possible to do a .macro and then include that
  * from C via asm(".include <asm/nospec-branch.h>") but let's not go there.
+ *
+ * AMD CPUs with the ERAPS feature may have a larger default RSB.  These CPUs
+ * use the default number of entries on a host, and can optionally (based on
+ * hypervisor setup) use 32 (old) or the new default in a guest.  The number
+ * of default entries is reflected in CPUID 8000_0021:EBX[23:16].
+ *
+ * With the ERAPS feature, RSB filling is not necessary anymore: the RSB is
+ * auto-cleared by hardware on context switches, TLB flushes, or some CR4
+ * writes.  Adapting the value of RSB_CLEAR_LOOPS below for ERAPS would change
+ * it to a runtime variable instead of the current compile-time constant, so
+ * leave it as-is, as this works for both older CPUs, as well as newer ones
+ * with ERAPS.
  */
 
 #define RETPOLINE_THUNK_SIZE	32
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0aa629b5537d..02446815b0de 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1818,9 +1818,12 @@ static void __init spectre_v2_select_mitigation(void)
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
 	/*
-	 * If Spectre v2 protection has been enabled, fill the RSB during a
-	 * context switch.  In general there are two types of RSB attacks
-	 * across context switches, for which the CALLs/RETs may be unbalanced.
+	 * If Spectre v2 protection has been enabled, the RSB needs to be
+	 * cleared during a context switch.  Either do it in software by
+	 * filling the RSB, or in hardware via ERAPS.
+	 *
+	 * In general there are two types of RSB attacks across context
+	 * switches, for which the CALLs/RETs may be unbalanced.
 	 *
 	 * 1) RSB underflow
 	 *
@@ -1848,12 +1851,21 @@ static void __init spectre_v2_select_mitigation(void)
 	 *    RSB clearing.
 	 *
 	 * So to mitigate all cases, unconditionally fill RSB on context
-	 * switches.
+	 * switches when ERAPS is not present.
 	 */
-	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
-	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
+	if (!boot_cpu_has(X86_FEATURE_ERAPS)) {
+		setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
+		pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
 
-	spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
+		/*
+		 * For guest -> host (or vice versa) RSB poisoning scenarios,
+		 * determine the mitigation mode here.  With ERAPS, RSB
+		 * entries are tagged as host or guest - ensuring that neither
+		 * the host nor the guest have to clear or fill RSB entries to
+		 * avoid poisoning: skip RSB filling at VMEXIT in that case.
+		 */
+		spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
+	}
 
 	/*
 	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
@@ -2866,7 +2878,7 @@ static ssize_t spectre_v2_show_state(char *buf)
 	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
 		return sysfs_emit(buf, "Vulnerable: eIBRS+LFENCE with unprivileged eBPF and SMT\n");
 
-	return sysfs_emit(buf, "%s%s%s%s%s%s%s%s\n",
+	return sysfs_emit(buf, "%s%s%s%s%s%s%s%s%s\n",
 			  spectre_v2_strings[spectre_v2_enabled],
 			  ibpb_state(),
 			  boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? "; IBRS_FW" : "",
@@ -2874,6 +2886,7 @@ static ssize_t spectre_v2_show_state(char *buf)
 			  boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? "; RSB filling" : "",
 			  pbrsb_eibrs_state(),
 			  spectre_bhi_state(),
+			  boot_cpu_has(X86_FEATURE_ERAPS) ? "; ERAPS hardware RSB flush" : "",
 			  /* this should always be at the end */
 			  spectre_v2_module_string());
 }
-- 
2.47.0


