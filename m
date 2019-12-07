Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E8B115BAE
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 10:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfLGJZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Dec 2019 04:25:55 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:59274 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726000AbfLGJZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Dec 2019 04:25:53 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 05F8A166F9C2EF584C38;
        Sat,  7 Dec 2019 17:25:47 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Sat, 7 Dec 2019
 17:25:36 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 5/6] KVM: x86: check kvm_pit outside kvm_vm_ioctl_reinject()
Date:   Sat, 7 Dec 2019 17:25:22 +0800
Message-ID: <1575710723-32094-6-git-send-email-linmiaohe@huawei.com>
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

check kvm_pit outside kvm_vm_ioctl_reinject() to keep codestyle consistent
with other kvm_pit func and prepare for futher cleanups.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d4e3a2dfec6..00b5d4ace383 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4662,9 +4662,6 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
 {
 	struct kvm_pit *pit = kvm->arch.vpit;
 
-	if (!pit)
-		return -ENXIO;
-
 	/* pit->pit_state.lock was overloaded to prevent userspace from getting
 	 * an inconsistent state after running multiple KVM_REINJECT_CONTROL
 	 * ioctls in parallel.  Use a separate lock if that ioctl isn't rare.
@@ -5029,6 +5026,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r =  -EFAULT;
 		if (copy_from_user(&control, argp, sizeof(control)))
 			goto out;
+		r = -ENXIO;
+		if (!kvm->arch.vpit)
+			goto out;
 		r = kvm_vm_ioctl_reinject(kvm, &control);
 		break;
 	}
-- 
2.19.1

