Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107FB478FB0
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbhLQPaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:10848 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238226AbhLQPaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755007; x=1671291007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k8gT9oB/5YPUMem/eqQOfbKkI8IytJEMqRnBB5pWAb0=;
  b=kTyPyaCea+JVUjiwq+IWLSBESXvDm0SSHiLesF2Ohk2GkdLYh+ddt0No
   U2AMQQeDoKy44/cpjFtKabpEm7FUfattn/N/KjND+je4SCT9bBFMzEnUs
   qf2DqvnvWKrhNmhBoFoHpnLSV7G+RvOCozkWtb62Xiz8YogJMcRJwA0y9
   Jh82NYQU6xgZMnWPvzBZudvMAoX6y3vKjtMDoGudSasqSOPOiVk3JazUS
   BLcvf5uN8cHsDGOiYGodpjwVYIB3Dr4Jaso0NURBrGG/PkqTUFYv2lW6p
   xcu8jOstr5mHAlG3Jn2UZKysZF6wfYebdp+8zWw1OjXLQJGd/mgKDhEwQ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723449"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723449"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588428"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:05 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 10/23] x86/fpu: Provide fpu_update_guest_xfd() for IA32_XFD emulation
Date:   Fri, 17 Dec 2021 07:29:50 -0800
Message-Id: <20211217153003.1719189-11-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kevin Tian <kevin.tian@intel.com>

Guest XFD can be updated either in the emulation path or in the
restore path.

Provide a wrapper to update guest_fpu::fpstate::xfd. If the guest
fpstate is currently in-use, also update the per-cpu xfd cache and
the actual MSR.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/include/asm/fpu/api.h |  6 ++++++
 arch/x86/kernel/fpu/core.c     | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 8e934e571273..100b535cd3de 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -140,6 +140,12 @@ extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
 extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest);
 extern int fpu_update_guest_perm_features(struct fpu_guest *guest_fpu);
 
+#ifdef CONFIG_X86_64
+extern void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd);
+#else
+static inline void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd) { }
+#endif
+
 extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
 extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
 
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 2560a95980aa..3daea097c618 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -288,6 +288,18 @@ int fpu_update_guest_perm_features(struct fpu_guest *guest_fpu)
 }
 EXPORT_SYMBOL_GPL(fpu_update_guest_perm_features);
 
+#ifdef CONFIG_X86_64
+void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
+{
+	fpregs_lock();
+	guest_fpu->fpstate->xfd = xfd;
+	if (guest_fpu->fpstate->in_use)
+		xfd_update_state(guest_fpu->fpstate);
+	fpregs_unlock();
+}
+EXPORT_SYMBOL_GPL(fpu_update_guest_xfd);
+#endif /* CONFIG_X86_64 */
+
 int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
 {
 	struct fpstate *guest_fps = guest_fpu->fpstate;
-- 
2.27.0

