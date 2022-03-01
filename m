Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCA84C83B5
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 07:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbiCAGE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 01:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbiCAGEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 01:04:54 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D7460D92
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:13 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id n66-20020a254045000000b0062883b59ddbso181927yba.12
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=R9LFCj/8R7U0/GTd7qJpyU2UelQ8TY/nygE42d5f9qE=;
        b=fUBSH7+jK1sGBOB8u/GEXoG4oOTfdW8ES3NoUBvoYw2Cp2Pc1ubQ/UxNivIdqOotJa
         w92t9QSk3eR9ZsFmjjL7vZzhSikqFbo5YC6SQOayJRcvGPdlHQcV/jFEF26/HXlUkw8W
         J296udLWDSf0BO+pI0DZdwbE6DZeA08y1louDOgcQerBx49R3sPfcozyF3+xyZmmvYuy
         szIGa6W0toh0/GRVDQRNSdxNPMk7UaYejSMrhYLTJEW7qBMWrXbpm0TMI82OS2swfCWK
         E7npZGaYZOpsPFxiYL4ZFKaUnpwoP55UOUIFSi62jbFQvw8Qbst3vZ3hz7pFHZy7Y25g
         YjYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=R9LFCj/8R7U0/GTd7qJpyU2UelQ8TY/nygE42d5f9qE=;
        b=2/K3E0HvmEwgum81Sy//8275/2jxrIIW6jluWSC/PyjdKd8EV/MVE9KlCIvQOUf1dK
         /eScL6f1awrWptSR0HCi0Ii/LMvKCsSObysHoMpmV2iOs1YJC3JRDTUgZl1xxv5fmfcb
         pLsCPw0SM3abUc/eHGqY6+9ffzHWlZR9gD6tytnPw7dLK8LjtF1prDXRZpOruq27oZ0d
         ggGN8P6FOx2HKa1gDKsSapoQOfwVjEJQxqeKXGIryjrT/FWRyOIfIi5Ern/rQwa9+I6P
         wp9CyLpBRF3tlriOW/HuAmmucseo8xaQqiEWGwF8sFyOJBbfyWp8ChrtOuXmVWB5Kl4P
         afvQ==
X-Gm-Message-State: AOAM532doRobUVyx1ubS6CqbCuWM/tjtlwdto+1+3eBOz+JhFY1Ac8YS
        lOq9u20AVKKXTr9PwKcG1xWTp/RbIqX2spEb7WiwqrfnhCqcjhiLG18gsMBbvFb8/zVaT3kgs20
        Pyr0p+Sx2WecMGm7A6vfA/Dm40D7Ii9zGtauTH3V64DxH/MpnLjG5XIwksQ==
X-Google-Smtp-Source: ABdhPJww0d1qwBPTz8rrlAVmKp2/n6SkSu4UykAiV1FXSfIxx+O6pkg40lvqRRMUxFe7fEB2BjvFzSxvlVw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:189:b0:611:4169:48b3 with SMTP id
 t9-20020a056902018900b00611416948b3mr22793628ybh.18.1646114653165; Mon, 28
 Feb 2022 22:04:13 -0800 (PST)
Date:   Tue,  1 Mar 2022 06:03:51 +0000
In-Reply-To: <20220301060351.442881-1-oupton@google.com>
Message-Id: <20220301060351.442881-9-oupton@google.com>
Mime-Version: 1.0
References: <20220301060351.442881-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 8/8] selftests: KVM: Add test for BNDCFGS VMX control MSR bits
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
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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
 .../kvm/x86_64/vmx_control_msrs_test.c        | 97 +++++++++++++++++++
 2 files changed, 99 insertions(+)

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
index 4ab780483e15..132e7e435bfa 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
@@ -138,6 +138,102 @@ static void load_perf_global_ctrl_test(struct kvm_vm *vm)
 			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,	/* clear */
 			     0,						/* exp_set */
 			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);	/* exp_clear */
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
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS,
+			     0,					/* set */
+			     VM_ENTRY_LOAD_BNDCFGS,		/* clear */
+			     VM_ENTRY_LOAD_BNDCFGS,		/* exp_set */
+			     0);				/* exp_clear */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS,
+			     0,					/* set */
+			     VM_EXIT_CLEAR_BNDCFGS,		/* clear */
+			     VM_EXIT_CLEAR_BNDCFGS,		/* exp_set */
+			     0);				/* exp_clear */
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
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS,
+			     0,					/* set */
+			     0,					/* clear */
+			     0,					/* exp_set */
+			     VM_ENTRY_LOAD_BNDCFGS);		/* exp_clear */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS,
+			     0,					/* set */
+			     0,					/* clear */
+			     0,					/* exp_set */
+			     VM_EXIT_CLEAR_BNDCFGS);		/* exp_clear */
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
+	cap.cap = KVM_CAP_DISABLE_QUIRKS2;
+	cap.args[0] = KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS;
+	vm_enable_cap(vm, &cap);
+
+	/*
+	 * Test that userspace can clear these bits, even if it exposes MPX.
+	 */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS,
+			     0,					/* set */
+			     VM_ENTRY_LOAD_BNDCFGS,		/* clear */
+			     0,					/* exp_set */
+			     VM_ENTRY_LOAD_BNDCFGS);		/* exp_clear */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS,
+			     0,					/* set */
+			     VM_EXIT_CLEAR_BNDCFGS,		/* clear */
+			     0,					/* exp_set */
+			     VM_EXIT_CLEAR_BNDCFGS);		/* exp_clear */
 }
 
 int main(void)
@@ -155,6 +251,7 @@ int main(void)
 	vm = vm_create_default(VCPU_ID, 0, NULL);
 
 	load_perf_global_ctrl_test(vm);
+	bndcfgs_test(vm);
 
 	kvm_vm_free(vm);
 }
-- 
2.35.1.574.g5d30c73bfb-goog

