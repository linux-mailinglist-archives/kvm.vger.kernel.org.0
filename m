Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773422540B3
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 10:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgH0IXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 04:23:52 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45808 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726395AbgH0IXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 04:23:51 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6322BE11D85A99240666;
        Thu, 27 Aug 2020 16:23:48 +0800 (CST)
Received: from huawei.com (10.174.187.31) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 16:23:42 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <anup.patel@wdc.com>,
        <alistair.francis@wdc.com>, <atish.patra@wdc.com>,
        <deepa.kernel@gmail.com>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <victor.zhangxiaofeng@huawei.com>, <wu.wubin@huawei.com>,
        <zhang.zhanghailiang@huawei.com>, <dengkai1@huawei.com>,
        <yinyipeng1@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH RFC 1/2] riscv/kvm: Fix use VSIP_VALID_MASK mask HIP register
Date:   Thu, 27 Aug 2020 16:22:50 +0800
Message-ID: <20200827082251.1591-2-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200827082251.1591-1-jiangyifei@huawei.com>
References: <20200827082251.1591-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.187.31]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The correct sip/sie 0x222 could mask wrong 0x000 by VSIP_VALID_MASK,
This patch fix it.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
---
 arch/riscv/kvm/vcpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index adb0815951aa..2976666e921f 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -419,8 +419,8 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
 
 	if (reg_num == KVM_REG_RISCV_CSR_REG(sip) ||
 	    reg_num == KVM_REG_RISCV_CSR_REG(sie)) {
-		reg_val = reg_val << VSIP_TO_HVIP_SHIFT;
 		reg_val = reg_val & VSIP_VALID_MASK;
+		reg_val = reg_val << VSIP_TO_HVIP_SHIFT;
 	}
 
 	((unsigned long *)csr)[reg_num] = reg_val;
-- 
2.19.1


