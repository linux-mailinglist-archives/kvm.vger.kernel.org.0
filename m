Return-Path: <kvm+bounces-32316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FB9A9D53C3
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 21:15:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C29C3B226B9
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1BC61DA103;
	Thu, 21 Nov 2024 20:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jPdGFKPI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225221D86C0;
	Thu, 21 Nov 2024 20:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732220116; cv=none; b=BjjLkiUbOuSnwC6tToMaUhlqncB6Ylwfpt7OC2NRiOAkQsaStVimNunIioLZ43LzbmcYhHrGg1OF7RPmXdMziWnaazPCfgTiqWvXpK50YNZhQ37xK0pYTcfIBunI5g/IoIMK9FZ8LIFcIlkLXsXW+GHPAxe5AwJlPfBCZhBt8fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732220116; c=relaxed/simple;
	bh=yVO/Q8HE9TkANyC1SW60CkbycsVMbxMuXRRZMb4m8EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diGyU++2/LmIWYwT2zIPEGTk009bMMWu62r4oKd+IGZq7ooMN8WJtg3APW7Trn19Opzd6ydiNuMYu/0PCq3hSdnWwTux55FpjyUEZ5I5tyYiLzK2LieUmttmxmsfzCNdaxymeHjCpHoS/PsdWq3WDVYh+LzMmx60yvAz7Gr1ljk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jPdGFKPI; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732220115; x=1763756115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yVO/Q8HE9TkANyC1SW60CkbycsVMbxMuXRRZMb4m8EI=;
  b=jPdGFKPIpsBeKteUMfCclAofpdjVgIBA/i7Qk4RRKWjmcSQBCWh3zNnY
   t+eYmok9ewTmXt9e/W+iVJLk639Vh5Kg/5txQYmvx0ppgg64RSiYVv8Sy
   jKhYPF+x4cwKnEq4IR+5+ctAXLiCB7XbFKeNK4feCiQsuGxyGHQxj12Uh
   EIpNvHW3ETgsOA9OwsmaJrfiY564NYp65Tb6IsejblGJ6vWlNjEGEllQa
   CvPwoj9aL2oggg9fKKGYZXWThne5GUfKjZrIrV2anaZFY7kueJQX8Pl/r
   cY0ydNhuCyU2RSGJWGt+paR9MA6k71Ka6//r5Y7sfKwXxcGwHYqV8rWLT
   g==;
X-CSE-ConnectionGUID: D3HCVfPkQG+ZBFqxbONvdA==
X-CSE-MsgGUID: qVavSsY9QiixPVi/VKvI0w==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="31715841"
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="31715841"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 12:15:15 -0800
X-CSE-ConnectionGUID: YBAt5CoIToC2VREsAa1AkA==
X-CSE-MsgGUID: F2bUpwlHQ2GOGAklmiOurQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="90161079"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.16.81])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 12:15:09 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH RFC 1/7] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX guest
Date: Thu, 21 Nov 2024 22:14:40 +0200
Message-ID: <20241121201448.36170-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241121201448.36170-1-adrian.hunter@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

Intel TDX protects guest VM's from malicious host and certain physical
attacks.  TDX introduces a new operation mode, Secure Arbitration Mode
(SEAM) to isolate and protect guest VM's.  A TDX guest VM runs in SEAM and,
unlike VMX, direct control and interaction with the guest by the host VMM
is not possible.  Instead, Intel TDX Module, which also runs in SEAM,
provides a SEAMCALL API.

The SEAMCALL that provides the ability to enter a guest is TDH.VP.ENTER.
The TDX Module processes TDH.VP.ENTER, and enters the guest via VMX
VMLAUNCH/VMRESUME instructions.  When a guest VM-exit requires host VMM
interaction, the TDH.VP.ENTER SEAMCALL returns to the host VMM (KVM).

Add tdh_vp_enter() to wrap the SEAMCALL invocation of TDH.VP.ENTER.

TDH.VP.ENTER is different from other SEAMCALLS in several ways:
 - it may take some time to return as the guest executes
 - it uses more arguments
 - after it returns some host state may need to be restored

TDH.VP.ENTER arguments are passed through General Purpose Registers (GPRs).
For the special case of the TD guest invoking TDG.VP.VMCALL, nearly any GPR
can be used, as well as XMM0 to XMM15. Notably, RBP is not used, and Linux
mandates the TDX Module feature NO_RBP_MOD, which is enforced elsewhere.
Additionally, XMM registers are not required for the existing Guest
Hypervisor Communication Interface and are handled by existing KVM code
should they be modified by the guest.

There are 2 input formats and 5 output formats for TDH.VP.ENTER arguments.
Input #1 : Initial entry or following a previous async. TD Exit
Input #2 : Following a previous TDCALL(TDG.VP.VMCALL)
Output #1 : On Error (No TD Entry)
Output #2 : Async. Exits with a VMX Architectural Exit Reason
Output #3 : Async. Exits with a non-VMX TD Exit Status
Output #4 : Async. Exits with Cross-TD Exit Details
Output #5 : On TDCALL(TDG.VP.VMCALL)

Currently, to keep things simple, the wrapper function does not attempt
to support different formats, and just passes all the GPRs that could be
used.  The GPR values are held by KVM in the area set aside for guest
GPRs.  KVM code uses the guest GPR area (vcpu->arch.regs[]) to set up for
or process results of tdh_vp_enter().

Therefore changing tdh_vp_enter() to use more complex argument formats
would also alter the way KVM code interacts with tdh_vp_enter().

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/include/asm/tdx.h  | 1 +
 arch/x86/virt/vmx/tdx/tdx.c | 8 ++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 1 +
 3 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index fdc81799171e..77477b905dca 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -123,6 +123,7 @@ int tdx_guest_keyid_alloc(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
 /* SEAMCALL wrappers for creating/destroying/running TDX guests */
+u64 tdh_vp_enter(u64 tdvpr, struct tdx_module_args *args);
 u64 tdh_mng_addcx(u64 tdr, u64 tdcs);
 u64 tdh_mem_page_add(u64 tdr, u64 gpa, u64 hpa, u64 source, u64 *rcx, u64 *rdx);
 u64 tdh_mem_sept_add(u64 tdr, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 04cb2f1d6deb..2a8997eb1ef1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1600,6 +1600,14 @@ static inline u64 tdx_seamcall_sept(u64 op, struct tdx_module_args *in)
 	return ret;
 }
 
+u64 tdh_vp_enter(u64 tdvpr, struct tdx_module_args *args)
+{
+	args->rcx = tdvpr;
+
+	return __seamcall_saved_ret(TDH_VP_ENTER, args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_enter);
+
 u64 tdh_mng_addcx(u64 tdr, u64 tdcs)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 4919d00025c9..58d5754dcb4d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -17,6 +17,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_VP_ENTER			0
 #define TDH_MNG_ADDCX			1
 #define TDH_MEM_PAGE_ADD		2
 #define TDH_MEM_SEPT_ADD		3
-- 
2.43.0


