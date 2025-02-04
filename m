Return-Path: <kvm+bounces-37276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AE99A27C4B
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 20:57:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14B793A1ABB
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 19:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 205AD21A451;
	Tue,  4 Feb 2025 19:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TwrtnipX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C356214233
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 19:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738699043; cv=none; b=qaw/S7/lsAyBftNERWRSOU5gPA4NiyoiP3dq0m/gfPMFJKB6eeMrxaJlqvEhIrHp7XD5mbfVLulXC4tdK7pdjP+xck1BqfXTOMgW+Zwulc2vqkae/kaLUuh5Ldy1DJf/uq52G3kwVNAOE+V6kx0JtY5u/cOvPiXX/KHMjjdhfqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738699043; c=relaxed/simple;
	bh=QqvlrBfQEOlBEj4EME2FtGfO8xnXwuQ2wNlYILdKt90=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UuOXNj643cCGJQctRMJXszxri0XjxjlY+mImFinIln/zG4aJ+d+9D5wVLHey1Dv2KKCDx2C6OmdsftWln4s3vVnJPiErm5ksGl+5cIi3+C6BXIZH3AKyVqZBqH5TVPrQZZJDNjX3cG4WqPCkaH3SY6iDI5PMfnxEirwrv7K0xaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TwrtnipX; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3d04b390e9cso4110565ab.3
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 11:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738699039; x=1739303839; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4R+14MvP6+jfAZ/2SDPJZGHYgAQ9ZFZffV6N7sMB9Y=;
        b=TwrtnipXgLMFbuTZ9YnY19PZBln52Kn2qUIfOkqTtFTiwjWFdxNN+IXvl6KggKpesa
         fb6lrQBO7zvLcv48pwvIMes6a/qHdEQuUw/SdaK9SN0u7TXh7MQ2YCeiXWc8D1vb+eCS
         EohszD7Vr1qBaZke92EUP/KUMCjiCFnFAjuo1t23jftL0RoWN57iVOK7nY/gVZrWJAjX
         VGeVrX+PkYY4uKls3uGJfkMhEj7isRW5dL1R0JgrHpaz4UdUREh25z05Yov6EyAGSLRU
         H0kfZMz4p7vDHaVCeetYncD7GVNggn84jypi1igGzzDU14FbIav3OwhbDLbcen8gjNOP
         juOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738699039; x=1739303839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4R+14MvP6+jfAZ/2SDPJZGHYgAQ9ZFZffV6N7sMB9Y=;
        b=UOO6Trnl/OXp1Jjxeds5Ty/TY9WZxsN2RNAwooOhZdmbr6/2ylr/OG16H+sxKx9t6k
         IjajPA8DmbjWdu5TC/NUQhirjwpOEwUePnOkYh85njaazbAd1cKiGrB5zQNK0MV44Yds
         XAYjMcUhVWBbwMSM9/62jHq1op+gd25JNF9Rtguw5D5lG+Abf2HKF0lEilLMaVJ/g53B
         gYfTseLq3Sfc6mWcF6R5K58TKZRkAZhIhk5p6rSil+GWfMKfHp+4gfd4QiK6FlRiy/tI
         coyf/8jQeY9tBI3DqdLYWsDVRvbGkO3mjvv93VbkXGpKY6Yqzpe7J3WRJ2Han2ifvPnm
         o8EQ==
X-Gm-Message-State: AOJu0Yz4E/Dw2QWJtqI6GRye4acg/kqv9pc5uTkPrZJTDH6ZGMETuZwp
	CE7ualfPT4efgIj4ZBp5ECh42lcbTkK76QAYFxUBctpt3nGzGF/Fan/y6792ndUQWGi0rWrV10Y
	iD3IxZhn3jePo2/bIaX3vu0r9/PjYTZiDROv+kTTgRmEgP8swf8yBWZJvvyar0ZPJiLUyGqrkLU
	ax3MO5SpASWZWYsGSB41tlQpbCQO9OSo2gITxqFnHY/WNb2ojO2AiS4Ik=
