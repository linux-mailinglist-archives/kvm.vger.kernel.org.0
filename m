Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8EB12599E
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 03:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfLSCfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 21:35:52 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:57026 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726700AbfLSCfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 21:35:51 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E3B169EA66CD9E325FA9;
        Thu, 19 Dec 2019 10:35:48 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Dec 2019
 10:35:40 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH v2] KVM: x86: remove unnecessary return vals of kvm pit functions
Date:   Thu, 19 Dec 2019 10:35:20 +0800
Message-ID: <1576722920-10558-1-git-send-email-linmiaohe@huawei.com>
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

The return vals of kvm pit functions are always equal to 0, which means
there is no way to failed with these function. So remove the return vals
as it's unnecessary to check these. Also add BUILD_BUG_ON to guard against
channels size changed unexpectly.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
v2:
	reorganize the patches. The previous one looks unresonable. I'm
sorry about it.
---
 arch/x86/kvm/x86.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8bb2fb1705ff..b8a75c581214 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4596,7 +4596,7 @@ static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 	return r;
 }
 
-static int kvm_vm_ioctl_get_pit(struct kvm *kvm, struct kvm_pit_state *ps)
+static void kvm_vm_ioctl_get_pit(struct kvm *kvm, struct kvm_pit_state *ps)
 {
 	struct kvm_kpit_state *kps = &kvm->arch.vpit->pit_state;
 
@@ -4605,40 +4605,44 @@ static int kvm_vm_ioctl_get_pit(struct kvm *kvm, struct kvm_pit_state *ps)
 	mutex_lock(&kps->lock);
 	memcpy(ps, &kps->channels, sizeof(*ps));
 	mutex_unlock(&kps->lock);
-	return 0;
 }
 
-static int kvm_vm_ioctl_set_pit(struct kvm *kvm, struct kvm_pit_state *ps)
+static void kvm_vm_ioctl_set_pit(struct kvm *kvm, struct kvm_pit_state *ps)
 {
 	int i;
 	struct kvm_pit *pit = kvm->arch.vpit;
 
+	BUILD_BUG_ON(sizeof(*ps) != sizeof(pit->pit_state.channels));
+
 	mutex_lock(&pit->pit_state.lock);
 	memcpy(&pit->pit_state.channels, ps, sizeof(*ps));
 	for (i = 0; i < 3; i++)
 		kvm_pit_load_count(pit, i, ps->channels[i].count, 0);
 	mutex_unlock(&pit->pit_state.lock);
-	return 0;
 }
 
-static int kvm_vm_ioctl_get_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
+static void kvm_vm_ioctl_get_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
 {
+	BUILD_BUG_ON(sizeof(ps->channels) !=
+		     sizeof(kvm->arch.vpit->pit_state.channels));
+
 	mutex_lock(&kvm->arch.vpit->pit_state.lock);
 	memcpy(ps->channels, &kvm->arch.vpit->pit_state.channels,
 		sizeof(ps->channels));
 	ps->flags = kvm->arch.vpit->pit_state.flags;
 	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
 	memset(&ps->reserved, 0, sizeof(ps->reserved));
-	return 0;
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
@@ -4651,17 +4655,13 @@ static int kvm_vm_ioctl_set_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
 		kvm_pit_load_count(pit, i, pit->pit_state.channels[i].count,
 				   start && i == 0);
 	mutex_unlock(&pit->pit_state.lock);
-	return 0;
 }
 
-static int kvm_vm_ioctl_reinject(struct kvm *kvm,
+static void kvm_vm_ioctl_reinject(struct kvm *kvm,
 				 struct kvm_reinject_control *control)
 {
 	struct kvm_pit *pit = kvm->arch.vpit;
 
-	if (!pit)
-		return -ENXIO;
-
 	/* pit->pit_state.lock was overloaded to prevent userspace from getting
 	 * an inconsistent state after running multiple KVM_REINJECT_CONTROL
 	 * ioctls in parallel.  Use a separate lock if that ioctl isn't rare.
@@ -4669,8 +4669,6 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
 	mutex_lock(&pit->pit_state.lock);
 	kvm_pit_set_reinject(pit, control->pit_reinject);
 	mutex_unlock(&pit->pit_state.lock);
-
-	return 0;
 }
 
 /**
@@ -4981,9 +4979,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
@@ -4997,16 +4993,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -ENXIO;
 		if (!kvm->arch.vpit)
 			goto out;
-		r = kvm_vm_ioctl_set_pit(kvm, &u.ps);
+		kvm_vm_ioctl_set_pit(kvm, &u.ps);
+		r = 0;
 		break;
 	}
 	case KVM_GET_PIT2: {
 		r = -ENXIO;
 		if (!kvm->arch.vpit)
 			goto out;
-		r = kvm_vm_ioctl_get_pit2(kvm, &u.ps2);
-		if (r)
-			goto out;
+		kvm_vm_ioctl_get_pit2(kvm, &u.ps2);
 		r = -EFAULT;
 		if (copy_to_user(argp, &u.ps2, sizeof(u.ps2)))
 			goto out;
@@ -5020,7 +5015,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -ENXIO;
 		if (!kvm->arch.vpit)
 			goto out;
-		r = kvm_vm_ioctl_set_pit2(kvm, &u.ps2);
+		kvm_vm_ioctl_set_pit2(kvm, &u.ps2);
+		r = 0;
 		break;
 	}
 	case KVM_REINJECT_CONTROL: {
@@ -5028,7 +5024,11 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r =  -EFAULT;
 		if (copy_from_user(&control, argp, sizeof(control)))
 			goto out;
-		r = kvm_vm_ioctl_reinject(kvm, &control);
+		r = -ENXIO;
+		if (!kvm->arch.vpit)
+			goto out;
+		kvm_vm_ioctl_reinject(kvm, &control);
+		r = 0;
 		break;
 	}
 	case KVM_SET_BOOT_CPU_ID:
-- 
2.19.1

