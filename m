Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E584967E4
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 23:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiAUW3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 17:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiAUW3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 17:29:48 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E18C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 14:29:48 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id o9-20020a170902d4c900b0014ab4c82aacso2195018plg.16
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 14:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ccjI/IWR5Whh2qHqkqlzXUnNsqIJF67ztrFNI0VfcTU=;
        b=rQ+aq92nBfOUrsMfWPnWTUsKkN4XRhmHDAtMMVmKMPvxSh6uY5Ku7QDdXq75X/tlxe
         pOYL6nT3fTiwTwfVf7NQdu+k65FX8A7VWloE5UWTXcNqYghoIC2ToAWA+ilMVLB+27gF
         G4NEDZOq7zWipi4ZoKkD8dLK72Zn4m0Aq10jr24e64mYeKWw3U6j9UZw+6jV9ahreuKT
         vxHNl8hukSU1GQi68T3xxQ9Jo5uMDVFA5p50SF4eU8ZIQGtf3bvU8JxUp+6T+z/IX3ie
         p+Tcrnv1Ulw+nTojosgnD0u1b406P3VMz61ZvWZWCewFaJTowCRDJomfupq9KpKn7W3K
         4UWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ccjI/IWR5Whh2qHqkqlzXUnNsqIJF67ztrFNI0VfcTU=;
        b=aHKBtjkuNSVeUZo7/YcZK1LJc1zST/bx46nGlbGeahLe/f5CPXiw+4JmWmOfCjUhvT
         ARUS4yS03rtJEb7t52qfK+ec1iAUxt/caImg9EMCx+PoUBMCUTZLdTQr7NPyNsccQ3zB
         Zz0gN410OXiX8tYn1JzVRTNUnnHdtUgtu4I7KywnuT8Io5Hr5BYQRFjNnqytkl1vymlw
         fA5g4C188NsGoJL7xNg47IbSEdDDyL2bnwohgYjqp2/zQU2LJ3lowCrAGSF16bxX9BMb
         KiNhf6mvW3+0YfqZ+wVUZWwZT3hb5jJkMcJZM8HUpSlwWJ8s8TZOof3Nr6Q5S1kg/de4
         5hzA==
X-Gm-Message-State: AOAM5325IWjBnNcm9iVS8sRm72YMVWq4VCNccJ1HLhPUdK3aBtIT/yZl
        wSVyG6kE3Bzm0Cdh/6uIAQH5xhZTG93p/nfCDYUux07hRBHLLzhbrmrTNLwohRlqFeURYk/4Ayv
        Y4PQKlzd7PzKtS3wU/mnbLocBftaet32x5wI3J1nQVC/jSAurFaapbGWL62CX84Dk1w==
X-Google-Smtp-Source: ABdhPJwfWXndTh6X8eWgatCKmTxULPAEYfzSnr0flSVrN/nrg1dtkdRcAjZSlg3fTmXTAigL9r1S1xCKNal5IG0=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a63:4c09:: with SMTP id
 z9mr2201896pga.471.1642804187375; Fri, 21 Jan 2022 14:29:47 -0800 (PST)
Date:   Fri, 21 Jan 2022 22:29:33 +0000
In-Reply-To: <20220121222933.696067-1-daviddunn@google.com>
Message-Id: <20220121222933.696067-4-daviddunn@google.com>
Mime-Version: 1.0
References: <20220121222933.696067-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v4 3/3] KVM: selftests: Verify disabling PMU virtualization
 via KVM_CAP_CONFIG_PMU
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com, seanjc@google.com
Cc:     daviddunn@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a VM with PMU disabled via KVM_CAP_PMU_CONFIG, the PMU will not be
usable by the guest.  On Intel, this causes a #GP.  And on AMD, the
counters no longer increment.

KVM_CAP_PMU_CONFIG must be invoked on a VM prior to creating VCPUs.

Signed-off-by: David Dunn <daviddunn@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index c715adcbd487..cffa2e019eac 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -325,6 +325,49 @@ static void test_not_member_allow_list(struct kvm_vm *vm)
 	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
 }
 
+/*
+ * Verify KVM_CAP_PMU_DISABLE prevents the use of the PMU.
+ *
+ * Note that KVM_CAP_PMU_CAPABILITY must be invoked prior to creating VCPUs.
+ */
+static void test_pmu_config_disable(void (*guest_code)(void))
+{
+	int r;
+	struct kvm_vm *vm;
+	struct kvm_cpuid2 *cpuid2;
+	struct kvm_cpuid_entry2 *entry;
+	struct kvm_enable_cap cap = { 0 };
+	bool sane;
+
+	r = kvm_check_cap(KVM_CAP_PMU_CAPABILITY);
+	if ((r & KVM_CAP_PMU_DISABLE) == 0)
+		return;
+
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+
+	cap.cap = KVM_CAP_PMU_CAPABILITY;
+	cap.args[0] = KVM_CAP_PMU_DISABLE;
+	r = vm_enable_cap(vm, &cap);
+	TEST_ASSERT(r == 0, "Failed KVM_CAP_PMU_DISABLE.");
+
+	vm_vcpu_add_default(vm, VCPU_ID, guest_code);
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	cpuid2 = vcpu_get_cpuid(vm, VCPU_ID);
+	entry = get_cpuid(cpuid2, 0xA, 0);
+	if (entry) {
+		TEST_ASSERT(entry->eax == 0 && entry->ebx == 0 &&
+			    entry->ecx == 0 && entry->edx == 0,
+			    "CPUID should not advertise PMU when disabled.");
+	}
+
+	sane = sanity_check_pmu(vm);
+	TEST_ASSERT(!sane, "Guest should not be able to use disabled PMU.");
+
+	kvm_vm_free(vm);
+}
+
 /*
  * Check for a non-zero PMU version, at least one general-purpose
  * counter per logical processor, an EBX bit vector of length greater
@@ -430,5 +473,7 @@ int main(int argc, char *argv[])
 
 	kvm_vm_free(vm);
 
+	test_pmu_config_disable(guest_code);
+
 	return 0;
 }
-- 
2.35.0.rc0.227.g00780c9af4-goog

