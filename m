Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244D5DBDB7
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 08:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504439AbfJRGgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 02:36:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4720 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392014AbfJRGgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 02:36:09 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 670F2DC43CDADA423205;
        Fri, 18 Oct 2019 10:50:11 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Fri, 18 Oct 2019
 10:50:02 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>,
        <mingfangsen@huawei.com>
Subject: [PATCH v2] KVM: SVM: Fix potential wrong physical id in avic_handle_ldr_update
Date:   Fri, 18 Oct 2019 10:50:31 +0800
Message-ID: <1571367031-6844-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guest physical APIC ID may not equal to vcpu->vcpu_id in some case.
We may set the wrong physical id in avic_handle_ldr_update as we
always use vcpu->vcpu_id. Get physical APIC ID from vAPIC page
instead.
Export and use kvm_xapic_id here and in avic_handle_apic_id_update
as suggested by Vitaly.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/lapic.c | 5 -----
 arch/x86/kvm/lapic.h | 5 +++++
 arch/x86/kvm/svm.c   | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 87b0fcc23ef8..b29d00b661ff 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -111,11 +111,6 @@ static inline int apic_enabled(struct kvm_lapic *apic)
 	(LVT_MASK | APIC_MODE_MASK | APIC_INPUT_POLARITY | \
 	 APIC_LVT_REMOTE_IRR | APIC_LVT_LEVEL_TRIGGER)
 
-static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
-{
-	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
-}
-
 static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 {
 	return apic->vcpu->vcpu_id;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2aad7e226fc0..1f5014852e20 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -242,4 +242,9 @@ static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
 }
 
+static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
+{
+	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
+}
+
 #endif
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f8ecb6df5106..ca200b50cde4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4591,6 +4591,7 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 	int ret = 0;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
+	u32 id = kvm_xapic_id(vcpu->arch.apic);
 
 	if (ldr == svm->ldr_reg)
 		return 0;
@@ -4598,7 +4599,7 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 	avic_invalidate_logical_id_entry(vcpu);
 
 	if (ldr)
-		ret = avic_ldr_write(vcpu, vcpu->vcpu_id, ldr);
+		ret = avic_ldr_write(vcpu, id, ldr);
 
 	if (!ret)
 		svm->ldr_reg = ldr;
@@ -4610,8 +4611,7 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
 {
 	u64 *old, *new;
 	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 apic_id_reg = kvm_lapic_get_reg(vcpu->arch.apic, APIC_ID);
-	u32 id = (apic_id_reg >> 24) & 0xff;
+	u32 id = kvm_xapic_id(vcpu->arch.apic);
 
 	if (vcpu->vcpu_id == id)
 		return 0;
-- 
2.19.1

