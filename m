Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023F96DC488
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 10:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjDJIlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 04:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjDJIlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 04:41:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB554C09;
        Mon, 10 Apr 2023 01:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681116069; x=1712652069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SfNRJW38HST/J2vYBy+d2Rz7YNwfS+VaJzsap6qMLmE=;
  b=C9yUxN4X244YfRWtbiSnMj3bgEsXKKaRL0nEllyVHsjwdgRRBB/743QA
   xEslhgA4LXswm7dbKrT2oWx664irKr7slEPTJ6McNPaIKoGaV3EFWgRk7
   ir5eD4m45LrEIhgZg9rOCjnf+BMuP99GoStbrGYW3TvoHodBIzou6AOdK
   wnwjh/RsjIhjn019N95Eg2thByxnKJkLYg6+vLAhZXUI6JRu/vGZ1edfY
   LCFNh3y7Ns170D5Pe6YNXntYwI+y0l1dtjkdBIpAP8coXhejYWoqLqDBr
   c8U7PuXjrApx7f4eQONnVg/ygbSoid12aaqHD+diMUjhLMGOGQla0znWy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="342078107"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="342078107"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 01:41:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="799436328"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="799436328"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga002.fm.intel.com with ESMTP; 10 Apr 2023 01:41:06 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v8 22/33] x86/fred: update MSR_IA32_FRED_RSP0 during task switch
Date:   Mon, 10 Apr 2023 01:14:27 -0700
Message-Id: <20230410081438.1750-23-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230410081438.1750-1-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

MSR_IA32_FRED_RSP0 is used during ring 3 event delivery, and needs to
be updated to point to the top of next task stack during task switch.

Update MSR_IA32_FRED_RSP0 with WRMSR instruction for now, and will use
WRMSRNS/WRMSRLIST for performance once it gets upstreamed.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/switch_to.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index 5c91305d09d2..00fd85abc1d2 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -68,9 +68,16 @@ static inline void update_task_stack(struct task_struct *task)
 #ifdef CONFIG_X86_32
 	this_cpu_write(cpu_tss_rw.x86_tss.sp1, task->thread.sp0);
 #else
-	/* Xen PV enters the kernel on the thread stack. */
-	if (cpu_feature_enabled(X86_FEATURE_XENPV))
+	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
+		/*
+		 * Will use WRMSRNS/WRMSRLIST for performance once it's upstreamed.
+		 */
+		wrmsrl(MSR_IA32_FRED_RSP0,
+		       task_top_of_stack(task) + TOP_OF_KERNEL_STACK_PADDING);
+	} else if (cpu_feature_enabled(X86_FEATURE_XENPV)) {
+		/* Xen PV enters the kernel on the thread stack. */
 		load_sp0(task_top_of_stack(task));
+	}
 #endif
 }
 
-- 
2.34.1

