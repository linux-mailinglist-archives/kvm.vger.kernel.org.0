Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4B0454154
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhKQG4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbhKQG42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:28 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6903CC061202
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:29 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id gx17-20020a17090b125100b001a6f72e2dbdso770157pjb.7
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ypuzSw/4IsFfP8hg4NDwxw7HgMl3eu3z0C9tC8AgYeo=;
        b=siCkxe7qZ1oXtFSP6PtWcHf9JCEx5P8MAKaxj8jRAZjR8TfN4niqzdgqkLMpfQaN0M
         rdSPyeCBX127qnv7K5czfSo/LvwTRLRDcXnzdNgvwE5IRGkZ8xGT03jhc8dwV/2RgR8P
         AWe670/xztmm7gjkaEv9Pa6NhvqJFPjCrCMYUmExN16V2e37k0q7bIznyTmf4bnI7Aap
         r46yZAFdRIAih428DLTPDiNrKorKOddvISj9yDv4t6ecov2NQayo4OZUfHgvYMaVQF3C
         3mdP1/hAF5VI6iemKG4j4BoxYnitUxtZwT4DfeyfxKH3tSqDswy3euhaPi9Bxg2V5kZI
         Zxdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ypuzSw/4IsFfP8hg4NDwxw7HgMl3eu3z0C9tC8AgYeo=;
        b=Tiqkesf9HsqiL/HeEvr88smPdQ8b7tLqAM6gDq17/zA7KBA76/2Bm70lN6tL/Yta/s
         XrIn3Vhn/wXDGVysJtG2DWHXg7Z1/RTw22bv7F2Ac60c/DJRIgFs2AIUtuwy0tfFSRGr
         JZfWDAGxUwwkXORjArRyPgVLgBghvTeuA0lmTKJAU46YiFPjndXaV85DBjjIa2+9YMqk
         ZZdnJom+0YwqZLhc/akd7BCQ3PtDVZdMHKKFp06VzFhSiQESwyOwajKs/QkEbM9Wntow
         xKgSq+Zr3isWNMrnGFtiLDnk7D1oQwJ1xR1MROgcebXY42KuWDS/5J7nvVw2DYwMMEHl
         +Ihw==
X-Gm-Message-State: AOAM533nql96LiRjBEoJ6jWWV5ekJniDA8u0gk5ss6F5yEpGQNQK8VZD
        ykn7K9mRxnRnNx2QO8e0NCINekyL9R4=
X-Google-Smtp-Source: ABdhPJwI9+DJbTQSPl234ZhGbVm/QrbU+RAS+b9ok3vE7uJCrhlFZeqke6v/rSWf7WrZlyw307Ylal6Fomo=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:21c2:b0:44c:fa0b:f72 with SMTP id
 t2-20020a056a0021c200b0044cfa0b0f72mr4939021pfj.13.1637132008899; Tue, 16 Nov
 2021 22:53:28 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:43 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-14-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 13/29] KVM: arm64: Make ID_MMFR0_EL1 writable
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
index dda7001959f6..5b16d422b37d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -864,6 +864,12 @@ static struct id_reg_info id_dfr1_el1_info = {
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
@@ -874,6 +880,7 @@ static struct id_reg_info id_dfr1_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_ID_MMFR0_EL1)] = &id_mmfr0_el1_info,
 	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
-- 
2.34.0.rc1.387.gb447b232ab-goog

