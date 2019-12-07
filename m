Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313D0115BB1
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 10:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfLGJ0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Dec 2019 04:26:05 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44662 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbfLGJZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Dec 2019 04:25:45 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EDD442BAA77B5C873DA8;
        Sat,  7 Dec 2019 17:25:41 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Sat, 7 Dec 2019
 17:25:35 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 4/6] KVM: x86: remove always equal to 0 return val of kvm_vm_ioctl_set_pit2()
Date:   Sat, 7 Dec 2019 17:25:21 +0800
Message-ID: <1575710723-32094-5-git-send-email-linmiaohe@huawei.com>
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

The return val of kvm_vm_ioctl_set_pit2() is always equal to 0, which means
there is no way to failed with this function. So remove the return val as
it's unnecessary to check against it.
Also add BUILD_BUG_ON to guard against channels size changed unexpectly.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/x86.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 637d5c6b92be..2d4e3a2dfec6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4634,13 +4634,15 @@ static void kvm_vm_ioctl_get_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
 	memset(&ps->reserved, 0, sizeof(ps->reserved));
 }
 
-static int kvm_vm_ioctl_set_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
+static void kvm_vm_ioctl_set_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
 {
 	int start = 0;
 	int i;
 	u32 prev_legacy, cur_legacy;
 	struct kvm_pit *pit = kvm->arch.vpit;
 
+	BUILD_BUG_ON(sizeof(ps->channels) != sizeof(pit->pit_state.channels));
+
 	mutex_lock(&pit->pit_state.lock);
 	prev_legacy = pit->pit_state.flags & KVM_PIT_FLAGS_HPET_LEGACY;
 	cur_legacy = ps->flags & KVM_PIT_FLAGS_HPET_LEGACY;
@@ -4653,7 +4655,6 @@ static int kvm_vm_ioctl_set_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
 		kvm_pit_load_count(pit, i, pit->pit_state.channels[i].count,
 				   start && i == 0);
 	mutex_unlock(&pit->pit_state.lock);
-	return 0;
 }
 
 static int kvm_vm_ioctl_reinject(struct kvm *kvm,
@@ -5019,7 +5020,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -ENXIO;
 		if (!kvm->arch.vpit)
 			goto out;
-		r = kvm_vm_ioctl_set_pit2(kvm, &u.ps2);
+		kvm_vm_ioctl_set_pit2(kvm, &u.ps2);
+		r = 0;
 		break;
 	}
 	case KVM_REINJECT_CONTROL: {
-- 
2.19.1

