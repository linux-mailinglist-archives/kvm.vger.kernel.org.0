Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 257EAD8C7B
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 11:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391959AbfJPJYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 05:24:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47562 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391925AbfJPJYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 05:24:47 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9493277D8DAEA9F0BA43;
        Wed, 16 Oct 2019 17:24:45 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Wed, 16 Oct 2019
 17:24:34 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>,
        <mingfangsen@huawei.com>
Subject: [PATCH] KVM: SVM: Fix potential wrong physical id in avic_handle_ldr_update
Date:   Wed, 16 Oct 2019 17:25:08 +0800
Message-ID: <1571217908-7693-1-git-send-email-linmiaohe@huawei.com>
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
always use vcpu->vcpu_id.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/svm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f8ecb6d..67cb5ba 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4591,6 +4591,8 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 	int ret = 0;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
+	u32 apic_id_reg = kvm_lapic_get_reg(vcpu->arch.apic, APIC_ID);
+	u32 id = (apic_id_reg >> 24) & 0xff;
 
 	if (ldr == svm->ldr_reg)
 		return 0;
@@ -4598,7 +4600,7 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 	avic_invalidate_logical_id_entry(vcpu);
 
 	if (ldr)
-		ret = avic_ldr_write(vcpu, vcpu->vcpu_id, ldr);
+		ret = avic_ldr_write(vcpu, id, ldr);
 
 	if (!ret)
 		svm->ldr_reg = ldr;
-- 
1.8.3.1

