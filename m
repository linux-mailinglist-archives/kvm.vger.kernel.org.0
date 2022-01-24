Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D7B497D41
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 11:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbiAXKhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 05:37:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37900 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233480AbiAXKhS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 05:37:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643020637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M/CTib4g8EL3qztBgmgbxWgLFwo1c5F2Z/Xwy3JUz+k=;
        b=Nf5pK2S6GreKuggiA60jS7oE4Uaudj0pa3zFkiWI0lwe15aSZjDuhBffLqLHvMjBJmjEA4
        lna/oHDRk9PsSBWnuKzoLDbjtrW04sKi1TWhxnU6zYDA5yltcVih3u8SNZNpwbE/A55F9I
        n113LZrMlfB00YqJwuden03Az99OPm8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-Ld1e_qyRNamVw3p5bifMyQ-1; Mon, 24 Jan 2022 05:37:14 -0500
X-MC-Unique: Ld1e_qyRNamVw3p5bifMyQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3671D425E1;
        Mon, 24 Jan 2022 10:37:13 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 142D11F305;
        Mon, 24 Jan 2022 10:36:25 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: Move CPUID.(EAX=0x12,ECX=1) mangling to __kvm_update_cpuid_runtime()
Date:   Mon, 24 Jan 2022 11:36:05 +0100
Message-Id: <20220124103606.2630588-2-vkuznets@redhat.com>
In-Reply-To: <20220124103606.2630588-1-vkuznets@redhat.com>
References: <20220124103606.2630588-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Full equality check of CPUID data on update (kvm_cpuid_check_equal()) may
fail for SGX enabled CPUs as CPUID.(EAX=0x12,ECX=1) is currently being
mangled in kvm_vcpu_after_set_cpuid(). Move it to
__kvm_update_cpuid_runtime() and split off cpuid_get_supported_xcr0()
helper  as 'vcpu->arch.guest_supported_xcr0' update needs (logically)
to stay in kvm_vcpu_after_set_cpuid().

Cc: stable@vger.kernel.org
Fixes: feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c | 54 +++++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3902c28fb6cb..89d7822a8f5b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -196,10 +196,26 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 		vcpu->arch.pv_cpuid.features = best->eax;
 }
 
+/*
+ * Calculate guest's supported XCR0 taking into account guest CPUID data and
+ * supported_xcr0 (comprised of host configuration and KVM_SUPPORTED_XCR0).
+ */
+static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = cpuid_entry2_find(entries, nent, 0xd, 0);
+	if (!best)
+		return 0;
+
+	return (best->eax | ((u64)best->edx << 32)) & supported_xcr0;
+}
+
 static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
 				       int nent)
 {
 	struct kvm_cpuid_entry2 *best;
+	u64 guest_supported_xcr0 = cpuid_get_supported_xcr0(entries, nent);
 
 	best = cpuid_entry2_find(entries, nent, 1, 0);
 	if (best) {
@@ -238,6 +254,21 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 					   vcpu->arch.ia32_misc_enable_msr &
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
+
+	/*
+	 * Bits 127:0 of the allowed SECS.ATTRIBUTES (CPUID.0x12.0x1) enumerate
+	 * the supported XSAVE Feature Request Mask (XFRM), i.e. the enclave's
+	 * requested XCR0 value.  The enclave's XFRM must be a subset of XCRO
+	 * at the time of EENTER, thus adjust the allowed XFRM by the guest's
+	 * supported XCR0.  Similar to XCR0 handling, FP and SSE are forced to
+	 * '1' even on CPUs that don't support XSAVE.
+	 */
+	best = cpuid_entry2_find(entries, nent, 0x12, 0x1);
+	if (best) {
+		best->ecx &= guest_supported_xcr0 & 0xffffffff;
+		best->edx &= guest_supported_xcr0 >> 32;
+		best->ecx |= XFEATURE_MASK_FPSSE;
+	}
 }
 
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
@@ -261,27 +292,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_apic_set_version(vcpu);
 	}
 
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
-	if (!best)
-		vcpu->arch.guest_supported_xcr0 = 0;
-	else
-		vcpu->arch.guest_supported_xcr0 =
-			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
-
-	/*
-	 * Bits 127:0 of the allowed SECS.ATTRIBUTES (CPUID.0x12.0x1) enumerate
-	 * the supported XSAVE Feature Request Mask (XFRM), i.e. the enclave's
-	 * requested XCR0 value.  The enclave's XFRM must be a subset of XCRO
-	 * at the time of EENTER, thus adjust the allowed XFRM by the guest's
-	 * supported XCR0.  Similar to XCR0 handling, FP and SSE are forced to
-	 * '1' even on CPUs that don't support XSAVE.
-	 */
-	best = kvm_find_cpuid_entry(vcpu, 0x12, 0x1);
-	if (best) {
-		best->ecx &= vcpu->arch.guest_supported_xcr0 & 0xffffffff;
-		best->edx &= vcpu->arch.guest_supported_xcr0 >> 32;
-		best->ecx |= XFEATURE_MASK_FPSSE;
-	}
+	vcpu->arch.guest_supported_xcr0 =
+		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
 	kvm_update_pv_runtime(vcpu);
 
-- 
2.34.1

