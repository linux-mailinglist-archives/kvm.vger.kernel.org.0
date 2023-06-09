Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E87472A089
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 18:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjFIQrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 12:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjFIQrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 12:47:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709D53A9B
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 09:47:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE9CD65A0D
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 16:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BA2C4339B;
        Fri,  9 Jun 2023 16:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686329229;
        bh=pIsFPoCBZ48P727b1+I4FozFVGrWdz7nAwou3bvDdps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0LlD0EVonaKSbCEb1epGg/85UFd6dLc42UIkCBu23lDCAyJq0bfdlYC/pPhT9Ulp
         dC1blpGSnFYzLKPGYglJMGFfgLBOMpOl3hTpoGIgojXIfs+RKRVEuT9+O5RI9O9Rko
         /Zjrw5Id0XPmdiMuoH/5pnpLEN2gk6yQgTHv+YMgB13N58b7NTi6I4khvscsfK7MFA
         76dP8u0sqdTMDE/6R26jUpEVrd20dGUYcs9qWl40XdO6moxBjycCEluG0UI7aPmBcZ
         p3KKOz7iex97fyM+Ax1dIGgc7OAftKmHhnvqu3pZ5Bo2bXRPc+b59Vpc8AhVZoH9yq
         ywzO/0NkcVFIQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q7esM-0048L7-VP;
        Fri, 09 Jun 2023 17:22:11 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 12/17] KVM: arm64: Adjust EL2 stage-1 leaf AP bits when ARM64_KVM_HVHE is set
Date:   Fri,  9 Jun 2023 17:21:55 +0100
Message-Id: <20230609162200.2024064-13-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609162200.2024064-1-maz@kernel.org>
References: <20230609162200.2024064-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

El2 stage-1 page-table format is subtly (and annoyingly) different
when HCR_EL2.E2H is set.

Take the ARM64_KVM_HVHE configuration into account when setting
the AP bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 95dae02ccc2e..b5edd27c7f97 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -21,8 +21,10 @@
 
 #define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX	GENMASK(4, 2)
 #define KVM_PTE_LEAF_ATTR_LO_S1_AP	GENMASK(7, 6)
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO	3
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW	1
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO		\
+	({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 2 : 3; })
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW		\
+	({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 0 : 1; })
 #define KVM_PTE_LEAF_ATTR_LO_S1_SH	GENMASK(9, 8)
 #define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS	3
 #define KVM_PTE_LEAF_ATTR_LO_S1_AF	BIT(10)
-- 
2.34.1

