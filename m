Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353653E0FBD
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 09:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhHEH5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 03:57:11 -0400
Received: from ozlabs.ru ([107.174.27.60]:52806 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhHEH5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 03:57:11 -0400
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 2D117AE80046;
        Thu,  5 Aug 2021 03:56:53 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org
Subject: [PATCH kernel v2] KVM: PPC: Use arch_get_random_seed_long instead of powernv variant
Date:   Thu,  5 Aug 2021 17:56:49 +1000
Message-Id: <20210805075649.2086567-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The powernv_get_random_long() does not work in nested KVM (which is
pseries) and produces a crash when accessing in_be64(rng->regs) in
powernv_get_random_long().

This replaces powernv_get_random_long with the ppc_md machine hook
wrapper.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

Changes:
v2:
* replaces [PATCH kernel] powerpc/powernv: Check if powernv_rng is initialized

---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index be0cde26f156..ecfd133e0ca8 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1165,7 +1165,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 		break;
 #endif
 	case H_RANDOM:
-		if (!powernv_get_random_long(&vcpu->arch.regs.gpr[4]))
+		if (!arch_get_random_seed_long(&vcpu->arch.regs.gpr[4]))
 			ret = H_HARDWARE;
 		break;
 	case H_RPT_INVALIDATE:
-- 
2.30.2