X-Google-Smtp-Source: AGHT+IFjKjYyuQlNa/ishtIcrEB5bPDdOoTVbdVO7D85Z9CPphU0w8y5cfrKi9gtvFrT4dURbTET8ohchq0pXDfx0g==
X-Received: from ilbdr11.prod.google.com ([2002:a05:6e02:3f0b:b0:3ce:7e27:ea5a])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:3f83:b0:3d0:4eaa:e480 with SMTP id e9e14a558f8ab-3d04f40166emr2549635ab.3.1738699039331;
 Tue, 04 Feb 2025 11:57:19 -0800 (PST)
Date: Tue,  4 Feb 2025 19:57:08 +0000
In-Reply-To: <20250204195708.1703531-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204195708.1703531-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204195708.1703531-2-coltonlewis@google.com>
Subject: [PATCH 2/2] perf: arm_pmuv3: Uninvert dependency between {asm,perf}/arm_pmuv3.h
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

perf/arm_pmuv3.h includes asm/arm_pmuv3.h at the bottom of the
file. This counterintiutive decision was presumably made so
asm/arm_pmuv3.h would be included everywhere perf/arm_pmuv3.h was even
though the actual dependency relationship goes the other way because
asm/arm_pmuv3.h depends on the PMEVN_SWITCH macro that was presumably
put there to avoid duplicating it in the asm files for arm and arm64.

Extract the relevant macro to its own file to avoid this unusual
structure so it may be included in the asm headers without worrying
about ordering issues.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h   |  2 ++
 arch/arm64/include/asm/arm_pmuv3.h |  1 +
 include/linux/perf/arm_pmuv3.h     | 49 ++-------------------------
 include/linux/perf/pmevn_switch.h  | 54 ++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 47 deletions(-)
 create mode 100644 include/linux/perf/pmevn_switch.h

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 2ec0e5e83fc9..a39277b6a365 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -9,6 +9,8 @@
 #include <asm/cp15.h>
 #include <asm/cputype.h>
 
+#include <linux/perf/pmevn_switch.h>
+
 #define PMCCNTR			__ACCESS_CP15_64(0, c9)
 
 #define PMCR			__ACCESS_CP15(c9,  0, c12, 0)
diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 89fd6abb7da6..e22fb26b6169 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -10,6 +10,7 @@
 #include <asm/sysreg.h>
 
 #include <linux/perf_event.h>
+#include <linux/perf/pmevn_switch.h>
 
 #ifdef CONFIG_KVM
 void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index d698efba28a2..00623b69cdcc 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -6,6 +6,8 @@
 #ifndef __PERF_ARM_PMUV3_H
 #define __PERF_ARM_PMUV3_H
 
+#include <asm/arm_pmuv3.h>
+
 #define ARMV8_PMU_MAX_GENERAL_COUNTERS	31
 #define ARMV8_PMU_CYCLE_IDX		31
 #define ARMV8_PMU_INSTR_IDX		32 /* Not accessible from AArch32 */
@@ -268,51 +270,4 @@
 #define ARMV8_PMU_BUS_WIDTH	GENMASK(19, 16)
 #define ARMV8_PMU_THWIDTH	GENMASK(23, 20)
 
