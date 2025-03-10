Return-Path: <kvm+bounces-40551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A2CDA58B57
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:59:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C961C162D31
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D89FE1CAA6E;
	Mon, 10 Mar 2025 04:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CLjG/PCr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A6B1C6F55
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582738; cv=none; b=TUzTwYVdRGAD9uYuh2vKLP3jW95Z1Na2/Dtf8/AFIQSgksDIrrs0F2lRM0TfwdSQaSSN+jHzbAwBDv0mErd9lvHU/ZamKPMtZwEe07ITMfKubx0gBWc+EbY0gpvSFianuiEWwI0Y1yg2IO5xtee+gpRbzdaJvX+tF+VWc9TV5Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582738; c=relaxed/simple;
	bh=mpLFw8B8ghgvo+W4mdZAKRhII4Cqk+UYWdUxOdK+FS0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ss2/CuH04qO9Wjygrmin/REECOTWe468cBbTcoql+NkcYqqU3AP3i06TeGXGTc2wfXa8WzysGg9rg0yDhU4esAC/vWfqGw2aDpeJ1gnscyywXFpq2gKC8TQd/oqTsa5zc1PRRQvWJ95CMYT+aCbeTk8k4OLrGOs7qwfNomVTXLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CLjG/PCr; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22398e09e39so65589525ad.3
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582736; x=1742187536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gKLFWb+An2Ks9U+R2rK1VtO2Tw0/JUbGbAmdQc7IQwE=;
        b=CLjG/PCrNZcxhtd+q+JkAkAi6eGwiSZabHM29ksJAyfuH1N0CXOHfRplBKs5N0xqZB
         uHXEfvsHV9CEO0UyL4kkBNrxZ3/wG6Ry1wqRxLRi+mTmoxlBIo5AojPkCbyw1gLefLgw
         XtDg2SAnpcBkgjRxGwFCbpgtkAS7Uk0F101RkAuv9J71oGjMwe8Q9R66uw8EJrFGy42t
         Wp+gTljZZ9e1CW/Gma+Hiipe7ZLSrUuhtzWDTylc1GHjkMR1OxZ/LbHU5nTGreT7pQJ8
         RkUAQhx130rC/FhFXzTDMSPdxmAhnS6BKlAhJJSXuSSz1sNnefiHlt3mSeu6LA1jeRd1
         WDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582736; x=1742187536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gKLFWb+An2Ks9U+R2rK1VtO2Tw0/JUbGbAmdQc7IQwE=;
        b=rB7oPuTRcAOWPiqEdt1k00n9iFj6PpP6AxvT/gY4CvrugtuCXP5KCySpFEj3MJ+mCF
         DgPRKSdYyuXeQgXcdgXFL+sPGfkXD+hXT/kOQmz936q7oe/HXWkjBROx5JyHambHjqMb
         D2Le+LHoo5zmvFbJNuQl8bYnVKtuEbK3MAaTP1JND1IlgG5q2TTXvFIPAwbPxwA62tjL
         LMDwuqCtSQ/RZ57oKLhiHEI2LXvf5jIqba9MpasIdIeJcHU7H/mCoswsB/eZ666kbrSU
         Ttz51M+XUZrUm+PuIMUlIu/08bjROopKbpQ7imj1GChI6wFV0ozILOxNdD2yjiTaL8Mb
         VRTg==
X-Forwarded-Encrypted: i=1; AJvYcCVddSdNjVox9b+lJgQKFmxOM8c5T6qHVj9EiI43nVaGpeh6dFkka1MuHdAA554wduO8DMY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yza80nt/xz9t3P72NmSoIw+xLs0vPCY5ZcGfgF3te3xU7T0JR6r
	ftfS3juAMloL7wuBzC+uwiQOawguIdDbkqdkkoUIyPMZ8t108fDqdj+ARyE5Gbc=
