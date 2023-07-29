Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043D4767A9C
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbjG2BQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237259AbjG2BQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:16:41 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65464211
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:27 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bbb34b091dso18455065ad.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593387; x=1691198187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M16bFNHvkcRN+2tjzsNjLxHb/2/W6Tup2HBNR7k8XBw=;
        b=wkIBFVPWFfHrP0auQtEC0KxkpWuqZA9JHKhtroNl3WuY3KuiVrDLc8D70ZMgcXwzIh
         cfwUMT+0y2EH48RakkphiG2mPoMg6sVs3xyk1sqv6cU7y5J+h5XqLbGb7jMOUNKQ8+1Y
         D62JDozO2QM/sR30/oUeAjVJxU+af/6kM38tbc/EI6nbIu8LNc6+uPE2/CnXGLMFZRlb
         OTLKwOOxFHeZAzeg+GHA/GXYWYoJBxmTDGp21jeO20rWC1kZCXosHoepcBX2CAEXRBLM
         z4WkWW8Cd/OUdef6v1CdItqUjmfYTIM0qMS/QL8V+NYmf/8Xa8zE66E+V/JzEDqPifdP
         x1aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593387; x=1691198187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M16bFNHvkcRN+2tjzsNjLxHb/2/W6Tup2HBNR7k8XBw=;
        b=WlKIvAeg27HgDF4XnCFP7wFRFk7B2o4FDR2mjsas0dDzidJhJfBFA5omM9ugJmGZnE
         2qVnQiSIwIk15o+hgzpkC34HzEiDlL71s2HCgN7fs1A8OJmgvKe2uRUUvFBIAHBg33/0
         gz1ED0KcL0GnfMdbY4R3jhYAndbiWcPjxMnW/srdi0yE5HCCm4jnY7v17NRheKtaRN6P
         IVjxomdtCIzT45j5vbeP4Do9mCOpArRK2yHEVMc2olGZMJatuuBbVlucOLbx0rpvvzRF
         Gzrj55gKuotfZ8MiBWNLunu6o/haSk4TNUAYRm0VMEL8lC1yhoOsfj8ooIi9hWHEIZDF
         vm6A==
X-Gm-Message-State: ABy/qLYBfkRJqeEzYl9BVYimALno6pwcTF/uyicgDWk9KB1PGIDzGln4
        GRcEaZrRUnLTTcY/QmBrVJTLyR8WlUc=
X-Google-Smtp-Source: APBJJlHPdWNRrX2vCjd70d69yFLt3KezmqaL9eTpvVY0WgkKo1Dwh5Lw5m4/O7c/2AAnazdTaLIVUHNn36M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2445:b0:1bb:c7bc:ce9a with SMTP id
 l5-20020a170903244500b001bbc7bcce9amr13660pls.10.1690593386757; Fri, 28 Jul
 2023 18:16:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:15:54 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-8-seanjc@google.com>
Subject: [PATCH v2 07/21] KVM: x86: Add a framework for enabling KVM-governed
 x86 features
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h  | 19 +++++++++++++
 arch/x86/kvm/cpuid.c             |  4 +++
 arch/x86/kvm/cpuid.h             | 46 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/governed_features.h |  9 +++++++
 4 files changed, 78 insertions(+)
 create mode 100644 arch/x86/kvm/governed_features.h

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dad9331c5270..007fa8bfd634 100644
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
index 7f4d13383cf2..ef826568c222 100644
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
index b1658c0de847..3000fbe97678 100644
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
+static __always_inline int kvm_is_governed_feature(unsigned int x86_feature)
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
2.41.0.487.g6d72f3e995-goog

