Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EF66A4CE8
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjB0VPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjB0VPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:15:06 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F4E2684A;
        Mon, 27 Feb 2023 13:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677532498; x=1709068498;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+X2600KfN0m5ZqG1NqIyA9OmLfKGo7rr2urm8ZQTI2s=;
  b=ZuRM4s124eYnB/MW31AvVoA4bI0ws8XHnrfZzzo9Z79I/bvFLkpJtFMh
   iiyY982Vq6I7WIIE8wqUEYpSPoiyRApQ7KZGLg3CRGTa+UJIGVIlrPU2e
   oB3Gu3AqT4hKUFb/OMqtmEQ8r8I+1Q1OrOv1m2xTFdgzeUUCVMQPdd1HR
   4=;
X-IronPort-AV: E=Sophos;i="5.98,220,1673913600"; 
   d="scan'208";a="187221001"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-fa5fe5fb.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 21:05:58 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-fa5fe5fb.us-west-2.amazon.com (Postfix) with ESMTPS id E542040DFE;
        Mon, 27 Feb 2023 21:05:56 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 27 Feb 2023 21:05:56 +0000
Received: from b0f1d8753182.ant.amazon.com (10.95.130.142) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 27 Feb 2023 21:05:51 +0000
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
Subject: [PATCH 2/2] KVM: x86: Propagate AMD-specific IBRS related bits
Date:   Mon, 27 Feb 2023 21:05:26 +0000
Message-ID: <20230227210526.83182-3-itazur@amazon.com>
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

Add AMD-specific IBRS related bits to be propagated to guests.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 arch/x86/kvm/cpuid.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 596061c1610e..829ca79076df 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -704,8 +704,9 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
 		F(CLZERO) | F(XSAVEERPTR) |
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
-		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
-		__feature_bit(KVM_X86_FEATURE_AMD_PSFD)
+		F(AMD_SSB_NO) | F(AMD_STIBP) | F(X86_FEATURE_AMD_IBRS_ALWAYS_ON) |
+		F(AMD_STIBP_ALWAYS_ON) | F(X86_FEATURE_AMD_IBRS_PREFERRED) |
+		F(X86_FEATURE_AMD_IBRS_SAME_MODE) | __feature_bit(KVM_X86_FEATURE_AMD_PSFD)
 	);
 
 	/*
-- 
2.38.0

