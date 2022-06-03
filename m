Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9DDC53C205
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240396AbiFCAqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240148AbiFCApX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:23 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D973465E
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:16 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id e19-20020aa79813000000b0051bba91468eso2882534pfl.14
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qKtRzPfDLOOFEO2wSRdLW5pILrJuZSfC3PuWiM+CjCg=;
        b=EmGymdcPeHrIz1wRxcU32dl8Q7T6JgH1WZLEG0CJs9puadul5S4J6N4/5OdyA7HYLW
         NVLpT5QVkAsAIAViayCwRYF4gBWYMbh4S/gkKaYhtW4vmYtc/morWbvZLXb3usVBDALz
         CKMKSrvw1wPaxI4F6OIEXWCOh9yb5WSoyOzRkz9VyZ1c4O1YKYAS9zfOqkq9AhxC2KXN
         Vz69KNbUgRFiPaSEBMJbzXHoxuvT3czrUfsVae10SEe4eXGLC0Zlqj2j5bdcaYg11QY4
         sBu5UPX0tJVIlKjmbRKApiCjSDc/65Ad8pCqOUcDNbZcR9BmbadEWseWK9zEZBCI4uON
         ppJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qKtRzPfDLOOFEO2wSRdLW5pILrJuZSfC3PuWiM+CjCg=;
        b=7BxZqRmVbaYckecbtVFrr69r+uSVm9vGbyUZfW2HNcVTJnIsObNcpx6l4hy8fqV4dP
         7WIZJnDniOsWA9dWWc14s3HHhYQVIL7TizYCkR/sIFrCKX2fTeWb2zpiHLL6ArsauJPZ
         CJBSrkkq7c2moMX95BOA9K28UUBQj0LOcsDSKpp6aWmuoa7uJUdarI/w6ppYMqB46AZw
         fTvtjTly04zaUInOrJj8bRsF7oGlgPhNmKtoaJWR4hqvpaEtsEqKu8x45UoRQa/dkISS
         kGhjyngVymAQp3/rt26rsE5dN8Ry/QM8XBgLA4PQZJ06eK6jCvKZ1VYr0qt/tys8pVuv
         uFDA==
X-Gm-Message-State: AOAM531E1HevTPLgB7/Tpt9IBESurBinAtrUgwRBKjHEuO3zcsJhMLXA
        wQYe5vSOkG1V+Lb/8mQr+K2n81sBsJo=
X-Google-Smtp-Source: ABdhPJzqusHhKgq8upBKcphystx0rq7hKPySCaHSbyr0mIFbuJQAXXx1q+93Wtfc0uVlj4nsUDO2+9Dejts=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr305574pja.1.1654217115458; Thu, 02 Jun
 2022 17:45:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:01 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-55-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 054/144] KVM: selftests: Convert vmx_pmu_msrs_test away
 from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Convert vmx_pmu_msrs_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 25 +++++++++----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 97b7fd4a9a3d..63129ff5d003 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -17,8 +17,6 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-#define VCPU_ID	      0
-
 #define X86_FEATURE_PDCM	(1<<15)
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
 #define PMU_CAP_LBR_FMT		0x3f
@@ -61,6 +59,7 @@ int main(int argc, char *argv[])
 	struct kvm_cpuid_entry2 *entry_a_0;
 	bool pdcm_supported = false;
 	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
 	int ret;
 	union cpuid10_eax eax;
 	union perf_capabilities host_cap;
@@ -69,7 +68,7 @@ int main(int argc, char *argv[])
 	host_cap.capabilities &= (PMU_CAP_FW_WRITES | PMU_CAP_LBR_FMT);
 
 	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	cpuid = kvm_get_supported_cpuid();
 
 	if (kvm_get_cpuid_max_basic() >= 0xa) {
@@ -88,27 +87,27 @@ int main(int argc, char *argv[])
 	}
 
 	/* testcase 1, set capabilities when we have PDCM bit */
-	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
-	vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_FW_WRITES);
+	vcpu_set_cpuid(vm, vcpu->id, cpuid);
+	vcpu_set_msr(vm, vcpu->id, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_FW_WRITES);
 
 	/* check capabilities can be retrieved with KVM_GET_MSR */
-	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
+	ASSERT_EQ(vcpu_get_msr(vm, vcpu->id, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
 
 	/* check whatever we write with KVM_SET_MSR is _not_ modified */
-	vcpu_run(vm, VCPU_ID);
-	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
+	vcpu_run(vm, vcpu->id);
+	ASSERT_EQ(vcpu_get_msr(vm, vcpu->id, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
 
 	/* testcase 2, check valid LBR formats are accepted */
-	vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, 0);
-	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), 0);
+	vcpu_set_msr(vm, vcpu->id, MSR_IA32_PERF_CAPABILITIES, 0);
+	ASSERT_EQ(vcpu_get_msr(vm, vcpu->id, MSR_IA32_PERF_CAPABILITIES), 0);
 
-	vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, host_cap.lbr_format);
-	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), (u64)host_cap.lbr_format);
+	vcpu_set_msr(vm, vcpu->id, MSR_IA32_PERF_CAPABILITIES, host_cap.lbr_format);
+	ASSERT_EQ(vcpu_get_msr(vm, vcpu->id, MSR_IA32_PERF_CAPABILITIES), (u64)host_cap.lbr_format);
 
 	/* testcase 3, check invalid LBR format is rejected */
 	/* Note, on Arch LBR capable platforms, LBR_FMT in perf capability msr is 0x3f,
 	 * to avoid the failure, use a true invalid format 0x30 for the test. */
-	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, 0x30);
+	ret = _vcpu_set_msr(vm, vcpu->id, MSR_IA32_PERF_CAPABILITIES, 0x30);
 	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
 
 	printf("Completed perf capability tests.\n");
-- 
2.36.1.255.ge46751e96f-goog

