Return-Path: <kvm+bounces-36707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B52A2006F
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 23:21:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D07FC1886486
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A7B1DDA00;
	Mon, 27 Jan 2025 22:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u1woGYra"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027AC1DBB13
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 22:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738016455; cv=none; b=sgvw/hmXbdiPEyFqvsM0pA9rDdr7+ioz7SyFxM3VUQMDf+nVRq4wmWMdbUTrilbE+gBXX86SWB6WDzDtN2g0xJ9jKEgAoevTeGfbKExJn6zD3q7Bpdp6+8wJs4ff+XVlGZPSFtiwdKEWaGMlGE8jNLQuVJwXJC8wRvRoVnkzHPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738016455; c=relaxed/simple;
	bh=e+fynXqXDHpzzqW8Vs+cdjC+w3ueF0FGlAHIDITfNr8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U+WN8L4+3dQetCeCx7uoibuqbvZGokwyseHV5VCiHHT6KIBpJHfEwCFPtfiLFevT4C+9fobbGy4Y4N+nZ4q+uPWqdBmjHM6Ch3LqjOhasmfQ2o2Hxq10nm4bm6V82E6z0TNOkL+/SQLWrJBLQ8A4k8EeO/CbZqyfsuBY4lqK5ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u1woGYra; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3cfc9a168ecso24807825ab.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 14:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738016453; x=1738621253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GaVkSfHrHzVfJjq8AwEUCvEhNWS7AN/5lexlisUUmk8=;
        b=u1woGYrauJdklAESZcnSDcLNF1a0J/801uEI1GlOHpN4qCXw0cim89NK9hPyqawmLh
         hC1TlXOD3Xuy3fAStzJuYOcsW1kaPcvQTgoFM+ZLQ3OhN81TlE2Aup2LWPxlmUYBKTGA
         iWoaFdHgyXXHq5bJUwwjV9UUfXLW3TyVUuU5It5NeCv+m3rKVXkAdEvyGJ4fIfgtRjsL
         0n1NSTyby9C/mjbdY0Wk0EJxsnmML8F5CDaGMqkU6+t9iaBU+jcXinV4bIrgqCQALNAi
         PiXvIWMNsqcab3Pod/j0Q5ACDG5+GYQKijPQ2Izj2oYAMg/9h8XhaC8ve0s+iShQILsJ
         t9oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738016453; x=1738621253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GaVkSfHrHzVfJjq8AwEUCvEhNWS7AN/5lexlisUUmk8=;
        b=njiKpSR7cmJ30UfL5QFCun2EWHhOEztuJWipvVHOAem2cNDytyjGUKq2Mc37gyz8zj
         c2Yp9Bx1qOyPbKN3U6LX2JeGpYCsowhzL6ubWKfCm8rCS9IqAIF3Za6WZH+LSO7YBepy
         4qDLf2BpJUQ3gKozk0re5GmaBtXXz0nq/niOXJdedTzD70L32BuCG993d06C8di6P9Xm
         IiuTXHPqO9A2hxNQcSxc5rESdqV7+GZQl7dgUeFRlPj/AGnjbvdaRYFFQagLowHnG8ww
         LFrmxJw6ayBtFT45ycU7FFlMVksYZ58bta2OU4dNAZS8fMgE6yd4BT0sNbsdig8A//zs
         7RPw==
X-Gm-Message-State: AOJu0Yy/DrV3ZdZxBq/TmmrbKcWgdO4P7h1189S4J18oadFlWCl96yvk
	7Y8oXvy7NTxiiQZnqAInNTQAa1Jtd1K0+sppBecuNXEkrq2D9/O8SC1ml9K/q+UbPDar8gFHkwH
	ktPfGg75BYNxnUmwKNByrpISWLODV8EEC+Rd+dok3nqDYPVaN9lxeI0QrfrecSIBgqblpMi+yn6
	Ds/+ZnjyTUosIxBdZLG+ig/1D1uOKSHqMcGpc/PPNDc/9ai6aNnt/YwNk=
X-Google-Smtp-Source: AGHT+IFYMP4DnSoUUl5kkRFoQsqHI/1D0lC2aOLiNQgEnibJSp/Pb6c49edDE2uZE1uw/6tcaw+6CTgspGEMpXa6dw==
X-Received: from ilbbu12.prod.google.com ([2002:a05:6e02:350c:b0:3ce:8579:c1eb])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1f85:b0:3cf:b08e:7e91 with SMTP id e9e14a558f8ab-3cfb08e7f5bmr197753565ab.13.1738016453125;
 Mon, 27 Jan 2025 14:20:53 -0800 (PST)
Date: Mon, 27 Jan 2025 22:20:28 +0000
In-Reply-To: <20250127222031.3078945-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250127222031.3078945-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127222031.3078945-3-coltonlewis@google.com>
Subject: [RFC PATCH 2/4] KVM: arm64: Make guests see only counters they can access
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

The ARM architecture specifies that when MDCR_EL2.HPMN is set, EL1 and
EL0, which includes KVM guests, should read that value for PMCR.N.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-emul.c                                 | 8 +++++++-
 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c | 2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6c5950b9ceac..052ce8c721fe 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -993,12 +993,18 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
+	u8 limit;
+
+	if (arm_pmu->partitioned)
+		limit = arm_pmu->hpmn - 1;
+	else
+		limit = ARMV8_PMU_MAX_GENERAL_COUNTERS;
 
 	/*
 	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
 	 * Ignore those and return only the general-purpose counters.
 	 */
-	return bitmap_weight(arm_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS);
+	return bitmap_weight(arm_pmu->cntr_mask, limit);
 }
 
 static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index f9c0c86d7e85..4d5acdb66bc2 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -610,7 +610,7 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
  */
 static void run_error_test(uint64_t pmcr_n)
 {
-	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
+	pr_debug("Error test with pmcr_n %lu (larger than the host allows)\n", pmcr_n);
 
 	test_create_vpmu_vm_with_pmcr_n(pmcr_n, true);
 	destroy_vpmu_vm();
-- 
2.48.1.262.g85cc9f2d1e-goog


