Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDA72A2381
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 04:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgKBDhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Nov 2020 22:37:07 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6722 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbgKBDhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Nov 2020 22:37:07 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CPdrZ712XzkdN2;
        Mon,  2 Nov 2020 11:37:02 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 2 Nov 2020 11:36:58 +0800
From:   Peng Liang <liangpeng10@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     <kvm@vger.kernel.org>, <maz@kernel.org>, <will@kernel.org>,
        <drjones@redhat.com>, <zhang.zhanghailiang@huawei.com>,
        <xiexiangyou@huawei.com>, Peng Liang <liangpeng10@huawei.com>
Subject: [RFC v3 00/12] kvm: arm64: emulate ID registers
Date:   Mon, 2 Nov 2020 11:34:10 +0800
Message-ID: <20201102033422.657391-1-liangpeng10@huawei.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In AArch64, guest will read the same values of the ID regsiters with
host.  Both of them read the values from arm64_ftr_regs.  This patch
series add support to emulate and configure ID registers so that we can
control the value of ID registers that guest read.

v2 -> v3:
 - remove check_user and split some set_user for some ID registers
 - check the consistency of ID registers of vCPUS
 - add more doc for the limits

v1 -> v2:
 - save the ID registers in sysreg file instead of a new struct
 - apply a checker before setting the value to the register
 - add doc for new KVM_CAP_ARM_CPU_FEATURE

Peng Liang (12):
  arm64: Add a helper function to traverse arm64_ftr_regs
  arm64: Introduce check_features
  kvm: arm64: Save ID registers to sys_regs file
  kvm: arm64: Make ID_AA64PFR0_EL1 configurable
  kvm: arm64: Make ID_AA64DFR0_EL1 configurable
  kvm: arm64: Make ID_AA64ISAR0_EL1 configurable
  kvm: arm64: Make ID_AA64ISAR1_EL1 configurable
  kvm: arm64: Make ID_DFR0_EL1 configurable
  kvm: arm64: Make MVFR1_EL1 configurable
  kvm: arm64: Make other ID registers configurable
  kvm: arm64: Check consistent of ID register
  kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension

 Documentation/virt/kvm/api.rst      |  36 ++++
 arch/arm64/include/asm/cpufeature.h |   4 +
 arch/arm64/include/asm/kvm_coproc.h |   2 +
 arch/arm64/include/asm/kvm_host.h   |   9 +
 arch/arm64/kernel/cpufeature.c      |  36 ++++
 arch/arm64/kvm/arm.c                |  22 +++
 arch/arm64/kvm/sys_regs.c           | 272 ++++++++++++++++++++++++++--
 include/uapi/linux/kvm.h            |   1 +
 8 files changed, 365 insertions(+), 17 deletions(-)

-- 
2.26.2

