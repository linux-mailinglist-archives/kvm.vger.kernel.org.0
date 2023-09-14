Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767317A004A
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbjINJiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235604AbjINJiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:38:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769FB83;
        Thu, 14 Sep 2023 02:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694684296; x=1726220296;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GCpk9GKZRRCMIQFL0D0NzM82+1bNcf1kwTMzwzthcgA=;
  b=cDIdwRKuoPTGI/WjCaaxW/Olk3zhTefEYBrEPNYRlQZmO1e5XXntAdO9
   gHXyXLX6rc1YCtV3lxQ3IiCvRiaYpZHA8R8/W516ufKvtDabcKJWo5pmy
   7w/3RuhjH/JWG54Wj7qKuxLliNvQv1s/5DdxwOh1VZbOCq/QnaCx5CGEa
   sLKynkOMKRtX1SdkltkQowdEpZ4EDg+pzO1idyiJSdfoZaNucm5fNUxh1
   TMYsIpcIa74EYC+riVLEfX+1ulBUTY+OBN0X5isXBOsxr4lGe03tr1/FR
   Zh+cwwTJgb0DIeKoJC/Rcly/cpfoI1dgmQB76OqzaTJ7Xq2DbkP/B9gBy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="409857313"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="409857313"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="747656212"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="747656212"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:15 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v6 02/25] x86/fpu/xstate: Fix guest fpstate allocation size calculation
Date:   Thu, 14 Sep 2023 02:33:02 -0400
Message-Id: <20230914063325.85503-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914063325.85503-1-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix guest xsave area allocation size from fpu_user_cfg.default_size to
fpu_kernel_cfg.default_size so that the xsave area size is consistent
with fpstate->size set in __fpstate_reset().

With the fix, guest fpstate size is sufficient for KVM supported guest
xfeatures.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kernel/fpu/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index a86d37052a64..a42d8ad26ce6 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -220,7 +220,9 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	struct fpstate *fpstate;
 	unsigned int size;
 
-	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
+	size = fpu_kernel_cfg.default_size +
+	       ALIGN(offsetof(struct fpstate, regs), 64);
+
 	fpstate = vzalloc(size);
 	if (!fpstate)
 		return false;
-- 
2.27.0

