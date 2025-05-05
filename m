Return-Path: <kvm+bounces-45510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E642FAAB059
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC8737BD14F
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B407306712;
	Mon,  5 May 2025 23:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f+spdJ2C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7826B3B2F51
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487252; cv=none; b=qoMHf1I1ltZnYZ1rNSQpSm+e2SI3f6K95RzdE1q721RtTwTaERsFafw8noQ7gKHvO/QMlkH07s6mkiZe/Kp4Kkubyxtk6ZA+N5ng4/lEVIm92qOP2ruVsSoXFh3Z1b9bRuiEcKyQ7PbQ/FbhMbMiVP4hSV6MPQgkwsqbKD8cDcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487252; c=relaxed/simple;
	bh=TacGw74bZNQyeDYcxCVjx5Ct3QHr5xUBU58fynumMKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKFKv3uW+w0T8MZcuuFW4kDg1orVG1qoKW21dS5+XpIqxnERoOR48AsmCpUHSPwPsuG62L0bF9iHfKB6aYzr5gu5+BWsLra6yzO9xbsXk/D48TefQqjblq6YDSG4KLJUZV4u3hczkBOEXIVRjf2LuN5vgF5Z8mx7TteZCw0mGn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f+spdJ2C; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-223fb0f619dso59394805ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487249; x=1747092049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JUmj3qtC0Uxjt25GgPIz4kBx9RjJCUcgOSDgbgc2pqU=;
        b=f+spdJ2CzIhhYxbKFUdeBTJ70EBncEgy0ADYK9JKiHPUC1sVKYIsweFCs0hplR+wbJ
         pgtgDDb0f0Vf63uoRe/3fnwg+qg530hzfbH1xy2vMJsGTqnSfmYCVPTu1OSOkzPNim0R
         2gnRSWJ4X15WmolcLHfkdoB0Xd8yuy8xSX0s42qYjKW//5/SUOYQUTBdOykXPbiVc4i1
         5PfRDcASF+RYmhItw8pXf2B3xAKuHeLzFjbBoVy66LHJeWixaYceZmvkjdYJDeTnNOSk
         Xs4Gxlk1+UTcCoQ+cjyCMkP/cmnJFGIDv0BLLkVgghJx+FeUNhzyGDzG0LICT/tggrqF
         64Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487249; x=1747092049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JUmj3qtC0Uxjt25GgPIz4kBx9RjJCUcgOSDgbgc2pqU=;
        b=RuELGEqjzmCwupvS4hqHxurFTHRteO0txrzEOqUd227vXwj58FAcEswU/HNc8vFrjS
         GrKM1wlTx0IvIAsSnln+zxWR2RykgW+hXE0wYaIGN02n1nRcxYTXRMIdtOBKsLyNyEll
         thfsf+PzQqBfS2aHDqz8PLoB29DC6br4FgzYlciLKxtgXcUelIgblRH6hXAamKSsZdp+
         uzSq+O6g5mVqbANVMUAZ6szxWaOcVmBnCCzi+osT2zdW9aeqSf41rUKov7BHG4Lp4QbQ
         urNdZdCxH9z6di/ia1npsLChAf2RGbJ3idga3qcUivLuTIpRMjgLo4L5uB8os5L3Ppyx
         LMKA==
X-Forwarded-Encrypted: i=1; AJvYcCXyA8ELXY5xQ4MSEdia/sekS3pyDDG5thdRcqc1mEoHj3AxCJoPCWrYrRH/9Mve7PZIddo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl56LbuEp4uq++jM7PeDsghH5+ME1hWnJUchNg34Sm3c1l7jcZ
	JCuiIC6SeNfiRnO4YGETkiha3Dxai10fe5nnj4seZPvGl/Rad4b7CovI5HAuTc4=
X-Gm-Gg: ASbGncvbceBrY7+/KWXTL0TKrvseArkFDBEPhumsc2j89kiBLuH9cIpSLC/yEiizIIM
	B7G+EJpYV8145dVjVLNQQ9otkvYvZJ08VS+PyqCUA/yk5yUfyh6wQWyuzriyAbikgoTCwPGaO4J
	ZWzRZZc3yqhd9hp+b3igyLkCzE9AfqWeR1J0TMrzcxCU81IWwgXDnnt+FTtjcDEfuuOoOGxZ/V7
	dGHgnUcOYwRcvjn++YzU79logGJSVVmI5l+wXFOlF0I45rm0y4Y3S0R3OP/Vlw0JVyiyoDAfqw1
	GxZ2AXPpUYVK8h5lhNMxzx465MgsuDN19vNBOyroMen8GsL2Tfk=
X-Google-Smtp-Source: AGHT+IHvuVTEdPuucnAVpdGG4ydIM8fLCmaTsPKggUPfKTAS4sZirTPdaGSJrLHEw92uhuxYwBNlUA==
X-Received: by 2002:a17:902:ef43:b0:221:7eae:163b with SMTP id d9443c01a7336-22e1037ecb5mr223727865ad.46.1746487248943;
        Mon, 05 May 2025 16:20:48 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:48 -0700 (PDT)
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
Subject: [PATCH v6 32/50] target/arm/ptw: replace TARGET_AARCH64 by CONFIG_ATOMIC64 from arm_casq_ptw
Date: Mon,  5 May 2025 16:19:57 -0700
Message-ID: <20250505232015.130990-33-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
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
index 26c52e6b03e..c144516aaba 100644
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


