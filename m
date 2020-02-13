Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C631F15B729
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 03:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbgBMCdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 21:33:44 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9726 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729333AbgBMCdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 21:33:44 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 593D746914F92CDC175F;
        Thu, 13 Feb 2020 10:33:42 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Thu, 13 Feb 2020
 10:33:36 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: VMX: Add 'else' to split mutually exclusive case
Date:   Thu, 13 Feb 2020 10:35:15 +0800
Message-ID: <1581561315-3820-1-git-send-email-linmiaohe@huawei.com>
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

Each if branch in handle_external_interrupt_irqoff() is mutually
exclusive. Add 'else' to make it clear and also avoid some unnecessary
check.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9a6664886f2e..bb5c33440af8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6178,13 +6178,11 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 	/* if exit due to PF check for async PF */
 	if (is_page_fault(vmx->exit_intr_info))
 		vmx->vcpu.arch.apf.host_apf_reason = kvm_read_and_reset_pf_reason();
-
 	/* Handle machine checks before interrupts are enabled */
-	if (is_machine_check(vmx->exit_intr_info))
+	else if (is_machine_check(vmx->exit_intr_info))
 		kvm_machine_check();
-
 	/* We need to handle NMIs before interrupts are enabled */
-	if (is_nmi(vmx->exit_intr_info)) {
+	else if (is_nmi(vmx->exit_intr_info)) {
 		kvm_before_interrupt(&vmx->vcpu);
 		asm("int $2");
 		kvm_after_interrupt(&vmx->vcpu);
-- 
2.19.1

