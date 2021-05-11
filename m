Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CB437A533
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 12:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhEKK4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 06:56:16 -0400
Received: from ozlabs.org ([203.11.71.1]:47903 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230382AbhEKK4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 06:56:16 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4FfZZN4p2zz9t14; Tue, 11 May 2021 20:55:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1620730508;
        bh=B4zCMGOZBSo431ZwaVwZwLRLvWTkJgniLzw1qREC68g=;
        h=From:To:Cc:Subject:Date:From;
        b=IzYRfA1rL29TjC83Jdh94WPZjuw8ebS11J/kDt3f/CIMk1LS+yB8JZ9QnHBFHNh43
         rwaoq6Cbd369Cm4dxelycd/+AtWDp+v5P5UT4kOsLQ6bfYaf35mjB1IA+ki3+HxpVB
         hZN2/+aKdz/iN8zaRvoIopxRRplqJ9VISAYn0oqlD5mSSWmVvZyh12aAeWFXS4eT49
         F70lzjLVdvsLe7vBjpUC1YCus4FSkoi0P42bAEFN59KxQjtHqjhEcUFxdJpTnJSQz0
         F5skh3PDiZQhQ74ETQpOpsdN98Dk54EgL9MQAUL0Y95YXaW4cBFrCxBUMiOO3eVxUK
         pL3MD/9f4VA+A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     npiggin@gmail.com, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com
Subject: [PATCH] KVM: PPC: Book3S HV: Fix kvm_unmap_gfn_range_hv() for Hash MMU
Date:   Tue, 11 May 2021 20:54:59 +1000
Message-Id: <20210511105459.800788-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 32b48bf8514c ("KVM: PPC: Book3S HV: Fix conversion to gfn-based
MMU notifier callbacks") fixed kvm_unmap_gfn_range_hv() by adding a for
loop over each gfn in the range.

But for the Hash MMU it repeatedly calls kvm_unmap_rmapp() with the
first gfn of the range, rather than iterating through the range.

This exhibits as strange guest behaviour, sometimes crashing in firmare,
or booting and then guest userspace crashing unexpectedly.

Fix it by passing the iterator, gfn, to kvm_unmap_rmapp().

Fixes: 32b48bf8514c ("KVM: PPC: Book3S HV: Fix conversion to gfn-based MMU notifier callbacks")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

I plan to take this via the powerpc fixes branch.

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 2d9193cd73be..c63e263312a4 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -840,7 +840,7 @@ bool kvm_unmap_gfn_range_hv(struct kvm *kvm, struct kvm_gfn_range *range)
 			kvm_unmap_radix(kvm, range->slot, gfn);
 	} else {
 		for (gfn = range->start; gfn < range->end; gfn++)
-			kvm_unmap_rmapp(kvm, range->slot, range->start);
+			kvm_unmap_rmapp(kvm, range->slot, gfn);
 	}
 
 	return false;
-- 
2.25.1

