Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE8253D44C
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350001AbiFDBVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349991AbiFDBVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:21:15 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE7856774
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:13 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id z18-20020a656112000000b003fa0ac4b723so4571170pgu.5
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=atPH1T2TubvL7PAUqYl19amHcm0CJWgBwICdsU+Bjlo=;
        b=Ofqb0/p28Y+xQw2Geh7UqeeARknTFRH6VFOMGeh3GBpGmEaYOLeRT99sUVTrluzUEu
         viaobvJ8WbVGFkTlT+xSQJNNdtFvN0PGqVgVBdtMAF9uj97ABSFfWWOXHumtxxxgzAgL
         a4XjV13y6LQNvUv2QpoCmScdURHN8aME53QSFfOXxJm5Xt1GgHFK1bHuHfn5MsAqzOQq
         JGb9VfWBZ7Euv0q4fbeuwYH02Uw/5DgGAhVvKsm66No4/B/fCZX8GqNUQm5m/jreQdhS
         ckWjgtdB+ScnTKd6BC0U4hRPgn+zFPZsfP2wCcfLLh/zOfwluUTTwvC2KMOC8fVUaUIJ
         QLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=atPH1T2TubvL7PAUqYl19amHcm0CJWgBwICdsU+Bjlo=;
        b=UE2guvXCFavRM4Ty2tw2Bxdl9lqHuZ4670/Bo984bwu/QshUjxacioTIAH+fkZVBpY
         lkh/a2ZRMrnD9EPqn3jFHf2kUpcq13YUuXeW4nBfkAPY564PTFfPIa457f8JpaWJ//Qv
         MxrlydWJnSU7v4R8S38DOuJ0g3HJ2gDL/JVvl/bLVOCKHKpJe0hJhS7IacEB/mVzt7MN
         5JzpRj2n0ecxnf9B40r8l5dAdW1NWDy2+JodfUQLdermmUkxrVCOsFtEUB/yDBK7K++f
         gv5sWLldLl5TqpP42kzy3hAlKT5tKpZKqbWR2wv/U0cyEl03KLH6tA6vtySLS6dP6DeO
         d1TA==
X-Gm-Message-State: AOAM5315Tx+VrGxCbz9bli52C3CL9YCCt1cvRBIBO91i33/d1kGHJY/o
        T/jooLkMScaFVhu6AKl6Q+NvuWBpfgc=
X-Google-Smtp-Source: ABdhPJwlu3BFfGOsEZTkFbArnW/+qTHVi9kD4VrBqV1cmLxB2QxCNybzYbcemWsOSmfFNZ73q9jca3eAio0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr4680pje.0.1654305672782; Fri, 03 Jun
 2022 18:21:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:23 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 07/42] KVM: selftests: Use kvm_cpu_has() to query PDCM in PMU selftest
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_cpu_has() in the PMU test to query PDCM support instead of open
coding equivalent functionality using kvm_get_supported_cpuid_index().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 1 +
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c | 7 ++-----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 24ffa7c238ff..ff8b92c435f5 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -79,6 +79,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_MWAIT		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 3)
 #define	X86_FEATURE_VMX			KVM_X86_CPU_FEATURE(0x1, 0, ECX, 5)
 #define	X86_FEATURE_SMX			KVM_X86_CPU_FEATURE(0x1, 0, ECX, 6)
+#define	X86_FEATURE_PDCM		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 15)
 #define	X86_FEATURE_PCID		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 17)
 #define	X86_FEATURE_MOVBE		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 22)
 #define	X86_FEATURE_TSC_DEADLINE_TIMER	KVM_X86_CPU_FEATURE(0x1, 0, ECX, 24)
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index eb592fae44ef..667d48e8c1e0 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -17,7 +17,6 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-#define X86_FEATURE_PDCM	(1<<15)
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
 #define PMU_CAP_LBR_FMT		0x3f
 
@@ -55,7 +54,6 @@ static void guest_code(void)
 int main(int argc, char *argv[])
 {
 	struct kvm_cpuid2 *cpuid;
-	struct kvm_cpuid_entry2 *entry_1_0;
 	struct kvm_cpuid_entry2 *entry_a_0;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
@@ -70,11 +68,10 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	cpuid = kvm_get_supported_cpuid();
 
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
+
 	TEST_REQUIRE(kvm_get_cpuid_max_basic() >= 0xa);
-
-	entry_1_0 = kvm_get_supported_cpuid_index(1, 0);
 	entry_a_0 = kvm_get_supported_cpuid_index(0xa, 0);
-	TEST_REQUIRE(entry_1_0->ecx & X86_FEATURE_PDCM);
 
 	eax.full = entry_a_0->eax;
 	__TEST_REQUIRE(eax.split.version_id, "PMU is not supported by the vCPU");
-- 
2.36.1.255.ge46751e96f-goog

