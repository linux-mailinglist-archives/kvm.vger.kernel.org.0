Return-Path: <kvm+bounces-40953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DBC0A5FC05
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:39:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E0723B2C28
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FED026A098;
	Thu, 13 Mar 2025 16:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nAmadn+a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C16269D17
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883959; cv=none; b=Z/2eZIkeLYE19VYc6vpkrPQM7C66eZBSDWNAVfqOHf35XGnOc3yPM4xHadf6bEokIQ0EAvU0/lu55zNhMcDcaXnSOf4e7F8nQQqbVXBKPskd/zcRPK6tuE4Rx52/FfVpusrJlxxINoF96mYAQHT7olKZ5wg6x6L0Rv80BjRe/ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883959; c=relaxed/simple;
	bh=o5ngxEogoPE4wzfGJK+6GJ+kqB2vK52Q1QHqnpgsaHQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rcj1iL8+nQuso1KR6XZvgvixaD1N/oTq3pZL6xoCP386tYY/iQUCVH85jJF7ZyIllZZ2l9pXpHtc78OOwX78uy/c1XsF0qSOeiLSCpSDeT6Pfp0yZ328xkjVcyKPw5kKvPPBQAJLxJ6kxoToCK1XetSv6tjpfsrhoAMxk36GtYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nAmadn+a; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2fee05829edso2501469a91.3
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883957; x=1742488757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wT5ohu0Ui7xrH+jgYqMJMpKemGPcZNvy7jzdyuAyzEs=;
        b=nAmadn+ah1BeUmVKHRFLruTDQoYrU3gBBC7V1w2LWP8wcBv20LLoi1khnTyr62f7Ga
         4h4YOwuR/wq64qrQJbWtmOeFkhAPP4I80QePj26Y/t0qr7wDyZhfBtsQEPQzMvgOB5Op
         X7nItLOqoShoKNvp9MQ0zZSWsVSEqcGKid8dWSVeHugUwIEEBmp9sgfFA/+MgvaRnmAx
         87guR4JbXeeGErmxGXPG8xv81kJpSS1J4IzkqvreHR94MiRcby4BFKsjyGWiRPWADG79
         T9nJIBDFR4AAxJ1qktsWFj6YBwlkghEsk15/g1DHK83ZwJMZ1lD5OYE+qTAeVvN96YNu
         GMCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883957; x=1742488757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wT5ohu0Ui7xrH+jgYqMJMpKemGPcZNvy7jzdyuAyzEs=;
        b=VPiBaArcca1yFEUHfq/JMapysFbMpQjby6ZJ4ejjfFU4i4lFT4v8Pq32A7Jp4fTsWB
         9sJ1OM1oINQzYqO1vaOD0EhKdBNtCoYX+WIVfNTYr7k5kGmc1VOU3xvLvKH+zlz7CGcy
         OY8KKTasUINqGwfKsg/7WXnJfmMNcl/uUgMxnpb9HaO+w6dxEEmAgUtCnRR73PchIzoI
         qcFNRwsrBBL9InaLYsPw3HaJciOi59QjTNc5m5w4FPaW1AA820972kGLsoCngKGJnEDb
         AdBnmnL/uW0DfsUrDjQCfw16hDwGn8k2hrlq8pF6PrpIiIX+6o0K+oXf9/cmqyuC3/0s
         Vo+w==
X-Forwarded-Encrypted: i=1; AJvYcCXwO4ZcBwc/lhcxQqADo8BO81GWCnArXgF9v/K6RtLZDZLtMcE5iyl6fq7vgytlJbR1o3k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzlxzsk39Zo4R+poYYTtty59om99f4EKGcKZPyx35Pn3fDqSgnO
	tvXWDNBTUOAE7PdqPqubd4kxyo6cAAdAGTYaBY7ohPJ7OzWpokY2bTW4SYwk3sM=
X-Gm-Gg: ASbGnctyjINLEcapyPRABMPDTshHeTdAAAnnTftCn61DhkCd+VIgp9SNLfu7iMtSk4O
	yWL1hxXk4KnC/X7N1IjmSjhSianp9qKC/vTc67GDGJN2WRD1ODJn+6F+NWdEFcDQ/DGKNxB5OHB
	rO7Peht+fq+BBAlrvh3SlEsAW5ytZsLedW1AYUYm3EKV63qAmDp8a/vCWvv9uK03Wa/joe77kXO
	j3ohkjsy0qiQ8Nwl3TbxU8o/YzJzAmEA2ZHu94q7IN5J0T05UBILfa3cjGlOje2tTlOt1kpIZVt
	Vbq09Z+92GaWCAveC9HAuk5yqDWXyzsga9pZpQObp3jO
X-Google-Smtp-Source: AGHT+IGT0TQa6IzxQKmV0c+iT9Ap/Go2mov47rFQ/lft0hbXJmOXflaiO0g7vmiNGPWVgJAiRn5xgQ==
X-Received: by 2002:a17:90b:2710:b0:2ff:6fc3:79c3 with SMTP id 98e67ed59e1d1-3014e8435admr275040a91.9.1741883957269;
        Thu, 13 Mar 2025 09:39:17 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:16 -0700 (PDT)
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
Subject: [PATCH v4 05/17] exec/memory.h: make devend_memop "target defines" agnostic
Date: Thu, 13 Mar 2025 09:38:51 -0700
Message-Id: <20250313163903.1738581-6-pierrick.bouvier@linaro.org>
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


