Return-Path: <kvm+bounces-46246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FED3AB42C6
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D695C1B62070
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E312C2AA0;
	Mon, 12 May 2025 18:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MieiNP2p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6742C1E37
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073338; cv=none; b=d2SLYQGeD1FAyWNCJYtfu2Mi2u0p/UbM36WQiJ7EWI4CjG3PbgNxh6Lla3SX+lWyTNoTp5qKwJv1pBhL+HSAEz3Ux3F085iUM+HcJYm+2IBawQZp7tvRohg+1iDCmQ/xYjb0hGB5RItqMHsmMBHwSlNNoCzbWOgQHz9p2hQzqG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073338; c=relaxed/simple;
	bh=klHAVfNryV0k23cWvtZlg3qSOnFFqbA0lqGW+gJPy48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsY0O0Sy53sie7BAPVnqo4G6Y1o8EzUzVe/KwkY3cDX9v8CpMSkJeCcwj31I6zUo4D4yYfflO4RPv0F6CE03L5PB90Y7+qY/OyYX8m8tYFZbtm+Hm0M6nKmxYjpvhjflHSyz9cHw6xDsQZ99PTMASKZeUO4PkZOIa5zSwexQBYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MieiNP2p; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7424c24f88bso3115046b3a.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073336; x=1747678136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XN9bpcu/hK+eTVDHriw8+8GBLuzv6l51ao11Y0jPFbk=;
        b=MieiNP2pTsHom2lbT4xji14yVqX0+YQk1Qg48z9dDm6WRR8mSxW3wJ9wR1RGT7lpWz
         xxZPZ0NpxJNcjdKoQVz7E9fZgp7prWERpnKCEDHAtrJBmm66xkLQ6TZZJKveAwDyavFX
         ThHTyqE60vLuE7y+sJjcov3T57dLmmDYudOHo13xydM8PAMFtLQXOZuvcoiQOLEWQH7y
         +f5z3rhLSF2hxUCyesk5wvK0VgRiZ8NO79SdHEiVEO2nFEUfmIKLfKZtfxv2/HVdvOfl
         fevNmUvEOJW5bmQIpldqwcuB189s50Uh7Mxzprakwn2cs7n1WbOnt20UpzfVVZtPlMB0
         j3xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073336; x=1747678136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XN9bpcu/hK+eTVDHriw8+8GBLuzv6l51ao11Y0jPFbk=;
        b=h8Pcp1TVJ3CVbEs9ntOz/YvToqAJVC2oBEC1iJADmVZ5rpqf/pTVqpVi2FZvpw6Kup
         sKtq+nRo9Bc8iQWOVdRKB/7RnNLk0JnG/gay6+RSkIO4jWBAE5GerDHutLnH61mI+Es4
         +z719TiodB3XynW7p7DunB7KpiMvke4lElQZBGt8DkfG2M7HrYql5WyXbEJsOtmrllEz
         85l1gK64gqJtX8knRQiwU4pRJ4T+jCzmycotxlKnfDbJIugQaIWgoRdkKr/oetrrplYo
         99todYRi3zw649tiY/KxMHUUFY2V2oiSFQ4c2OmiIDZWMvNoHnmaAdH81SgDEl2fpn66
         mIcA==
X-Forwarded-Encrypted: i=1; AJvYcCUxGT0PYK5Ly6bo/XwXTvLATwoF1uJ/tk7SzMzImsnm0SiXASMlPxE3j4umM38+TA+Zb3M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiK1+YptLcTkc2dK5RvhjeLrsj3IheCkikn5hxJJSvQrb7TpSl
	OshsrARO4IUI/SvTA7pXIh3diqwwb6jnzM1ZD/MnJH+ZlXs2QFyCcucLpjc0x54=
X-Gm-Gg: ASbGnctHA+xi0BBH0dSWXdQuTJ+tPENh84y3ZZXk1PwpSSvf3/9EIMmZ2nU1IuDasIb
	iVccrLyErvV+6OQVbCCG52pqxnyRvPqV9sm0W34XYSYyeMfHTJSoalupsgHQJeMNUQhXMBAPuDb
	WwrWe3N7/vAVQjkqUxVZXQW++N/iF6XJ7hEz7V/UUlSXnW8PwAO91C+YzvGxAwEgdlfI61/ZtTS
	MV/YOu5Ki5C/+yJWIFxPDUDnYLgMWzBsGc2Q1bEktRlvOCGEODU/850RqcSzYPB+LDPVX+E8whS
	AXEZb+SdWpPyqOk4240eGsPUWfgOJy8uFlKc1Nw1dlR7h2+b6ec=
X-Google-Smtp-Source: AGHT+IG+BeGr4IuBP8TMSOSX77hezFOtRuiKEwjWd9/2pXAZfzUtVZDsMPzzrQ073yba+JGvzQT+/w==
X-Received: by 2002:a05:6a00:9286:b0:736:3d7c:236c with SMTP id d2e1a72fcca58-7423be7d6d0mr18600353b3a.14.1747073335760;
        Mon, 12 May 2025 11:08:55 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237705499sm6438580b3a.33.2025.05.12.11.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:08:55 -0700 (PDT)
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
Subject: [PATCH v8 44/48] target/arm/tcg/tlb_helper: compile file twice (system, user)
Date: Mon, 12 May 2025 11:04:58 -0700
Message-ID: <20250512180502.2395029-45-pierrick.bouvier@linaro.org>
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
 target/arm/tcg/tlb_helper.c | 3 ++-
 target/arm/tcg/meson.build  | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/tlb_helper.c b/target/arm/tcg/tlb_helper.c
index d9e6c827d43..23c72a99f5c 100644
--- a/target/arm/tcg/tlb_helper.c
+++ b/target/arm/tcg/tlb_helper.c
@@ -9,8 +9,9 @@
 #include "cpu.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "exec/helper-proto.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
 
 /*
  * Returns true if the stage 1 translation regime is using LPAE format page
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index af786196d2f..49c8f4390a1 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -33,7 +33,6 @@ arm_ss.add(files(
   'm_helper.c',
   'mve_helper.c',
   'op_helper.c',
-  'tlb_helper.c',
   'vec_helper.c',
   'tlb-insns.c',
   'arith_helper.c',
@@ -68,9 +67,11 @@ arm_common_system_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
+  'tlb_helper.c',
 ))
 arm_user_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
+  'tlb_helper.c',
 ))
-- 
2.47.2


