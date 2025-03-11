Return-Path: <kvm+bounces-40793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5093CA5D029
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:58:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19CC6189A5D3
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7E4B264A8B;
	Tue, 11 Mar 2025 19:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E60uDPs9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511F2264A70
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723099; cv=none; b=M6dfC58KX4J288Vuel6K5uN0nMaXHGgXH4byEMyG5+5i/AS3mMsJO3X2VQErmPHnCL7po9a+2dcfVSU4XQ9OIiOm7rAqMI7JIeInjijkKzOkvwuxGIcYNligZXvvFKge1xVUCGM3mOS1LXrkRm59Rb7hYQ4TiL9aGT1Ix359LCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723099; c=relaxed/simple;
	bh=ZZ+AiZUTunZXOtLpOLhEBn3+u5OhZNz1tND1065eVAE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I8AfiAHBfNhjxAGubiwdGzwXY4nywbHT10HunNyMssrenhlggjr4EgfNJn2T6B3rcJ9HCOPAj8IEw4Ek7vG4TjSJldqX8QA+jEukpriHojwcPL3aXRDtA7mVtXCtsXsXKgS/6Fn3BZ0KD0fWRffYjcwH/DQe7HkFYXo/PJTSlCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=E60uDPs9; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22359001f1aso140554005ad.3
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723097; x=1742327897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYUY7egDw13yHwOIShpp+yHE9Lg9eeptR3FMaPhbw5Y=;
        b=E60uDPs9gEE0gubg4FxqJqeA+A3QvZdDGS5JBCjWSs0L5nzSnzgojDET2hMJoAWtfD
         EoWuZqN3rPfwu1ejUchIdrtH7JXupHogDM+xuf8whPwJrFbXI9n2YOJbMNEDkiTdGbG8
         7Ynz3295NYTSdc4NOKzaEtOAMYD5745rL+M8x4/VW14LuOn1FC1ohXjERGjfmlFR0wZi
         aGGg0ZBgzriKupEW9A16TtRX52BHfE4PNkL9w/PqBcicnazKaltOtEWJ8yhmY+QDsfmy
         VltwW70lpfzkVRnTr7D/Qpkr6lpyeFE4s1NH42P3on3hTsOVvnzj+RPf+OrkR1D5nF7I
         xHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723097; x=1742327897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wYUY7egDw13yHwOIShpp+yHE9Lg9eeptR3FMaPhbw5Y=;
        b=dZRAZeVbkEnrBxh5soqyJprADKJwwjQ900KtY6UYYWe448q8634tNvdZw2ejlBWjYL
         zmCm4yt2FJeccIDo+sZzu0g43mvIVyKp49jje1OOX42gtfB72qMYBdajnV2xtyTj5nCF
         e/7gzdYXcuzXaPQFeO6kCwEirpkpIy8Hf+Id65kwMAiDJQSg37eL4LA9uDSkM9L+4jdM
         jykARZoCIUk1mRxuqs87Y874TyhlKDiGu4b4qxKr/LRLbp1/StH3Kg/4ClYs1t5tsTh8
         Des/7UvczG0pHkImvPvk1Cpzkfz9XbT6cJQ8Fyim1RlTWl/fo7cEbw4+XEdENjYrR+bS
         tC4A==
X-Forwarded-Encrypted: i=1; AJvYcCWJ6yucVB6hEjhKcRkk9c+RkEPWd+I5R0bbijXARJZjHWaSEyUygl1gZ4k9a57xaQusHt8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHsg80lIbbrHgoB/kVCYhuUkx8+m4cOlxZijE2Qw/39dvzmaps
	A0YqW8YGHZxhRaACTZD2hSAzk3ni76/6uZOPZrJkQGKwAL8PKb9zqEknJf/zdps=
X-Gm-Gg: ASbGncv1qv3pJ7yg9rsu3BeTDHNmK2rKkYWH3KP/wDXJyVJJA8zxLT2KgaGDPRCuer/
	MMmCAdYZJA51cXXlzq5MptVHAVUiSpSHYUEBHpF8rv6G30LMjci8rYHcm5U9fRUnQ7pcEfpB6f5
	Fk+YxCrkFFCHXw6IFKcDKB809VgPiVDF2yKUuJbNhUs2YPfXHMU5A26UgRcBACSH+xGF8MpI3YJ
	jlj9gN/hZljzUUw9L827g56lFs+nDxJTnpcjQ7hALU35VwVwRzy/XqHVO8D5zObYw/YQtI/XXe2
	OoqMhD3JicNRtdvtc1MhCbMVzaFlSk8GafEYxYNEwP7z
