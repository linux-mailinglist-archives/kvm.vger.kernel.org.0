Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A212774A0
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 16:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgIXO6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 10:58:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728184AbgIXO6R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 10:58:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600959494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4b23nWcgJe4QPWfMDVLgEv+f1Z9LdXmKGaJ24uAFrSw=;
        b=bdTB6EunArmwAz+ISlPX09lESBepjXeoTRK1+v/1nYgvl9MktpYnWW2c6T3AqAPMHCduW8
        y2zf2MAytRZ8HVlrXNsfTOkJNelNlIbLshWVKdAJwqdFFfR9IEKw+spsHOeuubqYiO7S54
        EvCxBBDCbTE+FJkLfp2lcFddEy3hXkU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-sap6hgfrO0SV90bHNcxWJQ-1; Thu, 24 Sep 2020 10:58:11 -0400
X-MC-Unique: sap6hgfrO0SV90bHNcxWJQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DF9F1882FAA;
        Thu, 24 Sep 2020 14:58:09 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4801755786;
        Thu, 24 Sep 2020 14:58:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] KVM: x86: hyper-v: make KVM_GET_SUPPORTED_HV_CPUID output independent of eVMCS enablement
Date:   Thu, 24 Sep 2020 16:57:53 +0200
Message-Id: <20200924145757.1035782-4-vkuznets@redhat.com>
In-Reply-To: <20200924145757.1035782-1-vkuznets@redhat.com>
References: <20200924145757.1035782-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is really inconvenient when KVM_GET_SUPPORTED_HV_CPUID output depends on
whether some other capabilities are enabled as VMM needs to be aware of the
correct sequence (which becomes an API).

Enlightened VMCS is not the only feature which requires explicit enablement.
In particular, SynIC has to be enabled explicitly too but the corresponding
features are always present in KVM_GET_SUPPORTED_HV_CPUID, this is
inconsistent. In any case, userspace can't blindly copy the output of
KVM_GET_SUPPORTED_HV_CPUID to guest's CPUIDs and expect everything to work.

Previously, we were also using EVMCS enablement to decide whether or not to
report HYPERV_CPUID_NESTED_FEATURES feature leaf as the last available leaf
in HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES but this is already gone with
SYNDBG and nobody seemed to complain.

As a preparation to making KVM_GET_SUPPORTED_HV_CPUID a system ioctl, make
EVMCS feature bits work the same way as all other bits, nothing should break
(famous last words).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/api.rst                |  3 --
 arch/x86/include/asm/kvm_host.h               |  2 +-
 arch/x86/kvm/hyperv.c                         |  8 ++---
 arch/x86/kvm/vmx/evmcs.c                      |  8 ++---
 arch/x86/kvm/vmx/evmcs.h                      |  2 +-
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 35 +++++--------------
 6 files changed, 15 insertions(+), 43 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f0e9582c6b44..a552d41308e1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4502,9 +4502,6 @@ Currently, the following list of CPUID leaves are returned:
  - HYPERV_CPUID_SYNDBG_INTERFACE
  - HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
 
-HYPERV_CPUID_NESTED_FEATURES leaf is only exposed when Enlightened VMCS was
-enabled on the corresponding vCPU (KVM_CAP_HYPERV_ENLIGHTENED_VMCS).
-
 Userspace invokes KVM_GET_SUPPORTED_HV_CPUID by passing a kvm_cpuid2 structure
 with the 'nent' field indicating the number of entries in the variable-size
 array 'entries'.  If the number of entries is too low to describe all Hyper-V
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5303dbc5c9bc..ef971ae5f217 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1243,7 +1243,7 @@ struct kvm_x86_nested_ops {
 
 	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
 			    uint16_t *vmcs_version);
-	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
+	uint16_t (*get_evmcs_version)(void);
 };
 
 struct kvm_x86_init_ops {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 9527fa9685ad..6da20f91cd59 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1962,19 +1962,15 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		{ .function = HYPERV_CPUID_FEATURES },
 		{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
 		{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
+		{ .function = HYPERV_CPUID_NESTED_FEATURES },
 		{ .function = HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS },
 		{ .function = HYPERV_CPUID_SYNDBG_INTERFACE },
 		{ .function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	},
-		{ .function = HYPERV_CPUID_NESTED_FEATURES },
 	};
 	int i, nent = ARRAY_SIZE(cpuid_entries);
 
 	if (kvm_x86_ops.nested_ops->get_evmcs_version)
-		evmcs_ver = kvm_x86_ops.nested_ops->get_evmcs_version(vcpu);
-
-	/* Skip NESTED_FEATURES if eVMCS is not supported */
-	if (!evmcs_ver)
-		--nent;
+		evmcs_ver = kvm_x86_ops.nested_ops->get_evmcs_version();
 
 	if (cpuid->nent < nent)
 		return -E2BIG;
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index e5325bd0f304..4559d5851bf0 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -325,17 +325,15 @@ bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa)
 	return true;
 }
 
-uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
+uint16_t nested_get_evmcs_version(void)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	/*
 	 * vmcs_version represents the range of supported Enlightened VMCS
 	 * versions: lower 8 bits is the minimal version, higher 8 bits is the
 	 * maximum supported version. KVM supports versions from 1 to
 	 * KVM_EVMCS_VERSION.
 	 */
-	if (kvm_cpu_cap_get(X86_FEATURE_VMX) &&
-	    vmx->nested.enlightened_vmcs_enabled)
+	if (kvm_cpu_cap_get(X86_FEATURE_VMX))
 		return (KVM_EVMCS_VERSION << 8) | 1;
 
 	return 0;
@@ -427,7 +425,7 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 	vmx->nested.enlightened_vmcs_enabled = true;
 
 	if (vmcs_version)
-		*vmcs_version = nested_get_evmcs_version(vcpu);
+		*vmcs_version = nested_get_evmcs_version();
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index e5f7a7ebf27d..8e6429ec9ace 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -206,7 +206,7 @@ enum nested_evmptrld_status {
 };
 
 bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
-uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
+uint16_t nested_get_evmcs_version(void);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version);
 void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 745b708c2d3b..8b24cb2e6a19 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -45,20 +45,16 @@ static bool smt_possible(void)
 	return res;
 }
 
-static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
-			  bool evmcs_enabled)
+static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries)
 {
 	int i;
-	int nent = 9;
+	int nent = 10;
 	u32 test_val;
 
-	if (evmcs_enabled)
-		nent += 1; /* 0x4000000A */
-
 	TEST_ASSERT(hv_cpuid_entries->nent == nent,
 		    "KVM_GET_SUPPORTED_HV_CPUID should return %d entries"
-		    " with evmcs=%d (returned %d)",
-		    nent, evmcs_enabled, hv_cpuid_entries->nent);
+		    " (returned %d)",
+		    nent, hv_cpuid_entries->nent);
 
 	for (i = 0; i < hv_cpuid_entries->nent; i++) {
 		struct kvm_cpuid_entry2 *entry = &hv_cpuid_entries->entries[i];
@@ -68,9 +64,6 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 			    "function %x is our of supported range",
 			    entry->function);
 
-		TEST_ASSERT(evmcs_enabled || (entry->function != 0x4000000A),
-			    "0x4000000A leaf should not be reported");
-
 		TEST_ASSERT(entry->index == 0,
 			    ".index field should be zero");
 
@@ -85,9 +78,8 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 			test_val = 0x40000082;
 
 			TEST_ASSERT(entry->eax == test_val,
-				    "Wrong max leaf report in 0x40000000.EAX: %x"
-				    " (evmcs=%d)",
-				    entry->eax, evmcs_enabled
+				    "Wrong max leaf report in 0x40000000.EAX: %x",
+				    entry->eax
 				);
 			break;
 		case 0x40000004:
@@ -148,7 +140,6 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	int rv, stage;
 	struct kvm_cpuid2 *hv_cpuid_entries;
-	bool evmcs_enabled;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
@@ -159,8 +150,7 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	for (stage = 0; stage < 3; stage++) {
-		evmcs_enabled = false;
+	for (stage = 0; stage < 2; stage++) {
 
 		vm = vm_create_default(VCPU_ID, 0, guest_code);
 		switch (stage) {
@@ -169,19 +159,10 @@ int main(int argc, char *argv[])
 			continue;
 		case 1:
 			break;
-		case 2:
-			if (!nested_vmx_supported() ||
-			    !kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
-				print_skip("Enlightened VMCS is unsupported");
-				continue;
-			}
-			vcpu_enable_evmcs(vm, VCPU_ID);
-			evmcs_enabled = true;
-			break;
 		}
 
 		hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
-		test_hv_cpuid(hv_cpuid_entries, evmcs_enabled);
+		test_hv_cpuid(hv_cpuid_entries);
 		free(hv_cpuid_entries);
 		kvm_vm_free(vm);
 	}
-- 
2.25.4

