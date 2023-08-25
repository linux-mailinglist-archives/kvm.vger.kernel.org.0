Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B887886D2
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 14:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244644AbjHYMQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 08:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244586AbjHYMPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 08:15:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3D91B2;
        Fri, 25 Aug 2023 05:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692965747; x=1724501747;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jQXEz4wcD0gQvdifjvlTq7EQaYP21xof7fYHiYzoN/Q=;
  b=baOHcD7BtdtaeR2RqUEt0C1gjW2rrQ2H8v6gIBCbwBXgl/4eAFRrm7Rw
   +grF6ANNmU0Qg8ZrAZxLLYx7lP0o53uHo9/bmSEKhNIXo7W5CTP1Lvafx
   BPuPndHUdKsZUzCIjrg6AuGZSTIfFK+KzDUmuIMfieYJMumMgETmQLxF0
   DGuSDWa4zHCiXV83AvsKjpaCniC9FAnmD/scw/dd1H9kWGmNaoe8g9cVT
   qmQd8/L63DT9Gpyz+KGXG0mX30MKVXAfMGbHwcPLnDTCeaL7LauoIlGGo
   UNPaJUwoWiVmMGy0eiRccPp9dIGiqLhtsXS76QkwSJLw/4H0PAX6A3/LV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="438639223"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="438639223"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:15:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881158112"
Received: from vnaikawa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.185.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:15:30 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v13 06/22] x86/virt/tdx: Add SEAMCALL error printing for module initialization
Date:   Sat, 26 Aug 2023 00:14:25 +1200
Message-ID: <3b9ddfb377a944393b2a93f963cd902232a5ee33.1692962263.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692962263.git.kai.huang@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX module initialization is essentially to make a set of SEAMCALL leafs
to complete a state machine involving multiple states.  These SEAMCALLs
are not expected to fail.  In fact, they are not expected to return any
non-zero code (except the "running out of entropy error", which can be
handled internally already).

Add yet another layer of SEAMCALL wrappers, which treats all non-zero
return code as error, to support printing SEAMCALL error upon failure
for module initialization.

Other SEAMCALLs may treat some specific error codes as legal (e.g., some
can return BUSY legally and expect the caller to retry).  The caller can
use the wrappers w/o error printing for those cases.  The new wrappers
can also be improved to suit those cases.  Leave this as future work.

SEAMCALL can also return kernel defined error codes for three special
cases: 1) TDX isn't enabled by the BIOS; 2) TDX module isn't loaded; 3)
CPU isn't in VMX operation.  The first case isn't expected (unless BIOS
bug, etc) because SEAMCALL is only expected to be made when the kernel
detects TDX is enabled.  The second case is only expected to be legal
for the very first SEAMCALL during module initialization.  The third
case can be legal for any SEAMCALL leaf because VMX can be disabled due
to emergency reboot.

Also add wrappers to convert the SEAMCALL error code to the kernel error
code so that each caller doesn't have to repeat.  Blindly print error
for the above special cases to save the effort to optimize them.

TDX module can only be initialized once during its life cycle, but the
module can be runtime updated by the kernel (not yet supported).  After
module runtime update, the kernel needs to initialize it again.  Use
pr_err() to print SEAMCALL error for module initialization, because if
using pr_err_once() the SEAMCALL error during module initialization
won't be printed after module runtime update.

At last, for now implement those wrappers in tdx.c but they can be moved
to <asm/tdx.h> when needed.  They are implemented with intention to be
shared by other kernel components.  After all, in most cases, SEAMCALL
failure is unexpected and the caller just wants to print.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v12 -> v13:
 - New implementation due to TDCALL assembly series.

---
 arch/x86/include/asm/tdx.h  |  1 +
 arch/x86/virt/vmx/tdx/tdx.c | 84 +++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index cfae8b31a2e9..3b248c94a4a4 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -27,6 +27,7 @@
 /*
  * TDX module SEAMCALL leaf function error codes
  */
+#define TDX_SUCCESS		0ULL
 #define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
 
 #ifndef __ASSEMBLY__
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 908590e85749..bb63cb7361c8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -16,6 +16,90 @@
 #include <asm/msr.h>
 #include <asm/tdx.h>
 
