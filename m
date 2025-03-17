Return-Path: <kvm+bounces-41293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0042A65CC0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:35:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61933189813A
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBA7919F420;
	Mon, 17 Mar 2025 18:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F6j25ppD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F76E1E51EF
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236474; cv=none; b=uwGj5NkjvNFqIgikfW5uFwNkMo9hH79HEGp6MYibQsyB8wlFLbEvB+vLLjTLjOrJX9F/y0916jQ4sSCaQuzrJNEhGStdv3Uca7H5t1u9JLufP0Gom15f920GFgiXHGp60qP4oBgTjXS3Bf0TllqF8e4ciIdTIKNL/m0Ihh8F7O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236474; c=relaxed/simple;
	bh=7ZCuTPyFqkaspTwPhH/SEirOAPA6rDicmFwNtDxEP7g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UYx3ydRIKZkHNM7hjnzxheUZ2hG/8J7iGBd+MwIMBPfHbOJp+EsgLfuCCoBvV3xDtG0MkJzfDO7vRLrmsFi7z8mkLPFf3/shNLtdcn5W7C55dJwdtASbeLz8/E4THpBzCAPHpsqFVjAD79aot+HJsf/LDHOjwH4jDWGk0hnFBl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F6j25ppD; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22401f4d35aso89734795ad.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236472; x=1742841272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZcjdDtX1Z7JVvsuWgguTldfqVr7ZBWkV3i9i17ooa8=;
        b=F6j25ppDTWrwRE0ekl9lOcjxTzkCYdBZ2QGB5jX67hKSOwDV2U2gdgHn6BDqIuHMCO
         Qz6BO2Efg7Abkf/iAqio+f9d/lU5rAwwj0njA98TkV5fqHqW6IcWpPi4c/82TDQ8h5jo
         O466sCvqfbuKbur3vMMAjewWmMnuw8vWJzeQOQFCMEdHec0iJgTHo2p+H3G2GwAt6zH+
         Icn/4RP1KgPSF1LIcDHcXP/DihvBl9su0386k9vncGtKNROL3TX0NCvv31GtrVycQ3a7
         BwQuXj2UQGWuMlPIWx9+mKQwyUHshP46UEP1M6G7hkoDKsy0FJXkuqhGLFAouemhoiK0
         qztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236472; x=1742841272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZcjdDtX1Z7JVvsuWgguTldfqVr7ZBWkV3i9i17ooa8=;
        b=bPKO0BnRcfiCf1IzsldsnBcpN2lr4zencIPolF7yGs+WtzsgbqgsZGPSAYRxTcZ+lD
         chE66YRk2d4ZkQ9OHkXHCT28LXTTYwvKMyjxSP9bTW3hf1wthe7Q8QNm7ElQ8UZIroBh
         W1JZ8ROA6eSZEtqXOEul77B7+i5OkvPcgt8mmxoPA/NZq8hIlOS3p8jofaH0NA5S35ad
         /asjXvDW3J5XzbXXnH9koXxXeXNhSVTXdCFmpfgSpVmlpZTuTnLvgKbvcwdlAS/4LmZE
         +HY37sw5vyzzmhy4oWW7sYh+85BgRu2WAuyoJRMMC9RF8AINEbdiUI13M8KSGM+7uGin
         o8lg==
X-Forwarded-Encrypted: i=1; AJvYcCVLQuhYcJHVVNKbSQ0jK2kIPNzDCB7pKamOQscIqbUYVvjVjXjHXf6SFIuBN7Mv/4YI8pM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo222bBqBarShe7aHTa+exnmVTDmewarPKdIfQ9AlQDLoVDw8p
	tHDmF5e/pkfRBLgDjuSw07pn0LrpF/z/x1ksxrrY2RIItMEFOzYKVBEvZZ81Rlo7FMN/+pLFdds
	o
X-Gm-Gg: ASbGnctBD7byy4UKHhfJy8WaniAFyBB6MASKPIOJCkIt24sZG4IHxXF+ebnb58acpYm
	7F/PdjV/4tzTaALCFcCLrNZaiXfxIwLkW391Az9IYioXyp2l8xbNNXtJoXOMiuwLtc5D6SA9drB
	vA4HriEWNF7MG5O7Vc6hHbtByEjyV1gafgvU/boz+kS+F/fhSQfhU+bP9IyWAXlTsx0DrlovZRt
	QqpEJc1i6Eo+RDygdbmZ1TlHg1uXgggZLXG69gKGVFzdSb00EldjN1u/6PlaTdNS9y6W03lIMPV
	0V0cFR1z9WtNYeJAfgvG59nKvEHa4yMB6Oyvxz0DAGOB
X-Google-Smtp-Source: AGHT+IGNO8bUyUW0Tf64WVNf5jONex1ECKej9xrvhw7mQgHMktiWmZ+ZuCh9rC5TGEXL07arJnJidg==
X-Received: by 2002:a05:6a00:3c81:b0:736:5544:7ad7 with SMTP id d2e1a72fcca58-7375723f949mr818617b3a.14.1742236471771;
        Mon, 17 Mar 2025 11:34:31 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:31 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	qemu-riscv@nongnu.org,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Peter Xu <peterx@redhat.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Anthony PERARD <anthony@xenproject.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 06/18] codebase: prepare to remove cpu.h from exec/exec-all.h
Date: Mon, 17 Mar 2025 11:34:05 -0700
Message-Id: <20250317183417.285700-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
References: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
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


