Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348C85F5E13
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiJFAwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiJFAv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:51:59 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F9361B33
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:51:45 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y16-20020a17090322d000b0017848b6f556so170686plg.19
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jTDfTXOxJxyj7hkmYar0+I86ueOMf9vHS9LeaM7akak=;
        b=nNMVa/bNxHCJXpCCtHRBqkA2JULWc7psHgbOK+RLr1kF/r9zekj18eWRib1joyFZ/v
         gDEqz6lXzUc5owEzCxNEXdMUhXirSfKMx6961i7mLmRfoW1qdbhG26WwVcaSkwDAo0Rv
         RVxdWnwSCsRAMPRf7lnyeHGpo7PMOtJDDyWpa9pJ0kJ+qb6vGWyd2OcolOkBLkTpIpG1
         4kwqBNMirXs+R8boDJsV/V9miv5L9eInVpvR/JIONfAatrvnmwZEsuCbHY0cmXCPP6ED
         50YY5CpmT1J+cAsyMrx+AAVAjamo6HHb4MGdkqTdhF9XZYEOvTdA2tz9Nq1CFcF4JyMf
         7ZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jTDfTXOxJxyj7hkmYar0+I86ueOMf9vHS9LeaM7akak=;
        b=Yz9SCjQEsxfx5nSBxFYOp8BmYtYAEVM8uupIPmcgtU+0z0zrw9eySEN2r9bIMcAw2R
         9bSdERFoOeCq5RS7OystO75IgKayrGMELHFJThVtBFBG6lRBSoipVxhRDaUkKYeLlw8n
         9qNTk633vArtZhy0O39HcJnQnSWosELGvpCTChZoNrRZWrpAsWozARxT05dAB/BDmOta
         BH6khmM47q0gOUlPNKCkJWLQPazPOUKdrV8gfImDyBgx+w+Neth4z1uvfWal5y4gSu0/
         nASyXIUFsebz+07YU2sQkz1ohR/USJdQ6b2V7iLta3657n6yt0XCpwwDKJRCB33RTFUh
         k4Mw==
X-Gm-Message-State: ACrzQf3GmoevphaKHbunv8xnoYO+4IEClVtHzBjPuc8RIEW4FA851JuW
        ygsEeUipqEapwp2EotNJBAtnh/PzR+g=
X-Google-Smtp-Source: AMsMyM7prMIXH0PMPxXMlIoCBFacLrfCKPBlJW4qeCe8v+fKqy9mRfYM1xuSJ+W4lTVDmcDmnqnJ4vuLGak=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cd06:b0:203:ae0e:6a21 with SMTP id
 d6-20020a17090acd0600b00203ae0e6a21mr157806pju.0.1665017505094; Wed, 05 Oct
 2022 17:51:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:51:23 +0000
In-Reply-To: <20221006005125.680782-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006005125.680782-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006005125.680782-11-seanjc@google.com>
Subject: [PATCH 10/12] KVM: selftests: Add dedicated helpers for getting x86
 Family and Model
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

Add dedicated helpers for getting x86's Family and Model, which are the
last holdouts that "need" raw access to CPUID information.  FMS info is
a mess and requires not only splicing together multiple values, but
requires doing so conditional in the Family case.

Provide wrappers to reduce the odds of copy+paste errors, but mostly to
allow for the eventual removal of kvm_get_supported_cpuid_entry().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 52 +++++++++++++------
 .../selftests/kvm/lib/x86_64/processor.c      |  4 +-
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index acad7184d1b6..a1dafd4e8f43 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -247,6 +247,23 @@ struct kvm_x86_pmu_feature {
 
 #define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED	KVM_X86_PMU_FEATURE(BRANCH_INSNS_RETIRED, 5)
 
+static inline unsigned int x86_family(unsigned int eax)
+{
+	unsigned int x86;
+
+	x86 = (eax >> 8) & 0xf;
+
+	if (x86 == 0xf)
+		x86 += (eax >> 20) & 0xff;
+
+	return x86;
+}
+
+static inline unsigned int x86_model(unsigned int eax)
+{
+	return ((eax >> 12) & 0xf0) | ((eax >> 4) & 0x0f);
+}
+
 /* Page table bitfield declarations */
 #define PTE_PRESENT_MASK        BIT_ULL(0)
 #define PTE_WRITABLE_MASK       BIT_ULL(1)
@@ -510,6 +527,24 @@ static inline void cpuid(uint32_t function,
 	return __cpuid(function, 0, eax, ebx, ecx, edx);
 }
 
+static inline uint32_t this_cpu_fms(void)
+{
+	uint32_t eax, ebx, ecx, edx;
+
+	cpuid(1, &eax, &ebx, &ecx, &edx);
+	return eax;
+}
+
+static inline uint32_t this_cpu_family(void)
+{
+	return x86_family(this_cpu_fms());
+}
+
+static inline uint32_t this_cpu_model(void)
+{
+	return x86_model(this_cpu_fms());
+}
+
 static inline uint32_t __this_cpu_has(uint32_t function, uint32_t index,
 				      uint8_t reg, uint8_t lo, uint8_t hi)
 {
@@ -652,23 +687,6 @@ static inline void cpu_relax(void)
 bool is_intel_cpu(void);
 bool is_amd_cpu(void);
 
-static inline unsigned int x86_family(unsigned int eax)
-{
-	unsigned int x86;
-
-	x86 = (eax >> 8) & 0xf;
-
-	if (x86 == 0xf)
-		x86 += (eax >> 20) & 0xff;
-
-	return x86;
-}
-
-static inline unsigned int x86_model(unsigned int eax)
-{
-	return ((eax >> 12) & 0xf0) | ((eax >> 4) & 0x0f);
-}
-
 struct kvm_x86_state *vcpu_save_state(struct kvm_vcpu *vcpu);
 void vcpu_load_state(struct kvm_vcpu *vcpu, struct kvm_x86_state *state);
 void kvm_x86_state_cleanup(struct kvm_x86_state *state);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 99c309595c99..9fb949d63305 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1286,7 +1286,6 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 {
 	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
 	unsigned long ht_gfn, max_gfn, max_pfn;
-	uint32_t eax, ebx, ecx, edx;
 	uint8_t maxphyaddr;
 
 	max_gfn = (1ULL << (vm->pa_bits - vm->page_shift)) - 1;
@@ -1301,8 +1300,7 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 
 	/* Before family 17h, the HyperTransport area is just below 1T.  */
 	ht_gfn = (1 << 28) - num_ht_pages;
-	cpuid(1, &eax, &ebx, &ecx, &edx);
-	if (x86_family(eax) < 0x17)
+	if (this_cpu_family() < 0x17)
 		goto done;
 
 	/*
-- 
2.38.0.rc1.362.ged0d419d3c-goog

