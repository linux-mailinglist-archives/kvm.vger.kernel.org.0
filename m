Return-Path: <kvm+bounces-20856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07A099243AB
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 18:35:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA53D282A33
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 16:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A2D1BD51C;
	Tue,  2 Jul 2024 16:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bo+c9r9U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7B81BD4F1
	for <kvm@vger.kernel.org>; Tue,  2 Jul 2024 16:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719938122; cv=none; b=Iy99zJqTnYulNqcJsGVxDLLOefVLjYcpZ1EEikZwssNsUBH2ygHL/62wAKVIOfzV2a4xH7U3lbUgwt9xhbABzh4jGHB+OB1t3liroC1U4CI4VGLc52QvtZVNbslMu8Ygb/XaUrQ1g0LYSggZifEOOi3V67lI94VGWXR+DAiy4rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719938122; c=relaxed/simple;
	bh=pY8x0+IL41Sv5h0liBJxf5jrHXv+KWn3gxNFTzEI2gA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O4m/8I4ztEhH9JDPQwA0mnF4GmAWU5Dp7q6qasHOLhqDQp+3uzY+m2QClN97yFeN+SVisWQdrJYnhDhNhSSEKP585QB9IJsGeuIJKaNETudtvbbiM4cbzNP502ZcQtdp7T5NVr2rqOswdvLkEV0DBOhh2/Yh0UR0WJURk/DYpXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bo+c9r9U; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5854ac817afso2255123a12.2
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2024 09:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719938119; x=1720542919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2PdP7fwhovm4zuFbTsGS+kYSr4P/6sfjgnZ9Yiz/Fk=;
        b=bo+c9r9UW/nxbwK+6byfLZmrvZMnDsqurx/F2oUlN1DT2sBJSNsFJ2eKUtro0tVSTj
         Rig3Z6fSB4yZFceEjrxGPV2feZGDS38XA5e5MIpAVxaPocGtK64s3G0L1yV34F3eZIO8
         MwiNIbiqlc23tEMse+DnilFJsf05C/mJyS64T4wTB2ng5zrjfsUU3mXk/iOS5Kc/Of4U
         vTgP57PA5OtxC8M8qDOc/NXQLUj1qJlv0sQdnkCGWVHOLBNgzohdlT32g0STojU4FYxH
         LMa5Wge988jz+XPERsWkIwQwHtYyIcP7VJFgR6ivMckqYF7NfJK37vY+FfQtnqnLSyxD
         p0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719938119; x=1720542919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d2PdP7fwhovm4zuFbTsGS+kYSr4P/6sfjgnZ9Yiz/Fk=;
        b=AxdKalc6JsN2rlIM7ODLpP9szrOQG3TBAilMv7lMSRjBBxAdeyz/Pq1SlWPdLjqnlr
         tQ+iTZf1Aad0PQ33xA3YgGKIaZrTyBKQeBcb8Oa6IlygSDh9uw3V03DtnbZ95Jugw1/N
         AycZrI95Y6FB5nm/vEYfySkgiksmsYfp5DPGem0Cn6ny1DfoxnOvIo1o39zm715Oq2Gq
         zd5elXUiwvgvMX/CwXgffknuH1uO9jtPwNliqSLsJ7yzvkHVgIbIpXxwzQ3LIqdbqlHQ
         ssCZd4NcgDDiiAySEtZ+vbs1WQ8wArBQ4bogeFw7A4h6qnUV5schrBy8OAmHbgwukE6m
         bHbg==
X-Gm-Message-State: AOJu0Yxfqy+4hto033I6tbdbGihQW50H+GWNs6jQHepmXtG4IhYMOmAJ
	mrZnu8VW6flBCjVZZ69XQZH4TB3dc94g2TyxzS/khkzpsJef8K6m2eUL3JXZ4s4=
