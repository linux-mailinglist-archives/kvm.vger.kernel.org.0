Return-Path: <kvm+bounces-41916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F303A6E915
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CF49168F41
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA611F37DA;
	Tue, 25 Mar 2025 04:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nwl+IuWI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A891F3B93
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878788; cv=none; b=cY3bG62ncw2ksK9i2IkTZPbqRo0A1qJtViD0H4xQHVmRgOvkMUnjXo+mVjLiDnfGKPCztDcWiHloPA5F79iL7tMD20MsbMjQ3OW66lzbWjTMNTS2RmdZC9/DgGsH9qM02Yh+o/3U3U5l5ctRXYbZMuD9fbQybZcI31dnX7oYLSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878788; c=relaxed/simple;
	bh=RTnbDBhVNCLf8WLSJioy4qH8x2QFpvPxHxVTTYCvbMc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HuV9xJn0T6byU34y2z0QP8HgYS7TlGfdJlA/ADtcsAmmsOX0By3VwpMbSQRVF68gFWHqFSZ8iwLuh1RUBK7xF8/kaulKZmFLynQSl/GPzK2P0Nz+ZwADBTzGJFNhlhwCb/nobo9FJRE7gnyTnnIOmc+2PRoiqX7uqIWuCTEAwcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nwl+IuWI; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3015001f862so6434848a91.3
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878786; x=1743483586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oMLogjQnjMTWhIeJ1ZbndYnRq86dbBuVmVnxwVyz8FM=;
        b=nwl+IuWIOt5LJag1AyiMHikJvDLfrYE9MTZBeVAPuqd+Icu/iKNU7gK/Uej2oO8QZx
         yfH+uLcxT1u1NsfPHHv8Eex9iRfwn04ZUNzlUCrRT3kt2UEfVWLbDBnZkWCdPXE3ROPK
         2QIHsDOkQIfzBlrbYgdMFSraBJs/8ucSYwPQV2lvVdorhCAk4qssi+zLdjd9gUoJvuw8
         t9zZ56VatR6moqEd5JH8anN93rC5kIA91HA8IyJ/nxKiac2cArtwu8t+qCB/x91Srka+
         xnd9qlmGIGwNDOjdoJFyc6FChfPLqGPGrOAROgcKLLxuGy2bPtZkvZ2oUCc4oTrYcfAo
         2RjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878786; x=1743483586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oMLogjQnjMTWhIeJ1ZbndYnRq86dbBuVmVnxwVyz8FM=;
        b=f93EgDh1ZQwqZM+0sOtr2uTYJPbksEHOr/ghDfGLdnZ6WA9SB4MlDCzVYRpZVoC/oJ
         7uPC9Gn9V8XflBotOlT9L+SdybWA7SeDrMNEoofI+wfCSICgg+LNtUfjKaeB77Vlu+1o
         9XP91JeQP7vYX6kK82jNSQNuf7kzPfFMeWz1o3NeQC0f5XNjPJJkNZyiF+0sPO+W+R6N
         9hzxb8RDaq7cDwqkwzdN7t15/d2uFxRM7/b6NxR6bwuYyb6iKmVUaE3+UL+NideN8FJY
         tcE/7gw0NtPC8Ic1gv4Wfz9gnSoAao6gn2i2d4dBysjTTUyX4PGiGltjkHfIWE622YAl
         jOcw==
X-Forwarded-Encrypted: i=1; AJvYcCULPs8VpQyyHDpTsTYGzMGJWSMELc6rvmzeLlzbUSGhDFwgTpweZ2O+TX2fWCZMtj399wc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHWtwzKUEV/eZzJ8M8wxHmkhnZuNk9hioQxuq+dpOh4Z/4AyQq
	8Sy9vn0+ggaW+5kKS/zs2G9om1P5t5GUKpIzNxD1+yD6Qy2pd7wBSSzfAxr3yTs=
X-Gm-Gg: ASbGnct8+3NNfSK8o7KA6m/7pM/D4G9ur6kUQRwIWyelOY3WsqpzbDji/TTtgDjmLt1
	869DqXOBSfICJdPWDfAeuq2R4k1zzN2aiu32ts4on29kw+X953fqHm4Tt2J1Fz79H+q9lCG8Xjn
	C+c6/XDbU5lrX7MlAqHFij2t0+vDyQEDRa4koBD60remhdosvTIL8gpSemQFnwBMpzqF8kDKxZF
	uOHX9WuQPc08bTMTxBi24XwL4/znZElVbBk8erJk0phtGyfaDH3y8FhU+DJxpMetE4O3G/C8IxU
	Y1aSpfmH1o6EIvAdAMMYTk4ojccwgsiibpGMas+hsRSi
X-Google-Smtp-Source: AGHT+IG977/lluj6yGR5rtQmZPGYD//iaXHpiRPYTxrl/P6YCxp2pH/gKGqlEoMf8j4GBUIV0AflTA==
X-Received: by 2002:a17:90b:2647:b0:2fe:8902:9ecd with SMTP id 98e67ed59e1d1-3030fe7223bmr23232830a91.1.1742878786330;
        Mon, 24 Mar 2025 21:59:46 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:45 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 26/29] hw/arm/digic_boards: prepare compilation unit to be common
Date: Mon, 24 Mar 2025 21:59:11 -0700
Message-Id: <20250325045915.994760-27-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
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


