Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C797128E5
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 16:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243787AbjEZOsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 10:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243829AbjEZOsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 10:48:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAEC10C8
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 07:47:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6509961038
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 14:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4CBC433D2;
        Fri, 26 May 2023 14:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685112411;
        bh=GV2OlEBM0jd+RwK4yjooVI5TfGUg81MrP522jOEKVMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdiFf1TZzQXsm6cnv4aYxrK5OAVRAwuugwvFof5Vhy4ZOk4iMJdhPCkorB6/X/5AR
         E8CWZF2R5IwX45JV0YM9VaKnnUjC01Hi/9UUcbEkUsSeak+lBSoT5YIvftkWyO87kb
         GpNpSUIvA7+PAMUX/HRvPvhiYFYJgZKp6eu8InsHI0edkXhEd06P2+kOcBP8OJqdpb
         6VA46f3hBoZfWrznAC3+d4sRg07MPmNr5yj0DnPvVbmdegfH1p4ss50Ac4vHc8fw88
         LN/EdUi/oEVG8tVbC9CXNggSUFoivi0Yt2pw1/THe9aBenjQte/pxOwdENQCQnnlUo
         OqCRI0JC/6dSQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q2YVu-000aHS-B9;
        Fri, 26 May 2023 15:33:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 12/17] KVM: arm64: Adjust EL2 stage-1 leaf AP bits when ARM64_KVM_HVHE is set
Date:   Fri, 26 May 2023 15:33:43 +0100
Message-Id: <20230526143348.4072074-13-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230526143348.4072074-1-maz@kernel.org>
References: <20230526143348.4072074-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 3d61bd3e591d..3664cd64227b 100644
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

