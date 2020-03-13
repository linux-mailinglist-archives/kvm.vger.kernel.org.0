Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E033A183F5D
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 04:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgCMDOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 23:14:32 -0400
Received: from mail.loongson.cn ([114.242.206.163]:55508 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726310AbgCMDO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 23:14:29 -0400
Received: from localhost.localdomain.localdomain (unknown [125.69.47.232])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxn9uK+mpe1gcaAA--.45S3;
        Fri, 13 Mar 2020 11:14:20 +0800 (CST)
From:   Xing Li <lixing@loongson.cn>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, maobibo@loongson.cn,
        chenhc@lemote.com, jiaxun.yang@flygoat.com
Subject: [PATCH v2 Resend 2/3] KVM: MIPS: Fixup VPN2_MASK definition over 32bits virtual address
Date:   Fri, 13 Mar 2020 11:14:16 +0800
Message-Id: <1584069257-30896-2-git-send-email-lixing@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1584069257-30896-1-git-send-email-lixing@loongson.cn>
References: <1584069257-30896-1-git-send-email-lixing@loongson.cn>
X-CM-TRANSID: AQAAf9Dxn9uK+mpe1gcaAA--.45S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKr47GrWxWw4DXr1xKrW3ZFb_yoWDKwbEva
        4xZws7Zr1kGFZFyrWxZan5WFy5W34UWF9Igr98WryDC34Syrs8Wa93ury7Jw45uw4jyFsY
        va4vv34rZrnF9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbhxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGwA2048vs2IY02
        0Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84
        ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr0_GcWl
        e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
        8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
        jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r48MxAIw2
        8IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4l
        x2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrw
        CI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI
        42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z2
        80aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjLSdPUUUUU==
X-CM-SenderInfo: pol0x03j6o00pqjv00gofq/
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the cpu support more than 32bits vmbits, VPN2_MASK set to fixed
0xffffe000 will lead to wrong entryhi for _kvm_mips_host_tlb_inv

The cpu_vmbits definition of 32bit in cpu-features.h is 31,
so still use the old style for 32bits.

Signed-off-by: Xing Li <lixing@loongson.cn>
---
v2:
Change VPN2_MASK definition according to Jiaxun Yang's comment
 arch/mips/include/asm/kvm_host.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 6be70d5..ef8e606 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -274,7 +274,11 @@ enum emulation_result {
 #define MIPS3_PG_SHIFT		6
 #define MIPS3_PG_FRAME		0x3fffffc0
 
+#if defined(CONFIG_64BIT)
+#define VPN2_MASK		GENMASK(cpu_vmbits - 1, 13)
+#else
 #define VPN2_MASK		0xffffe000
+#endif
 #define KVM_ENTRYHI_ASID	cpu_asid_mask(&current_cpu_data)
 #define TLB_IS_GLOBAL(x)	((x).tlb_lo[0] & (x).tlb_lo[1] & ENTRYLO_G)
 #define TLB_VPN2(x)		((x).tlb_hi & VPN2_MASK)
-- 
2.1.0

