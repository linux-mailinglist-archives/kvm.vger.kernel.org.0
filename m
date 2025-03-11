Return-Path: <kvm+bounces-40802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EF24A5D033
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2B2B177A42
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00DCA25D8F1;
	Tue, 11 Mar 2025 19:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u9+AdiV4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFC9265607
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723110; cv=none; b=BtQjJxe37KNm6WImDpQ5BJpcrodHmAXUMhzKly4+guYIUYM6pFuIvnxHAI4Mp6hHaPxf+VmjW577FezuwJ+989+niVBr9FauqrfN868bW44kmXBsCNxqdG/ZknKcHYfKVmk9HgwGRgBbLD7BaxdPNZgkbx6leavrJgz1DEwbqu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723110; c=relaxed/simple;
	bh=HPmrxLDFV5sbXdh9+wymWgtr8znrI9mCJnuvPobQYz8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qcwbI5c90B87TW/GYTeIWptE/oKaMAbE8wVVnGc/JkVM0VEgs2knoAaTUVZ1d0doJ0sW4vmzgq6eV8c4492pFinmVp4ORO35lIwAkeg4rT+YIbzRcm+KVo55Qij7/4WKx2HdZ0nlRn/wAuLJgoPjaUccMtTtoaWV1GGkNY+8mV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=u9+AdiV4; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22334203781so3544525ad.0
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723108; x=1742327908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/B5foK4Qy0OvFQVWNYpVAAsAF+tVTKpBxl4Jl8CdPFE=;
        b=u9+AdiV4DJEovYEXKjIDLtxVgwFeYFAdtAuM3pq89R3m+boN61rmxE7ezcu24hgufH
         5Ze7z7vBGL66qjl9r5L/3Xl62puFaukjJ9F60A7bFJOVp0BuIFO80C23NQjN9IoiHfjQ
         Q2TM3mf3yxnq+GjieTwFCd8k9uQipaGIcUP8bsD1/nPtzX/WJTCcEH73wYqwxipBBVXC
         RMuejYMDifIsPSEKVCop754wWcN/0AjuaoS89o0PqWvDKNGcUYgVIL3+8TUF6E6OBcSR
         lLwajwLVg8yp5eiZOkYmFWzSFGnoKlaARD6vqoxAF4o+P9H05N4azPb1W6bnvn9hOoAn
         wKBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723108; x=1742327908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/B5foK4Qy0OvFQVWNYpVAAsAF+tVTKpBxl4Jl8CdPFE=;
        b=rIC+u9AR9r+ZQuMmHWOjcG+IGjr9w5ZR7pLn5RggLpP3ZsKg63yAX4YhN8UJAjr9Cx
         HT5A5M/hXrkiu/Ua9FKv/l5BAse0rt8JZ++rkVladwW8dqIgo/fVDvz0vomF1sUUKW3l
         IjYBHwpj+HXzE83YF1u+XUW0/Yjw5aW0xMjJAztE+BzR4HnFqVKDArpmGgqyIuR+wRXY
         gNDQ7SH3ZbweFIt/qWXz3DmoYPondigO2eN/sn1vG/2m/kQH5J0+GW7GTOHOGG62T88n
         PqIcZM1lJjq4GV33fFQWu2Rlwjbru37GFkSLnDD7fSs+tuDY/YIM12Fv+ucZ8Q1UFRrE
         nJQw==
X-Forwarded-Encrypted: i=1; AJvYcCWKs+bbCWLOEtThdguqMxsyzzoOodvu6kpp5DD0ttvNs/WSEs/IOmC5ED0g9TqcbfS9aI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZdWcEE47Id/twVhXXxc2EFxL4T2GkB+9bE6PxlXcj/b5q7fMk
	ilz3Z1GhLMjGay3oJ3kvDHFSk9BTDm47WqvcBH8dqoqpFgJjzYcb3f3Z1JU8euI=
X-Gm-Gg: ASbGncuBQvJ86YOElfqZrUcVjubpmgwz1zm/z+w+Kz+arhu/XrpOg7QMWGjQ+3U9v2S
	A+BdhOWBm3KaCfkwOTYA6cu7ltmpKd6QCOZAigqUgwvYBMaH7UgyPfdGu+7ruC+QEkgLg9ROODZ
	N66ppoWk/aTbh+XyTUfjkL6kdiROP8CsQopbqR/2YmH0Ox1UN6yoDmw2E7gVM5NDQHjkmrLqaba
	Ala15DNAPUlL8TQ1wPvE6wYwsx8ZsAhk0HE7HuVl686V2HOx4wcc+gVwYVN5DqCLj8umpnQBeLR
	ieURse8X4NW2zTEreq82hhjbhAbeG8GYtEpiCabVsDZk
X-Google-Smtp-Source: AGHT+IEFWhkhOunU64h5Vgyk432uXoYWcCQsdf3Qo3RWjfxu/zqVxr3PiSl8C3ffFvP7C/aGeequIA==
X-Received: by 2002:a05:6a00:638b:b0:732:57d3:f004 with SMTP id d2e1a72fcca58-736ec5f1748mr5532672b3a.6.1741723107984;
        Tue, 11 Mar 2025 12:58:27 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:27 -0700 (PDT)
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
Subject: [PATCH v3 15/17] include/exec/memory: move devend functions to memory-internal.h
Date: Tue, 11 Mar 2025 12:58:01 -0700
Message-Id: <20250311195803.4115788-16-pierrick.bouvier@linaro.org>
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


