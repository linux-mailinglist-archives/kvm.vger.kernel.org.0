Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9296A1716
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 08:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjBXH16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 02:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBXH1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 02:27:55 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AC91EBDF;
        Thu, 23 Feb 2023 23:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677223646; x=1708759646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4bpIJXn+Cqwm7qv6s3tf9xXrKBIQ0tJR6b3uTXiGGZk=;
  b=mQVj+Agy8UqmTAVhyCXCy+j1egXSUIKmp8HJRNvT3usuwVmsXQNlqEfM
   3VrvOo6FcJlM7cinR16lFGi9f9cDQJcisnGofqA2VLjYtjYXPliRs4bSj
   hk96IDFNhj3GLJhV9zd+9x0tm+jnDaYsWimzJSfKrdRTllvX48w+6t2US
   OpcuW3VmF+YC3IljwpuAUlAZ5OiVaMDr72zv6oValYjwNpfoGedEl41DP
   Y5jcVdNO4i0VowY55+rhBghkcUcvUM086DhPRfcCRfqaDXpEpGGYig1N5
   8unIHt0of2ZwHwSWc9KoCALtuMw21WCm2fw+JXBp67XnrJbWWUxnIX8Up
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="334835919"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="334835919"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:27:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="815639188"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="815639188"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2023 23:27:19 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v3 01/32] x86/traps: let common_interrupt() handle IRQ_MOVE_CLEANUP_VECTOR
Date:   Thu, 23 Feb 2023 23:01:14 -0800
Message-Id: <20230224070145.3572-2-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224070145.3572-1-xin3.li@intel.com>
References: <20230224070145.3572-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

IRQ_MOVE_CLEANUP_VECTOR is the only one of the system IRQ vectors that
is *below* FIRST_SYSTEM_VECTOR. It is a slow path, so just push it
into common_interrupt() just before the spurious interrupt handling.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kernel/irq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 766ffe3ba313..7e125fff45ab 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -248,6 +248,10 @@ DEFINE_IDTENTRY_IRQ(common_interrupt)
 	desc = __this_cpu_read(vector_irq[vector]);
 	if (likely(!IS_ERR_OR_NULL(desc))) {
 		handle_irq(desc, regs);
+#ifdef CONFIG_SMP
+	} else if (vector == IRQ_MOVE_CLEANUP_VECTOR) {
+		sysvec_irq_move_cleanup(regs);
+#endif
 	} else {
 		ack_APIC_irq();
 
-- 
2.34.1