X-Google-Smtp-Source: AGHT+IFxmrxAj1VktUMByj7Xw6HSUJJNLn+Inx9C8W4+xXXqlzwq/OMRxn8bbZoKs8uozwXqJXHXKA==
X-Received: by 2002:a17:906:db01:b0:a6f:4bf2:daa2 with SMTP id a640c23a62f3a-a751443c744mr799316366b.15.1719938117250;
        Tue, 02 Jul 2024 09:35:17 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72ab08cfccsm435948166b.148.2024.07.02.09.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 09:35:16 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id CC8685F93D;
	Tue,  2 Jul 2024 17:35:15 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: pbonzini@redhat.com,
	drjones@redhat.com,
	thuth@redhat.com
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	christoffer.dall@arm.com,
	maz@kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev (open list:ARM)
Subject: [kvm-unit-tests PATCH v1 2/2] arm/mmu: widen the page size check to account for LPA2
Date: Tue,  2 Jul 2024 17:35:15 +0100
Message-Id: <20240702163515.1964784-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240702163515.1964784-1-alex.bennee@linaro.org>
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If FEAT_LPA2 is enabled there are different valid TGran values
possible to indicate the granule is supported for 52 bit addressing.
This will cause most tests to abort on QEMU's -cpu max with the error:

  lib/arm/mmu.c:216: assert failed: system_supports_granule(PAGE_SIZE): Unsupported translation granule 4096

Expand the test to tale this into account.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
---
 lib/arm64/asm/processor.h | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 1c73ba32..4a213aec 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -110,31 +110,30 @@ static inline unsigned long get_id_aa64mmfr0_el1(void)
 #define ID_AA64MMFR0_TGRAN64_SHIFT	24
 #define ID_AA64MMFR0_TGRAN16_SHIFT	20
 
-#define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
-#define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
-#define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
+#define ID_AA64MMFR0_TGRAN4_OK	        0x0
+#define ID_AA64MMFR0_TGRAN4_52_OK       0x1
+#define ID_AA64MMFR0_TGRAN64_OK	0x0
+#define ID_AA64MMFR0_TGRAN16_OK	        0x1
+#define ID_AA64MMFR0_TGRAN16_52_OK      0x2
 
 static inline bool system_supports_granule(size_t granule)
 {
-	u32 shift;
 	u32 val;
-	u64 mmfr0;
+	u64 mmfr0 = get_id_aa64mmfr0_el1();
 
 	if (granule == SZ_4K) {
-		shift = ID_AA64MMFR0_TGRAN4_SHIFT;
-		val = ID_AA64MMFR0_TGRAN4_SUPPORTED;
+		val = ((mmfr0 >> ID_AA64MMFR0_TGRAN4_SHIFT) & 0xf);
+		return (val == ID_AA64MMFR0_TGRAN4_OK) ||
+		       (val == ID_AA64MMFR0_TGRAN4_52_OK);
 	} else if (granule == SZ_16K) {
-		shift = ID_AA64MMFR0_TGRAN16_SHIFT;
-		val = ID_AA64MMFR0_TGRAN16_SUPPORTED;
+		val = ((mmfr0 >> ID_AA64MMFR0_TGRAN16_SHIFT) & 0xf);
+		return val == ID_AA64MMFR0_TGRAN16_OK;
 	} else {
 		assert(granule == SZ_64K);
-		shift = ID_AA64MMFR0_TGRAN64_SHIFT;
-		val = ID_AA64MMFR0_TGRAN64_SUPPORTED;
+		val = ((mmfr0 >> ID_AA64MMFR0_TGRAN64_SHIFT) & 0xf);
+		return (val == ID_AA64MMFR0_TGRAN64_OK) ||
+		       (val == ID_AA64MMFR0_TGRAN4_52_OK);
 	}
-
-	mmfr0 = get_id_aa64mmfr0_el1();
-
-	return ((mmfr0 >> shift) & 0xf) == val;
 }
 
 #endif /* !__ASSEMBLY__ */
-- 
2.39.2


