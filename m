Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0C94B4275
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241013AbiBNHAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:00:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241010AbiBNHAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:00:03 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B77D575DD
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 22:59:56 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id b5-20020a1709027e0500b0014ca986e6d8so5772581plm.13
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 22:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=03TUyFaPg0/Gjl+vQfTSvgoxQ+5uxs9Hi6MR9A6wLJ8=;
        b=KcLvYfrEmbcbn9/knN5ogFzworOFEeVL5ZK8AZWWTFU0yGrQ6hL5mDfGOL7otoY7DR
         MyXrJDy49UxK0NIylHzK5Kb2vY5ZA3xGz37wsQNkJTS8gxji/7yEkk7ZAj6jvZCtspx8
         MdP3LyyAIa4guOEcXFwmjfL55hNOw3+XlP66BJuic56ao47fmmNw8vZtsWUpmU0kdsAz
         QiuI4vQKwMgyMdez4e0eoBFAWk5ZE58xz9J0/ZqFIYYdwrRbzcYtVJDPR5cHipUfImVa
         1KH0lY3Hlg2gzWwhjWzN3a1U1mJ/R4Am9ZBJ6ItMl/BtBeQ6A5e//6G8Y//FT3r6R1AF
         259A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=03TUyFaPg0/Gjl+vQfTSvgoxQ+5uxs9Hi6MR9A6wLJ8=;
        b=0pUf+iZbLko87SknD1Vb2Nz8diQSqJLUIui09ngWhRCDia7j2Lyfz7UoRcgo7xcTE/
         FES+98A6gN2KjcieSoJUmfxTqKjwKWJ0nW/LJ5W35AA8fKWFqKo9MylfD0elyXj8FW4L
         CxK7PoheD3pdPLObItGXuihZtZKd8Rxm7mtNopIEfmwLkPpy9LWZu1ibGg8ihzknCLtg
         cFX2VwR3cnlJjgBY8SP1FmMO6EHoPW76EPgjsqsjjnCPzsUKaVIQgecox1BSeHzWH1o4
         7QOcOmMcGypTdeyqZJImPzhgxyTouOKVl0IQ90CZf2wcYE44o7tM6Giep4lDbJ8IjIn2
         u6gw==
X-Gm-Message-State: AOAM533oEfPjen/Fx4sffs3fLTlVD21KMRN5vYpVW9HO/MMjP4V8ndXW
        rt+Re0vLzbpVbNapQ+7BnXHrdbryJWI=
X-Google-Smtp-Source: ABdhPJy+Udb+Z+ZE+Rw3PccqevtrcStNlD43OiYvy5Bfz0Nf6G3t2aLz7nIFNg+rtbp1DbKZPXtNfE5VWfk=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:2441:: with SMTP id
 l1mr12577060pls.142.1644821995705; Sun, 13 Feb 2022 22:59:55 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:29 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-11-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 10/27] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU support
 for the guest
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

When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
expose the value for the guest as it is.  Since KVM doesn't support
IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
expose 0x0 (PMU is not implemented) instead.

Change cpuid_feature_cap_perfmon_field() to update the field value
to 0x0 when it is 0xf.

Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index a9edf1ca7dcb..375c9cd0123c 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
 
 	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
 	if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
-		val = 0;
+		return (features & ~mask);
 
 	if (val > cap) {
 		features &= ~mask;
-- 
2.35.1.265.g69c8d7142f-goog

