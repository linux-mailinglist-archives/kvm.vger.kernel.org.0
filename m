Return-Path: <kvm+bounces-28988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AAC8F9A07CA
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 12:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BA4E286CDA
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 10:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142B1207206;
	Wed, 16 Oct 2024 10:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z+QLV8kA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BED1CACDB;
	Wed, 16 Oct 2024 10:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729075860; cv=none; b=ZIhLBYDT9DObTfkDXbQ9slut5U1wUwLfFxlZot9aLt5SfP18Tq3nrgC5c/mB1Mr4sDjoVGR8fAkF9qLIWas4wGZiSF81JjDo/aIejMR3L3Iexi3ICCYlyas68Uzhj3FRXWxLID+dhyy8NJwfHugryq7133cTIemzODZ1iv/82t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729075860; c=relaxed/simple;
	bh=PNIap9Mxdye6yXywbk16VpWNVzOz915uVCPZlmzOALo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JeNOVc8DoWwc9viau2KQBRG+tm9b2BPeeJtViDTTM4oPlXdXOO0rGmKo+lxg4+nYL/Clas35edzFLT3JF9Z/9x5vJUKY7UTEXXrrHTmZ01o6y++IIw4GXzDdbmuQm72p2fPx/WIKCc76f/gN22QlfJQYSl7Hw74h+Yi0aLrv/so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z+QLV8kA; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729075859; x=1760611859;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PNIap9Mxdye6yXywbk16VpWNVzOz915uVCPZlmzOALo=;
  b=Z+QLV8kAgjsiy9SSacTmEU0izrZ1GidBfDaqlNVTBWMeTIxmXsXriaCg
   ARsYLkfpsR4mlE8EtqC86Wn8qHvW5RBPYXgrJCGbBlb3FdntxwZooL91I
   nlxNTVCLvfiVll0WgeLKxTgc9MrDc0bD7teByrqKmTqbJIymONijrKQC8
   x7WvmfLE8rPTA4Lutpra7zDs+lbnyO3NW5eR01V2buXW8CBHKSRDyvcgx
   ScUF5xdnEmPVs2TK9jKr4D+uC3uGYov8lu1us+Ec7/l8eXfiqZO9feoJu
   kvRfMhCJ2ev2v4s3O1qt5a7d0hSMzYWVOtYowoIhkCY9G8SK5s2ZLlHex
   g==;
X-CSE-ConnectionGUID: fg0EHjLsTtKBv2BigDVJgQ==
X-CSE-MsgGUID: cDKpGVjdR8qXWc7Oa1+F7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11226"; a="28395566"
X-IronPort-AV: E=Sophos;i="6.11,207,1725346800"; 
   d="scan'208";a="28395566"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 03:50:58 -0700
X-CSE-ConnectionGUID: BcSritA1TJ2xJIzrN/E4tw==
X-CSE-MsgGUID: rEYd4NKfRJOPJascwiMpVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,207,1725346800"; 
   d="scan'208";a="82969242"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa005.jf.intel.com with ESMTP; 16 Oct 2024 03:50:51 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id DE448331; Wed, 16 Oct 2024 13:50:49 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Kai Huang <kai.huang@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH] x86/mtrr: Rename mtrr_overwrite_state() to guest_force_mtrr_state()
Date: Wed, 16 Oct 2024 13:50:48 +0300
Message-ID: <20241016105048.757081-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
References: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename the helper to better reflect its function.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
---
 arch/x86/hyperv/ivm.c              |  2 +-
 arch/x86/include/asm/mtrr.h        | 10 +++++-----
 arch/x86/kernel/cpu/mtrr/generic.c |  6 +++---
 arch/x86/kernel/cpu/mtrr/mtrr.c    |  2 +-
 arch/x86/kernel/kvm.c              |  2 +-
 arch/x86/xen/enlighten_pv.c        |  4 ++--
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 60fc3ed72830..90aabe1fd3b6 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -664,7 +664,7 @@ void __init hv_vtom_init(void)
 	x86_platform.guest.enc_status_change_finish = hv_vtom_set_host_visibility;
 
 	/* Set WB as the default cache mode. */
