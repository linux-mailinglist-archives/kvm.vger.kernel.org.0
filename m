Return-Path: <kvm+bounces-46231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23DB2AB424C
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:21:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 682FB1B612CD
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DFF92C033D;
	Mon, 12 May 2025 18:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OQIqSa0g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ECD2C030D
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073140; cv=none; b=rojrr6Y7DywJE6v+NtyqJAPYKk8XWEn08EGIFfn7kF1BJB/GC7/Kzu4LZPsflTnpyge6M1EHSkV7y8NwMt4wS9iW2QQPxtM6s4WQbo0BRf0aZs3FI89V7gZ4kyMBgheXeQ/QnPVdEL26+DxuiaCCvmuNV7Qb8oust3lXb5k2DNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073140; c=relaxed/simple;
	bh=YqO7si6OOlzy9ll+3G2BXeQ1hVT+gQZ2E0kYWTNKBRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAQKbp/na3PcWui1Q8vGr8CMnvlKL+6UAdWBuS75QvJGlKFOS/F4QCngpSDTJapaNa+NglZYkcYeaZz64TDh3YnHjJAVMCUETadD9U/blahzPh7FSUiJfYHOYaYYoykUFnp1aZ5j26Akxcvfd++sbY9IWh+ilpMYkZQkDHQp2Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OQIqSa0g; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22e033a3a07so52650175ad.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073138; x=1747677938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EMEP48GWxCsRSx7QE2iBFebS5MEkI8l2Uk35GcFvWVQ=;
        b=OQIqSa0guDUhunyAWhOlEO/ynh8VjmZWvzrLHVjcaZ3qQ5G8P4e04LGpeSAoa4pUhN
         fDqjX37IdXqpHxGmkYIbwt9/P2TqMnMnAsYpGu3XiZFCFKf8+ykb8wblW+6vzthKg444
         4O7pGxg1DS5Q7BUVckds6NDTrhs4OGoW/fUn77DjMQxTudcoWPNTmvop+d4twCT8Wa0B
         PyjPN2WJN0NvOkrkcWW+DHEH+Y9IujiCtlKPAM03Cz6s2U2eXkIVXVV4bYeQ/2LLVEl8
         Ygnlm+md7GFEgpkmtEa/Upe3v23+RLp9FUrmBmKjOMqKt/hfxDWFCh+0rsR4YSyMBL3i
         0p/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073138; x=1747677938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EMEP48GWxCsRSx7QE2iBFebS5MEkI8l2Uk35GcFvWVQ=;
        b=AJIfEXVzUc7GLThpynSbsK9wFjGRS3Emzk8TgLDZHZx3uBC6DjcvX+4E/Ymq6MWugz
         tmgeRd6yUIOnrh7tog5Du5Vih2C1XkyWhA8+CRW75o/ZXNSGiq+WdU5mPTdlBzlty1/P
         7rCg5JaERyZBCR6UwWsbTa/3kdu5QMMnO9g793hDEaqwiO/XQy93rXvvbTqt2BJsmVK0
         1sXJT9SFhk/W863s5IDPRMI5Rp+OwJ7pA0z2cfk2Joj4FsumhJYvqIIHJIEhHelTa31j
         R20IfjMV8Np27zR1WQCDJRM5D6G0QYdBGRngj1dvCMpgqd4EIgSBW1hBtp65NprtUICw
         f2iA==
X-Forwarded-Encrypted: i=1; AJvYcCWDjCFCpVw0JqZaL+sIsRv5RLdXQT7LBElXoYZiSSDuTh7gzCq/ujBzSyl7PSHDufzDPaY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZK+fyQpMV3SkPQp0tB7yN++hpHWZRa09mi2pDuPkNhauGRW+3
	yZADDXd3cyXUH9Yl+nAiilLUCbfLub+bpTiM52vBJmdEnWG+QT74xWP1gGx2CL0=
X-Gm-Gg: ASbGncvSTFRh9m19QGfaIhZj2pdPH8JYu5G408Q4yiBLsXw1aLsxQGi0wEcWQiyZqrS
	EBZ2piF8PiZHxbTz/FL9F0/5pRUgVlAk1/bIoWaoVaqZbU7DWpiMuKjgCrk47plYhZFYoHjim6l
	coCfhddh3KBUB7ko8gHRMZ5FJP6FLp9KoM2/XWx0KjZNfmw59N850y75ia+hzGNc0DTcQ60Wthg
	2ZilKlRQz55GaQwM+A1i+ciCmi5nyrqcDYCJAO23aQw0Ysk9CooEw8swEI4eCH6xJGn4rHwTM7O
	zkhhcOc3lgBhCB19SLkJVhHX6dkXpfMadv6PPtA9s+GV0cWrO7Y2/xtawj0gsQ==
X-Google-Smtp-Source: AGHT+IGpj+ByGGA6P9uf6PMDolvOaWHxRb5ursUcXrTwGZkqDGtHApsXva51S/fwpSIQmOg1POT4HQ==
X-Received: by 2002:a17:902:ea0c:b0:220:fe50:5b44 with SMTP id d9443c01a7336-22fc8c8ec4bmr205601205ad.31.1747073138576;
        Mon, 12 May 2025 11:05:38 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:38 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 30/48] target/arm/ptw: replace TARGET_AARCH64 by CONFIG_ATOMIC64 from arm_casq_ptw
Date: Mon, 12 May 2025 11:04:44 -0700
Message-ID: <20250512180502.2395029-31-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function needs 64 bit compare exchange, so we hide implementation
for hosts not supporting it (some 32 bit target, which don't run 64 bit
guests anyway).

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/ptw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index 68ec3f5e755..44170d831cc 100644
--- a/target/arm/ptw.c
+++ b/target/arm/ptw.c
@@ -737,7 +737,7 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
                              uint64_t new_val, S1Translate *ptw,
                              ARMMMUFaultInfo *fi)
 {
-#if defined(TARGET_AARCH64) && defined(CONFIG_TCG)
+#if defined(CONFIG_ATOMIC64) && defined(CONFIG_TCG)
     uint64_t cur_val;
     void *host = ptw->out_host;
 
-- 
2.47.2


