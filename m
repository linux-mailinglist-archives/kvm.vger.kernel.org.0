Return-Path: <kvm+bounces-46244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27B97AB42C4
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC07D17AB0A
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D3F5298CDF;
	Mon, 12 May 2025 18:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T/59CJ/K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB95E299927
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073336; cv=none; b=ksKI9kmJYPXJse80qtlPVlhZwZQUyKyrJkobxdjug8OB1LH9kGZrpmINPb1zS7XoHPEXhspHVakv1IZ4VJGqmIqFaXrcUl6TZFm/xSoxU5wDmudzIGIkpMiOJWj9f9lyBYOrmYvDcXznqdACbYDBvYqTA2j0HtNIbUN1NjG7Pv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073336; c=relaxed/simple;
	bh=R7KaXfalIYRJfT+v9IQzgzHxQq4kx515QhTMDlYyHiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCcDILZi7zeS3jEfthguuCv90+hFDt0IAugvjFwuFzwaLywknE3eNyFulKFNWfe2AwlsyY8d4MRKhlt/QBP97iCs1WPF8y0trBrS9NSSpWTF10PVIX5mawDpkcG8CNpCIULDpnkUJv1GypBHmfERputKAjupyEtP09ddXdZodKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=T/59CJ/K; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-74068f95d9fso4569129b3a.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073334; x=1747678134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rsZT/scaGxab+Vo7Y7hWrcYUC7iBy9GgtXflG2/7Eik=;
        b=T/59CJ/K82tLUBlak8mCYJOSN18+RobkFJx1lZ73fAInDvgy3CqiRCMj0rFnwIkUSk
         KRAbSSiSm9kkP5OL0WxM8b8M8y1fD10zL4pXXEct6HPm8WgAn7s4Dvf0EW5Hvm8jcJto
         3eZyVDm9Vmwa0WpHZAqF4JE4u8dLlOYpp3QS2AkFjytHQU6n2a/3qZU1yfJgNU6PWXgm
         wR5a577ihMSI5yDhyRB2mMNvaWIEjAnqgRsxi5ye9Kmly7xbTc3cWta+iK3FfyUCY/5j
         PmxtszgNJrgi/uAfBcumB8zlvQE6tDobXyJRCfVzjWhT3rnd7lTgCnrMBIY1wefRrX6C
         7hsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073334; x=1747678134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rsZT/scaGxab+Vo7Y7hWrcYUC7iBy9GgtXflG2/7Eik=;
        b=YWh7oYAPWNuzGpygMg8ScXMyJf+cwaA05cWR3htMa7MW17sMWzxnOQbVoM21B8EmMK
         7dr471BDxyya0nHxSWs3DuhUPdtxtxyKGYbXgG8cv8PgxOFlBxl5cXKU/FvFmq2P/CoY
         7sW9P9mPilISvj+4beT1ZAgeyPe0oyOjDKkueaIv1pd5XlADQsN0wi7+SVqdLV8hVJ4r
         Lih78gn+WluwqRKtWNVHVYDg8p5u40hcCK8yBXgDmIW83f5CFV1XszWxCDl6TT6G2nTY
         TGJqW6JCXvkeWAC5A6KJbnX6IRJw61ldBaL7rxKPZiWNnCgroJGvsbWmL/1PL5hYTF9v
         oqLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUF4B7TUXA7cqhph/bNzM3OdLDwzAcoEDGRELa3usTkngFWwCr6GjYIFvHAwCRrvU4G/2A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrCVk5bOz2n90tvOWM4iGYz1FTMOYRJvMKp/Wr+O8is9hq0hyH
	CO5M5rBrEHk1l++UV++9d6XUePPNfXdwbu0/khMyNGatS+B0AxZtl9lIPC1qyHM=
X-Gm-Gg: ASbGncuBx1iULtSIgNzuzcjLaQe4PRMZWQxN9wv5OjNywL6T+bvfL1jPfZScjqVNGEZ
	NeehTkL/qUnncSdCUr/TwSKZCcxAyoUHkF3SdK1RwKwF+JML3iO4VKJ77KJ9bPpZDM81C6lK+9P
	qUPv8la1uHRsDQ9tuTuKfLC96HVIb8rflj8Zs+CT9daT9qugWRiikBhYGcXqUHw3HvqiR/HmvYy
	36HBxrAhskuUvuBpKYu3DPsCOhE6eMAoHYY2FCNQhgo5/Ctr0Bxom2KzCK3NBwQck4FnGt7L7Fi
	b3Dbr17/3wwY71ZVWqqn0FZPMdRE8+rmhB2NT1MssGc6S+bcTtY=
X-Google-Smtp-Source: AGHT+IH6YdqrqSaks8wWBL7UflSDaRJSFa1wzyXZCbqTKawKIDKnpbS3w5JOi0gp4TZnERIb/sowVQ==
X-Received: by 2002:a05:6a20:3950:b0:1f5:7280:1cf2 with SMTP id adf61e73a8af0-215abb030femr18972486637.12.1747073334073;
        Mon, 12 May 2025 11:08:54 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237705499sm6438580b3a.33.2025.05.12.11.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:08:53 -0700 (PDT)
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
Subject: [PATCH v8 42/48] target/arm/tcg/iwmmxt_helper: compile file twice (system, user)
Date: Mon, 12 May 2025 11:04:56 -0700
Message-ID: <20250512180502.2395029-43-pierrick.bouvier@linaro.org>
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


