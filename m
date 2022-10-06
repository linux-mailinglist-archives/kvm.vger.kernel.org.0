Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43E65F5E15
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiJFAwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiJFAwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:52:01 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3581546611
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:51:47 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id a20-20020a17090acb9400b0020aff595f9eso177280pju.5
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4+CWUStYTQoTh0BU8RtshI04zg9Zxynj28PspoRPHoc=;
        b=rOtPmzwq4YRmk3PIS3+JztMvwdz7Z1mI20nu2l4Ha69F1mkOv+MBWjoZetB8JMjsu4
         N/RDXxVQJPvLuvI46EXDdA3azXP/Pb8ixNP49936Y4Q5Svauz9vq2TukSzldjjRAGlyQ
         nBUYWm3dObDKO6FSekxcnDdQ7w5uSUhxPla1CxFtZlqIqPVpOeD+MciqQkkIFtMmuxnX
         MgHimDfUbK9Zt5F9Qd1PKcTEHWApumNoHC5NgmDB1RBGYjXEcIBc9IDBsPom4aBVwX4i
         Bg2L6Zz9zweQtyQUywTeJom7Y9y5DM2++kVw7qpoI8kwukNsKhCsjYjbcRedR+Li7E4E
         av4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4+CWUStYTQoTh0BU8RtshI04zg9Zxynj28PspoRPHoc=;
        b=rcWOsxitttr+3vYCdzYrvH/Jilj8syp54FDRz/ztlqMTFhkmBmsdLcPv/Aj8e7jIyJ
         WOFf/gEBNppmxJTKKiAm5CzDunNwJWgxpsjYxDG1SdITNmrcIqMOoXEe5ga6S7a2CHM0
         FxoV83DRK/MfXglILhGQGtBDWh+OkCRC54rkr3LtR3O3tiFJWYtxYw88rmYXNF9ABcPD
         wObPLLIsDp2KjEA3YuCxCBVit0ebfQutKzspFLglWF6AfUMPbqaU4CAawaBD4u5EMYbT
         9KCjrCNwAoW4FKkratR/YhP60LsdOemBsORuqRq0IpA/a6wZKofldisgnGWRN3lmaby3
         cW6Q==
X-Gm-Message-State: ACrzQf1XrxoQqjX+moWZ2x6mvdheenw5DBJrFWpO/iz8zH4P5jKJATME
        TtJziKO1otmYbatkBT7B5/gRmZZVuNU=
X-Google-Smtp-Source: AMsMyM6Zc7TATcUVy3byTQCMQVUVqVcMugAkoChUZ7xp+S/H/0fCKciymhrfxnjKqjdOYFpK2DUChO1+oIs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41c6:b0:178:348e:f760 with SMTP id
 u6-20020a17090341c600b00178348ef760mr1932110ple.123.1665017506765; Wed, 05
 Oct 2022 17:51:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:51:24 +0000
In-Reply-To: <20221006005125.680782-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006005125.680782-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006005125.680782-12-seanjc@google.com>
Subject: [PATCH 11/12] KVM: selftests: Add and use KVM helpers for x86 Family
 and Model
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add KVM variants of the x86 Family and Model helpers, and use them in the
PMU event filter test.  Open code the retrieval of KVM's supported CPUID
entry 0x1.0 in anticipation of dropping kvm_get_supported_cpuid_entry().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 19 +++++++++++++--
 .../kvm/x86_64/pmu_event_filter_test.c        | 23 +++++++++----------
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index a1dafd4e8f43..021c5f375158 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -748,10 +748,27 @@ static inline void vcpu_xcrs_set(struct kvm_vcpu *vcpu, struct kvm_xcrs *xcrs)
 	vcpu_ioctl(vcpu, KVM_SET_XCRS, xcrs);
 }
 
+const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
+					       uint32_t function, uint32_t index);
 const struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
 const struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void);
 const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu);
 
+static inline uint32_t kvm_cpu_fms(void)
+{
+	return get_cpuid_entry(kvm_get_supported_cpuid(), 0x1, 0)->eax;
+}
+
+static inline uint32_t kvm_cpu_family(void)
+{
+	return x86_family(kvm_cpu_fms());
+}
+
+static inline uint32_t kvm_cpu_model(void)
+{
+	return x86_model(kvm_cpu_fms());
+}
+
 bool kvm_cpuid_has(const struct kvm_cpuid2 *cpuid,
 		   struct kvm_x86_cpu_feature feature);
 
@@ -819,8 +836,6 @@ static inline struct kvm_cpuid2 *allocate_kvm_cpuid2(int nr_entries)
 	return cpuid;
 }
 
-const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
-					       uint32_t function, uint32_t index);
 void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const struct kvm_cpuid2 *cpuid);
 void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu);
 
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 5cc88ac31c45..540b122ea588 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -369,20 +369,19 @@ static bool use_intel_pmu(void)
 	       kvm_pmu_has(X86_PMU_FEATURE_BRANCH_INSNS_RETIRED);
 }
 
-static bool is_zen1(uint32_t eax)
+static bool is_zen1(uint32_t family, uint32_t model)
 {
-	return x86_family(eax) == 0x17 && x86_model(eax) <= 0x0f;
+	return family == 0x17 && model <= 0x0f;
 }
 
-static bool is_zen2(uint32_t eax)
+static bool is_zen2(uint32_t family, uint32_t model)
 {
-	return x86_family(eax) == 0x17 &&
-		x86_model(eax) >= 0x30 && x86_model(eax) <= 0x3f;
+	return family == 0x17 && model >= 0x30 && model <= 0x3f;
 }
 
-static bool is_zen3(uint32_t eax)
+static bool is_zen3(uint32_t family, uint32_t model)
 {
-	return x86_family(eax) == 0x19 && x86_model(eax) <= 0x0f;
+	return family == 0x19 && model <= 0x0f;
 }
 
 /*
@@ -395,13 +394,13 @@ static bool is_zen3(uint32_t eax)
  */
 static bool use_amd_pmu(void)
 {
-	const struct kvm_cpuid_entry2 *entry;
+	uint32_t family = kvm_cpu_family();
+	uint32_t model = kvm_cpu_model();
 
-	entry = kvm_get_supported_cpuid_entry(1);
 	return is_amd_cpu() &&
-		(is_zen1(entry->eax) ||
-		 is_zen2(entry->eax) ||
-		 is_zen3(entry->eax));
+		(is_zen1(family, model) ||
+		 is_zen2(family, model) ||
+		 is_zen3(family, model));
 }
 
 int main(int argc, char *argv[])
-- 
2.38.0.rc1.362.ged0d419d3c-goog

