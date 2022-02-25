Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16DC4C4F4E
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 21:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbiBYUJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 15:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbiBYUJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 15:09:13 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70BC1F082F
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:40 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id j7-20020a92ca07000000b002c2b8f24cffso1035053ils.9
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+z9T7bYrV+NM+vqU8+yYapGWIC1qXPQ/EmOJqIiKsIk=;
        b=T293RxDOkxQ8vtVtX4MliH97EvLk9/RCYtVZ/uZ4phItmXAE/zaqRDMSkRNa/mMymW
         p2rfWmYthCN6N3V2sOZy/NH6nslBH2Gvl8bXDbIkFMGw5w161MxGnLCzJKVT4HaHovHU
         3h6UkjnMW+TYN9+rzUiFLlOm/l1JiICPlW4K0D8jyIPFH1YVnTzHw93EmEZMd/1gzzFS
         JxfQnrfoHYPegfuczYw6acMMQzelOkezU5wvi2g+52RhAF6alUXTzTgUbk+WNW2s3LvN
         fs61o7kdMVzJwIGNQTdzJGJOIkWumcqr06JgVJFWeJf9OOdjbnbjOk0bCC4/N0CDG3Bc
         roaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+z9T7bYrV+NM+vqU8+yYapGWIC1qXPQ/EmOJqIiKsIk=;
        b=3by22owBTE9l8lYyJjFCzRrev1ipiu1Gyo1Llp3fJMFoXquXP+LS3FExXYfMS0bJAt
         awam+sN/AjXL9BJixKXHSAV/ASjbT6eHEiMTfuu/jC3j1Ogtr6zv6BjOHZauWITWuNdV
         aQAEUHAXsCJlPUS4R7zUIrCG+3xscwgkdm5NuNiI7eGs8bHd1WIpZfuIvNXxjw//BYAB
         q/DzFwMRRnXbaRH2sB1an1+sge/NQcFl8LMqdfQWNyk3a68pOVRah3F9qWdlalOBMrjg
         ETD5IXCyh49df6ca8Wb1jyC0c+/Lv4CJg/40L83KPh6/69jvHT+ofhwiHRNscRd/ez8I
         qEWQ==
X-Gm-Message-State: AOAM5312EhUJzEuY7Fnf+mprm6txFUWnBg15sKjZPWhtvYtEzIGgyuTJ
        eJi7pQxcBEMk2/9Po4uD4Fcn8334DCbhH/35wgnTKtdvUiTevCeS3JVBRnVd2NzUXrjgP8tg3Ri
        cSsL+YZ3+C/jsZ8lbzfcWVWc+eVrFym+T2mcO4xYZ9DLoVrfWwBvZQdkfpA==
X-Google-Smtp-Source: ABdhPJzWYy8KlIAgCYf7jWgwg1fhEtA6dwddzWLvsHDbmTeKV98SkIqC1oZki6p8Sg/sVitNYUae5yFS810=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:cd91:0:b0:314:2535:6f75 with SMTP id
 l17-20020a02cd91000000b0031425356f75mr7012427jap.307.1645819719969; Fri, 25
 Feb 2022 12:08:39 -0800 (PST)
Date:   Fri, 25 Feb 2022 20:08:23 +0000
In-Reply-To: <20220225200823.2522321-1-oupton@google.com>
Message-Id: <20220225200823.2522321-7-oupton@google.com>
Mime-Version: 1.0
References: <20220225200823.2522321-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 6/6] selftests: KVM: Add test for BNDCFGS VMX control MSR bits
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that the default behavior of KVM is to ignore userspace MSR writes
and conditionally expose the "{load,clear} IA32_BNDCFGS" bits in the VMX
control MSRs if the guest CPUID exposes MPX. Additionally, test that
when the corresponding quirk is disabled, userspace can still clear
these bits regardless of what is exposed in CPUID.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/include/x86_64/vmx.h        |  2 +
 .../kvm/x86_64/vmx_control_msrs_test.c        | 87 +++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 583ceb0d1457..811c66d9be74 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -80,6 +80,7 @@
 #define VM_EXIT_SAVE_IA32_EFER			0x00100000
 #define VM_EXIT_LOAD_IA32_EFER			0x00200000
 #define VM_EXIT_SAVE_VMX_PREEMPTION_TIMER	0x00400000
