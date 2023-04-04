Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2764C6D698E
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbjDDQyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbjDDQyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:54:23 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F564EFC
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:54:01 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n15-20020a170902f60f00b001a273a4a685so11180589plg.15
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680627241;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KTJZitpcSngFsG0VDQnB1a1HM5F9zdkpY5So94W9+i4=;
        b=c75ESF3BCpppZ+Gol3gApZbDy1DrpNsKo2lM4cLpnuxzyxqPJjGA+n/xPhsEj5DsbK
         ahLswgI1U5/jDnmtb37uACUjAd74f3NH2q/Rva5CRjmBFL1UYKeFUh3RitCvBrnRe/cG
         uQlyz2rtrr3D0uzcUJBlKzzHTDc66vtLEA6hnVrEYmw4WOKY4kxVdE91FpD0rbSmrAXg
         Uzz/V0UvbRmimbHYxuzT3vJiTBp7UNNpBzrXn/gIO7Aq0d5RIijqHoFum1jOe3Ef8vQF
         ml+LQKVdYFmbMVoDdYNNHpZzd8juS7gnTYoUvpjiSgSTdPsklmxruTNEmoUhdljU4hel
         qJ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680627241;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KTJZitpcSngFsG0VDQnB1a1HM5F9zdkpY5So94W9+i4=;
        b=RRe7up9vK5T0qEXdJsuoJrbU52/OewL+70sLTlmq14v/ONmTFnrtjmTy8PVIhMrQ7R
         0zWaJ2Nex/DqRmTCpe43cfyvxnjO1RTdl8/KszxTZqESFTKwasQs/Zm2XpuDjHZOewcl
         BDUq9a5xlYt3QddSt3zmP9GsShrDSiAY/arcwOG3wYlopdtQIC7BZKncTwOslIA4vHoN
         MGL7ga5vqZA8ccn4GaCvDHXuc24EHtvcy/JYPWthX52eu42F0T++7npTYmRJs++v7flM
         nj4Pgg+i2HkHCqOpKdw73h0nXUAv2WomM2zwxfCQ3x+UPFynRUPgYg3OSeQhLtXgV5IP
         GjzA==
X-Gm-Message-State: AAQBX9c6h/KB1vYoWOQrdFoocHNylwO8459eFwuhOWzpjyFCZE6XPVHe
        HDkpFQKGMwSE/z3SJC7T6KYkq84p+jQ=
X-Google-Smtp-Source: AKy350YWz4aB8asusqfmZlirZQSnPSLvJqBfz73VJcfyw0ry9s9hdDkeEWbuJzh0WeGvI60e9Y1/gn1rh5o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4c1f:0:b0:4fb:1f2a:e6c6 with SMTP id
 z31-20020a634c1f000000b004fb1f2ae6c6mr929164pga.2.1680627241261; Tue, 04 Apr
 2023 09:54:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 09:53:40 -0700
In-Reply-To: <20230404165341.163500-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404165341.163500-10-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 9/9] nVMX: Add forced emulation variant of
 #PF access test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a forced emulation variant of vmx_pf_exception_test to exercise KVM
emulation of L2 instructions and accesses.  Like the non-nested version,
make the test nodefault as forcing KVM to emulate drastically increases
the runtime.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg |  6 ++++++
 x86/vmx_tests.c   | 25 ++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index c878363e..0971bb3f 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -409,6 +409,12 @@ extra_params = -cpu max,+vmx -append "vmx_pf_exception_test"
 arch = x86_64
 groups = vmx nested_exception
 
+[vmx_pf_exception_test_fep]
+file = vmx.flat
+extra_params = -cpu max,+vmx -append "vmx_pf_exception_forced_emulation_test"
+arch = x86_64
+groups = vmx nested_exception nodefault
+
 [vmx_pf_vpid_test]
 file = vmx.flat
 extra_params = -cpu max,+vmx -append "vmx_pf_vpid_test"
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 617b97b3..5a0415f9 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10463,14 +10463,22 @@ static void vmx_pf_exception_test_guest(void)
 	ac_test_run(PT_LEVEL_PML4, false);
 }
 
+static void vmx_pf_exception_forced_emulation_test_guest(void)
+{
+	ac_test_run(PT_LEVEL_PML4, true);
+}
+
 typedef void (*invalidate_tlb_t)(void *data);
+typedef void (*pf_exception_test_guest_t)(void);
 
-static void __vmx_pf_exception_test(invalidate_tlb_t inv_fn, void *data)
+
+static void __vmx_pf_exception_test(invalidate_tlb_t inv_fn, void *data,
+				    pf_exception_test_guest_t guest_fn)
 {
 	u64 efer;
 	struct cpuid cpuid;
 
-	test_set_guest(vmx_pf_exception_test_guest);
+	test_set_guest(guest_fn);
 
 	/* Intercept INVLPG when to perform TLB invalidation from L1 (this). */
 	if (inv_fn)
@@ -10519,7 +10527,12 @@ static void __vmx_pf_exception_test(invalidate_tlb_t inv_fn, void *data)
 
 static void vmx_pf_exception_test(void)
 {
-	__vmx_pf_exception_test(NULL, NULL);
+	__vmx_pf_exception_test(NULL, NULL, vmx_pf_exception_test_guest);
+}
+
+static void vmx_pf_exception_forced_emulation_test(void)
+{
+	__vmx_pf_exception_test(NULL, NULL, vmx_pf_exception_forced_emulation_test_guest);
 }
 
 static void invalidate_tlb_no_vpid(void *data)
@@ -10532,7 +10545,8 @@ static void vmx_pf_no_vpid_test(void)
 	if (is_vpid_supported())
 		vmcs_clear_bits(CPU_EXEC_CTRL1, CPU_VPID);
 
-	__vmx_pf_exception_test(invalidate_tlb_no_vpid, NULL);
+	__vmx_pf_exception_test(invalidate_tlb_no_vpid, NULL,
+				vmx_pf_exception_test_guest);
 }
 
 static void invalidate_tlb_invvpid_addr(void *data)
@@ -10569,7 +10583,7 @@ static void __vmx_pf_vpid_test(invalidate_tlb_t inv_fn, u16 vpid)
 	vmcs_set_bits(CPU_EXEC_CTRL1, CPU_VPID);
 	vmcs_write(VPID, vpid);
 
-	__vmx_pf_exception_test(inv_fn, &vpid);
+	__vmx_pf_exception_test(inv_fn, &vpid, vmx_pf_exception_test_guest);
 }
 
 static void vmx_pf_invvpid_test(void)
@@ -10792,6 +10806,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_mtf_test),
 	TEST(vmx_mtf_pdpte_test),
 	TEST(vmx_pf_exception_test),
+	TEST(vmx_pf_exception_forced_emulation_test),
 	TEST(vmx_pf_no_vpid_test),
 	TEST(vmx_pf_invvpid_test),
 	TEST(vmx_pf_vpid_test),
-- 
2.40.0.348.gf938b09366-goog

