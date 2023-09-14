Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2996C79FA4F
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 07:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbjINFTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 01:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbjINFT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 01:19:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0651FD7;
        Wed, 13 Sep 2023 22:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694668761; x=1726204761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HaNFd9+f6o42v45n40NutGcoZldX+CMRVlEU3cDygtg=;
  b=b/KkDC9q4trXFNRaJLchtnYNd9hcBpyEjADsJWDcYkkPis40w1ENC/1a
   XnMb1EJ8+Fc9X490ASKGYTvNTTuvxFzM4mvsQDH8MPR0TUAf59Te5nsrK
   7kGMlrrqg68aW4XU1dO2YzOFbhdRe5YqsQz0H2dtvS17NsMVhLSLh2SzP
   53v855whjdgIx2PH8UGN5X5xsIRMiDnjLgbk5pAgk7+Q4bUx/vXBwWqGw
   HOoOFpsTnA4t8nJmJpE5P34Gig+5JPI5PyWxebQWgQTNh/gDYdr3mxNt+
   NaTllILIqYsaCY3rBrXLddJQRukMC3F4AA/R0Nk508UHb0d5lOWPkRAaO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382661326"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382661326"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 22:17:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779488799"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779488799"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2023 22:17:39 -0700
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
Subject: [PATCH v10 20/38] x86/fred: Disallow the swapgs instruction when FRED is enabled
Date:   Wed, 13 Sep 2023 21:47:47 -0700
Message-Id: <20230914044805.301390-21-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914044805.301390-1-xin3.li@intel.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

