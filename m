Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1149D781760
	for <lists+kvm@lfdr.de>; Sat, 19 Aug 2023 06:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240893AbjHSEke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Aug 2023 00:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242377AbjHSEkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Aug 2023 00:40:02 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4D2A7
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 21:40:01 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58c583f885cso22819757b3.1
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 21:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692420000; x=1693024800;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TAo6+1RgBMzjn0+tgeK+RdjREY7saD7U6oafRnw0fx8=;
        b=rKmZ11ymHgsb8A+ZhygucloIc+RS76L/+ICgvOdkG41GnCGHyv62mTLMaS9ChptEpP
         lvA1xiqLn4J6R1X02OildZNEMxMF9TecNNRaYeH6rjJWyLQkqoJeMsGfp5JonrhYLNRk
         mDdPcat/mu45vFl46D66+iAGMZYw9xaBWB/TB2XxUh5u/wVpgjpMpB2nBT50PserrpvH
         2EYr0YsubYR1ZjdOYElel/ObCyhTmWPldrY2I5/O26x1B45EYoCGCZ0I7tR4nieMf+HQ
         zW9aW/c2M1C+Apy+b8eb/JPXMOTaf9toLNiJNtU/pt/w1OhyIe4YTU8+J+GEdx6Sn4Mr
         UlDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692420000; x=1693024800;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TAo6+1RgBMzjn0+tgeK+RdjREY7saD7U6oafRnw0fx8=;
        b=KBHJN0sPVMwiZWySdXo8IWxp6wlsYApN+pjbTxWgfKUqxrLaxOujKMAYgiTOy1hIZB
         Gs0jcPjKezpNKtkkDQn47v8czs46NPxdwrTJLzrl6GtBQ5jOvNXOmj40E9lZbWsTBnuB
         nYqBfBnZw8Qea6rgLuh8F6UAJ3fMarpPZ5F0d3ULyAgRRj6o2pwdzzjYX+/wDDFk5PL2
         EjohfpxIz/b4H90qIEz6Ez1NygaVvijdmfU502jPWdGR6VCNspajzwlzJO0W+urzPmDI
         UnAK7AdF3bUem027Rz/dhpe7irJmxs48EIZ195M/36DP9vVedl+Bih4uyHMHTKQqa+ca
         2qLg==
X-Gm-Message-State: AOJu0YwnY4IcedSbRUN+wNdi0FTbGt/PKTwxf4kYjnYd3PmJrAVXPVBR
        C3SZK9BQ8iBBVhrUCJiMMy0idC8qMPw=
X-Google-Smtp-Source: AGHT+IHX3mSDq9FhzDQbdS+XlHKtXxqy2p8nQlFtuOxi5Mt0UrnWf4ZYN4S6hnPUBVVyAcYA9P5COQcbbG4=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:768f:0:b0:d3f:ccc:2053 with SMTP id
 r137-20020a25768f000000b00d3f0ccc2053mr9506ybc.7.1692420000623; Fri, 18 Aug
 2023 21:40:00 -0700 (PDT)
Date:   Fri, 18 Aug 2023 21:39:45 -0700
In-Reply-To: <20230819043947.4100985-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230819043947.4100985-1-reijiw@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230819043947.4100985-3-reijiw@google.com>
Subject: [PATCH v3 2/4] KVM: arm64: PMU: Avoid inappropriate use of host's PMUVer
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

Avoid using the PMUVer of the host's PMU hardware to determine
the PMU event mask, except in one case, as the value of host's
PMUVer may differ from the value of ID_AA64DFR0_EL1.PMUVer for
the guest.

The exception case is when using the PMUVer to determine the
valid range of events for KVM_ARM_VCPU_PMU_V3_FILTER, as it has
been allowing userspace to specify events that are valid for
the PMU hardware, regardless of the value of the guest's
ID_AA64DFR0_EL1.PMUVer.  KVM will use a valid range of events
based on the value of the guest's ID_AA64DFR0_EL1.PMUVer,
in order to effectively filter events that the guest attempts
to program though.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 689bbd88fd69..eaeb8fea7971 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -36,12 +36,8 @@ static struct kvm_pmc *kvm_vcpu_idx_to_pmc(struct kvm_vcpu *vcpu, int cnt_idx)
 	return &vcpu->arch.pmu.pmc[cnt_idx];
 }
 
-static u32 kvm_pmu_event_mask(struct kvm *kvm)
+static u32 __kvm_pmu_event_mask(unsigned int pmuver)
 {
-	unsigned int pmuver;
-
-	pmuver = kvm->arch.arm_pmu->pmuver;
-
 	switch (pmuver) {
 	case ID_AA64DFR0_EL1_PMUVer_IMP:
 		return GENMASK(9, 0);
@@ -56,6 +52,14 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 	}
 }
 
+static u32 kvm_pmu_event_mask(struct kvm *kvm)
+{
+	u64 dfr0 = IDREG(kvm, SYS_ID_AA64DFR0_EL1);
+	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, dfr0);
+
+	return __kvm_pmu_event_mask(pmuver);
+}
+
 /**
  * kvm_pmc_is_64bit - determine if counter is 64bit
  * @pmc: counter context
@@ -954,11 +958,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		return 0;
 	}
 	case KVM_ARM_VCPU_PMU_V3_FILTER: {
+		u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
 		struct kvm_pmu_event_filter __user *uaddr;
 		struct kvm_pmu_event_filter filter;
 		int nr_events;
 
-		nr_events = kvm_pmu_event_mask(kvm) + 1;
+		/*
+		 * Allow userspace to specify an event filter for the entire
+		 * event range supported by PMUVer of the hardware, rather
+		 * than the guest's PMUVer for KVM backward compatibility.
+		 */
+		nr_events = __kvm_pmu_event_mask(pmuver) + 1;
 
 		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
 
-- 
2.42.0.rc1.204.g551eb34607-goog

