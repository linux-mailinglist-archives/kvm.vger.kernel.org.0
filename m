Return-Path: <kvm+bounces-48197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C12ACBB9D
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 21:31:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCAB93AE008
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 19:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF6723184E;
	Mon,  2 Jun 2025 19:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iWnBJFwv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1463122D9E6
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 19:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892549; cv=none; b=BrH+vM8cJutq07Wlr+cM1EmgDSB/EzEsMNl/9+lje8y7qWYRsg8dUQF4SFuvRqZKooKH+QjHvxCN/0BleEdRK7MTtUIkMKYLRSHTr7jsR677lNOdDsSvf+CL0MxV3lhuLU2+zwnFIRAl0891scfn+5MbtNNWBHHCmRI7emaZ6Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892549; c=relaxed/simple;
	bh=zCxK3dISxEfOML4T7vSp5Om1/JdipoyUx0Yzj/yzWcY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s1Ruz6MB3LekdQl0YjCoczVaztyzq4WNkx1m17kegTkQpI0Kc6QPw2+6wXdU71wJPtogRkOCAIykCifUIWfpi1atu0pVu2r5w9l4lPaxntM/KCl/Xe6Klo7Imxdl6An+/cWF+5H3nEGgUgrSbkopE5DKGZcOXrcUnxIbsGQl69c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iWnBJFwv; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3ddb62de753so4400245ab.1
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 12:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748892545; x=1749497345; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JYJABjVP2iDArJLMl5gj3ep5scI8fjcxHEMsai9rZ0Q=;
        b=iWnBJFwv1xoCtLnCWhP6wpYuaDdliG9GU1pOz6A0jYY9FYSXXEy8rDQNJ8WX4vCFvQ
         8+qwIS/FA0bYttGxImIkjnym2jAVXhQFneZUzaZ4qTdonLXkHuwd+ENa09jW41yyzCs2
         ZoV4trQHfvTQ+HVzt/MG2d6LO/9SJ+Gf/D4tTJ3Y2FBoKSMnUTtjw6pdlY5XleHfXzYO
         QjWEFrBrCFjxOZ5Q0nnCpOLWfeaEao6bPdyqLaai4TLN/Qan42FWWgDjcpzd0wiN0nW+
         UiEy0+0PsMd7mXDFQDvsEjJ+Dqklb2qp+OPnAGAK5X8lkbhxZ5f6MhL4IKwE1T5RhdRp
         EOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748892545; x=1749497345;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JYJABjVP2iDArJLMl5gj3ep5scI8fjcxHEMsai9rZ0Q=;
        b=JBOcpVO39N1a1Ce7rODWy0wrZWaR4aoG97Wx5PUCYS0iTtG698PS6VEKgyoAaJDOh3
         k8wuTtzRDs/b6B9GiJtLmAaP5S0YTbRpE3dXN5i1Zw9t0AZGaiZzXhatI3DXcEBPzXdk
         w7uY3d7vQF5P+fq45c5qkCOscKcKhApnDDD7+Mu+TgE+Q++ZUBelJf5ChxjnG0Bvdxkh
         H1Aip250mmoNhJdOXfU5UCBT8cka8/tlJ5tIWPviSx2jpB2vWJjFfZj4mqnIgl8RXVEa
         o+6JeeEmZ7xqKv5yWP+F89B6ui8nGAyFOAAfwOjPm6HjYd8FdR8IvcMuM7c5rpE8gtIb
         XNeQ==
X-Gm-Message-State: AOJu0Yx4P6460J/1mbBmi6K9AgG6k/3ty0I1DpX7pmzmAr6nL7/YUcNy
	8Hw9QJmJpxRAsIswzJZAveq/ParxSiJ5F4QeQygj5H/Wwb41H2jdgis19ZL0PsjDWssn4k6My7t
	7ePewHJN/t6ps4Z7QIwWEA09/gWUW8BnmOAGEryIEYNgxnLPqVjurz2dLh4B2XAjLymbx3cY0GF
	wSwj4f2df1V/MPtDrRW/bgurUE0DZK6ezkIhifzYzJiteYTGCcbN3XL74aNow=
X-Google-Smtp-Source: AGHT+IGg2rWIw4S1SBhgIdtyOl3kiwsQOgXvBToZBQsbPlELmXsPKjt1+hk3s/Rllj0rwiuIByf4uJq1ToD1VufkVQ==
X-Received: from ilbbf17.prod.google.com ([2002:a05:6e02:3091:b0:3dc:a282:283e])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:b46:b0:3dd:89c4:bc66 with SMTP id e9e14a558f8ab-3dda3342b61mr86473295ab.9.1748892544754;
 Mon, 02 Jun 2025 12:29:04 -0700 (PDT)
Date: Mon,  2 Jun 2025 19:26:52 +0000
In-Reply-To: <20250602192702.2125115-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250602192702.2125115-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250602192702.2125115-8-coltonlewis@google.com>
Subject: [PATCH 07/17] perf: arm_pmuv3: Generalize counter bitmasks
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

The OVSR bitmasks are valid for enable and interrupt registers as well as
overflow registers. Generalize the names.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 drivers/perf/arm_pmuv3.c       |  4 ++--
 include/linux/perf/arm_pmuv3.h | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index e506d59654e7..bbcbc8e0c62a 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -502,7 +502,7 @@ static void armv8pmu_pmcr_write(u64 val)
 
 static int armv8pmu_has_overflowed(u64 pmovsr)
 {
-	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
+	return !!(pmovsr & ARMV8_PMU_CNT_MASK_ALL);
 }
 
 static int armv8pmu_counter_has_overflowed(u64 pmnc, int idx)
@@ -738,7 +738,7 @@ static u64 armv8pmu_getreset_flags(void)
 	value = read_pmovsclr();
 
 	/* Write to clear flags */
-	value &= ARMV8_PMU_OVERFLOWED_MASK;
+	value &= ARMV8_PMU_CNT_MASK_ALL;
 	write_pmovsclr(value);
 
 	return value;
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index d698efba28a2..fd2a34b4a64d 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -224,14 +224,14 @@
 				 ARMV8_PMU_PMCR_LC | ARMV8_PMU_PMCR_LP)
 
 /*
- * PMOVSR: counters overflow flag status reg
+ * Counter bitmask layouts for overflow, enable, and interrupts
  */
-#define ARMV8_PMU_OVSR_P		GENMASK(30, 0)
-#define ARMV8_PMU_OVSR_C		BIT(31)
-#define ARMV8_PMU_OVSR_F		BIT_ULL(32) /* arm64 only */
-/* Mask for writable bits is both P and C fields */
-#define ARMV8_PMU_OVERFLOWED_MASK	(ARMV8_PMU_OVSR_P | ARMV8_PMU_OVSR_C | \
-					ARMV8_PMU_OVSR_F)
+#define ARMV8_PMU_CNT_MASK_P		GENMASK(30, 0)
+#define ARMV8_PMU_CNT_MASK_C		BIT(31)
+#define ARMV8_PMU_CNT_MASK_F		BIT_ULL(32) /* arm64 only */
+#define ARMV8_PMU_CNT_MASK_ALL		(ARMV8_PMU_CNT_MASK_P | \
+					 ARMV8_PMU_CNT_MASK_C | \
+					 ARMV8_PMU_CNT_MASK_F)
 
 /*
  * PMXEVTYPER: Event selection reg
-- 
2.49.0.1204.g71687c7c1d-goog


