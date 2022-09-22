Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BF85E6CCC
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 22:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiIVUKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 16:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbiIVUKm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 16:10:42 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04009F1632;
        Thu, 22 Sep 2022 13:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663877441; x=1695413441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=zwFIpoguOuj1QO5SML3bAM3A0l1o0mNQhic7NOeMOsg=;
  b=TfF30m1xorxxA+JpC64nqx0F+xvwz31wTpZ6kew8Z2nwcdEwyiAlVnpq
   C5aCJ7m+bApli6wnEpF6hDpGb4c10Ed2d4IiYbaWWz0ej10zC5gSNUZ4i
   BoHzG0IXs9kGrIq4A+1sEUO3SyIh2vpos3XKu4vLWvP3btVLK0niDB41R
   exfx2ZKVmdR8Lww7+gu+hqHWJh8ygmUk+XW1Ra57PBc8SEi0ohaQGJun5
   afmU0jyNiuZVFbyOIzGIuj+nOVmMUyZs9+3LFfxlBvkLERWMiV/+jNh8V
   c3d+2xDEAFIn61eWaGRT8k5SowbCGnPbxXsJjN8UkI5n9wkmdBK326txc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="300404296"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="300404296"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 13:10:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="597592010"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
  by orsmga006.jf.intel.com with ESMTP; 22 Sep 2022 13:10:37 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, avagin@gmail.com,
        seanjc@google.com, chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v2 3/4] x86/fpu: Disallow legacy states from fpstate_clear_xstate_component()
Date:   Thu, 22 Sep 2022 13:00:33 -0700
Message-Id: <20220922200034.23759-4-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220922200034.23759-1-chang.seok.bae@intel.com>
References: <20220922200034.23759-1-chang.seok.bae@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 087df48c298c ("x86/fpu: Replace KVMs xstate component clearing")
refactored the MPX state clearing code.

But, legacy states are not warranted in this routine:
- It presumes every state is contiguous but that's not true for the legacy
  states. While MXCSR belongs to SSE, the state is located in the XSAVE
  buffer as surrounded by FP states.
- Also, zeroing out legacy states is not meaningful as their init state is
  non-zero.

It is possible to adjust the code to support them. Then, there is no use
for clearing legacy states yet. To make it simple, explicitly disallow
legacy states.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from v1 (Sean Christopherson):
* Revert the name change.
* Add a warning.
* Update title/changelog.
---
 arch/x86/kernel/fpu/xstate.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index d7676cfc32eb..a3f7045d1f8e 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1375,6 +1375,15 @@ void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfeature)
 {
 	void *addr = get_xsave_addr(&fps->regs.xsave, xfeature);
 
+	/*
+	 * Allow extended states only, because:
+	 * (1) Each legacy state is not contiguously located in the buffer.
+	 * (2) Zeroing those states is not meaningful as their init states
+	 *     are not zero.
+	 */
+	if (WARN_ON_ONCE(xfeature <= XFEATURE_SSE))
+		return;
+
 	if (addr)
 		memset(addr, 0, xstate_sizes[xfeature]);
 }
-- 
2.17.1

