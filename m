Return-Path: <kvm+bounces-41303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E370A65CCB
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:36:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F7961897C40
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1175F1F582A;
	Mon, 17 Mar 2025 18:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tFmp2wSD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A444F1F5848
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236485; cv=none; b=nq/eWWYiP/btZmQM/4gpB0SZC8OYRG6YJl45MUJ3KdSc6wzg0BBmExV+XfBMES8C43mgpte5gJfJWs/yECrVfbOzHoqXexITSKNAPo0ShNmijrx6beOYuBwZvtQgGCTft/0L8Aq1bbrZL1EF9Z8lI57AW55R/xSdn+QndrFKrck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236485; c=relaxed/simple;
	bh=UarIdRlI7g0XIPw6CARZE3O+/eSUMq3JBtzD8zpo2Ao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BAQK4HSWtmq4oCpIovilZjv7qO9wk/3K2lIzPJRn8wNjvvsg/hLjoBfwr0ZNho88lOsBdSYDHrtrZ1LAIir/8gyB3Q3mr9jrASMPcDpMV4p0PJvA/XBS3gEpp2zKL9xY01Dlc4Tyw902VI+Nzfix6LSbeHI9VOhx6VmvzSCtfeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tFmp2wSD; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2255003f4c6so82571535ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236483; x=1742841283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ipPAyCMNYKQgJ+e1Pj22cNEjWMul6XXi9iVGdQZJ7Rc=;
        b=tFmp2wSDw0fx4WEBIkdnurrfAvmsv50VGAHE8mpkIOrKhlYgUF8LXpOcVwT2e1CfOU
         5GiU7Jsgrjerc/rLzdZa2RoCJfc5NSoMbnpghMa0A/MNU70U9VRPGyaovUUbqv6YCon/
         M+qhLLFpTiQdjyXZaDV1N7ZHkEMTGg0RbDTrSwrEbnoGWLzkv6l4tPUgZrW0WyxQBXUS
         wd1EULEuXpfsbX2Tdk3G1KB6/ffBSGp7MpRTzWjvAq+bTCxNqQMA+gXKd6a+Tkh/gKYJ
         1mCMCB+wZ47yHXEJkcdih+Ke/PZ8ajIMR1MTvxyD9ID9Vt/zEpRNj/BhXrxBIHjcyh1O
         CutA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236483; x=1742841283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ipPAyCMNYKQgJ+e1Pj22cNEjWMul6XXi9iVGdQZJ7Rc=;
        b=PzHkFpZ9JSqu47uXKoi3tSWmALoHc1kJPU2IyLnQ1eohjX+XVuQo14KAKPaIwy80Cn
         r7b5rZZxUfVFANH2pqmIOcVClu92cMKUzYl7FSyHmboh6jhA4T3Ls1DdHvry7lYeAiR2
         JEmjU3kqXrrRS5CGwVOMSVENucH6W68nYLo1rB6tHhgUfHnMB8xoNIM0XEPLAl4EoVdf
         +yqrUGP01D18p2HurWTY/vCvX0/Ob9jn3pydCjB784Z67IR+KEtsn21ZowEVkS8jnIOB
         KTVKz/V6Gniavd7fRd7SS36BmKwhMSXDQm8+P/7cqPCsxpVCG7iY3a0c7DX19B5RWoXo
         cUuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWv4UULLgoGEENan1RehX9cfLETUKRKgM56a/CiTN109T+IzX0qXDoKf8RLN5Ts5UpjLKw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4Dk/EHs0Bc+OGDMKoPKxZcKag3RUiRnvsb/vlfGsMZHwbNMtR
	AXQ+eOeNGztvHv4dmLwzOC7kYqfyH41VePjLXCqiMyc918ihtxOuiONvncHpMb0=
X-Gm-Gg: ASbGnctmZxGnDGIaUPtZPlBduZ9JDm37dkSZnfUeRo8ldY2GlbK4iqFi9zL0uSrRhHH
	BBIrUSCaHTX7DukkX7fxAbA6UEXTpA4R117/t9ZPn54WtEU/pO0uDaFDfC86YT5hxtCiFAegL84
	orFwfXZ0xUwhwN0evlcTpbbruE/UygzgxihRjbwkJWTMOllsmwILCEZ44fHixfAW5kFGXZEIFOr
	F5RnUsg81ESf+79Ujl+WmZrFd3Iwbg4G8OU6cV7FXo8IG6toQl7k1ibyHm+6b0EUopY1tC51afv
	cgrwiHagq1sFgjz7d4TlBkjUy5OfoLXzT4pxKTKAtp8R
X-Google-Smtp-Source: AGHT+IEkZnLpN2CL+GDmBOdEKBU4dHJiRJeeADCMAkJ+O9oEFhXHqcZxYnGUH5GSlkI3pMVX0bW4VQ==
X-Received: by 2002:a05:6a00:1a87:b0:736:5725:59b9 with SMTP id d2e1a72fcca58-7372236c6b2mr14484100b3a.2.1742236482975;
        Mon, 17 Mar 2025 11:34:42 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:42 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	qemu-riscv@nongnu.org,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Peter Xu <peterx@redhat.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Anthony PERARD <anthony@xenproject.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 16/18] include/exec/memory: move devend functions to memory-internal.h
Date: Mon, 17 Mar 2025 11:34:15 -0700
Message-Id: <20250317183417.285700-17-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
References: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
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


