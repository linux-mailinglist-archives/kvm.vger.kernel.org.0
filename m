Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F1979FA5F
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 07:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbjINFT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 01:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbjINFTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 01:19:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2661FDE;
        Wed, 13 Sep 2023 22:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694668762; x=1726204762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vZ6vels66+tC8YRpSCj8dEsAAUPLXovJkO1WpIp9s0Y=;
  b=K69NdO6K32mKD65wvuc7+o8TLuc8W//zfepoDPWD37CLmifV9V7SkCqh
   W56/I8Li0lj6K9ty0OXjvqwKEc4yI6erTwc3ld/MuEOlFA7VFww3MTJZW
   w8C/bqW8jkhS9yxzaxxsi3jpDDV+/98+Qk8ZEk4skUK/1IsRyNHek0b2E
   /NP4L05K1bnTVwcKZ73LzrIGaobRxr7B/tyFzpYvSck/ypUsti4ABe6XB
   XvaJd6V3qmMn4gM4Kt9zHiUwJ/L+iFWOFCl611f3s6st3tbfoJ7Fg5/Is
   sf0BOARuZqIX5/op/dQjSsDFvCai0D1J3DYd248CNWbdmZtSIBjhF4IKD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382661368"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382661368"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 22:17:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779488808"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779488808"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2023 22:17:40 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com
Subject: [PATCH v10 23/38] x86/fred: Make exc_page_fault() work for FRED
Date:   Wed, 13 Sep 2023 21:47:50 -0700
Message-Id: <20230914044805.301390-24-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914044805.301390-1-xin3.li@intel.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

On a FRED system, the faulting address (CR2) is passed on the stack,
to avoid the problem of transient state. Thus we get the page fault
address from the stack instead of CR2.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/mm/fault.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index ab778eac1952..7675bc067153 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -34,6 +34,7 @@
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
 #include <asm/irq_stack.h>
+#include <asm/fred.h>
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -1516,8 +1517,10 @@ handle_page_fault(struct pt_regs *regs, unsigned long error_code,
 
 DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 {
-	unsigned long address = read_cr2();
 	irqentry_state_t state;
+	unsigned long address;
+
+	address = cpu_feature_enabled(X86_FEATURE_FRED) ? fred_event_data(regs) : read_cr2();
 
 	prefetchw(&current->mm->mmap_lock);
 
-- 
2.34.1

