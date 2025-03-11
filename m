Return-Path: <kvm+bounces-40801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83DBEA5D030
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:59:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C68151739E2
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9221E26461B;
	Tue, 11 Mar 2025 19:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="muqHUgVt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6844D264FBE
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723108; cv=none; b=FH5evKjaX63IlR+bXS+UHNDcJa/WAkUXiBx2g22tcVy0qgjIdPB+OOoHIZqQto80LrvLb70rFeroq3m7LbXVCqJjMShRf2K1pCk1ebQdqKtTGABK0VmolIjvXYBHWfsk/NTmnn2NkgSIgzw3wED4v6qfJQJsXFG7Ysq90XfwbKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723108; c=relaxed/simple;
	bh=HWCRrm0GaxX14ykibana2jy+mNovavf3Va2YjCViNUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ilszPbJG6Wd9TgU9+h9t7g00izf2kt1GAljaJ0pR2J9Sf9HIZwqHb2F6o9T1QFzP1tavaL/3KpkaT7iiCDCUC+1y9mi+T0LbHhpcz1kncn89t2ItPMv0tSWOUG6BkURCjLpQs3QqkK4V1kMKKwq7Tu3MChue5lywmZVRMlJjD6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=muqHUgVt; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ff69365e1dso8805977a91.3
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723107; x=1742327907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0vI16NHb2tKWbIxjnq/SoVUTdY/Lep770BkCc47k0Rc=;
        b=muqHUgVtl9QLdlNCJATEelHbxrK8GMjSdGC5PLQGPH1RLg9pz5yJ1io6hGRZy7m0aa
         t9+BJspdtgfPTZlhWAxPE0vpzjxJr8axQTxgTb7dz1CcZbdgSaK6KE6vdtDs+cDBtYQN
         9603wlsCZRhDAay7sYVkYZS0/Tvk2/xE0glm1yDaIX5BPGP2ZdxvpafYi13HFv5pbFb/
         JeiEZpI0rlq0se19WE1qUU175fENPpCLIzxNTcxDHN1S/ze+VuBI0/HP74e8VCFYBJPP
         jkOdIwvJppJpDDrCp/R85IBJGbQLBa08o3WXSNIvpITdFOkLmXNKS021FQvHBGh6et1h
         iLoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723107; x=1742327907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0vI16NHb2tKWbIxjnq/SoVUTdY/Lep770BkCc47k0Rc=;
        b=KGRyWfkVqXlF0NaPBnIcPmTO89Ne1Eik4oqK8T+wKHP6ScKdBjgDJ1lzHIk9EWMdE5
         mCZQut3EVraDczM+EAjtC6eHlnLeYPCfnMQTFARAA1KLl4X4geyN4Rz9hl+XT1tyBmmh
         OpMNLs1zr+B1REcplzdvzSTO93fkmolmmdAOU6HWDZr7pibGUpL6GrMfzz6Xh8TL+YF8
         IZIZB/obr90zp/E/FcVa0TCImxHIMZptb3KDDFNDzLDRAgGTCHgoPzH6c579y7Sq0lZG
         jZsQ8mzx2Z8LtxR6aaOiWIXUWMJSwAe2DUw95nHoOB2MN3WMBb7rED8YrpHMORTyjBgs
         6xAw==
X-Forwarded-Encrypted: i=1; AJvYcCWKyIJGD4ZBw/XBT4BziW61nu8+u8xrz4N0tMLD+6EirL+HnAQoRQCrIZujJRY3imrp21Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YypE+E3Lnchh1ne7PkvuRA10+ZlJ8tWowbROPG8DHNw6dezQ+e+
	/ZxmJO1i2y1RMoOnyA5RhZvudyiIGikv8rGhZ/SOvyVFAU0/2bdYf8ZvPYCk70Y=
X-Gm-Gg: ASbGncsOOnDw89R8tnspwDEtvvA6EgJql41TyQYLpSGMyfwfmURFYO9RErenIM+5Rpg
	+tu3mIS8T1YatSBDjH0UhCVVa4ZAjTSC1PrBQLS2Yf3kZEsr+ebKx+jj9WFJJIvb6CR/nRtGkbu
	I8Gj+OUXpWLxCPc7MEyYM+nDdYFhPiyDBGenuSda6Pk/Ipl7w1zQ+0YA3Mvbn4emL+EI+DVHURC
	qEUYY/JYLhlHGZCja8SnbQGdkd0/ecI1gdVuPDn3kwf4eWrDNb5O+r/4v99QaxWSBzML867z/Py
	wOfHd9tBvlfvVc7YzXTx3IRo0ZnbSaLABdyBAtRlgK66
X-Google-Smtp-Source: AGHT+IH4DZQtwoxJlYICmsHBrM9aJbv4mOOcZipSBsnLFw41tHWuGL9LYWyAZtn5lP/0QysRh7Mo8Q==
X-Received: by 2002:a05:6a00:928b:b0:736:5dc6:a14b with SMTP id d2e1a72fcca58-736aaa1ace3mr27769096b3a.13.1741723106807;
        Tue, 11 Mar 2025 12:58:26 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:26 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	xen-devel@lists.xenproject.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	manos.pitsidianakis@linaro.org,
	Peter Xu <peterx@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	alex.bennee@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 14/17] include/exec/memory: extract devend_big_endian from devend_memop
Date: Tue, 11 Mar 2025 12:58:00 -0700
Message-Id: <20250311195803.4115788-15-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
References: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

we'll use it in system/memory.c.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/memory.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 069021ac3ff..70177304a92 100644
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