X-Google-Smtp-Source: AGHT+IHUxq5bEYzFkU8q2EMgwzHdCRPdTyU3cSt/scNg1CwBg3gT9IGXS4Ltng7xzXvu5gfwiPtTEg==
X-Received: by 2002:a05:6a00:7218:b0:736:ab48:18f0 with SMTP id d2e1a72fcca58-736ab481a99mr17386794b3a.1.1741723097629;
        Tue, 11 Mar 2025 12:58:17 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:17 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	xen-devel@lists.xenproject.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	manos.pitsidianakis@linaro.org,
	Peter Xu <peterx@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	alex.bennee@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 06/17] codebase: prepare to remove cpu.h from exec/exec-all.h
Date: Tue, 11 Mar 2025 12:57:52 -0700
Message-Id: <20250311195803.4115788-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
References: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/tcg/tcg-op.h           | 1 +
 target/ppc/helper_regs.h       | 2 ++
 hw/ppc/spapr_nested.c          | 1 +
 hw/sh4/sh7750.c                | 1 +
 page-vary-target.c             | 2 +-
 target/riscv/bitmanip_helper.c | 2 +-
 6 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/tcg/tcg-op.h b/include/tcg/tcg-op.h
index a02850583bd..bc46b5570c4 100644
--- a/include/tcg/tcg-op.h
+++ b/include/tcg/tcg-op.h
@@ -9,6 +9,7 @@
 #define TCG_TCG_OP_H
 
 #include "tcg/tcg-op-common.h"
+#include "exec/target_long.h"
 
 #ifndef TARGET_LONG_BITS
 #error must include QEMU headers
diff --git a/target/ppc/helper_regs.h b/target/ppc/helper_regs.h
index 8196c1346dc..b928c2c452d 100644
--- a/target/ppc/helper_regs.h
+++ b/target/ppc/helper_regs.h
@@ -20,6 +20,8 @@
 #ifndef HELPER_REGS_H
 #define HELPER_REGS_H
 
+#include "target/ppc/cpu.h"
+
 void hreg_swap_gpr_tgpr(CPUPPCState *env);
 void hreg_compute_hflags(CPUPPCState *env);
 void hreg_update_pmu_hflags(CPUPPCState *env);
diff --git a/hw/ppc/spapr_nested.c b/hw/ppc/spapr_nested.c
index 23958c6383a..18bbb1403c6 100644
--- a/hw/ppc/spapr_nested.c
+++ b/hw/ppc/spapr_nested.c
@@ -2,6 +2,7 @@
 #include "qemu/cutils.h"
 #include "exec/exec-all.h"
 #include "exec/cputlb.h"
+#include "exec/target_long.h"
 #include "helper_regs.h"
 #include "hw/ppc/ppc.h"
 #include "hw/ppc/spapr.h"
diff --git a/hw/sh4/sh7750.c b/hw/sh4/sh7750.c
index 6faf0e3ca8b..41306fb6008 100644
--- a/hw/sh4/sh7750.c
+++ b/hw/sh4/sh7750.c
@@ -29,6 +29,7 @@
 #include "hw/irq.h"
 #include "hw/sh4/sh.h"
 #include "system/system.h"
+#include "target/sh4/cpu.h"
 #include "hw/qdev-properties.h"
 #include "hw/qdev-properties-system.h"
 #include "sh7750_regs.h"
diff --git a/page-vary-target.c b/page-vary-target.c
index 3f81144cda8..84ddeb7c26a 100644
--- a/page-vary-target.c
+++ b/page-vary-target.c
@@ -21,7 +21,7 @@
 
 #include "qemu/osdep.h"
 #include "exec/page-vary.h"
-#include "exec/exec-all.h"
+#include "exec/target_page.h"
 
 bool set_preferred_target_page_bits(int bits)
 {
diff --git a/target/riscv/bitmanip_helper.c b/target/riscv/bitmanip_helper.c
index b99c4a39a1f..e9c8d7f7780 100644
--- a/target/riscv/bitmanip_helper.c
+++ b/target/riscv/bitmanip_helper.c
@@ -20,7 +20,7 @@
 
 #include "qemu/osdep.h"
 #include "qemu/host-utils.h"
-#include "exec/exec-all.h"
+#include "exec/target_long.h"
 #include "exec/helper-proto.h"
 #include "tcg/tcg.h"
 
-- 
2.39.5


