Return-Path: <kvm+bounces-32745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B0FA9DB8A1
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 14:29:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5767284475
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 13:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E2D51AA1E2;
	Thu, 28 Nov 2024 13:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODuhXW8s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC4C158527;
	Thu, 28 Nov 2024 13:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732800534; cv=none; b=swah8mQpLV8thpWqAsmpHIdvaQ/Ek9MMNK3AyGZf7pZPKJplw1eA5558nqhSLtnBVI7nKupnxJkakDmO7zQBS6KAn3Dt2LPveeAs4/bkUhM9hMi+RaucvkqJvRr1TgpYFAMKy1Xd389unfPkKkvaO6IiTEIIIvaIHc6y6SLZNOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732800534; c=relaxed/simple;
	bh=kC5eLhZuyJCGOCJxjU3EcU2Kl6QdCahcb46ZCgO3eGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlEuiReWf/k4y0o/86y3jUIb/QtKAB8JbzjgxxS6ZLask5iYhLUyR0uC2OrOXUYeE7nbxdvu3SNT2jZl94MfxixrfZkDY1ruhqbamhI/P8hgrD/vqLgejavVDiZ04SMvJWaK6A0VPbygctrZmq32VO16WqZ+RzAEsSdWju/pl24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODuhXW8s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9238EC4CED2;
	Thu, 28 Nov 2024 13:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732800534;
	bh=kC5eLhZuyJCGOCJxjU3EcU2Kl6QdCahcb46ZCgO3eGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODuhXW8su3Y/op7ZHDn5XHKC2c6xFjMTOdBBy0p/DMDsoMI3ae3IY+cwNZ0Rgyuca
	 BXZjH2KGcAeujLXEGxPGNCWbSRYyAznEMtvr8TKfrQEuvYr8Uxt33Wqrog/p0+oIFX
	 vTR4Rbk1HfChPqWTKw9bHPxUqVxSec9MNI9Xv3rpHhtSZtBkuAKZMBb7vIE5RK0Yzu
	 SfmbxDe9OuNxPtQlDAluwn/jx/yQqY4Uvd3Ryq3Z0tHXT8qfOpWWN8/nVuDJGRsbyL
	 bo0AuRP1gqsXmyEjMwV4Ji78JdeB6aA6FzH1kyIgoEhohHzWLH0FoM7WIhlDp2DB0B
	 tLHs4TtxCmH0A==
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
Subject: [RFC PATCH v3 1/2] x86: cpu/bugs: add AMD ERAPS support; hardware flushes RSB
Date: Thu, 28 Nov 2024 14:28:33 +0100
Message-ID: <20241128132834.15126-2-amit@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241128132834.15126-1-amit@kernel.org>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <20241128132834.15126-1-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amit Shah <amit.shah@amd.com>

When Automatic IBRS is disabled, Linux flushed the RSB on every context
switch.  This RSB flush is not necessary in software with the ERAPS
feature on Zen5+ CPUs that flushes the RSB in hardware on a context
switch (triggered by mov-to-CR3).

Additionally, the ERAPS feature also tags host and guest addresses in
the RSB - eliminating the need for software flushing of the RSB on
VMEXIT.

Disable all RSB flushing by Linux when the CPU has ERAPS.

Feature mentioned in AMD PPR 57238.  Will be resubmitted once APM is
public - which I'm told is imminent.

Signed-off-by: Amit Shah <amit.shah@amd.com>
---
 Documentation/admin-guide/hw-vuln/spectre.rst | 5 +++--
 arch/x86/include/asm/cpufeatures.h            | 1 +
 arch/x86/kernel/cpu/bugs.c                    | 6 +++++-
 3 files changed, 9 insertions(+), 3 deletions(-)

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
index 17b6590748c0..79a1373050f7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -461,6 +461,7 @@
 #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* Automatic IBRS */
 #define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* SMM_CTL MSR is not present */
 
+#define X86_FEATURE_ERAPS		(20*32+24) /* Enhanced RAP / RSB / RAS Security */
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d5102b72f74d..d7af5f811776 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1634,6 +1634,9 @@ static void __init spectre_v2_mitigate_rsb(enum spectre_v2_mitigation mode)
 	case SPECTRE_V2_RETPOLINE:
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_IBRS:
+		if (boot_cpu_has(X86_FEATURE_ERAPS))
+			break;
+
 		pr_info("Spectre v2 / SpectreRSB: Filling RSB on context switch and VMEXIT\n");
 		setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
@@ -2850,7 +2853,7 @@ static ssize_t spectre_v2_show_state(char *buf)
 	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
 		return sysfs_emit(buf, "Vulnerable: eIBRS+LFENCE with unprivileged eBPF and SMT\n");
 
-	return sysfs_emit(buf, "%s%s%s%s%s%s%s%s\n",
+	return sysfs_emit(buf, "%s%s%s%s%s%s%s%s%s\n",
 			  spectre_v2_strings[spectre_v2_enabled],
 			  ibpb_state(),
 			  boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? "; IBRS_FW" : "",
@@ -2858,6 +2861,7 @@ static ssize_t spectre_v2_show_state(char *buf)
 			  boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? "; RSB filling" : "",
 			  pbrsb_eibrs_state(),
 			  spectre_bhi_state(),
+			  boot_cpu_has(X86_FEATURE_ERAPS) ? "; ERAPS hardware RSB flush" : "",
 			  /* this should always be at the end */
 			  spectre_v2_module_string());
 }
-- 
2.47.0


