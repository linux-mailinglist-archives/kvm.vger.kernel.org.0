Return-Path: <kvm+bounces-63779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 42364C72518
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:20:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id F1A702CF36
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB5DC2EC0AE;
	Thu, 20 Nov 2025 06:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UnxgP/sy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A130283151;
	Thu, 20 Nov 2025 06:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619594; cv=none; b=FSwHvQLWLrzEDW2k+7p1AA6JmCBEZHtD683W49JM0jAi70mylytZkj4P9fIvaAYohsa2arXIaLkbLjJX/iSBsN9c0v1cdmeqV83u19GEIHnUEbZ2eGqwkMKJrUn1F4KZncQMI6LGLnmLIoiT7MQV+81V9Sa03n8kWasFJP1X5r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619594; c=relaxed/simple;
	bh=4OBFa8zHl9kgcuvI+bHoW6Hl8dCdjOsBYEoZlk3N8Sw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LpjLU7486kfPoUP8igAR2Y1oCrb4W4op6ICyxfg+E4K849lS74SMSvxTpN8PhhrFT4id9miCS63QZd5q+qccCkI7133UQKx2bYoC3aBzQaDrQFOnJYnIaKyEdI4kM6Qt11SxtKS+TeLW3RbJQh6xoHTOjsN6VL8fmbVQIapcOvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UnxgP/sy; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619593; x=1795155593;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4OBFa8zHl9kgcuvI+bHoW6Hl8dCdjOsBYEoZlk3N8Sw=;
  b=UnxgP/syKkS1rsSDG/5suxofZHaMgy4llR6S/3Bl9esh7n/JLk7C3LMA
   RnHdQH2+H5LBP9WAfgGQ+ZbQULyZDHna0UfPCiv3EwV8PkYauQjN5aU3H
   Fy558DTKuq1uHoYSe0nLOvSYk+vRyMuavamaOUkkj9EqGlbysQY1ViUIq
   tjhZrHSLdTXmNqA6ZySFcj1eOIIIAsMaUR3evbsStwGleyQFdSrDVkcQd
   IFAXyBHPxv75v2BaL9oMqAVeKE/0iSPA4Lo1+WsDKSvEnGZmuYeFCb/bP
   fjSkfYjZMSrc2rMZ7AOIp6kl/7d3Ktqi/0OBwCUF4J2ca++TghHhc8xnt
   A==;
X-CSE-ConnectionGUID: q8dHsykUSUWyQLwhulJtyA==
X-CSE-MsgGUID: 1m2EWpklRZ6nh6IVro+ROw==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="69529208"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="69529208"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:19:52 -0800
X-CSE-ConnectionGUID: G0BMLFTHRSyS4Ev+t7wZnQ==
X-CSE-MsgGUID: 5Vjmmqq5SqOPVRODL9rzqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="195395054"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:19:52 -0800
Date: Wed, 19 Nov 2025 22:19:51 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v4 09/11] x86/vmscape: Deploy BHB clearing mitigation
Message-ID: <20251119-vmscape-bhb-v4-9-1adad4e69ddc@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>

IBPB mitigation for VMSCAPE is an overkill on CPUs that are only affected
by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
indirect branch isolation between guest and host userspace. However, branch
history from guest may also influence the indirect branches in host
userspace.

To mitigate the BHI aspect, use clear_bhb_loop().

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 Documentation/admin-guide/hw-vuln/vmscape.rst |  4 ++++
 arch/x86/include/asm/nospec-branch.h          |  2 ++
 arch/x86/kernel/cpu/bugs.c                    | 30 ++++++++++++++++++++-------
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/vmscape.rst b/Documentation/admin-guide/hw-vuln/vmscape.rst
index d9b9a2b6c114c05a7325e5f3c9d42129339b870b..dc63a0bac03d43d1e295de0791dd6497d101f986 100644
--- a/Documentation/admin-guide/hw-vuln/vmscape.rst
+++ b/Documentation/admin-guide/hw-vuln/vmscape.rst
@@ -86,6 +86,10 @@ The possible values in this file are:
    run a potentially malicious guest and issues an IBPB before the first
    exit to userspace after VM-exit.
 
