Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B4479FA3F
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 07:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbjINFTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 01:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbjINFT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 01:19:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABE61FD0;
        Wed, 13 Sep 2023 22:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694668761; x=1726204761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U5v5FfPZcbv+kEeu4BDXYc9n8fkslqM+14uJJDiLwkk=;
  b=hwiItbJSe/YkA02RhxCCaWdeqkXTK7/tIInN/1UTFjERD0N0yZ1GUwBh
   4gvP8aApm6UWNNBiiBl2lbwAkpoPHcaMk05LNS14siMwGSJ6CE9VWzWk0
   09zMWY5dF+l3McdgkX7w7+eZkvyjxER/RIQP7cM5UOhHnbx/3l3RxHifG
   i59pHMRyBuVvWZdlSef+q+j+kxKwUNXFgSV6iQExNzqTXVW9hSYUx1kg9
   C0kclT8Shf435K0Iwm2RpCnAz3cDxXqFRtZMnFQTbtcNBsMkqwUvDcnv0
   n2UAt0rFEA8uNxGxGMfXgVrSno8e0uKZMbBzm06NCtC7pPtl++pBgiUyG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382661313"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382661313"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 22:17:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779488796"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779488796"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2023 22:17:38 -0700
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
Subject: [PATCH v10 19/38] x86/fred: Update MSR_IA32_FRED_RSP0 during task switch
Date:   Wed, 13 Sep 2023 21:47:46 -0700
Message-Id: <20230914044805.301390-20-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914044805.301390-1-xin3.li@intel.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

MSR_IA32_FRED_RSP0 is used during ring 3 event delivery, and needs to
be updated to point to the top of next task stack during task switch.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/switch_to.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index f42dbf17f52b..c3bd0c0758c9 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -70,9 +70,13 @@ static inline void update_task_stack(struct task_struct *task)
 #ifdef CONFIG_X86_32
 	this_cpu_write(cpu_tss_rw.x86_tss.sp1, task->thread.sp0);
 #else
-	/* Xen PV enters the kernel on the thread stack. */
-	if (cpu_feature_enabled(X86_FEATURE_XENPV))
+	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
+		/* WRMSRNS is a baseline feature for FRED. */
+		wrmsrns(MSR_IA32_FRED_RSP0, (unsigned long)task_stack_page(task) + THREAD_SIZE);
+	} else if (cpu_feature_enabled(X86_FEATURE_XENPV)) {
+		/* Xen PV enters the kernel on the thread stack. */
 		load_sp0(task_top_of_stack(task));
+	}
 #endif
 }
 
-- 
2.34.1

