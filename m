Return-Path: <kvm+bounces-45330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9ECFAA8419
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:32:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53B9217A22B
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF931B85CA;
	Sun,  4 May 2025 05:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d0UlAffB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3011C84BE
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336594; cv=none; b=QVt3V3lsKC0SVqfAy/1eTfT6j8Cxl11/rjjFihSn9GGU2kjtEejvc1qAV551fFfxIPK+pwos2GSKgYULE1ZJROGk502N3ubvbufjNofBMCf4/7JHhJAyOE/IKNzhG81X5pKQIp6EDCR5rE7kspM1IGJT1KcckcQQUArTxV7ba3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336594; c=relaxed/simple;
	bh=Kl1UsKIXvxONWdEIgci/kn2DL5Y93JMFul159hn42KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VklHePrOTPYnwUsimgJy7gvZMUsVEhFq6oU+vrvOsblmZ0ER5a3n31bcsjNLuEiPx3JyczK5QShi8mQAfI8Zo9PNkwPtIEHa7OQKLvNDJ1iYljw8Qe3ptv09gm+HotF2Z7UWj3/sTGajWUpM+7Ibpw8CkSAZ/IgRmTVrj1OqEpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d0UlAffB; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22e15aea506so21472515ad.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336592; x=1746941392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dgq1OA4KuFLS5XceK9ZkHI9zBCVx2Be38qBE8eQ0ZbQ=;
        b=d0UlAffBLqPL38UtWcZdO/mqaasF+jw4k3Pd3z8ORpLyI05sNiLRTgbM1BbMMf/SMA
         Q/F5FEil9fuG6VfWmtooWyloKjAi7VVKlTlo23mdgrEsAQnPHwUfYBbsgeK4yJR24i5C
         mY9nierIOMPB/8zwZ04dsPECEFH8JBMQBVCTJePUCwoQcFjTlWDTK9zvoV8CPkVDZ2qP
         LY/bwl+X3fv9y+YhIiJB+1fCa9EnjtY/2BXiPVuXk7LAUSW1xleVGG859xNZfaxELMes
         Te3lNdOmoiOwUlxMTYnPJiC97ol+Odav/BnJKJMNTtV+7UFYkBAkmnKuI59Urjof6ipx
         liYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336592; x=1746941392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dgq1OA4KuFLS5XceK9ZkHI9zBCVx2Be38qBE8eQ0ZbQ=;
        b=YT+Ypyawgk7XwF3wcWcwbOqUSm4nVMmqyibRjvEl62PdFnl9/9mKXbrQKFTtDwvuDa
         Drv5vzgGn7uBZ+1gZIGm/572L7xNZJ5se8qbsrT6q0KkKLY2KvzLvfNd9laNZNIuf8oM
         8dG9pyWXl6fyXuDutBzw1RSoqFaf1ILAqOHPTYvEjIZZXg6Z1P898kA9vF3ariRylPn3
         CEARv5Dbtjv9qlviKsJjdyqVphKrd/YpEzxd1tUXp2QnTCfIZB6MGTD9BLUZyxt+lWva
         qt36AgwpSNnDnNIipuSW5r48hTAFFRvD0Bbgoppv7AtW5/RW8HqM1hoPZva5+aqYbmjE
         xdDA==
X-Forwarded-Encrypted: i=1; AJvYcCUwp8AmnWCLi70333pAr6JOdChIa+kSJs50og7qqC+5dolUlimUxcNaFBR1emDfPlhH59Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6YHOjLcFi1DpJ5ejuvWvFyZsp6K2CRbBJH473c5lGbIQeZFwH
	FUgHXmABsGFV8EJUOrTCi0vSsszFjBsphdpMzgGI8yEP3kIqiRMuKx8/Wc4XJlo=
X-Gm-Gg: ASbGncuFKNEmnQhLtPtegQ84jWRbMDjj/ltSo+CMl79LPevgOIiwoCVdZePD6QIzTqQ
	ndVVNT4EfkjO8Grif3aD565PWzYnscrosWkgvYkq6/zkLTXSiB0e39U/pJ1owt8B5tnMtpLb3LV
	h8KIZeIfiihjXka6IvtHvfoAgE1I0jQhmeyfGlhU0pfEiGNOQYtot42v5uIwPci+weXxPzkzSbY
	uzar2zOg3s2OgirqWx2v1H3RksMH19K952o0IcKAOAoHW2olmNq06KzmXWw9KWP61PBYPeF8+zx
	gNyLrRv6zcaPZjtbPnFvIfEpzJdu0sRsyN8As2M7
X-Google-Smtp-Source: AGHT+IH3PkRT437ZbtLEUIz8+9AOsGuVI8JqwVpnwH0hHYHJ1JXGA0CKFFoatJYNym7SpJ/H7Tlzqw==
X-Received: by 2002:a17:902:fc86:b0:227:ac2a:2472 with SMTP id d9443c01a7336-22e1ea7c667mr47948295ad.28.1746336592452;
        Sat, 03 May 2025 22:29:52 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:52 -0700 (PDT)
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
Subject: [PATCH v4 37/40] target/arm/machine: remove TARGET_AARCH64 from migration state
Date: Sat,  3 May 2025 22:29:11 -0700
Message-ID: <20250504052914.3525365-38-pierrick.bouvier@linaro.org>
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

This exposes two new subsections for arm: vmstate_sve and vmstate_za.
Those sections have a ".needed" callback, which already allow to skip
them when not needed.

vmstate_sve .needed is checking cpu_isar_feature(aa64_sve, cpu).
vmstate_za .needed is checking ZA flag in cpu->env.svcr.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/machine.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/arm/machine.c b/target/arm/machine.c
index f7956898fa1..868246a98c0 100644
--- a/target/arm/machine.c
+++ b/target/arm/machine.c
@@ -241,7 +241,6 @@ static const VMStateDescription vmstate_iwmmxt = {
     }
 };
 
-#ifdef TARGET_AARCH64
 /* The expression ARM_MAX_VQ - 2 is 0 for pure AArch32 build,
  * and ARMPredicateReg is actively empty.  This triggers errors
  * in the expansion of the VMSTATE macros.
@@ -321,7 +320,6 @@ static const VMStateDescription vmstate_za = {
         VMSTATE_END_OF_LIST()
     }
 };
-#endif /* AARCH64 */
 
 static bool serror_needed(void *opaque)
 {
@@ -1102,10 +1100,8 @@ const VMStateDescription vmstate_arm_cpu = {
         &vmstate_pmsav7,
         &vmstate_pmsav8,
         &vmstate_m_security,
-#ifdef TARGET_AARCH64
         &vmstate_sve,
         &vmstate_za,
-#endif
         &vmstate_serror,
         &vmstate_irq_line_state,
         &vmstate_wfxt_timer,
-- 
2.47.2


