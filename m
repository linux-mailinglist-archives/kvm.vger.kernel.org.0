Return-Path: <kvm+bounces-35945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D4560A16694
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 07:13:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 883531887191
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 06:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C93F01865E2;
	Mon, 20 Jan 2025 06:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GWAPetPo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EBD183CA6
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 06:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737353623; cv=none; b=m7uKJkWk+AZ49HHxfAcD7RRkBYNJT3maBdkZO1uykhKf5HLellGOMwGOIXm7Gu0Jb+kMKTFY795ZVVdrOd0sq/x57UbaLdlyjgFuOw2Waz9Cyl8TJRIB2zqnSMvpUbcgkKGBXYjUjbMjPwEaJSKgbaSoqSApUtnJfeXSMW+DMKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737353623; c=relaxed/simple;
	bh=QnSpFRyKWMt39XVVx2ELFJMiClQemrEIudYmDiEkT6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=canLkyVambpx4pJt35xq7s75hBMZ7Z3JP1z1FTrmEtJvpikj5VKqKQ8L+rQmEHOUwmJQ7U+jx8TJvx9z+xGK0F42vSqMr8ylEkNcxD34kgF5fHyv6WnrKnijhYiUDfh67fr0VfkwQ3D7MhoaalbOVgk5/caqjlPqgyjJ3VL38Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GWAPetPo; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-38a25d4b9d4so2169307f8f.0
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2025 22:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737353618; x=1737958418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zrM4ECk8Y4tTKYauXOgMnvdhb7JSom/rYyhvfhnsqZM=;
        b=GWAPetPoBEM+xV0Zx7KvGqkfpT8GBZXtFfd40dWKu/KjHxCtBYv43gJjcQuFBeOPCX
         222xhoNC9Q930OKxns1z8JD9SJ+JxD3HqY2tkoQd6RYZUasYM/iFi9UPfJffLvoQ7muJ
         rlzyIeS/sf0VY5rVfYxiRr8fAc4yakgI3xJ78lDKIpXTl3tnGAhsHJCKgIbBrKFiJgtM
         7j5GKdOgGX7YARnoXjhqhxUKQuq8lLdCnVtu0ue4HyJXMDsggpWz1g6LzVDVZ+dBPptb
         jeAB36YPnXo/EzB1TSCIowd1Ksl69CMdc/0M5b/WmfRQmE14aaghjqkCXVNaSGYrLvIs
         1ymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737353618; x=1737958418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zrM4ECk8Y4tTKYauXOgMnvdhb7JSom/rYyhvfhnsqZM=;
        b=CCE1HATtTItZ6riryo6Gpt0J+OPH4wqe/ViQma52QCBh0B4CE2izjg/wLrqUcUBzgb
         aLjPM2VFjtm2grTSM/XNm92YPnjmnabzTkxOPG9lGRb5SK5Dvh9F+qPzjENGUIhHKnEw
         +RAS8wShtlSan0xq7z+LJjaJLXRJx0/Q/Vy4ZUBR1M5hPLAQXe+JR6BrfpktIi1c5Iq5
         TkfH1orXV17ORVpc33tSlVVk0rd24l+8g6RarCYwnxrIBCac0wuPq8zZiU0BDjIMN2mb
         1jua4zFlld/Kz8XANea5uhYKZ3ajOvIEJk5ofDsvRxgV1wr7iNWe29R+njOJSbculrVU
         SoEg==
X-Forwarded-Encrypted: i=1; AJvYcCXEy3hj8l9JRWhcjUzRkkJWuRS2/eh/aZOYd9Rrc77hnAabrgZQBOeWyeHI+AuSE5Zp15U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQzwJ1xLSG6LIXwBCU9GrxS4EfQq2xgIboa0liB3nPWXJ0Ksf4
	6Ec16d4M+40656Loj0hCPyPlxlxiE+lpt4CEtU3dX5XtlRLEy1ICindUbF+ADec=
X-Gm-Gg: ASbGncsfqL+TLYVmfZUD8CA++01oqoRrmqj7eK3t3dwdHLSqcQ/HIzfOorePGPLQjET
	5DpAzssxw+bTA9L9r74RRajkWvD3KpTAd/ozi5XaQ2tNS3Qg+FGIaxJxyq+stdFv0NQwIJgC+Pn
	38zJkDO9RGaQe8aX6ultQtXKg2wE09FeMGBnhmo9QQOT4hmG4FUHl3Bc9uPQiZZPIOozDYnFMf6
	j/Znpt1TNTlt4YQu96YRSgBtq/smYvPQllE3zFd8VxNTPac4UJRcBrNBmaDWGthH8JxB+b6NIry
	1cvcWQ6R+sY+zVxiCOEzjnJ7e2NjWR6FfSh7pDgq6BS9
X-Google-Smtp-Source: AGHT+IFpRrXKHsSHrGRf1/tQTx4ulvm5uan5qSrL2gEPeDMmiy4K8PABoDPo6hPEEcNwmESkC+jhcQ==
X-Received: by 2002:a05:6000:1fa8:b0:386:32ca:9e22 with SMTP id ffacd0b85a97d-38bf57a9b6cmr12043649f8f.41.1737353618483;
        Sun, 19 Jan 2025 22:13:38 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf322b51bsm9514651f8f.60.2025.01.19.22.13.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Jan 2025 22:13:38 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Kyle Evans <kevans@freebsd.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Warner Losh <imp@bsdimp.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <laurent@vivier.eu>
Subject: [PATCH 5/7] cpus: Constify cpu_is_stopped() argument
Date: Mon, 20 Jan 2025 07:13:08 +0100
Message-ID: <20250120061310.81368-6-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250120061310.81368-1-philmd@linaro.org>
References: <20250120061310.81368-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

CPUState structure is not modified, make it const.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/cpu.h | 2 +-
 system/cpus.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 04fede0e69a..00c16081396 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -857,7 +857,7 @@ void qemu_cpu_kick(CPUState *cpu);
  * Returns: %true if run state is not running or if artificially stopped;
  * %false otherwise.
  */
-bool cpu_is_stopped(CPUState *cpu);
+bool cpu_is_stopped(const CPUState *cpu);
 
 /**
  * do_run_on_cpu:
diff --git a/system/cpus.c b/system/cpus.c
index e4910d670cf..5ea124aed0b 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -73,7 +73,7 @@ static QemuMutex bql;
  */
 static const AccelOpsClass *cpus_accel;
 
-bool cpu_is_stopped(CPUState *cpu)
+bool cpu_is_stopped(const CPUState *cpu)
 {
     return cpu->stopped || !runstate_is_running();
 }
-- 
2.47.1


