Return-Path: <kvm+bounces-36708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DA49A20073
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 23:21:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 667321657AA
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 749681A01B0;
	Mon, 27 Jan 2025 22:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pIm7qApz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B751D935C
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 22:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738016456; cv=none; b=S/wG62usbl4QLPZtSzP+3VX//3gOOG2f3sK8PAiWCAfDpRrqxsl2JWqx3lq8CbE+yFTiVWVz5YH5+Bs2SwuNosOMOw88jMhuaspbEXm5oNf0PyfpjLUjn+t/WOhOqwdSs9mzhYmPk5VqHm4CMZfOmkU49Jx4KqREVq6c3zQmflc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738016456; c=relaxed/simple;
	bh=SZa0a0KzR+LD1LUzSHL466MizkYLm52X6tOmDCEf1DM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wv3rNY1gA9oealuyXp6USwILHNCa17KCCDw2AbOPnXx+ttp3AaY+VBSi7p64/R3XCOSiZkVcS6QjDRdkO6DrFjMBefC1wlSPMN7vBahrrXLPD3/gl+c38eiKUC+VutZfAy936zzmQgFUvH0U/VAQGUPQK5eOC+QK7iERjEby70g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pIm7qApz; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3a9d57cff85so93449425ab.2
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 14:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738016454; x=1738621254; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eB/WXdYtPvN5Ab5ru245YZuFbSt2Wl8WSfh8CIWhE9E=;
        b=pIm7qApzgYFclMU3e/6xRUZdvTo7iWPuuLywAaBsvBCCtpUagjgLroAbel7JEUsf0I
         332TbuaFwjZ8jzBBuXrBoij02D+BXhjhCchpSURqnp44i0tv5BjU2jYSonY7Z9JIWXk7
         Wbak2xcW8P8dJ1oq10j2hk/C36uqoXLkTVMAjmNd8WDEoDyJ4YY0wyjgKjzWdrYMC6oH
         JJpDsMSsUni1z8jC0yB0Wq7pnk9ukBeQdXwCCIG3CtKKrmCwosjpaXyUrWKkS5hPASTI
         sxFmc9wKsayfH+gSUSq6yd9ZiTAugwdRtcBzS21VlUdE4xSDg9CGrwD2gwFCczi4n9Sm
         ggEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738016454; x=1738621254;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eB/WXdYtPvN5Ab5ru245YZuFbSt2Wl8WSfh8CIWhE9E=;
        b=smP6Wa8tIyTkjuFayORY5LFOgZdbu3A6zdrMYMGVAM0rhQSR3L8vB1130pCUJ5srZ3
         oo5NfTfE1XCM5F9Gp1RZ2t831+Z29PBVlKADKRr0f1J5RpP02c3YWobQwE64780Qy9wq
         5KYmXKwEwCoXprdBcgos6/z9IJWyiFVALo14KKlAkdm7VWIIdw7BXp7FQdakJJ9Aaiei
         aPD60tkN1YVX5YyjI/1eNazP1OvXOyTxsIQ0I9qIwNTbk+yGdVPLBuyUqnAPOVAyn6Ig
         wv9/EFPA8dkNMW9n7SLt5yO/oIB2CxLhkQq8yR1OyWZJ4C/OavwOWlt/KRAq8hZ8JIhS
         uLbw==
X-Gm-Message-State: AOJu0YxJujG0aQNt0W2GDW1lIcbdTiMG1gWQvnAUnjaEZ4jxItF7QINI
	Vm/2dpqcQDvIR7lQXgwOcFqIv1Hpk9tqJoIOCMw/imT4Gy758jeypUcE/GOwvMJ+Vj9vpfGfS6L
	QTK22RTbqVuk3zuUmghSXp5ejuYyE46qJ8b4E6c7++OqWfg/iqZXXc64k6M+wjsMQjxhbjjvDRg
	dVmmGKZ+uz7khX3waAYJsJc8tPGhJCplVj2G4TKB4SGjLp1Sc0SaRyPGc=
X-Google-Smtp-Source: AGHT+IHlnPj0B51G4F3gaUMK8xZM3/o5eoR0afyVhEDX9mUYzTDBYrn3lVxOBnfUacMgZ4+x5YUCgf5OnSaiN01GgQ==
X-Received: from ilbdz9.prod.google.com ([2002:a05:6e02:4409:b0:3cd:deb8:6a64])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1fc9:b0:3cf:c88f:7555 with SMTP id e9e14a558f8ab-3cfc88f7680mr123300885ab.17.1738016454065;
 Mon, 27 Jan 2025 14:20:54 -0800 (PST)
Date: Mon, 27 Jan 2025 22:20:29 +0000
In-Reply-To: <20250127222031.3078945-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250127222031.3078945-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127222031.3078945-4-coltonlewis@google.com>
Subject: [RFC PATCH 3/4] perf: arm_pmuv3: Generalize counter bitmasks
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

These bitmasks are valid for enable and interrupt registers as well as
overflow registers. Generalize the names.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 include/linux/perf/arm_pmuv3.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index d399e8c6f98e..115ee39f693a 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -230,16 +230,23 @@
 #define ARMV8_PMU_MDCR_HPME		BIT(7)
 #define ARMV8_PMU_MDCR_HPMD		BIT(17)
 
+/*
+ * Counter bitmask layouts for overflow, enable, and interrupts
+ */
+#define ARMV8_PMU_CNT_MASK_P		GENMASK(30, 0)
+#define ARMV8_PMU_CNT_MASK_C		BIT(31)
+#define ARMV8_PMU_CNT_MASK_F		BIT_ULL(32) /* arm64 only */
+#define ARMV8_PMU_CNT_MASK_ALL		(ARMV8_PMU_CNT_MASK_P | \
+					 ARMV8_PMU_CNT_MASK_C | \
+					 ARMV8_PMU_CNT_MASK_F)
 /*
  * PMOVSR: counters overflow flag status reg
  */
-#define ARMV8_PMU_OVSR_P		GENMASK(30, 0)
-#define ARMV8_PMU_OVSR_C		BIT(31)
-#define ARMV8_PMU_OVSR_F		BIT_ULL(32) /* arm64 only */
+#define ARMV8_PMU_OVSR_P		ARMV8_PMU_CNT_MASK_P
+#define ARMV8_PMU_OVSR_C		ARMV8_PMU_CNT_MASK_C
+#define ARMV8_PMU_OVSR_F		ARMV8_PMU_CNT_MASK_F
 /* Mask for writable bits is both P and C fields */
-#define ARMV8_PMU_OVERFLOWED_MASK	(ARMV8_PMU_OVSR_P | ARMV8_PMU_OVSR_C | \
-					ARMV8_PMU_OVSR_F)
-
+#define ARMV8_PMU_OVERFLOWED_MASK	ARMV8_PMU_CNT_MASK_ALL
 /*
  * PMXEVTYPER: Event selection reg
  */
-- 
2.48.1.262.g85cc9f2d1e-goog


