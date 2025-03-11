Return-Path: <kvm+bounces-40735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B532FA5B7DD
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:10:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 758311896418
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D77E122173F;
	Tue, 11 Mar 2025 04:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nK1Guq36"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94399221554
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666155; cv=none; b=n1ZsxGfVmQyNiQLlq7RqdOMAFtQEaNd5vq6UmG8mG09EJIPKRTzX1W+wExOvVA9CPXZ5M23Qzv9LCnUtH3L2NbgU0OSkPttB4Vd538Sb0JKP2hjADgirGodhCEbVp9pDzEYO++0WTivQFrCTF1A7UcipYNLVLgYCJudIhC5qCs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666155; c=relaxed/simple;
	bh=GpHc/7gbu8WRAFUJRiCsLUN6noN1HCb2LT8LwfgVre8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oMQEMll9pfo/nYqt8w0ixd/3hvJfROMvctRPGsRy9F6oDYizrcxAC7tGBlrZFyhT3ZqjI9KA/pql8ytyePKeptrVfGdOR3/KE6blCBmBZr+6zxCej/vINLoy+wZ8mUxUPBuni7PrSZPWqoKlkEh72wtUoVn9rgzUkQGZGuh4zH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nK1Guq36; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2fa8ada6662so10526050a91.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666153; x=1742270953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LEAQ9wvxViIwfRRF7MZBxVkXSE0tKicEinIFunB945A=;
        b=nK1Guq36HVXvpHIQ87xNAzeczKtAQQfAxGh2Qt0ChAIAjI4dq0tR+jy+MGqWP3wPol
         3Z4KN302HkX6lONN8AO50iAZLDPsD5XSygt/wRRLAMgK8VmrmJF7KDNBG/hQzSqrjkJJ
         wsZ7x3dSXsUD7JE75Vx62dhNu4ue9ZhT/XZaqHzIOKPyda66iV7XRBJaNMjs+8GlGLqj
         URcKIJLW2RS4i6xTS292gisWBGG3vaED+GGBueneYSA/ScV6evvVaT3+LQjmG7WxHqTV
         4lnQTWUrxqyuubiDPHiDPK6/EkWqjcY7D3IHrzgYIug/EbhEfbD43Lx3+raf1VNQQRm5
         EQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666153; x=1742270953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LEAQ9wvxViIwfRRF7MZBxVkXSE0tKicEinIFunB945A=;
        b=Q9nisukk10uTUJ7+xiLu0Aom0ZU/26G+jonVB4pQW22fClpdE27i7FQ6X3n9zBsTPW
         eo61aa6o4YcCTNkZMrztycrdPMnWhJlsWJP1r2Crjw3ti8wZBkYoFkAWchLddlWuGbDX
         EJDzqRlGmWt2X3gzxflGPgYJiDniRwqjtt61m+thMoOu7gqRTB7pHUPEAwvKa4vzcpP+
         qAmg3se55GgOqWN4wKyciA/IxLgf0wk3/83KO5cXJMbc+t6XG08KGyz78xUEm5tKp9f7
         LLib7Bzjh6+EEqcbyHT5i+Qljw2JkxZnbI0aXfm03PLeF+lJMdQzXndiNL3PVL65rrzI
         oxLw==
X-Forwarded-Encrypted: i=1; AJvYcCVwbS+Gd5yk+E2Un8KOQKmqxzWRgC14ITiaeD1CK7hF1dJD4TKoNOvvQ4QWPYp7ja338e8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgvrixpURe5dNuHqnj92vxnCMn5aWQt/tStlvQZFPr4+nGEoyX
	hoF8wdoPLnhAWDz+ISIdLtG0yrb8kPhrOTaju8WdMCyq+JcjH0V/qqevE0XAszc=
X-Gm-Gg: ASbGnctVrxe72R40BBi1Jgs2BKvyXtUMz6U7dwIZbD+hmicw435LO9J7TxO4hR9rkjj
	eHQw2K7Y+ww0hbeRpNLQDDlLF7QZBz2riLGrC/GCmhNC5r+mfvqzhmKojfrAnPrEwAV4DMxlIwe
	1BPMH9oipMd7JpdFEoHKLWNb03FS5AF2eCdzFO7wBjAaP9h+rs+XP+sF2jr3jpUgK4Ca36TAkMq
	0U1Wv63HywjlyQjX8xf4uuGYz+fRSmqQxIhytm2JZ5wSseCdp2FLbQ0zDZjiKLcy15zslT4tAyL
	bbcFnKHuyagmM6FBLAYuYMjF71TzvUhE8ydp9nyqx5Js
X-Google-Smtp-Source: AGHT+IEEBIqVh4ZJ8rHFVsra/zLBqrrO/2Z7wqCz/tbRxr6Sh6SkveOkvqyI/KznC/OO1HDpbbusNw==
X-Received: by 2002:a05:6a21:4d17:b0:1f5:6e71:e55 with SMTP id adf61e73a8af0-1f56e71100cmr14244196637.6.1741666152825;
        Mon, 10 Mar 2025 21:09:12 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:12 -0700 (PDT)
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
Subject: [PATCH v2 14/16] include/exec/memory: extract devend_big_endian from devend_memop
Date: Mon, 10 Mar 2025 21:08:36 -0700
Message-Id: <20250311040838.3937136-15-pierrick.bouvier@linaro.org>
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

we'll use it in system/memory.c.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/memory.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 60c0fb6ccd4..57661283684 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -3138,16 +3138,22 @@ address_space_write_cached(MemoryRegionCache *cache, hwaddr addr,
 MemTxResult address_space_set(AddressSpace *as, hwaddr addr,
                               uint8_t c, hwaddr len, MemTxAttrs attrs);
 
-/* enum device_endian to MemOp.  */
-static inline MemOp devend_memop(enum device_endian end)
+/* returns true if end is big endian. */
+static inline bool devend_big_endian(enum device_endian end)
 {
     QEMU_BUILD_BUG_ON(DEVICE_HOST_ENDIAN != DEVICE_LITTLE_ENDIAN &&
                       DEVICE_HOST_ENDIAN != DEVICE_BIG_ENDIAN);
 
-    bool big_endian = (end == DEVICE_NATIVE_ENDIAN
-                       ? target_words_bigendian()
-                       : end == DEVICE_BIG_ENDIAN);
-    return big_endian ? MO_BE : MO_LE;
+    if (end == DEVICE_NATIVE_ENDIAN) {
+        return target_words_bigendian();
+    }
+    return end == DEVICE_BIG_ENDIAN;
+}
+
+/* enum device_endian to MemOp.  */
+static inline MemOp devend_memop(enum device_endian end)
+{
+    return devend_big_endian(end) ? MO_BE : MO_LE;
 }
 
 /*
-- 
2.39.5


