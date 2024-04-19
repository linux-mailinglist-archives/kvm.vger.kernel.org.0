Return-Path: <kvm+bounces-15331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A6AA8AB322
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:16:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D16681F21226
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E9E131E23;
	Fri, 19 Apr 2024 16:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hUx8dKSP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F008E130E3B
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543395; cv=none; b=LnJvIcZ6omZnWYv2s4LJRRPn5Wws86slCfx5oD2gYmGluEwvOK5tHRRbO46kkVaFcX8JccsTjzZ9gb+OxeNgnGvSAUlMySLHZAZOiFo189Qq60FBPyQAFuAzD8gvjLTk4F/ilBh9lo7zqkvzUeSkD8fxil7okw7LnZEVCfTNkvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543395; c=relaxed/simple;
	bh=LxpqhNiHAz6SvsLDXG7NrMJEe2ibA6UXfjbUpU8Y7ag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ejS3bGKK/usw5Rr6iQSK8GZINet0kpRZRXfU6wbmutFPFCR1KT5KONHdrgFo9Es7qAqphbXAUjRG5Nx6920hWFV7y2r/qMQlTko/TaWbsmKeo8ADZLSlvII/AgqpJg6/seDO7GY2rSY8YN2EwcEpKzAM5lOXNAgCaZc37dHKOOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hUx8dKSP; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-419c8c314d4so3020915e9.0
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713543390; x=1714148190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xin2iwTu/4c1Gy3XovoLyL3hBpjPxSwWtnXs1CtSYxs=;
        b=hUx8dKSPucKK0MRmjv5QHcTa5hoTkLn9AEU9UIEsIvJzxqC+odg04oEx1A2IDbeCj+
         BlUxfjakxXmcFCg8a/dJVd+cVfaBxQNfYtftk3t1Y1xL25H2682vFR6rT/mKSddDQRRR
         YpOmnDS2/ApC1h9LC3I7M21EtBYhXbjlksh26N+SiifDXlfUTjyQBZxpW2OOdQtMPFU5
         KX6rcXl842L4PyebUA/G0j5rNRdMFSpCY0KTtM2xMjqoC/il4SVMRwqBdcByaExdMhUr
         mfPRQEUSGlUdaccGS8UWp4xEeMHGkNM7bPyb+2/d9MReDw9QNnff4KnDAEqrqOX8I5to
         bndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543390; x=1714148190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xin2iwTu/4c1Gy3XovoLyL3hBpjPxSwWtnXs1CtSYxs=;
        b=JKypCuhAY9WHnFY+abV0LTiIFB5g90n54hKf35lbzBGRVki8n6EUzBpoyfWa+WyHhr
         cjEBXMTm71MaS2fEgEwm3ynsrPZ/xts0NvTSWcu6K7N9PcioL0JjlsLp5AoNQe9xaDS7
         5XMKfKYDbJU77aUsEafWP7eWjTeJfofmch6OuxY4YVJre/40GgjL6i2nCb2edQf+lKSI
         UZpA1qPkqlHB9FG+RSvBAMSLkZ9GssiPd6+fZqXS/134R/OpZoh9JpwKwh4MGMnvSoPY
         Fkxj1YMdnGk4eUebKZV0sZWIxVA8pSfNt//pmsC9JMr5vEFGlWxdnnwyyBd2NO5wRH4q
         jvJg==
X-Gm-Message-State: AOJu0Yyu3IVu1b1OoalYN2ZNehQ4/fiubkwWboNlLi3uTz43aEXNAg8+
	zOGbcyAntM3wNhm4dvd6swXYLM71r6k2vTi37Qq/RgEnH2skwVhSAIMv9JxF
X-Google-Smtp-Source: AGHT+IGDrm5er1UOnpGoWEpeGySkavL0qR0vR6toV9W2VLrk7yx+hjPJsKMJNCpY8Vzp04VMN9WEbg==
X-Received: by 2002:a05:600c:1554:b0:418:a620:15a1 with SMTP id f20-20020a05600c155400b00418a62015a1mr1778781wmg.30.1713543390487;
        Fri, 19 Apr 2024 09:16:30 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab5e:9e00:8bce:ff73:6d2f:5c25])
        by smtp.gmail.com with ESMTPSA id je12-20020a05600c1f8c00b004183edc31adsm10742188wmb.44.2024.04.19.09.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:16:29 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	andrew.jones@linux.dev,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>,
	Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH v7 02/11] x86: Move svm.h to lib/x86/
Date: Fri, 19 Apr 2024 18:16:14 +0200
Message-Id: <20240419161623.45842-3-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419161623.45842-1-vsntk18@gmail.com>
References: <20240419161623.45842-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

This enables sharing common definitions across testcases and lib/.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
Reviewed-by: Marc Orr <marcorr@google.com>
---
 {x86 => lib/x86}/svm.h | 0
 x86/svm.c              | 2 +-
 x86/svm_tests.c        | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {x86 => lib/x86}/svm.h (100%)

diff --git a/x86/svm.h b/lib/x86/svm.h
similarity index 100%
rename from x86/svm.h
rename to lib/x86/svm.h
diff --git a/x86/svm.c b/x86/svm.c
index e715e270..252d5301 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -2,7 +2,7 @@
  * Framework for testing nested virtualization
  */

-#include "svm.h"
+#include "x86/svm.h"
 #include "libcflat.h"
 #include "processor.h"
 #include "desc.h"
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index c81b7465..a180939f 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1,4 +1,4 @@
-#include "svm.h"
+#include "x86/svm.h"
 #include "libcflat.h"
 #include "processor.h"
 #include "desc.h"
--
2.34.1


