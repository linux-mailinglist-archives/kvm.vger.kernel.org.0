Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E1D443D44
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhKCGbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbhKCGbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:31:12 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E441FC061225
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:35 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 3-20020a620403000000b0044dbf310032so873804pfe.0
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Hg/kro78g0TD8dT23Op8aR6UZ26HEbXSuTGyujN0oMQ=;
        b=NWpHbvILfrGgHLj3IALBhGeMx0dFw9T/x+CEZkaF6/ls/KeWRL8OEjI6ueSJgrk37e
         0EpvU7aOphG/YeOsfMrsAYRbk2DKnJkafSm+ba7/IF8sUUVB9OYDIpxXyA2m1hfqcALt
         MixSxIfe2UxmJ5NzHW50IZw/4g8OTtvR7pZOCXmObmcVObu4WU9+i1x5qnqs9lT7aIiH
         /OzbT/sL03brKXDQKwxxGY5LwYJo5c+hdNqnBaEcX+Yx7DDHrMzKWBI0UyDR9KfCO4BK
         mTUDrQWhccBy/jRpf08B3lM6ELMcFMGtlikPwk2hv67YChVhUXhXqdzyW8ies0C424eX
         HWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Hg/kro78g0TD8dT23Op8aR6UZ26HEbXSuTGyujN0oMQ=;
        b=7Vx/LpyGArtKEPccibqX9fZfKrJMnEeYNPzcwRe0kzQe7LsWe9mkvx24MtsfFMdsNZ
         UbgO/vuQbFEGM63XDPw3eyWiSFZti9JqrKbCXttCskd4mkUZCYzN5NOgcguC6ZmWrqfk
         w/4jqSMFn9KCLci8bPimscAuhl4/S9qevF9cOSjw7mc7FjNajE5ACsVrIL5/Px8cLPws
         83F/N0EQ3t0RBlnGw7AtTLOY/zgfNK90Og6wvqAnV5NyLVZYNZBMPMXYKa/2FndC8/ow
         1U+JpY8JsDmljZlOgGDdwfMlux6DVNQxxfrLuaqVhNpHx9Ru+4ACDf3vlzwydGAYY0ha
         SO8Q==
X-Gm-Message-State: AOAM530TkLQljILRYJLYVIdJ47Wy+POkjnPLPDZW+RPtw+ZGiowHJZc+
        aztsv8cVpiHZrQYDLwEU4nBgC0uynpg=
X-Google-Smtp-Source: ABdhPJykbvGDPOO+pKErSwcFqQxn6Duu2EjZ6XP9dA7WAuHgFBYsENxD6RKzhtb+qlAkqPnymOleI2x7vXE=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:8b8b:b0:13d:e91c:a1b9 with SMTP id
 ay11-20020a1709028b8b00b0013de91ca1b9mr36970820plb.60.1635920914546; Tue, 02
 Nov 2021 23:28:34 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:16 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-25-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 24/28] KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
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

Add feature_config_ctrl for PMUv3, PMS and TraceFilt, which are
indicated in ID_AA64DFR0_EL1, to program configuration registers
to trap guest's using those features when they are not exposed to
the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index da6bc87d2d38..67f56ff08e41 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -435,6 +435,38 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
 	.cfg_val = HCR_TID5,
 };
 
+/* For ID_AA64DFR0_EL1 */
+static struct feature_config_ctrl ftr_ctrl_pmuv3 = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_PMUVER_SHIFT,
+	.ftr_min = ID_AA64DFR0_PMUVER_8_0,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_MDCR_EL2,
+	.cfg_mask = MDCR_EL2_TPM,
+	.cfg_val = MDCR_EL2_TPM,
+};
+
+static struct feature_config_ctrl ftr_ctrl_pms = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_PMSVER_SHIFT,
+	.ftr_min = ID_AA64DFR0_PMSVER_8_2,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_MDCR_EL2,
+	.cfg_mask = (MDCR_EL2_TPMS |
+			(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)),
+	.cfg_val = MDCR_EL2_TPMS,
+};
+
+static struct feature_config_ctrl ftr_ctrl_tracefilt = {
+	.ftr_reg = SYS_ID_AA64DFR0_EL1,
+	.ftr_shift = ID_AA64DFR0_TRACE_FILT_SHIFT,
+	.ftr_min = 1,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_MDCR_EL2,
+	.cfg_mask = MDCR_EL2_TTRF,
+	.cfg_val = MDCR_EL2_TTRF,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -928,6 +960,12 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
 	.init = init_id_aa64dfr0_el1_info,
 	.validate = validate_id_aa64dfr0_el1,
 	.get_reset_val = get_reset_id_aa64dfr0_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_pmuv3,
+		&ftr_ctrl_pms,
+		&ftr_ctrl_tracefilt,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_dfr0_el1_info = {
-- 
2.33.1.1089.g2158813163f-goog

