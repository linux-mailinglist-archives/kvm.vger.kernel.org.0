Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C45154BB2D
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352353AbiFNUHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350584AbiFNUHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:20 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA524D9C1
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:18 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id p123-20020a625b81000000b0051c31cc75dfso4237088pfb.5
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KTI4cDcDxRU2AdleYfc0AxKMoqQ5q7lkRFosyv3tl7Y=;
        b=WEDEWQkuXhSllM1JC9oQhj/pCnwiE7iF98H3mjG/aYZZ7lbVH/6Z5dbZa7YrmruZMW
         Jp27bzveE+Ya+fSj6NgZXVZyxb1uxWP1S0lA8Qr4kP4CvvxSWlXLWt7EsYPnkFkQWaj0
         sCcQiUm8syctpWhMtyaziC8rn++i43vhBDU5t4AwLaGKLKSezD6tDLqAhYrRF6ii9tLe
         /Duk3QjYcaze8akzq0b3LPqWsgErUuJ67+4UhN7gzeigWS3+Rbl53Maeqarb4LqOhqtv
         sZ5+JeDO95H6ZjeSK2Q95rnKsdIFq4a3s1MolsGYUFUSuaks2AONXQwKGOw91oARXftT
         FG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KTI4cDcDxRU2AdleYfc0AxKMoqQ5q7lkRFosyv3tl7Y=;
        b=55486GbvRDxVkl1Z+HgyJMGk8aqe0oyGFeAu9DnimCNkjGKsf8n8+tJg53HO77FLTk
         gAIKr2+bX8LNnIOhJ85tvQOwef8ZhN8unYapCIW6MlczkFCkeo7iBhnXKXXrrQ5zyTnf
         jYKzCqcDPHN72V+y6TMpKg0/l8Bdhm9Mv/sNusYDkchjjkCFkjr3A3bucCMHF4ZLXnGz
         jFG2rUFqTOv+5TLP+qMLCdGiBz1Ha1z2snVW9J8wp4yforTk6YI/wv5xV9ODXk1foXtx
         MF3JoIoCffjVPWVdld+zta87qRvHRctzxMWsM/IZ2XFkJETPkmnCxKKkY/JTQ4q+6PKB
         p8LA==
X-Gm-Message-State: AJIora8PUEKm/B2f9ip3zm4pf7RzanUAfiAXxVBVhHzcNhuaPPspXTKT
        U85aHZEaV27vHPkbdws6dmtHml75rK0=
X-Google-Smtp-Source: AGRyM1v4EQlG3wiKA/PqQz/ZBuEzfBcFq0tXOl0lwAd6C12EawhwojNf4d35w9mQ0v5jBs3DgR1AdWQRttM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:6946:b0:167:8ff3:1608 with SMTP id
 k6-20020a170902694600b001678ff31608mr5765641plt.116.1655237238390; Tue, 14
 Jun 2022 13:07:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:28 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 03/42] KVM: selftests: Add framework to query KVM CPUID bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Add X86_FEATURE_* magic in the style of KVM-Unit-Tests' implementation,
where the CPUID function, index, output register, and output bit position
are embedded in the macro value.  Add kvm_cpu_has() to query KVM's
supported CPUID and use it set_sregs_test, which is the most prolific
user of manual feature querying.

Opportunstically rename calc_cr4_feature_bits() to
calc_supported_cr4_feature_bits() to better capture how the CR4 bits are
chosen.

Link: https://lore.kernel.org/all/20210422005626.564163-1-ricarkol@google.com
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 106 ++++++++++++++++--
 .../selftests/kvm/lib/x86_64/processor.c      |  22 ++++
 .../selftests/kvm/x86_64/set_sregs_test.c     |  28 ++---
 3 files changed, 128 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 2b13ea74362a..ee3f7239cea7 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -43,23 +43,96 @@
 #define X86_CR4_SMAP		(1ul << 21)
 #define X86_CR4_PKE		(1ul << 22)
 
