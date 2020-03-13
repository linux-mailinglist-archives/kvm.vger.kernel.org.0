Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A04183F5B
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 04:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgCMDO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 23:14:29 -0400
Received: from mail.loongson.cn ([114.242.206.163]:55506 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726420AbgCMDO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 23:14:29 -0400
Received: from localhost.localdomain.localdomain (unknown [125.69.47.232])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxn9uK+mpe1gcaAA--.45S2;
        Fri, 13 Mar 2020 11:14:19 +0800 (CST)
From:   Xing Li <lixing@loongson.cn>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, maobibo@loongson.cn,
        chenhc@lemote.com, jiaxun.yang@flygoat.com
Subject: [PATCH v2 Resend 1/3] KVM: MIPS: Change KVM_ENTRYHI_ASID to cpu_asid_mask(&current_cpu_data)
Date:   Fri, 13 Mar 2020 11:14:15 +0800
Message-Id: <1584069257-30896-1-git-send-email-lixing@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9Dxn9uK+mpe1gcaAA--.45S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtFWktw1rWw47uFW3tFWDJwb_yoWkWrc_Z3
        W7Zws7ur4fCrZFy39Iywn3WFWFgw1UWF929r9IgFyq9asFyry5Wa9xJr9rAwsxur4qyF4r
        W34DJ34rZrnrCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb48FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
        1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8
        GwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
        0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUb2g4DUUUU
        U==
X-CM-SenderInfo: pol0x03j6o00pqjv00gofq/
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The code in decode_config4 of arch/mips/kernel/cpu-probe.c

        asid_mask = MIPS_ENTRYHI_ASID;
        if (config4 & MIPS_CONF4_AE)
                asid_mask |= MIPS_ENTRYHI_ASIDX;
        set_cpu_asid_mask(c, asid_mask);

set asid_mask to cpuinfo->asid_mask

So KVM_ENTRYHI_ASID should change to cpu_asid_mask(&current_cpu_data)
for support 10bits ASID_MASK

Signed-off-by: Xing Li <lixing@loongson.cn>
---
 arch/mips/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 41204a4..6be70d5 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -275,7 +275,7 @@ enum emulation_result {
 #define MIPS3_PG_FRAME		0x3fffffc0
 
 #define VPN2_MASK		0xffffe000
-#define KVM_ENTRYHI_ASID	MIPS_ENTRYHI_ASID
+#define KVM_ENTRYHI_ASID	cpu_asid_mask(&current_cpu_data)
 #define TLB_IS_GLOBAL(x)	((x).tlb_lo[0] & (x).tlb_lo[1] & ENTRYLO_G)
 #define TLB_VPN2(x)		((x).tlb_hi & VPN2_MASK)
 #define TLB_ASID(x)		((x).tlb_hi & KVM_ENTRYHI_ASID)
-- 
2.1.0

