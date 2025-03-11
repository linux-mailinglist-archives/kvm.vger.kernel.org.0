Return-Path: <kvm+bounces-40788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E61A5D017
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:58:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4E59189F4C4
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D89EE1EBFE1;
	Tue, 11 Mar 2025 19:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jHFoQze/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ABC25BAB4
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723094; cv=none; b=TPM8dVMqsZIicBgllMtI/5CoTAI+y5zlQC9alFf7M7mIMJC4xH4wJEXWceiddi45X+VIZu0UrE05hImI/gIn9KEkjthssF6MmKTxjO/QR7sxk7VzCGw7/61mwy2CJEzXg2jZ8Icum/+9LDbj/uUS2eT8E4IVpZN2h6zE9V8leuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723094; c=relaxed/simple;
	bh=D7kAKGSn4zAKkiSs1hQlq6vEceALs33too5mFmMr30Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=capdHt5b3NTbpmd/ku+MQDPlQ/9lfJx2lw3lZaz/3KxYQLwQkMHH5PtIvVkjCxi4UyiLQ75f0TAE8P1duN9J6jbFangJQGFToDBw9YVX4X9pv9aeyua9q8GQyiw39YQClL8UJgzfxxNVVBs/SdjtkO1EHMK2Cfkma2N2eHYsEow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jHFoQze/; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22580c9ee0aso38783405ad.2
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723092; x=1742327892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=949DeBQijWmgHqYCdDdupcSTn3rDdND8nLqwkILEwEI=;
        b=jHFoQze/IFcFIWY3GX3zS6ImelHx1HsBxHBO9qT28TObl9SJdCo7jT7W5lTyR81Bd2
         2idFZBVvJ1xaioaouAiMiNTnQWYGJUVwj3nMwIgvJ3Ic+YDS1YROLcz8kBgBp8BlswE8
         e4uoMV0qz4RDEbBEiL9Cz17TGJutBARL3TU6QxgYFq8USEuQHIOJXbCkdr4qHsMjlQDG
         ORpZCzP2enMnsGx4J/haHvnfv7Im0H7BceXXrUEFnuLkK9z248rsosjt8FrFPObOV7jS
         Osknv3kDBTkgqchDYcdkkrT/NMsLMwGnY2ylolxs4YsVehOxMQWXNdHnEDzkh1LHkauL
         MR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723092; x=1742327892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=949DeBQijWmgHqYCdDdupcSTn3rDdND8nLqwkILEwEI=;
        b=WlJJoKnfKC38r1bnP6vt850/bOXgOIFny5k+MskJtNR/1MBdAuGF8YBB7mSDFOQLad
         1NqkQp4vYGqsQL8FwAS91HC9LyyC40JMNJHrnGowh8G/Ziu35p8gYZIfh7JdTZzOw5j2
         uxEBESuP9hvybeEjiT7rgUpAoQAidmsx5DB02xO3DKf8x1JhavGWUaJfpGp/BvUpCH6T
         GS3vIuett/EJYqKR+5ToHDhzKvQGvbsY4LGFVucs3UmfnxKno4sFMXCrnT24l0InLYav
         /0gHJ1TYgXPaG6SOJD3AAI/QWsB9Gzlg0T3S+QFRJo8vcevun7gNjZO6rKpdzCF+IaD7
         X5EA==
X-Forwarded-Encrypted: i=1; AJvYcCVPibrjvwwCY4a/FcwTwa5hdI5/02Q+iEhcRPEM556wRYIMO1i3Gm2Dk3xbzvghL3OGdz8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZFbgg06yVzMgGxuRxta7uwjtZUDkbRBIJFdgTIu/X1OL4Xlb7
	2iJDPnV86zSn8SXL4sp2HuEa1waz9375NLmyp8ZdAJu2SWPlenO0YHsa995RMgA=
X-Gm-Gg: ASbGncvJYmH0nG3+UWXAmAP4WPRHN6GBn5yS5T4qg4uenrZf3Kvz2rUgtkuXDrcnqZV
	V3t2blzc/bJniYiLIMn09q8e9Ce4CKJy9cq0ppcctZtJk3HBdcPcXvf2y4gW4gYg4TtUHbT+zQF
	zbJlX1Y+70EiOhjgj6BopJmihieW1vH1YpsX28Ri9b14/PfxJRQP0DuUJ7njMEf27zdHqgGbAPj
	BFpgFOvkPmEzNdKY8Qvh5PNC59bJlEPIKvOiD18GivmlwE0ouvTGXjicRjw2C0TePjKYuhqB2s8
	kc2nGDH2Sol5J1COZF8sFM6CCIRY9GSKVn6KWZ3HnohoPEuHzn+3AA4=
X-Google-Smtp-Source: AGHT+IEdn0vUjdqWf+0ft6dtNABWq7WqhDB4TNeuQtg0nIMIUQeKA5OeniZU9oewAupJBz+i092ynA==
X-Received: by 2002:aa7:9e43:0:b0:736:d297:164 with SMTP id d2e1a72fcca58-736d29703d5mr9263457b3a.1.1741723091837;
        Tue, 11 Mar 2025 12:58:11 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:11 -0700 (PDT)
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
Subject: [PATCH v3 01/17] exec/tswap: target code can use TARGET_BIG_ENDIAN instead of target_words_bigendian()
Date: Tue, 11 Mar 2025 12:57:47 -0700
Message-Id: <20250311195803.4115788-2-pierrick.bouvier@linaro.org>
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