+/* Note, these are ordered alphabetically to match kvm_cpuid_entry2.  Eww. */
+enum cpuid_output_regs {
+	KVM_CPUID_EAX,
+	KVM_CPUID_EBX,
+	KVM_CPUID_ECX,
+	KVM_CPUID_EDX
+};
+
+/*
+ * Pack the information into a 64-bit value so that each X86_FEATURE_XXX can be
+ * passed by value with no overhead.
+ */
+struct kvm_x86_cpu_feature {
+	u32	function;
+	u16	index;
+	u8	reg;
+	u8	bit;
+};
+#define	KVM_X86_CPU_FEATURE(fn, idx, gpr, __bit)	\
+({							\
+	struct kvm_x86_cpu_feature feature = {		\
+		.function = fn,				\
+		.index = idx,				\
+		.reg = KVM_CPUID_##gpr,			\
+		.bit = __bit,				\
+	};						\
+							\
+	feature;					\
+})
+
+/*
+ * Basic Leafs, a.k.a. Intel defined
+ */
+#define	X86_FEATURE_MWAIT		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 3)
+#define	X86_FEATURE_VMX			KVM_X86_CPU_FEATURE(0x1, 0, ECX, 5)
+#define	X86_FEATURE_SMX			KVM_X86_CPU_FEATURE(0x1, 0, ECX, 6)
+#define	X86_FEATURE_PCID		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 17)
+#define	X86_FEATURE_MOVBE		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 22)
+#define	X86_FEATURE_TSC_DEADLINE_TIMER	KVM_X86_CPU_FEATURE(0x1, 0, ECX, 24)
+#define	X86_FEATURE_XSAVE		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 26)
+#define	X86_FEATURE_OSXSAVE		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 27)
+#define	X86_FEATURE_RDRAND		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 30)
+#define	X86_FEATURE_MCE			KVM_X86_CPU_FEATURE(0x1, 0, EDX, 7)
+#define	X86_FEATURE_APIC		KVM_X86_CPU_FEATURE(0x1, 0, EDX, 9)
+#define	X86_FEATURE_CLFLUSH		KVM_X86_CPU_FEATURE(0x1, 0, EDX, 19)
+#define	X86_FEATURE_XMM			KVM_X86_CPU_FEATURE(0x1, 0, EDX, 25)
+#define	X86_FEATURE_XMM2		KVM_X86_CPU_FEATURE(0x1, 0, EDX, 26)
+#define	X86_FEATURE_FSGSBASE		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 0)
+#define	X86_FEATURE_TSC_ADJUST		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 1)
+#define	X86_FEATURE_HLE			KVM_X86_CPU_FEATURE(0x7, 0, EBX, 4)
+#define	X86_FEATURE_SMEP	        KVM_X86_CPU_FEATURE(0x7, 0, EBX, 7)
+#define	X86_FEATURE_INVPCID		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 10)
+#define	X86_FEATURE_RTM			KVM_X86_CPU_FEATURE(0x7, 0, EBX, 11)
+#define	X86_FEATURE_SMAP		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 20)
+#define	X86_FEATURE_PCOMMIT		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 22)
+#define	X86_FEATURE_CLFLUSHOPT		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 23)
+#define	X86_FEATURE_CLWB		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 24)
+#define	X86_FEATURE_UMIP		KVM_X86_CPU_FEATURE(0x7, 0, ECX, 2)
+#define	X86_FEATURE_PKU			KVM_X86_CPU_FEATURE(0x7, 0, ECX, 3)
+#define	X86_FEATURE_LA57		KVM_X86_CPU_FEATURE(0x7, 0, ECX, 16)
+#define	X86_FEATURE_RDPID		KVM_X86_CPU_FEATURE(0x7, 0, ECX, 22)
+#define	X86_FEATURE_SHSTK		KVM_X86_CPU_FEATURE(0x7, 0, ECX, 7)
+#define	X86_FEATURE_IBT			KVM_X86_CPU_FEATURE(0x7, 0, EDX, 20)
+#define	X86_FEATURE_SPEC_CTRL		KVM_X86_CPU_FEATURE(0x7, 0, EDX, 26)
+#define	X86_FEATURE_ARCH_CAPABILITIES	KVM_X86_CPU_FEATURE(0x7, 0, EDX, 29)
+#define	X86_FEATURE_PKS			KVM_X86_CPU_FEATURE(0x7, 0, ECX, 31)
+
+/*
+ * Extended Leafs, a.k.a. AMD defined
+ */
+#define	X86_FEATURE_SVM			KVM_X86_CPU_FEATURE(0x80000001, 0, ECX, 2)
+#define	X86_FEATURE_NX			KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 20)
+#define	X86_FEATURE_GBPAGES		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 26)
+#define	X86_FEATURE_RDTSCP		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 27)
+#define	X86_FEATURE_LM			KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 29)
+#define	X86_FEATURE_RDPRU		KVM_X86_CPU_FEATURE(0x80000008, 0, EBX, 4)
+#define	X86_FEATURE_AMD_IBPB		KVM_X86_CPU_FEATURE(0x80000008, 0, EBX, 12)
+#define	X86_FEATURE_NPT			KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 0)
+#define	X86_FEATURE_LBRV		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 1)
+#define	X86_FEATURE_NRIPS		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 3)
+#define X86_FEATURE_TSCRATEMSR          KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 4)
+#define X86_FEATURE_PAUSEFILTER         KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 10)
+#define X86_FEATURE_PFTHRESHOLD         KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 12)
+#define	X86_FEATURE_VGIF		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
+
 /* CPUID.1.ECX */
 #define CPUID_VMX		(1ul << 5)
-#define CPUID_SMX		(1ul << 6)
-#define CPUID_PCID		(1ul << 17)
 #define CPUID_XSAVE		(1ul << 26)
 #define CPUID_OSXSAVE		(1ul << 27)
 
-/* CPUID.7.EBX */
-#define CPUID_FSGSBASE		(1ul << 0)
-#define CPUID_SMEP		(1ul << 7)
-#define CPUID_SMAP		(1ul << 20)
-
-/* CPUID.7.ECX */
-#define CPUID_UMIP		(1ul << 2)
-#define CPUID_PKU		(1ul << 3)
-#define CPUID_LA57		(1ul << 16)
-
 /* CPUID.0x8000_0001.EDX */
 #define CPUID_GBPAGES		(1ul << 26)
 
