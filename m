Return-Path: <kvm+bounces-49388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB8FEAD8394
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 09:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03649188F53F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 07:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4438625BEFF;
	Fri, 13 Jun 2025 07:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="rV0sFP99"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEB223BCFA;
	Fri, 13 Jun 2025 07:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749798156; cv=none; b=ulxb4F3EyFsdpsV1sq/D9TinR157vNDsnsk5B0qIAKrjCPLFrkWZbzLfnBb24lHC928LlI8YKRhEuUrKzrYN4iERherlz6wa799CfhtiuwYOBlWuQYXq50fytAxDs9yUNxWBJEIMT//tvnvWJJrf9RweiQ0HkGc+xBOZu78ZlPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749798156; c=relaxed/simple;
	bh=ltVbWKdp4DNpHzXVNw3+MB5ULknr9pNf5MvYKJzoQyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwA6tdvpGCkpaC2+9yrmmXw1QYRF9a+CZwyCMGNZlipRSzXQHxLcDGCCSRxM4X1vubsrbNIRl0HykYToJxaBP3FCV5nl3PeaY+Iwm/+JspTdONoOMKbPnOPL4FK6SZ1nMfk9zQZe1WyDS58WB9/1209gSQjm+MMvnVIpH4zcGcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=rV0sFP99; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55D71IfK3694425
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 13 Jun 2025 00:01:27 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55D71IfK3694425
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749798088;
	bh=A+vPN59zu4m9DqxX0uRBCuVc8EfPKFC1N0BKvoJm7i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rV0sFP99OpLiFrEQlGIwEw1RgSRjo1TqUmVdfXjHXv20jMyZuMjHyL2Sia6jl8P7q
	 u38ry0XqoeSgIikuuYwfix6ToP4XQ8r+FHsidkGMF7SB8e0fwmScoLVCZS1qHsLJnc
	 QUVbXQ5JA6xBqOB57EOIlCSH5L3lkrdCAzOvY2fDOhwooKZMeCcZmh8V//eRT0DOhH
	 Gub1Zp0FMwnwfUtxdT7ZLwIOzya3Hf2d/HfrIUiO9TZ6DfqECUn/yuBcfhuLjIcS15
	 G1wEFl0QSv9Az8XrrZInVAxa6NGLbL1rCkGg906cLkVJCB9gmi0v+p6I9swxZFnmlo
	 N7y6FPqdtJxWw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        brgerst@gmail.com, tony.luck@intel.com, fenghuay@nvidia.com
Subject: [PATCH v1 1/3] x86/traps: Move DR7_RESET_VALUE to <uapi/asm/debugreg.h>
Date: Fri, 13 Jun 2025 00:01:15 -0700
Message-ID: <20250613070118.3694407-2-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613070118.3694407-1-xin@zytor.com>
References: <20250613070118.3694407-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move DR7_RESET_VALUE to <uapi/asm/debugreg.h> to prepare to write DR7
with DR7_RESET_VALUE at boot time.

Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/coco/sev/core.c             | 1 +
 arch/x86/coco/sev/vc-handle.c        | 1 +
 arch/x86/include/asm/sev-internal.h  | 2 --
 arch/x86/include/uapi/asm/debugreg.h | 2 ++
 4 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index b6db4e0b936b..d62d946bbbb7 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -24,6 +24,7 @@
 #include <linux/io.h>
 #include <linux/psp-sev.h>
 #include <linux/dmi.h>
+#include <uapi/asm/debugreg.h>
 #include <uapi/linux/sev-guest.h>
 #include <crypto/gcm.h>
 
diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index 0989d98da130..ad4437a61f61 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -17,6 +17,7 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 #include <linux/psp-sev.h>
+#include <uapi/asm/debugreg.h>
 #include <uapi/linux/sev-guest.h>
 
 #include <asm/init.h>
diff --git a/arch/x86/include/asm/sev-internal.h b/arch/x86/include/asm/sev-internal.h
index 3dfd306d1c9e..8fc88beaf0d7 100644
--- a/arch/x86/include/asm/sev-internal.h
+++ b/arch/x86/include/asm/sev-internal.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
-#define DR7_RESET_VALUE        0x400
-
 extern struct ghcb boot_ghcb_page;
 extern u64 sev_hv_features;
 extern u64 sev_secrets_pa;
diff --git a/arch/x86/include/uapi/asm/debugreg.h b/arch/x86/include/uapi/asm/debugreg.h
index 0007ba077c0c..d16f53c3a9df 100644
--- a/arch/x86/include/uapi/asm/debugreg.h
+++ b/arch/x86/include/uapi/asm/debugreg.h
@@ -28,6 +28,8 @@
 #define DR_STEP		(0x4000)	/* single-step */
 #define DR_SWITCH	(0x8000)	/* task switch */
 
+#define DR7_RESET_VALUE	(0x400)		/* Reset state of DR7 */
+
 /* Now define a bunch of things for manipulating the control register.
    The top two bytes of the control register consist of 4 fields of 4
    bits - each field corresponds to one of the four debug registers,
-- 
2.49.0


