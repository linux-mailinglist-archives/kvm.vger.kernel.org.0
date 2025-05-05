Return-Path: <kvm+bounces-45487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85954AAAD70
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1BC53AE85C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E4F3304F6C;
	Mon,  5 May 2025 23:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P5rQyBxa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEA7397A64
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487239; cv=none; b=cNtsn4ag++q3OVShfY//kzG6PjIyHKsWP7ZFVJd3HSGAtM0E0REeRG9CqtXoZBqSbYCYyl+i401ym5bL87cs/og8Vx36Xi0qvTK5NS0Efzd1hEAfeU6BBrYEFkbmH41Qb4hB/ucWgIRybyzyxFpjH6DWL9d3D5iUfjNvYx5I8dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487239; c=relaxed/simple;
	bh=ml2TA0vrP9neaHTahuIEL5NgcIVEpZ1CGdXaGOWH+oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiaFmNnEMjvHfpCpYPOl26aRgnH3fqZenFj+sHbyAU8K2Wum3CAUGGuQEX+ktwBr/Horok9+86ZQ+x6rdPUxwX56dAI3+jqF3pLoiY+QXIB3X5BAGifcebEWOa6sNY6rH2o01TdwjXHNjcELCxcSQzvqjrCyChc0U0yEt4u+BPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=P5rQyBxa; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22e15aea506so42635705ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487237; x=1747092037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92Ra51BscJ7plqFLljDp4Imt4ck5QTPqHgH4Y/GteZ4=;
        b=P5rQyBxaHNchdPpLqUuXEcHaBJeKrjypAvXoYJETVElqFVkRniI+kESCeCmGRhnrBP
         Aj5nTPTkumMZ9bQUNkOBFd+XIyRB33Jw+suooj3SCuOj/FaRLTdxIeY7uyYNxzBQu+ma
         QD5/ygDllTJf7+D+ooQDI/LEIGcyDAbLvP6svO23lpU7sHeVC/y7bojBdfIFNg8CQMzr
         E3Wiwj5yQGNMFC9z6WR8eDuMRZexBoXmWth0mjviZhZjlFUY3+IWFuDXBAD9UPmdOHhS
         DBu3GP3SgsOD/+A+Sdrk4X6nHGJ0aVESzmEOKT/TCiyVy2096fBgkfdI36NgtSUqUGHa
         ZjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487237; x=1747092037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=92Ra51BscJ7plqFLljDp4Imt4ck5QTPqHgH4Y/GteZ4=;
        b=RoTfKZ9rPcJGu9vhXmiZm88HeOknd4Zc4VMTkjzcQmmznAgQ05RrvRPww9GRNT7VSW
         31FswSsMTAru6SOLpkxhDM9l5SKqp9UB9VlNFmeKyQSNXX4yPXoaec2HHbCPJBvkrYXI
         NNP/p+OOWdLQ/jQeVCUKHtKvltTha+sSbg1NqGHExlMpuCwoyeT2pq0Ey+WmIvAPr3X0
         bTCJ9krjDdeXhWUAzIlZj8YqohJjciO7yEpWnuBuPWjW4lcfbXDYRpOhAgEm0NFvXE2u
         Io5+UEBFBjAGbuHwQDqLmbdAtGriePQ5+MBaGYriZ2MujTRzLBcwyLiK4zWco55GP97w
         09zg==
X-Forwarded-Encrypted: i=1; AJvYcCXbkI4wq019iXDoOVAuuA+AYSeJCnYKL02uqkxGhf7DpaNtOhNt6XxuJskwsWPxwHXGSVo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsCttMtxjjat3N1EH+fyMOW6JWD2tt1C+jAs045ifSYq8v+orU
	ysshqTTnZjJpBLq7T1QNX6C4e/+yf1Qzw4ySTKMD6Hgm5eV01+D4PKj8rXNPPJE=
X-Gm-Gg: ASbGncvVd/Rz8VHhuM1dHuYkxCtwS76ygPvpbI6YS5rxZLBBnPWnufMZoE3SRBZRkFT
	sxXhLdJTtvoSRtZJLIgRIoXla6K1RJTDVeUZRft3gWoqlH6jey41cyvCo/QsXiO8KoG+5O7e+EI
	AibnY7fbFf5TuNo9hIb3BQuzR/b4SqfsjuF08hEU+ijhGbXdKHAzsYBY9ILgNTd/d/ij0EbLxo1
	k/ta31QMZKBs5XrplCgmmkOJWwdzYVy7KZBRLGHkBONVKlBirYmlqQrnS8YnfWsDQvb0O0qohZi
	Oyo1RtWNhCb12Udn3a0hsTOTsascFK4wQnDKcXJs
X-Google-Smtp-Source: AGHT+IFM1gtQ3Hr3DrzoVupUyM2ejLDN/ZtwY19Upapy3xbv6kMXCNmsmDwbwB0aXMOyoEqCYaGquQ==
X-Received: by 2002:a17:902:d2c1:b0:224:179a:3b8f with SMTP id d9443c01a7336-22e1ea583d3mr125469395ad.23.1746487236721;
        Mon, 05 May 2025 16:20:36 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:36 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 18/50] target/arm/debug_helper: only include common helpers
Date: Mon,  5 May 2025 16:19:43 -0700
Message-ID: <20250505232015.130990-19-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid pulling helper.h which contains TARGET_AARCH64.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/debug_helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
index 473ee2af38e..357bc2141ae 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -12,10 +12,12 @@
 #include "cpu-features.h"
 #include "cpregs.h"
 #include "exec/exec-all.h"
-#include "exec/helper-proto.h"
 #include "exec/watchpoint.h"
 #include "system/tcg.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 #ifdef CONFIG_TCG
 /* Return the Exception Level targeted by debug exceptions. */
 static int arm_debug_target_el(CPUARMState *env)
-- 
2.47.2


