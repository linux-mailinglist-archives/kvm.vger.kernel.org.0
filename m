Return-Path: <kvm+bounces-9809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F938670DF
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:27:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 148491C2878B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A19A5B668;
	Mon, 26 Feb 2024 10:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HgTiIvLW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4FF5B5DD
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942376; cv=none; b=Vx26uC3uh0pU9UqblowX8KxkQqt+LHvSD4unIIgTXZ39wsjB8+eI2kKF0aLno7LQDXNGe13x9RN8nHMSSBRd1/APdkr+wDRJLSAXXL7epR9EFZfefR4+04+n6zamK5u64oLEey+1ZlRx5TRZmxSdgPxeajrJNM9dXFarp3grxCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942376; c=relaxed/simple;
	bh=jk+0WB+yf2gFpG593dr7QBBKy6NP26w4uMraA6Nb4Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGEPXfgt3YGt2fXAhdqhIgP22hKPEjFdNsdDPcQ1NcxEmTFd0bS0kOuDoRPiTuBFQn+bF1ymPfxdEUvXIJa48pfAsLo+xA9TKuwK0XEaIskI7wuCji84Q/haFahJgmFRpl+WeMbVib9V20eHMHix6rdgx/IPRULwGrrvGYxr1SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HgTiIvLW; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5e42b4bbfa4so2130374a12.1
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942374; x=1709547174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t+TH0Gx+wER6wZOG+8C91ttQiZ2bbMEFLkmm4FPE5oM=;
        b=HgTiIvLWNqrFN1AKa8/EPT+rgLJSLAQ/p2QHIuQd4oD7Y1I2bJl4yDBK/gtbSCs1KJ
         gBnDfXSxZEFHmr5HKAiaSWGZAe5s8Tg5CIQefoI0MHQMUbPzt0nrfjE0JDqb62r+u7+H
         mXmfq8rivioF1Y600SyzpfrgT24pmXlpzVJJ1R3do43mTSMB9uJGuJMNb0xync0QHrk2
         o/wjJYFy+fy8e5kCHjDBu8FcYzta9kdDw/auYPp6pI1V9O/kcgvshtpzXZ8WiLtvaxsZ
         NWpuaTrx1dPQun7MkU5G0sk8WufooWbrlAxH+VQ29zoAGs6pr54xEMYwtW43jBU5s2YH
         sMxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942374; x=1709547174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t+TH0Gx+wER6wZOG+8C91ttQiZ2bbMEFLkmm4FPE5oM=;
        b=WUCrS5e/HLdJNiInb2fq30lNkCfXpFEIUFtGLKvw4nojPs8XgLd34mpBGjpNL2V8l7
         QasEN1HQu9kfkhKqniJLARKuzOrwzLzjWX7OcmPyye1gY1AdJ+X1nksneElsiVVLEQnz
         q3nW01XExKyf7ecdr5FXB9ZEhuQK1YMzjqn769vkgjXcapzNNFyxL6C3bzMhX5yU558j
         TfeIh6+mLY6bJIlL/hQg9wBzCTc+to4e4h58p0AWtCtWd9wmb18BNO3VDUUKAYXdw5qo
         tMYiLCgbdOdO6G6S5XfqhfiM4GQ4Vv9KjNXVkVHtFJ+w1TsxfWxP4LBnGROx7SV6mfy3
         t7Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWDAr4jLWniVoX7WSU8b7ppipswj06lzln9dSi4J3wZ6ivZqHZYWGpNzb/GiM0Mujn+D7NVWCjD2ERqgEKi1RdS2/Ac
X-Gm-Message-State: AOJu0YwBOwF40JvHqnq9H2cL9ZKmW86MRfOCU/7vr+dFXM0V8aFJVvDt
	h4IVx0OR1OehR0UXiez526wEpueRDlIaIcOi6pJakhpi2D9nSZTI
X-Google-Smtp-Source: AGHT+IGgnmShy9Psdns9NLfIW2FKxg/7QLv356Ru6hhwTTmGI2/InSX7WcablTLKCkzUPIq77zvhDQ==
X-Received: by 2002:a05:6a21:2d87:b0:1a0:f614:8480 with SMTP id ty7-20020a056a212d8700b001a0f6148480mr6252719pzb.58.1708942373905;
        Mon, 26 Feb 2024 02:12:53 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:12:53 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 05/32] powerpc: Cleanup SPR and MSR definitions
Date: Mon, 26 Feb 2024 20:11:51 +1000
Message-ID: <20240226101218.1472843-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move SPR and MSR defines out of ppc_asm.h and processor.h and into a
new include, asm/reg.h.

Add a define for the PVR SPR and various processor versions, and replace
the open coded numbers in the sprs.c test case.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/ppc_asm.h   |  8 +-------
 lib/powerpc/asm/processor.h |  7 +------
 lib/powerpc/asm/reg.h       | 30 ++++++++++++++++++++++++++++++
 lib/powerpc/asm/time.h      |  1 +
 lib/ppc64/asm/reg.h         |  1 +
 powerpc/sprs.c              | 21 ++++++++++-----------
 6 files changed, 44 insertions(+), 24 deletions(-)
 create mode 100644 lib/powerpc/asm/reg.h
 create mode 100644 lib/ppc64/asm/reg.h

diff --git a/lib/powerpc/asm/ppc_asm.h b/lib/powerpc/asm/ppc_asm.h
index 46b4be009..52a42dfbe 100644
--- a/lib/powerpc/asm/ppc_asm.h
+++ b/lib/powerpc/asm/ppc_asm.h
@@ -2,6 +2,7 @@
 #define _ASMPOWERPC_PPC_ASM_H
 
 #include <asm/asm-offsets.h>
