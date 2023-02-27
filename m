Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035926A4CE9
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjB0VPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjB0VPI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:15:08 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62984265AB;
        Mon, 27 Feb 2023 13:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677532499; x=1709068499;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QTDsYLHvG7I09WLI5isIEq1xwFB/a+7VTMu/FzazcPQ=;
  b=QMNY+mPaCro/3XU/eJC6hABwXYObObyL1pUr/qyvAdSScUJnF7W2Wt2U
   CENwEZ7yMpvb+f86WsO0HDoM4rPn/QzX88GrerBVyyDrjofdU3aJEuVSU
   ducnUzPKrECZ85quSlQDWh+G0xjEeyas7A5GSHAF8lPFhPf+d0axcUclv
   M=;
X-IronPort-AV: E=Sophos;i="5.98,220,1673913600"; 
   d="scan'208";a="187220989"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-b404fda3.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 21:05:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-b404fda3.us-east-1.amazon.com (Postfix) with ESMTPS id 9AB1A839DB;
        Mon, 27 Feb 2023 21:05:52 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 27 Feb 2023 21:05:51 +0000
Received: from b0f1d8753182.ant.amazon.com (10.95.130.142) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 27 Feb 2023 21:05:47 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <kvm@vger.kernel.org>, <x86@kernel.org>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        <linux-kernel@vger.kernel.org>,
        "Takahiro Itazuri" <zulinx86@gmail.com>,
        Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH 1/2] x86/cpufeatures: Add AMD-specific IBRS bits
Date:   Mon, 27 Feb 2023 21:05:25 +0000
Message-ID: <20230227210526.83182-2-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230227210526.83182-1-itazur@amazon.com>
References: <20230227210526.83182-1-itazur@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.130.142]
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD processors have some AMD-specific IBRS related bits in CPUID
Fn8000_0008_EBX (ref: AMD64 Architecture Programmer's Manual, Volume 3:
General-Purpose and System Instructions).

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 arch/x86/include/asm/cpufeatures.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 8f39c46197b8..cd7245507745 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -324,7 +324,10 @@
 #define X86_FEATURE_AMD_IBPB		(13*32+12) /* "" Indirect Branch Prediction Barrier */
 #define X86_FEATURE_AMD_IBRS		(13*32+14) /* "" Indirect Branch Restricted Speculation */
 #define X86_FEATURE_AMD_STIBP		(13*32+15) /* "" Single Thread Indirect Branch Predictors */
+#define X86_FEATURE_AMD_IBRS_ALWAYS_ON	(13*32+16) /* "" Indirect Branch Restricted Speculation always-on preferred */
 #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* "" Single Thread Indirect Branch Predictors always-on preferred */
+#define X86_FEATURE_AMD_IBRS_PREFERRED	(13*32+18) /* "" Indirect Branch Restricted Speculation preferred over software */
+#define X86_FEATURE_AMD_IBRS_SAME_MODE	(13*32+19) /* "" Indirect Branch Restricted Speculation provides same mode protection */
 #define X86_FEATURE_AMD_PPIN		(13*32+23) /* Protected Processor Inventory Number */
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* "" Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* Virtualized Speculative Store Bypass Disable */
-- 
2.38.0

