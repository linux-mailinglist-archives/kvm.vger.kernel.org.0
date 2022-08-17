Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0A1597940
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 23:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242402AbiHQVtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 17:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242444AbiHQVtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 17:49:21 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F0EADCCE
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:48:48 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660772925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ST+tcxgxp8FxfEEDmZJdp+DE2+spc5GBxl7IShYV3CU=;
        b=tSQQvSdByqKJNawZdlXjY1EtwJEdjcFYJDOknJcCTInIAfDB8ScztHOll6ROOz2L8IjDGr
        MyISuNiJlieDUuleWK7hWbG4X8FRaL3/scCKu5JplTnqWpPlR12oI6LT709QpRIFoutZeq
        BN4sPebFopkdXGgnSbZcmiAme5+ejBo=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, will@kernel.org,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 4/6] KVM: arm64: Add a visibility bit to ignore user writes
Date:   Wed, 17 Aug 2022 21:48:16 +0000
Message-Id: <20220817214818.3243383-5-oliver.upton@linux.dev>
In-Reply-To: <20220817214818.3243383-1-oliver.upton@linux.dev>
References: <20220817214818.3243383-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We're about to ignore writes to AArch32 ID registers on AArch64-only
systems. Add a bit to indicate a register is handled as write ignore
when accessed from userspace.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 3 +++
 arch/arm64/kvm/sys_regs.h | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 26210f3a0b27..9f06c85f26b8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1232,6 +1232,9 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 {
 	bool raz = sysreg_visible_as_raz(vcpu, rd);
 
+	if (sysreg_user_write_ignore(vcpu, rd))
+		return 0;
+
 	/* This is what we mean by invariant: you can't change it. */
 	if (val != read_id_reg(vcpu, rd, raz))
 		return -EINVAL;
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index e78b51059622..e4ebb3a379fd 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -86,6 +86,7 @@ struct sys_reg_desc {
 
 #define REG_HIDDEN		(1 << 0) /* hidden from userspace and guest */
 #define REG_RAZ			(1 << 1) /* RAZ from userspace and guest */
+#define REG_USER_WI		(1 << 2) /* WI from userspace only */
 
 static __printf(2, 3)
 inline void print_sys_reg_msg(const struct sys_reg_params *p,
@@ -157,6 +158,12 @@ static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
 	return sysreg_visibility(vcpu, r) & REG_RAZ;
 }
 
+static inline bool sysreg_user_write_ignore(const struct kvm_vcpu *vcpu,
+					    const struct sys_reg_desc *r)
+{
+	return sysreg_visibility(vcpu, r) & REG_USER_WI;
+}
+
 static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 			      const struct sys_reg_desc *i2)
 {
-- 
2.37.1.595.g718a3a8f04-goog

