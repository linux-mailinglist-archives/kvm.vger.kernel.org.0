Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68FA48D919
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 14:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbiAMNhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 08:37:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41625 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235285AbiAMNh1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 08:37:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642081046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PQFEnAuzz+RytEWWBVSSCKCXKb/NOMMYMWna1aSbXE8=;
        b=KBK47gaYLxChrvnKxDwKPSi4hsDPs1L6kQwpMmKXKrRTdUJCBHJqawhOcUEY9A2DqRvagC
        ySZ4H9LeJjgjEUU8UZTA5Erlylg3CaffZVDpQ5Qh7fRGWd6tXPehLtgZxUivg8hHMc+tFv
        y8aa8e9I9mF/o9S3b/Yq4ACSG55NyOM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-1VoKKlY9NVe_ETif0RX03g-1; Thu, 13 Jan 2022 08:37:25 -0500
X-MC-Unique: 1VoKKlY9NVe_ETif0RX03g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 440EB1926DA6;
        Thu, 13 Jan 2022 13:37:24 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30EE884A28;
        Thu, 13 Jan 2022 13:37:22 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] KVM: x86: Do runtime CPUID update before updating vcpu->arch.cpuid_entries
Date:   Thu, 13 Jan 2022 14:37:00 +0100
Message-Id: <20220113133703.1976665-3-vkuznets@redhat.com>
In-Reply-To: <20220113133703.1976665-1-vkuznets@redhat.com>
References: <20220113133703.1976665-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_update_cpuid_runtime() mangles CPUID data coming from userspace
VMM after updating 'vcpu->arch.cpuid_entries', this makes it
impossible to compare an update with what was previously
supplied. Introduce __kvm_update_cpuid_runtime() version which can be
used to tweak the input before it goes to 'vcpu->arch.cpuid_entries'
so the upcoming update check can compare tweaked data.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 89af3c7390d3..c4d4c350afbe 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -125,14 +125,21 @@ static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
 	}
 }
 
-static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
+static struct kvm_cpuid_entry2 *__kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu,
+					      struct kvm_cpuid_entry2 *entries, int nent)
 {
 	u32 base = vcpu->arch.kvm_cpuid_base;
 
 	if (!base)
 		return NULL;
 
-	return kvm_find_cpuid_entry(vcpu, base | KVM_CPUID_FEATURES, 0);
+	return cpuid_entry2_find(entries, nent, base | KVM_CPUID_FEATURES, 0);
+}
+
+static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
+{
+	return __kvm_find_kvm_cpuid_features(vcpu, vcpu->arch.cpuid_entries,
+					     vcpu->arch.cpuid_nent);
 }
 
 void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
@@ -147,11 +154,12 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 		vcpu->arch.pv_cpuid.features = best->eax;
 }
 
-void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
+static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
+				       int nent)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 1, 0);
+	best = cpuid_entry2_find(entries, nent, 1, 0);
 	if (best) {
 		/* Update OSXSAVE bit */
 		if (boot_cpu_has(X86_FEATURE_XSAVE))
@@ -162,33 +170,38 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
 	}
 
-	best = kvm_find_cpuid_entry(vcpu, 7, 0);
+	best = cpuid_entry2_find(entries, nent, 7, 0);
 	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
 
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
+	best = cpuid_entry2_find(entries, nent, 0xD, 0);
 	if (best)
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
 
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
+	best = cpuid_entry2_find(entries, nent, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
-	best = kvm_find_kvm_cpuid_features(vcpu);
+	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
-		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+		best = cpuid_entry2_find(entries, nent, 0x1, 0);
 		if (best)
 			cpuid_entry_change(best, X86_FEATURE_MWAIT,
 					   vcpu->arch.ia32_misc_enable_msr &
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 }
+
+void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
+{
+	__kvm_update_cpuid_runtime(vcpu, vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
+}
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
 static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
@@ -278,6 +291,8 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 {
 	int r;
 
+	__kvm_update_cpuid_runtime(vcpu, e2, nent);
+
 	r = kvm_check_cpuid(e2, nent);
 	if (r)
 		return r;
@@ -287,7 +302,6 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	vcpu->arch.cpuid_nent = nent;
 
 	kvm_update_kvm_cpuid_base(vcpu);
-	kvm_update_cpuid_runtime(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 
 	return 0;
-- 
2.34.1

