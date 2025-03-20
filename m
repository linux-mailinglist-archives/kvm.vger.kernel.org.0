Return-Path: <kvm+bounces-41630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59CB8A6B0E2
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:32:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C33B17B3861
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2703522ACFA;
	Thu, 20 Mar 2025 22:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uLyItkrc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E1E22DFB3
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509840; cv=none; b=f25sFb3YQrKUCWr3gZ9UjW8OO8zEa4MEYcmAsFtpGmsmAc12ynS6vCNPKWDijhkWXmJdfoxONxot+8bcIKpi53zuckaumOAPuksLLehC4tB7WLhy4rVWs4CrSJZIzrNNj7s7N+JGBdQW5KjAznXcaj/EqguD/JLWrGby7Cd63pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509840; c=relaxed/simple;
	bh=pF8+ThVAga4TNz5edervhz2zhU7Xp4e4IiWK70PBm8Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=df7b3ICJiAKfOFqdCYja2ss/VfzCL7ZF/bcP0e+ZkUBlptkQ1TYJwvFLxhLNXJIKjNWCDGVCTWgquGmwr2ZQuxEGLS8+QbS0h4bu6LVu9lV1+wMkdfqto9oCoxFu/DPl3QABYQq0Z4DLmlAT3y9a3CRkpDTRzCTxWWXg1meM5R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uLyItkrc; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2260c91576aso24280915ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509838; x=1743114638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3u7WNnidYvKn4+ZIVZ2UCzTlyZ6yVz/ThCJ+k4BRWTw=;
        b=uLyItkrcunqrvgBn+XvdqtUWVRuzEwS/92EE5KqeSIRlpAGXau+yqBAetvRVw3exCP
         lhicq4WtlZKv7ws4uPs1RsigXohCNniBVSh3u83diYanO65UeaEGC4WCquU1U9vhMN9l
         0zmU9L+C/8q3+UdZtXA7T4hTwvU1CkqFWyJAPkfVlXrxgJRvn5JNOPUWo4m9crVf7a7c
         hhnxCRiuKriqIu3bGCvJEdbqHxJOCCw5ZxIQsK/bxM88dSleEyglBvG1xxwc/yA2Najn
         vZWNOguRxzF8OplmXBddwUmhy7uj+RtiyGCmEjTVx4F7CONEc7WppMj/97CSGSsjL7VD
         WG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509838; x=1743114638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3u7WNnidYvKn4+ZIVZ2UCzTlyZ6yVz/ThCJ+k4BRWTw=;
        b=Ct/tW3EsD5W7uqw7gr7qjXl2JGC0xpipHLOtLdZCysfK6hCaH//T3zH2iAetlR+WQ5
         iBvDfHttAfZKYvEU6beraSK80dJLkHuhmlMigIUL394UzmgQOWwMfJuoidKgNRB3xdt5
         TILL7l/IsvVo2MLpGFwT8m81ivnLNuJkRo+xzygHVXJ93TBgWW+4Sib8EXEZuaGnFZSV
         2lPn08v2VUcSVxkgMTtm983LtU+jSRWwbaiPt69KoEvfRrUaJYXWNAijr2KnR5EKDMyn
         h2RKGFPOxmbDTvO0nzCeRRatg/M6HlPGqSmyc+3YgSCVS3s+Gz8OC/NnLgx+VSzPJwJY
         IhNg==
X-Gm-Message-State: AOJu0YwECk4mF2PNXxZvkjy0JHMUV3Qms/FUZWSIL7eRYt9uwcbT/u5f
	HmwxcwKvR1UmIMBMd/pUTA7J0aSS4e4nYUWKx/hBYQozWCNVeCl4Lt11PnZKP7iUa2qEDcLzRO0
	K
X-Gm-Gg: ASbGnctwBicHXGk2qfvC3r6PjpxTZK1PWfni/KaeZ0Nbx0HqRFD101LPuHdn91t1i+q
	ie/5PjcTDgK6sgw8OL8r4cZxfs/074NYO2qMBhnitVHxw7ISja2hzyjrFRzZXfpdk5kLAPskQJm
	KiC5fsUCwbrZLOugozmVJd9iU9Qy1Gn7NDSiyJulP4QLuhvRyj/FRjIguBD8fHrjFdKLk7oCR+x
	DHI7axhkqw07ZJI28Eu22FoWbgCGdgQjfvy3TPxfBv/cBVTLJOLX+t9J584U1SX+tH/urRA28mP
	R2lAThyaA22dnKmfDBalUepNF/AnAe+qX78CqxA2k390
X-Google-Smtp-Source: AGHT+IGuUar1bydPBfvUd3+IX5uuws7MRKeT3al1KpzBmkZ8QvPpHkZpK7kYl35m+krx05UHzx9n+A==
X-Received: by 2002:a17:902:ea07:b0:220:ca08:8986 with SMTP id d9443c01a7336-22780d828c4mr18233965ad.22.1742509838031;
        Thu, 20 Mar 2025 15:30:38 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:37 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 27/30] hw/arm/digic_boards: prepare compilation unit to be common
Date: Thu, 20 Mar 2025 15:29:59 -0700
Message-Id: <20250320223002.2915728-28-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/arm/digic_boards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/arm/digic_boards.c b/hw/arm/digic_boards.c
index 2492fafeb85..466b8b84c0e 100644
--- a/hw/arm/digic_boards.c
+++ b/hw/arm/digic_boards.c
@@ -80,7 +80,7 @@ static void digic4_board_init(MachineState *machine, DigicBoard *board)
 static void digic_load_rom(DigicState *s, hwaddr addr,
                            hwaddr max_size, const char *filename)
 {
-    target_long rom_size;
+    ssize_t rom_size;
 
     if (qtest_enabled()) {
         /* qtest runs no code so don't attempt a ROM load which
-- 
2.39.5


