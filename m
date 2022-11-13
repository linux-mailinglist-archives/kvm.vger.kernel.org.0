Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDCB626FEF
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 14:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbiKMNxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 08:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235393AbiKMNxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 08:53:03 -0500
Received: from smtp.smtpout.orange.fr (smtp-21.smtpout.orange.fr [80.12.242.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D732311C35
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 05:53:01 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id uDPsoatM9TyouuDPso0z7n; Sun, 13 Nov 2022 14:52:59 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Nov 2022 14:52:59 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH] RISC-V: KVM: Simplify kvm_arch_prepare_memory_region()
Date:   Sun, 13 Nov 2022 14:52:54 +0100
Message-Id: <c5e918630ba37273d7b0f4e4dbb6f90d4c2f321d.1668347565.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In kvm_arch_prepare_memory_region(), if no error occurs, a spin_lock()/
spin_unlock() call can be avoided.

Switch to kvm_riscv_gstage_iounmap() that is the same as the current code,
but with a better semantic.
It also embeds the locking logic. So it is avoided if ret == 0.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
I don't use cross-compiler, so this patch is NOT even compile tested.
---
 arch/riscv/kvm/mmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 3620ecac2fa1..c8834e463763 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -537,10 +537,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if (change == KVM_MR_FLAGS_ONLY)
 		goto out;
 
-	spin_lock(&kvm->mmu_lock);
 	if (ret)
-		gstage_unmap_range(kvm, base_gpa, size, false);
-	spin_unlock(&kvm->mmu_lock);
+		kvm_riscv_gstage_iounmap(kvm, base_gpa, size);
 
 out:
 	mmap_read_unlock(current->mm);
-- 
2.34.1

