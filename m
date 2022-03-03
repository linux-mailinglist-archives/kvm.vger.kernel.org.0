Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9FF4CB7BF
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiCCH2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiCCH2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:44 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE673DA5D
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292469; x=1677828469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=spaXWCL9cELMrFJ3ShOrqOYTZM2I4jQAfEYKi891ioU=;
  b=hzWFeRRaMSseaDiR0Rc3NKNTUM3j71CILNCJNzFkXvqN9SNnTmn082NC
   2yJnscDeg5/ebDm9YgljB0j0ugfaqH5LGwEJeEN4oe6T8R81aFU25OHPW
   ED0xG04tzQmWcNleKqKgEbvGROHWRvwEHpRgBWGUlktYPLFk2IWI6TVxe
   6dVahqDreb54UM2lKPv3ef3w4xtFVMsXF7UveOuVYnUql/2q8kQC7swwk
   TCLB8u0JE1ZwjvQ8OBAESb2cD0tAFOuJooM0SaQFVSPNA7MFqm4ys7dQ9
   51h1+bOtUGeurxir4LhgZ4Z8vrKRcPPSoraKjwsWpp9rzY7JW8KHKrIxx
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251177007"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251177007"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:47 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631722"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:44 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 11/17] x86 TDX: Add a formal IPI handler
Date:   Thu,  3 Mar 2022 15:19:01 +0800
Message-Id: <20220303071907.650203-12-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current IPI handler may currupts cpu context, it's not an big
issue as AP only enable interrupt in idle loop.

But in TD-guest, hlt instruction is simulated though tdvmcall
in #VE handler. IPI will currupt #VE context.

Save and restore cpu context in IPI handler to avoid crash.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 lib/x86/smp.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 2ac0ef74f264..8a37143c6d78 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -39,12 +39,20 @@ static __attribute__((used)) void ipi(void)
 
 asm (
      "ipi_entry: \n"
-     "   call ipi \n"
-#ifndef __x86_64__
-     "   iret"
-#else
-     "   iretq"
+#ifdef __x86_64__
+     "push %r15; push %r14; push %r13; push %r12 \n\t"
+     "push %r11; push %r10; push %r9; push %r8 \n\t"
 #endif
+     "push %"R "di; push %"R "si; push %"R "bp; \n\t"
+     "push %"R "bx; push %"R "dx; push %"R "cx; push %"R "ax \n\t"
+     "call ipi \n\t"
+     "pop %"R "ax; pop %"R "cx; pop %"R "dx; pop %"R "bx \n\t"
+     "pop %"R "bp; pop %"R "si; pop %"R "di \n\t"
+#ifdef __x86_64__
+     "pop %r8; pop %r9; pop %r10; pop %r11 \n\t"
+     "pop %r12; pop %r13; pop %r14; pop %r15 \n\t"
+#endif
+     "iret"W" \n\t"
      );
 
 int cpu_count(void)
-- 
2.25.1