+ * 'Mitigation: Clear BHB before exit to userspace':
+
+   As above, conditional BHB clearing mitigation is enabled.
+
  * 'Mitigation: IBPB on VMEXIT':
 
    IBPB is issued on every VM-exit. This occurs when other mitigations like
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 15a2fa8f2f48a066e102263513eff9537ac1d25f..1e8c26c37dbed4256b35101fb41c0e1eb6ef9272 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -388,6 +388,8 @@ extern void write_ibpb(void);
 
 #ifdef CONFIG_X86_64
 extern void clear_bhb_loop(void);
+#else
+static inline void clear_bhb_loop(void) {}
 #endif
 
 extern void (*x86_return_thunk)(void);
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index cbb3341b9a19f835738eda7226323d88b7e41e52..d12c07ccf59479ecf590935607394492c988b2ff 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -109,9 +109,8 @@ DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
 EXPORT_PER_CPU_SYMBOL_GPL(x86_spec_ctrl_current);
 
 /*
- * Set when the CPU has run a potentially malicious guest. An IBPB will
- * be needed to before running userspace. That IBPB will flush the branch
- * predictor content.
+ * Set when the CPU has run a potentially malicious guest. Indicates that a
+ * branch predictor flush is needed before running userspace.
  */
 DEFINE_PER_CPU(bool, x86_predictor_flush_exit_to_user);
 EXPORT_PER_CPU_SYMBOL_GPL(x86_predictor_flush_exit_to_user);
@@ -3200,13 +3199,15 @@ enum vmscape_mitigations {
 	VMSCAPE_MITIGATION_AUTO,
 	VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER,
 	VMSCAPE_MITIGATION_IBPB_ON_VMEXIT,
+	VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER,
 };
 
 static const char * const vmscape_strings[] = {
-	[VMSCAPE_MITIGATION_NONE]		= "Vulnerable",
+	[VMSCAPE_MITIGATION_NONE]			= "Vulnerable",
 	/* [VMSCAPE_MITIGATION_AUTO] */
-	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]	= "Mitigation: IBPB before exit to userspace",
-	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT",
+	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]		= "Mitigation: IBPB before exit to userspace",
+	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]		= "Mitigation: IBPB on VMEXIT",
+	[VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER]	= "Mitigation: Clear BHB before exit to userspace",
 };
 
 static enum vmscape_mitigations vmscape_mitigation __ro_after_init =
@@ -3253,8 +3254,19 @@ static void __init vmscape_select_mitigation(void)
 			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
 		break;
 
+	case VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER:
+		if (!boot_cpu_has(X86_FEATURE_BHI_CTRL))
+			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
+		break;
 	case VMSCAPE_MITIGATION_AUTO:
-		if (boot_cpu_has(X86_FEATURE_IBPB))
+		/*
+		 * CPUs with BHI_CTRL(ADL and newer) can avoid the IBPB and use BHB
+		 * clear sequence. These CPUs are only vulnerable to the BHI variant
+		 * of the VMSCAPE attack and does not require an IBPB flush.
+		 */
+		if (boot_cpu_has(X86_FEATURE_BHI_CTRL))
+			vmscape_mitigation = VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER;
+		else if (boot_cpu_has(X86_FEATURE_IBPB))
 			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
 		else
 			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
@@ -3278,6 +3290,9 @@ static void __init vmscape_apply_mitigation(void)
 {
 	if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER)
 		static_call_update(vmscape_predictor_flush, write_ibpb);
+	else if (vmscape_mitigation == VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER &&
+		 IS_ENABLED(CONFIG_X86_64))
+		static_call_update(vmscape_predictor_flush, clear_bhb_loop);
 }
 
 #undef pr_fmt
@@ -3369,6 +3384,7 @@ void cpu_bugs_smt_update(void)
 		break;
 	case VMSCAPE_MITIGATION_IBPB_ON_VMEXIT:
 	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:
+	case VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER:
 		/*
 		 * Hypervisors can be attacked across-threads, warn for SMT when
 		 * STIBP is not already enabled system-wide.

-- 
2.34.1



