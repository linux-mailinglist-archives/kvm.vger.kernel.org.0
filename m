Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016A222C17B
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 10:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgGXIzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 04:55:49 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55940 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727112AbgGXIzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 04:55:49 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DDC697F4DEC214F115C6;
        Fri, 24 Jul 2020 16:55:38 +0800 (CST)
Received: from huawei.com (10.174.187.31) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Jul 2020
 16:55:28 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <pbonzini@redhat.com>, <paul.walmsley@sifive.com>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>
CC:     <anup.patel@wdc.com>, <atish.patra@wdc.com>, <kvm@vger.kernel.org>,
        <kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <victor.zhangxiaofeng@huawei.com>,
        <wu.wubin@huawei.com>, <zhang.zhanghailiang@huawei.com>,
        <dengkai1@huawei.com>, <limingwang@huawei.com>,
        Yifei Jiang <jiangyifei@huawei.com>
Subject: [RFC 1/2] RISC-V: KVM: enable ioeventfd capability and compile for risc-v
Date:   Fri, 24 Jul 2020 16:54:40 +0800
Message-ID: <20200724085441.1514-2-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200724085441.1514-1-jiangyifei@huawei.com>
References: <20200724085441.1514-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.187.31]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
---
 arch/riscv/kvm/Kconfig  | 2 ++
 arch/riscv/kvm/Makefile | 2 +-
 arch/riscv/kvm/vm.c     | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 2356dc52ebb3..95d85d893ab6 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -4,6 +4,7 @@
 #
 
 source "virt/kvm/Kconfig"
+source "drivers/vhost/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
@@ -26,6 +27,7 @@ config KVM
 	select KVM_MMIO
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select SRCU
+	select HAVE_KVM_EVENTFD
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index b56dc1650d2c..3ad46fe44900 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for RISC-V KVM support
 #
 
-common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
+common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o eventfd.o)
 
 ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 4f2498198cb5..473299e71f68 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -52,6 +52,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	int r;
 
 	switch (ext) {
+	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SYNC_MMU:
-- 
2.19.1


