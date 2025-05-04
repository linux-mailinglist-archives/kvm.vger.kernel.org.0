Return-Path: <kvm+bounces-45312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67A9FAA8401
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:31:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5530179FC2
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63C919D093;
	Sun,  4 May 2025 05:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ezk/QVhx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4B41714B2
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336580; cv=none; b=j96+0M3A5Z6ipKs9qUrkHGHp/wyCRx1sHcRwj/OGRlexq3ftJnJBwFGmbiGWmN6R+wDUyakpHm+sXIMcwEFrsDbMWFrR/K/ViNN39ByQnYOI9h/CQLbP1J7StdilCmjBRii+WMAAVtnumADRpKh7Voo13PC3sQywBJogWilpaOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336580; c=relaxed/simple;
	bh=nW7ac0NUfdnDJCcYnr3MXIbzudND0FOdxl26cRuKPK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFpt8q+hLRKNwspTkJCtbu8EVo7QKSEvlhccHt9YSNmNgxLmdGoHqu0hC3iWAFW9hlwxmiali8rxmJ3n89FjFaVTLhIEJ/lNpYit8rrLvy/yULRFA/J/Vk0dVbmxxEjPBjgDZRKvyM0jH1egvaXlbnzNdKBJ9Gm+hM165CyL1D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ezk/QVhx; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-736a72220edso3839866b3a.3
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336578; x=1746941378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/RowU+G9lDkd5OLEKmfnzuDeOXrVzkwWk098+SYGJQ=;
        b=ezk/QVhxVTMZDvX9z7UpfcfN6+22meKxZf6ARdOLDmDgFNN8GAsJPzmiWoc1IXBaeI
         uaTIFQzNunuPsTajgZUptUV8Xjv+Mqlaiqg+9gXAR1+X2Xxgt1t7OirNBdxPbQaViAty
         uavHbuqZ+ZyqACxjAejaGcIRyy6DmoML4rhERHPSaYOGKFDL5tnBIKQP2ZR4tPHkrHYJ
         EcE0T6ax7hjHSaDxWKl5l1F2Pg3DMKnfMt3vvds5A5v103WLnHSq2IEXxOdLU0JXu3kT
         ZQ2LZkyoSTYav4IZ4U6mEEQ3oKdTwBKejMOt+Ma+s0IIWE2NTytXtLUZ/40OzFTIe9Yg
         5dfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336578; x=1746941378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u/RowU+G9lDkd5OLEKmfnzuDeOXrVzkwWk098+SYGJQ=;
        b=jIL6NNaA0cCaUucXmEtcjmo5eSIvM14zM31HzAAm3xpanHC8fcIBhoiZI72/avK46p
         1iyOLFaZe0m8xjOZs66wNDaXL07pQxXUD7MjgVjEH6jGLfQqd75KP6vagItiKPJ48oEX
         N/J8mqEwOt/GY+mlTFYcmMkSMcA/rl7oozxRXybZOgMUKPTwYRsnjFupjE+ujP61jRdk
         3IkdzAGf0vzorh/EaCKYDeuRahoIaNFEs8r00wr4Y1Es/wXlawnLNm37di37ZuYDlmkx
         +ene3hid47R3JULcfBgltzx2OAqGX5s2bkmVfsKPOZEbllQd5SBI0RSqFreOar9+avF9
         e82A==
X-Forwarded-Encrypted: i=1; AJvYcCUL/K6ITXECm8iT+5VkqdVyIG4IGEjMR44GvuAdjfLS/7r1jH70jL3m+XgX9T2sr1CNZSA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVPLZnuGziCAGb50mANV5yY+K9e2VYHnxbOxNuBSuVGlKAlLbX
	ttujCtC72NxnoKr4M+px7VsNosU/VSNlq6BvDgtkYzKwPT8QaRwPRx0G7Qk8PvE=
X-Gm-Gg: ASbGncsOhJv9Sa4E5u35iYRn5VFvaRxOR2gA3FYWhNn/vyB6GVVRnWD75eKFxWC5oVj
	aWQmT+1GUzXmQxuZIiDPxPhaZkwGaaOgMTOAPpXyAMidiiNFxQ3RknIrJuCenENZCzqCVQnL93k
	eeh/R3ostArlhfA5ZE1poUysveFJLVz6FSUDkDVaBH941kyvpPgzJoDx/0y16thXN7wAuDS6kve
	iFZx/v/4GHnxQYWoIrpjT5PXkuPzRl7P7FzAn8r4w/DZclEVx3QXgXxslVbm9pp5e+uf9rQ+h3+
	w4GttK00wq3gLIBjo02HaSzSDKVKqhBuyIOX+2L9
X-Google-Smtp-Source: AGHT+IFaP6D5Ew8hDYaflp+HVUummZVr2ncTgzSc1dejl9uu0i0B5hfKlcfV+xs9jmY0up0zG7JkNA==
X-Received: by 2002:a05:6a00:450a:b0:73c:3116:cf10 with SMTP id d2e1a72fcca58-74067443390mr6685540b3a.23.1746336577838;
        Sat, 03 May 2025 22:29:37 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:37 -0700 (PDT)
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
Subject: [PATCH v4 20/40] target/arm/debug_helper: compile file twice (user, system)
Date: Sat,  3 May 2025 22:28:54 -0700
Message-ID: <20250504052914.3525365-21-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index de214fe5d56..48a6bf59353 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -1,7 +1,6 @@
 arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(files(
-  'debug_helper.c',
   'gdbstub.c',
   'helper.c',
   'vfp_fpscr.c',
@@ -29,11 +28,18 @@ arm_system_ss.add(files(
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
 arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
-  'cpu32-stubs.c'))
+  'cpu32-stubs.c',
+))
+arm_user_ss.add(files(
+  'debug_helper.c',
+))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
+arm_common_system_ss.add(files(
+  'debug_helper.c',
+))
 
 subdir('hvf')
 
-- 
2.47.2


