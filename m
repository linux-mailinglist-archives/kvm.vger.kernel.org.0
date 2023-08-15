Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC7177D44B
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 22:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbjHOUhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 16:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238579AbjHOUhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 16:37:32 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5201FEC
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:36:59 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6871080795cso7369939b3a.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 13:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131817; x=1692736617;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LxhxKcrFotwJQ4zXyPONZCebIAlPqsSs9CH/9edQop0=;
        b=bj+PXpWlZ7XfkKb4SRKBbwL7SoSHEUDD5ckoAw2oDS6Ke62B3JZ1T19/LzJA9RjlRK
         QBAMK0vbXvFT7evYAAn/GNYPnndmVmGOjwoHDR/YO0zDdI7w/DvR1DT66BRdTYj+5/s5
         at690uwMASz8CDMdPWQ15WZoRRuYD93/seeSslVjF5gWv/hdb9WxDJQDQTtAOvJoS0Tp
         +ZKWm9W44nQqN3AG4hjK+JpPLXZnmZ2YIlKJt+VCNFxtmi4G/P8H2E8QYLH/grCKHn3+
         SM52RUIBGxTixx8I1pJ82OdGFJsS+14QpRlzLGlhuBZ5Tw8z4P3Cv5QYW8Obz495A8bJ
         0ZQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131817; x=1692736617;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LxhxKcrFotwJQ4zXyPONZCebIAlPqsSs9CH/9edQop0=;
        b=JvfJcNWYXDfXKZgZHaiFUkpP9VmnpZj9GjlcKHvQCUlDbXZtxAASNtCl2dyGvfFJDr
         VmhFWx7KTd4pDDlhQ8geKro4S29yhPtBkRDF8hWhEUlZart2iltIXWTk2QcKI/Ip/HMl
         KFwMLlu+TlkOTdR4im+AfM+E7G2vm5vD5kNgWJFEjOwHc1kVldvTykzm/hnHvymfqfbK
         DdkQehsTxH1Us+jN42Mz0E84N9EcvL5czxuyD8gwy8eXCtQyaVUKbons0y265I0/NDhi
         Kg2c9ViVD6AHPDRwtisfoeW5VSp496h8+BYULgmDtwzs/agZQ+hSZg/5lN/avi8V1lq1
         YEKA==
X-Gm-Message-State: AOJu0YzNoGAHsUtPNH70k2F8F9pWAPBlu5SunHOKw+YCQzqow3AJFJXh
        GQONCdvSYI/ER9O+TIWIyacqHCBOP5U=
X-Google-Smtp-Source: AGHT+IGBxJa5dASO30nxuQUhZTH6cFETIEtK9WDd4OiBCgRh0iZb43uuIrHIXrBHs2b+Sf1rJklROSxZbRA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4a09:b0:688:7ac7:9f4b with SMTP id
 do9-20020a056a004a0900b006887ac79f4bmr82706pfb.1.1692131817570; Tue, 15 Aug
 2023 13:36:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 13:36:39 -0700
In-Reply-To: <20230815203653.519297-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815203653.519297-2-seanjc@google.com>
Subject: [PATCH v3 01/15] KVM: x86: Add a framework for enabling KVM-governed
 x86 features
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
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

Introduce yet another X86_FEATURE flag framework to manage and cache KVM
governed features (for lack of a better name).  "Governed" in this case
means that KVM has some level of involvement and/or vested interest in
whether or not an X86_FEATURE can be used by the guest.  The intent of the
framework is twofold: to simplify caching of guest CPUID flags that KVM
needs to frequently query, and to add clarity to such caching, e.g. it
isn't immediately obvious that SVM's bundle of flags for "optional nested
SVM features" track whether or not a flag is exposed to L1.

Begrudgingly define KVM_MAX_NR_GOVERNED_FEATURES for the size of the
bitmap to avoid exposing governed_features.h in arch/x86/include/asm/, but
add a FIXME to call out that it can and should be cleaned up once
"struct kvm_vcpu_arch" is no longer expose to the kernel at large.

