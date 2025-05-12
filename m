Return-Path: <kvm+bounces-46216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49EE5AB422E
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FA7B1B60B5C
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8873F2BEC21;
	Mon, 12 May 2025 18:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B32W6ecV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6622BE11F
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073128; cv=none; b=ETIhVN0/E7XIJoxXGfcAS4qe0OvqLuw38NtXJOdFCqhWJnp1u11C37NA7D1r7cunFT6gPzMAYr9VyustrcuHxJrG0HJJDoxCzBeh+/jA2Nv11d8tJLNi7ANgQk5N2bHYmSZ7tsFy8FgwXhpgPqlqBWdfY47lAvSGgktSsSMcj04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073128; c=relaxed/simple;
	bh=E9jacJWcyZhRxtvgQxT+RUKTpQhm1PIlSntRw9cKGQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNn5XbWpgxi3grRqeL01ixNJtSsAIxXHyS7bCteVlKvjd7ASjmiKWZxO5ViE+sEmocuDk10TDByj63gXhJCYbtz63AFzapaVyv96nE6ZKMSHzBiISMvU6biuo6rfLTgQlntKDwy+LZ837FaybwIR2dWVavu1OwOfyEuhFmjpMa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=B32W6ecV; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22e033a3a07so52648215ad.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073126; x=1747677926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kfHS+52V3f05Qs2m5d7Nh2wTK+yUmoJBcA8DI59GOAc=;
        b=B32W6ecV27GtXhkAyOXLD48TgMP6+cKN509K5lKa+Vqx4fUarZWcpZkKbiseTew3sk
         9W/EpqKTDzyC617iEe+RK/kQNcEQ2kvXdiCvQjZ+Gqut5n94Q7cBdAjSDhljPPxzzMKQ
         orS+8qBew3ULYxdJErb7+o691Q9GUKkBXjyMbOCAYDirn8jGqdQ34P9wLrVp/5dkexB4
         PCT4Zcn4rifkNuWmeRb2FzowyaDF0UIla9uIc/tuB2X+6A6nmj2yOZmqdNNARv6dXuK2
         LbCZfKgXgSGSNNIlkphJBnjKCn+gz+fRtXZEGBXSGqtUqMuI0p11xRulQGdUPQD6f4wT
         gGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073126; x=1747677926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kfHS+52V3f05Qs2m5d7Nh2wTK+yUmoJBcA8DI59GOAc=;
        b=JL1U9KbBK038Av/MQj/MXW6Ay52hFDBHWdN4OY6UsLIwmzgGcVT969qaB3th+0ZiBa
         FWyIZqoMc6aNh2xHNC/1b1Bs7YZxIDn5x94EFNMZ2vNw3Wxs1zEDUnCQTljv4RhWCbJn
         DmgeTc5hD30PZpnND/C+69QJ1UwlQDJGRcPNVI1mnz8XOgLd4pWxe63NPFhaxbyP6C9O
         VRcZ3aQ5i7IeszXEdIGLyi9EFGuVCZcOLJ3ig55Zcbt6OaCogBak0KtMe2NmdDt1RsAU
         NEH3/LMvgpbHoBQfZF9UIvHEgLKCrBGE9fjHOjUgM1bB0HX/lef1t6FBJe48C1huAiiM
         TRTQ==
X-Forwarded-Encrypted: i=1; AJvYcCULS4vWc/ephn/v9/FujdiH4v5B1WELLa8zqaNigd7Y5aFm60Ngjb0v+5V5e2m0Xo8TKFQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOt3FSFwpLPcP2kuzYiseCAE1DX+B1k+nywUwQAY0y1b0aAtpY
	n30Nd+3FU5Mx6za0QGZr5OqF7sXD8pkrBJDsKFWvpy01K+51n4zj7hQmdHzWTeU=
X-Gm-Gg: ASbGncsG1Py6dq3wrGOTEmbM/jkI5tvDtONQAbbZeAl6zfFXujdJKg7GAbf9kBIxU4k
	hvQKkux2v3kLoDupt3zq60AXOIZqgSON2W65w5wpA8E8JoC93c2Y5LmJVc2aSdOsJbsWnkDOU9a
	GeF+UlexeAzwcQUU0KIqWJcwMEwkrIkucYdXFq3Tan5LBzs4KGNB0h6oiHrRqgyT3WnZmBWh83S
	X86VPDi7r3Qx9VeZ+gN1CkdMNf0AmmS3csIvq43454Bm0crj0hr51TIxCNBRvtYRZRCk8oOs/xQ
	IdUINPK7Yu5jBz4eITc54P1U8WkMzITw2CArK1Oig4rUZzowcDfqXTUnB3anSA==
X-Google-Smtp-Source: AGHT+IEEH7iAqqDA68fuoaWPuS79K3+C1FsiPNsaDzF/9dqgyPWdEGPHvdAfcxmHtZcyfQ1XFCuGtg==
X-Received: by 2002:a17:902:ccc4:b0:22e:50f2:1451 with SMTP id d9443c01a7336-22fc918fd2bmr202795785ad.37.1747073126314;
        Mon, 12 May 2025 11:05:26 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:25 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 16/48] target/arm/debug_helper: only include common helpers
Date: Mon, 12 May 2025 11:04:30 -0700
Message-ID: <20250512180502.2395029-17-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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
index de7999f6a94..cad0a5db707 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -11,10 +11,12 @@
 #include "internals.h"
 #include "cpu-features.h"
 #include "cpregs.h"
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


