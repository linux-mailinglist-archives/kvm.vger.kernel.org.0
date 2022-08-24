Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83ED59F1AE
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbiHXDDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbiHXDDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:08 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031C580492
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:50 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id r74-20020a632b4d000000b0041bc393913eso6984018pgr.10
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=+yIYSNMHN63JV1GUJoPfVwo+V85Kr+tRWCM+hzY6XYI=;
        b=fzu5kMIiWREdmbLllRf+ppgoA3X2wm1TYxGwaZZ8pX1wKBBVgXRoSSWhidV8DtM1P0
         Pp1Z2V6YjIahNjZHlmDLsaTa9r9bQvbPyltHZ4pJF/YYrVZouLpEX9J1sAuXNKOYvODo
         jDqwT5K1s+ZgJXe1ZVREMvNI0Nq63+lJPITA+eveyRTYGL/8YKvouleLMwXaQUoOehz+
         crV65NS8wZ+Bi5cjTaUd4W4f2giWxkZtyz8RFMYbupHh88mV8oB1tkkTRQ+ZorQuG9Ia
         qCaM26/QbICEt3fVmBgSniGTP/mqvR87iGoivdya9yix2Vle1H5476zIbLvzarAnrSCF
         3ASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=+yIYSNMHN63JV1GUJoPfVwo+V85Kr+tRWCM+hzY6XYI=;
        b=AxrJ57pZI/d6bxK7rOSGVpJ6XR2pgBPu0n95WnDzYGrU0/jFrLcZpUbXBT16tA4nbo
         0wLFYJd7Lh/vr69BVcaAQw1HX9so6Kzw8t9W4/N3PYIJ9g8dPRXspO2iae3GkOdlW2WR
         Y3BDTloMSXOoDii5NScPjsbQolGF7KzvMAsphzJK1czUxyg1nC0ZvAMkFQhmkCxxHI5E
         LY4wX4WfHPp6lk1FWt5QkWg4PfmurdQPqbTFcklCpSQ151u+Hi6hgj3UQGXBm8LhXIEf
         fIdyVaNlqHZkWVkuQ+Yb5f0TntIUWJv2XDaA4b+uNUJxetp5EE2SkNfbufZDWAFfA5QB
         fIBA==
X-Gm-Message-State: ACgBeo0QLeyaHi4Sngl2gCMk+JMzIh3AUcJhequJdo/M1OWdwFSwjQXB
        X6D/NM8GcVfyXD6yL3WxsJcXxra4m38=
X-Google-Smtp-Source: AA6agR6IwMmGu7MBaw06oPoadN6rzCQSjebTU6nxNnEfujqkjoUn27NCM5mypheBfQ5yh9O2UX0KOpGVgTo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2308:b0:52f:8ae9:9465 with SMTP id
 h8-20020a056a00230800b0052f8ae99465mr27368411pfh.77.1661310109613; Tue, 23
 Aug 2022 20:01:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:07 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 05/36] KVM: x86: Report error when setting CPUID if
 Hyper-V allocation fails
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
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

Return -ENOMEM back to userspace if allocating the Hyper-V vCPU struct
fails when enabling Hyper-V in guest CPUID.  Silently ignoring failure
means that KVM will not have an up-to-date CPUID cache if allocating the
struct succeeds later on, e.g. when activating SynIC.

Rejecting the CPUID operation also guarantess that vcpu->arch.hyperv is
non-NULL if hyperv_enabled is true, which will allow for additional
cleanup, e.g. in the eVMCS code.

Note, the initialization needs to be done before CPUID is set, and more
subtly before kvm_check_cpuid(), which potentially enables dynamic
XFEATURES.  Sadly, there's no easy way to avoid exposing Hyper-V details
to CPUID or vice versa.  Expose kvm_hv_vcpu_init() and the Hyper-V CPUID
signature to CPUID instead of exposing cpuid_entry2_find() outside of
CPUID code.  It's hard to envision kvm_hv_vcpu_init() being misused,
whereas cpuid_entry2_find() absolutely shouldn't be used outside of core
CPUID code.

