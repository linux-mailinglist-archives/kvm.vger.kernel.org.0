Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACF9153CCF
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 02:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgBFB6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 20:58:00 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9703 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727307AbgBFB6A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 20:58:00 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 49465B4B612BD9E8A9D8;
        Thu,  6 Feb 2020 09:57:57 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Thu, 6 Feb 2020
 09:57:47 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: apic: reuse smp_wmb() in kvm_make_request()
Date:   Thu, 6 Feb 2020 09:59:35 +0800
Message-ID: <1580954375-5030-1-git-send-email-linmiaohe@huawei.com>
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

There is already an smp_mb() barrier in kvm_make_request(). We reuse it
here.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/lapic.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index eafc631d305c..ea871206a370 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1080,9 +1080,12 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 			result = 1;
 			/* assumes that there are only KVM_APIC_INIT/SIPI */
 			apic->pending_events = (1UL << KVM_APIC_INIT);
-			/* make sure pending_events is visible before sending
-			 * the request */
-			smp_wmb();
+			/*
+			 * Make sure pending_events is visible before sending
+			 * the request.
+			 * There is already an smp_wmb() in kvm_make_request(),
+			 * we reuse that barrier here.
+			 */
 			kvm_make_request(KVM_REQ_EVENT, vcpu);
 			kvm_vcpu_kick(vcpu);
 		}
-- 
2.19.1

