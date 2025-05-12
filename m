Return-Path: <kvm+bounces-46217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABEF5AB4240
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:20:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 877BC3BE8A0
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 736912BEC34;
	Mon, 12 May 2025 18:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DoDpfOl/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11750297A7D
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073129; cv=none; b=IZCoAxdXGzbCAiu7aOa5dq3sHy40i94UKJqrBMEdkMWx1VAKZPGKNlBrla7YINHqLu9DmYDSVluICe8nGgqoUYzun1rlVcGQBaQsxz67efk2gWbFahL2r17m7IDDmZJDUyPrjJr2eqmUAROBS9NVo+KKGexKnN+VnDI1UeANSjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073129; c=relaxed/simple;
	bh=7jxBB/VVdfOQHPcM76kxx9YqgtWj7JRfQb70xfNgVR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qYiRAiw1UqGZ/aZc7f+pQQzu0esqdTchlU0hG77lmKuLATUBb9In/t4PGTPY4iCRzm91mfRxl3dgXiVsk2PtejSmUzrfdRYvQqvWVnrfMMWrAwCOe8HoRUFmAqDVwbhxCN2U86ZAvAn+aWiAI8jCjr3+ia67OJ/2GnWoApOaEGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DoDpfOl/; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-22e6344326dso48591165ad.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073127; x=1747677927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgtSyivanfJoltGbQqPmVVFicsFn6el5hIn8rUX6RjU=;
        b=DoDpfOl/hu3Ynkr7xWPNMTtetn1ltnzDPzmArv8LtdlvhuCzWp3ygaxrxZBFlLF/Ml
         6Mjc8gfZZoA/1DvNCRIm2B0zNFIJqjherwW0cWf3p/qMtS7/SlZ/lxXd2RlzAQwbf82u
         YEJWvqIJf8jBOb1h8sNRJMZRjs9Uin8bdC6Zz8+F3IyFNbnYD4D9jHXSpqqdzm4abFH7
         HiIS9b/Dk3OtvEtzitl14RROO4u9CXAxm4TAGrxEFDOJ47wSilVMTLIr4ofaSFYEZc8y
         ExQMj5mNYtgRnLrTYjxA/W5BqFF4lctpsPrBkbDO0Atf5V0ZQSmwqk/6O/nKPlcJ4kaw
         JlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073127; x=1747677927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgtSyivanfJoltGbQqPmVVFicsFn6el5hIn8rUX6RjU=;
        b=Xb3Qr52MXJp7p3nkJWdlNWHsFiK6LYy4vX53ZMycHf4Kf/dWzSM4uS4vZ2mcH02OaM
         Bc4uNsL3s0udk8JNyZI+oarWNbM9cn3/JqaTjLmzvjGeXnS7mUWWwt0//eGUS+dnS4PR
         gnuxirnizHiZvV5gUtP74zCP5F5az5VjaIedtQJs1qrvtBvYV71xpwQ1SrVhNvdJp98o
         CyW7Oi4WtN9QfroF94vnJOJwSR6TrLSigmyMZTMgA4XZiUwLGh5CsHRBDKBQcAhNB8JZ
         5BOmjO+V0S7txwTUdce6gKNdMddPfHAm6fbVzeBi7n5DiEgxE0vt3e0dFfMb8mTm23VM
         Sprw==
X-Forwarded-Encrypted: i=1; AJvYcCUxouNrG01VmPmmWb0yMlrlBfM7R5j41iz1F+QiqRIDjE49xkvkA2tC8EKZEbyw3g9gJp8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPSV6b/j6E6XyV+zkFawQ3oh7ZuXm3KjraA1k66YPUfRpUThHC
	TFu9ox0UcPxhJ1Jz40LYp3vIxTCvLB4FFQOOnLo+v/HWYUKL5qA+pGPHiS7mamg=
X-Gm-Gg: ASbGncsNCtOd6qyS7c9kdxBiDw/FlWE89dSEK0Etigj8RijHuLZ0ucmOep+N3dFMX9G
	ejF9gDRBbjxe2FHY0fe+pDpnGTvvpTx21EujyeVnFFWIBQRCdGaCtB/SJA4w9k52xC4yuOrLKCY
	VZDGGLARL/OU9RSp8cUNxoBI8/ZfwgWQkftL5G0hjdFn0JEWTVGtnED2Xq3rDU8fPv6Bye+UpTP
	OJcjNMmuw4Iu7QUL2nNPuvqSRBAVIAj4t5r2amlfY+kl8ljPAJtjrCs9reVWGIu+kEHevZdGMR/
	r1xj0KL/E6LS+Gu54fVJcUYQQhetrsyt5XMOlpZ9meWaYiBWFfU=
X-Google-Smtp-Source: AGHT+IFPFtd54s+F2aR6e/s2yggvKE9L9W2oRHkbhnFg6B45F2gxHU/Non/U4k/+HSNVb7YPTjYCXA==
X-Received: by 2002:a17:902:d581:b0:223:3b76:4e22 with SMTP id d9443c01a7336-22fc8b0b618mr179655835ad.6.1747073127211;
        Mon, 12 May 2025 11:05:27 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:26 -0700 (PDT)
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
Subject: [PATCH v8 17/48] target/arm/debug_helper: remove target_ulong
Date: Mon, 12 May 2025 11:04:31 -0700
Message-ID: <20250512180502.2395029-18-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/debug_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
index cad0a5db707..69fb1d0d9ff 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -380,7 +380,7 @@ bool arm_debug_check_breakpoint(CPUState *cs)
 {
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
-    target_ulong pc;
+    vaddr pc;
     int n;
 
     /*
-- 
2.47.2


