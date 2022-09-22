Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0295E65D9
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 16:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiIVOhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 10:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiIVOhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 10:37:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3842F6F47
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 07:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663857426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pIfJ3bPCmkG+z995PI+eIkSYghOocG6/MToO8whN5Us=;
        b=ZiKCNzvcyGoj7FTj1/vyR29IEZMd/YcIKo4vlCM69IKQRz99YRCskvdPCIjQdzdCgVkNy2
        wuGWM5I0Dxf33cSGegjMT3yTEcSSBBBu4AmM5bcE3RcjmjrA4wg+CKwyvWcoMeS6dQKU0S
        TK5wkU17uIyEQSRxo8HOdBXcDDkwHD0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-mPiFwrYuOSCQoyiUSwiszg-1; Thu, 22 Sep 2022 10:37:03 -0400
X-MC-Unique: mPiFwrYuOSCQoyiUSwiszg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 063F1811E81;
        Thu, 22 Sep 2022 14:37:03 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 261AB4048D87;
        Thu, 22 Sep 2022 14:37:01 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/6] KVM: x86: Introduce CPUID_8000_0007_EDX 'scattered' leaf
Date:   Thu, 22 Sep 2022 16:36:51 +0200
Message-Id: <20220922143655.3721218-3-vkuznets@redhat.com>
In-Reply-To: <20220922143655.3721218-1-vkuznets@redhat.com>
References: <20220922143655.3721218-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID_8000_0007_EDX may come handy when X86_FEATURE_CONSTANT_TSC
needs to be checked.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c         | 8 ++++++--
 arch/x86/kvm/reverse_cpuid.h | 9 ++++++++-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ffdc28684cb7..b95a4b7489ec 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -685,6 +685,10 @@ void kvm_set_cpu_caps(void)
 	if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))
 		kvm_cpu_cap_set(X86_FEATURE_GBPAGES);
 
+	kvm_cpu_cap_init_scattered(CPUID_8000_0007_EDX,
+		SF(CONSTANT_TSC)
+	);
+
 	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
 		F(CLZERO) | F(XSAVEERPTR) |
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
@@ -1137,8 +1141,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		/* L2 cache and TLB: pass through host info. */
 		break;
 	case 0x80000007: /* Advanced power management */
-		/* invariant TSC is CPUID.80000007H:EDX[8] */
-		entry->edx &= (1 << 8);
+		cpuid_entry_override(entry, CPUID_8000_0007_EDX);
+
 		/* mask against host */
 		entry->edx &= boot_cpu_data.x86_power;
 		entry->eax = entry->ebx = entry->ecx = 0;
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index a19d473d0184..a5514c89dc29 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -12,7 +12,8 @@
  * "bug" caps, but KVM doesn't use those.
  */
 enum kvm_only_cpuid_leafs {
-	CPUID_12_EAX	 = NCAPINTS,
+	CPUID_12_EAX		= NCAPINTS,
+	CPUID_8000_0007_EDX	= NCAPINTS + 1,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -24,6 +25,9 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
 
+/* CPUID level 0x80000007 (EDX). */
+#define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -48,6 +52,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
+	[CPUID_8000_0007_EDX] = {0x80000007, 0, CPUID_EDX},
 };
 
 /*
@@ -78,6 +83,8 @@ static __always_inline u32 __feature_translate(int x86_feature)
 		return KVM_X86_FEATURE_SGX1;
 	else if (x86_feature == X86_FEATURE_SGX2)
 		return KVM_X86_FEATURE_SGX2;
+	else if (x86_feature == X86_FEATURE_CONSTANT_TSC)
+		return KVM_X86_FEATURE_CONSTANT_TSC;
 
 	return x86_feature;
 }
-- 
2.37.3

