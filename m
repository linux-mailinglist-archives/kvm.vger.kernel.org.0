Return-Path: <kvm+bounces-41348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD297A668A5
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:51:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C91BF7A1DF4
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479EB1C3039;
	Tue, 18 Mar 2025 04:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bTYf9gT4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5142187FE4
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273496; cv=none; b=Xt/+114DmT9bUFpoZYIvkwlXUjOcZrZeLNOQDHb/sR2F9zqha67UuO5qkdcu+wnfwfS7FQW4uxD21CKfS1/8jN1vSLHmXqwwfYyJgDh5l/YwV8RDbV4rzbj/IQXHh9mVcFLCVEI9GOTNDfpA4vNvYuIIpW9VjTRgDJjTDyq1UMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273496; c=relaxed/simple;
	bh=YY/wGhTSENXg/nPFgwyVG33cbYZVvZTYHS3aR6BRczo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FljujWNq+kjjGzOCtO3eHK7gcUN7kb/0RyvTGpNYkuRdKgLHkBR1yahHoq0xu2IFVDLgIaCUCixsyORCUDGqxuoc0JZcjL4K3tQbPIftFxkFV26dzowsXsW9RyFUV+EgTyw4KP4njwJf/8pc/Ii91iKcwMW9/xziM5VRGNz7VAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bTYf9gT4; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2255003f4c6so89474175ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273494; x=1742878294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qcqbwr1tVieUFzv+VyvLW43sytu+qG57UDVEiNckHsM=;
        b=bTYf9gT4+CgCjZoMCYDT1EWPauBa4xHyHd9yMkMflxVoITPMGB2QbGQZx4ICL1sA7j
         LzzUVkaDMrA6waJoX9yjXB5ztrhWVRI1ZabcMAmlYJ1orPGNgOeSBCmFmkUc3tiPWbWw
         RKyd4pbE6BXkBP6IbyYFc70hKrqRzJovMwkJyslYA/HH96NdVzpiwHhDG0cXjMV3i/ae
         YP9PRhUnqPT5lbyM2lXgyHEXMeITz1khGoVKfd5K5jzAcywhrJ2Cg/J4TX/baHSN6Jda
         1E1azH77vKozRhDso0mXtWzzeBhMn4GN8vdssZf/RItlcMaFjzQCx+tSwCPkvOlVq+2o
         b1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273494; x=1742878294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qcqbwr1tVieUFzv+VyvLW43sytu+qG57UDVEiNckHsM=;
        b=RroBY+gVA/lFjrviLH+5XtcKbrUp7c+fcq243bTT0sn19tLXhVb04nIXh4ciEszUoC
         i2YFBpuHZ4+L2yKyTVn7rY3XIs5eo1zn96/sEgfQ/SUfeQw0bUVhymOOhNwhm0B/qwpH
         s+oFqNAvycw/MM3vDpKYSm9m0UL/IWPIUiiDpL+vlHUfJQAlw7rX+wvkRIff7USCaGHh
         eq4mOmW8lY4HttUWxkOXwkk5To1fbpCZTdhpHMRSKhgpx8GpFC/ncZ8h78xSl0CJnPUk
         wTW6WWoJxFQWfUlQqCMtB0HMBjOH7KOY7Vam1B0LWTfVFFqDoQh1LiaNh60dWZ+C9x2i
         nl5w==
X-Forwarded-Encrypted: i=1; AJvYcCWAdETM3axr4D48OCZeGTUUSfsojzdjB3CsEHOaLiFTL6K55vFzcuF/WqIAOkwkIhiQOLo=@vger.kernel.org
X-Gm-Message-State: AOJu0YydyrWvLd1lWli3N05UgDwZz2Q82voRZhmAPal5VpkH6XUlQfJ0
	7zG0+hpRXRays/FGiY5ezU4Loe8iHBeKweca+Ohe+pIwxeAJN7Hm1Ed11EU8kh0=
X-Gm-Gg: ASbGnctPqR3MbRSeSU3mKTB04P+r8eyjKZp4ik8Nr5bGptANWfqwTFOI9GexzcrOv8x
	y5SlNhPqmAoi+uwUvQwXafAGwECC4EjPOgUH/Aqt37eiZz4hnfcb8vIZFL+pHiVu9auMeaMkr0Q
	2LQ8gFmU2BD0y9sZYHjui7kq5eeiqw2I9zJyOyV2QLRtrbKQsL+9klLCoPL0HQIeMtCaYH7rvmH
	KSX9SniZs4+krNuoqy3hnDjpBZFr441p9T7mTFj9KTuRvnsIihMpWH2yY7vx1Hy8Ql6p8AHojlm
	dBjbxWGuFSvazzaqjwdmpLVtHPfMvBqiftkWA/EAFjFd
X-Google-Smtp-Source: AGHT+IFfMoeTTqls6zY+hsXszh3yHhLtBiG+rzEGqdr9nPsWVicrdsS6kI4KP9BQloEuNsUFe9nCuw==
X-Received: by 2002:a05:6a20:d81b:b0:1f5:6c94:2cce with SMTP id adf61e73a8af0-1f5c12cd664mr22674037637.30.1742273494052;
        Mon, 17 Mar 2025 21:51:34 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:33 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	alex.bennee@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 01/13] exec/cpu-all: restrict BSWAP_NEEDED to target specific code
Date: Mon, 17 Mar 2025 21:51:13 -0700
Message-Id: <20250318045125.759259-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This identifier is already poisoned, so it can't be used from common
code anyway.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 902ca1f3c7b..6dd71eb0de9 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -34,8 +34,10 @@
  * TARGET_BIG_ENDIAN : same for the target cpu
  */
 
-#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
-#define BSWAP_NEEDED
+#ifdef COMPILING_PER_TARGET
+# if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
+#  define BSWAP_NEEDED
+# endif
 #endif
 
 /* page related stuff */
-- 
2.39.5


