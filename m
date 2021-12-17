Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A8F478FB6
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbhLQPaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:10842 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238221AbhLQPaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755008; x=1671291008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zAEHvRs3p4TZZV08wBtJSf3RNrbNkqEnul3jvvQ3jcg=;
  b=nQQu9xp0NsaDjPNRjgg8p+Ia+RaqF14R5NU7DECAVA22jKaMsbpBPY4Q
   JLF3mcU1xdFne2SwQLq5scKNurmJAD3708JOOBEnHhGaPjVF1ajfV48/n
   dkulbfzi3LgLcQRQlshhjc3qYLzU5+tOXhIrl3fF1Pxi5k5oRnDSlWZL9
   GgpmdAQgAp11GwtO3xEJHg244cSOXyD7Dqq/7reCICr3E1wGjeYUZLdHj
   ghwDLbYxvHhG7pClJMCHuy/GLTaGiFV7cGD5Exe0SMMXl918D0eOBZhuQ
   KydsiFIaarLo66icJhwoGI05+Vhj2nlRgo8l3aCVhGFBN8K4Qn8k9grVq
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723464"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723464"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588461"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:06 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 17/23] x86/fpu: add uabi_size to guest_fpu
Date:   Fri, 17 Dec 2021 07:29:57 -0800
Message-Id: <20211217153003.1719189-18-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Userspace needs to inquire KVM about the buffer size to work
with the new KVM_SET_XSAVE and KVM_GET_XSAVE2. Add the size info
to guest_fpu for KVM to access.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/include/asm/fpu/types.h | 5 +++++
 arch/x86/kernel/fpu/core.c       | 1 +
 arch/x86/kernel/fpu/xstate.c     | 1 +
 3 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 3795d0573773..eb7cd1139d97 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -522,6 +522,11 @@ struct fpu_guest {
 	 */
 	u64				xfd_err;
 
+	/*
+	 * @uabi_size:			Size required for save/restore
+	 */
+	unsigned int			uabi_size;
+
 	/*
 	 * @fpstate:			Pointer to the allocated guest fpstate
 	 */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 3daea097c618..89d679cc819b 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -240,6 +240,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	gfpu->fpstate		= fpstate;
 	gfpu->xfeatures		= fpu_user_cfg.default_features;
 	gfpu->perm		= fpu_user_cfg.default_features;
+	gfpu->uabi_size		= fpu_user_cfg.default_size;
 	fpu_init_guest_permissions(gfpu);
 
 	return true;
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index b0925051b0b6..4cb1f69c50c6 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1545,6 +1545,7 @@ static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
 		newfps->is_confidential = curfps->is_confidential;
 		newfps->in_use = curfps->in_use;
 		guest_fpu->xfeatures |= xfeatures;
+		guest_fpu->uabi_size = usize;
 	}
 
 	fpregs_lock();
-- 
2.27.0

