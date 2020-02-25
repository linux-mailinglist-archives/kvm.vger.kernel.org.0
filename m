Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B290516B7AC
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 03:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgBYCT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 21:19:58 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44134 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726962AbgBYCT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 21:19:58 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BAF3F1A1BAE69E311B6B;
        Tue, 25 Feb 2020 10:19:56 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Feb 2020
 10:19:48 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: X86: avoid meaningless kvm_apicv_activated() check
Date:   Tue, 25 Feb 2020 10:21:19 +0800
Message-ID: <1582597279-32297-1-git-send-email-linmiaohe@huawei.com>
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

After test_and_set_bit() for kvm->arch.apicv_inhibit_reasons, we will
always get false when calling kvm_apicv_activated() because it's sure
apicv_inhibit_reasons do not equal to 0.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ddcc51b89e2c..fa62dcb0ed0c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8018,8 +8018,7 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 		    !kvm_apicv_activated(kvm))
 			return;
 	} else {
-		if (test_and_set_bit(bit, &kvm->arch.apicv_inhibit_reasons) ||
-		    kvm_apicv_activated(kvm))
+		if (test_and_set_bit(bit, &kvm->arch.apicv_inhibit_reasons))
 			return;
 	}
 
-- 
2.19.1

