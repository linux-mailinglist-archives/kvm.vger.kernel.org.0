Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76ADB7A0054
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbjINJie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbjINJiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:38:22 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB931BF2;
        Thu, 14 Sep 2023 02:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694684298; x=1726220298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mo0J7nmC7/MpnJ3d9RwhENdZi4KZZ89Pbi3lSWxz018=;
  b=gfsfPXzRKPscqyalcDfTKP10vg4ulbrXvfC9cSe/vgEgerL3h1RMhN3/
   +WIX3/LvPAyyCAKJ4M5OZh2anH0LHTsB1/b2KZKkIQnov9ONS6mgtPqze
   uc3/hZRD7VY8DWGR1Ffui2ppVgH9Ky3LuZ7TJtLjqE56diaJ/fut2lVmn
   8ZAcbhzfs+Tf5ZpcJDfHxEDDUoxVNEeIFK8XeJAvY7MoyTSXDi10Rkwav
   RsbJ3yg7L/+R0JG77FZfqkqdeK1HpUNsWRedPW2Tzc/H5YPJ6vW2q9Sll
   l8JNmiLQWShyZdeN/iHmObsNvXtKyB9vfi/6grwA8jXKpPRGhFtneT2Kw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="409857346"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="409857346"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="747656237"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="747656237"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:18 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v6 08/25] x86/fpu/xstate: WARN if normal fpstate contains kernel dynamic xfeatures
Date:   Thu, 14 Sep 2023 02:33:08 -0400
Message-Id: <20230914063325.85503-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914063325.85503-1-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

fpu_kernel_dynamic_xfeatures now are __ONLY__ enabled by guest kernel and
used for guest fpstate, i.e., none for normal fpstate. The bits are added
when guest fpstate is allocated and fpstate->is_guest set to %true.

For normal fpstate, the bits should have been removed when init system FPU
settings, WARN_ONCE() if normal fpstate contains kernel dynamic xfeatures
before xsaves is executed.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kernel/fpu/xstate.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 9c6e3ca05c5c..c2b33a5db53d 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -186,6 +186,9 @@ static inline void os_xsave(struct fpstate *fpstate)
 	WARN_ON_FPU(!alternatives_patched);
 	xfd_validate_state(fpstate, mask, false);
 
+	WARN_ON_FPU(!fpstate->is_guest &&
+		    (mask & fpu_kernel_dynamic_xfeatures));
+
 	XSTATE_XSAVE(&fpstate->regs.xsave, lmask, hmask, err);
 
 	/* We should never fault when copying to a kernel buffer: */
-- 
2.27.0

