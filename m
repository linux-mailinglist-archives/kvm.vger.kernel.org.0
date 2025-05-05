Return-Path: <kvm+bounces-45505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC0A9AAAD54
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:33:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A14B6169A2F
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA2FE28A1EA;
	Mon,  5 May 2025 23:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gauS1V98"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79A02F8BCC
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487250; cv=none; b=EN7VIpVAG+Tusn07X4GYIsHeKdcvfQ68hFkyHZ5Dww5Djgkt4Eq/gcKcONYBP6Qv0u78kSxmasXlIU5czntT0uHkGk1Z4776/QuHgvW94r2sUdZEP3VI/oLwwJIDsK+RnpZZ/Ouetf8T2JiThHhzAgkWAMFvAXt36UFJ6ACOhcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487250; c=relaxed/simple;
	bh=JfZNVY4hxn/F80wsu/sK/tFwdFEqzR06bfiZaB0QHo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n4QbNEUFi/YlDylEjAJSL3Bb5LpbsKIIn8sb44gQytMtMjSMXwowTTU+dWMOSNt7wCht2aOgODRn344+S9eY3VUi84snPHgT8YmwQye/k/nWW2pDApxYXYcUjXDAgBPGinZgfW5Ajqtzft6pBuaXDNq0IXDSmF2Ex97b3DBd4UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gauS1V98; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-224171d6826so73674925ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487248; x=1747092048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEdUza85WO+DzwzEMeWL7z4M0hhaS2RgQrae4P4VTDk=;
        b=gauS1V98LQ/mbTudn0O4s+KLOWzKkUmNZLvvZMi3fV3Zg/wusT/zbfT2nwvK0s957e
         q9EbWBceiuxfqDDI/Rat8W8TiJFpM29QfDJIaR22hg3bTw49/d7NqLAXUAsIGULg/D3z
         bRpe8d3x6rc1J9Y4y4JEyZBLNDuQI0OF/Y7zmbYzxPsdoiMaGm4gFJgDwoTcKst8RaBI
         MBoHT58G63ZK+/1wCazplpwHQ8GYEX4P81B3gxzF91IdqOvJuIjXK+qMIbWFYfyV1oM6
         4/3uptmOt6JMZ8iTK1bH0yN8BCkZxfrA3+zrddbOvPue+LNsI5F8UGI5szy2es1ZOC9h
         pf/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487248; x=1747092048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oEdUza85WO+DzwzEMeWL7z4M0hhaS2RgQrae4P4VTDk=;
        b=c6CdLodQ6qhQEwm0jFMifxrju12pspCEsrOtcoV+WPWcSVD9sHA5BzmI2Z4/NH9c5+
         TurMeHjbhGfDFeVR2k1d0eCC3kVIjx+4qwYplKvFsiV7LbPvPsw4mAjqU3DX83F8kxyF
         5ajsn+vhImRsIH0z3uNU3gpza0oIpT818xCQFCKRRyjWSlsGjEffHGBr/76eI4QPe3d2
         NXLVzBnkLL4lkGPFLodlAHnd9QiyAaza53Q9tWNz0BWuxjm0DofmEaE3TpD4JOAtAOwp
         FTFc2aXjg+lQl8rpqqp7n7PWYChoDygY93hQ/dhFy23FGYcxCGcOKfOm3u88RzciOGqR
         V6vw==
X-Forwarded-Encrypted: i=1; AJvYcCU5kMi5BWuIPQ7pmOcdgDKsvBlSq8zkEfM2jqpT4Qp0MYKFQS8bJfHMuGNs+SAbNDM/PaA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmNkqTr1irhk41J5kBGOBuL+So4UNAZr9hz69UnKVKi+hCUFP8
	6Wg5PJVOzgosFq+c+GYEJ4aqZ8bLy1sAPNRV3uMknGToFnMJocWKIa88d4OZsv0=
X-Gm-Gg: ASbGncuiq3OT0kSe4lPWE+G+AT6bdDJWvgWQO6ElHAkRAqkGviucxVZHvWKWEfJqnhr
	mMuEHCRMlvfZYqJN9wPT7wJx6CczpMA2gPo4s4mKHPkdhvzC4bPKMqGdkgq5UZRMGYYkzdcFWBn
	ebDmvz6VCqE7KOXxZnjsq0U9l0LwSB3IvpoZ6Ajd+BnS8aPxlNcf+16+OXsfYrTpdWZgFHk22Rx
	Hv+bdi2JLfnFd24mKHoTjvouAUL7dvQEZpjuvkoAh8dsRMiUd0niWHOhUmpHmqvpMIZCyYl83f0
	zFe95suHIfTFpNK+pGRLFlnxsC+eELcb2VE1o71e
X-Google-Smtp-Source: AGHT+IG1jiJQxBbzAHV3mqZ6REtUe8lv1QX9zvdPySzs6EmfZn2E2GCfq+CiMq6MLVUXpnJYHzmN+w==
X-Received: by 2002:a17:903:1a8b:b0:224:1acc:14db with SMTP id d9443c01a7336-22e32baa0b1mr16580805ad.29.1746487248068;
        Mon, 05 May 2025 16:20:48 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:47 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 31/50] target/arm/ptw: replace target_ulong with int64_t
Date: Mon,  5 May 2025 16:19:56 -0700
Message-ID: <20250505232015.130990-32-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

sextract64 returns a signed value.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/ptw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index e0e82ae507f..26c52e6b03e 100644
--- a/target/arm/ptw.c
+++ b/target/arm/ptw.c
@@ -1660,7 +1660,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
     uint64_t ttbr;
     hwaddr descaddr, indexmask, indexmask_grainsize;
     uint32_t tableattrs;
-    target_ulong page_size;
+    uint64_t page_size;
     uint64_t attrs;
     int32_t stride;
     int addrsize, inputsize, outputsize;
@@ -1733,7 +1733,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
      * validation to do here.
      */
     if (inputsize < addrsize) {
-        target_ulong top_bits = sextract64(address, inputsize,
+        uint64_t top_bits = sextract64(address, inputsize,
                                            addrsize - inputsize);
         if (-top_bits != param.select) {
             /* The gap between the two regions is a Translation fault */
-- 
2.47.2


