Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE97600E3E
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiJQLx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiJQLxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:53:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AAD4F18C
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A2216108F
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F93FC433C1;
        Mon, 17 Oct 2022 11:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007623;
        bh=TlmuoizYiy7ocLRUX9ITRdoDGCG+RyLE/kBvsyVSA4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/YX1u6Evb6DoaMiPuFbzBItnTR1d6+0VWVw7kjpQ3djj1CLRxeg+3t7HtnPnrBG7
         iq49leJqB+ctfPDoqYlFnj6CoIa2wIUNvbOQLDc0us0mUouz7LcXMLGXSs3SINJ5Gz
         AnB2XJI1CHnSxSIF1gPu6YVBldxTNa3XFPygIe/SNFlQSPYGrXxWqTTkRp3tiJLg6n
         xTBK3CKp1h7tMBLlgm3FLCSv7Ajo/eqwzFGctpDIqbnLpNquB8T0yOoe6RxwfAPoCO
         0rpuPVlY1ETIYSs73iqTNTDgpPfbnM5r2QZ4aicP1Frp7Z3CWtJDHwq1XKFGRsBN/H
         WPo1Ws9uz713A==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
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
Subject: [PATCH v4 23/25] KVM: arm64: Explicitly map 'kvm_vgic_global_state' at EL2
Date:   Mon, 17 Oct 2022 12:52:07 +0100
Message-Id: <20221017115209.2099-24-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221017115209.2099-1-will@kernel.org>
References: <20221017115209.2099-1-will@kernel.org>
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

