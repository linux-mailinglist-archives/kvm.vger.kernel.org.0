Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C1C7128E3
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 16:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243573AbjEZOr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 10:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237462AbjEZOr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 10:47:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB80E10D9
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 07:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8430F615D1
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 14:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EFBC433D2;
        Fri, 26 May 2023 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685112409;
        bh=gX1HEG+z9KW3eMtUvCzJlWpVp+Aform3r5YduMPqVos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofsW8JVOTHJSD7OCUF4Swuj9FRlkinEIJ+gqQ5CWgJAG4CwBVcnnEp6B4AQfsqYEu
         YEVC+18Zr//6R8aaMN/NsojaGFz650zEI0Wn+pFJ1O/2wjG3tXqhlK4vI0ok0IMiev
         GdvnV93rRCmwRZB9eXdWcd+9xtiY5Hg2wsgeXLS9/Wg7rt47eEL0Y6ZCCRcVTDvJCN
         xBY/PKtgPSLKF9GRLnIVFyNXjhdQhcAD4MutgwNtF697DV1fpLxWz51zQFsKClapZ2
         ZM6wcIhfChWJI3y+PDYhgUU1MHTTSsX0DfvOt4k6t5rQOJ9ShGkwhj411PY3vsQnrQ
         FQx/JkXp+9ffw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q2YVt-000aHS-QU;
        Fri, 26 May 2023 15:33:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 10/17] KVM: arm64: Force HCR_EL2.E2H when ARM64_KVM_HVHE is set
Date:   Fri, 26 May 2023 15:33:41 +0100
Message-Id: <20230526143348.4072074-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230526143348.4072074-1-maz@kernel.org>
References: <20230526143348.4072074-1-maz@kernel.org>
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

Obviously, in order to be able to use VHE whilst at EL2, we need
to set HCR_EL2.E2H. Do so when ARM64_KVM_HVHE is set.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14391826241c..c12276dd2cf4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1676,6 +1676,8 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
 	else
 		params->hcr_el2 = HCR_HOST_NVHE_FLAGS;
+	if (cpus_have_final_cap(ARM64_KVM_HVHE))
+		params->hcr_el2 |= HCR_E2H;
 	params->vttbr = params->vtcr = 0;
 
 	/*
-- 
2.34.1

