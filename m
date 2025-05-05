Return-Path: <kvm+bounces-45521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BE8FAAAADB6
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB3917B7C0B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 699CB4075D8;
	Mon,  5 May 2025 23:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tk/DOsSW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB4A379423
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487461; cv=none; b=pMYQ1jcawCgXBYe9uzSqClI9tgvbx2Q8PnQMMB8hFj4p96oMyjWjqf/G9I4Mzkg2/oD0fI0K7XHJtCq7nKPi6ILQa/hK7uiH12vpt7va7RhozHxZoZFLGvHbIVPkfJT6eFeusTCVlJmgf0/GA09wyI+NTJQq5ZavtosHo9j792w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487461; c=relaxed/simple;
	bh=uhyN6OagJHA/8qpwacuXulq1J5vw7t7rKBFxacIElLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUt0VwY4Ps4LEAc5MfMIspGih2oFbkoeXj9QqERCtqS95Hy2eVdZh0KUtBoefP8uScbE9692HhSKzoK3epnugC5GMMonv58rsB5AKwJnJ3XqSbDoKSY8iAYocHMpEZU2pxBHLKV4Ej9k3Gut7NxPNSFdqv1iWNY1XR9rJ8RopiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tk/DOsSW; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-22e16234307so27987225ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487456; x=1747092256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D50FgSNi0pKqcQ8O05hlTOFeOSvMmvlw2mBrg4KVMZU=;
        b=tk/DOsSWuNYuWTDnSMsBwZfysndywkZqaZEG0XxqJSmkzxtTRRDoHHkfvLRAsWA6Mx
         gai9IRqTdHxbY2on2TG52gSCSEP0GdmlVQ6ohAyGnxcPUyInU7HH+mAqZOmiTXrrvbWj
         t/RtXjHzuf0+4Nej4/GUWlazLzLs1/TqIa4tkCrneE3AUo4vhVuyRDFtkfHU4ojqlbLw
         wRfoZ4dMcjeicIcBz2b9KLUDEkDjPhqr9T9e/8XseKGAOfkEmxdYTFL8smR7dcnxE8hz
         sAZxKLMqQG227dpHx2SYAgyQ5Fxcmz0GBZi5GvO/ajHkFFQUXfu2wOKbB8nAmryOhnb6
         W7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487456; x=1747092256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D50FgSNi0pKqcQ8O05hlTOFeOSvMmvlw2mBrg4KVMZU=;
        b=NhxQ+cf1d9Pwdjnv2TcgA3xolfg63oL0dR0AbTmIVwpCfxlcDRN3VpR15iamjUCijF
         jKAGRjMYSOW1AX67pverUxu9rWuE+cDGE8sLElvPZ1kXypH5AgTwBLvbSRDxW37meU7n
         rUdZDoQqFKTLQkz5OiQXzJzEMW8OAlGiBaL+d7lYLXYWwmpXx89HjVlzUiNMcowvX3XP
         x4WL5E2zQc4nYL3h6LID6OjGPwN3HyfKViHnlI1dOqIwM10QkICRLmIzwkIBsssJWHSQ
         NQgaafvez34pJ+HZsL1JtsU1x+2rn1pudbJwHaCEuogrUOI8n1UH7KHCIMhVtCE63v7/
         6Odw==
X-Forwarded-Encrypted: i=1; AJvYcCWDA7K54sAoV/fm4DgIuTNghQ9OlXk3GUWP+HeBiybULdKZnuIY+uMHNCn1GPLTs7Ywtxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIECvomuvHKKNvTRmAvy90yITX85+Nx0ligoeA+I8xoaCr4SSR
	uC2L7+f1JgosrQ+NRqWBaz+jCFxFsonQdNSBFBN2P8srNado7ab41u5yU9QMdSlg0kQv9JcrdYw
	jgvA=
X-Gm-Gg: ASbGnct93xmABZGx7J3onfG8ey/kzQUN6Bg/3sJqgeQ6qRspb2ruJMqsFZUorLr9nfS
	XojFNEdLK9lscVsn+UPn/uVTW4On/hj0c5IbANWCghu0ODJYidpz53z/7de1sV3o6rNLPPFoTfR
	OJOgWHbhpbd2Moa7bSOO89qb+jy+5jEOnqQuW5IUegQGOUNHtWHFy0lj1nOdCV3KyWOYRY8WH33
	bqw7VIx9qPxz7iQW0JEgs0nHYvQ7vgNb2mudIgnWTOC/aRgVzzOt9T/Ua1zrbcWaInnBIwTLBQK
	l0donlk0wqIxTs7nEmX2/zgn3WsgOmP78iq9Zu/s
X-Google-Smtp-Source: AGHT+IEL4UfW/fNN2+1qFoskfy2C2PqX7WLykiEeT5Zb9TMUjzEO1zSNYPd1AXKmg/5TTMpRlWPNzg==
X-Received: by 2002:a17:902:e5ca:b0:21f:53a5:19e0 with SMTP id d9443c01a7336-22e327f74c6mr16808835ad.12.1746487456046;
        Mon, 05 May 2025 16:24:16 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e16348edasm58705265ad.28.2025.05.05.16.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:24:15 -0700 (PDT)
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
Subject: [PATCH v6 49/50] target/arm/tcg/arith_helper: compile file once
Date: Mon,  5 May 2025 16:20:14 -0700
Message-ID: <20250505232015.130990-50-pierrick.bouvier@linaro.org>
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
 target/arm/tcg/arith_helper.c | 5 +++--
 target/arm/tcg/meson.build    | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/target/arm/tcg/arith_helper.c b/target/arm/tcg/arith_helper.c
index 9a555c7966c..670139819df 100644
--- a/target/arm/tcg/arith_helper.c
+++ b/target/arm/tcg/arith_helper.c
@@ -6,11 +6,12 @@
  * SPDX-License-Identifier: GPL-2.0-or-later
  */
 #include "qemu/osdep.h"
-#include "cpu.h"
-#include "exec/helper-proto.h"
 #include "qemu/crc32c.h"
 #include <zlib.h> /* for crc32 */
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 /*
  * Note that signed overflow is undefined in C.  The following routines are
  * careful to use unsigned types where modulo arithmetic is required.
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 5d326585401..7502c5cded6 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -34,7 +34,6 @@ arm_ss.add(files(
   'mve_helper.c',
   'op_helper.c',
   'vec_helper.c',
-  'arith_helper.c',
   'vfp_helper.c',
 ))
 
@@ -59,6 +58,7 @@ arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
 arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
 
 arm_common_ss.add(files(
+  'arith_helper.c',
   'crypto_helper.c',
 ))
 
-- 
2.47.2


