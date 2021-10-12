Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE30429CAA
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhJLEjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbhJLEi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACA3C061778
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i83-20020a256d56000000b005b706d1417bso25890512ybc.6
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=coUrbvM5Lflty8spiztbsAsv+oJSc+F2TzdUPHTvF9k=;
        b=Ej/iKb8rhpuAFcFhtUeJxd6vSSdkQ2BxL4TjlXKczR/6dr5X6ci0KopMAWsHDKOqjv
         okJL8Sppbfs3inGm9cGEmEYOuaQpNVgtJFpM7j8m66AwkUwYxOU1sjQ443h6XFSBJmMK
         v5b7RbvmeJRv4kOx4BcVMQ3hiBWnsJ7CuryfbV04C0oCi80aONDVPBeImSrVKgXQCb0d
         FB9No1u+1RpUHV6C7uwVmJPr1oYspLsYn6DzWVKGUDNNQ2badK3vWNggpGelXEpMFnF+
         IH06c42XNyHc9Mbeg+uit5VZ7HA0CiQyecbm7ta0nasgP0t0rBUVAX5EePI+t7TMCE+t
         QqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=coUrbvM5Lflty8spiztbsAsv+oJSc+F2TzdUPHTvF9k=;
        b=3TaWWOQAHf63NybKiJsPBLFp68uFTW6RTWd/YbUboTNWcB9ZisBrgfJp6C0/kqy55m
         OwmY7tdZInN6KHcUNPqhpg2+bEV5iy4jihW4dHPdsJeYaCBijDXgu4eWn2gwCq9Or1Nh
         oP1EY5x5MvOzeU74buvqE4RPb2bSNEoOa8hXV3FbQk7zzvF/UNZeDQISXo19zaLW4IZL
         yTUJSRwmYa+4MZgtX+zKP1TSe2fBSgX/19NfTz6VtlqMbTqRQ4Qp29qJOFpeyuLVlacl
         EJWHpUUp8ShRb2w6NS1tLQq+LsEnNcVuR+1HL5kv2GXWaKme29cgOo/fKo8Ieb4M2Yh1
         rsDA==
X-Gm-Message-State: AOAM533VO81JM9TykP0HFjfvEvXXMu+22W1qiwLlvvrgiNQ6QebfQ/bX
        fPoW6JiW7Xjc7fQDqGutG87r4NoX3zY=
X-Google-Smtp-Source: ABdhPJwPvi/lmgC+gTZ21/Wz66CiGZojJBK5kwnJiiX4LQSzHxbRpLQV3my0CP726mGMYzFbz6D93vOC+Rk=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a25:1c45:: with SMTP id c66mr27703481ybc.133.1634013410276;
 Mon, 11 Oct 2021 21:36:50 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:30 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-21-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 20/25] KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
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
index 2b45db310151..595ab1c79bae 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -331,6 +331,17 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
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
@@ -693,6 +704,10 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
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
2.33.0.882.g93a45727a2-goog

