Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8C2BCB1F
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 17:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbfIXPWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 11:22:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46512 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727382AbfIXPWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 11:22:21 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 19DE9F71006A9E2A596B;
        Tue, 24 Sep 2019 23:22:19 +0800 (CST)
Received: from linux-Bxxcye.huawei.com (10.175.104.222) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Tue, 24 Sep 2019 23:22:09 +0800
From:   Heyi Guo <guoheyi@huawei.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>
CC:     <wanghaibin.wang@huawei.com>, Heyi Guo <guoheyi@huawei.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [RFC PATCH 0/2] Add virtual SDEI support for arm64
Date:   Tue, 24 Sep 2019 23:20:52 +0800
Message-ID: <1569338454-26202-1-git-send-email-guoheyi@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.222]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As promised, this is the first RFC patch set for arm64 virtual SDEI
support.

New kvm capability KVM_CAP_FORWARD_HYPERCALL is added to probe if kvm
supports forwarding hypercalls, and the capability should be enabled
explicitly. PSCI can be set as exception for backward compatibility.

We reuse the existing term "hypercall" for SMC/HVC, as well as the
hypercall structure in kvm_run to exchange arguments and return
values. The definition on arm64 is as below:

exit_reason: KVM_EXIT_HYPERCALL

Input:
  nr: the immediate value of SMC/HVC calls; not really used today.
  args[6]: x0..x5 (This is not fully conform with SMCCC which requires
           x6 as argument as well, but use space can use GET_ONE_REG
           ioctl for such rare case).

Return:
  args[0..3]: x0..x3 as defined in SMCCC. We need to extract
              args[0..3] and write them to x0..x3 when hypercall exit
              returns.

And there is a corresponding patch set for qemu.

Please give your comments and suggestions.

Thanks,
HG

Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>

Heyi Guo (2):
  kvm/arm: add capability to forward hypercall to user space
  kvm/arm64: expose hypercall_forwarding capability

 arch/arm/include/asm/kvm_host.h   |  5 +++++
 arch/arm64/include/asm/kvm_host.h |  5 +++++
 arch/arm64/kvm/reset.c            | 25 +++++++++++++++++++++++++
 include/kvm/arm_psci.h            |  1 +
 include/uapi/linux/kvm.h          |  3 +++
 virt/kvm/arm/arm.c                |  2 ++
 virt/kvm/arm/psci.c               | 30 ++++++++++++++++++++++++++++--
 7 files changed, 69 insertions(+), 2 deletions(-)

-- 
1.8.3.1

