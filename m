Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9858179DDF
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 03:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgCECco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 21:32:44 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11144 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbgCECco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 21:32:44 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C5C67A2B9C0A401CC778;
        Thu,  5 Mar 2020 10:32:40 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Mar 2020
 10:32:32 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <joro@8bytes.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: VMX: Use wrapper macro ~RMODE_GUEST_OWNED_EFLAGS_BITS directly
Date:   Thu, 5 Mar 2020 10:35:31 +0800
Message-ID: <1583375731-18219-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

(X86_EFLAGS_IOPL | X86_EFLAGS_VM) indicates the eflag bits that can not be
owned by realmode guest, i.e. ~RMODE_GUEST_OWNED_EFLAGS_BITS. Use wrapper
macro directly to make it clear and also improve readability.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 743b81642ce2..9571f8dea016 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1466,7 +1466,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	vmx->rflags = rflags;
 	if (vmx->rmode.vm86_active) {
 		vmx->rmode.save_rflags = rflags;
-		rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
+		rflags |= ~RMODE_GUEST_OWNED_EFLAGS_BITS;
 	}
 	vmcs_writel(GUEST_RFLAGS, rflags);
 
@@ -2797,7 +2797,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	flags = vmcs_readl(GUEST_RFLAGS);
 	vmx->rmode.save_rflags = flags;
 
-	flags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
+	flags |= ~RMODE_GUEST_OWNED_EFLAGS_BITS;
 
 	vmcs_writel(GUEST_RFLAGS, flags);
 	vmcs_writel(GUEST_CR4, vmcs_readl(GUEST_CR4) | X86_CR4_VME);
-- 
2.19.1

