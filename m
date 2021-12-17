Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F59478FC8
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbhLQPap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:45 -0500
Received: from mga03.intel.com ([134.134.136.65]:10852 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238253AbhLQPaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755009; x=1671291009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ta2Eqb4PNg89gDFRCNYN06qBp8rwWdB7g3PLouU0Wug=;
  b=IM1QmYl2HaqkEN0KsErwTqhexgI+LcufLGpT5C75uIckqm3DdxAiIVQ3
   eaYV0WJouCCyYk1fFYg6IHMktiC0IJ06DXkoj+Cy8ToH9YFKSFeNBBbtT
   y6+2+8o4acFxo0ctkGHTUNzWKRq8PmfhH3Gf3E3Hwk2HeH0rXv4M41YNj
   QMDN+1xtvpYX8eKDSiW1P86iZmc9kdhodV2cQYI9f2afCXXZJmTEkajAF
   BGMQ/a1y67QqpAnpmX/QP4Pn5JdC+EmYGglp7SKNnkgGAyx8vsYoInklS
   AYobg6SZsroaWSlZp/TMySYdyi63lVuNWUFsAhy+5APUe7kA1VibeFbtf
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723476"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723476"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588475"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:06 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 21/23] x86/fpu: Provide fpu_sync_guest_vmexit_xfd_state()
Date:   Fri, 17 Dec 2021 07:30:01 -0800
Message-Id: <20211217153003.1719189-22-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

KVM can disable the write emulation for the XFD MSR when the vCPU's fpstate
is already correctly sized to reduce the overhead.

When write emulation is disabled the XFD MSR state after a VMEXIT is
unknown and therefore not in sync with the software states in fpstate and
the per CPU XFD cache.

Provide fpu_sync_guest_vmexit_xfd_state() which has to be invoked after a
VMEXIT before enabling interrupts when write emulation is disabled for the
XFD MSR.

It could be invoked unconditionally even when write emulation is enabled
for the price of a pointless MSR read.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/include/asm/fpu/api.h |  2 ++
 arch/x86/kernel/fpu/core.c     | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 100b535cd3de..dc51809f0e4a 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -142,8 +142,10 @@ extern int fpu_update_guest_perm_features(struct fpu_guest *guest_fpu);
 
 #ifdef CONFIG_X86_64
 extern void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd);
+extern void fpu_sync_guest_vmexit_xfd_state(void);
 #else
 static inline void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd) { }
+static inline void fpu_sync_guest_vmexit_xfd_state(void) { }
 #endif
 
 extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 89d679cc819b..42a195a6b2ce 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -299,6 +299,30 @@ void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
 	fpregs_unlock();
 }
 EXPORT_SYMBOL_GPL(fpu_update_guest_xfd);
+
+/**
+ * fpu_sync_guest_vmexit_xfd_state - Synchronize XFD MSR and software state
+ *
+ * Must be invoked from KVM after a VMEXIT before enabling interrupts when
+ * XFD write emulation is disabled. This is required because the guest can
+ * freely modify XFD and the state at VMEXIT is not guaranteed to be the
+ * same as the state on VMENTER. So software state has to be udpated before
+ * any operation which depends on it can take place.
+ *
+ * Note: It can be invoked unconditionally even when write emulation is
+ * enabled for the price of a then pointless MSR read.
+ */
+void fpu_sync_guest_vmexit_xfd_state(void)
+{
+	struct fpstate *fps = current->thread.fpu.fpstate;
+
+	lockdep_assert_irqs_disabled();
+	if (fpu_state_size_dynamic()) {
+		rdmsrl(MSR_IA32_XFD, fps->xfd);
+		__this_cpu_write(xfd_state, fps->xfd);
+	}
+}
+EXPORT_SYMBOL_GPL(fpu_sync_guest_vmexit_xfd_state);
 #endif /* CONFIG_X86_64 */
 
 int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
-- 
2.27.0

