Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42798DE265
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 04:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfJUCwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Oct 2019 22:52:34 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4737 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726768AbfJUCwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Oct 2019 22:52:34 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 93BB4285F04837690E45;
        Mon, 21 Oct 2019 10:52:31 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Mon, 21 Oct 2019
 10:52:24 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] KVM: remove redundant code in kvm_arch_vm_ioctl
Date:   Mon, 21 Oct 2019 10:52:56 +0800
Message-ID: <1571626376-11357-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If we reach here with r = 0, we will reassign r = 0
unnecesarry, then do the label set_irqchip_out work.
If we reach here with r != 0, then we will do the label
work directly. So this if statement and r = 0 assignment
is redundant.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/x86.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 661e2bf38526..0b3ebc2afb3d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4916,9 +4916,6 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (!irqchip_kernel(kvm))
 			goto set_irqchip_out;
 		r = kvm_vm_ioctl_set_irqchip(kvm, chip);
-		if (r)
-			goto set_irqchip_out;
-		r = 0;
 	set_irqchip_out:
 		kfree(chip);
 		break;
-- 
2.19.1

