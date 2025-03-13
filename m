Return-Path: <kvm+bounces-40964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B4BBA5FC12
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BC203BC598
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25A626AA88;
	Thu, 13 Mar 2025 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sVbroHHT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C3F269B1C
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883971; cv=none; b=j3TdnTKdwMvxUMecfmE/yntUitxYAHPyWY/JwzJqnhjZRgieXgroSE2e8J6R5tvt+XxL/IROQbqFI08Hbc4TfIwznN1Yw40vGBZRNvFIAfW4VL9kebIEneFWFZ9K+DmjBoVZQl3kQs7aVZsGnrfd3adrJbOoC6Bca+ywdBM8vC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883971; c=relaxed/simple;
	bh=HPmrxLDFV5sbXdh9+wymWgtr8znrI9mCJnuvPobQYz8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F4MuaGktkrH+ihcawNJQ1SAMkmIZSITLEQPYvKFTlXDqw6f3OQVRv+aECeDy1Q3a8vL4/HM/10mcWU4GMwemCYp9AUOgGtLMDmwvfN7xDbdxm7IZRz1N18T1ADiP3+e/VfX48onytnGuOWZBKFdvT/ialdjbGhPc+7U+Z5r9J5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sVbroHHT; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2ff6a98c638so2662423a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883969; x=1742488769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/B5foK4Qy0OvFQVWNYpVAAsAF+tVTKpBxl4Jl8CdPFE=;
        b=sVbroHHTI+j9lW5nfMAqmzftbnwspS/fXKplWosDlhtUrITPmedZ5Xkv+oKp4QkCpX
         OeN1Nk5bCJz/VEqgUfMToHpIszrjqmH/rsK2yDo11tGVDkfm7FmK4qJTZDyZZHbv3bWy
         Pj0oHy4xyWsEiw7yW0OUMEFfh4MMdl4C2pRJTr8S4LmknA84SWitIa1q7Z45EyYZYHR0
         /2H89iQtmx1DqWba7umlBNJCEoO6WrfZUO73LaxJ3m3TfsE0iGGJf4K7MpviX8AuGkUU
         /Zcn0VH2ayXddSVicfx7VVZXVVQhETGPwFCQECyUE8RzWpFDxyINk3kWU3KaUd0vDc/6
         a6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883969; x=1742488769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/B5foK4Qy0OvFQVWNYpVAAsAF+tVTKpBxl4Jl8CdPFE=;
        b=nY91xtvC8Yy4fTp4zoe02T/TxRhduEgyQi2iD1Ong8C/ZxU2DzK2lit07hmQrpGvJ4
         I67RW/pit7ET29piV468uuuiv4VHeuDct1bF8128X+sK6mtllDYMunhwU+bhxr/e3b2I
         BRC+nzgjdatvQfNZuF+Vusb5jJOKeYi/trx2/WM6JS4YccZuBC0KGqI4cMOtYnnvqxtb
         w0XGGTSv3LhdW2lc931Matf0cC5BRkt8lajG69we5+PM+w/607KHv0x4o7zy7xHrX8F2
         sNB4xoGFqUDANErXMkcOr07iJui9TDC9eRErC/WZsuMrXUDuGyfm9K3xAICcaRnhiR+f
         n8lg==
X-Forwarded-Encrypted: i=1; AJvYcCWZyrjuhus2ZkoUU8Mj+ZoGCYRY9P3LiO/c934X4nkDAA71SWfJIYgal9YwyeBrunp4Cbk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/5cqItwOWvIY7Tomp7Gyu0rT7vCg8jObmY/MKYUQ/72mv6o5u
	8DXhpcHe+JeHeLSv/2RbUqz3+5Sw9Gi1vpDnc+I/BB03/2roQJDvcBfYC8GvMRM=
X-Gm-Gg: ASbGncuY9ILIj3pUz2QWW5gD0cc7+VoCJeVoHi1M77Ago9CnZwrk3Aazl/x2zRptCa6
	YpVueFV+PvS3wFbQ9tCTCI4GDMrArWl+JV07BZPIL1QVr+f/uccpTa/Cyt4FGqA4bsSnQu/qi9H
	SrrXnpS6MDYGIlX9rDOty5q9TtinGBhKpeJUFvjTjUmEIDgLdPT3i1k2Ya/pkmAA5QUafyRL1Zv
	acWtWno4+ZYe4MF2v2GV8UGj50tjI0I2szU073BD9MFDR9W9iJ49THD0OjmTru0ZqPmGwCYb1jG
	+cPSBfel79GY9snBT/fOEDVjmOb4UJYrAk28XOcJoicr
X-Google-Smtp-Source: AGHT+IE6Us2O77TYYfj/J/RmRU6RhpFIbMCr45wvgkThs0nxBWSPhVRimj63yvMeVhIF4wJ+N9MdKw==
X-Received: by 2002:a17:90b:3bc6:b0:2ff:58b8:5c46 with SMTP id 98e67ed59e1d1-3014e82fd9amr271511a91.8.1741883968719;
        Thu, 13 Mar 2025 09:39:28 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:28 -0700 (PDT)
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
Subject: [PATCH v4 15/17] include/exec/memory: move devend functions to memory-internal.h
Date: Thu, 13 Mar 2025 09:39:01 -0700
Message-Id: <20250313163903.1738581-16-pierrick.bouvier@linaro.org>
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

Only system/physmem.c and system/memory.c use those functions, so we can
move then to internal header.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/memory-internal.h | 19 +++++++++++++++++++
 include/exec/memory.h          | 18 ------------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/include/exec/memory-internal.h b/include/exec/memory-internal.h
index b729f3b25ad..c75178a3d6b 100644
--- a/include/exec/memory-internal.h
+++ b/include/exec/memory-internal.h
@@ -43,5 +43,24 @@ void address_space_dispatch_free(AddressSpaceDispatch *d);
 
 void mtree_print_dispatch(struct AddressSpaceDispatch *d,
                           MemoryRegion *root);
+
+/* returns true if end is big endian. */
+static inline bool devend_big_endian(enum device_endian end)
+{
+    QEMU_BUILD_BUG_ON(DEVICE_HOST_ENDIAN != DEVICE_LITTLE_ENDIAN &&
+                      DEVICE_HOST_ENDIAN != DEVICE_BIG_ENDIAN);
+
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
+}
+
 #endif
 #endif
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 70177304a92..a3bb0542bf6 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -3138,24 +3138,6 @@ address_space_write_cached(MemoryRegionCache *cache, hwaddr addr,
 MemTxResult address_space_set(AddressSpace *as, hwaddr addr,
                               uint8_t c, hwaddr len, MemTxAttrs attrs);
 
-/* returns true if end is big endian. */
-static inline bool devend_big_endian(enum device_endian end)
-{
-    QEMU_BUILD_BUG_ON(DEVICE_HOST_ENDIAN != DEVICE_LITTLE_ENDIAN &&
-                      DEVICE_HOST_ENDIAN != DEVICE_BIG_ENDIAN);
-
-    if (end == DEVICE_NATIVE_ENDIAN) {
-        return target_words_bigendian();
-    }
-    return end == DEVICE_BIG_ENDIAN;
-}
-
-/* enum device_endian to MemOp.  */
-static inline MemOp devend_memop(enum device_endian end)
-{
-    return devend_big_endian(end) ? MO_BE : MO_LE;
-}
-
 /*
  * Inhibit technologies that require discarding of pages in RAM blocks, e.g.,
  * to manage the actual amount of memory consumed by the VM (then, the memory
-- 
2.39.5


