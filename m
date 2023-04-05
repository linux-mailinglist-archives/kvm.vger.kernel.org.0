Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137A06D825F
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbjDEPqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239072AbjDEPq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:46:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1049A7287
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:46:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5362463F02
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7727C4339B;
        Wed,  5 Apr 2023 15:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680709571;
        bh=5FKZeF4bcHwk1v+ELgygebiurlG0HlkfqX7UD+u6FrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBW7dABKyloKObDla8SIZglPwDt2of9gvt0WxHKYZdVcnLzLMp3Xj+wMR/fxDbjrn
         icg6cABJEWfJ6PY19wWhPOrHDrscWeTlXe8IRsquAaEGCNvAUzjt7Zfjpw0NsHaskk
         QraW35EHoU1YfhuOzlU570TLdPizUAHjEJcWci4trgUPfDFZAVkXk86B1HbHgw9jth
         ckut0WJErX9DuwGPNYnKOqn8qdF23OW/XZgQ9LuaLrtclYT6BvsgOO05S7om8jqrmq
         vmLuqs4jObOo1ihlFTwPJ9iAHD2YqfwOuMfLPVpDtt2lZbGtGmgmeP98sCj6ctenrC
         yKSfLc98y7UWQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pk5Fd-0062PV-I7;
        Wed, 05 Apr 2023 16:40:46 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v9 36/50] KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like information
Date:   Wed,  5 Apr 2023 16:39:54 +0100
Message-Id: <20230405154008.3552854-37-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230405154008.3552854-1-maz@kernel.org>
References: <20230405154008.3552854-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to be able to make S2 TLB invalidations more performant on NV,
let's use a scheme derived from the ARMv8.4 TTL extension.

If bits [56:55] in the descriptor are non-zero, they indicate a level
which can be used as an invalidation range.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  2 +
 arch/arm64/kvm/nested.c             | 81 +++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 9e5ffb68a5cd..52d0a6c0fecc 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -137,4 +137,6 @@ struct sys_reg_desc;
 void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
 			  const struct sys_reg_desc *r);
 
+#define KVM_NV_GUEST_MAP_SZ	(KVM_PGTABLE_PROT_SW1 | KVM_PGTABLE_PROT_SW0)
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index b46d58d4542c..0f535a5ff941 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -4,6 +4,7 @@
  * Author: Jintack Lim <jintack.lim@linaro.org>
  */
 
+#include <linux/bitfield.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
@@ -413,6 +414,81 @@ static unsigned int ttl_to_size(u8 ttl)
 	return max_size;
 }
 
+/*
+ * Compute the equivalent of the TTL field by parsing the shadow PT.  The
+ * granule size is extracted from the cached VTCR_EL2.TG0 while the level is
+ * retrieved from first entry carrying the level as a tag.
+ */
+static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
+{
+	u64 tmp, sz = 0, vtcr = mmu->vtcr;
+	kvm_pte_t pte;
+	u8 ttl, level;
+
+	switch (vtcr & VTCR_EL2_TG0_MASK) {
+	case VTCR_EL2_TG0_4K:
+		ttl = (1 << 2);
+		break;
+	case VTCR_EL2_TG0_16K:
+		ttl = (2 << 2);
+		break;
+	case VTCR_EL2_TG0_64K:
+		ttl = (3 << 2);
+		break;
+	default:
+		BUG();
+	}
+
+	tmp = addr;
+
+again:
+	/* Iteratively compute the block sizes for a particular granule size */
+	switch (vtcr & VTCR_EL2_TG0_MASK) {
+	case VTCR_EL2_TG0_4K:
+		if	(sz < SZ_4K)	sz = SZ_4K;
+		else if (sz < SZ_2M)	sz = SZ_2M;
+		else if (sz < SZ_1G)	sz = SZ_1G;
+		else			sz = 0;
+		break;
+	case VTCR_EL2_TG0_16K:
+		if	(sz < SZ_16K)	sz = SZ_16K;
+		else if (sz < SZ_32M)	sz = SZ_32M;
+		else			sz = 0;
+		break;
+	case VTCR_EL2_TG0_64K:
+		if	(sz < SZ_64K)	sz = SZ_64K;
+		else if (sz < SZ_512M)	sz = SZ_512M;
+		else			sz = 0;
+		break;
+	default:
+		BUG();
+	}
+
+	if (sz == 0)
+		return 0;
+
+	tmp &= ~(sz - 1);
+	if (kvm_pgtable_get_leaf(mmu->pgt, tmp, &pte, NULL))
+		goto again;
+	if (!(pte & PTE_VALID))
+		goto again;
+	level = FIELD_GET(KVM_NV_GUEST_MAP_SZ, pte);
+	if (!level)
+		goto again;
+
+	ttl |= level;
+
+	/*
+	 * We now have found some level information in the shadow S2. Check
+	 * that the resulting range is actually including the original IPA.
+	 */
+	sz = ttl_to_size(ttl);
+	if (addr < (tmp + sz))
+		return ttl;
+
+	return 0;
+}
+
 unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
 {
 	unsigned long max_size;
@@ -420,6 +496,11 @@ unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
 
 	ttl = FIELD_GET(GENMASK_ULL(47, 44), val);
 
+	if (!(cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) && ttl)) {
+		u64 addr = (val & GENMASK_ULL(35, 0)) << 12;
+		ttl = get_guest_mapping_ttl(mmu, addr);
+	}
+
 	max_size = ttl_to_size(ttl);
 
 	if (!max_size) {
-- 
2.34.1

