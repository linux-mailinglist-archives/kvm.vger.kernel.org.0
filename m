Return-Path: <kvm+bounces-40955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 401AAA5FC07
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:39:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B90F16D666
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 723F826A0BF;
	Thu, 13 Mar 2025 16:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iUNwF2ke"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7ED26A095
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883961; cv=none; b=AQ7rDLlYSmEj809aAMSeZmUE1Es7mb7X8cs/AEzXl0obIseSFNUxw0SSRJTqTvlsiSS54ECrwm22Xsp4iCHwoHOQvbqjE4b4lumTLhNPPMMrSrjToy6YUoIytNW+hsUKK4GVW+fuGaSFhQQEgVpwXDhbe87CeQRJH+c1Z5Bon1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883961; c=relaxed/simple;
	bh=7ZCuTPyFqkaspTwPhH/SEirOAPA6rDicmFwNtDxEP7g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XR1dm/QFye7RcVuny1koGF6bU4NJSGE8QU+NbMEC1w0NbMYM0QIreIoDnbWM2Qal9G/FB33nR1/oYzMD6RtHEKdeb6DEZMKJjKvylUfHU7u6P+tKoiy0CSuE9Ppts9Io4yien7dNDmaKQ2ckQ6lola7SAl8xgX8HeEWedw0GRzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iUNwF2ke; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2ff6ae7667dso2578454a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883958; x=1742488758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZcjdDtX1Z7JVvsuWgguTldfqVr7ZBWkV3i9i17ooa8=;
        b=iUNwF2keHls6VK1fRn2dZyYKkGiKeSJQvO45MzMdjV2wEVapGOmZ4qcb7Pb0PIEQgV
         RHHpAW2hJHIkGfrlM3XsvL/uAMCDEEmV/gEG6g7ZsoyXxqJKWjt/U+B+XxfoG2vmJNQa
         V7/5JbZFHZ0ZrFCqTxhoC2yZvWgUc2TwIZUjHd5Ey7iR3GPRBKCI4YWdrF6E4hLsbUaH
         J+KO1UaDaJj/b2efzDAQ3rSKjVDk3deqQwD9TUrNv8QlOqSMndSuPMZ2uR12XuvG4dHk
         3LCexNX1FMSajaWJ8eI8wL8dZOINk/WyPiAfjlHY+o9/bnxMJvDcgkTIJyU84fhb+hWp
         usFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883958; x=1742488758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZcjdDtX1Z7JVvsuWgguTldfqVr7ZBWkV3i9i17ooa8=;
        b=EWo+VExrWPS7VwVvPdDeIxiGFyr7HXTo1WZ+wpEBjKIbFiag4HGgKGVNT8dpVU3dUT
         I8OBGie5gM75gzSLJgxJBzWJ9tDgrE9PijF9bxWwU9z1EgJBQGBFU96vI891dwVCAprx
         00Hv7P1uqn7tmwVl5F6UYDFU0CaModvy44rkGQJDTprvqiwtyxRZsbyZaWPGfQvEjcIw
         lnxm8WDizKmVqcqnQqGkEfLKqB323eN7cnd6+KGb8nV21YR+cEnueo912k2YLrUJoWvV
         wrgcrxb238/qnkNkEeSAHEgYZ/hrkNVfGFNUad0ClI3OsNS0yuBU7MN5nc7xzOetqK5G
         F9UQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQSYYqKn55Ww/V6tgmR66z4xEeN/6scaB45DiK80x1FtdpgW3HfWJmbGN7l6kqMzUs+2A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+izlsadojVerw9ajKeEGFTNLtnzVYSlhdS5TpDkOFdcaR1CQW
	0290AwEvfrofQhYYqFPkFtTr4jBupyrfIVxVBCSaGn4WHkcZeNwV8zFKRbqXTLk=
X-Gm-Gg: ASbGncsbKBFR04oXrjEct+ZUUIUNcE4Jy8yCee0B5qduXwlKDdTbIQ/1or/Llru7sLx
	kauNOhCPnuKv7BTu9LZDZTrpeWXPXEDMFDpSaIDwOsvubFLb3U6NWSpJ0L+19yRTSdBNFdXoqcz
	JjzK5R+76U9shstsmEpLxIABSpPZfLB95ZXamtYsuyyIrG+cWr1IJ7HjfRPF25c7YiyjdwQYQxe
	CYtWiq38+zouSItSnwb7yoz8fOjM4IF3rYj1RtAx6isYuA6vDJ/Eq4NlKzXpxErix1I9o8Co5yV
	fHHYXyrP8cEffgT78zQsBl0UMXRGpEaviElBw0Mi22Jl
X-Google-Smtp-Source: AGHT+IG4zIqLxuyjovKp9g3TAXrCpctV1RL6f3536TGUBfN83HoHfbIXNZa1EoQ+qlG58AlBh7g+Ww==
X-Received: by 2002:a17:90b:5403:b0:2ee:fa0c:cebc with SMTP id 98e67ed59e1d1-3014e861c18mr244498a91.20.1741883958391;
        Thu, 13 Mar 2025 09:39:18 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:18 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 06/17] codebase: prepare to remove cpu.h from exec/exec-all.h
Date: Thu, 13 Mar 2025 09:38:52 -0700
Message-Id: <20250313163903.1738581-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
References: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
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