+#define seamcall_err(__fn, __err, __args, __prerr_func)			\
+	__prerr_func("SEAMCALL (0x%llx) failed: 0x%llx\n",		\
+			((u64)__fn), ((u64)__err))
+
+#define SEAMCALL_REGS_FMT						\
+	"RCX 0x%llx RDX 0x%llx R8 0x%llx R9 0x%llx R10 0x%llx R11 0x%llx\n"
+
+#define seamcall_err_ret(__fn, __err, __args, __prerr_func)		\
+({									\
+	seamcall_err((__fn), (__err), (__args), __prerr_func);		\
+	__prerr_func(SEAMCALL_REGS_FMT,					\
+			(__args)->rcx, (__args)->rdx, (__args)->r8,	\
+			(__args)->r9, (__args)->r10, (__args)->r11);	\
+})
+
+#define SEAMCALL_EXTRA_REGS_FMT	\
+	"RBX 0x%llx RDI 0x%llx RSI 0x%llx R12 0x%llx R13 0x%llx R14 0x%llx R15 0x%llx"
+
+#define seamcall_err_saved_ret(__fn, __err, __args, __prerr_func)	\
+({									\
+	seamcall_err_ret(__fn, __err, __args, __prerr_func);		\
+	__prerr_func(SEAMCALL_EXTRA_REGS_FMT,				\
+			(__args)->rbx, (__args)->rdi, (__args)->rsi,	\
+			(__args)->r12, (__args)->r13, (__args)->r14,	\
+			(__args)->r15);					\
+})
+
+static __always_inline bool seamcall_err_is_kernel_defined(u64 err)
+{
+	/* All kernel defined SEAMCALL error code have TDX_SW_ERROR set */
+	return (err & TDX_SW_ERROR) == TDX_SW_ERROR;
+}
+
+#define __SEAMCALL_PRERR(__seamcall_func, __fn, __args, __seamcall_err_func,	\
+			__prerr_func)						\
+({										\
+	u64 ___sret = __seamcall_func((__fn), (__args));			\
+										\
+	/* Kernel defined error code has special meaning, leave to caller */	\
+	if (!seamcall_err_is_kernel_defined((___sret)) &&			\
+			___sret != TDX_SUCCESS)					\
+		__seamcall_err_func((__fn), (___sret), (__args), __prerr_func);	\
+										\
+	___sret;								\
+})
+
+#define SEAMCALL_PRERR(__seamcall_func, __fn, __args, __seamcall_err_func)	\
+({										\
+	u64 ___sret = __SEAMCALL_PRERR(__seamcall_func, __fn, __args,		\
+			__seamcall_err_func, pr_err);				\
+	int ___ret;								\
+										\
+	switch (___sret) {							\
+	case TDX_SUCCESS:							\
+		___ret = 0;							\
+		break;								\
+	case TDX_SEAMCALL_VMFAILINVALID:					\
+		pr_err("SEAMCALL failed: TDX module not loaded.\n");		\
+		___ret = -ENODEV;						\
+		break;								\
+	case TDX_SEAMCALL_GP:							\
+		pr_err("SEAMCALL failed: TDX disabled by BIOS.\n");		\
+		___ret = -EOPNOTSUPP;						\
+		break;								\
+	case TDX_SEAMCALL_UD:							\
+		pr_err("SEAMCALL failed: CPU not in VMX operation.\n");		\
+		___ret = -EACCES;						\
+		break;								\
+	default:								\
+		___ret = -EIO;							\
+	}									\
+	___ret;									\
+})
+
+#define seamcall_prerr(__fn, __args)						\
+	SEAMCALL_PRERR(seamcall, (__fn), (__args), seamcall_err)
+
+#define seamcall_prerr_ret(__fn, __args)					\
+	SEAMCALL_PRERR(seamcall_ret, (__fn), (__args), seamcall_err_ret)
+
+#define seamcall_prerr_saved_ret(__fn, __args)					\
+	SEAMCALL_PRERR(seamcall_saved_ret, (__fn), (__args),			\
+			seamcall_err_saved_ret)
+
 static u32 tdx_global_keyid __ro_after_init;
 static u32 tdx_guest_keyid_start __ro_after_init;
 static u32 tdx_nr_guest_keyids __ro_after_init;
-- 
2.41.0

