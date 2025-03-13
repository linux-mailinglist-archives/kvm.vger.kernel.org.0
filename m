Return-Path: <kvm+bounces-40950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15CE8A5FBFF
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:39:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62B271890A33
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED8C8269B1C;
	Thu, 13 Mar 2025 16:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="os0AdLfp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683CB1FBEA8
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883956; cv=none; b=nj8odf5QNxgN1CirI1l7/+HVXu0eMIW9KBOVRCOiiik+VFnHw8ATnAlnUqrvW6VKbNxhc0t22jJ9OKBhrbFCatsmsnvt8Y0IZf5c6pt5gJLK6GurcgAOdq9zgY6aa6zHPWkLlRuLEA+L2S/a22qWY+RGsAxpXX76H+scappgVWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883956; c=relaxed/simple;
	bh=D7kAKGSn4zAKkiSs1hQlq6vEceALs33too5mFmMr30Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Oy9NIZjXPa4whvzMLpX/0qpRAi63ftY42MkdXf9wq64yXkKgdnERpPaOuXoiLzgmwSe5mQPfuInZxjO+iUeY99CTLAWaJS1nticWmA49IC8CTa1YWgVklq/Ojdkur6pqkU1kiyRRuepak1rPLpZk84nob3jGYsVWHtceRyD5yhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=os0AdLfp; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2ff65d88103so2115514a91.2
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883952; x=1742488752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=949DeBQijWmgHqYCdDdupcSTn3rDdND8nLqwkILEwEI=;
        b=os0AdLfpbmE1IPXGe2iz9R0NgEj4pTBFdZmHErvcvlX81Z0RN33b+piz/BsbE6/auT
         eqsCNnj3MBT9J+21AO4xLjeqO+wAaP9md9KZe891zmI8qw8AHr32kQihcNA8DKGFvDb3
         k3OKULE/aXJPsQ8tWMEwBlwprUj6PLu0UIB0Oi0g+hRiYAYhO3Ugxx5FEMkSbIDCanHy
         bF39skCvNcusNwpNYy/iwQ8n9yiB0zSbXnzVZMwNmPzgOkaF6/7n9Km5oPiL5tJptz8v
         76lffw8j7QWxzhOM7vqRtqER5smOmzUeICY5id5WJEKYhu3HEMsXMgii9oshlZcBMa1r
         UlCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883952; x=1742488752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=949DeBQijWmgHqYCdDdupcSTn3rDdND8nLqwkILEwEI=;
        b=Yc1e9uTqtw+B4diZKqAwguvnap/J0A7JE9Vm+3oeMdeGxER+AfOS4X1F4DRuIdw32i
         nVDKepsTMv2vew//+NfG/tiXvfLUC83B5wyT6obPMdKldhmgpMS3NqSCzpwCfLSq7et7
         eQtnLxkhNSFqSOs079MU30LYsaEiHKncPf/9gKM898AQh5jYCL8aRZoy5fbU7oh870L3
         kbtwJsL+I0GG5GuWfOoCm7zGe/UjQROqSomNhSG2bSFO4ClywFdC30sMUB3cGIev8vYs
         uZ1+r1wp5gznxDDVRGpL1lPugHuherc9PFieCgLM6XQQhJs+IxzeKwPckvi+EfYkkJT8
         MgdA==
X-Forwarded-Encrypted: i=1; AJvYcCVdZ5FMekObl2z/yDhhW5Vl/lOyzjVG5EzBFO1okxJRZHuzzEqU+Z6wQJ/Ck/FvyeNdZBM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXv3/BYC7eKC08u29zVqBA2nwgvmA5ZO0oOGlpPI0w9zzFXiuo
	gAk3t1JaDBe6L+EMSuvT5FuFKdlAtW/J9zlpR7difZUPGHhiIC29lSVSYyv2ZnM=
X-Gm-Gg: ASbGncuK855Quvi6ucwkNUxe4zKWjdOq/IHpZTEBkRrSn1gABQJWR2JX7XRI/ZPNYlG
	vHrx03GrP6o1XVN7x6TFhIX30bz0ZUx7qn+MXaSgFmktd5Ab58w2wJgCuNHnGBVA90bFo33D71p
	lWFan+9CpmcNYgmGkit1qHpizYZoksxzqfTIo4NEsWiBgoM5JiReBz7HHvB2NfY+yciE4t6meuB
	lf+2xkH8Rsn1EQ7IhFQR6zTHT/J9/h9w7zX1IePm3IZXxbeXRxERQHKEfnqpKMxXKn1Dxp7fo3l
	HdOD2O7yFkba0r9GuuPezTf7XVaiwSMklNtatGI+DXvg
X-Google-Smtp-Source: AGHT+IGev37PyaCRPVTSAXm6sa8QmcuQfkCR4AEqF/Tkfr+Zh7Bhff2KfoPULWlCloRr8rbLF7MLgw==
X-Received: by 2002:a17:90b:3850:b0:2ff:7b15:813b with SMTP id 98e67ed59e1d1-3014e855f52mr302864a91.17.1741883952691;
        Thu, 13 Mar 2025 09:39:12 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:12 -0700 (PDT)
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
Subject: [PATCH v4 01/17] exec/tswap: target code can use TARGET_BIG_ENDIAN instead of target_words_bigendian()
Date: Thu, 13 Mar 2025 09:38:47 -0700
Message-Id: <20250313163903.1738581-2-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/tswap.h | 11 ++++++-----
 cpu-target.c         |  1 +
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/exec/tswap.h b/include/exec/tswap.h
index ecd4faef015..2683da0adb7 100644
--- a/include/exec/tswap.h
+++ b/include/exec/tswap.h
@@ -13,13 +13,14 @@
 /**
  * target_words_bigendian:
  * Returns true if the (default) endianness of the target is big endian,
- * false otherwise. Note that in target-specific code, you can use
- * TARGET_BIG_ENDIAN directly instead. On the other hand, common
- * code should normally never need to know about the endianness of the
- * target, so please do *not* use this function unless you know very well
- * what you are doing!
+ * false otherwise. Common code should normally never need to know about the
+ * endianness of the target, so please do *not* use this function unless you
+ * know very well what you are doing!
  */
 bool target_words_bigendian(void);
+#ifdef COMPILING_PER_TARGET
+#define target_words_bigendian()  TARGET_BIG_ENDIAN
+#endif
 
 /*
  * If we're in target-specific code, we can hard-code the swapping
diff --git a/cpu-target.c b/cpu-target.c
index cae77374b38..519b0f89005 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -155,6 +155,7 @@ void cpu_abort(CPUState *cpu, const char *fmt, ...)
     abort();
 }
 
+#undef target_words_bigendian
 bool target_words_bigendian(void)
 {
     return TARGET_BIG_ENDIAN;
-- 
2.39.5


