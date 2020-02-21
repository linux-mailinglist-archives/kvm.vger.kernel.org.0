Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB6F167F82
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 15:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgBUODa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 09:03:30 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10662 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727876AbgBUODa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 09:03:30 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7F25D60998780C0EA439;
        Fri, 21 Feb 2020 22:03:22 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 21 Feb 2020
 22:03:13 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH v2] KVM: apic: avoid calculating pending eoi from an uninitialized val
Date:   Fri, 21 Feb 2020 22:04:46 +0800
Message-ID: <1582293886-23335-1-git-send-email-linmiaohe@huawei.com>
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

When pv_eoi_get_user() fails, 'val' may remain uninitialized and the return
value of pv_eoi_get_pending() becomes random. Fix the issue by initializing
the variable.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
v1->v2:
Collect Vitaly' R-b.
Use Vitaly' alternative wording.
Explicitly handle the error, as suggested by Sean.
---
 arch/x86/kvm/lapic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4f14ec7525f6..b4aca77efc8e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -627,9 +627,11 @@ static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
 static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
 {
 	u8 val;
-	if (pv_eoi_get_user(vcpu, &val) < 0)
+	if (pv_eoi_get_user(vcpu, &val) < 0) {
 		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
 			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
+		return false;
+	}
 	return val & 0x1;
 }
 
-- 
2.19.1

