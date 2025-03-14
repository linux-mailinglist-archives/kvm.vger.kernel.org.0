Return-Path: <kvm+bounces-41102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4B07A617CD
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:33:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5059175848
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37D292054FE;
	Fri, 14 Mar 2025 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V5vv9LZ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29CE20550D
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973524; cv=none; b=TCCqMUfMiheQ/7Y9KLCzuMLyhSWBHkhkkrWS38kvYqrtw+sO6v1V6AV3OBZB2I+1BcUTV4OUpywRUcJSSxEg0XkdOL8wNXn4C3xMNozt6hYY6kTlE0+daMUPd02jO5HDG1ZFRSnFNFQirFRBPBK0DW4bTAW5DAZg3WoFvhpbnHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973524; c=relaxed/simple;
	bh=UarIdRlI7g0XIPw6CARZE3O+/eSUMq3JBtzD8zpo2Ao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eEHXHOJjoZUeJePkq7yH9aGbP00aZIzk5SFhvKK8tdT9EWLlI/7eqvUgEJut3OLgO9oeD5AQJteiCFN7Ph+2ZdpM+yKz6MlGUxCnVGjTE13ndZQkEQnOFpoMoQFMNtcFC/E1k/eTygg/RrTLnZR1+s3Zu7ayIG1nwRE0DWIYwPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V5vv9LZ4; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-224100e9a5cso48995345ad.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973522; x=1742578322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ipPAyCMNYKQgJ+e1Pj22cNEjWMul6XXi9iVGdQZJ7Rc=;
        b=V5vv9LZ49vrOxYLK3IiuqmwkfdXjo/rdVDrGxjMBQzII5L0h7EEHvQ9jTi2weXVr6m
         /atVoHi0/eq0aZbQ0TBFMuPwh07rQtnpPqQSleFX2r1hmOdJYDAtz+KAG4yusIrfKNgz
         recSQCHjVZO7TPXGzlws4SqpKreMianbxcp4xwet4m2kMSnrO6YM4GNEYNmyjG15e8aM
         vlhJwEt9jW6f8tUa4c4rT049L4sLNN38KbXwmpWFNtitUbEaJ2KrkdMAPelRO7hDiO6n
         x0kSMiQ28tjafMHPDJxF0vVKG1u4Gxpirjmqt4oGaU34yggg6+yFIwl0HewWa+Rzt254
         phfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973522; x=1742578322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ipPAyCMNYKQgJ+e1Pj22cNEjWMul6XXi9iVGdQZJ7Rc=;
        b=SSMrZPgjjOUnoweKSf7yhFhCeVTznSfdChKg7R3KNB/R9rAHEoQX1CmgbA/RbY7JK+
         Bpl7dJmPU1on630D0TGXPQe3B/s1JI6njXK5AYUDpFG8lI+yRlPWfZ7+cgJwwyxWELax
         F2cHkyeprK8aoHEPLJvWLzS8U6m1MkJzuLzpmKS0n39wNM0k3rAm9le1B+aIkm1f0HdX
         qyHe5YPERAuTP6qmVB6xaxaj5voS45Ef4ifIs8Ajo4u6bD/J0BaaBHPlHjc8Iy7NeBFh
         HftL4y3NriINGmJcxP0zNVALr4n5j8CylcKkmmkxdx8K4+ADu0hOdGsXKlIu/RUP1Mhh
         A/xg==
X-Forwarded-Encrypted: i=1; AJvYcCVEKadW0kD7DEPVV+RY40XcfkHrG4GuUM2fTfm/39JHsJ3KYXqEBOM7g1DyWb0Ka9JLZwo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPGQXWkMmy5XT6jD9Qv9B6ecUjM3bMopZYmcr7fWGTTFhEMpxH
	SUKm8W6F//2boJtjO/gmrhyI7iZ2ZDqEYx8Q5q4mb7acOXxAScjgUewrHxxL6lY=
X-Gm-Gg: ASbGncuSiLmoa0NXfvyL1zjgjIStTQiWE5JzA+vYfMRJOmMHtvSHvxZkESrOpBqBoro
	USezbOd3QCsqIJ574IXOSLZok92iFfqM7exournsRVSnrIfkk5WGT28gU2WQgTkKCALF40Ovk0J
	6oaPE7EQ+YS/eAVzlpwU8fgtK4rgECVHiXntiAaorNokPLREmFcQRGZpePZzk1CnjrhfW0J52W4
	2UwNweAG6iEEh/REfcpn+WmvZ+gEQYF5kUU/u59TTjwhO9H9OwCKo0bNKXpRY7PEuw/wyxLlft/
	yIyoLpIeEBXRwPXpllNhbBO6R4HnuxT2dBf3JXfoWMSG
X-Google-Smtp-Source: AGHT+IEtHSmevJ6R5avE3bKBZZosO5sZ+P9hAoOgJtZ8OftQtbIF6mLlVq94OOMFZzJGHDBT5BJrHg==
X-Received: by 2002:a05:6a21:6d88:b0:1f5:7873:3053 with SMTP id adf61e73a8af0-1f5c12ec5b1mr4773946637.29.1741973522470;
        Fri, 14 Mar 2025 10:32:02 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:32:02 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 15/17] include/exec/memory: move devend functions to memory-internal.h
Date: Fri, 14 Mar 2025 10:31:37 -0700
Message-Id: <20250314173139.2122904-16-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only system/physmem.c and system/memory.c use those functions, so we can
move then to internal header.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


