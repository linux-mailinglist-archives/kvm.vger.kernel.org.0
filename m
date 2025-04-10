Return-Path: <kvm+bounces-43100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9127DA84B9D
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 19:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E90FD1BA4D86
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 17:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0AE8285416;
	Thu, 10 Apr 2025 17:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AVvUzMUD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6323C1EDA29;
	Thu, 10 Apr 2025 17:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744307395; cv=none; b=ioTcpIqHIqqydZMD2AUrtBteOjYOj6NzVGNQ7pki6ASleWGDZZq3bxKHUfqtqLOPmU2GomjcQn84y5eFcatYefs4W8VzwjEV8Lej40KPBDjavshBfnbxnSH2RRqmaTcnOyLwXFEgk94geLhMHGRksJXdrH+0nM+VRDP80wT+tzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744307395; c=relaxed/simple;
	bh=BSlBou70rdYI1WqIexajKvsgOgYusvRJvdttvr8R6Ww=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XCxj03/rWK7nQhpSNwrhMAMb/fhMboFwZrOX7wRm/NPXnl54WJQRDiSkqU6dMEKCe/Vh1em6Ya/iy92Kvdp/ryh0DpC0JjbTyZlB2oSPms+C+zSZFUFccX504VmH6WN4F1dhAPDqaCQs0gp0hmLZtUVOEK8RjD5PeWL4IT+BmKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AVvUzMUD; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744307393; x=1775843393;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=BSlBou70rdYI1WqIexajKvsgOgYusvRJvdttvr8R6Ww=;
  b=AVvUzMUDKuTZH0rMeX8DH2296p3CT72YaWUmiOD01cUHbnSor27Zb1Ux
   +Qo0p5seohrKtJ2Z9sijYSXfb9JoT03wnLxrWxgpRZVkGV+BgW4Gk3ix2
   qN9Uy2faRrZZa+Wq4Mcd3uNQeYHyrD1cTt/yg4bmgYQPAT+yMGpbouCk6
   8IpYjvuP/C4Z7JbBvkitNZNI4F1quaNMX73H3rQmnhRKcry4VHutNGhpH
   CMMc5XR0c9B4wufzEJoCsTsXhUGKguQPuuCPgIhjRlytIFNWaQRo5b6mc
   j+J81k1trfUMs2XeLU9WIxi9cr97in3my70bXXrBujw7aqeojTHvl1Ewk
   Q==;
X-CSE-ConnectionGUID: Q2Gkit4/Ty+TfHN7maqbOQ==
X-CSE-MsgGUID: WGg0Y+1QTd2mpZvYlRinLA==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="56024157"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="56024157"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 10:49:52 -0700
X-CSE-ConnectionGUID: m1Un4WLvSqCJYAUpy7G3EA==
X-CSE-MsgGUID: 4pja72TtQjScDM94snD2/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="129507250"
Received: from dstill-mobl.amr.corp.intel.com (HELO desk) ([10.125.145.218])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 10:49:52 -0700
Date: Thu, 10 Apr 2025 10:49:51 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] x86/bugs/mmio: Rename mmio_stale_data_clear to
 cpu_buf_vm_clear
Message-ID: <20250410-mmio-rename-v1-1-fd4b2e7fc04e@linux.intel.com>
X-B4-Tracking: v=1; b=H4sIAE8C+GcC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDE0MD3dzczHzdotS8xNxU3eQ0i8Tk1OQkUzPjVCWgjoKi1LTMCrBp0bG
 1tQA9ZqbYXQAAAA==
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
 arch/x86/include/asm/nospec-branch.h |  2 +-
 arch/x86/kernel/cpu/bugs.c           | 16 ++++++++++------
 arch/x86/kvm/vmx/vmx.c               |  2 +-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 8a5cc8e70439e10aab4eeb5b0f5e116cf635b43d..c0474e2b741737dad129159adf3b5fc056b6097c 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -561,7 +561,7 @@ DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
 
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
-DECLARE_STATIC_KEY_FALSE(mmio_stale_data_clear);
+DECLARE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
 
 extern u16 mds_verw_sel;
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 4386aa6c69e12c9a8d66758e9f7cfff816ccbbe3..dcf029fed3beec38a2e8b6292ec7d0660f3ec678 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -128,9 +128,13 @@ EXPORT_SYMBOL_GPL(mds_idle_clear);
  */
 DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
-/* Controls CPU Fill buffer clear before KVM guest MMIO accesses */
-DEFINE_STATIC_KEY_FALSE(mmio_stale_data_clear);
-EXPORT_SYMBOL_GPL(mmio_stale_data_clear);
+/*
+ * Controls CPU Fill buffer clear before VMenter. This is a subset of
+ * X86_FEATURE_CLEAR_CPU_BUF, and should only be enabled when KVM-only
+ * mitigation is required
+ */
+DEFINE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
+EXPORT_SYMBOL_GPL(cpu_buf_vm_clear);
 
 void __init cpu_select_mitigations(void)
 {
@@ -450,9 +454,9 @@ static void __init mmio_select_mitigation(void)
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
@@ -572,7 +576,7 @@ static void __init md_clear_update_mitigation(void)
 		taa_select_mitigation();
 	}
 	/*
-	 * MMIO_MITIGATION_OFF is not checked here so that mmio_stale_data_clear
+	 * MMIO_MITIGATION_OFF is not checked here so that cpu_buf_vm_clear
 	 * gets updated correctly as per X86_FEATURE_CLEAR_CPU_BUF state.
 	 */
 	if (boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA)) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5c5766467a61d434ba2baa79a5faba99bcbd9997..c79720aad3df265ec8060dfe754bc816104f8c7b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7361,7 +7361,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
-	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
+	else if (static_branch_unlikely(&cpu_buf_vm_clear) &&
 		 kvm_arch_has_assigned_device(vcpu->kvm))
 		mds_clear_cpu_buffers();
 

---
base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
change-id: 20250410-mmio-rename-cf8acecb563e


