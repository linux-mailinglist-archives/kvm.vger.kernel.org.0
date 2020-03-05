Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE75179DFB
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 03:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgCECqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 21:46:05 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:56004 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725777AbgCECqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 21:46:04 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A5866949316ACE906043;
        Thu,  5 Mar 2020 10:46:01 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Mar 2020
 10:45:54 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <joro@8bytes.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: x86: small optimization for is_mtrr_mask calculation
Date:   Thu, 5 Mar 2020 10:48:55 +0800
Message-ID: <1583376535-27255-1-git-send-email-linmiaohe@huawei.com>
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

We can get is_mtrr_mask by calculating (msr - 0x200) % 2 directly.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/mtrr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 7f0059aa30e1..a98701d9f2bf 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -348,7 +348,7 @@ static void set_var_mtrr_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	int index, is_mtrr_mask;
 
 	index = (msr - 0x200) / 2;
-	is_mtrr_mask = msr - 0x200 - 2 * index;
+	is_mtrr_mask = (msr - 0x200) % 2;
 	cur = &mtrr_state->var_ranges[index];
 
 	/* remove the entry if it's in the list. */
@@ -424,7 +424,7 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		int is_mtrr_mask;
 
 		index = (msr - 0x200) / 2;
-		is_mtrr_mask = msr - 0x200 - 2 * index;
+		is_mtrr_mask = (msr - 0x200) % 2;
 		if (!is_mtrr_mask)
 			*pdata = vcpu->arch.mtrr_state.var_ranges[index].base;
 		else
-- 
2.19.1

