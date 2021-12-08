Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6048746BED6
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbhLGPNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:13:34 -0500
Received: from mga14.intel.com ([192.55.52.115]:5593 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238668AbhLGPNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:13:24 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237821219"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237821219"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:09:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461289971"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:09:50 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 12/19] x86/fpu: Prepare KVM for bringing XFD state back in-sync
Date:   Tue,  7 Dec 2021 19:03:52 -0500
Message-Id: <20211208000359.2853257-13-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Guest may toggle IA32_XFD in high frequency as it is part of the fpstate
information (features, sizes, xfd) and swapped in task context switch.

To minimize the trap overhead of writes to this MSR, one optimization
is to allow guest direct write thus eliminate traps. However MSR
passthrough implies that guest_fpstate::xfd and per-cpu xfd cache might
be out of sync with the current IA32_XFD value by the guest.

This suggests KVM needs to re-sync guest_fpstate::xfd and per-cpu cache
with IA32_XFD before the vCPU thread might be preempted or interrupted.

This patch provides a helper function for the re-sync purpose.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
(To Thomas): the original name kvm_update_guest_xfd_state() in
your sample code is renamed to xfd_sync_state() in this patch. In
concept it is a general helper to bring software values in-sync with
the MSR value after they become out-of-sync. KVM is just the
first out-of-sync usage on this helper, so a neutral name may make
more sense. But if you prefer to the original name we can also
change back.

 arch/x86/include/asm/fpu/xstate.h |  2 ++
 arch/x86/kernel/fpu/xstate.c      | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index cd3dd170e23a..c8b51d34daab 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -129,4 +129,6 @@ static __always_inline __pure bool fpu_state_size_dynamic(void)
 }
 #endif
 
+extern void xfd_sync_state(void);
+
 #endif
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 3c39789deeb9..a5656237a763 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1762,11 +1762,25 @@ void xfd_update_state(struct fpstate *fpstate)
 	}
 }
 EXPORT_SYMBOL_GPL(xfd_update_state);
+
+/* Bring software state in sync with the current MSR value */
+void xfd_sync_state(void)
+{
+	if (fpu_state_size_dynamic()) {
+		u64 xfd;
+
+		rdmsrl(MSR_IA32_XFD, xfd);
+		current->thread.fpu.fpstate->xfd = xfd;
+		__this_cpu_write(xfd_state, xfd);
+	}
+}
+EXPORT_SYMBOL_GPL(xfd_sync_state);
 #else /* CONFIG_X86_64 */
 static inline int xstate_request_perm(unsigned long idx, bool guest)
 {
 	return -EPERM;
 }
+void xfd_sync_state(void) {}
 #endif  /* !CONFIG_X86_64 */
 
 inline u64 xstate_get_guest_group_perm(void)
