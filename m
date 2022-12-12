Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF54664A734
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiLLSiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbiLLShh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:37:37 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08C912D32
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:35 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id b6-20020a17090acc0600b0021a1a90a3e0so403430pju.0
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RTf0vqd6q8+sD3Ai3Fk1grBLzBMEa+ZNH0AvURQNQ5o=;
        b=pYVYkqiR43tK0hPCEG/kVDHMEt2aJJUYg1bH40nsGgVdu1wYh+ANfWYTGzSekKt7Sl
         h70vvfs3BMrzkPRXUFrR6/CXV9WmP4E63xa4OPbGvnC97OUhEXc4uBdP44any6xY4x2X
         XUcUeWHjOyxyNIxvonAUP7ubiABB/4tD8LSKPGME40AwJp+c8uojQNm7Tf9GED8AtSGn
         RUAskYjgoDDcGPOJL9o47bYtISj8wuSvy7AlOoo3qvNmRhoX58Brzc5N4o8Mr+7odksx
         F/3swp5pNcElcc5cciV9JdGK5e2XJqOLdojPsYsS1dm8E9puOTLfvVzV3V7S1Jadu5oR
         SAKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RTf0vqd6q8+sD3Ai3Fk1grBLzBMEa+ZNH0AvURQNQ5o=;
        b=b69wK/iOV3iPT0G1inYxGb21su/8k+6QERTFj56rsD8ulaWWqU2RdXr9Zi5P6/PWkR
         acd1GX8PQt4rC82dufIf2QXZZxBFsFWP/3Q488w/5FM/A6ZbJRN6EvgXA/9E1Zb4Yyrj
         db5tBP12ggYW4Om7z7ZqMz6PQ2sgbo69cdCpACCKHMFX839KeoZ83iIZJcMxroKoK009
         qODUcqAvYranZvZQbIxeaWS01J31VPHc6qtQGtQanlU94P1mRlKEP34FD4kdOW58MRYX
         9xBYCnr2Q1/XjRdsvou8CzCItnk3UX/jr9PfkUBECk7BgaM6r7hp57dwq90CN5yxiFhs
         j2Vw==
X-Gm-Message-State: ANoB5pluuK0hHtEiuTLM9Wmumf/sF/h/c782dIUrJirmbIqpv+MeF2n0
        Xhbck1RhwMmTSRMl0q39KQXPRbzjACMC
X-Google-Smtp-Source: AA0mqf7XdqvvUzZbtRGowjArMbHVjopaA21CdyKAOLrrdgs3Mm9aPIa64BP5PeVL66Hm5zFNegKxkGstEE55
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:9c8:b0:20d:48bc:6666 with SMTP id
 66-20020a17090a09c800b0020d48bc6666mr2082pjo.98.1670870255442; Mon, 12 Dec
 2022 10:37:35 -0800 (PST)
Date:   Mon, 12 Dec 2022 10:37:14 -0800
In-Reply-To: <20221212183720.4062037-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221212183720.4062037-8-vipinsh@google.com>
Subject: [Patch v4 07/13] KVM: selftests: Test Hyper-V invariant TSC control
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Add a test for the newly introduced Hyper-V invariant TSC control feature:
- HV_X64_MSR_TSC_INVARIANT_CONTROL is not available without
 HV_ACCESS_TSC_INVARIANT CPUID bit set and available with it.
- BIT(0) of HV_X64_MSR_TSC_INVARIANT_CONTROL controls the filtering of
architectural invariant TSC (CPUID.80000007H:EDX[8]) bit.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/hyperv.h     |  3 ++
 .../selftests/kvm/include/x86_64/processor.h  |  1 +
 .../selftests/kvm/x86_64/hyperv_features.c    | 47 +++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index ab455c4efc66..28eb99046475 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -335,4 +335,7 @@ struct hyperv_test_pages {
 struct hyperv_test_pages *vcpu_alloc_hyperv_test_pages(struct kvm_vm *vm,
 						       vm_vaddr_t *p_hv_pages_gva);
 
+/* HV_X64_MSR_TSC_INVARIANT_CONTROL bits */
+#define HV_INVARIANT_TSC_EXPOSED               BIT_ULL(0)
+
 #endif /* !SELFTEST_KVM_HYPERV_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 5d310abe6c3f..80cbb9218f19 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -134,6 +134,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_GBPAGES		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 26)
 #define	X86_FEATURE_RDTSCP		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 27)
 #define	X86_FEATURE_LM			KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 29)
+#define	X86_FEATURE_INVTSC		KVM_X86_CPU_FEATURE(0x80000007, 0, EDX, 8)
 #define	X86_FEATURE_RDPRU		KVM_X86_CPU_FEATURE(0x80000008, 0, EBX, 4)
 #define	X86_FEATURE_AMD_IBPB		KVM_X86_CPU_FEATURE(0x80000008, 0, EBX, 12)
 #define	X86_FEATURE_NPT			KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 0)
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index b00240963974..258267df8e2a 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -63,6 +63,16 @@ static void guest_msr(struct msr_data *msr)
 	if (msr->write)
 		GUEST_ASSERT_3(msr_val == msr->write_val, msr->idx,
 			       msr_val, msr->write_val);
+
+	/* Invariant TSC bit appears when TSC invariant control MSR is written to */
+	if (msr->idx == HV_X64_MSR_TSC_INVARIANT_CONTROL) {
+		if (!this_cpu_has(HV_ACCESS_TSC_INVARIANT))
+			GUEST_ASSERT(this_cpu_has(X86_FEATURE_INVTSC));
+		else
+			GUEST_ASSERT(this_cpu_has(X86_FEATURE_INVTSC) ==
+				     !!(msr_val & HV_INVARIANT_TSC_EXPOSED));
+	}
+
 done:
 	GUEST_DONE();
 }
@@ -118,6 +128,7 @@ static void guest_test_msrs_access(void)
 	int stage = 0;
 	vm_vaddr_t msr_gva;
 	struct msr_data *msr;
+	bool has_invtsc = kvm_cpu_has(X86_FEATURE_INVTSC);
 
 	while (true) {
 		vm = vm_create_with_one_vcpu(&vcpu, guest_msr);
@@ -435,6 +446,42 @@ static void guest_test_msrs_access(void)
 			break;
 
 		case 44:
+			/* MSR is not available when CPUID feature bit is unset */
+			if (!has_invtsc)
+				continue;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = false;
+			msr->fault_expected = true;
+			break;
+		case 45:
+			/* MSR is vailable when CPUID feature bit is set */
+			if (!has_invtsc)
+				continue;
+			vcpu_set_cpuid_feature(vcpu, HV_ACCESS_TSC_INVARIANT);
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = false;
+			msr->fault_expected = false;
+			break;
+		case 46:
+			/* Writing bits other than 0 is forbidden */
+			if (!has_invtsc)
+				continue;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = true;
+			msr->write_val = 0xdeadbeef;
+			msr->fault_expected = true;
+			break;
+		case 47:
+			/* Setting bit 0 enables the feature */
+			if (!has_invtsc)
+				continue;
+			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
+			msr->write = true;
+			msr->write_val = 1;
+			msr->fault_expected = false;
+			break;
+
+		default:
 			kvm_vm_free(vm);
 			return;
 		}
-- 
2.39.0.rc1.256.g54fd8350bd-goog

