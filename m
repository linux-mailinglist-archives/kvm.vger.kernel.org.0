Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0153C12A58D
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 03:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfLYCUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 21:20:07 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44692 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726259AbfLYCUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 21:20:07 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id ED51ABED064994ED5F36;
        Wed, 25 Dec 2019 10:20:01 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Wed, 25 Dec 2019
 10:19:55 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: nvmx: retry writing guest memory after page fault injected
Date:   Wed, 25 Dec 2019 10:21:41 +0800
Message-ID: <1577240501-763-1-git-send-email-linmiaohe@huawei.com>
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

We should retry writing guest memory when kvm_write_guest_virt_system()
failed and page fault is injected in handle_vmread().

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/vmx/nested.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8edefdc9c0cb..c1ec9f25a417 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4799,8 +4799,10 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 					instr_info, true, len, &gva))
 			return 1;
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
-		if (kvm_write_guest_virt_system(vcpu, gva, &value, len, &e))
+		if (kvm_write_guest_virt_system(vcpu, gva, &value, len, &e)) {
 			kvm_inject_page_fault(vcpu, &e);
+			return 1;
+		}
 	}
 
 	return nested_vmx_succeed(vcpu);
-- 
2.19.1

