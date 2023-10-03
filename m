Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FFB7B61E9
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 08:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239235AbjJCG65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 02:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239485AbjJCG6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 02:58:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A2E2D4D;
        Mon,  2 Oct 2023 23:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696316150; x=1727852150;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KVAH30AJVp6O2e8FLYlwUzaPcwlh2ELK9dDq37AIdDs=;
  b=Z1LAqzi+Z3ye68zKOI2in3pIFKFY+Ay3dgi0OQrOWruDTJZoDjwpznfs
   N91WrtwrvnoRypg0vwvp1JFD8CjGAKv6xhQ/4y7u8Y2hrKDxNAK/hR7HH
   IOkNa0F13FTUIwYxHCxL45QrnTl3UtM8UC8A60bJwTQxu14i0aaeYAMm+
   FmHM3gUN9V9NWWu7g1htpJzbBzg6nzS8suOkA0/9nz6WNFXtGsOF9kfJ5
   ldjdyJEhSE+20+4JB6RTxLglKyiPpZ6leRrY+9zUvD+VU6PckhVpICGBY
   vHn74pxuUGt3FcZxt97J++g9GbmA+fT+2kkW06KZMVlPmQ1rvw0uVYz2D
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="367858350"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="367858350"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 23:54:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="1081901025"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="1081901025"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga005.fm.intel.com with ESMTP; 02 Oct 2023 23:54:52 -0700
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
Subject: [PATCH v12 35/37] x86/syscall: Split IDT syscall setup code into idt_syscall_init()
Date:   Mon,  2 Oct 2023 23:24:56 -0700
Message-Id: <20231003062458.23552-36-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003062458.23552-1-xin3.li@intel.com>
References: <20231003062458.23552-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Because FRED uses the ring 3 FRED entrypoint for SYSCALL and SYSENTER and
ERETU is the only legit instruction to return to ring 3, there is NO need
to setup SYSCALL and SYSENTER MSRs for FRED, except the IA32_STAR MSR.

Split IDT syscall setup code into idt_syscall_init() to make it easy to
skip syscall setup code when FRED is enabled.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kernel/cpu/common.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9b1cb6c938c4..69f9bdab19a9 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2078,10 +2078,8 @@ static void wrmsrl_cstar(unsigned long val)
 		wrmsrl(MSR_CSTAR, val);
 }
 
-/* May not be marked __init: used by software suspend */
-void syscall_init(void)
+static inline void idt_syscall_init(void)
 {
-	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);
 	wrmsrl(MSR_LSTAR, (unsigned long)entry_SYSCALL_64);
 
 	if (ia32_enabled()) {
@@ -2115,6 +2113,15 @@ void syscall_init(void)
 	       X86_EFLAGS_AC|X86_EFLAGS_ID);
 }
 
+/* May not be marked __init: used by software suspend */
+void syscall_init(void)
+{
+	/* The default user and kernel segments */
+	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);
+
+	idt_syscall_init();
+}
+
 #else	/* CONFIG_X86_64 */
 
 #ifdef CONFIG_STACKPROTECTOR
-- 
2.34.1

