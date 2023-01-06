Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B516865FDB3
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbjAFJWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbjAFJU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:26 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19566B5B4;
        Fri,  6 Jan 2023 01:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996824; x=1704532824;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cFa67ljZDOj6B4hnKmSyOvFw/+uBlbUZju1/l5Toj94=;
  b=nSUnNxdzSUaxCQvfugbbCcU1gb/P3R5kMcqSqlvBI67Mh+JHZQuSBEJk
   tBQfuaxOgyVDdx8IrudVG5MCLCOGRrH+DOeiO83/HrAXa/FtHIgybhyFK
   afLK4/GuTN8xRKkPFz2goezMU/ej/NBxP//kfryi9agy93V/vt75T9r77
   xfGpu1KfQNoUB3doZflwvYNRcH+au41YBA0Z+sG3uSoNL/nzTxyfV/kxT
   tNLMM2iEAowG4ITCabeT8qxm0d/GaA8xRk/wT/ulA4V8lzSEEpYNbpp7X
   wmhEknz9xtDIBxv2wu+LEhHdkpbrTa3fkHrORlvw61GEcaPnpyIFoP5he
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511608"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511608"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139439"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139439"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:16 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 25/32] x86/fred: disallow the swapgs instruction when FRED is enabled
Date:   Fri,  6 Jan 2023 00:56:10 -0800
Message-Id: <20230106085617.17248-26-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106085617.17248-1-xin3.li@intel.com>
References: <20230106085617.17248-1-xin3.li@intel.com>
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

The FRED architecture establishes the full supervisor/user through:
1) FRED event delivery swaps the value of the GS base address and
   that of the IA32_KERNEL_GS_BASE MSR.
2) ERETU swaps the value of the GS base address and that of the
   IA32_KERNEL_GS_BASE MSR.
Thus, the swapgs instruction is disallowed when FRED is enabled,
otherwise it cauess #UD.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kernel/process_64.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index bfe6179b7a17..5b6cfd2ca630 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -165,7 +165,8 @@ static noinstr unsigned long __rdgsbase_inactive(void)
 
 	lockdep_assert_irqs_disabled();
 
-	if (!static_cpu_has(X86_FEATURE_XENPV)) {
+	if (!cpu_feature_enabled(X86_FEATURE_FRED) &&
+	    !static_cpu_has(X86_FEATURE_XENPV)) {
 		native_swapgs();
 		gsbase = rdgsbase();
 		native_swapgs();
@@ -190,7 +191,8 @@ static noinstr void __wrgsbase_inactive(unsigned long gsbase)
 {
 	lockdep_assert_irqs_disabled();
 
-	if (!static_cpu_has(X86_FEATURE_XENPV)) {
+	if (!cpu_feature_enabled(X86_FEATURE_FRED) &&
+	    !static_cpu_has(X86_FEATURE_XENPV)) {
 		native_swapgs();
 		wrgsbase(gsbase);
 		native_swapgs();
-- 
2.34.1