Fixes: 10d7bf1e46dc ("KVM: x86: hyper-v: Cache guest CPUID leaves determining features availability")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c  | 18 +++++++++++++++++-
 arch/x86/kvm/hyperv.c | 30 ++++++++++++++----------------
 arch/x86/kvm/hyperv.h |  6 +++++-
 3 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 75dcf7a72605..ffdc28684cb7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -311,6 +311,15 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
+static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
+{
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = cpuid_entry2_find(entries, nent, HYPERV_CPUID_INTERFACE,
+				  KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	return entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX;
+}
+
 static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -341,7 +350,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr4_guest_rsvd_bits =
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
 
-	kvm_hv_set_cpuid(vcpu);
+	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu->arch.cpuid_entries,
+						    vcpu->arch.cpuid_nent));
 
 	/* Invoke the vendor callback only after the above state is updated. */
 	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
@@ -404,6 +414,12 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 		return 0;
 	}
 
+	if (kvm_cpuid_has_hyperv(e2, nent)) {
+		r = kvm_hv_vcpu_init(vcpu);
+		if (r)
+			return r;
+	}
+
 	r = kvm_check_cpuid(vcpu, e2, nent);
 	if (r)
 		return r;
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 8aadd31ed058..bf4729e8cc80 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -38,9 +38,6 @@
 #include "irq.h"
 #include "fpu.h"
 
-/* "Hv#1" signature */
-#define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
-
 #define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
 
 static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
@@ -934,7 +931,7 @@ static void stimer_init(struct kvm_vcpu_hv_stimer *stimer, int timer_index)
 	stimer_prepare_msg(stimer);
 }
 
-static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
+int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	int i;
@@ -1984,26 +1981,27 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	return HV_STATUS_SUCCESS;
 }
 
-void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
+void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu, bool hyperv_enabled)
 {
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct kvm_cpuid_entry2 *entry;
-	struct kvm_vcpu_hv *hv_vcpu;
 
-	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_INTERFACE);
-	if (entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX) {
-		vcpu->arch.hyperv_enabled = true;
-	} else {
-		vcpu->arch.hyperv_enabled = false;
+	vcpu->arch.hyperv_enabled = hyperv_enabled;
+
+	if (!hv_vcpu) {
+		/*
+		 * KVM should have already allocated kvm_vcpu_hv if Hyper-V is
+		 * enabled in CPUID.
+		 */
+		WARN_ON_ONCE(vcpu->arch.hyperv_enabled);
 		return;
 	}
 
-	if (kvm_hv_vcpu_init(vcpu))
-		return;
-
-	hv_vcpu = to_hv_vcpu(vcpu);
-
 	memset(&hv_vcpu->cpuid_cache, 0, sizeof(hv_vcpu->cpuid_cache));
 
+	if (!vcpu->arch.hyperv_enabled)
+		return;
+
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
 	if (entry) {
 		hv_vcpu->cpuid_cache.features_eax = entry->eax;
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index da2737f2a956..1030b1b50552 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -23,6 +23,9 @@
 
 #include <linux/kvm_host.h>
 
+/* "Hv#1" signature */
+#define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
+
 /*
  * The #defines related to the synthetic debugger are required by KDNet, but
  * they are not documented in the Hyper-V TLFS because the synthetic debugger
@@ -141,7 +144,8 @@ void kvm_hv_request_tsc_page_update(struct kvm *kvm);
 
 void kvm_hv_init_vm(struct kvm *kvm);
 void kvm_hv_destroy_vm(struct kvm *kvm);
-void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu);
+int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu);
+void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu, bool hyperv_enabled);
 int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce);
 int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
 int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
-- 
2.37.1.595.g718a3a8f04-goog

