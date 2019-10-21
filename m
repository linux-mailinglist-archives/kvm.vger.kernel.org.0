Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5B9DE71C
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 10:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfJUIw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 04:52:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4739 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726181AbfJUIw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 04:52:26 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 85CC1A26E84D34BABAC3;
        Mon, 21 Oct 2019 16:52:24 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Mon, 21 Oct 2019
 16:52:14 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH v2] KVM: remove redundant code in kvm_arch_vm_ioctl
Date:   Mon, 21 Oct 2019 16:52:53 +0800
Message-ID: <1571647973-18657-1-git-send-email-linmiaohe@huawei.com>
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
is redundant. We remove them and therefore we can get rid
of odd set_irqchip_out lable further pointed out by tglx.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/x86.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 661e2bf38526..cd4ca8c2f7de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4913,13 +4913,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		}
 
 		r = -ENXIO;
-		if (!irqchip_kernel(kvm))
-			goto set_irqchip_out;
-		r = kvm_vm_ioctl_set_irqchip(kvm, chip);
-		if (r)
-			goto set_irqchip_out;
-		r = 0;
-	set_irqchip_out:
+		if (irqchip_kernel(kvm))
+			r = kvm_vm_ioctl_set_irqchip(kvm, chip);
 		kfree(chip);
 		break;
 	}
-- 
2.19.1