X-Gm-Gg: ASbGnctmfnLM7+CXcmg8CfQcbFd7XZ7/LRSTS+n7xebWIZSseFn6tBWGfgTBNwWQvae
	PeC1xFUgGvijJBS+iBvxe5NV494Jz0tYF3tZvqdRYCrve8O9fHGvbzz6mPyNlCwMfjGIn2yrtsv
	luaGNb3yg2L3XIzL5Zc6lxriHMhLxomRoTVodJKIq2D5dk/evHpgOrUqt97V9y1LZCP66JuDkA3
	FpuLMuEMAv83SwiExxkWhCVeEfSn8u2SHQdQR1o6Gfw5K/tJJeQ8H1h0j0jO126sd7098RLEsuu
	YeH+661KwRPcOh93R2D1+CZRTZ4dCcQC5n2sk9vQbD9S
X-Google-Smtp-Source: AGHT+IEAovvlOy2ME9s2bcowigrmpQEpYOhHLOJWN1HotCTdKvUP3vKFXajlsE4wLKble7VBohAKKQ==
X-Received: by 2002:a05:6a00:4fc6:b0:736:32d2:aa82 with SMTP id d2e1a72fcca58-736aab17045mr17832470b3a.23.1741582735793;
        Sun, 09 Mar 2025 21:58:55 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:58:55 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	manos.pitsidianakis@linaro.org,
	qemu-riscv@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 05/16] qemu/bswap: implement {ld,st}.*_p as functions
Date: Sun,  9 Mar 2025 21:58:31 -0700
Message-Id: <20250310045842.2650784-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For now, they are duplicate of the same macros in cpu-all.h that we
eliminate in next commit.

Keep code readable by not defining them with macros, but simply their
implementation.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/qemu/bswap.h | 70 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/include/qemu/bswap.h b/include/qemu/bswap.h
index ebf6f9e5f5c..46ec62f716d 100644
--- a/include/qemu/bswap.h
+++ b/include/qemu/bswap.h
@@ -442,6 +442,76 @@ DO_STN_LDN_P(be)
 
 #undef DO_STN_LDN_P
 
+/* Return ld{word}_{le,be}_p following target endianness. */
+#define LOAD_IMPL(word, args...)                    \
+do {                                                \
+    if (target_words_bigendian()) {                 \
+        return glue(glue(ld, word), _be_p)(args);   \
+    } else {                                        \
+        return glue(glue(ld, word), _le_p)(args);   \
+    }                                               \
+} while (0)
+
+static inline int lduw_p(const void *ptr)
+{
+    LOAD_IMPL(uw, ptr);
+}
+
+static inline int ldsw_p(const void *ptr)
+{
+    LOAD_IMPL(sw, ptr);
+}
+
+static inline int ldl_p(const void *ptr)
+{
+    LOAD_IMPL(l, ptr);
+}
+
+static inline uint64_t ldq_p(const void *ptr)
+{
+    LOAD_IMPL(q, ptr);
+}
+
+static inline uint64_t ldn_p(const void *ptr, int sz)
+{
+    LOAD_IMPL(n, ptr, sz);
+}
+
+#undef LOAD_IMPL
+
+/* Call st{word}_{le,be}_p following target endianness. */
+#define STORE_IMPL(word, args...)           \
+do {                                        \
+    if (target_words_bigendian()) {         \
+        glue(glue(st, word), _be_p)(args);  \
+    } else {                                \
+        glue(glue(st, word), _le_p)(args);  \
+    }                                       \
+} while (0)
+
+
+static inline void stw_p(void *ptr, uint16_t v)
+{
+    STORE_IMPL(w, ptr, v);
+}
+
+static inline void stl_p(void *ptr, uint32_t v)
+{
+    STORE_IMPL(l, ptr, v);
+}
+
+static inline void stq_p(void *ptr, uint64_t v)
+{
+    STORE_IMPL(q, ptr, v);
+}
+
+static inline void stn_p(void *ptr, int sz, uint64_t v)
+{
+    STORE_IMPL(n, ptr, sz, v);
+}
+
+#undef STORE_IMPL
+
 #undef le_bswap
 #undef be_bswap
 #undef le_bswaps
-- 
2.39.5


