Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D28166114
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 16:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgBTPgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 10:36:07 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:52248 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728319AbgBTPgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 10:36:07 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E30F47E11A4E9CF39F13;
        Thu, 20 Feb 2020 23:35:53 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 23:35:12 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: apic: avoid calculating pending eoi from an uninitialized val
Date:   Thu, 20 Feb 2020 23:36:46 +0800
Message-ID: <1582213006-488-1-git-send-email-linmiaohe@huawei.com>
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

When get user eoi value failed, var val would be uninitialized and result
in calculating pending eoi from an uninitialized val. Initialize var val
to 0 to fix this case.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4f14ec7525f6..7e77e94f3176 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -626,7 +626,7 @@ static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
 
 static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
 {
-	u8 val;
+	u8 val = 0;
 	if (pv_eoi_get_user(vcpu, &val) < 0)
 		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
 			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
-- 
2.19.1

