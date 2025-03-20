Return-Path: <kvm+bounces-41610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB2CDA6B0D1
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:31:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16D0C9882AA
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB04122B8BF;
	Thu, 20 Mar 2025 22:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FgLoD7lm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB1922B595
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509822; cv=none; b=jVIZZMqPQiHQjrkAtQQN2Cmhv+hYyP0pTUtfbz/o2O2/uz4uN5QlLc5wSf+GTgA6n2GwwpsI1mPw6jAiCw96jdr3TJYz+jCy+sVTGLybQ09UpkkHYlgVg5zLRgKZ9jeNmwqU+TnsqpxFVBTKqDN1jIkNl3XBGmMe649FQ/M73Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509822; c=relaxed/simple;
	bh=W5N86DrXp2gETwcZLxpX3IR0F9O3pFeoIewYiuj3z1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hGCFKXt+hciNLgbuwVUAMfrTYqLwo+w35K0KR6jNfaf5/e7Bb31ELTxFCBQNIHI/aD2qG4NzVxThGvdGurAzfvvW0pSzpsc6OfLCblFhMea7+Zr9Og/6jh3ZpUouofHqUx0Lpw6I6kEFyF9ArZUdAENq4dwybKNjRVuQHlitXEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FgLoD7lm; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-224171d6826so36973505ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509820; x=1743114620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFqUHpOq6/zm0nogOBs1dNKROVvqoyXbuPu8a/iEMZk=;
        b=FgLoD7lmPy+8Ac29nahbpRITbwx8Jd82mstBKJBSp0MaWck2lkwwrlKEwmb7J3cxf8
         i8S2ijY8+5QZyqECmyjGPOHm2uYcnGNl7hJ38FEImxm/UMg0LW+lgLTd4uF5jEOGbE71
         Ic4mYQ975Xu9d4Yo3C3H3UDAMFAHn1yEekh+SmVPILscoNb7iFRiQW6rysqdDI1g7IZD
         isC1AMQzWIFtjgOsEZU5kTsMq2uMl38l8rbXT/q3rcahUt1FB0LfBEmSVWTUo9na1f9V
         HAiZGYbr/5/dduoUyMeVyu/HXO4rbxK+/Ad3Tz0Xqlc1QR6MB3UBy8xzFsH/Si6X4uUz
         fVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509820; x=1743114620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xFqUHpOq6/zm0nogOBs1dNKROVvqoyXbuPu8a/iEMZk=;
        b=dSQfvDve7fScDVv8GEufTfcNH0j/bjCP6LwQkUjDCw3A/0bAaSsTDH0Tv1RDAe9HdN
         l8NviD8nQFv52Mu5TEilWRO9EejlxvaeS4Qolv4au4a0BNa3VxTTYwqP7WcDsKxreVkJ
         MeihNyIeOO8mAkZjPe9jMY4qJ1IBDt6Uh2Qrf75fZhMXmTdXhNc8BCKbKji2kkPGHawJ
         p+gY/L/be51iy13c4JKNb8UPOe8X1lSmMn210YiR6sZk0gZY5dcERYXCv1+XsiUolJmV
         qbOlKZhw2UOifK71f2OT2Ry+NG+5lTjN/jdydq5miZGSwfWtWPNuG9AmfJsczyqIbBoy
         ejZA==
X-Gm-Message-State: AOJu0YwapyethZZioHTMXauS8aNhP6eShUpHXjzeZ0dv7aqaWjzhYJD+
	NPCPFeIZsFM1EKFTxCU+BixlaSaBF2QtLKmngq5x+dTAU39tE0OMJqK3R+JqvzM=
X-Gm-Gg: ASbGnctSh35T23D+RqsRlmwdqxiJc7/FyUQ3muGK83DxCC7bkchSl/aZfZGpIuhDR2Y
	3DeRD/fcswlFpHRbUXbEiwdLD386GNy3Ee2hG7vpiomXcathzFxSojbTOZ2XdYX//Ug+673NuX2
	d6ayk0/WTo8QrAwhy7cle+FFTEUnyJG7IwQsvuxK9GGjb3gq4RyHmwelTlYfvTv3CLMSCqJCenq
	WmEKFffrovQTzhcW4qGk40wmXgdszRk92j4gh0QogBHjMoEwD5EkIRgiH1oHyObuUqJ7ZkLDwg4
	giLvfryUXzBoZl4DMn0AagwIvdm+PhX/giFvAiow3uhd
X-Google-Smtp-Source: AGHT+IFBKDA1KSEszRYL6pQSK/w5qMFQcOYQFQf+g/w2J4vsHvlcI3/0ADJcw1lVzMWVtNrb1auW7g==
X-Received: by 2002:a17:903:32ce:b0:223:6180:1bf7 with SMTP id d9443c01a7336-22780e1557emr14650115ad.42.1742509820539;
        Thu, 20 Mar 2025 15:30:20 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:20 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 07/30] exec/cpu-all: remove tswap include
Date: Thu, 20 Mar 2025 15:29:39 -0700
Message-Id: <20250320223002.2915728-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h               | 1 -
 target/ppc/mmu-hash64.h              | 2 ++
 target/i386/tcg/system/excp_helper.c | 1 +
 target/i386/xsave_helper.c           | 1 +
 target/riscv/vector_helper.c         | 1 +
 5 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 4a2cac1252d..1539574a22a 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -21,7 +21,6 @@
 
 #include "exec/cpu-common.h"
 #include "exec/cpu-interrupt.h"
-#include "exec/tswap.h"
 #include "hw/core/cpu.h"
 
 /* page related stuff */
diff --git a/target/ppc/mmu-hash64.h b/target/ppc/mmu-hash64.h
index ae8d4b37aed..b8fb12a9705 100644
--- a/target/ppc/mmu-hash64.h
+++ b/target/ppc/mmu-hash64.h
@@ -1,6 +1,8 @@
 #ifndef MMU_HASH64_H
 #define MMU_HASH64_H
 
+#include "exec/tswap.h"
+
 #ifndef CONFIG_USER_ONLY
 
 #ifdef TARGET_PPC64
diff --git a/target/i386/tcg/system/excp_helper.c b/target/i386/tcg/system/excp_helper.c
index b0b74df72fd..4badd739432 100644
--- a/target/i386/tcg/system/excp_helper.c
+++ b/target/i386/tcg/system/excp_helper.c
@@ -23,6 +23,7 @@
 #include "exec/cputlb.h"
 #include "exec/page-protection.h"
 #include "exec/tlb-flags.h"
+#include "exec/tswap.h"
 #include "tcg/helper-tcg.h"
 
 typedef struct TranslateParams {
diff --git a/target/i386/xsave_helper.c b/target/i386/xsave_helper.c
index 996e9f3bfef..24ab7be8e9a 100644
--- a/target/i386/xsave_helper.c
+++ b/target/i386/xsave_helper.c
@@ -5,6 +5,7 @@
 #include "qemu/osdep.h"
 
 #include "cpu.h"
+#include "exec/tswap.h"
 
 void x86_cpu_xsave_all_areas(X86CPU *cpu, void *buf, uint32_t buflen)
 {
diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
index ff05390baef..ff8b2b395f5 100644
--- a/target/riscv/vector_helper.c
+++ b/target/riscv/vector_helper.c
@@ -26,6 +26,7 @@
 #include "exec/page-protection.h"
 #include "exec/helper-proto.h"
 #include "exec/tlb-flags.h"
+#include "exec/tswap.h"
 #include "fpu/softfloat.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "internals.h"
-- 
2.39.5


