Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701DF4F705C
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 03:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbiDGBV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 21:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240462AbiDGBUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 21:20:01 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1CF182D89
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 18:16:30 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w14-20020a1709027b8e00b0015386056d2bso1965257pll.5
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 18:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bNkFmzFNlQeAcnvu9GC9OTshsJeI+rH6kiFRlwb3YBU=;
        b=K8Gs9++5sAjjhKmOk+cuBZV91Fgx1F2Mc9/ihaqPTpvvoSDaAbLdCPmuZPTlG68if4
         P+L4S4dZumJgdSzNaEYVh+GredXixyyYlIw20G4uFBWxPVYkE4B4SKiO/claX7T8fsqZ
         973YmBn98DfC32Jfkfmhgw6w0dQlXY+5zJIAo0HS7siO1awykxEQcHKvmgE2C7Wulzf+
         yCe+cXmw+ol7FZCVBquExv//U+Raiq+r8EeVZnh/Gvh67wftRg0AnrEFREcqmr/YtDAx
         MWqy6tOmw/VyRjst4kEyYRT0NdHa9vj5NDXg6tBeIW1fR0zgikI1q556ZrgXu7cgVb66
         SJCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bNkFmzFNlQeAcnvu9GC9OTshsJeI+rH6kiFRlwb3YBU=;
        b=jtRJg1njh4VQWaPxoOuH76HIYHbB4cJnLmnnMmA+MvdB4Jm65R9TvM4uAOT17bZQD6
         79nrVKcG4VD+PUXYmssFyivJcnks++8MPMMk5VzDGtoKA/4uKRsFPatn2QukdkQvCBLs
         p7Euou0w1Z5Mbvh18V3E6O3hMEsSrm4bAnExxz6A0mYk1ZdTIZ4EyartUbWu7b/FemRl
         AtpxkXdP/aPZzv5VaJmC8Nouk0ngFl4c2gFE+JVPxLBScIfaEg3WjrU2TTvkOTC7pFT+
         mQfr8UhfOTfaodyrh3QscaQYTOZWt4FaiclkMjwNrifTHGLoAJt5mQwXZMhrqxNMYHDv
         wYcg==
X-Gm-Message-State: AOAM531fXUxmOLQKgP/xQgeeQZ7GR6ckzGa58h75U5TxlByuSANNfJjk
        fdzC5E0ywFM4IWTJMLCaNj1rVzKeTVAO
X-Google-Smtp-Source: ABdhPJw3H13JfmsLMr/v01PnuQI5IQ6Tom5pq0QlYE+3A76jaQsbAEjlYFdMr4kCXy4hfGM3I3np0WoSyb7z
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:7088:b0:156:1aa9:79eb with SMTP id
 z8-20020a170902708800b001561aa979ebmr11197910plk.71.1649294189989; Wed, 06
 Apr 2022 18:16:29 -0700 (PDT)
Date:   Thu,  7 Apr 2022 01:16:05 +0000
In-Reply-To: <20220407011605.1966778-1-rananta@google.com>
Message-Id: <20220407011605.1966778-11-rananta@google.com>
Mime-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v5 10/10] selftests: KVM: aarch64: Add KVM_REG_ARM_FW_REG(3)
 to get-reg-list
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the register KVM_REG_ARM_FW_REG(3)
(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3) to the base_regs[] of
get-reg-list.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 281c08b3fdd2..7049c31aa443 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -691,6 +691,7 @@ static __u64 base_regs[] = {
 	KVM_REG_ARM_FW_REG(0),
 	KVM_REG_ARM_FW_REG(1),
 	KVM_REG_ARM_FW_REG(2),
+	KVM_REG_ARM_FW_REG(3),
 	KVM_REG_ARM_FW_FEAT_BMAP_REG(0),	/* KVM_REG_ARM_STD_BMAP */
 	KVM_REG_ARM_FW_FEAT_BMAP_REG(1),	/* KVM_REG_ARM_STD_HYP_BMAP */
 	KVM_REG_ARM_FW_FEAT_BMAP_REG(2),	/* KVM_REG_ARM_VENDOR_HYP_BMAP */
-- 
2.35.1.1094.g7c7d902a7c-goog

