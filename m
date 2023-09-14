Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A99D79FAB8
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 07:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbjINFVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 01:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbjINFUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 01:20:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E4C212E;
        Wed, 13 Sep 2023 22:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694668767; x=1726204767;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DfU6e7Lxi3caIgHaas3RwgcYA9izTEYulGU0upU0hWQ=;
  b=ZzL6Kn4cqvAk6SV+zVcfAh1hkxVgYHhwoavTha/1ib/qszt4DPW2W38l
   G/zrHXbGWXq9QOEccAhBkpu6K+WHiBBH8EvoXsjMBNTCraepdmX7YEplF
   yHgd6DpyqRyddeNLmUJG1TYDcZN1BtOMU5JE59x7YixKWlZ/0nN9517Oo
   p9/YG3kcWg7G7tRyiMdVIWlhZYpq20XLyq37fRQBNUaUP78pVpRCwj7i5
   0d2LvX/8vYZsEEO3OkCPPkYAQQHetkYo5f1XG2v6TiK0CuYXiU2IzjkN1
   7ccVewM14F6YGA+O0FOLJb7bT2fIzJRdriaqJCHW4jND+ypmPimq+Uucc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382661535"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382661535"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 22:17:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779488847"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779488847"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2023 22:17:47 -0700
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
Subject: [PATCH v10 36/38] x86/fred: Add fred_syscall_init()
Date:   Wed, 13 Sep 2023 21:48:03 -0700
Message-Id: <20230914044805.301390-37-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914044805.301390-1-xin3.li@intel.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Add a syscall initialization function fred_syscall_init() for FRED,
and this is really just to skip setting up SYSCALL/SYSENTER related
MSRs, e.g., MSR_LSTAR and invalidate SYSENTER configurations, because
FRED uses the ring 3 FRED entrypoint for SYSCALL and SYSENTER, and
ERETU is the only legit instruction to return to ring 3 per FRED spec
5.0.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kernel/cpu/common.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d960b7276008..4cb36e241c9a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2105,6 +2105,23 @@ static inline void idt_syscall_init(void)
 	       X86_EFLAGS_AC|X86_EFLAGS_ID);
 }
 
+static inline void fred_syscall_init(void)
+{
+	/*
+	 * Per FRED spec 5.0, FRED uses the ring 3 FRED entrypoint for SYSCALL
+	 * and SYSENTER, and ERETU is the only legit instruction to return to
+	 * ring 3, as a result there is _no_ need to setup the SYSCALL and
+	 * SYSENTER MSRs.
+	 *
+	 * Note, both sysexit and sysret cause #UD when FRED is enabled.
+	 */
+	wrmsrl(MSR_LSTAR, 0ULL);
+	wrmsrl_cstar(0ULL);
+	wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)GDT_ENTRY_INVALID_SEG);
+	wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
+	wrmsrl_safe(MSR_IA32_SYSENTER_EIP, 0ULL);
+}
+
 /* May not be marked __init: used by software suspend */
 void syscall_init(void)
 {
-- 
2.34.1

