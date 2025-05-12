Return-Path: <kvm+bounces-46250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9F79AB42FF
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14344866B9D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 870C6299955;
	Mon, 12 May 2025 18:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lWS8aQLH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CC8299940
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073341; cv=none; b=RJDw0sVoEBb+FtDwhAVVf6cwz7e8tEM0dnlFy9oRAxWyk0YA6/YizZLA5GgWD3dI+MMdRntmcmuDsNibEHo0KnTetDCxP8v9Pxjj66ZgB/UE9NOdM+zvt+x+goAA58iAPZQ2w//w4le1nhqE7aQmLXIVkY5gIIp4C4zpUTguNkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073341; c=relaxed/simple;
	bh=Rn2lI2/pl5nRyUK/hjfWkym7bAiVbpNG1rk6SoHIe0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CL4I4znPwSqKGlw0fmUi9pL60JFuVOmPuiviau6gcEGMY5hMsUzmHUaInsRX7snpK/zqeWW0mjDq61HqL6IYa+SI5jC12UVo8wYswNEwKzJTEt6aXLN0OUPIZL8dLn+ZPCrdfuMCWD/iXgu0Euh7MlNJaULQ28mWzqiOs2XiREQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lWS8aQLH; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7396f13b750so5257749b3a.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073339; x=1747678139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h9+0A2smB/xfpAp/1FKWxfsvzCeqir2otJn6Vwgzfpo=;
        b=lWS8aQLHDSQhDzbqHufYvtWyzJIYVuecTIcY+98QHH4oJcWk2DXfZf/Ld9pxhUsE7o
         Wusfs/x0XMWeATQHYvGu/u6U9qVg9kuT5cjWb4viPGjn9SZ7FdskXZUG4to4Pc9vXodJ
         gmDW6iY4qRgr7+tYvPMEB2VYhBoLeeXkbqHByLtQ0MomJ0QexT1GQ2CPBmfYv4L9m9qM
         eBENuP0v9SZdBWiT4hNxkAmIFoAaTinyEmGIzYxViC2jDM9PLk9wvnF+UNkA5oTt5367
         xwtXbBgy6IuU4sEbCfWHsHOhXgYgOe6iRNiuQU0z1n9xTm02fJrXHGp6bhhAOSkqbjYm
         NunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073339; x=1747678139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h9+0A2smB/xfpAp/1FKWxfsvzCeqir2otJn6Vwgzfpo=;
        b=TA+UsNkzrbahvg+nkeb37LD2frUDFlh5vrrXZsTLA1Y/bNqodeK5Zw7JKuFvN9qeGF
         G1XHoq9i+OY1kUpsBh1PpjObWf7lsgzp7TQusB1Wn5vH2Qeymd7EeXCt1BGMW0aVIHXN
         CToQJggZ330X0ODb5QroA7TfDut1A8+/ymyOUqSIotUD25totHdYUCMuoxV0Ub3mAoOM
         lmxCbu22cOFCFUnc2dmwk3XDqoDj0KimkoWQX1zruHfgErOePBi1JHNUuGEKIvpU4Nrz
         oOOSLtuNUYymSTFowVkcFtfjoNoIqgjEr1/Eh6dxegMANtBCs7A2fdgD4yrezWg4nimE
         fwqg==
X-Forwarded-Encrypted: i=1; AJvYcCViFq7rz+x6r3A5K0RyUf9zn48y+MHSRgcrMYz9DZDs+xMviMIyhl/8OAUqc/lPOTwSo/0=@vger.kernel.org
X-Gm-Message-State: AOJu0YySAI/E0LDas7Mv0/fZYSbdd7Yvf4x0qiGdW8jJIgPJWMnnKT5l
	GX3qZ1x8MHtOz1dpNSFQ88xehJDG3juzoZcOldo6W14muYcweE81ZoWdrUxYrt0=
X-Gm-Gg: ASbGnctGWOZ8hEI1UdDTF74FHahkyZPmXKPBa+LQSv4xsYSTTaUYVd2j7c+CanDgaNH
	OpMnlnCwZZ7RpEXUj+C//59b4AXUUlKq7IcY66CM+CKzZIchc/e3aF84kDDYY9NANIbcwvF9AM5
	PbXL2OBXJcN5UdLz432YMAa/WM3UsoC2G0skAf7zWlNHhUPtsb4apdsychHnDk3UxDQk6cYvde4
	byGTS2dMtTItBnumJeBwR676DnZRmA2NF+DAQPUudBFnQUM9rlOuEOR9YVY0sHgJweOpbmQ9O4o
	s5NZeX+5vR5BbCy6bMSHA3DUNnChpBk5i4ftVrHCth61ALwEf0w=
X-Google-Smtp-Source: AGHT+IFMxEYVPluGpO+aZ38G/jrGs/8RtCSp1027p4RYYJ/IZhfE7V8sbgUcy7m6CYbsJgYkfmCkQw==
X-Received: by 2002:a05:6a00:997:b0:73e:b65:bc47 with SMTP id d2e1a72fcca58-7423bfe4cf7mr18237636b3a.17.1747073339256;
        Mon, 12 May 2025 11:08:59 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237705499sm6438580b3a.33.2025.05.12.11.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:08:58 -0700 (PDT)
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
Subject: [PATCH v8 48/48] target/arm/tcg/vfp_helper: compile file twice (system, user)
Date: Mon, 12 May 2025 11:05:02 -0700
Message-ID: <20250512180502.2395029-49-pierrick.bouvier@linaro.org>
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
 target/arm/tcg/vfp_helper.c | 4 +++-
 target/arm/tcg/meson.build  | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/vfp_helper.c b/target/arm/tcg/vfp_helper.c
index b32e2f4e27c..b1324c5c0a6 100644
--- a/target/arm/tcg/vfp_helper.c
+++ b/target/arm/tcg/vfp_helper.c
@@ -19,12 +19,14 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/helper-proto.h"
 #include "internals.h"
 #include "cpu-features.h"
 #include "fpu/softfloat.h"
 #include "qemu/log.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 /*
  * Set the float_status behaviour to match the Arm defaults:
  *  * tininess-before-rounding
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 7502c5cded6..2d1502ba882 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -34,7 +34,6 @@ arm_ss.add(files(
   'mve_helper.c',
   'op_helper.c',
   'vec_helper.c',
-  'vfp_helper.c',
 ))
 
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
@@ -68,10 +67,12 @@ arm_common_system_ss.add(files(
   'neon_helper.c',
   'tlb_helper.c',
   'tlb-insns.c',
+  'vfp_helper.c',
 ))
 arm_user_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
   'tlb_helper.c',
+  'vfp_helper.c',
 ))
-- 
2.47.2


