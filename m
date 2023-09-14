Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A056479FBF3
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 08:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbjING25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 02:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbjING2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 02:28:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545B3F9;
        Wed, 13 Sep 2023 23:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694672925; x=1726208925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mo0J7nmC7/MpnJ3d9RwhENdZi4KZZ89Pbi3lSWxz018=;
  b=Y6uA6VCpNaCCxTjQV54+DXc5d3erxGQYYWtOWL2TV1I+q3Z5WvnFHWaJ
   JS47NT+1WT6NJz+Bd03btwzqy9u2sl3i5l1N/Dt26KEvkaDzyvka2szUU
   kcJn9q4lCAvSyS8GwqFd3KFYaEUaXjGM89ff8PP+l9GRg82+vOxiVZqk0
   wQk+NNOPy1mjmgAP/V0Fx8SNCSkY1Zl8rlfw5i3b/6xL6fbh1Fe3rfXFk
   32gOt5x0r8Jmon0WvaMzxgFn6NZlpM9nAhavdCndb7nVFMdCMua3hHCvq
   pFx/Xowb18L3tm9ne7fACJAD1eoU4aYoP7+E7MYVR0kq2LtJmAzv6Yh8Q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382672480"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382672480"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="809937999"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="809937999"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:44 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, peterz@infradead.org,
        seanjc@google.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
        kvm@vger.kernel.org, yang.zhong@intel.com, jing2.liu@intel.com,
        chao.gao@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 8/8] x86/fpu/xstate: WARN if normal fpstate contains kernel dynamic xfeatures
Date:   Wed, 13 Sep 2023 23:23:34 -0400
Message-Id: <20230914032334.75212-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914032334.75212-1-weijiang.yang@intel.com>
References: <20230914032334.75212-1-weijiang.yang@intel.com>
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

