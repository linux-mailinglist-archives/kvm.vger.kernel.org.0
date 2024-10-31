Return-Path: <kvm+bounces-30200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 621A59B7EAB
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 16:40:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21147281A77
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA83C1AA78A;
	Thu, 31 Oct 2024 15:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lI0P/rzz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF46613342F;
	Thu, 31 Oct 2024 15:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730389183; cv=none; b=pIA6/M8N9awsOEJHbz2vHZR2Oxv7DQl+2NvyI43w75q8vON3jJdk/VOfGmnNKJyUD3D3MOMvEQuoMNbYl1RKN+mTJ3/BEvO7iOQWoUPCPGsqmFmc5hWQTEvygCmiuxdqE2YMsGlB372qk4LJetGmIY1fXDk8mrv7OUp0pfeSpDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730389183; c=relaxed/simple;
	bh=snmI6YMjx7sCmaq0eZOPPYPW0C2ycDeH1djt9cKAXl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CstiTHT3byhv27PVF+Zxmo02ChoPXfKEQx/k9qKRCdKB78Jsw1+OCK/ZmghbrbxXqh0zQajG8EgFDSw7GEUgfKuXc5wnN0bPnRy7Bss/JPaHsBcBbWYplYo71mpi/nC8LD1IMjlWEngrXwy920MiL1End5nB9HMTTuzHfsmVERw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lI0P/rzz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD40C4DDE6;
	Thu, 31 Oct 2024 15:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730389182;
	bh=snmI6YMjx7sCmaq0eZOPPYPW0C2ycDeH1djt9cKAXl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lI0P/rzzRRDwX+HPXX43pikeNKkg84CFu3WGUqmbqeq9h5luU802vslH0vG4hjwyN
	 u6x9RRdIza3fkpYJM7L+ISCA5enSRLHihBfGahAoqyvXqzuGXy3KFD9AyG4sXOhGIZ
	 lcosX9TQTqieAsNpxz+NRKuPn9RcSFn05U5Jk+4bH9d5Y9d3wxzhyIv8aBEiX07GME
	 ScOmWOxM2AC4O3GRFTGer6cTFzuwU/Np+eGohXDQyCeH+Vgnb23RC98HVpMj9ds5xR
	 KVfUSVtkM1Rx+m8RjCjjHeo2tfeh8HrkWahqIyP5jsM7Swxb5qn93kyq0SplHv417W
	 AfVe8oea5I2Iw==
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
	david.kaplan@amd.com
Subject: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
Date: Thu, 31 Oct 2024 16:39:24 +0100
Message-ID: <20241031153925.36216-2-amit@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241031153925.36216-1-amit@kernel.org>
References: <20241031153925.36216-1-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amit Shah <amit.shah@amd.com>

Remove explicit RET stuffing / filling on VMEXITs and context
switches on AMD CPUs with the ERAPS feature (Turin+).

With the Enhanced Return Address Prediction Security feature,  any
hardware TLB flush results in flushing of the RSB (aka RAP in AMD spec).
This guarantees an RSB flush across context switches.  The feature also
explicitly tags host and guest addresses - eliminating the need for
explicit flushing of the RSB on VMEXIT.

The BTC_NO feature in AMD CPUs ensures RET predictions do not speculate
from outside the RSB. Together, the BTC_NO and ERAPS features ensure no
flushing or stuffing of the RSB is necessary anymore.

Feature documented in AMD PPR 57238.

Signed-off-by: Amit Shah <amit.shah@amd.com>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |  5 +--
 arch/x86/include/asm/cpufeatures.h            |  1 +
 arch/x86/include/asm/nospec-branch.h          | 11 ++++++
 arch/x86/kernel/cpu/bugs.c                    | 36 +++++++++++++------
 4 files changed, 40 insertions(+), 13 deletions(-)

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
index 96b410b1d4e8..24d0fe5d5a8b 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -117,6 +117,17 @@
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
+ * auto-cleared on a TLB flush (i.e. a context switch).  Adapting the value of
+ * RSB_CLEAR_LOOPS below for ERAPS would change it to a runtime variable
+ * instead of the current compile-time constant, so leave it as-is, as this
+ * works for both older CPUs, as well as newer ones with ERAPS.
  */
 
 #define RETPOLINE_THUNK_SIZE	32
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 47a01d4028f6..83b34a522dd7 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1828,9 +1828,6 @@ static void __init spectre_v2_select_mitigation(void)
 	 *    speculated return targets may come from the branch predictor,
 	 *    which could have a user-poisoned BTB or BHB entry.
 	 *
-	 *    AMD has it even worse: *all* returns are speculated from the BTB,
-	 *    regardless of the state of the RSB.
-	 *
 	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
 	 *    scenario is mitigated by the IBRS branch prediction isolation
 	 *    properties, so the RSB buffer filling wouldn't be necessary to
@@ -1838,6 +1835,15 @@ static void __init spectre_v2_select_mitigation(void)
 	 *
 	 *    The "user -> user" attack scenario is mitigated by RSB filling.
 	 *
+	 *    AMD CPUs without the BTC_NO bit may speculate return targets
+	 *    from the BTB. CPUs with BTC_NO do not speculate return targets
+	 *    from the BTB, even on RSB underflow.
+	 *
+	 *    The ERAPS CPU feature (which implies the presence of BTC_NO)
+	 *    adds an RSB flush each time a TLB flush happens (i.e., on every
+	 *    context switch).  So, RSB filling is not necessary for this
+	 *    attack type with ERAPS present.
+	 *
 	 * 2) Poisoned RSB entry
 	 *
 	 *    If the 'next' in-kernel return stack is shorter than 'prev',
@@ -1848,17 +1854,24 @@ static void __init spectre_v2_select_mitigation(void)
 	 *    eIBRS.
 	 *
 	 *    The "user -> user" scenario, also known as SpectreBHB, requires
-	 *    RSB clearing.
+	 *    RSB clearing on processors without ERAPS.
 	 *
 	 * So to mitigate all cases, unconditionally fill RSB on context
-	 * switches.
-	 *
-	 * FIXME: Is this pointless for retbleed-affected AMD?
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
+		 * avoid poisoning, skip RSB filling at VMEXIT in that case.
+		 */
+		spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
+	}
 
 	/*
 	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
@@ -2871,7 +2884,7 @@ static ssize_t spectre_v2_show_state(char *buf)
 	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
 		return sysfs_emit(buf, "Vulnerable: eIBRS+LFENCE with unprivileged eBPF and SMT\n");
 
-	return sysfs_emit(buf, "%s%s%s%s%s%s%s%s\n",
+	return sysfs_emit(buf, "%s%s%s%s%s%s%s%s%s\n",
 			  spectre_v2_strings[spectre_v2_enabled],
 			  ibpb_state(),
 			  boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? "; IBRS_FW" : "",
@@ -2879,6 +2892,7 @@ static ssize_t spectre_v2_show_state(char *buf)
 			  boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? "; RSB filling" : "",
 			  pbrsb_eibrs_state(),
 			  spectre_bhi_state(),
+			  boot_cpu_has(X86_FEATURE_ERAPS) ? "; ERAPS hardware RSB flush" : "",
 			  /* this should always be at the end */
 			  spectre_v2_module_string());
 }
-- 
2.47.0


