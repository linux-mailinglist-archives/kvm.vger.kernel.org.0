Return-Path: <kvm+bounces-46229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 606D4AB4247
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:21:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFA2D1B6118C
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D39A12BF3F9;
	Mon, 12 May 2025 18:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bkiqyjx7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8052BFC6F
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073138; cv=none; b=IfCY3R4FIIKVM1nwaJsSQhBVAlgaFbpM8Iw4q9PouQpG7n0YH/UBHVo5JsEHK5ayrP589TUxxMwXNfGpHqd1WvPE1dNQfCQt2wQ7VmuuJUiylZgOBELs9lvBYgNcLCI/hVsXrfQw7j3evwmgPJmd2XUS0nMdtHS2689w+2g7P0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073138; c=relaxed/simple;
	bh=nio9YJkiK2g8f7JN+bhkPA8UAPODA+S829FcakWQE/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miO75YBnygTcCYnuuSUAk4/VvSgqdYNglBqydIZMSvVBVDd6q6VaT2eF3NlT2HfqLZLFi3sXDelMX/U/urGX1rT4+QOHKeO4QSvLPVMesG4J02RN/hYyF/xWo/vyeweNgf4VpOpyH64Z8Oy9jTbf7wK5a59T2PN2cbn3fYC/ojw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bkiqyjx7; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22e16234307so50731545ad.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073137; x=1747677937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rVtP/RnhHG9awohdmhc7BZy6oUycGDI8ImSQa94LuXo=;
        b=bkiqyjx7pxZRXIVu2oZ9XnxSl4y0VOaiqyYxbxidIopBFiSoXPEFnN2VXgNRf+Tmoo
         smFWi07JRsaLu/ORg+tancPr3WvXz8cQVdzatK2M5GrDTuH89dHXECpKMS50DS1XI3f2
         izhazHStVz3FZm2BVKqtb3zQ3SJzeQC5TZ5f7G7acByUB1Xen9+CnigchOWUO8Rg6vqB
         1G2YWqY4KQT6FK1wRmiCjtwiK2DpPM8QeeYoqXnXgLVt9Gj/dT1vQtEj9bRn0QV+cpLL
         a88FHLZfFaau4AZmwtj16P9M6medd1Go6iHDbbS1aSrkjv+XH/3verQjPAsClYfPxciL
         69Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073137; x=1747677937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rVtP/RnhHG9awohdmhc7BZy6oUycGDI8ImSQa94LuXo=;
        b=T4IMiWBAJ9jeYjkz2HS6zLHlq6ovNwOEBbpGaj9o+G6RedZxuFKHdTkfR58D2+o9bo
         raNNZc/rmLdds4iw+Pt15zA0scupnGIHWgURSMG2ECt6nQwa2oGZkCrfDzPcR5D3Q2u6
         c5BgsAIrjETBDUDwZXffyAWI1KTgHmyGhsBKtm4PZtRtQ7zJ0fa4v3QsCrxs6J6TQpQH
         A9b05a6UWxO19/jVNzOq3Wn9lMxyfrUsLLpMVM5IsmHUUPVwS60rGSKY6MA6BJ8ujnE/
         4LIEbcFmFQzFg+NdkQ5Nk3bu3d/Z9qAh4uE6eY8K/TtzP7LilV7TCs5YWXyr2acLFHqE
         JgIw==
X-Forwarded-Encrypted: i=1; AJvYcCWeC9FAhFBlISrGEZznpTwG5WBkdUV6vfhzLs1an0PwLYJh0cYaXLOGYJI9uvg8dKZUP5w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPNNTEc5t2CdlGadXbHu2qtIWQp7Z5x9KbbTPptDbJWRnZNv16
	fYbY3eBILSlO6L3Tkh9gW3/3v4cQQ24nTQ4mc8tR3nE30yiU2iFkJ10h4fP/fGM=
X-Gm-Gg: ASbGncsljhiFkx1uMl6sbitYr2OHxga0EBXMrdpwdA9H+CT7HdDD/6az5mK8tE/HMNh
	UM7zpnd1B/olqD/GJjNzdom4AGQJPUJQ9BW3wHWHqcEVcMdejgP7oCeM8F2PMPu7v53XEoe9rrw
	KZF/VlCDLvDf5AXSpXtMGc7zYsh1hnROXGfgQRS5M/QCywuM4zfBeAqRTOaEXjHHFXH+paUxxRc
	P0PSvgPAVyCxeROrzRo2rJ9F7pLQAY5o+uC5mc+NZID/IpapHwO19sySzMlpN3CIzRI7mkj1xHy
	BG5xcasnPMN3ZyqbU/YvIszox/OCNrayxNvFE36gqu+RUJKZ1ZA=
X-Google-Smtp-Source: AGHT+IHQktjkFkIYbxcsH/03GT/KqC3Zw458X78euWuyq7vNjTjOxPnKiAkDjbUnG4wIaS9Ypg1Ktw==
X-Received: by 2002:a17:903:2f92:b0:22d:c846:3e32 with SMTP id d9443c01a7336-2317cb65e55mr5398205ad.25.1747073136768;
        Mon, 12 May 2025 11:05:36 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:36 -0700 (PDT)
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
Subject: [PATCH v8 28/48] target/arm/cortex-regs: compile file once (system)
Date: Mon, 12 May 2025 11:04:42 -0700
Message-ID: <20250512180502.2395029-29-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 7db573f4a97..6e0327b6f5b 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -16,7 +16,6 @@ arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arm-qmp-cmds.c',
-  'cortex-regs.c',
   'machine.c',
   'ptw.c',
 ))
@@ -38,6 +37,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_common_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
+  'cortex-regs.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2


