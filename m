Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7317A183F60
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 04:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgCMDO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 23:14:28 -0400
Received: from mail.loongson.cn ([114.242.206.163]:55504 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726377AbgCMDO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 23:14:28 -0400
Received: from localhost.localdomain.localdomain (unknown [125.69.47.232])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxn9uK+mpe1gcaAA--.45S4;
        Fri, 13 Mar 2020 11:14:20 +0800 (CST)
From:   Xing Li <lixing@loongson.cn>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, maobibo@loongson.cn,
        chenhc@lemote.com, jiaxun.yang@flygoat.com
Subject: [PATCH v2 Resend 3/3] KVM: MIPS: Support kvm modules autoprobed when startup system
Date:   Fri, 13 Mar 2020 11:14:17 +0800
Message-Id: <1584069257-30896-3-git-send-email-lixing@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1584069257-30896-1-git-send-email-lixing@loongson.cn>
References: <1584069257-30896-1-git-send-email-lixing@loongson.cn>
X-CM-TRANSID: AQAAf9Dxn9uK+mpe1gcaAA--.45S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr1xCFy7uF1UKFWkuw4rKrg_yoW8Zr1rpF
        4DAa93Cr45uryDJFWfZFnFgrW3Ja1DG3yj9ayjgryjv3ZYqFs8Jws2kwnxKr1DXFsIq3WF
        gas3Xr1jka92vw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBv14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
        x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
        8EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxd
        M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
        v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
        F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8GwCF04
        k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18
        MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr4
        1lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l
        IxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4
        A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU5pnQUUUUU=
X-CM-SenderInfo: pol0x03j6o00pqjv00gofq/
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the module_init of kvm_mips_init cannot force the kvm
modules insmod when startup system.

Add new feature CPU_MIPS_VZ in elf_hwcap to support KVM auto probe
when hardware virtualization supported.

Signed-off-by: Xing Li <lixing@loongson.cn>
---
 arch/mips/include/uapi/asm/hwcap.h | 1 +
 arch/mips/kernel/cpu-probe.c       | 4 +++-
 arch/mips/kvm/mips.c               | 3 ++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/uapi/asm/hwcap.h b/arch/mips/include/uapi/asm/hwcap.h
index 1ade1da..9e66509 100644
--- a/arch/mips/include/uapi/asm/hwcap.h
+++ b/arch/mips/include/uapi/asm/hwcap.h
@@ -17,5 +17,6 @@
 #define HWCAP_LOONGSON_MMI  (1 << 11)
 #define HWCAP_LOONGSON_EXT  (1 << 12)
 #define HWCAP_LOONGSON_EXT2 (1 << 13)
+#define HWCAP_MIPS_VZ       (1 << 14)
 
 #endif /* _UAPI_ASM_HWCAP_H */
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index c543326..b305269 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -2242,8 +2242,10 @@ void cpu_probe(void)
 	if (cpu_has_loongson_ext2)
 		elf_hwcap |= HWCAP_LOONGSON_EXT2;
 
-	if (cpu_has_vz)
+	if (cpu_has_vz) {
 		cpu_probe_vz(c);
+		elf_hwcap |= HWCAP_MIPS_VZ;
+	}
 
 	cpu_probe_vmbits(c);
 
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 1109924..1da5df3 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -19,6 +19,7 @@
 #include <linux/sched/signal.h>
 #include <linux/fs.h>
 #include <linux/memblock.h>
+#include <linux/cpufeature.h>
 
 #include <asm/fpu.h>
 #include <asm/page.h>
@@ -1742,7 +1743,7 @@ static void __exit kvm_mips_exit(void)
 	unregister_die_notifier(&kvm_mips_csr_die_notifier);
 }
 
-module_init(kvm_mips_init);
+module_cpu_feature_match(MIPS_VZ, kvm_mips_init);
 module_exit(kvm_mips_exit);
 
 EXPORT_TRACEPOINT_SYMBOL(kvm_exit);
-- 
2.1.0

