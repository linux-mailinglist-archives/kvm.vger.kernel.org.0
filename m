Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58AA14159A
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 03:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbgARCkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 21:40:00 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9187 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730588AbgARCj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 21:39:59 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 41AEC3C6971C1F329BD0;
        Sat, 18 Jan 2020 10:39:57 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Sat, 18 Jan 2020
 10:39:47 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: x86: avoid clearing pending exception event twice
Date:   Sat, 18 Jan 2020 10:41:55 +0800
Message-ID: <1579315315-6444-1-git-send-email-linmiaohe@huawei.com>
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

The exception pending event is cleared by kvm_clear_exception_queue(). We
shouldn't clear it again.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/x86.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93bbbce67a03..10fa42f627d9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9180,7 +9180,6 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.nmi_injected = false;
 	kvm_clear_interrupt_queue(vcpu);
 	kvm_clear_exception_queue(vcpu);
-	vcpu->arch.exception.pending = false;
 
 	memset(vcpu->arch.db, 0, sizeof(vcpu->arch.db));
 	kvm_update_dr0123(vcpu);
-- 
2.19.1

