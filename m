Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB35443D2C
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhKCGa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbhKCGax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:53 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC55C061203
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:18 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id nv1-20020a17090b1b4100b001a04861d474so504636pjb.5
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Esyigd24VZzPo59EpEVlVJ1Fgs9fgw4MXQuf865VkCM=;
        b=F+nZxkxoiWIyyns/e6YvCovwVFgHwrPCf4W/omxTTZKZxPeieOLU5DGarIx6iQBnRA
         AwDOAjRjA/RTb348aoIOxmxsGOLFGENIy+5whxqZNRq2weovTQtDpvjwDDS/X/bVB5Oc
         3Hksfyo6u3r8/r+WY1rwl3twBXaLZL30HbuxcePUi7SummLqW7NN8HBHD562Q92RPCB8
         IYHOfGZtQruMMArAwh5rkXIi6EftMSA9wzKz2yuC9O/WL/hANK5OkQecfL7Yf7PH4cld
         rUB0NfkdHf/CKIXzlxHKTBdEQoiAN6AGqNtwOmqQ1pzZzKBCXDxuE5wGgmn1Fd2VVxyD
         oggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Esyigd24VZzPo59EpEVlVJ1Fgs9fgw4MXQuf865VkCM=;
        b=cw2W57ja9aahX7+eZr/vwNIXkiglIia+AZ19VS5nJ1XEV2MiLbiK0t+UANlxfSvUi9
         aA7b1SW/FFW2K22c0PN1YDSWOHc75n4VvELBomeW6ybQ1iP5A0LZm6WNWvslcISgBEef
         wezO/ZSxyUiuHCjVMaxIAXPbVkw0GIm3C6HFqW9Fl0HTUEk+1M9oMX9oeI9HN2gS0Tm5
         vC+MbVH0K29U4sO0Oha4PW7PRogLC08LIlBOYsf90mFfpK36j4LLdGL5Los/rRC35Rtl
         bf6XLvVB9w56yVZPTLTamLSuliTOUTA+hSvF74JR2KOzbWDRZxQW+OuhOLQHugFvrlI+
         wTpA==
X-Gm-Message-State: AOAM533pmA2JVGacq/DlpZqOu3M/AHeALUiCBGw9xfX5XoN3Y3ozZwxs
        pkqlvM4KME/foytJ+hKy3S2AwPzld7w=
X-Google-Smtp-Source: ABdhPJy8zAxunqRArXzuJB5aGkOf3dPMAfmrH4e8aF0KnNXPQWSWpgHh4j0Xv7zu5BhBikqibRcVNu8SQBM=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:244d:b0:44d:c279:5155 with SMTP id
 d13-20020a056a00244d00b0044dc2795155mr41787826pfj.0.1635920897698; Tue, 02
 Nov 2021 23:28:17 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:06 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-15-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 14/28] KVM: arm64: Make ID_MMFR0_EL1 writable
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

This patch adds id_reg_info for ID_MMFR0_EL1 to make it writable
by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f04067fdaa85..cfa3624ee081 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -840,6 +840,12 @@ static struct id_reg_info id_dfr1_el1_info = {
 	.ftr_check_types = S_FCT(ID_DFR1_MTPMU_SHIFT, FCT_LOWER_SAFE),
 };
 
+static struct id_reg_info id_mmfr0_el1_info = {
+	.sys_reg = SYS_ID_MMFR0_EL1,
+	.ftr_check_types = S_FCT(ID_MMFR0_INNERSHR_SHIFT, FCT_LOWER_SAFE) |
+			   S_FCT(ID_MMFR0_OUTERSHR_SHIFT, FCT_LOWER_SAFE),
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -850,6 +856,7 @@ static struct id_reg_info id_dfr1_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_ID_MMFR0_EL1)] = &id_mmfr0_el1_info,
 	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
-- 
2.33.1.1089.g2158813163f-goog

