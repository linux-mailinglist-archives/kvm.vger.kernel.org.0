Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696F36A741B
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 20:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjCATOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 14:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjCATOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 14:14:30 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AA336095;
        Wed,  1 Mar 2023 11:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677698061; x=1709234061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9+Fk+ywSCeiN4GCv/ZuP2Cp2Wv3txmX4zooLxC/Zf10=;
  b=mpNRF+YjgnBSsj6E8kiaKFf0SFksQzf+l7pix+jYFUxEdLIg1bbvQHUm
   pnAIEpAV8+ZOP2/v8K9YQGhhmSi3txOz9g5TJvwv/+RuiLHcRPv2Qeytt
   vMkp/tTDeu3UlrdCDx+sSAUQ/VKzS+tG4SX8Zhh9ltJAZnkwGJ7wEDDUy
   k=;
X-IronPort-AV: E=Sophos;i="5.98,225,1673913600"; 
   d="scan'208";a="1108222653"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 18:59:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com (Postfix) with ESMTPS id 6E16740E2D;
        Wed,  1 Mar 2023 18:59:08 +0000 (UTC)
Received: from EX19D002ANA002.ant.amazon.com (10.37.240.152) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Wed, 1 Mar 2023 18:59:07 +0000
Received: from b0f1d8753182.ant.amazon.com.com (10.95.161.59) by
 EX19D002ANA002.ant.amazon.com (10.37.240.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Wed, 1 Mar 2023 18:59:04 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
CC:     <linux-kernel@vger.kernel.org>,
        Takahiro Itazuri <zulinx86@gmail.com>,
        Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH v2 1/1] KVM: x86: Propagate AMD-specific IBRS bits to guests
Date:   Wed, 1 Mar 2023 18:58:38 +0000
Message-ID: <20230301185838.21659-2-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230301185838.21659-1-itazur@amazon.com>
References: <20230301185838.21659-1-itazur@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.161.59]
X-ClientProxiedBy: EX19D035UWB004.ant.amazon.com (10.13.138.104) To
 EX19D002ANA002.ant.amazon.com (10.37.240.152)
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMMs retrieve supported CPUID features via KVM_GET_SUPPORTED_CPUID to
construct CPUID information to be passed to KVM_SET_CPUID2. Most CPUID
feature bits related to speculative attacks are propagated from host
CPUID. AMD processors have AMD-specific IBRS related bits in CPUID
Fn8000_0008_EBX (ref: AMD64 Architecture Programmer's Manual Volume 3:
General-Purpose and System Instructions) and some bits are not
propagated to guests.

Enable propagation of these bits to guests, so that guests can see the
same security information as the host without VMM action.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 arch/x86/kvm/cpuid.c         | 5 +++--
 arch/x86/kvm/reverse_cpuid.h | 5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 596061c1610e..c297064208dd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -704,8 +704,9 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
 		F(CLZERO) | F(XSAVEERPTR) |
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
-		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
-		__feature_bit(KVM_X86_FEATURE_AMD_PSFD)
+		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_IBRS_ALWAYS_ON) |
+		F(AMD_STIBP_ALWAYS_ON) | F(AMD_IBRS_PREFERRED) |
+		F(AMD_IBRS_SAME_MODE) | __feature_bit(KVM_X86_FEATURE_AMD_PSFD)
 	);
 
 	/*
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 042d0aca3c92..1e538e29b117 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -43,6 +43,11 @@ enum kvm_only_cpuid_leafs {
 #define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
 #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
 
+/* AMD-specific IBRS hint bits, CPUID level 0x80000008 (EBX) */
+#define X86_FEATURE_AMD_IBRS_ALWAYS_ON	KVM_X86_FEATURE(CPUID_8000_0008_EBX, 16)
+#define X86_FEATURE_AMD_IBRS_PREFERRED	KVM_X86_FEATURE(CPUID_8000_0008_EBX, 18)
+#define X86_FEATURE_AMD_IBRS_SAME_MODE	KVM_X86_FEATURE(CPUID_8000_0008_EBX, 19)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
-- 
2.38.0

