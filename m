Return-Path: <kvm+bounces-43469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2FA5A90563
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 16:05:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 801BE8E1FB1
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 14:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262311DE3CF;
	Wed, 16 Apr 2025 13:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KBYClgcI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9B41AA1FE;
	Wed, 16 Apr 2025 13:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744811274; cv=none; b=fPtr3cQ6fYYmMrHqHx5r+vwrhsyuSdnS6xixzu8yusE5y9XfeEmwWBLE687tP4b7qGYfSwEKJloYHfStq/HPQFKaKRnEPvgWccI7QnwSqvqyFefGpVg3UF/ganru/b4m+kKgt0NYp/eMphPI9c0MIAKyT/haTCnc1j8atcNdFAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744811274; c=relaxed/simple;
	bh=aZZ8ryF9EMbL1ZSnq1IfvBgrOmIuVFi9WpHYiEmRUoY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oHvLLm3fF+XwzBxMErAUMc+psgtG80ZIqVea+t9tmyvlDWKu5zexOVrkEBDghNFWzSYQwAYnJpoVRRnuVLNqTKXyC8EcF37m5tLB2qnI4TBeiA76FvZA1SAuY3z0Urh10DWiPLgO6SDyGy+gLHamWjdGngu/6JHqTizxgNA4LdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KBYClgcI; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744811273; x=1776347273;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=aZZ8ryF9EMbL1ZSnq1IfvBgrOmIuVFi9WpHYiEmRUoY=;
  b=KBYClgcIv+akc+fByVCMRk77KvkxLFVOqkcTXhhubr+S1cZ3Fr4V774J
   aHG8/r7kJi8PQpPzhL15AazLMF5Z46fmXpLdAkFSFU/y7+PD4BsIZU3Gb
   ECJ9GVBxXMnDn6aFwFd97ajoIW0x8rWf2hR/iLCN3YYzS7V6p/XlF5it7
   FXx1BFDjJsVQ8VFnGcC52rqXHqWElO0UBsOMqGHVM7l5P7VEd4h0Qt9X3
   JEEQhne/PnSMaBx6+uFKatAyEWsGmWFdWFp7Xmfb8Pp9U1yKFWhYgC5Ps
   b/E+jW6zqxhr5qzzpe7Nmf0l5iGV0R9BNwfSWqISARRyvsgdWJIWD8qY6
   g==;
X-CSE-ConnectionGUID: XKmx2O/YSk+eavydhsRqPA==
X-CSE-MsgGUID: Xn7TpeRHSpWCvNuxsdnJOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11405"; a="46250960"
X-IronPort-AV: E=Sophos;i="6.15,216,1739865600"; 
   d="scan'208";a="46250960"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 06:47:52 -0700
X-CSE-ConnectionGUID: UTVCo3N7Q+eL8DVLGRAnkQ==
X-CSE-MsgGUID: asjFQW9UTvK8JR2fUfd/bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,216,1739865600"; 
   d="scan'208";a="130245510"
Received: from aktunmor-mobl1.amr.corp.intel.com (HELO desk) ([10.125.145.226])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 06:47:52 -0700
Date: Wed, 16 Apr 2025 06:47:51 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2] x86/bugs/mmio: Rename mmio_stale_data_clear to
 cpu_buf_vm_clear
Message-ID: <20250416-mmio-rename-v2-1-ad1f5488767c@linux.intel.com>
X-B4-Tracking: v=1; b=H4sIADK0/2cC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDI1MDE0MD3dzczHzdotS8xNxU3eQ0i8Tk1OQkUzPjVCWgjoKi1LTMCrBp0bG
 1tQD45Nh8XQAAAA==
X-Change-ID: 20250410-mmio-rename-cf8acecb563e
X-Mailer: b4 0.14.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The static key mmio_stale_data_clear controls the KVM-only mitigation for
MMIO Stale Data vulnerability. Rename it to reflect its purpose.

No functional change.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
v2:
- Clarify the case when cpu_buf_vm_clear is used. (Sean)
---
 arch/x86/include/asm/nospec-branch.h |  2 +-
 arch/x86/kernel/cpu/bugs.c           | 16 ++++++++++------
 arch/x86/kvm/vmx/vmx.c               |  6 +++++-
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 5c43f145454ddda781e21806752737b42789c86d..81c4a13e4c0d4ace02b0948eef79377a68252e63 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -561,7 +561,7 @@ DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
 
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
-DECLARE_STATIC_KEY_FALSE(mmio_stale_data_clear);
+DECLARE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
 
 extern u16 mds_verw_sel;
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 362602b705cc43bd5e9df7c2157f44e7bfb304b9..9131e612de170a6b2bf27c35651f8e824f3d016c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -127,9 +127,13 @@ EXPORT_SYMBOL_GPL(mds_idle_clear);
  */
 DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
-/* Controls CPU Fill buffer clear before KVM guest MMIO accesses */
-DEFINE_STATIC_KEY_FALSE(mmio_stale_data_clear);
-EXPORT_SYMBOL_GPL(mmio_stale_data_clear);
+/*
+ * Controls CPU Fill buffer clear before VMenter. This is a subset of
+ * X86_FEATURE_CLEAR_CPU_BUF, and should only be enabled when KVM-only
+ * mitigation is required.
+ */
+DEFINE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
+EXPORT_SYMBOL_GPL(cpu_buf_vm_clear);
 
 void __init cpu_select_mitigations(void)
 {
@@ -449,9 +453,9 @@ static void __init mmio_select_mitigation(void)
 	 * mitigations, disable KVM-only mitigation in that case.
 	 */
 	if (boot_cpu_has(X86_FEATURE_CLEAR_CPU_BUF))
-		static_branch_disable(&mmio_stale_data_clear);
+		static_branch_disable(&cpu_buf_vm_clear);
 	else
-		static_branch_enable(&mmio_stale_data_clear);
+		static_branch_enable(&cpu_buf_vm_clear);
 
 	/*
 	 * If Processor-MMIO-Stale-Data bug is present and Fill Buffer data can
@@ -571,7 +575,7 @@ static void __init md_clear_update_mitigation(void)
 		taa_select_mitigation();
 	}
 	/*
-	 * MMIO_MITIGATION_OFF is not checked here so that mmio_stale_data_clear
+	 * MMIO_MITIGATION_OFF is not checked here so that cpu_buf_vm_clear
 	 * gets updated correctly as per X86_FEATURE_CLEAR_CPU_BUF state.
 	 */
 	if (boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA)) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5c5766467a61d434ba2baa79a5faba99bcbd9997..a1754f7ba889853eca919f090794b0dc54229a1a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7358,10 +7358,14 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 * mitigation for MDS is done late in VMentry and is still
 	 * executed in spite of L1D Flush. This is because an extra VERW
 	 * should not matter much after the big hammer L1D Flush.
+	 *
+	 * cpu_buf_vm_clear is used when system is not vulnerable to MDS/TAA,
+	 * and is affected by MMIO Stale Data. In such cases mitigation in only
+	 * needed against an MMIO capable guest.
 	 */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
-	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
+	else if (static_branch_unlikely(&cpu_buf_vm_clear) &&
 		 kvm_arch_has_assigned_device(vcpu->kvm))
 		mds_clear_cpu_buffers();
 

---
base-commit: 8ffd015db85fea3e15a77027fda6c02ced4d2444
change-id: 20250410-mmio-rename-cf8acecb563e

Best regards,
-- 
Pawan



