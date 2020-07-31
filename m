Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09F0233FCF
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731552AbgGaHPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:15:38 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44472 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731419AbgGaHPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:15:38 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F2D441A9DA066B7E64B6;
        Fri, 31 Jul 2020 15:15:30 +0800 (CST)
Received: from huawei.com (10.175.104.57) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Fri, 31 Jul 2020
 15:15:26 +0800
From:   Peng Wu <wupeng58@huawei.com>
To:     <tsbogend@alpha.franken.de>
CC:     <chenhc@lemote.com>, <pbonzini@redhat.com>,
        <aleksandar.qemu.devel@gmail.com>, <colin.king@canonical.com>,
        <tianjia.zhang@linux.alibaba.com>, <huanglllzu@gmail.com>,
        <linux-mips@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] emulate:Fix build error
Date:   Fri, 31 Jul 2020 15:16:47 +0800
Message-ID: <1596179807-17713-1-git-send-email-wupeng58@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The declaration of function kvm_mips_complete_mmio_load
has only one formal parameter,but two parameters are passed
when called. So, the following error is seen while building
emulate.c

arch/mips/kvm/emulate.c: In function ‘kvm_mips_emulate_load’:
arch/mips/kvm/emulate.c:2130:3: error: too many arguments
to function ‘kvm_mips_complete_mmio_load’
   kvm_mips_complete_mmio_load(vcpu, run);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from linux/include/linux/kvm_host.h:36,
                 from linux/arch/mips/kvm/emulate.c:15:
arch/mips/include/asm/kvm_host.h:1072:30: note: declared here
extern enum emulation_result
	kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu);

Signed-off-by: Peng Wu <wupeng58@huawei.com>
---
 arch/mips/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
index 1d41965..7037823 100644
--- a/arch/mips/kvm/emulate.c
+++ b/arch/mips/kvm/emulate.c
@@ -2127,7 +2127,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 			run->mmio.phys_addr, run->mmio.len, run->mmio.data);
 
 	if (!r) {
-		kvm_mips_complete_mmio_load(vcpu, run);
+		kvm_mips_complete_mmio_load(vcpu);
 		vcpu->mmio_needed = 0;
 		return EMULATE_DONE;
 	}
-- 
2.7.4

