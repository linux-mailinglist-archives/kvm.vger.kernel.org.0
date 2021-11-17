Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775D445416D
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhKQG4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhKQG4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:44 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8486BC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:45 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id r23-20020a17090a941700b001a74be6cf80so773368pjo.2
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RcpZ70HWqU0SXh1JgWU046j8p1JVlfrsxLvOnh+ny5w=;
        b=LbXvb9O/MjigBpj3Q1x1la7lfju5hUWJ9TCDDM/Td5aHN+uf0MArRvDL6IXDAGsAYO
         1qkC7lXJQbWXm6LWhlCZdiuD7RJJBvl8caI2psMUC1eT7mAMEjHA2BHA8Canef5mwt+s
         AHPDTPURjEgHiRebfgGqDADsiynKYh/zcoZ8u2PAU+3i4Cyo9u7uBIvvkDK8+wV7KfOg
         AOjPWj7Iru5eyBljExW4+88J3f/eMpEMCsWsTXdRmMTBeSdj9C2rZkCK2INb3GMbqBjB
         UOJvRCAGgqj3yTfI0jOwqB/5K58OA7pNhcqCuiwr4meSLJsuXv1vC+HzzVW8cXmmJGgD
         +AQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RcpZ70HWqU0SXh1JgWU046j8p1JVlfrsxLvOnh+ny5w=;
        b=IQ6gFjWUCUavIgMGNgkkLdrxsNRTHiumhnAPck4MrDYuzu1e+moByLqTMR2kXy8L8O
         JBJrklYY97PPa/oK9zOxvaUi7jGjxu4hIj/Kb2ku7BEwJobsyXyoVq0aGjbt+Og/lxwu
         7Km1ufFux6rSNIfO5Vf3CJvpBA5hIq3ibMmra+a0mBQ8Wk9o9NbXaTZxS65gwdI2f2Ae
         Q5uvvy/jKyW0A+OofyWmnu5zBA61uaynzL/IE1ss+D7xq67l8jWrkBSHYEqGoXj+Q04Q
         3Ti3rvSoCucJjd0vv3iG6YMX7EO9MZVf0zKQX3YtFWJ2CnLAwi3lBy42U7eV5xt50Rds
         6slA==
X-Gm-Message-State: AOAM532GPAK18/mBhCEjq7vWMXuSIZpzInwUfCjemfl/jeeqzJA0eBbE
        nT8+z+YK/pT8lryQmUXxobIV0GjqpqM=
X-Google-Smtp-Source: ABdhPJw5QD14fDi96csV3HLcCihYEQmTicWAkaNNtkp4LgwsRxcvxf5w6HB4o8EsJXz+BBU2q7qWUTFRJGg=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr314255pjf.1.1637132024716; Tue, 16 Nov 2021 22:53:44 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:53 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-24-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 23/29] KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
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

Add feature_config_ctrl for MTE, which is indicated in
ID_AA64PFR1_EL1, to program configuration register to trap the
guest's using the feature when it is not exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 42db8cf18fbb..73d992ba6e90 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -426,6 +426,17 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
 	.cfg_val = CPTR_EL2_TAM,
 };
 
+/* For ID_AA64PFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_mte = {
+	.ftr_reg = SYS_ID_AA64PFR1_EL1,
+	.ftr_shift = ID_AA64PFR1_MTE_SHIFT,
+	.ftr_min = ID_AA64PFR1_MTE_EL0,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_HCR_EL2,
+	.cfg_mask = (HCR_TID5 | HCR_DCT | HCR_ATA),
+	.cfg_val = HCR_TID5,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -904,6 +915,10 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.get_reset_val = get_reset_id_aa64pfr1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_mte,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64isar0_el1_info = {
-- 
2.34.0.rc1.387.gb447b232ab-goog

