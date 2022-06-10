Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7C8546296
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 11:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347710AbiFJJfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 05:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347981AbiFJJfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 05:35:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE15A215
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 02:35:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98C35B82CFB
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 09:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60996C34114;
        Fri, 10 Jun 2022 09:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654853737;
        bh=UWqmfJ/Rf0ncHATIJtPlqt9EtH/WUDpFfEL5zZJ0POM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDQU8ZH4C54TrEq7hrjSR33rA1R6JJVn5oeeYRt4rc5fGzv4jwDzpDkyDFrAEUwiA
         kDwHpewK1tOckCRSgfNb208QtawUXE3GzFWfBNfkqVbapnkL4hq2zgPE8sp0pAfpYG
         Dom2KrWpuL60qAS9Qo4ulflLWRB97X2uWOUdruDeMtXwnkqf3jWk5nPmbcRlT/FUwc
         cS8D26f4iZjJeWs3GBZQkKYVa03JIVrWT59kujn0Yw4dQKt53Ok82X5ivoQdtAT3TV
         0LTABEvXuq/YERyhmVnlgRNl+WVsFkr5+b6EBr0y7JYVj0JVmWqlrzQWGgFiSY7WNh
         y0p3fRz8uUMXw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nzawr-00H6Dt-Ex; Fri, 10 Jun 2022 10:28:57 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>,
        Reiji Watanabe <reijiw@google.com>, kernel-team@android.com
Subject: [PATCH v2 15/19] KVM: arm64: Warn when PENDING_EXCEPTION and INCREMENT_PC are set together
Date:   Fri, 10 Jun 2022 10:28:34 +0100
Message-Id: <20220610092838.1205755-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, reijiw@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We really don't want PENDING_EXCEPTION and INCREMENT_PC to ever be
set at the same time, as they are mutually exclusive. Add checks
that will generate a warning should this ever happen.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 6ec58080ece8..9bdba47f7e14 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -473,11 +473,13 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 
 static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 {
+	WARN_ON(vcpu_get_flag(vcpu, PENDING_EXCEPTION));
 	vcpu_set_flag(vcpu, INCREMENT_PC);
 }
 
 #define kvm_pend_exception(v, e)					\
 	do {								\
+		WARN_ON(vcpu_get_flag((v), INCREMENT_PC));		\
 		vcpu_set_flag((v), PENDING_EXCEPTION);			\
 		vcpu_set_flag((v), e);					\
 	} while (0)
-- 
2.34.1

