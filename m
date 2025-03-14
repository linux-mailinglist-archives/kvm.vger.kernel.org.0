Return-Path: <kvm+bounces-41093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85DE1A617C0
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:32:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B961917126B
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE550204C0B;
	Fri, 14 Mar 2025 17:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WkZtlYpb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B9920485D
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973514; cv=none; b=SdVdGFGqEjcTAqRLB8WjgS5Le5lVv90vdoaVeYEHwSD1DV732gjEhfVh53sE7De6lliolxn3Ag/YCVGSr8QJ30OuakwQTit2i/dexsIRoUoqlhqhzEOBoJ3UIPL5sJZpHgCQZeyAl/AmLxLOGLi0b7xJmfXaUes11smtsaOyZG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973514; c=relaxed/simple;
	bh=7ZCuTPyFqkaspTwPhH/SEirOAPA6rDicmFwNtDxEP7g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IeNjamHzUDunInlAL/uWSlwjHw7oiVmmHAqwZDQJYK5l8xZLO1VEGEIXu3faMe/T8zX+/+s7RsS9Dptc6bR1irfXzdkZYXxBy1MYCkDJrknEqOaZc/flF9/Hg/o5/nmzD4C7OjOJT++Rr5biINncxnPt6Vyd/O5BbEXvnVIvkhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WkZtlYpb; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-225a28a511eso43036795ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973512; x=1742578312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZcjdDtX1Z7JVvsuWgguTldfqVr7ZBWkV3i9i17ooa8=;
        b=WkZtlYpb9OKCX3/slGsTKrBEyqCsJmhA2E0mpJwdxMKeSYJEFRObu7lrMLf+5vNxDI
         dQ2K9qE3m/YlwT0Gs7vflsr7KXpmABI0m80QOEM1uM2slcWhd+2YolxOm+UuunQs4AIU
         iL4DzINTRLMQc/n3pLRC9xB42X1kMu7A/bBckJEsU5twaeQNgIAu8sPbVUr41af6tOSE
         N113mci7y78kPqs+RioxQyq48beZQt5dzKCJHLfCyMQMN5p+m35IkxU7MM2FY0zBEttm
         7QCdnPXc25I0I5I7UiKfr6zmMDv5bsyNFzfUjTYQ/qS8kEWPVEZnLYurlISh9Liqkrls
         rvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973512; x=1742578312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZcjdDtX1Z7JVvsuWgguTldfqVr7ZBWkV3i9i17ooa8=;
        b=HNxYfd7wH352m1LH7rwYGeDu8s3u0Yukv18cFwjagZXE3lgk/fUPi/16hUnU3LrBRB
         WyvNNSoVyRYXpUCJ78DLzoeGhjrEARxpZlL3sl/rGz/9aFS/vUWVyHFXQJfiBejLXRes
         YdHFS+0kls2LaCdze4r0tKXISgn9paS9CxftZnLmPdfURpgXd6idB5Z3X5CPe2YSOgMV
         1J+6AXiDsBos3p8yEG1dEVWqptjbRM/aiGILKf7pkWKSspVrswYjRkhkLwN1VONOO75x
         qC7W/PD5r0IHt/OeGF7gAISLm9godyljncfDCnw2ln7srq4r7RB0RUyQVuoEHp+Fnf2A
         kdQw==
X-Forwarded-Encrypted: i=1; AJvYcCVUZ4uE/GY22a6NDSGZAvfYHtXeuAQTa41/DpiNo+Heqs85pCR5nsBJr0/q0opTPxhjuB0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2LjuIi221Lo9o7m+aqSLjHMaDD++pXc9+hGGi3Cul+czPbNmt
	Auvthy3GQElggx8MwbS5RGstOO5HHKv/1O52x5aZs6FastP+8dWSAwDgjlr4HnE=
X-Gm-Gg: ASbGnctXfT7hoghYoQCpsf6e2Zf6KZBFMvBlSsUOxm7QhGI9+3v3XYMhZhI+G6ZaXzQ
	e/mYTvjYNKXubKesEfhhmaVk7x43GmFCZIF13VEEH9SHOCz/nOOPXY9PwM++jzVw9vUWrdINs6h
	8PKetHVvWWODLtnejKSOfsmlCndDLy+2B+JNexhdXcFVI6KJqMLbsYPQ2DjFfTGFLQPuy5XfAi1
	8ieL0KqzVIu17UqvLDAlOxEs5IXBrwz18NEhH8RnOZTkW94bwLZOP6TJGwv3IY4h9vO1g1+hCQU
	Ie0ys9vv8+XYz2FANmbepYWfIvwfDmfHLy01a+1UTN+5
X-Google-Smtp-Source: AGHT+IEORLbJQZPgomOf1sDjTcDkAnGl+mlFCK1VHaTDHzBWmfJYoIo2+c2hSAC++5jNWglDm/0AKA==
X-Received: by 2002:a05:6a21:502:b0:1f5:8179:4f47 with SMTP id adf61e73a8af0-1f5c11d86e1mr5274835637.20.1741973511929;
        Fri, 14 Mar 2025 10:31:51 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:51 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 06/17] codebase: prepare to remove cpu.h from exec/exec-all.h
Date: Fri, 14 Mar 2025 10:31:28 -0700
Message-Id: <20250314173139.2122904-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
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
 target/ppc/tcg-excp_helper.c   | 1 +
 target/riscv/bitmanip_helper.c | 2 +-
 7 files changed, 8 insertions(+), 2 deletions(-)

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
index 201f6292033..a79e398c132 100644
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
diff --git a/target/ppc/tcg-excp_helper.c b/target/ppc/tcg-excp_helper.c
index 5a189dc3d70..c422648cfdd 100644
--- a/target/ppc/tcg-excp_helper.c
+++ b/target/ppc/tcg-excp_helper.c
@@ -19,6 +19,7 @@
 #include "qemu/osdep.h"
 #include "qemu/main-loop.h"
 #include "qemu/log.h"
+#include "target/ppc/cpu.h"
 #include "exec/cpu_ldst.h"
 #include "exec/exec-all.h"
 #include "exec/helper-proto.h"
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


