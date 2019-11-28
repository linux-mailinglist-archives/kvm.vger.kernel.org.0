Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3661410C2C0
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 04:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfK1DKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 22:10:07 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:53054 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727113AbfK1DKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 22:10:07 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 351A96ADCDBDC841C9DC;
        Thu, 28 Nov 2019 11:10:05 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 28 Nov 2019
 11:09:55 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <maz@kernel.org>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <suzuki.poulose@arm.com>, <christoffer.dall@arm.com>,
        <catalin.marinas@arm.com>, <eric.auger@redhat.com>,
        <gregkh@linuxfoundation.org>, <will@kernel.org>,
        <andre.przywara@arm.com>, <tglx@linutronix.de>
CC:     <linmiaohe@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH] KVM: arm64: eliminate unnecessary var err and jump label in set_core_reg()
Date:   Thu, 28 Nov 2019 11:09:58 +0800
Message-ID: <1574910598-14468-1-git-send-email-linmiaohe@huawei.com>
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

The var err and jump label out isn't really needed in
set_core_reg(). Clean them up.
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/arm64/kvm/guest.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 3b836c91609e..88eb6e5399ed 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -159,7 +159,6 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	__uint128_t tmp;
 	void *valp = &tmp;
 	u64 off;
-	int err = 0;
 
 	/* Our ID is an index into the kvm_regs struct. */
 	off = core_reg_offset_from_id(reg->id);
@@ -173,10 +172,8 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (KVM_REG_SIZE(reg->id) > sizeof(tmp))
 		return -EINVAL;
 
-	if (copy_from_user(valp, uaddr, KVM_REG_SIZE(reg->id))) {
-		err = -EFAULT;
-		goto out;
-	}
+	if (copy_from_user(valp, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
 
 	if (off == KVM_REG_ARM_CORE_REG(regs.pstate)) {
 		u64 mode = (*(u64 *)valp) & PSR_AA32_MODE_MASK;
@@ -200,14 +197,12 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 				return -EINVAL;
 			break;
 		default:
-			err = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 	}
 
 	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
-out:
-	return err;
+	return 0;
 }
 
 #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
-- 
2.19.1

