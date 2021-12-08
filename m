Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777D746BEC6
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238594AbhLGPNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:13:11 -0500
Received: from mga14.intel.com ([192.55.52.115]:5480 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238582AbhLGPNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:13:08 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237821133"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237821133"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:09:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461289843"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:09:34 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 08/19] x86/fpu: Move xfd_update_state() to xstate.c and export symbol
Date:   Tue,  7 Dec 2021 19:03:48 -0500
Message-Id: <20211208000359.2853257-9-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

xfd_update_state() is the interface to update IA32_XFD and its per-cpu
cache. All callers of this interface are currently in fpu core. KVM only
indirectly triggers IA32_XFD update via a helper function
(fpu_swap_kvm_fpstate()) when switching between user fpu and guest fpu.

Supporting AMX in guest now requires KVM to directly update IA32_XFD
with the guest value (when emulating WRMSR) so XSAVE/XRSTOR can manage
XSTATE components correctly inside guest.

This patch moves xfd_update_state() from fpu/xstate.h to fpu/xstate.c
and export it for reference outside of fpu core.

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/include/asm/fpu/api.h |  2 ++
 arch/x86/kernel/fpu/xstate.c   | 12 ++++++++++++
 arch/x86/kernel/fpu/xstate.h   | 14 +-------------
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 7532f73c82a6..999d89026be9 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -131,8 +131,10 @@ DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
 /* Process cleanup */
 #ifdef CONFIG_X86_64
 extern void fpstate_free(struct fpu *fpu);
+extern void xfd_update_state(struct fpstate *fpstate);
 #else
 static inline void fpstate_free(struct fpu *fpu) { }
+static void xfd_update_state(struct fpstate *fpstate) { }
 #endif
 
 /* fpstate-related functions which are exported to KVM */
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index fe3d8ed3db0e..3c39789deeb9 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1750,6 +1750,18 @@ int xfd_enable_guest_features(struct fpu_guest *guest_fpu)
 	return __xfd_enable_feature(xfd_err, guest_fpu);
 }
 
+void xfd_update_state(struct fpstate *fpstate)
+{
+	if (fpu_state_size_dynamic()) {
+		u64 xfd = fpstate->xfd;
+
+		if (__this_cpu_read(xfd_state) != xfd) {
+			wrmsrl(MSR_IA32_XFD, xfd);
+			__this_cpu_write(xfd_state, xfd);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(xfd_update_state);
 #else /* CONFIG_X86_64 */
 static inline int xstate_request_perm(unsigned long idx, bool guest)
 {
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 3254e2b5f17f..651bd29977b9 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -149,19 +149,7 @@ static inline void xfd_validate_state(struct fpstate *fpstate, u64 mask, bool rs
 #endif
 
 #ifdef CONFIG_X86_64
-static inline void xfd_update_state(struct fpstate *fpstate)
-{
-	if (fpu_state_size_dynamic()) {
-		u64 xfd = fpstate->xfd;
-
-		if (__this_cpu_read(xfd_state) != xfd) {
-			wrmsrl(MSR_IA32_XFD, xfd);
-			__this_cpu_write(xfd_state, xfd);
-		}
-	}
-}
-#else
-static inline void xfd_update_state(struct fpstate *fpstate) { }
+extern void xfd_update_state(struct fpstate *fpstate);
 #endif
 
 /*
