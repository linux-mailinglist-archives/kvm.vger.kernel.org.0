Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B5E72A94C
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 08:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjFJGPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Jun 2023 02:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjFJGPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Jun 2023 02:15:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555D63AB3
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 23:15:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8cf175f5bso7941087276.0
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 23:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686377750; x=1688969750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XLDsl1lE9fKzoXIg8MPnOFwUsmvQwygsh/INqaD/ueI=;
        b=UXc1xrBzdBOHgPQCOKCE2wNtYRgmzI+RQz6iY7jqlTfPceGe8tt2VMepKsGukaoYIa
         rzVoXP04E5vTRIA+ikBFVrDAcy7bloizNSUaTJhzYOECZl3wkLSMZq+XATfYdTlkZRKM
         FD1ZE/J4yrcDhasx1GF+l/LHPaCm2AN+dnhJG0Y+CWXKaGkMgKzct2jnOokOTkUn2wYd
         Bc4yjOcQO7urvkPY3uxi+wn8za7LZjpnUgvGGDwBsvWSuXzmN219boKVn62J2AXwM2bc
         miAMFWnxzMl1GsD5Bj4PXBdMFNm3ql+fyIDyrVUWZzlI65MuXPXJpmFCdaAg8OBc7I8h
         C0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686377750; x=1688969750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XLDsl1lE9fKzoXIg8MPnOFwUsmvQwygsh/INqaD/ueI=;
        b=QT+/FkChkMoRozB3lc2sjEnDKrluCjIzHkhInPQOUouzEexor2Lq5BG5r4+UIB2vzs
         QFMdoCAUwTxmAH2OYWo/1A8lFpJvFqqhqcZStWtIX1n3CqSoIlZIMym0Og+LZB4X+j8x
         2GF70saXDPKuQo0eEr02bOTH3naDL4JCd5/ddBVCA7eKB+hnaGWeAHrIUYY+vdUMSVCr
         jkFicJWurZktfzEh50fX16opEYW+5eATR91X6a0xd63it6EKeKxw4GIpW4dZ7fuPOcHZ
         4CkjiifgYVGoHYfLwky72w/BQ0FwzP6Bqir2iutVm0HWd81Jn8ym9Jr52ghWtobFjWIr
         +RHQ==
X-Gm-Message-State: AC+VfDzq+/otuPi3skPp3Qo+AvvKK7CDS5y5HYVprdzU2SONqSoGe+gD
        0idQOONyFgujIK84I51FYRyh76UyVsY=
X-Google-Smtp-Source: ACHHUZ6XJDpHi/HdxtmR8FpIa1JbQfGhF/z0iFxliMSkJFXID9aX9+1u8XSDF829uN+7AjpPFpq3nAnn06c=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:8c07:0:b0:bad:2b06:da3 with SMTP id
 k7-20020a258c07000000b00bad2b060da3mr2303926ybl.3.1686377750578; Fri, 09 Jun
 2023 23:15:50 -0700 (PDT)
Date:   Fri,  9 Jun 2023 23:15:19 -0700
In-Reply-To: <20230610061520.3026530-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230610061520.3026530-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230610061520.3026530-2-reijiw@google.com>
Subject: [PATCH 1/2] KVM: arm64: PMU: Introduce pmu_v3_is_supported() helper
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
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

Introduce pmu_v3_is_supported() helper to check if the given
PMUVer supports PMUv3, and use it instead of open coding it.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 +--
 arch/arm64/kvm/sys_regs.c | 2 +-
 include/kvm/arm_pmu.h     | 8 ++++++++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 491ca7eb2a4c..5d2903f52a5f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -672,8 +672,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 {
 	struct arm_pmu_entry *entry;
 
-	if (pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_NI ||
-	    pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
+	if (!pmu_v3_is_supported(pmu->pmuver))
 		return;
 
 	mutex_lock(&arm_pmus_lock);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 753aa7418149..9200b18127f6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1408,7 +1408,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if ((pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver))
 		return -EINVAL;
 
-	valid_pmu = (pmuver != 0 && pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
+	valid_pmu = pmu_v3_is_supported(pmuver);
 
 	/* Make sure view register and PMU support do match */
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 1a6a695ca67a..eef17de966da 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -12,6 +12,14 @@
 
 #define ARMV8_PMU_CYCLE_IDX		(ARMV8_PMU_MAX_COUNTERS - 1)
 
+static inline bool pmu_v3_is_supported(int pmuver)
+{
+	WARN_ON_ONCE(pmuver & ~GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0));
+
+	return (pmuver != ID_AA64DFR0_EL1_PMUVer_NI) &&
+	       (pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
+}
+
 #ifdef CONFIG_HW_PERF_EVENTS
 
 struct kvm_pmc {
-- 
2.41.0.162.gfafddb0af9-goog

