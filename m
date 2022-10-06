Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD365F5E16
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiJFAwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiJFAvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:51:46 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BD64B98D
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:51:39 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id m16-20020a17090ab79000b0020abf0d3ff4so183816pjr.1
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7soigY1/Tz7WOVBHk7JHdF5hp208aWepLSOPTuKShpk=;
        b=GXtN7HVAOXnla58u9BNt8+Ey5jQt5uUmrrbK9ZfJrdWtm6YFP/Dj8cVRqNMbUkkmob
         mN3945nSzxfQXtUoq8YVtyVxgelo/i0qumerWkZE2o1p8iN/HbES3dG+gDIuKcrxtaSv
         WbjJU/hc3/LRL8FuNcvIhvYe+PFemxPCwzu56iWb9sSt8Qz9l1qVvoqWCtQKxme+ArjL
         O8xT2RLuokpiwR8AjaRCov2UO3eK0YHoNIsxi8/6jpqQ9IC7MC1zJj08v5vdflnMlg9r
         hDhro6g9MZ+UNoOQHGIILBxWHN2NfRBXEyP3/obgdh/fqcJIc4jv5yQbusVjayCP4syw
         YBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7soigY1/Tz7WOVBHk7JHdF5hp208aWepLSOPTuKShpk=;
        b=WZpQS4XBaeBKNfqNZsCb7TMxv1I/E/i/jNKlgCBNyh6Hpi4hCm2eE+uDgdsRJRGKKq
         5YvdnSJfcXj7Aum6bIZYAeQISdX3RDYuXKrYqIUUl+ITtj/Jsvkd/whhonG2NStcswoD
         YPOlRhdGR61WOrCMewcct6eQoHllbHJQM/8PdJYtcu8QWlWmhYAPW86a8x89PLAyOeXX
         zTtXmQxpqPyG0WHVjlVaoVDjxVrYobuez/ZCwkT2VWTPD/mLpyuY2eMTaO4vrJqC9LRR
         gGd/narek6/uIY8KvkghXWWGuJKTLFSlFx9IuTGmQbDNTaS5yivgWYIaqGmrmLIJ3QPU
         J5fw==
X-Gm-Message-State: ACrzQf31lvoN27REUhs0jXQu75Uv5z2JD3pwbOAOW5Qq0Atk+zSCgaCz
        v4xnuOlv/64CjFdi10DScpG846wkFHE=
X-Google-Smtp-Source: AMsMyM6j6dPsXwG80Bv5TCwwBBE3hp2YFW4wFkbm8U1r9+v+wF3U9/2O/qoIFzmJ3xv91Z/3nERO0nRRGE0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:205:f08c:a82b with SMTP id
 w6-20020a17090ac98600b00205f08ca82bmr157518pjt.1.1665017498155; Wed, 05 Oct
 2022 17:51:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:51:19 +0000
In-Reply-To: <20221006005125.680782-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006005125.680782-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006005125.680782-7-seanjc@google.com>
Subject: [PATCH 06/12] KVM: selftests: Add kvm_cpu_*() support for X86_PROPERTY_*
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

Extent X86_PROPERTY_* support to KVM, i.e. add kvm_cpu_property() and
kvm_cpu_has_p(), and use the new helpers in kvm_get_cpu_address_width().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 34 ++++++++++++++++---
 .../selftests/kvm/lib/x86_64/processor.c      | 17 ++++++----
 2 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 55458e3d3ab4..b2babda9eac8 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -205,6 +205,7 @@ struct kvm_x86_cpu_property {
 
 #define X86_PROPERTY_MAX_EXT_LEAF		KVM_X86_CPU_PROPERTY(0x80000000, 0, EAX, 0, 31)
 #define X86_PROPERTY_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
+#define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
 #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
 
 #define X86_PROPERTY_MAX_CENTAUR_LEAF		KVM_X86_CPU_PROPERTY(0xC0000000, 0, EAX, 0, 31)
@@ -697,6 +698,34 @@ static inline bool kvm_cpu_has(struct kvm_x86_cpu_feature feature)
 	return kvm_cpuid_has(kvm_get_supported_cpuid(), feature);
 }
 
+uint32_t kvm_cpuid_property(const struct kvm_cpuid2 *cpuid,
+			    struct kvm_x86_cpu_property property);
+
+static inline uint32_t kvm_cpu_property(struct kvm_x86_cpu_property property)
+{
+	return kvm_cpuid_property(kvm_get_supported_cpuid(), property);
+}
+
+static __always_inline bool kvm_cpu_has_p(struct kvm_x86_cpu_property property)
+{
+	uint32_t max_leaf;
+
+	switch (property.function & 0xc0000000) {
+	case 0:
+		max_leaf = kvm_cpu_property(X86_PROPERTY_MAX_BASIC_LEAF);
+		break;
+	case 0x40000000:
+		max_leaf = kvm_cpu_property(X86_PROPERTY_MAX_KVM_LEAF);
+		break;
+	case 0x80000000:
+		max_leaf = kvm_cpu_property(X86_PROPERTY_MAX_EXT_LEAF);
+		break;
+	case 0xc0000000:
+		max_leaf = kvm_cpu_property(X86_PROPERTY_MAX_CENTAUR_LEAF);
+	}
+	return max_leaf >= property.function;
+}
+
 static inline size_t kvm_cpuid2_size(int nr_entries)
 {
 	return sizeof(struct kvm_cpuid2) +
@@ -809,11 +838,6 @@ static inline uint32_t kvm_get_cpuid_max_basic(void)
 	return kvm_get_supported_cpuid_entry(0)->eax;
 }
 
-static inline uint32_t kvm_get_cpuid_max_extended(void)
-{
-	return kvm_get_supported_cpuid_entry(0x80000000)->eax;
-}
-
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
 bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 30e8dfe2111e..99c309595c99 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -729,6 +729,13 @@ bool kvm_cpuid_has(const struct kvm_cpuid2 *cpuid,
 			     feature.reg, feature.bit, feature.bit);
 }
 
+uint32_t kvm_cpuid_property(const struct kvm_cpuid2 *cpuid,
+			    struct kvm_x86_cpu_property property)
+{
+	return __kvm_cpu_has(cpuid, property.function, property.index,
+			     property.reg, property.lo_bit, property.hi_bit);
+}
+
 uint64_t kvm_get_feature_msr(uint64_t msr_index)
 {
 	struct {
@@ -1066,16 +1073,12 @@ bool is_amd_cpu(void)
 
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 {
-	const struct kvm_cpuid_entry2 *entry;
-
-	/* SDM 4.1.4 */
-	if (kvm_get_cpuid_max_extended() < 0x80000008) {
+	if (!kvm_cpu_has_p(X86_PROPERTY_MAX_PHY_ADDR)) {
 		*pa_bits == kvm_cpu_has(X86_FEATURE_PAE) ? 36 : 32;
 		*va_bits = 32;
 	} else {
-		entry = kvm_get_supported_cpuid_entry(0x80000008);
-		*pa_bits = entry->eax & 0xff;
-		*va_bits = (entry->eax >> 8) & 0xff;
+		*pa_bits = kvm_cpu_property(X86_PROPERTY_MAX_PHY_ADDR);
+		*va_bits = kvm_cpu_property(X86_PROPERTY_MAX_VIRT_ADDR);
 	}
 }
 
-- 
2.38.0.rc1.362.ged0d419d3c-goog

