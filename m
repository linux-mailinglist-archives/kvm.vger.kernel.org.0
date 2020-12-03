Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9DE2CD56D
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 13:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbgLCMVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 07:21:54 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9099 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgLCMVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 07:21:54 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cmw0N6bBrzLyy0;
        Thu,  3 Dec 2020 20:20:36 +0800 (CST)
Received: from huawei.com (10.174.186.236) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 3 Dec 2020
 20:21:02 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <anup.patel@wdc.com>, <atish.patra@wdc.com>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <pbonzini@redhat.com>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <victor.zhangxiaofeng@huawei.com>, <wu.wubin@huawei.com>,
        <zhang.zhanghailiang@huawei.com>, <dengkai1@huawei.com>,
        <yinyipeng1@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH RFC 0/3] Implement guest time scaling in RISC-V KVM
Date:   Thu, 3 Dec 2020 20:18:36 +0800
Message-ID: <20201203121839.308-1-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series implements guest time scaling based on RDTIME instruction
emulation so that we can allow migrating Guest/VM across Hosts with
different time frequency.

Why not through para-virt. From arm's experience[1], para-virt implementation
doesn't really solve the problem for the following two main reasons:
- RDTIME not only be used in linux, but also in firmware and userspace.
- It is difficult to be compatible with nested virtualization.

[1] https://lore.kernel.org/patchwork/cover/1288153/

Yifei Jiang (3):
  RISC-V: KVM: Change the method of calculating cycles to nanoseconds
  RISC-V: KVM: Support dynamic time frequency from userspace
  RISC-V: KVM: Implement guest time scaling

 arch/riscv/include/asm/csr.h            |  3 ++
 arch/riscv/include/asm/kvm_vcpu_timer.h | 13 +++++--
 arch/riscv/kvm/vcpu_exit.c              | 35 +++++++++++++++++
 arch/riscv/kvm/vcpu_timer.c             | 51 ++++++++++++++++++++++---
 4 files changed, 93 insertions(+), 9 deletions(-)

-- 
2.19.1

