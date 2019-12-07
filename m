Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F86115BAB
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 10:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfLGJZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Dec 2019 04:25:49 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:59234 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726263AbfLGJZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Dec 2019 04:25:49 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F321D2097DBCFEC46ADE;
        Sat,  7 Dec 2019 17:25:46 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Sat, 7 Dec 2019
 17:25:37 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 6/6] KVM: x86: remove always equal to 0 return val of kvm_vm_ioctl_reinject()
Date:   Sat, 7 Dec 2019 17:25:23 +0800
Message-ID: <1575710723-32094-7-git-send-email-linmiaohe@huawei.com>
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

The return val of kvm_vm_ioctl_reinject() is always equal to 0, which means
there is no way to failed with this function. So remove the return val as
it's unnecessary to check against it.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/x86.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00b5d4ace383..82b0403cb2c7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4657,7 +4657,7 @@ static void kvm_vm_ioctl_set_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
 	mutex_unlock(&pit->pit_state.lock);
 }
 
-static int kvm_vm_ioctl_reinject(struct kvm *kvm,
+static void kvm_vm_ioctl_reinject(struct kvm *kvm,
 				 struct kvm_reinject_control *control)
 {
 	struct kvm_pit *pit = kvm->arch.vpit;
@@ -4669,8 +4669,6 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
 	mutex_lock(&pit->pit_state.lock);
 	kvm_pit_set_reinject(pit, control->pit_reinject);
 	mutex_unlock(&pit->pit_state.lock);
-
-	return 0;
 }
 
 /**
@@ -5029,7 +5027,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -ENXIO;
 		if (!kvm->arch.vpit)
 			goto out;
-		r = kvm_vm_ioctl_reinject(kvm, &control);
+		kvm_vm_ioctl_reinject(kvm, &control);
+		r = 0;
 		break;
 	}
 	case KVM_SET_BOOT_CPU_ID:
-- 
2.19.1

