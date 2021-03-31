Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA4C350324
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 17:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbhCaPSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 11:18:36 -0400
Received: from condef-07.nifty.com ([202.248.20.72]:24700 "EHLO
        condef-07.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236026AbhCaPSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 11:18:25 -0400
Received: from conuserg-08.nifty.com ([10.126.8.71])by condef-07.nifty.com with ESMTP id 12VF7UIT002859
        for <kvm@vger.kernel.org>; Thu, 1 Apr 2021 00:07:51 +0900
Received: from localhost.localdomain (133-32-232-101.west.xps.vectant.ne.jp [133.32.232.101]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id 12VF77DG021201;
        Thu, 1 Apr 2021 00:07:08 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com 12VF77DG021201
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1617203229;
        bh=X7MGBKWtJ8QFT7mnCJZpDCMgrc+q4Yb5sVuxj/Bmw2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPOEIc/aJkyRaiYpnLM+6fyo0GyCuAVQoeVq8nvNcmWZGHY7ButJcwqnkxH11G31j
         RlqJr5Rt00XNwaK3GVj1FScvevsoyLrD4fHfr5RK0bkBrg8+mdw6ydwd9NKK5krqNH
         7JaIqSlmDwZHI7JTxUSt9TSr5zCQpqTc4ZZozyr4WgD62h5E4bkuxzL54tAoTfPp10
         bcZkFOxUFJJGO/EopCNKGkEK5Pp2RhqCeqDu3sTbMD81OOF93UuObL46us9LmtiRa3
         jFXRY3bOVeCEyJc4yNj39mxnDH++yS7eoKhvfT7UXT5aYUNtIz/VcQvMz83ScfG50O
         48xxyBwBKe2Og==
X-Nifty-SrcIP: [133.32.232.101]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-mips@linux-mips.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH 2/2] mips: clean up kvm Makefile
Date:   Thu,  1 Apr 2021 00:06:57 +0900
Message-Id: <20210331150658.38919-2-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210331150658.38919-1-masahiroy@kernel.org>
References: <20210331150658.38919-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

You can use kvm-y instead of kvm-objs to create the composite module.
kvm-$(CONFIG_...) looks cleaner.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 arch/mips/kvm/Makefile | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index 7d42d624a7b9..6bc5da6faf0e 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -2,26 +2,23 @@
 # Makefile for KVM support for MIPS
 #
 
-common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o eventfd.o)
-
 ccflags-y += -Ivirt/kvm -Iarch/mips/kvm
 
-common-objs-$(CONFIG_CPU_HAS_MSA) += msa.o
+kvm-y := $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o eventfd.o)
+kvm-$(CONFIG_CPU_HAS_MSA) += msa.o
 
-kvm-objs := $(common-objs-y) mips.o emulate.o entry.o \
+kvm-y +=    mips.o emulate.o entry.o \
 	    interrupt.o stats.o commpage.o \
 	    fpu.o
-kvm-objs += hypcall.o
-kvm-objs += mmu.o
-ifdef CONFIG_CPU_LOONGSON64
-kvm-objs += loongson_ipi.o
-endif
+kvm-y += hypcall.o
+kvm-y += mmu.o
+kvm-$(CONFIG_CPU_LOONGSON64) += loongson_ipi.o
 
 ifdef CONFIG_KVM_MIPS_VZ
-kvm-objs		+= vz.o
+kvm-y		+= vz.o
 else
-kvm-objs		+= dyntrans.o
-kvm-objs		+= trap_emul.o
+kvm-y		+= dyntrans.o
+kvm-y		+= trap_emul.o
 endif
 obj-$(CONFIG_KVM)	+= kvm.o
 obj-y			+= callback.o tlb.o
-- 
2.27.0

