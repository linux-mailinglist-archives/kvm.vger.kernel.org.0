Return-Path: <kvm+bounces-41354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A761A668AB
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:52:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61A4219A2544
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE76C1B0402;
	Tue, 18 Mar 2025 04:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aivLWNsO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650E338FA6
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273501; cv=none; b=AQMo54pVMKpFj1BYKFqfHAaIE8NjcQ6IQC0/dynkwZA+GU5cTEI7dgh37NIGrPG57hWNDNj0KUvRqYVjYUJiWBEywYXP37kZj19SnDwPYxvasv3iseLp3MbhH22F0V6qcRzvxy2c0EXuM5WiJen6x6qV8QKNNGVfTDR8kwaZTdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273501; c=relaxed/simple;
	bh=ryhhsIWRsF1rCK+2IZXlgCT6qZHTW4T2VnsqiMi7dgA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m5gMmNqPY/MOgmj+pReq8uORPBPICNUtelKdx5DTXsA6cRU6Dhje3V87IO+MFG2o60VAQKk7CClNz71XUV4biqp01GuFO0njJFaVzszeVUp4PCxm9LK+j4QJEHZsKzeCBwPNJL677jxLwlh9POcZSGrD7wYXi6sXzAHFPvsmx/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aivLWNsO; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-225df540edcso68626115ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273499; x=1742878299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e9rzsv10o1w5kRlHax2UvpGLKsY+tUQFsRxZLLJXZ6E=;
        b=aivLWNsOKdgTNPsqFqHUON4lqNPi8TdZ5oYJXadbPHXPgMFkt1DkGoNDbdphogviw2
         kKBii9xyBpwpdpQDMMe+hi1ZInvWvDnTm/IdTvE+sqN7cCpWPISWhutBGiD+NqxHlsY/
         SWJN8fKOZrFp9eCFWJdW/KZX0QaVO+jdrVckjk99zTnB999sCmELlvRqmLhJHDPwMU1+
         V/KXDHVIlA4T2QC2loHCCKMNjyL1x7wPboDH29dzhoATxZrdA8eS/2qFbd83/5JoWZ2u
         CecxhaJWvTiK8lUcEU78awE3gBVsKHF181C5WhekANmpwpQMRZLsqEvPeWjy4W2oE1Cr
         MV7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273499; x=1742878299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e9rzsv10o1w5kRlHax2UvpGLKsY+tUQFsRxZLLJXZ6E=;
        b=bCUV5QJGRnjZHJqllvgbKysPQkfIOiJqLBbrscGdAC+FSO9tFOhnat5d2vYJSGNlxo
         8tVaOGCudpowa3pH4OUyO2TQk1jizDvRWShJKz0q4MFPDjOGbMYFGvajzOKhuORDvMvq
         Xw59+s6naDBj8FDfFnoeXb4MjUw2leZcLb+fSK7aXDsLyVMX/ZdnEFyLQ6eCv0xazEI7
         fL83JjRyRjgMKXUC73WKALLLpV7fdDododlnfXdVgu0ClP0cotYraA7zpZ67Cg/JCGb+
         Ek8oqZ0jaV/+y5zCPxTZQj3huAkiakW7s0m3IEuILYbXdD7bWO+XDE3VFUDLJuyr7lWk
         0tDw==
X-Forwarded-Encrypted: i=1; AJvYcCXpLmUsPuuDGJpK5AUbt6jkvvF3lA6tl+ss7e6JzcYaBWBGRaFwlIb8R/1A3796LHJ4PDM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUrFsUodwFmZQn5XBDa4wJeVwG+5WOIf+Pwh02k2Ka6ont/gGD
	5Q34tnxunNq17Yk8Mw/QuToh5/6zqGqGE1d9evroW/AX5Xstbs4Raey0O4Yx0rI=
X-Gm-Gg: ASbGnctERlGUIGcuMXz1n4suc65suRi/mWGmfGUc0HQuc54J2MVpxFD57lKTGUP0Djd
	AhYjcfAY7WbmJzpfDMJMc79iOtqlNxHlt4vv8M9YTrWm4jPRu0BmQb0TjUX7mwEJhdKX8ENTp6n
	Ev84onMIXEsPtCVbYWVemdWmZruEw/ayLpu933HjSM0Ue6EL3zzbbXsk+ygc0jc/8j0nIR+BvI2
	q7LIB41pNR+khoCiEGZA+qcdNPHScCBg6XkRZpSRgkqCcqQkmGU056LQqwrVEMBpmOGT3MBzFwD
	ZTgB6Um2wFZMXhVpdZEIoXuKedc991L7d0ko0SdEwWIX
X-Google-Smtp-Source: AGHT+IE8qR7rvWy16B29zqVKeH+5Xs9FEHJRohxtlVk1ha0v5ACDqhpK4pBzwowgaOfPj90X8hPjJA==
X-Received: by 2002:a05:6a21:27aa:b0:1f3:1ba1:266a with SMTP id adf61e73a8af0-1fa4c6a1afemr2173708637.0.1742273499683;
        Mon, 17 Mar 2025 21:51:39 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:39 -0700 (PDT)
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
Subject: [PATCH 07/13] target/arm/cpu: always define kvm related registers
Date: Mon, 17 Mar 2025 21:51:19 -0700
Message-Id: <20250318045125.759259-8-pierrick.bouvier@linaro.org>
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

This does not hurt, even if they are not used.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 23c2293f7d1..96f7801a239 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -971,7 +971,6 @@ struct ArchCPU {
      */
     uint32_t kvm_target;
 
-#ifdef CONFIG_KVM
     /* KVM init features for this CPU */
     uint32_t kvm_init_features[7];
 
@@ -984,7 +983,6 @@ struct ArchCPU {
 
     /* KVM steal time */
     OnOffAuto kvm_steal_time;
-#endif /* CONFIG_KVM */
 
     /* Uniprocessor system with MP extensions */
     bool mp_is_up;
-- 
2.39.5


