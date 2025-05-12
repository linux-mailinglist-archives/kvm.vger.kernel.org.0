Return-Path: <kvm+bounces-46239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15459AB4260
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:22:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 982B6165437
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ABF82C1E00;
	Mon, 12 May 2025 18:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kF2NeGkz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450AD2C0875
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073147; cv=none; b=fp1TR5Bsc3bgpSmCGpG5p/aRmaQ7oQGfpN3ToBBYdM6/1pQuWr61nnwn4X/f1jECaLt+hBp3yfP+g17v1hF4viOgmPTNgKRA6HLFs59J3CGxfMowKKJO2hN0nOX7Ko2DIF20COZbf8VaEFqKgq3PO9WW+aX4BuW2kb39JoMoFbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073147; c=relaxed/simple;
	bh=/zYUGtiopuAnKe6Qv0yETkvli2mk8237qAU3JIOPtdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE7zXT6Kw9SJZYKEI1mxlgBWzmJzTwsJW7ftTfo2X0r1whgOy5Rw9/Q/bngt30NtFkdjtaTGmBh6jEfxWMNSWduEiIkx7iMvkjtOjyzKZ3Nt0s6G71C7PV+ZuWL2pydKwLRZMvOc4sio9z7CmmWUJzQVOb7Y6skBGmd3jIdtiKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kF2NeGkz; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2302d90c7f7so16349505ad.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073145; x=1747677945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6rvyCptpZZum3a3XLfgy4KbKHlT47oeB0wfjegrLwc=;
        b=kF2NeGkzS0MFkmal3E7p6OnDkFGxXFFtFX7w+A1XRxxpHjY4BayQxRidiWjuaeHi8T
         2USBqeY2B/4DRJ8ScbNDtPDiSR4evSdVRuKHeEhMcGD7tAuK08MeHbUrXPY2OLYXEm4A
         dygM3uwvkuwRmKjkGclUuPDUzP7g89/vcDbTHNQznMsABGsPdvKYRWwhas6mb3jCn8/L
         TFMUizOmFgQGOJNkwmVOmQinRF3/JrJ5RSMdu7D3UJv7RmegE0bHUgs3+cj7FejMp/6f
         OAU+BWNJitA3krUyQsBgS0mOJmi0IflcNUZoIrFPh1fylWsvwXHsfcpuVpseU1KejQ6Q
         R0Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073145; x=1747677945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F6rvyCptpZZum3a3XLfgy4KbKHlT47oeB0wfjegrLwc=;
        b=RPwmSUAVqXMy/jmdvaLpcmD3nqtUBvAPlVt+/70dSW2EtRG5uLNJ47+fqjmZuNNpGm
         ko4ww4al30PaSFR+UXmBgFwpNlndvtq94s/RC6qkd+8CSKasXwYF1A6+EzL6xuzHPzGj
         RU5X4RUb5aI2hGnUt9ofB/6f413LboNrEuVbRNQ48/D9mmVmi5J7YJdyzkwPec5uvLSx
         RnDJ0fwf4GCHf6XM8z94bIikabdIBcMTEjSBkPFs4OpE0m6hl3QCn150fcEZQRQJG3x3
         /3zJdth6Lw04T42CclkAbBjpuQk8N95Try0mARNxtquITBi+Yxdiq0kSoiKTBzNee5Ga
         FHOA==
X-Forwarded-Encrypted: i=1; AJvYcCUPjueI65qvArDaCOPBhKPlnYv8WKpKFW52VWoIkjrz/6SFB/fTXdt6Y/qHpHlsQVKkX2g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh3C7cXGxUzHM3xv15w5vpnLcVW7FG4hFDAUOurtyGv/Hpj+q5
	oPG/HwNiXtbfC2OVXB6TgzUcUFHNHJEelc5xP6YUEJ5aQKYPeAb4ibMSYT2wVAY=
X-Gm-Gg: ASbGnctD+OquwEzU1vzLDizy8gmkCR8DcVaO8q2oXnicSQcJ8dVniD5U+kk3BgQ42wS
	i0oll5tz0uCofUcCBt0Ctda+piLD5WEC0iPeIJ3wklLgofbnjtIHJtkb+D1P6w9xIum7qA8ghUB
	vKHL9Rks+uTx9/VS7/PLqc2/v+Dm+xs1+lRt3lQFnr7gZKV8fuSmD85QBJwt+vfXQpxli5sLdTK
	y5BbC85kMlX/XhSuSLmxH2KcSpSlWvlxYRz1M14XThCzF36baylhzjLbjz0yvWNUNndAiIxeYCg
	juh4LsVe7nvqdAx2oLpiinG8xkL6OR1SfcGG1s+sBWWXKAFetlE=
X-Google-Smtp-Source: AGHT+IEQctetiUpc2QcOpW5CX99/3QsW0wYbokv3zI/2EZN1Or1hGsYawLA4NLCdijZxTZnCyTjjAQ==
X-Received: by 2002:a17:903:244c:b0:223:52fc:a15a with SMTP id d9443c01a7336-22fc91a1e42mr167593605ad.33.1747073145620;
        Mon, 12 May 2025 11:05:45 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:45 -0700 (PDT)
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
Subject: [PATCH v8 38/48] target/arm/machine: compile file once (system)
Date: Mon, 12 May 2025 11:04:52 -0700
Message-ID: <20250512180502.2395029-39-pierrick.bouvier@linaro.org>
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
index bb1c09676d5..b404fa54863 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -13,7 +13,6 @@ arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arm-qmp-cmds.c',
-  'machine.c',
 ))
 arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
@@ -39,6 +38,7 @@ arm_common_system_ss.add(files(
   'cortex-regs.c',
   'debug_helper.c',
   'helper.c',
+  'machine.c',
   'ptw.c',
   'vfp_fpscr.c',
 ))
-- 
2.47.2


