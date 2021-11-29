Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9B84624A2
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbhK2WXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhK2WVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:21:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B4FC08EAE5
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:02:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B935CB815D7
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B93C53FD2;
        Mon, 29 Nov 2021 20:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216132;
        bh=r1KVpSR7EgIPE8I4/GpAKDCPw+V3aHcPhm5guWg0kK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLEypiGX/Kz7h6mdeCJwpUhz3LiCZn0KCrGZ3Fpyr5abbPxTc2I8Pf4KvWMXQJWCw
         OXxCmvjqPrli5MqoRrySZ1QypS3IXkjIs6ztJzUQ3mNES7SAPaFhRE1Z/AOxNPf41X
         /fgnIDRmYqDs4P5N8eow/MN7uxtwRjXLZ0wKQ6J9ZumwVzNhLOWxHiTMTpt4LnGUk0
         /GRnEzmsZuZdvJgFMXLZQ9i3p8l1t4qXwt+DeZjICcLEdveIOARaro9XT35uaZ0qM2
         McAWtybaxeqOaid4Qi2BfLFDMa5qV1Hq78ygJ4BAx81MaefY+cJhlcdggKTrEgOOyy
         VDgT3pL391XdQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqo-008gvR-NI; Mon, 29 Nov 2021 20:02:10 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 05/69] KVM: arm64: Allow preservation of the S2 SW bits
Date:   Mon, 29 Nov 2021 20:00:46 +0000
Message-Id: <20211129200150.351436-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The S2 page table code has a limited use the SW bits, but we are about
to need them to encode some guest Stage-2 information (its mapping size
in the form of the TTL encoding).

Propagate the SW bits specified by the caller, and store them into
the corresponding entry.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 8cdbc43fa651..d69e400b2de6 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1064,9 +1064,6 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	u32 level;
 	kvm_pte_t set = 0, clr = 0;
 
-	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
-		return -EINVAL;
-
 	if (prot & KVM_PGTABLE_PROT_R)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
 
@@ -1076,6 +1073,10 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_X)
 		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
+	/* Always propagate the SW bits */
+	clr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_SW, 0xf);
+	set |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
+
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level);
 	if (!ret)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
-- 
2.30.2

