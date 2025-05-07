Return-Path: <kvm+bounces-45805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BD0B9AAEF94
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:48:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 862EDB2055C
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:45:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A69E22951CB;
	Wed,  7 May 2025 23:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vWlazuA3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4D5294A14
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661401; cv=none; b=H3xUNL+AdYf3KgXCof/dsZK3SeWGyZVSZOsUkLWJk5UvncMbrqpNEqHrgYhtQikSaQdXE+HPa+kQaRwWf8cnxFyQBpuuQvptO13sOd/clKzR947Vxv5cUdkIZOvpkvSif/Fs0jjj+KvK2cG427wl6NRMiabYJZuH0cxEzBTlrNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661401; c=relaxed/simple;
	bh=/zYUGtiopuAnKe6Qv0yETkvli2mk8237qAU3JIOPtdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUGwfjI9/wRcCzzJbJ8l2SEzplcJsWiJ/8uBsVWoYev6VRL3sxeNc00vt+HtKnzDxgbGTylPYAB7a8mDlLFUQKaD+uwSIb1DT06xsCuHMN/AXc91tJ/fGHQf+lmXjkFKEHg+x4O93xJk+e5BAchGfIvHmSlOasEIj4XH/BX6bUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vWlazuA3; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b0db0b6a677so283515a12.2
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661396; x=1747266196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6rvyCptpZZum3a3XLfgy4KbKHlT47oeB0wfjegrLwc=;
        b=vWlazuA3QWhpdrHSK9vWvfP1GYlFctMFKURFdhyjYGlnDxo4Kk3TmVXL00QeIT0hqC
         aLmVRf3shbU7/7TXKeYDPekib+DKoW/ELrxL8L+sNo+PcaoFsUR20UfVkKS89JpJLc6T
         2lmDL5kgjS2NPdX4S8DXlzEAX6QVgI+5jcM3I5z9SWNtu9wVRHKBYwjimAXc7kwtw6Ef
         KgYUKe5jO1yr2ksSQJAUmB7U2N6dK+Tpqko3L1XVhFKWPP5PAZMGnet2ko+0zjMRmhSF
         xpU4spiJRaT2zoaRd1anL5xwT8lbsxoW/KpEI7Aa5aZPDEJASGkR2PzZaExAG1N0IQHb
         YjtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661396; x=1747266196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F6rvyCptpZZum3a3XLfgy4KbKHlT47oeB0wfjegrLwc=;
        b=L2png7F90VQtpc/LFCt7o8yQVgK7p5dkX+1aIYW/hVfvc46YGLxLraLOj6gtKQ/rWn
         meIqBjSYigCuKApBpi9mj54+7Tr4OMiZCsaNtHaICaGEYhOsdTKOiuEw5CnbIsDmoyI5
         9mHSktkXG/yEqQ7kEuJRDes37yG463yezFlwZvFiDqDwz6yDRgvtQmkrIXEHX7J9fq45
         cXGmlE32OWs/c4yA9xmFpwj2p3VD2HwDNJQZMGjdG1pA5g7tEGpOaeBwbpi0H7LUl7uO
         zmy/o7ndjNoRPMbrGZ/zAHsWI8YPcmUf6xdnwjFHRpS3Ty4yTWYgqCpxRiO9Mumta2Kt
         XzkA==
X-Forwarded-Encrypted: i=1; AJvYcCWLjQpwzNh7hvn8bmzQBfsCKOWd1i6lAkPADfGW2TJLz6gTR0LoZC/uP1srsG4X3PYvEsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeTPTKuA2DvBw/bM/FDVF+CDMb7VyXRhCYiv0SpHtbHLyDHN2F
	dW1xdo3JCSAh1PeDKTmJp7MFbIa0GIVbQvw0MF4jHjHo8ULWzcqLL3RjTTaY8lI=
X-Gm-Gg: ASbGnctz1N9jOQ5w8pjM+FHQ/Hw7qLIm6+rbk2hLHogJQsUKgrsNYYq3mTXQg0I1WxP
	/TxVAGSQDwQtqZmfmXgncM6RjeXZO1GbkXrK1YTgbdSfec9L7bi/MnMslWqHPzOMFcZNOjvAUpO
	dFKwcLL8HZU5RkDEzB6kfFyOCgsC+cKZ30KABlTgYiZk8yVLINGR0KwYgnk9DJ3waeAnzjCAvPY
	1x+iqEIXq6ifsUvwcpbjpa7ksVWoNpOxGponvcQpBCKf4RuwLve3pCtMjyUwm7wjN0/OqOe+ZVy
	V1eLLqr5Q53kdsVu8rAYmRfdazfulSd/ZNbPNLrG
X-Google-Smtp-Source: AGHT+IGbXpVTbR041CeMnGcomU3gZeDQGJYdsxW6D2UWIAmpkewY+S/xE0Eh1L5Jy7l2aT8fMDhxzA==
X-Received: by 2002:a17:90b:2d06:b0:301:98fc:9b5a with SMTP id 98e67ed59e1d1-30aac186270mr7642172a91.6.1746661396688;
        Wed, 07 May 2025 16:43:16 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:16 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 39/49] target/arm/machine: compile file once (system)
Date: Wed,  7 May 2025 16:42:30 -0700
Message-ID: <20250507234241.957746-40-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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


