Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB154443BA
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 15:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhKCOmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 10:42:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37025 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231689AbhKCOmU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 10:42:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635950383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ltYy3/c7hX+1J9DtMpENyj5YzNAPuaDoe4ar90ESlRI=;
        b=PzY2Jq6UbOt6oQQQ0fqxNe2WmD4smuraOzphOqdkP4mXqcWiHRuEC1kEVoIL1d6ea66R92
        FqCTrtkixGrERThAx3E1TEhSURkNISRYbI1cXveN3B3IhAiX/3MKJ+NdiAS2eBpYDbb6df
        DHkfHVrmsEUoB5QDRilW1oM/V1s+0WE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-FRX-sqk8P8mNqL_u77v5Kw-1; Wed, 03 Nov 2021 10:39:40 -0400
X-MC-Unique: FRX-sqk8P8mNqL_u77v5Kw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABC31879515;
        Wed,  3 Nov 2021 14:39:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B9DC5D6B1;
        Wed,  3 Nov 2021 14:39:31 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v3] KVM: x86: inhibit APICv when KVM_GUESTDBG_BLOCKIRQ active
Date:   Wed,  3 Nov 2021 16:39:29 +0200
Message-Id: <20211103143929.15264-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_GUESTDBG_BLOCKIRQ relies on interrupts being injected using
standard kvm's inject_pending_event, and not via APICv/AVIC.

Since this is a debug feature, just inhibit APICv/AVIC while
KVM_GUESTDBG_BLOCKIRQ is in use on at least one vCPU.

Fixes: 61e5f69ef0837 ("KVM: x86: implement KVM_GUESTDBG_BLOCKIRQ")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/avic.c         |  3 ++-
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 arch/x86/kvm/x86.c              | 21 +++++++++++++++++++++
 4 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd7..8f6e15b95a4d8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1034,6 +1034,7 @@ struct kvm_x86_msr_filter {
 #define APICV_INHIBIT_REASON_IRQWIN     3
 #define APICV_INHIBIT_REASON_PIT_REINJ  4
 #define APICV_INHIBIT_REASON_X2APIC	5
+#define APICV_INHIBIT_REASON_BLOCKIRQ	6
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8052d92069e01..affc0ea98d302 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -904,7 +904,8 @@ bool svm_check_apicv_inhibit_reasons(ulong bit)
 			  BIT(APICV_INHIBIT_REASON_NESTED) |
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
-			  BIT(APICV_INHIBIT_REASON_X2APIC);
+			  BIT(APICV_INHIBIT_REASON_X2APIC) |
+			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
 
 	return supported & BIT(bit);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 71f54d85f104c..e4fc9ff7cd944 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7565,7 +7565,8 @@ static void hardware_unsetup(void)
 static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
-			  BIT(APICV_INHIBIT_REASON_HYPERV);
+			  BIT(APICV_INHIBIT_REASON_HYPERV) |
+			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
 
 	return supported & BIT(bit);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b0..5d30cea58182e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10703,6 +10703,25 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu = NULL;
+	int i;
+	bool block_irq_used = false;
+
+	down_write(&kvm->arch.apicv_update_lock);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ) {
+			block_irq_used = true;
+			break;
+		}
+	}
+	__kvm_request_apicv_update(kvm, !block_irq_used,
+					       APICV_INHIBIT_REASON_BLOCKIRQ);
+	up_write(&kvm->arch.apicv_update_lock);
+}
+
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
@@ -10755,6 +10774,8 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 	static_call(kvm_x86_update_exception_bitmap)(vcpu);
 
+	kvm_arch_vcpu_guestdbg_update_apicv_inhibit(vcpu->kvm);
+
 	r = 0;
 
 out:
-- 
2.26.3

