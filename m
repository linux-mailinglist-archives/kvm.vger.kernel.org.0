Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A1078175F
	for <lists+kvm@lfdr.de>; Sat, 19 Aug 2023 06:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbjHSEkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Aug 2023 00:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241773AbjHSEkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Aug 2023 00:40:00 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F4D3A8D
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 21:39:59 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58fbc0e0c6dso1758257b3.0
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 21:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692419999; x=1693024799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Seh1pUJAoJeQMsb3DjbA2692WgZC2RtCPmgGThvub30=;
        b=DwkJD32BekuBCy2U4IGt+GsAXbEeNlO8nqmNBNRYSJRYAuGurqXGOPFa84zQOJUG6B
         LNX++XExakKbrpEEtpeXFwLrXMqQNp6nJ7PgVb9YR2MT1ig76IumJt0+ofKZIrV3yULh
         yRVADfXjNzU1NlxKdGULlj+buFsONnxtCUK14eD5NRvOz3hCTltJ/Hz89hHQ0QDm1LNu
         b5zLZjuAV72if7vS438j5l1gDhM7Eb+jUFyBy+xk/4v1QNP09pY6tL2zIdftUFzWFDqJ
         HGDtcaUnBhLuUXFvefYPtalWuV4aMkM8zuZRykC/3owI3r3scalOmigyXxpLegc0wNN8
         H89Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692419999; x=1693024799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Seh1pUJAoJeQMsb3DjbA2692WgZC2RtCPmgGThvub30=;
        b=SR8v5hXY40QSp5LWnRyH4/OYIJ3Ik5t5KUgVhMrOsD/7vYKH5FYy8LCEEpI6q2GznP
         LVNP4TJNrQVRwZRlGo6dgRj/u5G8HJ8FfswwiBLz/3CoK5vcN+uo9IBvri7Hge1bbQQb
         7qMky5S7RFW94oUK5AqIJkX7SBNBewTUWsxjrTlUYMalY5BJMzVxvBlMFLQT//oMgxQC
         QWft1nezEmEJf/zvYMnPZN6zkBFoq04f5ZnvivYTRDVU9eAAXtk/LUW8q3zrTKeNXrSJ
         KcekgTW4EzAJnFgBEMNJvb37qBan36XFBTB0PlBIrLlv3cQ4aR9Va5It9lu/7kvQSuNV
         ve3g==
X-Gm-Message-State: AOJu0YxQX6/A9vT0GSexcLydsy6TUDLznt1MQQC5Fllua6sMmxn1qxZW
        +STsQGwgwKXWrnQ85mzt5zTM6fWXtdA=
X-Google-Smtp-Source: AGHT+IHb42+dcZ0kfTh6jwPD34e2/SSiy6aoKrRAB1WAoCDxylqcANHFl34q+BzSpUcEkGGuqaQWd6kWUhU=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:764e:0:b0:584:3d8f:a425 with SMTP id
 j14-20020a81764e000000b005843d8fa425mr10578ywk.10.1692419998770; Fri, 18 Aug
 2023 21:39:58 -0700 (PDT)
Date:   Fri, 18 Aug 2023 21:39:44 -0700
In-Reply-To: <20230819043947.4100985-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230819043947.4100985-1-reijiw@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230819043947.4100985-2-reijiw@google.com>
Subject: [PATCH v3 1/4] KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disallow userspace from configuring vPMU for guests on systems
where the PMUVer is not uniform across all PEs.
KVM has not been advertising PMUv3 to the guests with vPMU on
such systems anyway, and such systems would be extremely
uncommon and unlikely to even use KVM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 560650972478..689bbd88fd69 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -14,6 +14,7 @@
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_vgic.h>
+#include <asm/arm_pmuv3.h>
 
 #define PERF_ATTR_CFG1_COUNTER_64BIT	BIT(0)
 
@@ -672,8 +673,11 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 {
 	struct arm_pmu_entry *entry;
 
-	if (pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_NI ||
-	    pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
+	/*
+	 * Check the sanitised PMU version for the system, as KVM does not
+	 * support implementations where PMUv3 exists on a subset of CPUs.
+	 */
+	if (!pmuv3_implemented(kvm_arm_pmu_get_pmuver_limit()))
 		return;
 
 	mutex_lock(&arm_pmus_lock);
-- 
2.42.0.rc1.204.g551eb34607-goog