-	mtrr_overwrite_state(NULL, 0, MTRR_TYPE_WRBACK);
+	guest_force_mtrr_state(NULL, 0, MTRR_TYPE_WRBACK);
 }
 
 #endif /* defined(CONFIG_AMD_MEM_ENCRYPT) || defined(CONFIG_INTEL_TDX_GUEST) */
diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 4218248083d9..c69e269937c5 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -58,8 +58,8 @@ struct mtrr_state_type {
  */
 # ifdef CONFIG_MTRR
 void mtrr_bp_init(void);
-void mtrr_overwrite_state(struct mtrr_var_range *var, unsigned int num_var,
-			  mtrr_type def_type);
+void guest_force_mtrr_state(struct mtrr_var_range *var, unsigned int num_var,
+			    mtrr_type def_type);
 extern u8 mtrr_type_lookup(u64 addr, u64 end, u8 *uniform);
 extern void mtrr_save_fixed_ranges(void *);
 extern void mtrr_save_state(void);
@@ -75,9 +75,9 @@ void mtrr_disable(void);
 void mtrr_enable(void);
 void mtrr_generic_set_state(void);
 #  else
-static inline void mtrr_overwrite_state(struct mtrr_var_range *var,
-					unsigned int num_var,
-					mtrr_type def_type)
+static inline void guest_force_mtrr_state(struct mtrr_var_range *var,
+					  unsigned int num_var,
+					  mtrr_type def_type)
 {
 }
 
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 7b29ebda024f..2fdfda2b60e4 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -423,7 +423,7 @@ void __init mtrr_copy_map(void)
 }
 
 /**
- * mtrr_overwrite_state - set static MTRR state
+ * guest_force_mtrr_state - set static MTRR state for a guest
  *
  * Used to set MTRR state via different means (e.g. with data obtained from
  * a hypervisor).
@@ -436,8 +436,8 @@ void __init mtrr_copy_map(void)
  * @num_var: length of the @var array
  * @def_type: default caching type
  */
-void mtrr_overwrite_state(struct mtrr_var_range *var, unsigned int num_var,
-			  mtrr_type def_type)
+void guest_force_mtrr_state(struct mtrr_var_range *var, unsigned int num_var,
+			    mtrr_type def_type)
 {
 	unsigned int i;
 
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.c b/arch/x86/kernel/cpu/mtrr/mtrr.c
index 989d368be04f..ecbda0341a8a 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -625,7 +625,7 @@ void mtrr_save_state(void)
 static int __init mtrr_init_finalize(void)
 {
 	/*
-	 * Map might exist if mtrr_overwrite_state() has been called or if
+	 * Map might exist if guest_force_mtrr_state() has been called or if
 	 * mtrr_enabled() returns true.
 	 */
 	mtrr_copy_map();
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 21e9e4845354..7a422a6c5983 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -983,7 +983,7 @@ static void __init kvm_init_platform(void)
 	x86_platform.apic_post_init = kvm_apic_init;
 
 	/* Set WB as the default cache mode for SEV-SNP and TDX */
-	mtrr_overwrite_state(NULL, 0, MTRR_TYPE_WRBACK);
+	guest_force_mtrr_state(NULL, 0, MTRR_TYPE_WRBACK);
 }
 
 #if defined(CONFIG_AMD_MEM_ENCRYPT)
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index d6818c6cafda..633469fab536 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -171,7 +171,7 @@ static void __init xen_set_mtrr_data(void)
 
 	/* Only overwrite MTRR state if any MTRR could be got from Xen. */
 	if (reg)
-		mtrr_overwrite_state(var, reg, MTRR_TYPE_UNCACHABLE);
+		guest_force_mtrr_state(var, reg, MTRR_TYPE_UNCACHABLE);
 #endif
 }
 
@@ -195,7 +195,7 @@ static void __init xen_pv_init_platform(void)
 	if (xen_initial_domain())
 		xen_set_mtrr_data();
 	else
-		mtrr_overwrite_state(NULL, 0, MTRR_TYPE_WRBACK);
+		guest_force_mtrr_state(NULL, 0, MTRR_TYPE_WRBACK);
 
 	/* Adjust nr_cpu_ids before "enumeration" happens */
 	xen_smp_count_cpus();
-- 
2.45.2


