Return-Path: <kvm+bounces-51445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E41A9AF713D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:00:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A69F166C48
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2116B2E3AEB;
	Thu,  3 Jul 2025 10:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kMaRT5+V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9697829B789
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540368; cv=none; b=INhXt9hjSFGlZyYnzi+N/BHmwRQkzt+6Xt5Dt+lXUabqRbaQTh1UprC0OczKrVbtdHSrjHyC9cNROb7v3Vfg0oB7OVspCSqBRzZu1TPKhWrvlYsQRdCnCWJEtkwfCsK7MeTK3pUNT7V54AFsO1uPapszuEnIB0g+NDvdafmBc6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540368; c=relaxed/simple;
	bh=gcC5czTCIg5Tfxp/c/XAgwB2+XFpoSZ75ZTPAJ2NsEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l8ixDlMPh6uYN2tmt9J/WryYZLRVTfFs6Fv3/BAdUoU6F23B6dTAFvhwKlfnJdVYfU3Mw/8me2Uaq3w3ZJ323XviQNFD6XcEEtbe78ExXJg3EBllqfvzOnKBa/snWs9S1Sc1esfpC2AKCdpfKbLXOq38mLfnX6OaPG+aaDP8g/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kMaRT5+V; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a54690d369so5259239f8f.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540365; x=1752145165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZapE+BsIWKP1uR9SD9UqThOOP5DO0oP7K7FrxAXgmYg=;
        b=kMaRT5+VgTVbMkUZc9L1QPiq7AN1ujkjBG7150OO6q4ClqzRkIUPBI3R/6Ic4CNtiE
         LfxQJMaKmIAujLW4U0Co3vllzT6BJrE64MI/BYydaiWDbr6Bynf2C7euPFy/zA2sdjyS
         pKCYKldvqq0hKGXUZVTym0OSj1n1aMhu6fCNrCMTvl4ElAgxMoyQPt2Fb+/kMb9OuQw6
         PApWvJN2m6bCIcGXbV4roO8do9008V81Bt6i7qRp38oNkJdu8iqADgU3/Vsx94J2zlHo
         8bA+8hvRz1lnvNKtagcLR2KwVUk1kFMalTTAVxrBEq4F0wDt3xNMQFoR3oPtg0cFDRKd
         RheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540365; x=1752145165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZapE+BsIWKP1uR9SD9UqThOOP5DO0oP7K7FrxAXgmYg=;
        b=w9lv6/ruMsIY2FQFz0rcptrJlUcwCWkiK+CoyCLwrfpxVkCiWnpbnngQnwE0SyIcKa
         M/TZajXdsiQ2wrqrCaUz53rjcUE9emHQi5SwQBBf2qUZqHlF7X7PUEV69mHKq5pBM9Ky
         VHjdoBFrAfOlmWGR7k0Mn8ywQeT7lda5XB65XRU1RL3kW/AoNtRoORZcSNbVxmIytfey
         8vDADCzfHP7I136tiScVadoN9Wmi2QrwlYxbR6lPVKSGKaNvOkMLJTo3bU+xhc6EDnQ7
         XOG1it052BmsSDWGlJYUYo44QYlQY/9esLztsqQWaMtxUmIpPv1tvzIM7gd568xvPgS0
         ypMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWouLUmm34IqYec2pxcjX7obgX5KhTdhg3Ze3QDYMa1pKoLEaRbgGJq+NXgca3EV1LNyC0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/DRO671nMZmz9iqS6V+rKLOnpwyTzzVWCaSHZDLq/ovwfYN1D
	pTIwtit66Zkyz7bHuBVPW4kkIeU09plTeEdu2Zp+L6+fQEEOzQQZsQ+siuNjJw9Ptjo=
X-Gm-Gg: ASbGncvB6J7fDTSHVJoeAyNxukZS2AI5Oh0hUBo79vbdPwnxDnv8B7dVaaIETcYfrsZ
	1vUqhmWljwv/uiHDAeHT7ZGnUuqWgZz1Ype4UlSo8lpoZzEq1/aE3X71gywI379dS6UniPFTgAO
	F6wUpQvugIjvXGRNcLj9rq3KN1ThPgNAB4MV5pAiQh84x2cg2bUVzGy3LSxR5OOwAYonnq7QOVU
	+POWvtRh3IigV3BIab5kyVpHWfr3fXK4y6OzLr/z6r64mJyligvtpXHjn7ZM0ES7ITC7swA+dNW
	r6qqr4Zo6rS7ZBV7hC3au58bd4+/5aWFdYV4n8YOv3P1AIc9ZY6C9agHxrlZ1JkXE6yPUjkcRjz
	NUFuoqucwcs4aMTwUIq45cg==
X-Google-Smtp-Source: AGHT+IFY9M7MGc9Du92Rg09ABFGQ8dmP+5MoX5ZHraX2JMAk+dchRReAPMN4ssVoMNvxYSI4Pwb8+Q==
X-Received: by 2002:a05:6000:480b:b0:3a3:648d:aa84 with SMTP id ffacd0b85a97d-3b1fdc20ce5mr5225925f8f.5.1751540364905;
        Thu, 03 Jul 2025 03:59:24 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e52c8esm18531283f8f.55.2025.07.03.03.59.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:59:24 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 42/69] accel/system: Document cpu_synchronize_state()
Date: Thu,  3 Jul 2025 12:55:08 +0200
Message-ID: <20250703105540.67664-43-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/accel-ops.h |  8 ++++++++
 include/system/hw_accel.h  | 13 +++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 2a89641aa81..ac0283cffba 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -45,6 +45,14 @@ struct AccelOpsClass {
 
     void (*synchronize_post_reset)(CPUState *cpu);
     void (*synchronize_post_init)(CPUState *cpu);
+    /**
+     * synchronize_state:
+     * synchronize_pre_loadvm:
+     * @cpu: The vCPU to synchronize.
+     *
+     * Request to synchronize QEMU vCPU registers from the hardware accelerator
+     * (the hardware accelerator is the reference).
+     */
     void (*synchronize_state)(CPUState *cpu);
     void (*synchronize_pre_loadvm)(CPUState *cpu);
 
diff --git a/include/system/hw_accel.h b/include/system/hw_accel.h
index 380e9e640b6..574c9738408 100644
--- a/include/system/hw_accel.h
+++ b/include/system/hw_accel.h
@@ -17,9 +17,18 @@
 #include "system/whpx.h"
 #include "system/nvmm.h"
 
+/**
+ * cpu_synchronize_state:
+ * cpu_synchronize_pre_loadvm:
+ * @cpu: The vCPU to synchronize.
+ *
+ * Request to synchronize QEMU vCPU registers from the hardware accelerator
+ * (the hardware accelerator is the reference).
+ */
 void cpu_synchronize_state(CPUState *cpu);
-void cpu_synchronize_post_reset(CPUState *cpu);
-void cpu_synchronize_post_init(CPUState *cpu);
 void cpu_synchronize_pre_loadvm(CPUState *cpu);
 
+void cpu_synchronize_post_reset(CPUState *cpu);
+void cpu_synchronize_post_init(CPUState *cpu);
+
 #endif /* QEMU_HW_ACCEL_H */
-- 
2.49.0


