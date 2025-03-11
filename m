Return-Path: <kvm+bounces-40726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 89AD1A5B7D0
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9144171D13
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBEA1EE02A;
	Tue, 11 Mar 2025 04:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sGeHux3P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A026F1EDA12
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666145; cv=none; b=Ul6m9sFfkllkvE81ZHUbPTtVXhYKdpLqf1dt7U/JzHUZJ9WsI1FsZ/hdAfjF6crQqqiZ/HRrQcY4SIntTFd35zhNubFYjXLhozo2ZPHkQebBj/a5b1pAg3y9L7F6YD6xIa3SIZDfkqBHfq5HRSOFGLlJnNZUozU2rKAchSMHAVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666145; c=relaxed/simple;
	bh=yFFV5k6u58GmoFHWyrxMkyCvxBZP0lG+d4fsFlGzWtI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OYM2xtOy8J6QzSz0tbYJ/gs2DCC4NkiRvzJpviSWuckS5s263yyswtZ2OcOS1kN+l/YxrhPL341TzcW+yFNZ5+JamMTUEx+q6dQMPMlmzAshhQ4MX4bgwfMUsrRqSZTP482x/4w+ioISc8V8JvBbfWZr7ZSPgUEaC0gfV5F0sLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sGeHux3P; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2ff797f8f1bso6645128a91.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666143; x=1742270943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=igRm5DauylZU7kF6A9LJbRIXn+glPoGkFsEjcODvlvM=;
        b=sGeHux3PNUXSXyu0VWmq25ZffNkVKiKkw5ibpG4QKzaRGmB/msrJqrxt2g6bZ1ok7l
         cbQfwBJleVsMwpznSnjtv5jfQ47t9Cci25Q/V2NjwKede8Cl9FOrjJfy7WBbK1904hXs
         Qe5VDWh+MwBatrd2Y7El5eePyzwwmprgDdtRszH9yh7XsCHsvrm1roCQ9RzmRbRiEc1J
         Yg5mYpyuooWFukKSByjQul/H3Oh+wfy0s1AXOvElskna8Up4zItblvB9nji7lapnCb9A
         2RxQYgzuuDj2a3PNHuostmVFlOncvtQTfiG7pipn6AmJ6/etyT5z6NWFjciIczPvJi/c
         VDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666143; x=1742270943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=igRm5DauylZU7kF6A9LJbRIXn+glPoGkFsEjcODvlvM=;
        b=AYevHxLgIRpkR6KE2fHe05tBSlrT3gWLaQG95GgYNfnhvWXqAGJeW2jZHXCQCr44h+
         Rv4NF+4QSlGCDxXmV16wjnt6kSWUPXA3+noPjJx9G4Txpu1pUc9mdYU01BDIn0YleU81
         Kkla62otmTCR8RQ6yK9ujgqtsyYkPIlBEhU/oeY5y3mUS6kA0jPEKRWueCPrM97CyVl0
         C5lcpgBMDmO/BFLl6s0nNENcFX2Ub+QHeAEg0huL8R1hi7U45Y1CY8nIpoyN+eSS52/n
         qvAiBW16sACOwgFtC5LRIHtpFFHSnfrFoTbtj6wTCMkcN3lPbMl/0nsOe1AMk6lrLPgQ
         SdiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVX+ivAEDUopMbu1mIUt6K+PND2MjIBJ0H5oybfL/ON7VA4eRwMldBp37+DoHjx/kzmIZA=@vger.kernel.org
X-Gm-Message-State: AOJu0YySCzmobkyhBjMbJXK9uLfzSzxxAsMHcy60MBuyZ+WGTVXGOSNl
	oWO7IEJyrF4bvHMIU8FsoWzwHk/pCsX7uuvFkwFPkfboY6JkqUBNOy2LLegHlYA=
X-Gm-Gg: ASbGnctCXtmhM/JK1sAam9WxV7SPwe0uoJo6fgSz4Apm2pHnFSUwhYx3jLHv8CN9HZY
	xdci7sDSMJpamXx7i03YP13Q4MgYUgEY8GnOZ9fvjhMP8X5/0jH09gIhV1YE5FkI1qOnenq8Q/z
	6UOxkENPqphqF275PMdmiL1I2zIun6Rz9PsNwoNUTFWTDAvjKbMUFDxaqMhMnpSwijEUKbGwvMN
	K5XUgE+PWS6SFUE5k40I9ts9YGGb1oY5pwfJWOEb0GEVLlYyn446FatmERjvTT5RwFWlOsxbujm
	aJ/m7MtNwiAqVxm7hq/DVl1gNvBGffrmRmoq5oR6y2j6
X-Google-Smtp-Source: AGHT+IHqGisSQCK+iGHuI44FF+Puo0WshM2hC7DuGryTfuE/I3BKO7cRhsCQCZNyA9pqBEuzvyba5w==
X-Received: by 2002:a05:6a21:3a85:b0:1f3:40a9:2c36 with SMTP id adf61e73a8af0-1f58cb20502mr3303668637.10.1741666142929;
        Mon, 10 Mar 2025 21:09:02 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:02 -0700 (PDT)
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
Subject: [PATCH v2 05/16] exec/memory.h: make devend_memop "target defines" agnostic
Date: Mon, 10 Mar 2025 21:08:27 -0700
Message-Id: <20250311040838.3937136-6-pierrick.bouvier@linaro.org>
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

Will allow to make system/memory.c common later.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/memory.h | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index ff3a06e6ced..60c0fb6ccd4 100644
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


