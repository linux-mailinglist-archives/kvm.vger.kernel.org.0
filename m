Return-Path: <kvm+bounces-45520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD653AAADD8
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:44:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECF60162EA9
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 121A5406C32;
	Mon,  5 May 2025 23:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lSpZhz4v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865052FC105
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487455; cv=none; b=e8nMaJ6KFxGxaHgFQOTwNc781siKcXnnO26DUD5EX0a5zAKzdzHZSPTb3jZMEIWnD0pdTI5fL4dtaNr8j40aMoTp6lIcAku5eqVIbzIVgN+K9YkwUYuV27KirW0/If73hNIG1Eu4cBpGklwSEVcEmGC/4wukTSuLPwFDawH+GOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487455; c=relaxed/simple;
	bh=R7KaXfalIYRJfT+v9IQzgzHxQq4kx515QhTMDlYyHiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dE31CKG53FOpgjblBngCSzNII1EOw9Sk3XALi7AkKS5igZlFg44qGyDEXPVNYJF0jhg873oY0ZFPUrU+5hZsidMaHdJ9eDzPDp3pDNkwFzvRpzNoZWhw9mDUf4d6eZsqY5syZWnY63kdOvRtimqtThErytLWfU5vPT8LJnYU9bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lSpZhz4v; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22438c356c8so48848785ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487452; x=1747092252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rsZT/scaGxab+Vo7Y7hWrcYUC7iBy9GgtXflG2/7Eik=;
        b=lSpZhz4vGclNjfVYbGUE3M3K7abXtMOs/+eft8VgGPRnacPuL5VyOM1zDPH72x0U/T
         jyD7WuP5KNgEEFQViGIGlAz1KT3GS6CPQyo/pzeIUvaD1bA/ENYCoJf4AnVz3jEIq3Yl
         kLQiQZRtrw55IzchIxzoGcER3HdCEc1n1mYPxciJY9QAfEQEgFMt7HhuBJIkE8jublx+
         yi6RbuwBj2F8yjBqFNf//191iJ5aG7QLn3tECYs7pXJFHIFsPFTpGgt+ZctA/cJg0I+Q
         rlL/jm0TeUttlcg5dAHDW5cYSZQ5rnLQ882uchV9t1A1bvjfZ4QNe14E3ZLlM9hYnk39
         QVQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487452; x=1747092252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rsZT/scaGxab+Vo7Y7hWrcYUC7iBy9GgtXflG2/7Eik=;
        b=eeOn/cbNKRiWeD9vVcPIS1GfADnvIWI9rJidK3qgPnyPBuJluknz5zPML3gza3VmIJ
         A3GXDl4sRxMxTA9icl4DCejkdnGVFpJd/rnGMsDkkOBFjLLmL8b4jB2vZ+u0NsrbCfub
         mzb9dNrUWRFSmLqpEP7VSBqyAyKk2nESTft7AkutnvO/ou0GfuCnJefMwR0vBK6zhC7E
         PCQOu/WWbR/vjGQxPCVn2rgu/euKHzdXt4PSghWzpZTspgysWyuvsYEOjFtyRx0zMLgi
         mefZQQMJWAAwNmptUySPn16LsZAK0S159NIZvRriWa3n9mmPQpjiLo2srYz16d5ZVe3C
         MWzg==
X-Forwarded-Encrypted: i=1; AJvYcCXKfBswkXk62q/t5flCYzIRhFqLo9iTxqQVKS9wMPXKHqKQL3Y6TWz+NYsg5Yi33DrRvpc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw55FzHlWoT+0aI8FYKkC1AxtMhV4uYrhkcNwqBpnDcAGcw48MM
	B0Xc436sMOEKJdV4yOVuTkUPzLKCNOrpiY5F7MFFkWs44MLMZuNgHsJe0TaL8s3szUrjwlTqHE6
	xXE4=
X-Gm-Gg: ASbGnctWC3IfTrQPvDATErvFf87HfGQfGJL0dih9ol60IICHATW/esXs3NMY0Q7faGR
	wZU07XzxlIYRp2vVqjpzhnIR3QLq30wlziWc7e7X+b+1BAeXeFgIXYaXwRWSU35HVFD1WD1+0dA
	AoIWCCvyH8ehwxEBW6ObS6rtbsOjqw9P3eaU4dJwVQDlD8KAiS3mGEgbM0Euxfix21fTQN3xCj5
	MT2+4od7lgdUeAR0vF1m+igJnrjSSGi1dixABqBLRT6R0cd8pvFrD71qgc432HllZhCZuiynksv
	YbRnqLR7oQvC3OJ8ZfJwMHxd1xrYVvA8WAwF1RLXrZI1vqdLbG4=
X-Google-Smtp-Source: AGHT+IFAhPucFlkZ11OgWLPowthveQnohlxYQE/0ZLy0irLJH4rJEHICQLoX26yFH/+v+7ZBHx2EcQ==
X-Received: by 2002:a17:902:fc43:b0:224:1e7a:43fe with SMTP id d9443c01a7336-22e1ea8de5cmr133671325ad.46.1746487451718;
        Mon, 05 May 2025 16:24:11 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e16348edasm58705265ad.28.2025.05.05.16.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:24:11 -0700 (PDT)
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
Subject: [PATCH v6 44/50] target/arm/tcg/iwmmxt_helper: compile file twice (system, user)
Date: Mon,  5 May 2025 16:20:09 -0700
Message-ID: <20250505232015.130990-45-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/iwmmxt_helper.c | 4 +++-
 target/arm/tcg/meson.build     | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/iwmmxt_helper.c b/target/arm/tcg/iwmmxt_helper.c
index 610b1b2103e..ba054b6b4db 100644
--- a/target/arm/tcg/iwmmxt_helper.c
+++ b/target/arm/tcg/iwmmxt_helper.c
@@ -22,7 +22,9 @@
 #include "qemu/osdep.h"
 
 #include "cpu.h"
-#include "exec/helper-proto.h"
+
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
 
 /* iwMMXt macros extracted from GNU gdb.  */
 
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index cee00b24cda..02dfe768c5d 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -30,7 +30,6 @@ arm_ss.add(files(
   'translate-mve.c',
   'translate-neon.c',
   'translate-vfp.c',
-  'iwmmxt_helper.c',
   'm_helper.c',
   'mve_helper.c',
   'neon_helper.c',
@@ -68,7 +67,9 @@ arm_common_ss.add(files(
 
 arm_common_system_ss.add(files(
   'hflags.c',
+  'iwmmxt_helper.c',
 ))
 arm_user_ss.add(files(
   'hflags.c',
+  'iwmmxt_helper.c',
 ))
-- 
2.47.2


