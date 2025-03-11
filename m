Return-Path: <kvm+bounces-40721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8D71A5B7BC
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EBCD188E216
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A99321EB9FF;
	Tue, 11 Mar 2025 04:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LwwDaDU/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC9D1EB5D8
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666140; cv=none; b=ATL4IpLRk6K7hOLhCVod8NHeNoPX/FrrNBxoOQ8wwxRoSmUSek32Y6wX+pP3/+V8yyppOaGpF190SQ1CH4TLytwZsIqSULCWC4GqfejATdBNYF65akz7WBvutGXLv8w9jqjD1HdgEu4qi1EC9y0q+EbmvWwhsgt0kpwi6joTr3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666140; c=relaxed/simple;
	bh=D7kAKGSn4zAKkiSs1hQlq6vEceALs33too5mFmMr30Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kcB63VMGcHTJhbX/L9A3BtftNqql+Oz5awm+UhhWXwIxVehscCR227+0RaZIXidDlKKWywRlSxKFLMIJgdSQhsSSkMZ7BOAfGeRO1z2ZD3RmkXPb1HAtmjTFX8GytmN/KNJrdJArt9U7f4xLGytwAuQz0nxa22QVxf8sx9+lqOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LwwDaDU/; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ff694d2d4dso7130741a91.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666138; x=1742270938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=949DeBQijWmgHqYCdDdupcSTn3rDdND8nLqwkILEwEI=;
        b=LwwDaDU/ePd/7NhfhWIJyqaLQ/s7jFDmNhSWjk4OnsKzScfrusP9VsSqI2iI1cr2gR
         j5pkKVBZQsRyFc0Kjg4fIbZRXqBUolw8pCGl0X4rKZD+7gBlNuoHDgWs9e7n4HJvRjq9
         UC2fiTDcn9xrcQlYqttCgx4wMZ9Xsyvh1szVdxw8H9cOU5iq4lYgFb7iUWGCWwpO+aUV
         qhatBjpv0OYeGX+JlNnXyuHXoqVTmeYE7kA4+G52FHvMax2ySalJ9o90thhJJoz9/0R7
         FjP0kYqDZOeDK8pveutzGWCgrQApCO+CvS1csekI4NC1xFIPDi/F6h44KTKbvebFefC5
         4l0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666138; x=1742270938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=949DeBQijWmgHqYCdDdupcSTn3rDdND8nLqwkILEwEI=;
        b=BwWDlHk4gbLCMNFW2fDSYeoQGufEC3XvQqQQapZ0UW+vTCv/rgkL079ZE1/W45JdoO
         8MI6c9y8/a367Q3vZxzdu7+zsrsDY9ZjLsW4RHGyLYK+bWkolu6PllwZ4zHJHe2mnSUo
         a7Egs4OEv13UI8HdxUBk+zwCeGZKsSidNCiA1aMZ5XIKWd+3WHNfWgjsRiswlk0VjtHV
         cAoQIvaxL0xhr1Em+wUA11Qk1w79vhRA3GamXUcyYtLN0kAmMvkskyyvnqifY4NaFTTy
         FZQzaON92AXLKsuTZ/FmRAJiZyQx9ECSAxKWu8Ybv5alVIRQK9eaSk9Ri6+cF5Ap8WyV
         zwPA==
X-Forwarded-Encrypted: i=1; AJvYcCW1YqadGRaV0IhWmBptjB+hJf8MwQJ2unhapyf/9YguSExFvYTi5QuA0zoJmH2pScU8RMQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3otXWuIaAG7zKSTI0T2kpLI5Xd9vYLhlDWN7Wp7+taKALLTn1
	XS+jtoojTS6i8TrDxS/KPCtETTD+MFHP+NTH9O/E60PP3BZXv5nFL1fm4ethYnU=
X-Gm-Gg: ASbGnct1Qa1TfLI/3UHRXDiVfqouTQ6JbWR+5kFTEjput9hV80WRgD/FhOkeFKt3HkK
	sb8ULVSlmY0aezcsJmb+5MWp1ktdnANBzb9snu1Quf6OP7TsAkkRg8g0r3tIxt7rstcwfnOH4cu
	qeYpfqP/j9C1VDa5g0aLMmQkRvbNJrxfcSFewkSwnP6/7Schzl+2V13yGmcYqijkgCJhVIm4OqM
	HKqt7LvU0F3dN3wIh4mQpCUDcd8yIrhJI9E8y7Sxeu6dH8gFbxqzUZfnRfrGzpEcPOf6RbOelJ9
	YHPE8R4lN9V5p8tSrTn022gj4W/g3NPXT3usZ/c69ogE
X-Google-Smtp-Source: AGHT+IEzBJ4Y504tWVEKTLiAl14rUz4i3nUGGoyaKrgK43oaArjDd5np2LA5f1JQHmiuxtYBHKlEDg==
X-Received: by 2002:a05:6a21:b97:b0:1f5:889c:3cdb with SMTP id adf61e73a8af0-1f5889c6dc7mr5899820637.8.1741666138527;
        Mon, 10 Mar 2025 21:08:58 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:08:58 -0700 (PDT)
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
Subject: [PATCH v2 01/16] exec/tswap: target code can use TARGET_BIG_ENDIAN instead of target_words_bigendian()
Date: Mon, 10 Mar 2025 21:08:23 -0700
Message-Id: <20250311040838.3937136-2-pierrick.bouvier@linaro.org>
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


