Return-Path: <kvm+bounces-50881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F97BAEA7BB
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1AEB7A87EE
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5722B2F235D;
	Thu, 26 Jun 2025 20:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZbCbXG1t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4804B2F0C5F
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 20:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968355; cv=none; b=ZR5qwLuzrAAyCmGURtD49Euj9a0y+kSMTWX6INoeIjJrpvWOkF7/hjQC62Y84AND8EaA6D0oQzj0avHbzgCWiuCL48ugU6zlRHNCPP4LDTEIdL41KW3yli0KYz/gARLLIOpy1JfCbsA+a1HU1rWZIOkx3tGYaNOsrW9cQbjLfy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968355; c=relaxed/simple;
	bh=9apEKUIdLeyPsikl7KFCLmT2RywguEX6MjbxXJr0f/0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TqWUdrttjZItN4g21n7L0uuyA1C8v0nphaAMQtWAmTn4zN1K1Lo8FqmOnap3gmWYiRBuCLofRljPKdXhtu4FLpNJ71DknQCftmqteObKqGGmGOA+/JDYQ2WUkn/Fmc//jh9OtKt7RTmMpj7HAaBZadcAafiFqAIBfBVIUTBPnLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZbCbXG1t; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddc0a6d4bdso17347035ab.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 13:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968352; x=1751573152; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iaFai0kpA9G7yidHpU/KUU/hEAHmvPP5GvS91zDpLpc=;
        b=ZbCbXG1t93on6ZRGgXaE1OAzhkNHfwrfyR37dvqdzvdzI7ccihsvwMmZ/AWwHHSgms
         EsLy7Ao4mb/qbFBbAn3Ql9abr+SYBGHV921xTu+tWSBY5JEx59DZFi+mQV+RQKGVqfxO
         b92fs2RhJirHmqwdubzWz+411Pj1dcCft5Mp5U+0G2iTsg/KgfTNY29cG09UFQXfaJLn
         o/GdUaGKD7aofJjTcZMyRH3oTT76gztpnZnhbwe6lP5Wn8ASZlIxyznUnCpwJ+FHoL/b
         g4o5fGgxdNmWmHVn01mTBxNqKqJZMt4rsrW57k09+n7FRTxYpJkxNbzA13aK5pje/oex
         x6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968352; x=1751573152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iaFai0kpA9G7yidHpU/KUU/hEAHmvPP5GvS91zDpLpc=;
        b=bRw/AAer1uvlRgimub6vnCYfjsZVHpOfGsPzvBg1JZcZRNQ2E4zr3AMrPyF+OLgx7q
         LaGzDre3nYnquO0+apInL4AKUFcXfLBnqN5fwheDDb9Qr/mXv5Hv/lSLdx6P6xn6EXQl
         oO4maXzZ1cudp+XG1AGRVoLxd46Jdy4JJzXxXQ0vyMQntQjazqIlUlkyrKFI7yttAo42
         FUZdNcttqrhETqRUxD+aQTds5Z2d9ygT3j9tEYGViqxWrAoFRnZlU9DOaIGNAOgCrKcj
         W7yIb2o8mqGkYudULH1gEB2MC2D1AJ2TwbFkvDtZOmw9aFtqvKc9oNNp87BKs6vNyIPM
         TH1A==
X-Gm-Message-State: AOJu0Yz/OPEL4uvosv6fzZIBQJsPoWItR6kYvvBXNHN6KifhLRFZbwm/
	0xxwPh9n/y6fYP5/YvEDhAVbfDJxxBvqSA1Mo8wy4HVQ28lXRVYMDPovwdTYpI5LcUzphtb8VJe
	I3ISifx+pkjSeCTFD0IFWid5q5ZhVnNL66sObyWUFp1dfb07kAiCqdGleSBkOLMiy74ZeN+I+Z5
	u9UmP7dt1vLrz2fcKHHIdxsASOhSGWS8hwSrvWh6Wovq+rPB2NZZizDx+zoUA=
X-Google-Smtp-Source: AGHT+IH29/gNXm3nZ2B2ojHCYilqtMfkqWLjy1qqrKLeh9n7wKnCz/XYXSUrRH/F4j6Tl4Qhzhb+cR95L/p7I4Y1iQ==
X-Received: from ilbdh3.prod.google.com ([2002:a05:6e02:1f03:b0:3dd:b580:4100])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a92:c245:0:b0:3df:4159:8fe5 with SMTP id e9e14a558f8ab-3df4ab55b4bmr13423615ab.4.1750968352377;
 Thu, 26 Jun 2025 13:05:52 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:37 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-2-coltonlewis@google.com>
Subject: [PATCH v3 01/22] arm64: cpufeature: Add cpucap for HPMN0
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

Add a capability for FEAT_HPMN0, whether MDCR_EL2.HPMN can specify 0
counters reserved for the guest.

This required changing HPMN0 to an UnsignedEnum in tools/sysreg
because otherwise not all the appropriate macros are generated to add
it to arm64_cpu_capabilities_arm64_features.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kernel/cpufeature.c | 8 ++++++++
 arch/arm64/tools/cpucaps       | 1 +
 arch/arm64/tools/sysreg        | 6 +++---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b34044e20128..73a7dac4b6f6 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -548,6 +548,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
@@ -2896,6 +2897,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, FGT2)
 	},
+	{
+		.desc = "FEAT_HPMN0",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_HPMN0,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64DFR0_EL1, HPMN0, IMP)
+	},
 #ifdef CONFIG_ARM64_SME
 	{
 		.desc = "Scalable Matrix Extension",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 10effd4cff6b..5b196ba21629 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -39,6 +39,7 @@ HAS_GIC_CPUIF_SYSREGS
 HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
 HAS_HCR_NV1
+HAS_HPMN0
 HAS_HCX
 HAS_LDAPR
 HAS_LPA2
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8a8cf6874298..d29742481754 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1531,9 +1531,9 @@ EndEnum
 EndSysreg
 
 Sysreg	ID_AA64DFR0_EL1	3	0	0	5	0
-Enum	63:60	HPMN0
-	0b0000	UNPREDICTABLE
-	0b0001	DEF
+UnsignedEnum	63:60	HPMN0
+	0b0000	NI
+	0b0001	IMP
 EndEnum
 UnsignedEnum	59:56	ExtTrcBuff
 	0b0000	NI
-- 
2.50.0.727.gbf7dc18ff4-goog


