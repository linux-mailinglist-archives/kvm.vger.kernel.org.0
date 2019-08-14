Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31DF38D7F9
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 18:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbfHNQWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 12:22:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33591 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfHNQWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 12:22:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id u16so646229wrr.0;
        Wed, 14 Aug 2019 09:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9IpXj+WLqrPfM7eBTih/QAL5m+fd30y7Bv1MfCGetRI=;
        b=KTV1AebBP6iE8e7HKKr6PbQEOuucGyw4XziuNXEtXV6KNoUxB96wCfPt5UjbM75/Eb
         hD21IfDpPH036DrvK0RAjAVX2V2cBLZ+mLfD9K2lmg1YXI3GTme8E6StDuAlhhMaQrBT
         XIHVOP/MbUS5juGxI94EGzlVjeJ/Xnu3rw2SXLjZ3jOHVWaqxalyISP0D+a0CvADw3mh
         vIerF9nbovPdkRHjH2CcyxgKkmZDiwGKi5RnXYdaCi69JPFQh6Cpkm4ilGvRVOBA9508
         wRHis7CpRcz9mqAtf1Y4hQkCMzeHGiEEDYydyVES2Zp2c8Ce/Ijg6flzvD0+fmQag+Ff
         3fZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=9IpXj+WLqrPfM7eBTih/QAL5m+fd30y7Bv1MfCGetRI=;
        b=cO+GVot3RCrwzJ6ZGOu7YB6Wnkz6EqgzQIprDCiviCenXkEfQwgb3fnYy0QFFCo7gY
         oYTC0d98YADXT4ytkFwx4XpWaGiM/P87Fx7b/p5Vz2aJDTncd4SZTg6HNWW1+KB5VCC+
         4v/thnk7aeoWGv461vQvThoEZVdrV5kPXDRwnV2Ps3hjhdaeXJtigattd0Og/O0laLF0
         1bdjn9i24XefUk1rxKGx2ZSdeHhg007G0zBacn7oOqm+E1w+CL2TOFsPKR/ugxL0I9sU
         P1FpllA21QLe8DxxjbMcdegoXaZIBcABBUZxNMj6PM5HYe/V7SgEjU9785RB4zKyVVj5
         EwJQ==
X-Gm-Message-State: APjAAAUS0yCn1my3Mf0RfRQfp9GrzCBql2L9N/VlcFdptcIo2r5b66i7
        pllGDyokHZdtMm8FbYeDinPopsuI
X-Google-Smtp-Source: APXvYqx/OwnZ4kS12siXivbayZPya7LWMkiycRDASXEqVgLfDFKsEak0VHoShCNUFPeq+Ss1IgCxTQ==
X-Received: by 2002:a5d:628d:: with SMTP id k13mr558630wru.69.1565799758801;
        Wed, 14 Aug 2019 09:22:38 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id k124sm191620wmk.47.2019.08.14.09.22.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 09:22:38 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com
Subject: [PATCH 2/3] selftests: kvm: provide common function to enable eVMCS
Date:   Wed, 14 Aug 2019 18:22:32 +0200
Message-Id: <1565799753-3006-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565799753-3006-1-git-send-email-pbonzini@redhat.com>
References: <1565799753-3006-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two tests already enabling eVMCS and a third is coming.
Add a function that enables the capability and tests the result.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/include/evmcs.h       |  2 ++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c      | 20 ++++++++++++++++++++
 tools/testing/selftests/kvm/x86_64/evmcs_test.c   | 15 ++-------------
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c | 12 ++++--------
 4 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/evmcs.h b/tools/testing/selftests/kvm/include/evmcs.h
