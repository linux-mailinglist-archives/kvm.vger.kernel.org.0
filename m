Return-Path: <kvm+bounces-45047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B54EAA5ADB
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:25:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3ADFF1BA7648
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A5F26C391;
	Thu,  1 May 2025 06:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T7UsSyBn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185EA230274
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080650; cv=none; b=qu9srw7JUYGR2nQ3tRS3tLEXe7tGNZRYnoHS8p3geBCoWKgo1HwyQo4zHeyaF7MxO6BtnfFJqyAuljF6JG+wX76rqYaNZaQ093ICDeeNrOKb9ZA7I97lUjb51yBXU5rr6XJxNguu+FF9plwlIjDfL79KIBtF4tmD1ZEv8CGbOeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080650; c=relaxed/simple;
	bh=/YX7jOzP1uUHif+liOCEeLJvXPlbmSiHaTYoe4sRu5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQ8sPfHMqeaFNBZ+K6gyvXcV4K7KYvCecX1OQwawImdFF7VFmKZWzMdNmvuzOtWwgCG7qfmAFt1ZGELCF2rJoJB2X7YeFMUKgCgIsZUyoPoxaSmUxReP8sL5qbOY8pzS4P5SBcgD6n82G8wp5s6Yb1QbDAS4F8m6oy03ApAmXo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=T7UsSyBn; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-736aa9d0f2aso992740b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080648; x=1746685448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V8qwK/HCEw1i46saViqejeACvzUpjG6Ezmpbs5eELYY=;
        b=T7UsSyBnnlaZDqOyJZv6hJDfiXRbpFUp27jQRrnUTt7BJsPe1Uiqkud/AEQfzP6onz
         JM8tNMv04plbNR/xWH6BnaVIunylbdy4xYcDW1a0R2atl8/BsvwgzFAer5B2oBGFqPTF
         V8wufCR/kWIOT6It1LtKzhxKkRxwkCXtm0sdYpbPT22vNQU8JDpIqiVfGuVD+0ItgbdT
         HhyQDeaj+0X+n0lII2Q1YT91d6fxc9eSOkxh3OfOSWlhE1HRfQsifq+VLpZMsHnB+wg1
         ECffvNLnas2hQbrhT/sSam4dFV6vL3T6dkdifA5LjrpWfuFTiMGPW8fP6fr0RjAWsUUl
         P3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080648; x=1746685448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V8qwK/HCEw1i46saViqejeACvzUpjG6Ezmpbs5eELYY=;
        b=VIjDr2fAlM48MJ8U6SxX+7uwOlhlYyIb7YMh7PV6bCSNdQLA0CCByAbqea6zakwZCE
         OgtuFE+OH1t6GT8OlTgncCPdZyE8rIHTo0brAV74lIBfHieEHGrUFHS6Q9plKHLyL2B9
         d5arDIV02aRpLbPJpt8sKV2RpkFL4GRR49FwmRnxtZRQdINbHDSWmjVv8gkgB/rb7Z/F
         TWuvXfoyy/dtxxNSq+5Cxc3IwNLTphvxO7eu6YWlxssVOiVUV1QEs9AiyiUo/4EbayC6
         LAXaNMLj4Eg+zjOdwKJcFuiOkyOxy/ckqnVxPQc+aUb3lXAWFQVJhEQfnyQyd/zp4tZH
         wHbQ==
X-Forwarded-Encrypted: i=1; AJvYcCW14f4ujZ4VHxj+E2lz/1jOgi3aAwWkQ2UJB8tXho/iMEAxLBf68HTOmRaP8+x29Se0/sU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKPo9kApWCwXoTg8lOlw9wb56nN18wv3VxWo2PnMg/wXoHpCOK
	qzXan0kbnr8FqsQT8Qpp49mqAtyTz10ICfZpd1UpNf3b2VheYBUfDFQK5GIwmUg=
X-Gm-Gg: ASbGncsVXrKz2Ih71N/C80B7uGI8maX3MwPNa+PmDq4HVtBim7reatB20p4SnwG2lRE
	z5DPwd1OT7Tw4HGbBbN9nEijnJTP74Sv0TMMMTVL8pu8RbVWRv77mF6a19wQtccAJQZcpqo6/xh
	/ENDF+hhlbkFdx9ZO0QRNuwSa8hOZV3UajwwNoFoG8t57Al6uNxjSGuaGul7EovDfo4LEoqtTNh
	Tt9yVCCE1GSc2wejiD/klQAX/85MwrUMqd2aCghSsUaxctVqCFsKgv+PxYS43xMfjtU7VUUofWD
	YTby92bVYPiYEHdHx+T9F2A/GA40xcibs9oGxmkC
X-Google-Smtp-Source: AGHT+IGrgUKmcCRVBMb5krJnI6qBInswBqP/CfMh/qvXh475gMhq7CTc84gIms6BVmzHce7FJGFwGg==
X-Received: by 2002:a05:6a00:2e9a:b0:736:457b:9858 with SMTP id d2e1a72fcca58-7404777fa13mr2551923b3a.10.1746080648457;
        Wed, 30 Apr 2025 23:24:08 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:08 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 19/33] target/arm/helper: restrict include to common helpers
Date: Wed, 30 Apr 2025 23:23:30 -0700
Message-ID: <20250501062344.2526061-20-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 257b1ba5270..085c1656027 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -12,7 +12,6 @@
 #include "cpu.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "exec/helper-proto.h"
 #include "exec/page-protection.h"
 #include "exec/mmap-lock.h"
 #include "qemu/main-loop.h"
@@ -36,6 +35,9 @@
 #include "target/arm/gtimer.h"
 #include "qemu/plugin.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 #define ARM_CPU_FREQ 1000000000 /* FIXME: 1 GHz, should be configurable */
 
 static void switch_mode(CPUARMState *env, int mode);
-- 
2.47.2


