Return-Path: <kvm+bounces-41292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 472A5A65CB8
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:35:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3667B3BAAF0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 303B81E5B77;
	Mon, 17 Mar 2025 18:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AMbxgOg2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514431E1E0D
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236473; cv=none; b=IU6duaQd99+F/LlMLq1tWrmRUYSkOXhkMkprq6i04gGI87Onk6Xof9hXTLfVDBYsESgdhdM2d4YtfjHKF8VURqHQ+cYdWnW21J9XLjdK3+IwgzGKA9prUCM0R5N7Aj7vA3ET+MALMitn4AdKqlBi4q5tBbOTZTIHSwTQh1UJU1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236473; c=relaxed/simple;
	bh=o5ngxEogoPE4wzfGJK+6GJ+kqB2vK52Q1QHqnpgsaHQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N+5ZN/tuUqbUI1Ho7i+cyiXRyUZrwassiibCAl9NQqRSK7yJLWf9uj3QnaX/UjLYzWZzO7aqEf7oI8ieyPHKSxWbXbG/aSajniU1knWtHb8vyCBE8pP7Kl4q2i6UpPOB346GLZRAfhEdPiwpIOTEA4Bl5gNFR22tsKqwaA5fYUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AMbxgOg2; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22423adf751so80102905ad.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236470; x=1742841270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wT5ohu0Ui7xrH+jgYqMJMpKemGPcZNvy7jzdyuAyzEs=;
        b=AMbxgOg2WIyRpnIEBHaG34Iy3Iowj9qfCdue+y6m/MgRiz6d3bM06C2OaDJyZJgnfA
         K+HWorBvkn7xnvFIA158Uyt6FMWrmfXMtzvXQzl3LPm47N11teGvRI1gzQfwR8OSdigF
         bbKkgytUmfx20lnMCrfctkcJFvh/GINsPubi15hMQAeUx8KsHGpxQMis+efwW4Yj+H5c
         /m815DatvUxFMDZrNPZOaJu48fuePxaYkqE/hdiBTiMei1+NKJR8NtMQiFGkWCwy70FP
         DdiyH7nBIYYyMlE4Za1O9dpOBTJh1qYNZ1A4cIr0CkR4TJ4+EJ1exnZjxP/82FM9nHH6
         5jYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236470; x=1742841270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wT5ohu0Ui7xrH+jgYqMJMpKemGPcZNvy7jzdyuAyzEs=;
        b=Xqjr+XfD2vOtzXZTxY6eKBA8bblEeKQryXPbaT0pVoTNAZQSdOJkKxWQBxm3vgnJM7
         C1a2Kp2eUM/n5KSOPqb87dcrKjKyZgDTnvK0DHKHUoj8JsBM0Fmx3g5hBNgE5/dD4yMi
         23I6CRmkMn35T2yQfEMFM5mmteAxJOi52zWKAET0SsgzfycCrTqNkxLM3H8O5nweFFMW
         t+aIWKP1J7VdR66/6Xi6A8SLMaHbrXJ2j363h5vS/x1bzENTzX7kWz8S7z1RpCnvvScF
         ls/cOvon2VWiFYXudJHijRHAQmfQjE3NizmcK8C3P+iLrvSOc7O7x7s0JNSNEtLKbuwx
         DtrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQTjPI1Yx5DPVJugS22FSCsZSKcYfAlpL9qtxTkbVzIA7yXVFJqnV4JB8FubXV0vuwsiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYO7LArYvD3Yh0J0IploZyWyeXTLmsmYYFUMJytw9/QS09e+RZ
	l06oJ4xyoOKnOH0bLBJIHg6BynFFWhysfm9lJYSC1lEOLPDfOEdjgPUwc8QyDPU=
X-Gm-Gg: ASbGnctpaRUD81my1IhmR4Nuy+SE2BoApoTbcmFUd14xBewIlmihFTjlpdPUQ0ZuGv+
	+yQDx1/kkgpek8JNz7koOEuPs3gE1LwEgtRqWiEdn70M20uAmhMFdZ86RdojN4GDk/tOIrnN+aK
	RjDvk3peFWx3J+B7gDjMDRNwPLjyoCINsI6SEaWNM8rV/dKIBWUnzEU7m9o6LrVgPbCruK+gRKm
	A9DkDIbvfaEgRPWudSbok806iZ3IoavqoUFM5pOSG66WeeZFSMdRncua1neX0Kf9ZBnHsQBX9wL
	6z14sNNDJ6pflz0DIIIREZiw0u0VsJ3qMXdYTnVxhxk0
X-Google-Smtp-Source: AGHT+IHwzlIJ6LxZBvPsjg5l1kKbXhEFWIu9N9qHSrE9Y+TBbc5aw9FWPh64Zl9aShUUkawUwyHzSA==
X-Received: by 2002:a17:903:22c8:b0:223:517c:bfa1 with SMTP id d9443c01a7336-225e0af0323mr191813145ad.38.1742236470577;
        Mon, 17 Mar 2025 11:34:30 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:30 -0700 (PDT)
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
Subject: [PATCH v6 05/18] exec/memory.h: make devend_memop "target defines" agnostic
Date: Mon, 17 Mar 2025 11:34:04 -0700
Message-Id: <20250317183417.285700-6-pierrick.bouvier@linaro.org>
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

Will allow to make system/memory.c common later.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/memory.h | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index da21e9150b5..069021ac3ff 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -3138,25 +3138,17 @@ address_space_write_cached(MemoryRegionCache *cache, hwaddr addr,
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
-    const int non_host_endianness =
-        DEVICE_LITTLE_ENDIAN ^ DEVICE_BIG_ENDIAN ^ DEVICE_HOST_ENDIAN;
-
-    /* In this case, native (target) endianness needs no swap.  */
-    return (end == non_host_endianness) ? MO_BSWAP : 0;
-#endif
+    bool big_endian = (end == DEVICE_NATIVE_ENDIAN
+                       ? target_words_bigendian()
+                       : end == DEVICE_BIG_ENDIAN);
+    return big_endian ? MO_BE : MO_LE;
 }
-#endif /* COMPILING_PER_TARGET */
 
 /*
  * Inhibit technologies that require discarding of pages in RAM blocks, e.g.,
-- 
2.39.5