index 4059014d93ea..4912d23844bc 100644
--- a/tools/testing/selftests/kvm/include/evmcs.h
+++ b/tools/testing/selftests/kvm/include/evmcs.h
@@ -220,6 +220,8 @@ struct hv_enlightened_vmcs {
 struct hv_enlightened_vmcs *current_evmcs;
 struct hv_vp_assist_page *current_vp_assist;
 
+int vcpu_enable_evmcs(struct kvm_vm *vm, int vcpu_id);
+
 static inline int enable_vp_assist(uint64_t vp_assist_pa, void *vp_assist)
 {
 	u64 val = (vp_assist_pa & HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_MASK) |
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 204f847bd065..9cef0455b819 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -12,6 +12,26 @@
 
 bool enable_evmcs;
 
+int vcpu_enable_evmcs(struct kvm_vm *vm, int vcpu_id)
+{
+	uint16_t evmcs_ver;
+
+	struct kvm_enable_cap enable_evmcs_cap = {
+		.cap = KVM_CAP_HYPERV_ENLIGHTENED_VMCS,
+		 .args[0] = (unsigned long)&evmcs_ver
+	};
+
+	vcpu_ioctl(vm, vcpu_id, KVM_ENABLE_CAP, &enable_evmcs_cap);
+
+	/* KVM should return supported EVMCS version range */
+	TEST_ASSERT(((evmcs_ver >> 8) >= (evmcs_ver & 0xff)) &&
+		    (evmcs_ver & 0xff) > 0,
+		    "Incorrect EVMCS version range: %x:%x\n",
+		    evmcs_ver & 0xff, evmcs_ver >> 8);
+
+	return evmcs_ver;
+}
+
 /* Allocate memory regions for nested VMX tests.
  *
  * Input Args:
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index f95c08343b48..92915e6408e7 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -79,11 +79,6 @@ int main(int argc, char *argv[])
 	struct kvm_x86_state *state;
 	struct ucall uc;
 	int stage;
-	uint16_t evmcs_ver;
-	struct kvm_enable_cap enable_evmcs_cap = {
-		.cap = KVM_CAP_HYPERV_ENLIGHTENED_VMCS,
-		 .args[0] = (unsigned long)&evmcs_ver
-	};
 
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
@@ -96,13 +91,7 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	vcpu_ioctl(vm, VCPU_ID, KVM_ENABLE_CAP, &enable_evmcs_cap);
-
-	/* KVM should return supported EVMCS version range */
-	TEST_ASSERT(((evmcs_ver >> 8) >= (evmcs_ver & 0xff)) &&
-		    (evmcs_ver & 0xff) > 0,
-		    "Incorrect EVMCS version range: %x:%x\n",
-		    evmcs_ver & 0xff, evmcs_ver >> 8);
+	vcpu_enable_evmcs(vm, VCPU_ID);
 
 	run = vcpu_state(vm, VCPU_ID);
 
@@ -146,7 +135,7 @@ int main(int argc, char *argv[])
 		kvm_vm_restart(vm, O_RDWR);
 		vm_vcpu_add(vm, VCPU_ID);
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
-		vcpu_ioctl(vm, VCPU_ID, KVM_ENABLE_CAP, &enable_evmcs_cap);
+		vcpu_enable_evmcs(vm, VCPU_ID);
 		vcpu_load_state(vm, VCPU_ID, state);
 		run = vcpu_state(vm, VCPU_ID);
 		free(state);
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index f72b3043db0e..ee59831fbc98 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -18,6 +18,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "vmx.h"
 
 #define VCPU_ID 0
 
@@ -106,12 +107,7 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 	int rv;
-	uint16_t evmcs_ver;
 	struct kvm_cpuid2 *hv_cpuid_entries;
-	struct kvm_enable_cap enable_evmcs_cap = {
-		.cap = KVM_CAP_HYPERV_ENLIGHTENED_VMCS,
-		 .args[0] = (unsigned long)&evmcs_ver
-	};
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
@@ -136,14 +132,14 @@ int main(int argc, char *argv[])
 
 	free(hv_cpuid_entries);
 
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_ENABLE_CAP, &enable_evmcs_cap);
-
-	if (rv) {
+	if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
 		fprintf(stderr,
 			"Enlightened VMCS is unsupported, skip related test\n");
 		goto vm_free;
 	}
 
+	vcpu_enable_evmcs(vm, VCPU_ID);
+
 	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
 	if (!hv_cpuid_entries)
 		return 1;
-- 
1.8.3.1


