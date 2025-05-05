Return-Path: <kvm+bounces-45507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7458CAAAFFC
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:30:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1C901750D6
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 404043EBDB3;
	Mon,  5 May 2025 23:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M/NYjP/u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AAC2F8BDC
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487246; cv=none; b=P1FASJNimTihNqxcIz71Akgu3yBlfw+09Ov+ApYhwji+JzwZsgIQh+uOgGzKA5jWJ1gBOyWptmPjPyKWr4ejbadiKwlcPl+CMXKBqg7TesEqB+NUIrCW2Ir0NdFXv+djW7ycfgeCJQ3WdUnvAgbShnh5twfV8pJdSul1Fv0vkZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487246; c=relaxed/simple;
	bh=0ND4mB9JS7urQpEVchws9S6EzmrvFhsdvB7VUnUD0HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1eP+qTDLeQtidxVC8mJ544xUbgRtyb6IENl9OPLTzf0Xy73uthJ8zMaTtzoRwRONHhT+cwkpLKYaTM7iwARFeiKUJ/e/vUzjfa6hdJqEKZHJz/F+gdeMSEEOQg+lyRs8sL3tBiJ2hd/iV+xE/kyl3U/5ulOWO6Ni/k6n7w17Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=M/NYjP/u; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-223f4c06e9fso45718145ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487243; x=1747092043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DYtSZEbP1atLGb677pRK4UuiMz1CYlbqC5aWBJkLTc=;
        b=M/NYjP/uXRpZeCx5AIQk9WQ4WR8LVVNSJNb9adYS0RrF1orSTGdaJ18NyCsPHpF84U
         kch2T19zjGTf76HSiBfxtk9b9CZiD1QS4fZjQLVK+iDxDyf/jBegyq+/12sQzp1+o9vJ
         nII/wUHkzlacKgmCdAfyKsqxv6/jfxZWNtkBddvPDnX9QmqxKlCPOBEeLOG51gcphOri
         tgiLEYJXRwgEa1ELjELkhxUbkJgx0SrP2QaxffhXMXUu64GIYmRpukfOkb/BrzJVjsrN
         exhQT2vV9lefIJHBwK5g/E70r3Uy6MUYn9l4m29L8Z5yDp12BWrvCmGhCUo5k/8ZAX1g
         8ovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487243; x=1747092043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4DYtSZEbP1atLGb677pRK4UuiMz1CYlbqC5aWBJkLTc=;
        b=dVQVFI20E8hBl3hfBGEVaNkLDCodjaEcP8awGPD6Pl0ZyJvuNFlEhtI7ZzBGYBXC6L
         24BGApl+T7Xup8XALDwZDsLHLJ75cszjQjpXjjReHxlXWLxb/RVOvTcNM2PhwWWaktWq
         B6LtCVUm3m2z5iwgHBNb5qLRyQVyHBTDsCnlmtOaIGMKfXEZN/w8a+cHzFa/IKyzLf30
         Aa1XfoMkuMKGcalF7/ZezGorT7Zbh6CWk88EA+PH1Zk0B8vPN1r9qxsMylzP6X/gy4DC
         8tuRFPhZgAWLHZqGP0V9X7SKC0FoIPU3J4zL/N8RpKihRZhT9sqI9nRMuzbNTGWiZtCI
         NH1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVDPu5JJ5cx1NlqqYbPdeXmIRhrxjQkprTJVEw42uDLnxOTtcHg2rEGZ0cc448OOqk26y4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywmlg69wm4REmtPN4+IEtgdiLDknUZirAQrIrfx/IsTOSoJ9cLp
	ymSZ+wTp2mXBAygGNtkxShuNKNCs9ef6Xnkv6HkSrplzSgDHKZxv2gT38jwLpcM=
X-Gm-Gg: ASbGnctGO2TfcmqDR7zxSBohywhikqrjGqgQAUQgc1EE6lg/7BKLmlg2PqbIuJ/LI9d
	PuYtKVwl+WJeucGz/ioqI71yxUoJTEHdmqRPVPJUlsii6U0Gt2J9fsYJi0ZblyB8qlCyeSYOGoW
	SyFWjj7t0DtkkMhEL0xytahkPNtrxCdrEsx0sNUQtIssvT6SnLTIJXuWuwegWe62OMTiPAyN7za
	YNDOciFMh+7XJT6zgFbeZSX4NPggxVoFVb8G9ZXp+knG92235LQOtAvwpHPmmu589xD+16/TevF
	8wxhRZTYwhiy2woLAh+rsldeZT/fMuawD+4xexk4
X-Google-Smtp-Source: AGHT+IH5Uw7g4LrrMeNQldUBujYpCP1weLdfAKQARAwCGSAFxHYIUIR+BJ+7kpydaxwme0QVMesEtg==
X-Received: by 2002:a17:902:f64b:b0:221:8568:c00f with SMTP id d9443c01a7336-22e31e0e9c2mr19933785ad.0.1746487242699;
        Mon, 05 May 2025 16:20:42 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:42 -0700 (PDT)
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
Subject: [PATCH v6 25/50] target/arm/helper: compile file twice (user, system)
Date: Mon,  5 May 2025 16:19:50 -0700
Message-ID: <20250505232015.130990-26-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 48a6bf59353..c8c80c3f969 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -2,7 +2,6 @@ arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(files(
   'gdbstub.c',
-  'helper.c',
   'vfp_fpscr.c',
 ))
 arm_ss.add(zlib)
@@ -32,6 +31,7 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
 ))
 arm_user_ss.add(files(
   'debug_helper.c',
+  'helper.c',
 ))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
@@ -39,6 +39,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(files(
   'debug_helper.c',
+  'helper.c',
 ))
 
 subdir('hvf')
-- 
2.47.2


