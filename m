Return-Path: <kvm+bounces-41088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4866A617AC
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04FDE166BE7
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD7978F2E;
	Fri, 14 Mar 2025 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uV9IrwiU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D692629D
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973508; cv=none; b=V/0kmRyzShZuGOQQ1RYE9SLGOZcOrdhWMpvDAxcpchhuZjhSjAPZ4TnJHLUTZpkPYr0JtIXaRKJPngWj6x2IB52ymzWKACryHTiDUuAmo5kIT7qaVe6yMSCyeizCEN5hUirB8FYILr8Jp06Isy27S/MY1o6TfjcuCZyDb/MiSc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973508; c=relaxed/simple;
	bh=D7kAKGSn4zAKkiSs1hQlq6vEceALs33too5mFmMr30Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JTMUYYUysnddYT/ar2/CRBOGa+LEwXUWKrYmO0f/FO2JKpsY0ul0S9Q9iEtr9eFfer2sZoQwfzPc2kYcGAbH46paRlLO/1jEhITIHI933ij8B+g+7FSELP6IWTqDYnEEhtskebfrKGovKwK3H+cj+Z109jqk8rD/FhK2dg/zpjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uV9IrwiU; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22355618fd9so48786885ad.3
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973506; x=1742578306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=949DeBQijWmgHqYCdDdupcSTn3rDdND8nLqwkILEwEI=;
        b=uV9IrwiUhNl1Q0gvrwlyqXmv1hLHBVnuq8ZzJW69WeLtR9eUyOck5GcS3fvUjoVj+i
         lvPcZYVhciJzc40eB31PqTXOFLJLVguAYlHLfVC92/iBv4lxsmYTWLcCxU2PCs9/d57E
         y5MSGDqqoAHVb51DcVXMmYa5rnV3HAIJpUdSFb6ODYWflzS2aKnqVHDv7AuFplmfunhQ
         6kglRFfFzZ0lNopDwWb7Sh4Pr7x3zc7yVsLMm66hBqI44hKw44GkUOuhvRoXsRnsjC65
         /fm8nMZNFA2WawXiwe4n9eoqZXtHvWvp/ICJOBvTX7U4LxClzY2u/WqG2q8YxKHVeQ/w
         mgAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973506; x=1742578306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=949DeBQijWmgHqYCdDdupcSTn3rDdND8nLqwkILEwEI=;
        b=Z24KhC4wampJbvjGxSJy/kVA85goXK4ApPMFry+4d1eW1fQfZC8Rr2yE0aVGMgyQ+U
         nNfcmAYfZqZVqizQTb57lrEcHhZn6x2fU7FJdzWuTC8oiOjQyPtEd+/DBkPM/D+UbacT
         dfQyaNIbkLGz2SDkxo5sSteFDgIbA4ZOcimGlU9sTuhW3TOTgaBfq2JDUeVnf1fRgik8
         YVq+2/FZTj3Pflb5lML/T1LBPG7nfEM910MuEBtMmopCfGYwUXCUU/A+WzTVQMJhw3Nx
         3oFapxUgysiVoaKMu+EqVwjsIQ8j9woe8gtYQHWsbk3/i5H2178wWQEZym3YVo3tE47d
         /IFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPdpCsgZnvmt7lPu4nqbIvtMM0Tn0yxjXz1lnwHIYStlaU3ySJEOIYMUcWgApI+FFLZwY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+BLa6urjIFQbWBPQHCKaQTGxJUTMMmlMtTOZzkNmUuvKtqm2I
	ID4M/Ei1MtYND2IY5tLxj/aKhLhg+SH00IXlYuuUdYLYj3ja6hljOYTy1lt1FrI=
X-Gm-Gg: ASbGncvV0ljQHw1txChBlidj78T4Fimn2usbB4i3ibPB0q/tUREI3F5LPo01AKF9QHT
	NAGcU8js7PGG7SDqFnKyJd1iDeZCgm513/0gVlcTYdLIA/MPvPESoRWqeJOtth4cl6nA4FVLD2F
	fSq1KPItFl1jQ1+NbDC6Pt+0ZHSlPNZvq/Xs8Erwx2QACG54nBZ2lEYT50cWaOg/WHtVqOS7ds/
	NycqW+ngQsmltIzRnrs4UOX0XU/GiPv5IHQLhLffM/2U3wVJWMz2xwbXMBQ1Cm1bEqEV9LG1p/6
	5RsktCgH9qxI3N+n/sfyTuGkXdMIZhsRWZ8DNlGT83zJ
X-Google-Smtp-Source: AGHT+IEjELEcHkUSgYSyUpOQLSDQBfR3q2soKgt+mWzeI9X+HyRoUAOICNrXniu51BG9jWIge0MJZQ==
X-Received: by 2002:a05:6a21:168e:b0:1f5:7f2e:5c3c with SMTP id adf61e73a8af0-1f5c113795cmr4514154637.1.1741973505987;
        Fri, 14 Mar 2025 10:31:45 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:45 -0700 (PDT)
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
Subject: [PATCH v5 01/17] exec/tswap: target code can use TARGET_BIG_ENDIAN instead of target_words_bigendian()
Date: Fri, 14 Mar 2025 10:31:23 -0700
Message-Id: <20250314173139.2122904-2-pierrick.bouvier@linaro.org>
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