Cc: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h  | 19 +++++++++++++
 arch/x86/kvm/cpuid.c             |  4 +++
 arch/x86/kvm/cpuid.h             | 46 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/governed_features.h |  9 +++++++
 4 files changed, 78 insertions(+)
 create mode 100644 arch/x86/kvm/governed_features.h

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 19d64f019240..60d430b4650f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -831,6 +831,25 @@ struct kvm_vcpu_arch {
 	struct kvm_cpuid_entry2 *cpuid_entries;
 	struct kvm_hypervisor_cpuid kvm_cpuid;
 
+	/*
+	 * FIXME: Drop this macro and use KVM_NR_GOVERNED_FEATURES directly
+	 * when "struct kvm_vcpu_arch" is no longer defined in an
+	 * arch/x86/include/asm header.  The max is mostly arbitrary, i.e.
+	 * can be increased as necessary.
+	 */
+#define KVM_MAX_NR_GOVERNED_FEATURES BITS_PER_LONG
+
+	/*
+	 * Track whether or not the guest is allowed to use features that are
+	 * governed by KVM, where "governed" means KVM needs to manage state
+	 * and/or explicitly enable the feature in hardware.  Typically, but
+	 * not always, governed features can be used by the guest if and only
+	 * if both KVM and userspace want to expose the feature to the guest.
+	 */
+	struct {
+		DECLARE_BITMAP(enabled, KVM_MAX_NR_GOVERNED_FEATURES);
+	} governed_features;
+
 	u64 reserved_gpa_bits;
 	int maxphyaddr;
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5a88affb2e1a..4ba43ae008cb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -313,6 +313,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
 
+	BUILD_BUG_ON(KVM_NR_GOVERNED_FEATURES > KVM_MAX_NR_GOVERNED_FEATURES);
+	bitmap_zero(vcpu->arch.governed_features.enabled,
+		    KVM_MAX_NR_GOVERNED_FEATURES);
+
 	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best && apic) {
 		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index b1658c0de847..284fa4704553 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -232,4 +232,50 @@ static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
 	return vcpu->arch.pv_cpuid.features & (1u << kvm_feature);
 }
 
+enum kvm_governed_features {
+#define KVM_GOVERNED_FEATURE(x) KVM_GOVERNED_##x,
+#include "governed_features.h"
+	KVM_NR_GOVERNED_FEATURES
+};
+
+static __always_inline int kvm_governed_feature_index(unsigned int x86_feature)
+{
+	switch (x86_feature) {
+#define KVM_GOVERNED_FEATURE(x) case x: return KVM_GOVERNED_##x;
+#include "governed_features.h"
+	default:
+		return -1;
+	}
+}
+
+static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
+{
+	return kvm_governed_feature_index(x86_feature) >= 0;
+}
+
+static __always_inline void kvm_governed_feature_set(struct kvm_vcpu *vcpu,
+						     unsigned int x86_feature)
+{
+	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
+
+	__set_bit(kvm_governed_feature_index(x86_feature),
+		  vcpu->arch.governed_features.enabled);
+}
+
+static __always_inline void kvm_governed_feature_check_and_set(struct kvm_vcpu *vcpu,
+							       unsigned int x86_feature)
+{
+	if (kvm_cpu_cap_has(x86_feature) && guest_cpuid_has(vcpu, x86_feature))
+		kvm_governed_feature_set(vcpu, x86_feature);
+}
+
+static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
+					  unsigned int x86_feature)
+{
+	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
+
+	return test_bit(kvm_governed_feature_index(x86_feature),
+			vcpu->arch.governed_features.enabled);
+}
+
 #endif
diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
new file mode 100644
index 000000000000..40ce8e6608cd
--- /dev/null
+++ b/arch/x86/kvm/governed_features.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(KVM_GOVERNED_FEATURE) || defined(KVM_GOVERNED_X86_FEATURE)
+BUILD_BUG()
+#endif
+
+#define KVM_GOVERNED_X86_FEATURE(x) KVM_GOVERNED_FEATURE(X86_FEATURE_##x)
+
+#undef KVM_GOVERNED_X86_FEATURE
+#undef KVM_GOVERNED_FEATURE
-- 
2.41.0.694.ge786442a9b-goog

