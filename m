Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672477B614C
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 08:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbjJCGzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 02:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239261AbjJCGy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 02:54:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E157E9;
        Mon,  2 Oct 2023 23:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696316092; x=1727852092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HaNFd9+f6o42v45n40NutGcoZldX+CMRVlEU3cDygtg=;
  b=JtCHFHMEPu5NVDh5XXdAjWkYhp1Lq5sD3SyxPQh4W1RNtsgtOIi9Me31
   FIXQuI2z3sv6LmHyqRq2fRIs0e+bzOPv5YKHr4ryYPtyp/n1OfyaWC6hI
   W0pi84Kt9am7AeYuMSkUIM1h6+K9dg500hi2tjaMgNsG8VyEYfRhp1d96
   UrfOktayFp9Z1puWReVzsAfMSvbtwDT3jpLQyOZRyybi/dFgl74We2O24
   Yh5gab4z9f7OBV3RvUEne1UJXedjEcPSSFehv1P9ZdEnT1NfyIN19MD5/
   NvYeLAFseKRjKOqtsr5NxqCWR2odD02T+Pap+7D2ug+9HOqsSQ7AhXb7l
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="367858139"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="367858139"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 23:54:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="1081900957"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="1081900957"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga005.fm.intel.com with ESMTP; 02 Oct 2023 23:54:44 -0700
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
Subject: [PATCH v12 20/37] x86/fred: Disallow the swapgs instruction when FRED is enabled
Date:   Mon,  2 Oct 2023 23:24:41 -0700
Message-Id: <20231003062458.23552-21-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003062458.23552-1-xin3.li@intel.com>
References: <20231003062458.23552-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

SWAPGS is no longer needed thus NOT allowed with FRED because FRED
transitions ensure that an operating system can _always_ operate
with its own GS base address:
- For events that occur in ring 3, FRED event delivery swaps the GS
  base address with the IA32_KERNEL_GS_BASE MSR.
- ERETU (the FRED transition that returns to ring 3) also swaps the
  GS base address with the IA32_KERNEL_GS_BASE MSR.

And the operating system can still setup the GS segment for a user
thread without the need of loading a user thread GS with:
- Using LKGS, available with FRED, to modify other attributes of the
  GS segment without compromising its ability always to operate with
  its own GS base address.
- Accessing the GS segment base address for a user thread as before
  using RDMSR or WRMSR on the IA32_KERNEL_GS_BASE MSR.

Note, LKGS loads the GS base address into the IA32_KERNEL_GS_BASE MSR
instead of the GS segment’s descriptor cache. As such, the operating
system never changes its runtime GS base address.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v8:
* Explain why writing directly to the IA32_KERNEL_GS_BASE MSR is
  doing the right thing (Thomas Gleixner).
---
 arch/x86/kernel/process_64.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 0f78b58021bb..4f87f5987ae8 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -166,7 +166,29 @@ static noinstr unsigned long __rdgsbase_inactive(void)
 
 	lockdep_assert_irqs_disabled();
 
-	if (!cpu_feature_enabled(X86_FEATURE_XENPV)) {
+	/*
+	 * SWAPGS is no longer needed thus NOT allowed with FRED because
+	 * FRED transitions ensure that an operating system can _always_
+	 * operate with its own GS base address:
+	 * - For events that occur in ring 3, FRED event delivery swaps
+	 *   the GS base address with the IA32_KERNEL_GS_BASE MSR.
+	 * - ERETU (the FRED transition that returns to ring 3) also swaps
+	 *   the GS base address with the IA32_KERNEL_GS_BASE MSR.
+	 *
+	 * And the operating system can still setup the GS segment for a
+	 * user thread without the need of loading a user thread GS with:
+	 * - Using LKGS, available with FRED, to modify other attributes
+	 *   of the GS segment without compromising its ability always to
+	 *   operate with its own GS base address.
+	 * - Accessing the GS segment base address for a user thread as
+	 *   before using RDMSR or WRMSR on the IA32_KERNEL_GS_BASE MSR.
+	 *
+	 * Note, LKGS loads the GS base address into the IA32_KERNEL_GS_BASE
+	 * MSR instead of the GS segment’s descriptor cache. As such, the
+	 * operating system never changes its runtime GS base address.
+	 */
+	if (!cpu_feature_enabled(X86_FEATURE_FRED) &&
+	    !cpu_feature_enabled(X86_FEATURE_XENPV)) {
 		native_swapgs();
 		gsbase = rdgsbase();
 		native_swapgs();
@@ -191,7 +213,8 @@ static noinstr void __wrgsbase_inactive(unsigned long gsbase)
 {
 	lockdep_assert_irqs_disabled();
 
-	if (!cpu_feature_enabled(X86_FEATURE_XENPV)) {
+	if (!cpu_feature_enabled(X86_FEATURE_FRED) &&
+	    !cpu_feature_enabled(X86_FEATURE_XENPV)) {
 		native_swapgs();
 		wrgsbase(gsbase);
 		native_swapgs();
-- 
2.34.1

