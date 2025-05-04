Return-Path: <kvm+bounces-45324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 700F5AA840F
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:32:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7E2C17A18B
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512891B0411;
	Sun,  4 May 2025 05:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NKiZlmWD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FFA1B043E
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336589; cv=none; b=g7Phe/3D92cqBcYv9ghlxaveGcvdy7T2OBFJqNKDhihNThRIa3id1t0fQsVEFqsmRMzZbS9WKD2/F+N54WkoycLEywtXOJ55U5j28yifbc7aah7eKLjsMOf4qe6eYU/HgjT9WAe/nxtG+kB3+goTetvvh3nk2uAIMre6RTKMiTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336589; c=relaxed/simple;
	bh=i55ko3u+nUwdC2hX8Z0yTu/wcyOEYwm/wdKHZ62vY8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rEF7xELGRYx/eS+mF8KH10whRfXLh09XZ6qtDDOBQcXWIXliqjA0SKclvD3NbKl56iHfsznKGEI/683m3AgJJ/6j47meEf2pY96/jzv3OHne9+g1zfxYCiZEPB52loupId/qlXLuRNpBmxRGg7i0PefeoQLE4S0H3umN3MPZtg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NKiZlmWD; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-736aaeed234so3024296b3a.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336587; x=1746941387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YoA0Kgl2rygvKGIkAwhDx+FIBh00kPrYN/3sfHQDQ5M=;
        b=NKiZlmWDe1Ko3GOBf6OpdCJsEQjON9RZqzxEUuFXQgOhA5M6lGvorEel0bnwKvkvL0
         gzw3/xVLYGQKfmumtmvlAsRlcSAgDPC9REl8ARQw35NSuJOTMjIcL3lZW9FwgEFJLnxR
         zU1TFvc9fCwyqi5sdQQp28m+YkME3cz8GzjPTO6MrknPkl76xcgQ9paK9LbR0hBF7mRf
         lc/H9ohfUbE4IX2WYX4w9z1ED6TBIt5hVFK2Z0lI8KDeuGuxiai2do6CYwVWJJTFKehC
         41OsTyiLp81byfZ9MHPdFNLWeng03e3pgBgIXO7qu9IWrPCXX8lvaucw/6kMppAk8RjM
         zwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336587; x=1746941387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YoA0Kgl2rygvKGIkAwhDx+FIBh00kPrYN/3sfHQDQ5M=;
        b=M+G8jydPQk6IPYYllMHenxMI9e70h1nHygU3yU8y3vfXczO0Dus+QJ6AthOlyPTCoX
         cexGvNnuvJxNOgKpbPTqKVoT4WG1lHtYLEAFwf4REnBd7y6lxAUGdKnfcNyKknsGD5aZ
         oWcevfugAZZ7M7ucIfN73EuoE20K9sNtK9U54G4NZHyDfm7sSVCVFPIK4OGWHLtMXZaA
         mEOQSIcueLPkFqX3UjRV2Jz3Bs6rJ5HqZ2go4n7dztzMj5FtujCmHoKD4Evfd+7nr63x
         MacgPilCZArna0mo0JFDriXkpoODdvvw35bkJUN6W+kgTsYjNRREGRxzHT5atk8v3kTk
         pnzw==
X-Forwarded-Encrypted: i=1; AJvYcCU+tsC32J1x3g5Y7lfVjzpHBE0/NkaGb85qlxXH4azFs+lHYOZVQ8h8T1yC/hLEVVrbVPk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCk3BWhcmeOL/QJllPCxqoBYxfKoSMiEiZ5Ft1Wxy8CNHoGY8C
	OW4KPMl++nO9t5Gdhiqc2D0Zy8ssXfRETledzdcyJKslhYGbAE+Au/wL1e645ww=
X-Gm-Gg: ASbGncu09k3Pb+7DsnxPeTCUjpsDvbb/OrXMpefWCkT+UE+RurO33maHCs3+jjXi4Jo
	4kiEfhDRAAfL5wzl9PVc5OET7iQoSG+q2ypUR7qB5zVNdDN+Whnjlex/C3QzN6RXFbIkhvmLe5A
	W6ic4NtyECh7aGUFsoalMeDHGQhElgbHIJ281PrT+mOpuz01WjQ4qpcdXm8GKpXaql9GpMTIVMS
	Wd1dlEmXa6++gykpEe1cjS4UtzErFDKWQjpKfjTBpHa+PG8GpWeO2s+WyrtFPD1YvUZJ93DB1sK
	+5PiCYnRy03lzCAESuV7ht+nA/2SCQQ2Zkhan9tG
X-Google-Smtp-Source: AGHT+IH3vm9MpG2MZs9UPMSWDERbKRH/7rBr8oV4iU4Hz/r/vqw8nSgxVg2rOHV0XUqnb0ez/kKhKg==
X-Received: by 2002:a05:6a20:c90a:b0:1f5:5b77:3818 with SMTP id adf61e73a8af0-20e97abe098mr4252718637.27.1746336587445;
        Sat, 03 May 2025 22:29:47 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:47 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 31/40] target/arm/ptw: replace target_ulong with int64_t
Date: Sat,  3 May 2025 22:29:05 -0700
Message-ID: <20250504052914.3525365-32-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

sextract64 returns a signed value.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/ptw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index d0a53d0987f..424d1b54275 100644
--- a/target/arm/ptw.c
+++ b/target/arm/ptw.c
@@ -1660,7 +1660,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
     uint64_t ttbr;
     hwaddr descaddr, indexmask, indexmask_grainsize;
     uint32_t tableattrs;
-    target_ulong page_size;
+    uint64_t page_size;
     uint64_t attrs;
     int32_t stride;
     int addrsize, inputsize, outputsize;
@@ -1733,7 +1733,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
      * validation to do here.
      */
     if (inputsize < addrsize) {
-        target_ulong top_bits = sextract64(address, inputsize,
+        uint64_t top_bits = sextract64(address, inputsize,
                                            addrsize - inputsize);
         if (-top_bits != param.select) {
             /* The gap between the two regions is a Translation fault */
-- 
2.47.2


