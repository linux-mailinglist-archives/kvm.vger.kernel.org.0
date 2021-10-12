Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65015429C97
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhJLEio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbhJLEij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F10BC06174E
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j193-20020a2523ca000000b005b789d71d9aso25783060ybj.21
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FDFGhMdlG5o/vMsnwPNFr7Rd2snS1UKSEvF8GgeeBk0=;
        b=bFgp4asOyTe5ohqjZrdTrsCRaXrQKZImQiXs0iv6ieHHCXWjcZ4+e/dCT7hgcdYpAY
         mJE0cltfIC6m0zQpTRr07A4H7BDFqur03nuvRSNTON1uQT+SwxsBf5+AbbbCmULIZWQZ
         KyifZ2mptugqxzta6k+xpDUxVoiM8/hCsH6nGtttUNM+3YUcCxIcTbmhKdG4/2uGy9lE
         TzJy4XfdtsrFDat2QKaUjSnomRyAfmnfZLG0nh/PY5Bco9jYqR1fjRE9lvNIKHzqsHpi
         ezKsGvVQK+Ae7dyB0wtV4rmnXsUYPFiGpFEZpDkaNlgen+ezu2eUbx86PQ4frv7cUAFx
         AZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FDFGhMdlG5o/vMsnwPNFr7Rd2snS1UKSEvF8GgeeBk0=;
        b=AFkOVFoOM/BYOzz/pOy4zrhBSw6TlpY++MA+/akjfEmpI1GMh9yvstFwNeAk042TjD
         6PI0Cvh4xmaeqZuWV2uLjQCOzmEw5gNp+gFhtfbhWDu7F+XgpbmXaFYv2x12Jn0pwl0/
         7pIv2+qs1bu/2iz9i05SWj4sQvIRMxHt7DMwOMsxuxo0acq7KcDbWy89iPyZzRibPD34
         As4CCwi7FAozGKJJQlU7afaNDWnu4fZSyflNh1oZiWieIEM/88TreljeDKkmCr4BL/f+
         pfhZsvfDRzR2oa/bbMqiM35W8on3Do+VhQTzm31uIOqDslATKBomjOfHyrhDvxH+ch9i
         RKwA==
X-Gm-Message-State: AOAM532q7SeTly2g4J+9AN0WODu6qfuXPSZP2b0ByiRffiw1QxCrtf0d
        XAoxV7s1hilP4y8Ld/yPOMUYbLIKEQc=
X-Google-Smtp-Source: ABdhPJy/Am31eNzPPFxM2MuSeuH8s6JV4pcMog7TA73zjPoDJL1Y4brQNrPfvNSY+xWqEWvRHGSmE/XmAVI=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a25:54c5:: with SMTP id i188mr26034197ybb.43.1634013397423;
 Mon, 11 Oct 2021 21:36:37 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:22 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-13-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 12/25] KVM: arm64: Make MVFR1_EL1 writable
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds id_reg_info for MVFR1_EL1 to make it writable
by userspace.

There are only a few valid combinations of values that can be set
for FPHP and SIMDHP fields according to Arm ARM.  Return an error
when userspace tries to set those fields to values that don't match
any of the valid combinations.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 84c064dfc63a..71cfd62f9c85 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -461,6 +461,35 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu, u64 val)
 	return 0;
 }
 
+static int validate_mvfr1_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	unsigned int fphp, simdhp;
+	struct fphp_simdhp {
+		unsigned int fphp;
+		unsigned int simdhp;
+	};
+	/* Permitted fphp/simdhp value combinations according to Arm ARM */
+	struct fphp_simdhp valid_fphp_simdhp[3] = {{0, 0}, {2, 1}, {3, 2}};
+	int i;
+	bool is_valid_fphp_simdhp = false;
+
+	fphp = cpuid_feature_extract_unsigned_field(val, MVFR1_FPHP_SHIFT);
+	simdhp = cpuid_feature_extract_unsigned_field(val, MVFR1_SIMDHP_SHIFT);
+
+	for (i = 0; i < ARRAY_SIZE(valid_fphp_simdhp); i++) {
+		if (valid_fphp_simdhp[i].fphp == fphp &&
+		    valid_fphp_simdhp[i].simdhp == simdhp) {
+			is_valid_fphp_simdhp = true;
+			break;
+		}
+	}
+
+	if (!is_valid_fphp_simdhp)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit;
@@ -637,6 +666,11 @@ static struct id_reg_info id_dfr0_el1_info = {
 	.get_reset_val = get_reset_id_dfr0_el1,
 };
 
+static struct id_reg_info mvfr1_el1_info = {
+	.sys_reg = SYS_MVFR1_EL1,
+	.validate = validate_mvfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -647,6 +681,7 @@ static struct id_reg_info id_dfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_MVFR1_EL1)] = &mvfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
-- 
2.33.0.882.g93a45727a2-goog

