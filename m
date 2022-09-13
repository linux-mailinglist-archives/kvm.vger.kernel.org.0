Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F33B5B6B15
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 11:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiIMJpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 05:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbiIMJpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 05:45:06 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0776FD36;
        Tue, 13 Sep 2022 02:45:04 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663062303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z1HCozkzwfIh/WZyb+NtoFOxgqJRCNjqWxITkulBgAA=;
        b=pk7e10ybcoZrRzQTGxR3QDGPtHgnvSHBeBRinW5NVM/ySvbnetK1XSxL9PjQQBkmNm9Lg6
        BdtL3hUprSN3mgtYaGp5HlnrmTPrN96sgeIk4xMCCGZw8OgsRIBb59V/QD6An71MyJfb3e
        CgGNo4E2AaqzCmc8KwjGZGDkogbnYHY=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/7] KVM: arm64: Spin off helper for calling visibility hook
Date:   Tue, 13 Sep 2022 09:44:37 +0000
Message-Id: <20220913094441.3957645-5-oliver.upton@linux.dev>
In-Reply-To: <20220913094441.3957645-1-oliver.upton@linux.dev>
References: <20220913094441.3957645-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index a8c4cc32eb9a..e78b51059622 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -136,22 +136,25 @@ static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
 	__vcpu_sys_reg(vcpu, r->reg) = r->val;
 }
 
-static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
-				 const struct sys_reg_desc *r)
+static inline unsigned int sysreg_visibility(const struct kvm_vcpu *vcpu,
+					     const struct sys_reg_desc *r)
 {
 	if (likely(!r->visibility))
-		return false;
+		return 0;
 
-	return r->visibility(vcpu, r) & REG_HIDDEN;
+	return r->visibility(vcpu, r);
+}
+
+static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
+				 const struct sys_reg_desc *r)
+{
+	return sysreg_visibility(vcpu, r) & REG_HIDDEN;
 }
 
 static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
 					 const struct sys_reg_desc *r)
 {
-	if (likely(!r->visibility))
-		return false;
-
-	return r->visibility(vcpu, r) & REG_RAZ;
+	return sysreg_visibility(vcpu, r) & REG_RAZ;
 }
 
 static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
-- 
2.37.2.789.g6183377224-goog

