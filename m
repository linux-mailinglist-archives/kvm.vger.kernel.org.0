Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A6D7AC006
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 12:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbjIWKM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 06:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjIWKL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 06:11:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ED91B2;
        Sat, 23 Sep 2023 03:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695463906; x=1726999906;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U5v5FfPZcbv+kEeu4BDXYc9n8fkslqM+14uJJDiLwkk=;
  b=ixQUNrJAyVY8HNPqmZmobN0KOm8z0sYCjmnxRgrHa21aF7gDb2l0JjAJ
   SduROhw4WqIZFzrJIDZikzmbl2ys2xAw1kINfl5W9KbYeaI1R2HdAkmiJ
   LfRlTvm8JCW7SUoZGZ1/uC6Ga0URrF/GBtxZPvJwJLwMCFuhK04I0QCz9
   rK10C81fTG8soG4v2mXvLBzavgFbIlTNWqXfSE3Av6RF7QxSHNFK1f9aK
   FUGw2TIvFu1AY7OLsr/H2sye/yG32Ib0HAMQ4RCnkTQZuUfds8uhl1JSR
   coumZW0UTi/E9IgZwJ0gRcq6gwS8nB9WTXXQIN6INyHqDviyXCzl9yFGb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="447492302"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="447492302"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 03:11:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="813388168"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="813388168"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 23 Sep 2023 03:11:44 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: [PATCH v11 19/37] x86/fred: Update MSR_IA32_FRED_RSP0 during task switch
Date:   Sat, 23 Sep 2023 02:41:54 -0700
Message-Id: <20230923094212.26520-20-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230923094212.26520-1-xin3.li@intel.com>
References: <20230923094212.26520-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

