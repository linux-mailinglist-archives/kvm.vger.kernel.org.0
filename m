Return-Path: <kvm+bounces-40553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1316A58B59
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:59:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C4047A446B
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8631CCEF0;
	Mon, 10 Mar 2025 04:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IvmHt3Rc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1096A1CAA74
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582740; cv=none; b=saFQlAIH5JW3zVHrQ7DfOtfwP0UOHen/8mAJ1bua/v5Oos0Rql7ZVEbMltdIH/JGEkiaoCnbQj6X+miEq0TMR2wil3bqpCUghOUXVebdL4JBVmleUZn2slr2KOcnIPRv1TCV5HvOiP5M/J13UuoZRS+DnjUEIWIzq5as0eXLZjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582740; c=relaxed/simple;
	bh=HxYnI6Z/1qJqoDRK8ECVMQtb+GUZekW3l/MfIiL8650=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P//DIY+klEAswC+Inoxxj5FI3mdX6z1+As1ZXkl8x4dwoBFk/SmFsjsheRUnp01Todgu/cbGoXsfumVKB2EHwB9ZhS7XPI9RagSTCWAqy8k1so5tzWJ0wLQ1ICVRyU1FQLPcmhIIsRIchYD9ZkZZIUvOSdEW8utCSy65R30lVMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IvmHt3Rc; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-225477548e1so20295405ad.0
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582738; x=1742187538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8s25jeAGTcBk8xCVR99anv09nY4TtNOY1pAkSQYXuE0=;
        b=IvmHt3Rc5qOXONpAlJ87WS5JWFKe8EDhsvFrL8E1o1fvW9gnD53xBgjDt9L+ib6Epl
         xF9Y9rtnvjU/Q6HBWDlCaWoCntGyVufd9yjHY1UBEo4lI/2HKmZVSIQrU5AaG4A1aJ68
         Uw9UaD+begrIxV890W63um9hJd9hu1eWeB+HVBe22XVMGNDKPdBqe84FgXSv59pOxUQX
         fBdMPjUZrI5tH53SnRlmr18+4Sdp1s0kLIH7dibgJPacc6xFD3xnj5gAV1rUWuuTuJBs
         OALzYq3xoR3kBlE9ji5n8qIYOJTGKpKPQJNp5k39lyg8I58u+nBLy7ewGKZSLvzvSrx9
         N7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582738; x=1742187538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8s25jeAGTcBk8xCVR99anv09nY4TtNOY1pAkSQYXuE0=;
        b=nTznjx5GrDATIxdON14OMolrF1GnAm/jBT9Ul0QCKfzWzqB+EHCZX8h25GHPUPFkJw
         EgRYLSb7AHSwffrclWYuiDi/JLi57DuoMnqEiAeISR9ygNsaUv+KqLUV2a/6r4RFOgaf
         bpHCEsWcA6aJBCE2CrGlnZ+8fYugogqbw58sesRmuNKyXnRNKRCTkf1/blwLWdOMuBwi
         JHsvlggRVsIv2w0kuvPfX3wZx4EiB/234EKPb/OwMxny2fWMOQVbnfQDwB0pN1Hm7lan
         hj4SMOlXt/nbDwEZCm8eiykvwDuZlfHY3pqLgE6w8Es3fKXk4jTb6/XPMajpfNjD29Gv
         sljA==
X-Forwarded-Encrypted: i=1; AJvYcCWQAGfjIcjtI87Ocfrkp5f2jQNDUHpGcDKUhzTZq3fMTwWIEoE5o+Q2yidKi4NaKH38cMg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUgUJIraTISvYTyTfwQvsYejyo6C/EwvMFa9hkQXJebr4iLSSn
	onDj8BDb8J2CYypwpCmfkbQsEmihPYz80NKUneEwZRlgYku56091Eyu1Dadixik=
X-Gm-Gg: ASbGncvBlkMA/dRCjTIPxJ9sGjkXtD7BKmYVcZ/rQhi9JiV4LoAp5/zFy7N+ssVtdJW
	WDcIea2FLCMq8kGecuZGLGatbASobNRPzP/WMccLabvB5gVSgfv6D0Q6HIAK+aMwtN5+MxYbmaC
	yBmc5xxngklwt7HCuLpQeuMMZFnI/mGSEpaoX2qdiuj+xnCE180i6pSIO7V576kIkkB7/ZpLama
	+uErjdXQ3zjYhmrsKoC9ZejLEUp7wtJnk744ZUpkXBvuMW5ldXzGoiX1xeT0X0pSnbH9YrQcoUh
	iAAEUeUT9Sb6UpvircWgde4q9Fnl7GgaiydNA9xDCC579KP3XI/9PNQ=
X-Google-Smtp-Source: AGHT+IGRoGZ7coEeYo9o9fE7YTKv7YM5Vcb8VYcCl0LtzUFuhPuPAIbAabhl/TEnMhgrans4FlUiUA==
X-Received: by 2002:a17:902:f648:b0:220:d601:a704 with SMTP id d9443c01a7336-22428a967a4mr181654565ad.18.1741582738292;
        Sun, 09 Mar 2025 21:58:58 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:58:57 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	manos.pitsidianakis@linaro.org,
	qemu-riscv@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 07/16] codebase: prepare to remove cpu.h from exec/exec-all.h
Date: Sun,  9 Mar 2025 21:58:33 -0700
Message-Id: <20250310045842.2650784-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/tcg/tcg-op.h           | 1 +
 target/ppc/helper_regs.h       | 2 ++
 hw/ppc/spapr_nested.c          | 1 +
 hw/sh4/sh7750.c                | 1 +
 page-vary-target.c             | 3 ++-
 target/riscv/bitmanip_helper.c | 1 +
 6 files changed, 8 insertions(+), 1 deletion(-)

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
index 3f81144cda8..12fda410bb0 100644
--- a/page-vary-target.c
+++ b/page-vary-target.c
@@ -20,8 +20,9 @@
 #define IN_PAGE_VARY 1
 
 #include "qemu/osdep.h"
-#include "exec/page-vary.h"
 #include "exec/exec-all.h"
+#include "exec/page-vary.h"
+#include "exec/target_page.h"
 
 bool set_preferred_target_page_bits(int bits)
 {
diff --git a/target/riscv/bitmanip_helper.c b/target/riscv/bitmanip_helper.c
index b99c4a39a1f..d93312a811c 100644
--- a/target/riscv/bitmanip_helper.c
+++ b/target/riscv/bitmanip_helper.c
@@ -21,6 +21,7 @@
 #include "qemu/osdep.h"
 #include "qemu/host-utils.h"
 #include "exec/exec-all.h"
+#include "exec/target_long.h"
 #include "exec/helper-proto.h"
 #include "tcg/tcg.h"
 
-- 
2.39.5


