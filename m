Return-Path: <kvm+bounces-45326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4509AA8413
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58B6917A201
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE26C1B3930;
	Sun,  4 May 2025 05:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rUq6ktMM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5ECF1B424A
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336591; cv=none; b=R7Wjc1lbUT8I6d++4U/Ut0cLPUQGA0hw6CX1vNUnZVs7Z6m0I43Kv8ecg4gsS40k2t8sEtF6QSLOd3aTbu8q+4sHYNHiSw/GLfrTPKcCm7cyb65Wh+c6fKacyA5hUeazkYHrfvQkaqem38FUJhdoufzzkMK1PVo/5Wg2cpTPnsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336591; c=relaxed/simple;
	bh=ENP2hN0JkLSGgU+MLNHwU2T/tGgXwB94KuX7uaX3DAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKiFrN63OmQWpU0CHOAlJBJygHQLfeiZgcuznjVlvz/f34gF1fLGTXvj//mNmyoqTYLlC69mqQU/khDEWApmxCQfhKqkRRK1xrKVYVpdW+xGBjhmJ4/dgxn0IdLC4Q39qXGSZ4X71B/F6n7DjfAG2+FmDXpIyMuOLlZfv1FnPrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rUq6ktMM; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso3518660b3a.2
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336589; x=1746941389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E27VnLHwdjjgu7+qzkSpdD6sP1u8J5fzfB0GITxze0s=;
        b=rUq6ktMMCBkPa1mBMoGGqsk8Kd5HyU3OwvGDYMB1ohg4kY/Miyvwdw0DXAAR5iCzlb
         7y72AOtY91FQkPDQZqtfpxWa5JrJCSydBJkVgkhru/1YP0WjrijFw0ThXgmBm49e1vyO
         iyMbRUJmBaJZdjcMfKSiSJJ8IPu63pbbIZA4hCUKs4DRP61pXyLVQUgMaTQJTyPdfnf2
         DYny5LLAI30xwi+IgvYc8VLFmaJiNf3oFzqxZADcZKfcMx9l8hMYYxCBUlli8TvzsCFx
         BLwI2SPRkyqEwg8CqoZw6FhB36JwydticcVFAhsKI6F5qgrQ/wGkevq+kS2E+WhrM6u1
         lxSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336589; x=1746941389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E27VnLHwdjjgu7+qzkSpdD6sP1u8J5fzfB0GITxze0s=;
        b=YT0fCfqpFf4C8fIitQUtHegZPo6ObzXJ3jEhQzAekjk2EASuX4hDt9ulDMxBHnY4mD
         8/YHdLfME/lt5vehHabo9DtwDdxGYFeGajPbUKOogRGz+BDyiwkKzZNTYg3vDjJ38Rhm
         avUiDcrTOXwb6F6u8gVOjuII/ODHHj089DpFDRx+MiBJCjNcQr+L02fxJCnW5rCM2kSY
         Ugg88EVyO3ohT1VWbzYDOu9giC1OM1UePKuC2w3+a2UssFMxsigP+gsulXJ1XNYWNyvl
         xN79Q0euy2JMvC5slAIq5ydldkZpJJkL3V4zLAnktLH0wG9ly8t9QQrnlnqfG6UFIDPq
         kzCw==
X-Forwarded-Encrypted: i=1; AJvYcCVZnogsPA/gjWCQi8Ztp9dho37Nvm4KVLa6USiB0W7pvfU80YVXI+ONW78gPlIxlnPqY9E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBb3Y6zgrgRZmRKPT4FgP/02x5jlmuLHUOdVKoKvtA0VF9rQCU
	n9HuVUwlMFJFvBO/UCmaL0B/aIn9hOEyqy71xV4pnvmEzxKdMxmynLO0vTX4h7o=
X-Gm-Gg: ASbGncuDSO+SxHHAKezyN/Qo3rqYgSd1y9XQhl0lHzQEayYoXUx0Ydd9aHLzdFKSE9a
	X2wnpRtUWmzCi8N/oaiN0/6BjxKiePdqvJhIcqISsishEzIRJuTdeD1gpW6qaZ6LzwkNNOSS48q
	RfwGP5yWglLL66ofIzX4RlI1S1ff+/xAMbZbKfYsj/n1EFXNCJ7hdRYmjkFeuwJNXmBw4i5na59
	Vmb5GhaNCotoIeWlND1t0rMEIzIlr24lShkXp3ppEkVy8kzfJ6I4DoZ3DkDqD0z4Q/61GjrRZEP
	+LYMhKpeSpqtXmypHtixL/MYxixFr/kTbKkJ06Af
X-Google-Smtp-Source: AGHT+IECb2kqsXYdYx3HexFcHoSRwPANHXQWSjcMKm+7Iwt/AOnqMohaPWxRynpWHSWLdEAcrQgA/A==
X-Received: by 2002:a05:6300:668b:b0:1f3:41d5:6608 with SMTP id adf61e73a8af0-20cdfee99ebmr10830982637.26.1746336589134;
        Sat, 03 May 2025 22:29:49 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:48 -0700 (PDT)
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
Subject: [PATCH v4 33/40] target/arm/ptw: compile file once (system)
Date: Sat,  3 May 2025 22:29:07 -0700
Message-ID: <20250504052914.3525365-34-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 6e0327b6f5b..151184da71c 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -17,7 +17,6 @@ arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
-  'ptw.c',
 ))
 
 arm_user_ss = ss.source_set()
@@ -40,6 +39,7 @@ arm_common_system_ss.add(files(
   'cortex-regs.c',
   'debug_helper.c',
   'helper.c',
+  'ptw.c',
   'vfp_fpscr.c',
 ))
 
-- 
2.47.2


