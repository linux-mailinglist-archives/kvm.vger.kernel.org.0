Return-Path: <kvm+bounces-45378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F4A4AA8AD9
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D12BA165FE7
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025521E834D;
	Mon,  5 May 2025 01:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fgOh2AU3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996541E32C6
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409979; cv=none; b=H7qLFJG7fZrZvjGLCWY5dQvJ46jEr83p20HutwMfVCun6VbFfWGAOQdJN2UTHNwjCHYudeoeOIm19ecfYtt9APfkcYkpQ6ttPDy9AKxZOOPOIU2G0kuD0SEdRXy0c9iI0Kxcz/NutKN6dDim3Pvpk93/J2NC7zVy84ERDuiW71s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409979; c=relaxed/simple;
	bh=JfZNVY4hxn/F80wsu/sK/tFwdFEqzR06bfiZaB0QHo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lvjHUmvvfTBHQhJ4tRKz5HFixJoAQ7Vx9REE7NI+nGRKdxf2nIUskr2FAAL6HxATi0nR8KhJuS0PRyv/bTeo78+qP7IOEiIaVugmsLGZ7H5Wy8cQGykqO8kjO533DzQ2/AcmmEukZtOkg61nDZfpQVjMfU8t5GKJ7//O6OQ3xNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fgOh2AU3; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7394945d37eso3163826b3a.3
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409977; x=1747014777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEdUza85WO+DzwzEMeWL7z4M0hhaS2RgQrae4P4VTDk=;
        b=fgOh2AU3njDiQS3HVu9Jj/lFyYnRAxspJlvMYNzIyEX6RWG8EXVWTOBknIwtPrmItm
         vnBh2WOsbyCGuBq4jKJbFnSKpV9OYiC4HehIOUImRNT/t0MImrbk8Jwdt+mi8KxI8oJI
         GYfULJmcVvX+78FgaSTYXQOJpANIDYXsBTxHAeUWb11q6+VDX068JGRkjsLkINiRUt51
         hJRRbGPPyc0zLQvPw00gxy4VJKP8vAHp1Qd82Yvje5hg/Vu21YfTStGh2BH/YSOxtlZ1
         1SYa35JFrTn6lvauoTDbJLoY2aXWjSRyYxlP4/vJoF7uUsFgyV3Hq72uwoKJnXI6v39S
         c7fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409977; x=1747014777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oEdUza85WO+DzwzEMeWL7z4M0hhaS2RgQrae4P4VTDk=;
        b=in1bKbtNvTgHhp9AtBFWPXuVShta5kwU0DKc8mzwNR6rDowRUMJIPxVfoQvz1BKmwE
         VIitgIfTVnQnv4yBo52djK8qOwkRlmxyHlCWh1p1Lb5IixLo0Vjr9X69vfw9SAHNHUO3
         L1wui32tUwbQKIs8VMBSgEQP/iRtYd6Munv1MusxEATuiVvRxk5TKp92XRM0mFFStyFg
         pbLQDLq214b+W80OQyEAVMpRQ0CGD8LjaowItkJe8TzxdO0wjlGvmOascflY74pxVeyZ
         JCeYNZwqoSr7iQvdJW03lFoNX562U4apB72fmFKKNumbzng0kuI1eel+Kl+gSc6rWkSa
         J6nw==
X-Forwarded-Encrypted: i=1; AJvYcCW2R380YwchL0lvGxaL5x3piaHqcOFgnk/eM5y0Qdbj97Czt2SyDuaLnNNBDRypr7R1ziA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3WpwTCcCyvnHLNBC4h5VsjXaN9qf2PtABRZIF68hNmACNKOaw
	g8PdE+0zg0gzQP8osbMuhjoeMRiq8SeXQgnVQlklU9Gg7ddYtNVw0xH5zv0RLe8=
X-Gm-Gg: ASbGncuTOIAoZNLM2dmVIiS3Uhc0Xu8rfRiU82pmpIkBaSB9vmRJj+JEJreubNrjtw1
	+/3BHWIMqnXGUkBWrmYjosNVPke3pWEEHMhkfEuolnAGO/Fw2rKB2su+PM05wL/N9uwYp0NLvoF
	AZPQUzc1LJ69Nn5ta2+gyJFsh9i0NEQeSRyGggajHcJwMrENnCSdElOoWgddwYlT7mA2MXNdBy3
	rpF78HULcavN18Qb0u2tQVrv+zxF7TT3iNTfqNZY23AfJxk6QeXR14LZpJhxgvyyYCtWGl/ZNF+
	jLgYi30cc0L12ox7/k2uisNfg+jOtLEFS9WsBWAn
X-Google-Smtp-Source: AGHT+IGxlO9gTykq6ulNB0WPj1QemoIP4SS2JOIADwz2/WJQVG/BKVmUJZdt8lSEKyp+6CHlJm1dyw==
X-Received: by 2002:a05:6a20:7350:b0:1f5:535c:82dc with SMTP id adf61e73a8af0-20e97ea92ffmr6762334637.42.1746409977012;
        Sun, 04 May 2025 18:52:57 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:56 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 31/48] target/arm/ptw: replace target_ulong with int64_t
Date: Sun,  4 May 2025 18:52:06 -0700
Message-ID: <20250505015223.3895275-32-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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
index e0e82ae507f..26c52e6b03e 100644
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


