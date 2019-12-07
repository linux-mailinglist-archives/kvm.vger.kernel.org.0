Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91689115BB4
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 10:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfLGJ0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Dec 2019 04:26:11 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44664 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726307AbfLGJZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Dec 2019 04:25:45 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E726E9190CB894EC4E39;
        Sat,  7 Dec 2019 17:25:41 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Sat, 7 Dec 2019
 17:25:33 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 1/6] KVM: x86: remove always equal to 0 return val of kvm_vm_ioctl_get_pit()
Date:   Sat, 7 Dec 2019 17:25:18 +0800
Message-ID: <1575710723-32094-2-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1575710723-32094-1-git-send-email-linmiaohe@huawei.com>
References: <1575710723-32094-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

The return val of kvm_vm_ioctl_get_pit() is always equal to 0, which means
there is no way to failed with this function. So remove the return val as
it's unnecessary to check against it.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/x86.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 392d473252f8..732f03c19fdc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4596,7 +4596,7 @@ static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 	return r;
 }
 
-static int kvm_vm_ioctl_get_pit(struct kvm *kvm, struct kvm_pit_state *ps)
+static void kvm_vm_ioctl_get_pit(struct kvm *kvm, struct kvm_pit_state *ps)
 {
 	struct kvm_kpit_state *kps = &kvm->arch.vpit->pit_state;
 
@@ -4605,7 +4605,6 @@ static int kvm_vm_ioctl_get_pit(struct kvm *kvm, struct kvm_pit_state *ps)
 	mutex_lock(&kps->lock);
 	memcpy(ps, &kps->channels, sizeof(*ps));
 	mutex_unlock(&kps->lock);
-	return 0;
 }
 
 static int kvm_vm_ioctl_set_pit(struct kvm *kvm, struct kvm_pit_state *ps)
@@ -4981,9 +4980,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -ENXIO;
 		if (!kvm->arch.vpit)
 			goto out;
-		r = kvm_vm_ioctl_get_pit(kvm, &u.ps);
-		if (r)
-			goto out;
+		kvm_vm_ioctl_get_pit(kvm, &u.ps);
 		r = -EFAULT;
 		if (copy_to_user(argp, &u.ps, sizeof(struct kvm_pit_state)))
 			goto out;
-- 
2.19.1

