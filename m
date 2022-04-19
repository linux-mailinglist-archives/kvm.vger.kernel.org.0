Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5EA5064F5
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349044AbiDSG75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 02:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349037AbiDSG7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 02:59:55 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9868D27B2D
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:14 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id r15-20020a17090a4dcf00b001cb7ea0b0bdso1045548pjl.1
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DnB6mkT71yKfiG5xjrOUttE90Hmb51/VYCnn9fFtof4=;
        b=ZbU4DI8LNyuRtCFqPLEdyNdwHwoaTlUuA0oTrVeKfChCv8RdXwbrsDjHZp/0f6FQnP
         PZLE4A7NgUR6x0oMr5exTueSSuVho7obJ7dNzlyMTCr7HwLw6BKGJra91wUoMx3wlcb6
         bSQgSXwurkj3VYnxA575UdfzsJ87lzw9afbZ03AYvGQBQjegBxyQqcW+BA/oZie6o1mF
         Yh4sHj8EegW8bDGiPBecdj0wvXoudVP1mUn1WVnV9+uzP0TsHZWRMOL2i/nuqQfZnjxy
         xbyWDd7Or3+beb4xI3uCxytRvzji52R4qg7KmFzoyO/a+cO5Ag0fHz60VLe8FWFkTWw9
         Li0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DnB6mkT71yKfiG5xjrOUttE90Hmb51/VYCnn9fFtof4=;
        b=JTTmStnBFvcKnCtc+tpdT/aE6EG2Fal1pr02QF2NkWEBDpciH/EkzBANJg7pd4gtFT
         x7hKplIc6gHzg5vJwc7eJztEpzueYH3bjjV4ey6z4L68ikDAui0LSP+UrCp2mjuE3tAm
         tYdc8uI6ZccHQCEBqic7BKoMUjUPLFWfuU9qo3G7W73uICoc5wmX8cL/yRrg1DHih3jg
         NjclkmN/P16+0EIPXMYcQzwx1ZTCbwQ4Rh5B4aUfm545uOelqjP9qHS0FFkGveJ+mCMU
         7zlY1dPs3ltze/pu33+sG/g5MPMhkO2UIY9JIc3dzwKrJrLDGQ7x8rXh62bDS/GyXTZo
         Wolw==
X-Gm-Message-State: AOAM530JhaC9fQENTCMwR5EVQdGxctOnJBlmVvi+Ext3P7sLE1qo7GzL
        bt/2m4hRu5XL4N5Ph2yyjagx3DnKNiE=
X-Google-Smtp-Source: ABdhPJzKDkHVW1R2MC+Nhg/V/wFyysks9SmrrOZPKWBr9DJqaBdQnJOCmh0zLDSQV1Z/jaqGVIPM47cp9DI=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:2384:b0:1cb:5223:9dc4 with SMTP id
 mr4-20020a17090b238400b001cb52239dc4mr276794pjb.1.1650351433778; Mon, 18 Apr
 2022 23:57:13 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:11 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-6-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 05/38] KVM: arm64: Prohibit modifying values of ID regs for
 32bit EL1 guests
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prohibit userspace from modifying values of ID registers.
(Don't support configurable ID registers for 32bit EL1 guests)

NOTE: The following patches will enable trapping disabled features
only based on values of AArch64 ID registers for the guest expecting
userspace to make AArch32 ID registers consistent with the AArch64
ones (Otherwise, it will be a userspace bug).  Supporting 32bit EL1
guests will require that KVM will not enable trapping based on values
of AArch64 ID registers (and should enable trapping based on the
AArch32 ID registers when possible).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b19e14a1206a..bc06570523f4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1537,6 +1537,10 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 	if (raz)
 		return -EINVAL;
 
+	/* Don't allow to modify the register's value for the 32bit EL1 guest */
+	if (test_bit(KVM_ARCH_FLAG_EL1_32BIT, &vcpu->kvm->arch.flags))
+		return -EPERM;
+
 	/*
 	 * Don't allow to modify the register's value if the register doesn't
 	 * have the id_reg_desc.
-- 
2.36.0.rc0.470.gd361397f0d-goog