@@ -488,6 +561,15 @@ static inline void vcpu_xcrs_set(struct kvm_vcpu *vcpu, struct kvm_xcrs *xcrs)
 }
 
 struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
+
+bool kvm_cpuid_has(const struct kvm_cpuid2 *cpuid,
+		   struct kvm_x86_cpu_feature feature);
+
+static inline bool kvm_cpu_has(struct kvm_x86_cpu_feature feature)
+{
+	return kvm_cpuid_has(kvm_get_supported_cpuid(), feature);
+}
+
 struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vcpu *vcpu);
 
 static inline int __vcpu_set_cpuid(struct kvm_vcpu *vcpu,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index c46a22f8a9af..7666f24a145a 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -734,6 +734,28 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 	return cpuid;
 }
 
+bool kvm_cpuid_has(const struct kvm_cpuid2 *cpuid,
+		   struct kvm_x86_cpu_feature feature)
+{
+	const struct kvm_cpuid_entry2 *entry;
+	int i;
+
+	for (i = 0; i < cpuid->nent; i++) {
+		entry = &cpuid->entries[i];
+
+		/*
+		 * The output registers in kvm_cpuid_entry2 are in alphabetical
+		 * order, but kvm_x86_cpu_feature matches that mess, so yay
+		 * pointer shenanigans!
+		 */
+		if (entry->function == feature.function &&
+		    entry->index == feature.index)
+			return (&entry->eax)[feature.reg] & BIT(feature.bit);
+	}
+
+	return false;
+}
+
 uint64_t kvm_get_feature_msr(uint64_t msr_index)
 {
 	struct {
diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index dd344439ad33..2bb08bf2125d 100644
--- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -43,36 +43,32 @@ static void test_cr4_feature_bit(struct kvm_vcpu *vcpu, struct kvm_sregs *orig,
 	TEST_ASSERT(!memcmp(&sregs, orig, sizeof(sregs)), "KVM modified sregs");
 }
 
-static uint64_t calc_cr4_feature_bits(struct kvm_vm *vm)
+static uint64_t calc_supported_cr4_feature_bits(void)
 {
-	struct kvm_cpuid_entry2 *cpuid_1, *cpuid_7;
 	uint64_t cr4;
 
-	cpuid_1 = kvm_get_supported_cpuid_entry(1);
-	cpuid_7 = kvm_get_supported_cpuid_entry(7);
-
 	cr4 = X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE |
 	      X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE | X86_CR4_PGE |
 	      X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_OSXMMEXCPT;
-	if (cpuid_7->ecx & CPUID_UMIP)
+	if (kvm_cpu_has(X86_FEATURE_UMIP))
 		cr4 |= X86_CR4_UMIP;
-	if (cpuid_7->ecx & CPUID_LA57)
+	if (kvm_cpu_has(X86_FEATURE_LA57))
 		cr4 |= X86_CR4_LA57;
-	if (cpuid_1->ecx & CPUID_VMX)
+	if (kvm_cpu_has(X86_FEATURE_VMX))
 		cr4 |= X86_CR4_VMXE;
-	if (cpuid_1->ecx & CPUID_SMX)
+	if (kvm_cpu_has(X86_FEATURE_SMX))
 		cr4 |= X86_CR4_SMXE;
-	if (cpuid_7->ebx & CPUID_FSGSBASE)
+	if (kvm_cpu_has(X86_FEATURE_FSGSBASE))
 		cr4 |= X86_CR4_FSGSBASE;
-	if (cpuid_1->ecx & CPUID_PCID)
+	if (kvm_cpu_has(X86_FEATURE_PCID))
 		cr4 |= X86_CR4_PCIDE;
-	if (cpuid_1->ecx & CPUID_XSAVE)
+	if (kvm_cpu_has(X86_FEATURE_XSAVE))
 		cr4 |= X86_CR4_OSXSAVE;
-	if (cpuid_7->ebx & CPUID_SMEP)
+	if (kvm_cpu_has(X86_FEATURE_SMEP))
 		cr4 |= X86_CR4_SMEP;
-	if (cpuid_7->ebx & CPUID_SMAP)
+	if (kvm_cpu_has(X86_FEATURE_SMAP))
 		cr4 |= X86_CR4_SMAP;
-	if (cpuid_7->ecx & CPUID_PKU)
+	if (kvm_cpu_has(X86_FEATURE_PKU))
 		cr4 |= X86_CR4_PKE;
 
 	return cr4;
@@ -99,7 +95,7 @@ int main(int argc, char *argv[])
 
 	vcpu_sregs_get(vcpu, &sregs);
 
-	sregs.cr4 |= calc_cr4_feature_bits(vm);
+	sregs.cr4 |= calc_supported_cr4_feature_bits();
 	cr4 = sregs.cr4;
 
 	rc = _vcpu_sregs_set(vcpu, &sregs);
-- 
2.36.1.476.g0c4daa206d-goog

