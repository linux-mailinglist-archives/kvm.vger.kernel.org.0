Return-Path: <kvm+bounces-41288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A246AA65CBD
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:35:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 780AD17F4BA
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D211DDC22;
	Mon, 17 Mar 2025 18:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lf7coFEG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7F519048F
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236469; cv=none; b=e6ZBVuJ4uEElIaWbEguOAHj2BToDA8qTIz80YApKVoyhBz9kfzL1tx8F+pNKjxygoUqfSah0SLjVvPHL02t+BbRmBBW147To7WDKzXCt27PckMfGusRfY/YGbvKreinm9bqhR9ICUtKjj0dlhrbPeEnac73/Oques/0Gdpej3/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236469; c=relaxed/simple;
	bh=D7kAKGSn4zAKkiSs1hQlq6vEceALs33too5mFmMr30Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XP62bak29y4StAKMB8cqY0tR+88bwGXHkAzCzpN9fBN5POeQrNpWJDYGf0Cf3ZboqvygmkFMvtElbRnZl+6RjZDrokfStHIcGdJfz/caZmkkAS5Pd+myO0WimNbXG4DGydmkyzCo4zK1ywQ6VnffAT79hfiHBpYNgjR9vJOinxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lf7coFEG; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22423adf751so80101465ad.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236466; x=1742841266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=949DeBQijWmgHqYCdDdupcSTn3rDdND8nLqwkILEwEI=;
        b=lf7coFEGzN80IA2TlDFDPqH+AH+ZksdfEB6AhFWXJUC7o+90sjl3/K8h0s3ic1aujx
         C1dlrecdXt55NiQcR3XQb5YcpdE0A3peW2gmP76i+lBKaLWTFQiXwYKBZomqQMajl+fh
         go2ekezYCGqSGdXNswr02fgr9MWurqWF2LGWuKGCmu1kHBcQ24bZjTIQyeIET48uYMwM
         xtA6ntMUztcZLUAwsNuOFQAtnNM0KfnGsCgNxBzhQaKvvbXPmada8aLEZGi4ZZMJZswO
         WULz3nQ/4UCzu/5cRtl3jlzgwImpSjZRRYnGtS2fOcOVQVquSEd8/CwPWDtaVhiVy9qP
         XZvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236466; x=1742841266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=949DeBQijWmgHqYCdDdupcSTn3rDdND8nLqwkILEwEI=;
        b=ReRpYzFUaijfa0UDfLJ0dkJ5Lj1XiI6cEpAhE4FnM0bW4Un/khD1tdG2m6ioph3vSv
         RWWzYzd51sfRO6E2zvhEGdLZVNftCvth28ekLuYej3XcUBSJT5yuHoy2P0uhg/eWv46f
         8Lflf5UfHfvHRmpFSViZaw9jOOETEhP2YSNvfAQ9HPjJ+PRr06AyzCHYwJnoEt/mB+kl
         hOEF/iYGRuTzwJsVQjeUI3trLmK5z+Y5xsVBdTvxBpPttoMJd4RQT+cWts0p0/HQ6SaI
         RvmbHIrFQzvw3F7s88JbqBqsn7d8PUGgz2+QQ3DSCgSiGsEaLtfi/lRN0gjxBYRSDkhQ
         4rFA==
X-Forwarded-Encrypted: i=1; AJvYcCXBpobe/ziR8vEltfO3NLpQxGBf9fMYaGiyIIUot+zFVVQqgEU8QzLP1EJGH9IE0fOnyzc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4V5n/WrMAu+8Rt3blDW4hCJiJbywacbbPbbHuFDmuW8pMUjOQ
	hiX0n3acFzKEaZr2TQ0qBEnGGy6J9MJHfz6zXZXKAQmEiOitg2vIBcXaMlXp8Ko=
X-Gm-Gg: ASbGncvddE3DqNd+mOf1SobAkJf6CAfsGbEMAB3GphntWHzLfj8dwjuJL6ppEctVas5
	H6tbKraiIJ4CwXG1gUdBMkA7w1v5/rTVG4hLhreNFGh6yV/ERwDTvp+C5Rh4gNzcizm7irGrgrk
	Y9646V+JaBee9lQEf8VxRPLREFEpAzhedCwQlDzhZIQIiOL6Ve+xNKJpKpDjeVmiSCH6ee0dul/
	8I8NB9qegzGOEF3V+Ik4WZGx5kPwQ4Em+CHOH0AY4uqNg+IXZYhAjGDQub67jjWpsfwXDyauV4H
	Nqgnxi2JLpDVG8Kl0gteexe4Ng+QLU4naq5In7JMYqya
X-Google-Smtp-Source: AGHT+IEMdkhHnCOZBQ+9EV0uYxPSw6/JcOSk+BrsDVDiw8khDcGewsFrIqa6c3AgQ8Es/TqwcULwNA==
X-Received: by 2002:a05:6a00:139f:b0:736:9e40:13b1 with SMTP id d2e1a72fcca58-737224726e5mr14180634b3a.23.1742236465994;
        Mon, 17 Mar 2025 11:34:25 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:25 -0700 (PDT)
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
Subject: [PATCH v6 01/18] exec/tswap: target code can use TARGET_BIG_ENDIAN instead of target_words_bigendian()
Date: Mon, 17 Mar 2025 11:34:00 -0700
Message-Id: <20250317183417.285700-2-pierrick.bouvier@linaro.org>
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


