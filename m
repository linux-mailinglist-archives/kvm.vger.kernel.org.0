Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8397E5B8320
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 10:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiINIg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 04:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiINIgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 04:36:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DCD5F7E2
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 01:36:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBEFBB81689
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 08:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C97C433D7;
        Wed, 14 Sep 2022 08:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663144590;
        bh=nabgJXIV5TCp67knXjzIafDEUmrxwmyp5lgXbjeYsoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwGpsQIvXIaeqxGaEkCBcSLb4v5uClChYPe4/xrdni5T7IvhEWhFIsJGg2uWI9EY3
         Dl8olJqZj8iNC4C4y8k0mCdn61+zqZnf2/SweHQTYieLDhWhR3U1wHHqU5FaG7whpP
         gG2jgoJ/RJv/qrnU0c7n6XkV/wamvKHDLIZdw1N+yBogyDcIO3vW+8xp+XVqi3ggPa
         1/FXgsXlLURhZgrIFMVEGMJkWLj89JwuNd7FvfTYLXXkZUR6mdcmRInbi5IUViLZuZ
         BVNBrY0S13M7AtNf8xqpMbWiIJuXF07OOf5FPIljurWSGQ6rsMMFP6NiGD3mexmhZe
         Ez5UsxTUafc4w==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 23/25] KVM: arm64: Explicitly map 'kvm_vgic_global_state' at EL2
Date:   Wed, 14 Sep 2022 09:34:58 +0100
Message-Id: <20220914083500.5118-24-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
2.37.2.789.g6183377224-goog

