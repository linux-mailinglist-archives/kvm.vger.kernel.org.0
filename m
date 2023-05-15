Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6689D703A76
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244962AbjEORvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244906AbjEORuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:50:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1011B762
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:48:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE4D962F2A
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F076C4339B;
        Mon, 15 May 2023 17:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684172929;
        bh=zafaV0OKBenajnqzsF2lDJ3WFX+7sWUrcCMh01PwgBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKJP0JwCfeP6j4scAQR0ehgFwbdehy8JhP1QFzymsNMoEaxWRKLBkQHJ0Cf467MaP
         XdaB+/2hnoPe7nEv5FWysVB3ZYakyQSzBlmsoe6/YH+1FzD4i8EDGSKuhaIYcBsoGj
         ShSdcQWl+yuQGCdH4snt3gz4YPaYLFg4y3G/OQjXJP0MJew2kZ5t4xlhMu6JlEyo0u
         EQQ7EqKXZjxPb4U/HZBMV9M3a3DnLfl4iLkvWHdpcI+bOu9V3FnZIfvcolHyTYdgyR
         sNXy5379WxGoJAGoPeJ3SM4qRK1ANaT3chz1m944MSwFsu5pMRgiIeT1bbcfZDSiU3
         AiVGMP4IYGqkw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc3A-00FJAF-Jw;
        Mon, 15 May 2023 18:31:56 +0100
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
Subject: [PATCH v10 54/59] KVM: arm64: nv: Allocate VNCR page when required
Date:   Mon, 15 May 2023 18:30:58 +0100
Message-Id: <20230515173103.1017669-55-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

If running a NV guest on an ARMv8.4-NV capable system, let's
allocate an additional page that will be used by the hypervisor
to fulfill system register accesses.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 10 ++++++++++
 arch/arm64/kvm/reset.c  |  1 +
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f41a86f0e924..bc47c79afad0 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -38,6 +38,14 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
 		return -EINVAL;
 
+	if (cpus_have_final_cap(ARM64_HAS_ENHANCED_NESTED_VIRT)) {
+		if (!vcpu->arch.ctxt.vncr_array)
+			vcpu->arch.ctxt.vncr_array = (u64 *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+
+		if (!vcpu->arch.ctxt.vncr_array)
+			return -ENOMEM;
+	}
+
 	mutex_lock(&kvm->arch.config_lock);
 
 	/*
@@ -67,6 +75,8 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 		    kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2], 0)) {
 			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
 			kvm_free_stage2_pgd(&tmp[num_mmus - 2]);
+			free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
+			vcpu->arch.ctxt.vncr_array = NULL;
 		} else {
 			kvm->arch.nested_mmus_size = num_mmus;
 			ret = 0;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index ad11cc514b3d..d35b6a50a03a 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -161,6 +161,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (sve_state)
 		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
 	kfree(sve_state);
+	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
 	kfree(vcpu->arch.ccsidr);
 }
 
-- 
2.34.1

