Return-Path: <kvm+bounces-50889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 363BEAEA7DC
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C70833B8EEF
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9D02FBFE1;
	Thu, 26 Jun 2025 20:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QGY9JTtc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D16D2F4318
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 20:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968365; cv=none; b=abPq1nUsRtuOAUusXDUJvM11ziXK00DbZjo8pymes9OqvYVafReO40RPt/bXVoq5B9piskKzYCvTNlrC6Nr8pzly8v+x5vq6rgmm31X3mNZbWfGzF3wL1XO49azE6lSSUUWbnyX4XuAAa0IpkTKNKlg1KoId5f+Bc+Lp5/BfMA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968365; c=relaxed/simple;
	bh=K2xYmW/GgRMbLaQlmv0qc4PJUypEgPrPpwxJt6aim7A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l7I/fNkYzgWgKO8CfljIq31XYAYVUhUjYmLSIO84q2lH083l/+vKQJ5sQ6B1LuaCRyC0bBthi22lgmNw6NplRpu7kAY0DpM78HXc5M4QxBcSKbV0Tsg8usbkBpJ9fCZ5D+IoiW/dZuUbux6M9I0CwadKNQdweVQmYdCabIqVwyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QGY9JTtc; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-72e90e6e171so275643a34.1
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 13:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968360; x=1751573160; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/x7IKRsWOtConph2bUpKtMTviRfv4NZ5l+qpFLQ4pko=;
        b=QGY9JTtc2RkySTRV7Nde7iqNyBTHJcRQIryLAQIPrqKJyac1W3WZCNknWXUKnaw804
         h3LQkaNh/w+5THpXIyZ8qm8Bf2DGP7kaNbtkdcwMJ4kldWFRHR5IgHhHHDXXyBd4dX+w
         WUSAg7iCSzv3vhObVbn1riBxagoWNu0//2I5mHEBM0L6VTnmYYLasXCz2P/8XS//TH29
         9RbBq1sRd9cvFg+NVZEaR9BtLeBqaKeSrPZW6kHEhTYknRthKgTogMJjDH9XOwB+lkqg
         NvBq7mQA2aKrkIL++Jk1bfKV4xd3kW0tjYb5H8zCdzHfN6qqzd0/f812ZHPNCSDhd20E
         uabA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968360; x=1751573160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/x7IKRsWOtConph2bUpKtMTviRfv4NZ5l+qpFLQ4pko=;
        b=Q560hqB9pMEUEPguGKawLLZQxBIsNZHNh1XzaSgKBbL/GJRJvC82u14mqgK5/Npc11
         Qadtg6NW6btaeXLDIl/W2kTd/V/bXasI0Wr0GM/drN2ic7IVQvFgzqLsb5L8tnPlO580
         yA5X1DIb9PhIDMLStS7Y4wLdDiBPC10yqAiVj55qrcc/oElaNaojJC9MA4Bdl6E2TjK3
         gPB7FJq5hHh6hFle9oLiccV2m6ye44YSQk0t9fKgqOIwAHdMn3tcFbq6YCcgyxahLJ9l
         tq0heDG7pT7rO7dOJj0I6YuGU5vHJKIRqTMTusgh87qWdm96Mxi2kEY0RtoXcvim9oK6
         9hfg==
X-Gm-Message-State: AOJu0YzZJJ7q84CmkTGa4yaCjrefSqAORyeja2TP689jc6xYZkBCaXFE
	+TqlBn0qrKCTH5thryEa3qrawwPd+mhxxGS1ZoOVMV1YErecr3e3JlHnBr4iXFpxTBarPBoggZP
	SwXe12uOy2k79AvL7qcY7zURJxbohXn+sJ8of4WDIX5UzABnUzCHNHRq8YMbtLzCgkwqjA1oUOT
	GkGbYpic+qLQa/d8kiC8gMpPmjQG7R/C8G/JvjLzM+svjz9sUlDlcSxFZJb28=
X-Google-Smtp-Source: AGHT+IE+CkaZ5iXFv3dTlFyH7UdGDZHsbvzoJSe9buN7PuL7mIyZPRSBWsO96oSxssKGqZuLRqFlyodkFZoXyb0msA==
X-Received: from otber8.prod.google.com ([2002:a05:6830:3c08:b0:72b:8c86:a47f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:720b:b0:72b:9bb3:67cf with SMTP id 46e09a7af769-73afc5c355dmr285473a34.9.1750968360578;
 Thu, 26 Jun 2025 13:06:00 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:45 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-10-coltonlewis@google.com>
Subject: [PATCH v3 09/22] KVM: arm64: Correct kvm_arm_pmu_get_max_counters()
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Since cntr_mask is modified when the PMU is partitioned to remove some
bits, make sure the missing counters are added back to get the right
total.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 79b7ea037153..67216451b8ce 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -533,6 +533,8 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
+	u8 counters;
+
 
 	/*
 	 * PMUv3 requires that all event counters are capable of counting any
@@ -545,7 +547,12 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
 	 * Ignore those and return only the general-purpose counters.
 	 */
-	return bitmap_weight(arm_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS);
+	counters = bitmap_weight(arm_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS);
+
+	if (kvm_pmu_is_partitioned(arm_pmu))
+		counters += arm_pmu->hpmn_max;
+
+	return counters;
 }
 
 static void kvm_arm_set_nr_counters(struct kvm *kvm, unsigned int nr)
-- 
2.50.0.727.gbf7dc18ff4-goog


