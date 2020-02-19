Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3CC163A67
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 03:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgBSCoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 21:44:20 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10214 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727187AbgBSCoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 21:44:20 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E49B176D5EFC7A29FE95;
        Wed, 19 Feb 2020 10:44:18 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 19 Feb 2020
 10:44:13 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH v2] KVM: VMX: replace "fall through" with "return" to indicate different case
Date:   Wed, 19 Feb 2020 10:45:48 +0800
Message-ID: <1582080348-20827-1-git-send-email-linmiaohe@huawei.com>
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

The second "/* fall through */" in rmode_exception() makes code harder to
read. Replace it with "return" to indicate they are different cases, only
the #DB and #BP check vcpu->guest_debug, while others don't care. And this
also improves the readability.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a13368b2719c..5b8f024f06c2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4492,10 +4492,8 @@ static bool rmode_exception(struct kvm_vcpu *vcpu, int vec)
 			return false;
 		/* fall through */
 	case DB_VECTOR:
-		if (vcpu->guest_debug &
-			(KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
-			return false;
-		/* fall through */
+		return !(vcpu->guest_debug &
+			(KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP));
 	case DE_VECTOR:
 	case OF_VECTOR:
 	case BR_VECTOR:
-- 
2.19.1

