Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A6479774B
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241382AbjIGQYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243949AbjIGQXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:23:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701EA2D79
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 09:10:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A9CC43215;
        Thu,  7 Sep 2023 10:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694081396;
        bh=QwiP3p+wUV3zgflX1WtWNo6n2tiC/U8l1eWmNPtnCQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDWWmkNzJCEgNqx0qxPt78Xpco1bO/qYvmddsuz/a1sDEQcO2fc1Cm7QjapzZR3Vw
         nr3UMzsqN41BiVRn3vbyCNDYR1mmgBI0w2ZeDuiBEXeRPuQyyJ/Yf9HfXKJf3DVnSW
         u+vZVyoulahiC1crz8I77BHOz0O2WBc0gbeG7kI2nnOU1mCZ2KOr27XKaTjkEdX5Qk
         ihtXc+/6gWTlkbIPaYLvClgO9uf37IR3Rs299HZmqK/thd4pe+Bcrmh4qJPVqhCh9X
         l16nWxRfJHk0TbrXz4HyqUCqI9u643eEJztqLJ0X2bJWlzC992RhxbYVpADfcQRQOd
         ORQh98eiLsdhw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qeBxR-00B37Y-KB;
        Thu, 07 Sep 2023 11:09:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>
Subject: [PATCH 1/5] KVM: arm64: Simplify kvm_vcpu_get_mpidr_aff()
Date:   Thu,  7 Sep 2023 11:09:27 +0100
Message-Id: <20230907100931.1186690-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230907100931.1186690-1-maz@kernel.org>
References: <20230907100931.1186690-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, zhaoxu.35@bytedance.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By definition, MPIDR_EL1 cannot be modified by the guest. This
means it is pointless to check whether this is loaded on the CPU.

Simplify the kvm_vcpu_get_mpidr_aff() helper to directly access
the in-memory value.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3d6725ff0bf6..b66ef77cf49e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -465,7 +465,7 @@ static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 
 static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 {
-	return vcpu_read_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
+	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
 }
 
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
-- 
2.34.1

