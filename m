Return-Path: <kvm+bounces-40550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC521A58B56
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:59:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECA1E16702A
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B721C831A;
	Mon, 10 Mar 2025 04:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nnCzdkw8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3AA1C5D79
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582736; cv=none; b=ufUx9Y2/G56DNHUTS58UNKHGcD8tQS2Y49cPHqgvAgvT2Mpxx82mpst2vKOkHirJ8kgRNy92Z+iGh9ekxtyh/4QPYwtxoc79kE4G+tXoDP8HRId480BAGeNgMZEgaN7wevtKCCIgbBIC91sGTYlJgBNfTEVUaRBd9LSFadqUDrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582736; c=relaxed/simple;
	bh=KhEtYNhp/u6iU7U6n40EuuECOZ4DyErr8zAEkm44y1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UbBk3Y6Cye+GxDpV2epBqbNS7W39VzMr3YLDQtAyqmvbjJKE6epSu8CrFp0UqPJ7JpbavpRay7pzFicPzZQQ0d1urVQlCe2KgQGGpyVQwgBBDXyr5XaVC+vENKTVEX/jnLKw4sZtv2zK7CaeUVOIT0DdBxFmqCgBVAZHJH8z2rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nnCzdkw8; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22337bc9ac3so70486795ad.1
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582734; x=1742187534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S8ktbxqhQcYI9crAlIF4CNR4KDCM1LZDZwDTggcCVc4=;
        b=nnCzdkw8FyS3CMkTni2HVGupjSieuQ21CLPaC9HSXr+ludagSHOsDmkxMJDOmW81Dt
         V9xwUVlMY51QXjGqirYXS1bLV8R8+u6GFWTf3GiuV85rU55Tcqv/TJz68M4fWz+e+0us
         M+ozyVsQNxejkjjn81d6Y4w9wgZ8nzCMc92fUJO/+6seZ59S/SOmCwJVZgK0UnlgXW5w
         pWdCR17EmkQ7wAGQR86rjiVrCYT8ES1Ax0JCCIjvPyMOEz6eu06onc7hhlfebjkJMH64
         aAnRRbSDYYOSRme3cYdmHX1YUG8RV2xRTt/sXbqh5JA+xETk9JZZ7BOc6Wl6FWMnjKfd
         USbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582734; x=1742187534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S8ktbxqhQcYI9crAlIF4CNR4KDCM1LZDZwDTggcCVc4=;
        b=XHcEn9MeZJM0yFOShsE8LkOYtopnyPJG3t58sPorn4oFRV4f0JN+IAWHOtP+weHVLv
         mEVcqIhbOk5O3Ou6YVkp759cxumq/5Z8cJXx6u1O+hUuWOhaMSJWJ0S5q8HB32V32Fm4
         YgWoxZQ5fyne2E36PThnzk+xxxMgKN1j1aZb7sEyU6TPfotBTzHlv9gdzAB91OO4trGa
         QtWnrfM61HvyuNkH9kbRldyKAWgefJRBcY9d5NMWYUCoczLnf1RUXIJ1y79kLD7THM0R
         c8ha6EDl72j9/QHndYs6TxFzmVOMmft0ecyAPl3AzHWqge0VgG8jI6sfYekSXH9hoi0N
         qN8w==
X-Forwarded-Encrypted: i=1; AJvYcCUYP0jq8EOAv3NNpmGsdqFObVUv5JR93/8dWqDkG1dxEjwZiaBGhrtRONyXub5HG6UbXw8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfzWVpaX3f4W4M2+3LM/wo0yReOR6uzatsCqpi5aodxTj+SvDL
	8Xvd3xONE7JxWPbXoCY9mufzLdd4NDSJ64icAlo6vG/ifCXOEs3PU7iaIlDTiXc=
X-Gm-Gg: ASbGncudj1qP4h//Vk5owcDZ3gmGcbU/0X6nyaI1r1NsloIqcYOQspdNz/HN2aevPlI
	NIMZU42D2B6GtkztHr7FPYeuVlykrpZXclNXv0fXdJVXOB5dr9MekD0W9X+lv826Z+WICO5SIzY
	T4+StBbYdxyHUu4JVtR3wnghGs5flgur8e6qR3otHdFd6TwTJP7uvy1kYITUIjKWxJsCcSlnXV0
	6oyZ7RlK+NHwWwlLJ8PPfLXPN5cZY8/bezN37idWY0RQ8rjpinDA/2s+OxFQiZyJTu9ZKk1rkCY
	s+PNhGt3p9gzXnd11CZaShgTxCgzC7VpN9u3HqZtPNiU
X-Google-Smtp-Source: AGHT+IHkXXNzkEnz2BccPlbhHJNUY3LGOIbmL0i4gzfHTIIx3yoWhp8OGUsmgyQKBXK356JOEhoSQw==
X-Received: by 2002:a05:6a00:2493:b0:736:ab48:5b0 with SMTP id d2e1a72fcca58-736ab48061fmr14740098b3a.2.1741582734610;
        Sun, 09 Mar 2025 21:58:54 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:58:54 -0700 (PDT)
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
Subject: [PATCH 04/16] exec/memory.h: make devend_memop target agnostic
Date: Sun,  9 Mar 2025 21:58:30 -0700
Message-Id: <20250310045842.2650784-5-pierrick.bouvier@linaro.org>
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

Will allow to make system/memory.c common later.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/memory.h | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 7c20f36a312..698179b26d2 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -3164,25 +3164,23 @@ address_space_write_cached(MemoryRegionCache *cache, hwaddr addr,
 MemTxResult address_space_set(AddressSpace *as, hwaddr addr,
                               uint8_t c, hwaddr len, MemTxAttrs attrs);
 
-#ifdef COMPILING_PER_TARGET
 /* enum device_endian to MemOp.  */
 static inline MemOp devend_memop(enum device_endian end)
 {
     QEMU_BUILD_BUG_ON(DEVICE_HOST_ENDIAN != DEVICE_LITTLE_ENDIAN &&
                       DEVICE_HOST_ENDIAN != DEVICE_BIG_ENDIAN);
 
-#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
-    /* Swap if non-host endianness or native (target) endianness */
-    return (end == DEVICE_HOST_ENDIAN) ? 0 : MO_BSWAP;
-#else
+    if (HOST_BIG_ENDIAN != target_words_bigendian()) {
+        /* Swap if non-host endianness or native (target) endianness */
+        return (end == DEVICE_HOST_ENDIAN) ? 0 : MO_BSWAP;
+    }
+
     const int non_host_endianness =
         DEVICE_LITTLE_ENDIAN ^ DEVICE_BIG_ENDIAN ^ DEVICE_HOST_ENDIAN;
 
     /* In this case, native (target) endianness needs no swap.  */
     return (end == non_host_endianness) ? MO_BSWAP : 0;
-#endif
 }
-#endif /* COMPILING_PER_TARGET */
 
 /*
  * Inhibit technologies that require discarding of pages in RAM blocks, e.g.,
-- 
2.39.5


