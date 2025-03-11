Return-Path: <kvm+bounces-40792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B227A5D028
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:58:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 681737A80B3
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6B8264A88;
	Tue, 11 Mar 2025 19:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Rl/1CCoV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE9125E82F
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723099; cv=none; b=mtxB9BmWrQuRrZiJX1dpz1gy/DDt0rkakNRML1zCXbjocnLI5gii61HhSVMQnUSIIHMgM8O29AJogSnVKfoGNKg8O4Vk7Msjm/pOHCiq5A6ySEjkR4MZz1Tyw8y7KvlonhhWdfjU4y0PmLTP1wbeaWdD9hj1BDxD6LimC99fcgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723099; c=relaxed/simple;
	bh=o5ngxEogoPE4wzfGJK+6GJ+kqB2vK52Q1QHqnpgsaHQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fkvjodI3oqRDOYevyZYOIBz0Cf3dH5IpPedJqwhNPLsMXV1vlp8Ym8Q9xcMXW9/CbK9wBljHOi09NRBRgSMQx1a2hX2keO1yJuxvBmjS0tT9NypQP+WdsZt5xls9uZwzFGoaPzAHP4ibcEfaIhXhkLX38iRyxNZbRUl3finsQJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Rl/1CCoV; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-219f8263ae0so113520435ad.0
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723096; x=1742327896; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wT5ohu0Ui7xrH+jgYqMJMpKemGPcZNvy7jzdyuAyzEs=;
        b=Rl/1CCoVGS0dHPCgtJYskvuArZRc/jk/1JDwOJB+52UAww3UB69Osn24C56E/87nzY
         XPI2h067C8wu6W3q20WLXJnhx5ORT4Sl+vaPDP6H1ea70ZzncEmyOKqpqvq0nNjyAOC6
         UNUPALVk2804u7BH9hNyrFOhQO68CkmtYBHw6ML1lnZPzgvBaE6jgQXXmgSIBuN7+KS4
         363OT6/T0IOth0nRxd537j6BczW7dDslQ4veyTrPfFMnpIjT68eDZo7F1wYxcAtt/nP5
         qVGkPpUjIin3+J7F3KDpoHPzmiCG1l/JHmNwuqWn2xh0bIoNMGkOBuAdef/0MC7BfMus
         iSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723096; x=1742327896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wT5ohu0Ui7xrH+jgYqMJMpKemGPcZNvy7jzdyuAyzEs=;
        b=A7OBaOUehbs2qqQec7VtjWK9FpTJsYmwKkFBTuzrp6W+MpmPdP9uTLpo4NmsBeuDR4
         Y1Cc+R7WMZ1eJvpdQOvpvJQ7ueaz697DqzUDNITaKMYvAn8ZIhmUeIi5Vq1xJvdKPnJ2
         mxrPtzFdIhtySARwHH7tojKdQGOp2nzfsJEFIfzNJlQ6bOrcihMqg3NZApdaX57xOp6d
         Ev06EJkZ2/fPGMnDebeabkkfOZLowJIjONBQHUI2gPsjv9N8C/aBHR9B2S+rFceRy+5J
         ohuxXdb5N3A2U3REQJCr8pxXrKvxw/tKd58ILc3IpSlgFPLjwcv4HsaIuGE2m4tZ983N
         6mVA==
X-Forwarded-Encrypted: i=1; AJvYcCW8aN1lbrjs8ETNEcA1olFCihhOr/9sR0SVTlst2sl7q0Y+8pupl9Vq+c20zoiFJSFqPQU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyBjiLbjBaDVWLF9CxI8cyoohU7p6RR1JOPoM7muQ4veNIVNRQ
	K7LUz9ta9wcmSvirUm70ipN3x544iEjjasq5fJobFQKAZkA6T1evF/7U5/WTYbo=
X-Gm-Gg: ASbGncsLO5/ZLQFKkZ7eniONnGO6hqikTXO354NUO3kVsySPreDocuHQOFgI4D+JdZw
	XTp85W67MZTl3vA6k2DGT6Y7A5FH9V+oPQ6LcjfIxra8SxeDLQvB7PhkBsNcvdVN9XeUTwgfm7R
	TSL0zp5GAgpo+ytU0QPK8T9A6rlUQ2xda94p7gtfWt4HEtssqYdx/hFpXrPQd8EaMwvAJjS2Ub2
	KmSWoEXK45S6TxnR1q8jv8mSkNB+jiZ8BkdBUOQUOaKMACxUHnc+DBN+AkHjGaIx/Bnj6lQ4qaH
	UuRJWFg05qPNtIOvhvLBwT3a7oiqZt10/WLgn94mURzz
X-Google-Smtp-Source: AGHT+IFol9xcK9Mza8BcbJc/CzML1UZwkH32uaLlj+5vumcl06S67T5kaVFtBRtM8pv/UzBlFhWjBg==
X-Received: by 2002:a17:902:f691:b0:215:bc30:c952 with SMTP id d9443c01a7336-22592e2009cmr58302965ad.6.1741723096508;
        Tue, 11 Mar 2025 12:58:16 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:16 -0700 (PDT)
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
Subject: [PATCH v3 05/17] exec/memory.h: make devend_memop "target defines" agnostic
Date: Tue, 11 Mar 2025 12:57:51 -0700
Message-Id: <20250311195803.4115788-6-pierrick.bouvier@linaro.org>
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


