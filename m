Return-Path: <kvm+bounces-40549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2ECAA58B55
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:59:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E9A6162BE4
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF301C5F34;
	Mon, 10 Mar 2025 04:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iB/F1b9r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2381D1C54A2
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582735; cv=none; b=L96e8XiKuBnDN6LO21BPNqdYip4tp98I9lBWm8Ly/Z8BsiRW9X6JVEWvzVTomX1C9H5uUskUAcuow/6Vp2ks+wM7/6ihtM2QBLSS09aSSsTyh3T0k10SpCOHYhIgxOt4qfjIVa9T/Qx7eksgoKHpsJiJx9YcjuUjzmrIew5x0vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582735; c=relaxed/simple;
	bh=EHJ4NV86nZgqju0S3FLNfal/v+biiU/OyUthg9HEuSo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=amexvAGmgVoC8s/sYHkhUZoBo0V+LTtReBI1pECVcBJO3BtHNeHzKO6+4R9I6QEErCGzPgA4LSA3fShIg871ZeQojERlSuM7EW3997ZjKAT6nQEudlx6wgqDJCliIpM+aDFsrDlzdZgNMTWFueXyDfJthkBVFCAsaPavc+Cke7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iB/F1b9r; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-219f8263ae0so68330455ad.0
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582733; x=1742187533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGwlDw5fL6/8/4sqaw9ZjtskhrLsqkJfziSvtmiyf9E=;
        b=iB/F1b9rHXZraDpIsztclSKMfo9uPZ537k4+zDO01LV/HTrfPuqnC8nwY/axJMwSo+
         5BFyGfXVwSlaTBQZr/Imly6YdHE5ZgPp1D0XXqrAmn65tn1UuwmWiOW8g0vLMcPke4Kw
         cUE1gnz8LYPzPaxZUiqoihealmU0l3qdEDe7g9hRCefXaBHmOHHYwP4iI6CvgSKW3lRG
         54WDXplFI9kpO3myMNNN2REVuotELkVMM0BmonRAUDbL20NFHqFYUVvV3Z+N/Nfx3SoH
         atdKewqrD+dNJnl3SCEdatMHgRg7Isvrq2KdQVMAp45GWvdd/j6llMb4pWoMiKDY/7b2
         1jSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582733; x=1742187533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OGwlDw5fL6/8/4sqaw9ZjtskhrLsqkJfziSvtmiyf9E=;
        b=eIl0XaFbm+U1J50eozZB8UbXhlYDe93WVOjAeOxDyYYIJ/JgmKnN6SihexxWpv6IEJ
         ssCVFcp4RIfOWxgg0DYFHJoN9SQhlkA4p02denxP6QnOI+qL+l4hm61L3JpMFPhMq7AN
         51lyanbCDgqC+qD8wd5d3tim4UEpLYgzZJm/fAslujGC7LxmF5GNA2PtQwV3IbW0KP/Q
         Mu+HORdIHDYCbhz3hhxjFhLn5nPi0Mi27lHmccS6LRV3lPjThH3ZOiPvgDqEPQLPoQG8
         SY14n1yv3JLhEI3HAOMcMg9ahLHazDBgzddop3XbOqQZJ18hrGoZGfxzXCeg94Tmz2JU
         eX1A==
X-Forwarded-Encrypted: i=1; AJvYcCVq7ZVlYBAsYYY3xfD6t6rSWM3fRrG+YN2wEkiqd+p4/mD/8h46Mf/BOT5TnPr6bf19Y8I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzyu+p0WRUpXpFVKMMULCiwXtKLATpgu2o5J46Ck79p/VsoIx1r
	XLgBKPGo9StVatzJpJMI8PunNdFUm/gI+hmfv0CICaa9NGT1Ayre4Tyu13BIbSc=
X-Gm-Gg: ASbGncvHC4Ly4VqHbprxJeRJzUyqLjGFFN+gCRbcaZmBxOm4vJLUwPPTOeQ+LKrp9yB
	4asu6RsL8JIdpIrrnSZh4LBNQNQSet87G5Efs56xmn6F5u/oJpRgs+iRI9fMnUCty9eM2c5sUuu
	nX5FK5LQUELyKX/bwMxwFkOnG1G36r7WI+DgLHLws35FPTccFoEfouoeMSxblfZ3hlkmPQcfnyV
	dpcSD8nFr+lfeF9OtvXLSV9VM46uaPqLm8xcXZsV3nxiEAIY/RIZdazh8Pc73pa8Ikzex1bUDLY
	UxMCJ1TxtbVhwcN/W5JGX9iF3bz0MzrtUc+hgRhcGrgR
X-Google-Smtp-Source: AGHT+IF9OJp4stFJ9k/lsvOwoQRvqqkA/ZzdxglsajfWtO3On0dbMxz5MT0xvVfYC1mLC7gyZMGdug==
X-Received: by 2002:a05:6a00:13a9:b0:736:3be3:3d77 with SMTP id d2e1a72fcca58-736aaac69ddmr15637676b3a.16.1741582733352;
        Sun, 09 Mar 2025 21:58:53 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:58:52 -0700 (PDT)
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
Subject: [PATCH 03/16] include: move target_words_bigendian() from tswap to bswap
Date: Sun,  9 Mar 2025 21:58:29 -0700
Message-Id: <20250310045842.2650784-4-pierrick.bouvier@linaro.org>
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

This is needed for next commits (especially when implementing st/ld
primitives which will use this function).
As well, remove reference to TARGET_BIG_ENDIAN, as we are about to
remove this dependency.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/tswap.h | 11 -----------
 include/qemu/bswap.h | 12 ++++++++++++
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/exec/tswap.h b/include/exec/tswap.h
index ecd4faef015..cc662cd8b54 100644
--- a/include/exec/tswap.h
+++ b/include/exec/tswap.h
@@ -10,17 +10,6 @@
 
 #include "qemu/bswap.h"
 
-/**
- * target_words_bigendian:
- * Returns true if the (default) endianness of the target is big endian,
- * false otherwise. Note that in target-specific code, you can use
- * TARGET_BIG_ENDIAN directly instead. On the other hand, common
- * code should normally never need to know about the endianness of the
- * target, so please do *not* use this function unless you know very well
- * what you are doing!
- */
-bool target_words_bigendian(void);
-
 /*
  * If we're in target-specific code, we can hard-code the swapping
  * condition, otherwise we have to do (slower) run-time checks.
diff --git a/include/qemu/bswap.h b/include/qemu/bswap.h
index b915835bead..ebf6f9e5f5c 100644
--- a/include/qemu/bswap.h
+++ b/include/qemu/bswap.h
@@ -1,6 +1,8 @@
 #ifndef BSWAP_H
 #define BSWAP_H
 
+#include <stdbool.h>
+
 #undef  bswap16
 #define bswap16(_x) __builtin_bswap16(_x)
 #undef  bswap32
@@ -8,6 +10,16 @@
 #undef  bswap64
 #define bswap64(_x) __builtin_bswap64(_x)
 
+/**
+ * target_words_bigendian:
+ * Returns true if the (default) endianness of the target is big endian,
+ * false otherwise.
+ * Common code should normally never need to know about the endianness of the
+ * target, so please do *not* use this function unless you know very well
+ * what you are doing!
+ */
+bool target_words_bigendian(void);
+
 static inline uint32_t bswap24(uint32_t x)
 {
     return (((x & 0x000000ffU) << 16) |
-- 
2.39.5