-/*
- * This code is really good
- */
-
-#define PMEVN_CASE(n, case_macro) \
-	case n: case_macro(n); break
-
-#define PMEVN_SWITCH(x, case_macro)				\
-	do {							\
-		switch (x) {					\
-		PMEVN_CASE(0,  case_macro);			\
-		PMEVN_CASE(1,  case_macro);			\
-		PMEVN_CASE(2,  case_macro);			\
-		PMEVN_CASE(3,  case_macro);			\
-		PMEVN_CASE(4,  case_macro);			\
-		PMEVN_CASE(5,  case_macro);			\
-		PMEVN_CASE(6,  case_macro);			\
-		PMEVN_CASE(7,  case_macro);			\
-		PMEVN_CASE(8,  case_macro);			\
-		PMEVN_CASE(9,  case_macro);			\
-		PMEVN_CASE(10, case_macro);			\
-		PMEVN_CASE(11, case_macro);			\
-		PMEVN_CASE(12, case_macro);			\
-		PMEVN_CASE(13, case_macro);			\
-		PMEVN_CASE(14, case_macro);			\
-		PMEVN_CASE(15, case_macro);			\
-		PMEVN_CASE(16, case_macro);			\
-		PMEVN_CASE(17, case_macro);			\
-		PMEVN_CASE(18, case_macro);			\
-		PMEVN_CASE(19, case_macro);			\
-		PMEVN_CASE(20, case_macro);			\
-		PMEVN_CASE(21, case_macro);			\
-		PMEVN_CASE(22, case_macro);			\
-		PMEVN_CASE(23, case_macro);			\
-		PMEVN_CASE(24, case_macro);			\
-		PMEVN_CASE(25, case_macro);			\
-		PMEVN_CASE(26, case_macro);			\
-		PMEVN_CASE(27, case_macro);			\
-		PMEVN_CASE(28, case_macro);			\
-		PMEVN_CASE(29, case_macro);			\
-		PMEVN_CASE(30, case_macro);			\
-		default: WARN(1, "Invalid PMEV* index\n");	\
-		}						\
-	} while (0)
-
-#include <asm/arm_pmuv3.h>
-
 #endif
diff --git a/include/linux/perf/pmevn_switch.h b/include/linux/perf/pmevn_switch.h
new file mode 100644
index 000000000000..1f211468d8bf
--- /dev/null
+++ b/include/linux/perf/pmevn_switch.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __PMEVN_SWITCH_H
+#define __PMEVN_SWITCH_H
+
+#include <asm-generic/bug.h>
+
+/*
+ * This code is really good
+ */
+
+#define PMEVN_CASE(n, case_macro) \
+	case n: case_macro(n); break
+
+#define PMEVN_SWITCH(x, case_macro)				\
+	do {							\
+		switch (x) {					\
+		PMEVN_CASE(0,  case_macro);			\
+		PMEVN_CASE(1,  case_macro);			\
+		PMEVN_CASE(2,  case_macro);			\
+		PMEVN_CASE(3,  case_macro);			\
+		PMEVN_CASE(4,  case_macro);			\
+		PMEVN_CASE(5,  case_macro);			\
+		PMEVN_CASE(6,  case_macro);			\
+		PMEVN_CASE(7,  case_macro);			\
+		PMEVN_CASE(8,  case_macro);			\
+		PMEVN_CASE(9,  case_macro);			\
+		PMEVN_CASE(10, case_macro);			\
+		PMEVN_CASE(11, case_macro);			\
+		PMEVN_CASE(12, case_macro);			\
+		PMEVN_CASE(13, case_macro);			\
+		PMEVN_CASE(14, case_macro);			\
+		PMEVN_CASE(15, case_macro);			\
+		PMEVN_CASE(16, case_macro);			\
+		PMEVN_CASE(17, case_macro);			\
+		PMEVN_CASE(18, case_macro);			\
+		PMEVN_CASE(19, case_macro);			\
+		PMEVN_CASE(20, case_macro);			\
+		PMEVN_CASE(21, case_macro);			\
+		PMEVN_CASE(22, case_macro);			\
+		PMEVN_CASE(23, case_macro);			\
+		PMEVN_CASE(24, case_macro);			\
+		PMEVN_CASE(25, case_macro);			\
+		PMEVN_CASE(26, case_macro);			\
+		PMEVN_CASE(27, case_macro);			\
+		PMEVN_CASE(28, case_macro);			\
+		PMEVN_CASE(29, case_macro);			\
+		PMEVN_CASE(30, case_macro);			\
+		default: WARN(1, "Invalid PMEV* index\n");	\
+		}						\
+	} while (0)
+
+
+#endif
-- 
2.48.1.362.g079036d154-goog


