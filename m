Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AF9478FDE
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238713AbhLQPbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:31:08 -0500
Received: from mga03.intel.com ([134.134.136.65]:10848 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238219AbhLQPaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755006; x=1671291006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4zf2XhN+pJn1URvKvn8kauagNWE4KhwPv1N796bD7S0=;
  b=JNWavPRqJUGcczsm+7zUrOHG94BDvrF1TAzu1RIIQBC0D+ne0vhfQrgA
   PHF4rjCSq/8+UBbMLxqy83OcN+q6QcBK0ilACs1g2/5le4Blidy7JNAC+
   9z65vP5ppkTtQznV03njtyc7LrUYTd8RvEBG76Qh75adl3HXn+NxOf2RC
   W6wPjsCcUTWbu5pF+GuRmyPRJg+v4N5xw8JskY+JygRwGT3iklqj6H2eo
   gDXReYXipGq22vIfJFbg+QRbxzBoRfIVK10Ni4js0aQFeCgyaCJZEvlc7
   1YHNriMFWNsvH6L7W6YZKVwVvEgqamOxyrfjPHV5blc8JVgNpODRfB+Nm
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723445"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723445"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588414"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:04 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 08/23] x86/fpu: Provide fpu_update_guest_perm_features() for guest
Date:   Fri, 17 Dec 2021 07:29:48 -0800
Message-Id: <20211217153003.1719189-9-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kevin Tian <kevin.tian@intel.com>

KVM can require fpstate expansion in two approaches:

  1) Dynamic expansion when intercepting guest updates to XCR0 and
     XFD MSR;

  2) Static expansion e.g. at KVM_SET_CPUID2;

The first option doesn't waste memory for legacy guest if it doesn't
support XFD. However doing so introduces more complexity and also
imposes an order requirement in the restoring path, i.e. XCR0/XFD
must be restored before XSTATE.

Given that the agreement is to do the static approach. This is
considered a better tradeoff though it does waste 8K memory for
legacy guest if its CPUID includes XFD features.

Provide a wrapper to allow expanding the fpstate buffer to what
guest perm allows. Once completed, both emulation and restore path
don't need to worry about the buffer size.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/include/asm/fpu/api.h |  1 +
 arch/x86/kernel/fpu/core.c     | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index d8c222290e68..8e934e571273 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -138,6 +138,7 @@ extern inline u64 xstate_get_guest_group_perm(void);
 extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
 extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
 extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest);
+extern int fpu_update_guest_perm_features(struct fpu_guest *guest_fpu);
 
 extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
 extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index a78bc547fc03..2560a95980aa 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -261,6 +261,33 @@ void fpu_free_guest_fpstate(struct fpu_guest *gfpu)
 }
 EXPORT_SYMBOL_GPL(fpu_free_guest_fpstate);
 
+/*
+ * fpu_update_guest_perm_features - Enable xfeatures according to guest perm
+ * @guest_fpu:		Pointer to the guest FPU container
+ *
+ * Enable all dynamic xfeatures according to guest perm. Invoked if the
+ * caller wants to conservatively expand fpstate buffer instead of waiting
+ * until XCR0 or XFD MSR is written.
+ *
+ * Return: 0 on success, error code otherwise
+ */
+int fpu_update_guest_perm_features(struct fpu_guest *guest_fpu)
+{
+	u64 expand;
+
+	lockdep_assert_preemption_enabled();
+
+	if (!IS_ENABLED(CONFIG_X86_64))
+		return 0;
+
+	expand = guest_fpu->perm & ~guest_fpu->xfeatures;
+	if (!expand)
+		return 0;
+
+	return __xfd_enable_feature(expand, guest_fpu);
+}
+EXPORT_SYMBOL_GPL(fpu_update_guest_perm_features);
+
 int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
 {
 	struct fpstate *guest_fps = guest_fpu->fpstate;
-- 
2.27.0