+#include <asm/reg.h>
 
 #define SAVE_GPR(n, base)	std	n,GPR0+8*(n)(base)
 #define REST_GPR(n, base)	ld	n,GPR0+8*(n)(base)
@@ -35,11 +36,4 @@
 
 #endif /* __BYTE_ORDER__ */
 
-#define SPR_HSRR0	0x13A
-#define SPR_HSRR1	0x13B
-
-/* Machine State Register definitions: */
-#define MSR_EE_BIT	15			/* External Interrupts Enable */
-#define MSR_SF_BIT	63			/* 64-bit mode */
-
 #endif /* _ASMPOWERPC_PPC_ASM_H */
diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index fe1052939..e415f9235 100644
--- a/lib/powerpc/asm/processor.h
+++ b/lib/powerpc/asm/processor.h
@@ -3,18 +3,13 @@
 
 #include <libcflat.h>
 #include <asm/ptrace.h>
+#include <asm/reg.h>
 
 #ifndef __ASSEMBLY__
 void handle_exception(int trap, void (*func)(struct pt_regs *, void *), void *);
 void do_handle_exception(struct pt_regs *regs);
 #endif /* __ASSEMBLY__ */
 
-#define SPR_TB		0x10c
-#define SPR_SPRG0	0x110
-#define SPR_SPRG1	0x111
-#define SPR_SPRG2	0x112
-#define SPR_SPRG3	0x113
-
 static inline uint64_t mfspr(int nr)
 {
 	uint64_t ret;
diff --git a/lib/powerpc/asm/reg.h b/lib/powerpc/asm/reg.h
new file mode 100644
index 000000000..6810c1d82
--- /dev/null
+++ b/lib/powerpc/asm/reg.h
@@ -0,0 +1,30 @@
+#ifndef _ASMPOWERPC_REG_H
+#define _ASMPOWERPC_REG_H
+
+#include <linux/const.h>
+
+#define UL(x) _AC(x, UL)
+
+#define SPR_TB		0x10c
+#define SPR_SPRG0	0x110
+#define SPR_SPRG1	0x111
+#define SPR_SPRG2	0x112
+#define SPR_SPRG3	0x113
+#define SPR_PVR		0x11f
+#define   PVR_VERSION_MASK	UL(0xffff0000)
+#define   PVR_VER_970		UL(0x00390000)
+#define   PVR_VER_970FX		UL(0x003c0000)
+#define   PVR_VER_970MP		UL(0x00440000)
+#define   PVR_VER_POWER8E	UL(0x004b0000)
+#define   PVR_VER_POWER8NVL	UL(0x004c0000)
+#define   PVR_VER_POWER8	UL(0x004d0000)
+#define   PVR_VER_POWER9	UL(0x004e0000)
+#define   PVR_VER_POWER10	UL(0x00800000)
+#define SPR_HSRR0	0x13a
+#define SPR_HSRR1	0x13b
+
+/* Machine State Register definitions: */
+#define MSR_EE_BIT	15			/* External Interrupts Enable */
+#define MSR_SF_BIT	63			/* 64-bit mode */
+
+#endif
diff --git a/lib/powerpc/asm/time.h b/lib/powerpc/asm/time.h
index 72fcb1bd0..a1f072989 100644
--- a/lib/powerpc/asm/time.h
+++ b/lib/powerpc/asm/time.h
@@ -3,6 +3,7 @@
 
 #include <libcflat.h>
 #include <asm/processor.h>
+#include <asm/reg.h>
 
 static inline uint64_t get_tb(void)
 {
diff --git a/lib/ppc64/asm/reg.h b/lib/ppc64/asm/reg.h
new file mode 100644
index 000000000..bc407b555
--- /dev/null
+++ b/lib/ppc64/asm/reg.h
@@ -0,0 +1 @@
+#include "../../powerpc/asm/reg.h"
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 285976488..a19d80a1a 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -23,6 +23,7 @@
 #include <util.h>
 #include <migrate.h>
 #include <alloc.h>
+#include <asm/ppc_asm.h>
 #include <asm/handlers.h>
 #include <asm/hcall.h>
 #include <asm/processor.h>
@@ -120,25 +121,23 @@ static void set_sprs_book3s_31(uint64_t val)
 
 static void set_sprs(uint64_t val)
 {
-	uint32_t pvr = mfspr(287);	/* Processor Version Register */
-
 	set_sprs_common(val);
 
-	switch (pvr >> 16) {
-	case 0x39:			/* PPC970 */
-	case 0x3C:			/* PPC970FX */
-	case 0x44:			/* PPC970MP */
+	switch (mfspr(SPR_PVR) & PVR_VERSION_MASK) {
+	case PVR_VER_970:
+	case PVR_VER_970FX:
+	case PVR_VER_970MP:
 		set_sprs_book3s_201(val);
 		break;
-	case 0x4b:			/* POWER8E */
-	case 0x4c:			/* POWER8NVL */
-	case 0x4d:			/* POWER8 */
+	case PVR_VER_POWER8E:
+	case PVR_VER_POWER8NVL:
+	case PVR_VER_POWER8:
 		set_sprs_book3s_207(val);
 		break;
-	case 0x4e:			/* POWER9 */
+	case PVR_VER_POWER9:
 		set_sprs_book3s_300(val);
 		break;
-	case 0x80:                      /* POWER10 */
+	case PVR_VER_POWER10:
 		set_sprs_book3s_31(val);
 		break;
 	default:
-- 
2.42.0


