Return-Path: <kvm+bounces-40727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 895FFA5B7D1
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22AB4188F36E
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF411EE7BC;
	Tue, 11 Mar 2025 04:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NzhR9vgL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF961EDA29
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666146; cv=none; b=Cum6jMHprzgQxJHyYyaq2v1sYHrV7lhPSz5osHfOjPaAKWCeQHAa73L7XWwWFB+9saz4JQIJy9/F3LZAdwqovqoBzBUdCHV2pPE/sqx7WQV1qEG+nwufbKzSHR4T5gzlZ+QdesnAgs/TrsYR+Tmh2KAtrdxVF4xup0C9D9lrWYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666146; c=relaxed/simple;
	bh=ZZ+AiZUTunZXOtLpOLhEBn3+u5OhZNz1tND1065eVAE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HY4K1PeFWDjGIGmajuOBEaKnbv97z7AwpGXm6E9ji6Ulcd2ojAuPERU+/XRbIsMSRyvcBeKqZAZaU0k2MvHVKVusl/qjP5zwSwcNilmMRXDreYIKzeTKNPa8mnH7l2lcBk0tM8wrTSweq2ONUv9fBwJZJPwCFHWkdwV6822Cz6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NzhR9vgL; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2255003f4c6so43108755ad.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666144; x=1742270944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYUY7egDw13yHwOIShpp+yHE9Lg9eeptR3FMaPhbw5Y=;
        b=NzhR9vgLTUcuuF8dd/hEzEeDcU98Iloh/VYR1/KqPgsflhqm5co5wj5rZBnSnbtXna
         8yjYSHCnxzD9UNoLtme0tBgzqkCGrA9TE9wl9IpW0b1HocRLE6guScY17FsoAvwgJpLu
         iUp2VOtiHLEgbF0SKny3rJ3DEd4XWkmZsNIqQSa1th3arI+ujXs4MVmLDxsuzM7VxQAQ
         SpcOaSkyDOHLlmZdpJI9dE3VYirRf7hgKF//c43/spYO6nWE5Ek+27R+z5GPToyr5kiT
         spZ6jp3WZS094KGtjFrGWtApYm83JuBaxBYB8//0jwIH3g+0xH99+S+9LxIt0xh/J9Vs
         eWSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666144; x=1742270944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wYUY7egDw13yHwOIShpp+yHE9Lg9eeptR3FMaPhbw5Y=;
        b=VXhJac5nbbKDqQkxjyGtetVvSSlgRmhZ8juY+3H2pKrW5rm+DkAInFvKoi2Upom246
         Lo/4OBREJA5DrNj9zvkEoPUdj+yKCSBLiAQYke7oHPndbOV+nb/b2gj0tVw6qC2/zgIy
         R1M/EtuYneRJr37IiuPgMC3bSfplugCqA1NBM3J4uf72eSbtVUpDm6NVn6LvE0sfnY+l
         N9WWrEyJvtfyDc7n3Aeo+qP8q/nlKP+FQtxtrVycQdep2PEwJcb9cblcC8B2+gb6zRxB
         63CaGg4/RFwSQE7NRCsgq/jRUfgP76GHLdwte2jsGATEhgOjxJuefFCQ6Shz10OfVYcl
         JHmg==
X-Forwarded-Encrypted: i=1; AJvYcCUajYkfbD6MsusDh4/K+OdT1E4CqIB3NSMW+T2zQTKEkZn3H7KqMpRGv5NMb/zIGCKtL+M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/Y5c2fJMc988oUkXn3WYEBvkyNxphKA3x/IkHVvsgFOMPt3hf
	2sP0iC2Cu2HFwqmxvwFlkmxRQGg7FA+M8gWr+2ruoPusT1YgFsqqOBZhz2gEarU=
X-Gm-Gg: ASbGncst409+dM8xy7RBwtueo/TwLeumfbJ4EZ5G0dZcvK8QvPK8EzXsdzv5i/8mery
	eQi2gqXFILHbzJU+OXpaH6SKIcmigwEAVGe/pPL1R8d+CUmD9WJjTFoVd6HemukwR8reCm/b9e0
	vnq5fvUUCTbv7zSN9Gr45OnLX24bxh7vX0cJFTkNG2HcBIpuqfJdiA/iU0/h9751W3GcN7Jrf69
	vUzYSM4bZdtVnkYNC4Du6rd27E8exyHeENxD3wOxY/XFigbTdgCbigWIx01m353XSjstd6chZww
	BUk4eFbcFHtkyYM7ITBfJobU7sXu3rpanMwe9aHk0WMa
X-Google-Smtp-Source: AGHT+IG1r91N/pZj/+/h4MYPAOLJfFbK6eObEmS4IiEzuC9Hkmi66055HrrfvkPljzn8i/+Wegt/7g==
X-Received: by 2002:a05:6a21:4cc7:b0:1f3:36f7:c0d2 with SMTP id adf61e73a8af0-1f58cbf3befmr3240926637.41.1741666144062;
        Mon, 10 Mar 2025 21:09:04 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:03 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 06/16] codebase: prepare to remove cpu.h from exec/exec-all.h
Date: Mon, 10 Mar 2025 21:08:28 -0700
Message-Id: <20250311040838.3937136-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
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