+#define VM_EXIT_CLEAR_BNDCFGS			0x00800000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -90,6 +91,7 @@
 #define VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL	0x00002000
 #define VM_ENTRY_LOAD_IA32_PAT			0x00004000
 #define VM_ENTRY_LOAD_IA32_EFER			0x00008000
+#define VM_ENTRY_LOAD_BNDCFGS			0x00010000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
index ab598d9e7582..66ff2e81b9f1 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
@@ -128,6 +128,92 @@ static void load_perf_global_ctrl_test(struct kvm_vm *vm)
 			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
 			     0,
 			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
+
+	/* cleanup, enable the quirk again */
+	cap.args[0] = 0;
+	vm_enable_cap(vm, &cap);
+}
+
+static void clear_mpx_bit(struct kvm_cpuid2 *cpuid)
+{
+	struct kvm_cpuid_entry2 ent;
+
+	ent = *kvm_get_supported_cpuid_index(0x7, 0x0);
+	ent.ebx &= ~(1u << 14);
+
+	TEST_ASSERT(set_cpuid(cpuid, &ent),
+		    "failed to clear CPUID.07H:EBX[14] (MPX)");
+}
+
+static void bndcfgs_test(struct kvm_vm *vm)
+{
+	uint32_t entry_low, entry_high, exit_low, exit_high;
+	struct kvm_enable_cap cap = {0};
+	struct kvm_cpuid2 *cpuid;
+
+	get_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, &entry_low, &entry_high);
+	get_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, &exit_low, &exit_high);
+
+	if (!(entry_high & VM_ENTRY_LOAD_BNDCFGS) ||
+	    !(exit_high & VM_EXIT_CLEAR_BNDCFGS)) {
+		print_skip("\"load/clear IA32_BNDCFGS\" VM-{Entry,Exit} controls not supported");
+		return;
+	}
+
+	/*
+	 * Test that KVM will set these bits regardless of userspace if the
+	 * guest CPUID exposes MPX.
+	 */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, 0,
+			     VM_ENTRY_LOAD_BNDCFGS,
+			     VM_ENTRY_LOAD_BNDCFGS,
+			     0);
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, 0,
+			     VM_EXIT_CLEAR_BNDCFGS,
+			     VM_EXIT_CLEAR_BNDCFGS,
+			     0);
+
+	/*
+	 * Hide MPX in CPUID
+	 */
+	cpuid = _kvm_get_supported_cpuid();
+	clear_mpx_bit(cpuid);
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	free(cpuid);
+
+	/*
+	 * Test that KVM will clear these bits if the guest CPUID does not
+	 * expose MPX
+	 */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, 0, 0, 0,
+			     VM_ENTRY_LOAD_BNDCFGS);
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, 0, 0, 0,
+			     VM_EXIT_CLEAR_BNDCFGS);
+
+	/*
+	 * Re-enable MPX in CPUID
+	 */
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	/*
+	 * Disable the quirk, giving userspace control of the VMX capability
+	 * MSRs.
+	 */
+	cap.cap = KVM_CAP_DISABLE_QUIRKS;
+	cap.args[0] = KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS;
+	vm_enable_cap(vm, &cap);
+
+	/*
+	 * Test that userspace can clear these bits, even if it exposes MPX.
+	 */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, 0,
+			     VM_ENTRY_LOAD_BNDCFGS,
+			     0,
+			     VM_ENTRY_LOAD_BNDCFGS);
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, 0,
+			     VM_EXIT_CLEAR_BNDCFGS,
+			     0,
+			     VM_EXIT_CLEAR_BNDCFGS);
 }
 
 int main(void)
@@ -140,6 +226,7 @@ int main(void)
 	vm = vm_create_default(VCPU_ID, 0, NULL);
 
 	load_perf_global_ctrl_test(vm);
+	bndcfgs_test(vm);
 
 	kvm_vm_free(vm);
 }
-- 
2.35.1.574.g5d30c73bfb-goog

