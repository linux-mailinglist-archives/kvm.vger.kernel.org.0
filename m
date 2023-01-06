Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FCB65FF01
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 11:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjAFKge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 05:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbjAFKgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 05:36:32 -0500
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C791A6B5FF;
        Fri,  6 Jan 2023 02:36:31 -0800 (PST)
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1pDk5K-0003o2-SY; Fri, 06 Jan 2023 10:36:26 +0000
Received: from 54-240-197-227.amazon.com ([54.240.197.227] helo=debian.cbg12.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1pDk5K-0001wX-Ir; Fri, 06 Jan 2023 10:36:26 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     x86@kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v7 1/2] KVM: x86/cpuid: generalize kvm_update_kvm_cpuid_base() and also capture limit
Date:   Fri,  6 Jan 2023 10:35:59 +0000
Message-Id: <20230106103600.528-2-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230106103600.528-1-pdurrant@amazon.com>
References: <20230106103600.528-1-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_ADSP_ALL,
        RCVD_IN_DNSWL_MED,SPF_FAIL,SPF_HELO_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A subsequent patch will need to acquire the CPUID leaf range for emulated
Xen so explicitly pass the signature of the hypervisor we're interested in
to the new function. Also introduce a new kvm_hypervisor_cpuid structure
so we can neatly store both the base and limit leaf indices.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>

v7:
 - Morph kvm_update_hypervisor_cpuid() into kvm_get_hypervisor_cpuid()
 - Place the definition of struct kvm_hypervisor_cpuid to avoid churn
   in patch #2.

v6:
 - New in this version
---
 arch/x86/include/asm/kvm_host.h |  7 ++++++-
 arch/x86/kvm/cpuid.c            | 24 +++++++++++++-----------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c70690b2c82d..85cbe4571ac9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -678,6 +678,11 @@ struct kvm_vcpu_hv {
 	} nested;
 };
 
+struct kvm_hypervisor_cpuid {
+	u32 base;
+	u32 limit;
+};
+
 /* Xen HVM per vcpu emulation context */
 struct kvm_vcpu_xen {
 	u64 hypercall_rip;
@@ -826,7 +831,7 @@ struct kvm_vcpu_arch {
 
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
-	u32 kvm_cpuid_base;
+	struct kvm_hypervisor_cpuid kvm_cpuid;
 
 	u64 reserved_gpa_bits;
 	int maxphyaddr;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 69768e4d53a6..db5a4d38fcd0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -180,15 +180,15 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
 	return 0;
 }
 
-static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
+static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcpu,
+							    const char *sig)
 {
-	u32 function;
+	struct kvm_hypervisor_cpuid cpuid = {};
 	struct kvm_cpuid_entry2 *entry;
+	u32 base;
 
-	vcpu->arch.kvm_cpuid_base = 0;
-
-	for_each_possible_hypervisor_cpuid_base(function) {
-		entry = kvm_find_cpuid_entry(vcpu, function);
+	for_each_possible_hypervisor_cpuid_base(base) {
+		entry = kvm_find_cpuid_entry(vcpu, base);
 
 		if (entry) {
 			u32 signature[3];
@@ -197,19 +197,21 @@ static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
 			signature[1] = entry->ecx;
 			signature[2] = entry->edx;
 
-			BUILD_BUG_ON(sizeof(signature) > sizeof(KVM_SIGNATURE));
-			if (!memcmp(signature, KVM_SIGNATURE, sizeof(signature))) {
-				vcpu->arch.kvm_cpuid_base = function;
+			if (!memcmp(signature, sig, sizeof(signature))) {
+				cpuid.base = base;
+				cpuid.limit = entry->eax;
 				break;
 			}
 		}
 	}
+
+	return cpuid;
 }
 
 static struct kvm_cpuid_entry2 *__kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu,
 					      struct kvm_cpuid_entry2 *entries, int nent)
 {
-	u32 base = vcpu->arch.kvm_cpuid_base;
+	u32 base = vcpu->arch.kvm_cpuid.base;
 
 	if (!base)
 		return NULL;
@@ -439,7 +441,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	vcpu->arch.cpuid_entries = e2;
 	vcpu->arch.cpuid_nent = nent;
 
-	kvm_update_kvm_cpuid_base(vcpu);
+	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
 	kvm_vcpu_after_set_cpuid(vcpu);
 
 	return 0;
-- 
2.20.1

