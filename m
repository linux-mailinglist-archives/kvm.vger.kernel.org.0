Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67CF478FAC
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238268AbhLQPaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:10848 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238213AbhLQPaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755005; x=1671291005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7dXZPVEDoLzyZy2Pl21Dl3pKMjJYI7sq2Em4vBDIQI4=;
  b=ljOjIuMH7GSEiBc9Y9xaW8M4nRZNDzAq1SQQSzh262ZBoI39Z49xbIkD
   kfVIxBinc7N/btRS2jUChqPBrPqtNnSoxbiFiR9PxCfwIqcNfkL01Knd3
   ixedGFt9/h+hDZpsLJkej98IIKJ/yBeFCX+5FzdjgJ093aFN/tO3wecQE
   pGlUfilrOmj/JEcmw+xYvMeraVDEXbIG1YfzFAK/7gjUV54foI4xGBn28
   cL8n3g3/tT4UlNhaX5XESUiZZpSVQv1o+N12f7/A/9zmBsh9+HpLZTy2P
   YoWf1TGxvw4is1BwXhSyXrRnnwvIXmlzvLaOhjW8jZBkVndb9p1/w6n4o
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723439"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723439"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588407"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:04 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 06/23] x86/fpu: Make XFD initialization in __fpstate_reset() a function argument
Date:   Fri, 17 Dec 2021 07:29:46 -0800
Message-Id: <20211217153003.1719189-7-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vCPU threads are different from native tasks regarding to the initial XFD
value. While all native tasks follow a fixed value (init_fpstate::xfd)
established by the FPU core at boot, vCPU threads need to obey the reset
value (i.e. ZERO) defined by the specification, to meet the expectation of
the guest.

Let the caller supply an argument and adjust the host and guest related
invocations accordingly.

Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/kernel/fpu/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index eddeeb4ed2f5..a78bc547fc03 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -199,7 +199,7 @@ void fpu_reset_from_exception_fixup(void)
 }
 
 #if IS_ENABLED(CONFIG_KVM)
-static void __fpstate_reset(struct fpstate *fpstate);
+static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
 
 static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
 {
@@ -231,7 +231,8 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	if (!fpstate)
 		return false;
 
-	__fpstate_reset(fpstate);
+	/* Leave xfd to 0 (the reset value defined by spec) */
+	__fpstate_reset(fpstate, 0);
 	fpstate_init_user(fpstate);
 	fpstate->is_valloc	= true;
 	fpstate->is_guest	= true;
@@ -454,21 +455,21 @@ void fpstate_init_user(struct fpstate *fpstate)
 		fpstate_init_fstate(fpstate);
 }
 
-static void __fpstate_reset(struct fpstate *fpstate)
+static void __fpstate_reset(struct fpstate *fpstate, u64 xfd)
 {
 	/* Initialize sizes and feature masks */
 	fpstate->size		= fpu_kernel_cfg.default_size;
 	fpstate->user_size	= fpu_user_cfg.default_size;
 	fpstate->xfeatures	= fpu_kernel_cfg.default_features;
 	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
-	fpstate->xfd		= init_fpstate.xfd;
+	fpstate->xfd		= xfd;
 }
 
 void fpstate_reset(struct fpu *fpu)
 {
 	/* Set the fpstate pointer to the default fpstate */
 	fpu->fpstate = &fpu->__fpstate;
-	__fpstate_reset(fpu->fpstate);
+	__fpstate_reset(fpu->fpstate, init_fpstate.xfd);
 
 	/* Initialize the permission related info in fpu */
 	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
-- 
2.27.0

