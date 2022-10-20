Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7D16061F5
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 15:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJTNk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 09:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiJTNkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 09:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BEC5A3E5
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 06:40:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D98BEB826A2
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5978BC433D6;
        Thu, 20 Oct 2022 13:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666273202;
        bh=TlmuoizYiy7ocLRUX9ITRdoDGCG+RyLE/kBvsyVSA4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aa/5NEzMxgzRNWleNJNolE1U55vS35EzGe9SwJ6FNEF4MPkp3vmDTnetSeop+T74y
         vk2QDFiRb/NYbcjTTDoezEmwgG2A1B1bUr3K5jh2lvo7CpmkGEsEIjzICrpcCdaNco
         uVZUfjr1mJ1BO9Mq/3SlsOfajSYwTSGIhd9T47VERTUv6pEJeQ9koLNcsO5j1jXtU2
         TDOQnyBTm1eirC4Pmb6Ely3BK4IPsHlPmMspTsU/6+d8iLisz56ZFmbsyPz7kajsVC
         Ihfl8BKBuBlbQA/Mdgq3YVZpdCtmDBWY7SkT2gbHZiWW4q8f953QDrW1N83Ays+S2B
         KTANdPphuHT1A==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 23/25] KVM: arm64: Explicitly map 'kvm_vgic_global_state' at EL2
Date:   Thu, 20 Oct 2022 14:38:25 +0100
Message-Id: <20221020133827.5541-24-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221020133827.5541-1-will@kernel.org>
References: <20221020133827.5541-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

The pkvm hypervisor at EL2 may need to read the 'kvm_vgic_global_state'
variable from the host, for example when saving and restoring the state
of the virtual GIC.

Explicitly map 'kvm_vgic_global_state' in the stage-1 page-table of the
pKVM hypervisor rather than relying on mapping all of the host '.rodata'
section.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 0f69c1393416..5a371ab236db 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -161,6 +161,11 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	if (ret)
 		return ret;
 
+	ret = pkvm_create_mappings(&kvm_vgic_global_state,
+				   &kvm_vgic_global_state + 1, prot);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.38.0.413.g74048e4d9e-goog

