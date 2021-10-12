Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0158429CAB
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbhJLEjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbhJLEjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:39:00 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283BBC06177B
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:52 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id oo5-20020a17090b1c8500b0019e585e8f6fso876167pjb.9
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=X2MC5tS4urnyh50skPCY/9xIv7Rg4adWM6caa08DYXc=;
        b=inNCt9FpIq76B+VhKdpWkwhHuSBX1gL+4xixhQW+svRbgV2n+ibgsdFUCNmdtoMru2
         /it/NY6mdNUiEezsHyd52DTIcssGR44sV17vmvs3biSKEQaMcDmePmVdCsE7EOOmmICQ
         g3K5iFvnZOU1DXcSFi3420WslBqkRO1yBTilD2CQLSFmjVj/FnILkKaZBBVq8qOJOqwI
         w07qZGVrqOdO8jQH5FI+AHLzxUDDqdXxSOg6Ln7nkNxoSl1AUhvikgKBoaHiZKe2hZ0S
         cVlQJHpaMstreT9JmVbLDZ2PiW3p0ajTViN3Kr0rA8/MLsVEqSUGf+/i2fAnNshMHjyF
         hXmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X2MC5tS4urnyh50skPCY/9xIv7Rg4adWM6caa08DYXc=;
        b=K0dGXOAJLCbHMUu5vFnGPPKzxg9fBLpN4hMpClkthfNjFWJSjU/SrfgPGwIkSKYTyD
         Jap1iUyEpDGbcztm9IFEp63Q3hzaKb4GmGBSgr3T5n7LFd6xI4Tzswx/9rLQerKXOaIa
         IOosF7hPymQ/RhMhG6MBiMx96/+49q5x3yhbJFkb/KA9WYtc0CDzJnHOaWBmlV2g9FP/
         fURmmkmAnVfGIZjGaL06hC0ZMTNMibZi0qGOu4b3mdb/h1gWOrcQAHMzqS7p1dvQ/cV4
         RGyaIlKr6pevoWs3pRnniEFpnlINmOxdBLhOkWgqk3ETPeZ6tCYQA1LzUf2I07S7HRAj
         PkVw==
X-Gm-Message-State: AOAM533OpKhQWOm8TUEnS/WFdWzv4GRXvgKSfC9BhOoDOMt/7m3ya2aT
        qq96B0nHXq0keOvCbSN37ibXH/7hcyw=
X-Google-Smtp-Source: ABdhPJyXRkRDYHX+V64uORGsvksZYYcAzeDYpRvgXni5jgbKqEJlLN+vJO2JfCbxPWmEGCNi7HHH8xh+o+g=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:aa7:81c7:0:b0:44c:517f:a759 with SMTP id
 c7-20020aa781c7000000b0044c517fa759mr29319641pfn.3.1634013411673; Mon, 11 Oct
 2021 21:36:51 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:31 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-22-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 21/25] KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
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
index 595ab1c79bae..23a3bcac4986 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -342,6 +342,38 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
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
@@ -727,6 +759,12 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
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
2.33.0.882.g93a45727a2-goog

