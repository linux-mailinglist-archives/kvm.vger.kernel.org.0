Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C8C6B5712
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjCKAtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjCKAsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:48:15 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D82213F56F
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:47:25 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id pb4-20020a17090b3c0400b00237873bd59bso2844038pjb.2
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678495617;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PL46ZVFFY4W6THy18E6ByGyTQEOReUquwUIR0GdzpTw=;
        b=UqLaWbM1URFaqajdFYpP3qWI1GLaFwLH3UIQad3gxXdNnR1HssacIG0e3wji4Ozdtd
         IEBfvROKjN8oIX1O4Ul4D2qwqpHTLH9/lqh4xWW2SSMSrxIZeWH0RCMdX7n4O02NM/3p
         4qVVv6rBds34QA6rHcUxGX7oOPvXMqfIG6ImBaYN/SclYX6ddXVFvHePPAY/J2nlqBNI
         yk27LLdv2THmLKQdIC1pviVhi2NqGZsw+1Vjr/uwqIqAJqF89zvGLLkN9sLoYKJLAmmu
         EEKx7yRv7Q65JJnBwtpoe+0V5j7yssZ6d3zuNkSllf8hv/AkmuD//pZLv2tauiB5tpTj
         QRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678495617;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PL46ZVFFY4W6THy18E6ByGyTQEOReUquwUIR0GdzpTw=;
        b=7icDIUTtfYnyY5neBMGjk0V8/m0jhDN2RKbPgfks4XI7otYLbEq/HD2g+dOsJrjuyV
         NXaBDHJaYYSjCmM1qJ9u1czsoDdRB0pMwYz9cTP90tlaQgsX2pqt6gau2TuuO1Y3QJkJ
         WJbW7tiF5jhZOwhp9P5+lLZWlbI2d46Q5JNFxDhxoE09H2ja8oK7jJ492CyEuPbe62KK
         jo29oEsN+IEUVNE1ezOmhQbTCYS1sCG6ikyvcUjUA63UNxtPnFdT3aPjfxQQVu3vIBxG
         Z49QOfS45fEd5bjIKxoecqsecZ0UzWc5k2AchCccHLfjBDkzHM1u0ZMlf8Pwb9rMzNUq
         XXJA==
X-Gm-Message-State: AO0yUKVoCaK+YdjMYbggnjt25eWftxorAGm7YHwt0+zkZMTjNVr2f0ZJ
        ih1eIum3qHDjtE6MlGph6agDo7H6uTU=
X-Google-Smtp-Source: AK7set9Mo+BuWR6CB5HxeWiftETZGTR15RP7d7hcjx3C76bs5pjrOGHQqlEKK3ZHcM9GayWy71Fb6QbcBNw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:ce43:0:b0:593:dc61:2161 with SMTP id
 y64-20020a62ce43000000b00593dc612161mr11028772pfg.2.1678495617175; Fri, 10
 Mar 2023 16:46:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:46:16 -0800
In-Reply-To: <20230311004618.920745-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311004618.920745-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311004618.920745-20-seanjc@google.com>
Subject: [PATCH v3 19/21] KVM: selftests: Refactor LBR_FMT test to avoid use
 of separate macro
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the LBR format test to use the bitfield instead of a separate
mask macro, mainly so that adding a nearly-identical PEBS format test
doesn't have to copy-paste-tweak the macro too.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c        | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 6733d879a00b..38aec88d733b 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -19,8 +19,6 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-#define PMU_CAP_LBR_FMT		0x3f
-
 union perf_capabilities {
 	struct {
 		u64	lbr_format:6;
@@ -169,7 +167,7 @@ static void test_immutable_perf_capabilities(union perf_capabilities host_cap)
 
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, NULL);
-	uint64_t val;
+	union perf_capabilities val = host_cap;
 	int r, bit;
 
 	for_each_set_bit(bit, &reserved_caps, 64) {
@@ -184,12 +182,13 @@ static void test_immutable_perf_capabilities(union perf_capabilities host_cap)
 	 * KVM only supports the host's native LBR format, as well as '0' (to
 	 * disable LBR support).  Verify KVM rejects all other LBR formats.
 	 */
-	for (val = 1; val <= PMU_CAP_LBR_FMT; val++) {
-		if (val == (host_cap.capabilities & PMU_CAP_LBR_FMT))
+	for (val.lbr_format = 1; val.lbr_format; val.lbr_format++) {
+		if (val.lbr_format == host_cap.lbr_format)
 			continue;
 
-		r = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, val);
-		TEST_ASSERT(!r, "Bad LBR FMT = 0x%lx didn't fail", val);
+		r = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, val.capabilities);
+		TEST_ASSERT(!r, "Bad LBR FMT = 0x%x didn't fail, host = 0x%x",
+			    val.lbr_format, host_cap.lbr_format);
 	}
 
 	kvm_vm_free(vm);
-- 
2.40.0.rc1.284.g88254d51c5-goog

