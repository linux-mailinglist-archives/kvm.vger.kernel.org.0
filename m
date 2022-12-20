Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856B3652245
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbiLTOQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbiLTOQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:16:21 -0500
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCBEE0F2;
        Tue, 20 Dec 2022 06:16:20 -0800 (PST)
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1p7csQ-00012f-TJ; Tue, 20 Dec 2022 13:41:50 +0000
Received: from 54-240-197-227.amazon.com ([54.240.197.227] helo=debian.cbg12.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1p7csQ-0002HU-J6; Tue, 20 Dec 2022 13:41:50 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v6 1/2] KVM: x86/cpuid: generalize kvm_update_kvm_cpuid_base() and also capture limit
Date:   Tue, 20 Dec 2022 13:40:52 +0000
Message-Id: <20221220134053.15591-2-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221220134053.15591-1-pdurrant@amazon.com>
References: <20221220134053.15591-1-pdurrant@amazon.com>
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

A sunsequent patch will need to acquire the CPUID leaf range for emulated
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

v6:
 - New in this version
---
 arch/x86/include/asm/kvm_host.h |  7 ++++++-
 arch/x86/kvm/cpuid.c            | 15 ++++++++-------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f35f1ff4427b..ff201ad35551 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -710,6 +710,11 @@ struct kvm_queued_exception {
 	bool has_payload;
 };
 
+struct kvm_hypervisor_cpuid {
+	u32 base;
+	u32 limit;
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -826,7 +831,7 @@ struct kvm_vcpu_arch {
 
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
-	u32 kvm_cpuid_base;
+	struct kvm_hypervisor_cpuid kvm_cpuid;
 
 	u64 reserved_gpa_bits;
 	int maxphyaddr;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0b5bf013fcb8..2468720f8d84 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -180,12 +180,13 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
 	return 0;
 }
 
-static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
+static void kvm_update_hypervisor_cpuid(struct kvm_vcpu *vcpu, const char *hypervisor_signature,
+					struct kvm_hypervisor_cpuid *hypervisor_cpuid)
 {
 	u32 function;
 	struct kvm_cpuid_entry2 *entry;
 
-	vcpu->arch.kvm_cpuid_base = 0;
+	memset(hypervisor_cpuid, 0, sizeof(*hypervisor_cpuid));
 
 	for_each_possible_hypervisor_cpuid_base(function) {
 		entry = kvm_find_cpuid_entry(vcpu, function);
@@ -197,9 +198,9 @@ static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
 			signature[1] = entry->ecx;
 			signature[2] = entry->edx;
 
-			BUILD_BUG_ON(sizeof(signature) > sizeof(KVM_SIGNATURE));
-			if (!memcmp(signature, KVM_SIGNATURE, sizeof(signature))) {
-				vcpu->arch.kvm_cpuid_base = function;
+			if (!memcmp(signature, hypervisor_signature, sizeof(signature))) {
+				hypervisor_cpuid->base = function;
+				hypervisor_cpuid->limit = entry->eax;
 				break;
 			}
 		}
@@ -209,7 +210,7 @@ static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
 static struct kvm_cpuid_entry2 *__kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu,
 					      struct kvm_cpuid_entry2 *entries, int nent)
 {
-	u32 base = vcpu->arch.kvm_cpuid_base;
+	u32 base = vcpu->arch.kvm_cpuid.base;
 
 	if (!base)
 		return NULL;
@@ -439,7 +440,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	vcpu->arch.cpuid_entries = e2;
 	vcpu->arch.cpuid_nent = nent;
 
-	kvm_update_kvm_cpuid_base(vcpu);
+	kvm_update_hypervisor_cpuid(vcpu, KVM_SIGNATURE, &vcpu->arch.kvm_cpuid);
 	kvm_vcpu_after_set_cpuid(vcpu);
 
 	return 0;
-- 
2.20.1

