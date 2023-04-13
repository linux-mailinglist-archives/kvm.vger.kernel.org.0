Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCCDA6E08B6
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 10:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjDMIO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 04:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjDMIOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 04:14:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A6E768D
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 01:14:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B231634CC
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 08:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E049FC433A7;
        Thu, 13 Apr 2023 08:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681373690;
        bh=rwmmXpw7HzvlcwZFWNqSFO/o0tH4qlAkLiVY1MwzDMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hM+Rhk0Zau1RZ9pXacqypToa2pX0j8u9m7YuXb5ACT3nw7Xz5SSVPBeJBK4fZS7f0
         ymL26T8VT37UX/zNl8x5NE8VY89v2OcF/mHpMb2LubGg4cwyIY6y6QQFVRi+3g+uo+
         EC2SIknQ+tK3dvdqbU/gh4qu5xlQ50Dwwc+tznCvDOttJUcFgtTq5Ece/dm0ZbNdJF
         9rl9/BnVdsy2jkA6VxIiQCSeVhsnbj7nm28SR8ovxyPhc/b5MCaN4d9vLzJEBrtioF
         vmbR9JlIeqsSmabWT74tNZME7MtjSozG2SvGewqsikuTHeiw7bIXMj+0BveAiRyTFI
         PCtlm08PxuTMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pms6S-0082qd-TM;
        Thu, 13 Apr 2023 09:14:48 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Ricardo Koller <ricarkol@google.com>
Subject: [PATCH v3 3/5] KVM: arm64: pkvm: Document the side effects of kvm_flush_dcache_to_poc()
Date:   Thu, 13 Apr 2023 09:14:39 +0100
Message-Id: <20230413081441.165134-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230413081441.165134-1-maz@kernel.org>
References: <20230413081441.165134-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We rely on the presence of a DSB at the end of kvm_flush_dcache_to_poc()
that, on top of ensuring completion of the cache clean, also covers
the speculative page table walk started from EL1.

Document this dependency.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 552653fa18be..2e9ec4a2a4a3 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -297,6 +297,13 @@ int __pkvm_prot_finalize(void)
 	params->vttbr = kvm_get_vttbr(mmu);
 	params->vtcr = host_mmu.arch.vtcr;
 	params->hcr_el2 |= HCR_VM;
+
+	/*
+	 * The CMO below not only cleans the updated params to the
+	 * PoC, but also provides the DSB that ensures ongoing
+	 * page-table walks that have started before we trapped to EL2
+	 * have completed.
+	 */
 	kvm_flush_dcache_to_poc(params, sizeof(*params));
 
 	write_sysreg(params->hcr_el2, hcr_el2);
-- 
2.34.1

