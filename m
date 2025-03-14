Return-Path: <kvm+bounces-41092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31CCAA617BF
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:32:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67A0B16FC2F
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6E3204C00;
	Fri, 14 Mar 2025 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yJbVF7Qo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E842046BA
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973512; cv=none; b=aPJp5YkPHKcP0TAAH8fUXm06SM+nQOv08DN9Ne0wg8GKzKDuKJr+ZZsOdBQtgsErIH8LvXmPlP6i2j/VXYY0e28T5yeP4ZTySZ3l0Cc1HsFQaECkn+Loar9Q0NtemaJOlxj4gihtU8usu/skZdgRd9EMN2OZ13gWMvc+q2n2Z4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973512; c=relaxed/simple;
	bh=o5ngxEogoPE4wzfGJK+6GJ+kqB2vK52Q1QHqnpgsaHQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HjMF28VReTbtBZ2jXkuS6UamyT7j+CAUB/HehwPIbYuMow4zE+lUsX2/qGTrDD92bEJoNjG7RJZ0CG+epQ1gYaXkT0tWCmoDNwU9XowIDEKmKM5pPKfn09H41tAe4OUirp3h2R+wh+MbEjnBUnD2KRMrgbYoew5+YM9DUu8k8AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yJbVF7Qo; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-224100e9a5cso48992085ad.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973511; x=1742578311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wT5ohu0Ui7xrH+jgYqMJMpKemGPcZNvy7jzdyuAyzEs=;
        b=yJbVF7Qow7HlU5PPgXYbN6pUFysL8QI0Qq6cuDPaauBy9e+JxJlqKnfZxphjZSReCT
         H1ApAcYWPeK/1DCGrSgPM9xrilA8KfWmj7qPuXpa7f174icd+WxUVyf4oLx/EnA46YAP
         GMHT/U9kdH8CMVhgEafHIC6D4kdtRlu1CS/gp/laTODLvQho0/E8auehKc+SCB04iB6+
         8jDAL5rpM59ZgyGA+36xtTFH1rr7DubkSFdTLwMqy2MRoOjugeDRuWfdZ6grVB6pXh0N
         aUxIo096MrGJYpLXN7Sos/8FUdDUbGxtml15AgcngGO7MPtAQmTisfuY2JhSX+Kyyg3Q
         PvQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973511; x=1742578311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wT5ohu0Ui7xrH+jgYqMJMpKemGPcZNvy7jzdyuAyzEs=;
        b=bBE1pJ8R/wkwkqb8LoWiqZ6Q9SDSsnW5xmVR/iHw6nmM1bF/pdqZ9Zk43DdYjcIMGQ
         WDrgtJPU+pudPmwlvD/fkHdT281md4gJ1Gb7b2RiXK9+iE8GLK67pQMbGJH54ms9rLrt
         5SOM7gK4e1nmPkttr74uacRAKZ4NpYowmaq6EknlUF6LaiIREMiQtvETeO6xGm0tPMBr
         wKF5BUKB2+QY38Fi3pGEDdOHgjJs1keg5TqQG/EK7w4lhAILU0/nBOV4nGkBArVH4ieq
         kZuvE0iMf3RBh6ij43H8Y0TgzJ0XZEzxmPOuwyr4ZA7oHJKCqn5JIXkEdsad30u7P3Gd
         /nEA==
X-Forwarded-Encrypted: i=1; AJvYcCXCACnO34ZqOGCyRsoOJxz8ql1Wbly4KqZHWYLrPS6Ogu29O94Yh5GrYkB7T3fAej3Pu5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyUgzz+fC86jMSdBahF/VHLlo+Z3uuZfNtlreuqPd9h6C/+AvM
	d3N35vWYppjZjo3J32VnDN4bU/WYcE0w2csx881WN17uI8+5KDz9t84amwT0AIs=
X-Gm-Gg: ASbGncsOVNQ8L5QqhyZbRHRUDLWUjLS/r2ATkMxPmv5e4TG8LDPJTF5Il0Dtasaltd0
	FEv8JW3R3gQ9h/34rcxG2iPYQRe/yh0p6sS1IkdLiiHNzI3BPXV/hofx4YyYqkXKc42cKmImsCz
	IuvmZf+9AYipsZ11YEZ95BcGq/O9eknvsRThbrAEy8vfpPQ7CIQjh6SmPjES4NPFqvtVOjrFNh1
	XtZ3SLRJ+Q4kOfa3nUx4nkECYRaeKh83bjWPHozyBhGyiiBxfffnA0jgcOxYDJWSG68jkvENIEX
	mxt8bpFcoe7gHQvvw4buQD2GbaGsDiwpZw/a5AMTI+G4
X-Google-Smtp-Source: AGHT+IHrpliMNKDFJoDtMC4n7ul1BPKlqc8CVK3A1d9AQSWcUHjtbEMPub70Om5ILhqP0o6bsvQnoA==
X-Received: by 2002:a05:6a21:9005:b0:1f5:75a9:526c with SMTP id adf61e73a8af0-1f5c117e146mr4872005637.13.1741973510710;
        Fri, 14 Mar 2025 10:31:50 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:50 -0700 (PDT)
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
Subject: [PATCH v5 05/17] exec/memory.h: make devend_memop "target defines" agnostic
Date: Fri, 14 Mar 2025 10:31:27 -0700
Message-Id: <20250314173139.2122904-6-pierrick.bouvier@linaro.org>
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


