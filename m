Return-Path: <kvm+bounces-32810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B80859DFB40
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 08:32:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18ECF163D53
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 07:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528C31F9420;
	Mon,  2 Dec 2024 07:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fkzbt0Lb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AC4481A3;
	Mon,  2 Dec 2024 07:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733124717; cv=none; b=tDLUd2QtLW+bSOQj+KQi3realXEMQOnUY+rY46sEEKxGK/B9dOf94NazL+D3eD+hzY0/1gHDTiUhLxuXvaDhCFOhsIt/KfWoOSeHzbapU0ML+e86eMKjF2/KukY3X2nIuPFNe0wCq5US+jDhn6fornc75KmSbljJfjy5EzizBSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733124717; c=relaxed/simple;
	bh=M15az0QjHwqSnaRdQ3vhhyKn2F1zyuHqY37H2ln+rKo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TTCd7Serp7RBEiEDhyeP3NfLCoypPx+JIl5yJ5iCPR4H2X+ZQ6fsr6qWyTZxagb4r5hs8AaJ0hMnWQjKT0bLaQ8rwFyk4hZvC1Tt7o9k5rBrPMJpboQ8E0Vdyz/g6N1sjrz57LEhgHsdAwStXhZQvOvUHpQph1wfgsuv9DE3j64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fkzbt0Lb; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733124716; x=1764660716;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=M15az0QjHwqSnaRdQ3vhhyKn2F1zyuHqY37H2ln+rKo=;
  b=Fkzbt0LbwANoVMZOnOMOGN9KegQmN+4B2twy60b+dacxO1/ZRMn8sDyK
   nmbXskvoMWdQ9/pta7s0KPr7M1JIOjWiwhB0dkptCT4AHcVhHdZkPLlNI
   sosDAThdXXUULFw/n4/lNakbAgBOc93euzbRW6GaxWTkGyw0WMdCCff0g
   KLemb1iDADJDNqG1VVxhDWK6QzmUcIt1gNAUYS++imkPkAl0D4ZfPdowF
   XQuqr38nug6y1uvkotcJOWr5drkMr6K9jZJ1JvT6N6cqI+flMJkiBRzak
   26bMcXZ1khCXMmZlRuG7bK+EDqAG8K2oYKbweCyX3jpmkcSiezqloInw3
   A==;
X-CSE-ConnectionGUID: kCbXoUWcSSOgDEpG9C5c3Q==
X-CSE-MsgGUID: CpOzjEvMRA6nQFa4ftyZ0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11273"; a="36943343"
X-IronPort-AV: E=Sophos;i="6.12,201,1728975600"; 
   d="scan'208";a="36943343"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2024 23:31:55 -0800
X-CSE-ConnectionGUID: 5gTE3+swTUCPaC+Chly83w==
X-CSE-MsgGUID: 9RWjv968Rkar/vBJ99Abxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,201,1728975600"; 
   d="scan'208";a="93408303"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa007.jf.intel.com with ESMTP; 01 Dec 2024 23:31:49 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id B58773B2; Mon, 02 Dec 2024 09:31:47 +0200 (EET)
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
Subject: [PATCH, RESEND] x86/mtrr: Rename mtrr_overwrite_state() to guest_force_mtrr_state()
Date: Mon,  2 Dec 2024 09:31:39 +0200
Message-ID: <20241202073139.448208-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.45.2
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
Acked-by: Dave Hansen <dave.hansen@intel.com>
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


