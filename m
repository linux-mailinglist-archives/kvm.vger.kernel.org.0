Return-Path: <kvm+bounces-45783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 340DFAAEF69
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2B9317A7F3
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD92C2920A4;
	Wed,  7 May 2025 23:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="usxDCtG8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82A22920B1
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661381; cv=none; b=np5Zs7GI1CDgQuSyYaJNz7uBz4QS3KUcyefqs5sYh2pe5QFXr5Xx76BDoDT4SvkHe6veiQoxiuGSt6t4Oxoy0XnAS6jH7NQ/deHJZJtPq1v+Dg4xROb5x4+8ELWmmEsTj5uwC3B9nzCNQxppEjaXipKgDqkiiIhHwVc2NIbxEPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661381; c=relaxed/simple;
	bh=7jxBB/VVdfOQHPcM76kxx9YqgtWj7JRfQb70xfNgVR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YlL8zLmv6/fpIZ0UV9HQiCEHTPxab1KfnZNBWU4IfkxDeuxI4mMGEY9Tis8D7oqXQiAeNgwJr4JRc5nCbAqFuXUBUiraLD9iBNbJLdL/eDYrWKV3CaFX+15GxNd40tCGDRu6a2ZDgKtAPAXmYtcJLYSaE74F+9q+1JcGVzh+h0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=usxDCtG8; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22e76850b80so3228325ad.1
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661379; x=1747266179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgtSyivanfJoltGbQqPmVVFicsFn6el5hIn8rUX6RjU=;
        b=usxDCtG8Rb3/N/DBpcarXnkyGMq3SLr84MjZRGUWh1gstICTeZCydT2QeLKEiK3Xtb
         Proe5QCtnivEcQqa0DQmWnZYX8owEeX9IRbA+vn4ZWb0Myl0VR87WBDMNAWsmyj8ELag
         4o0hiSfMIfPDcnLRfQPDMHMnNORrUlvLosV7yNH/EfsdCnIhrEcz3lGwJfQhyIM9j65/
         A2ssmvfK1pDYYiwtPr6oukptqUycISiZn1q5+iFBYoCL+ZzxQlY0yLjGd3CumtuUmOlD
         v53lZn5wJri1oCVKFBYTbNa/iLItYTZM3FEyjPiQdcJzRGADwCTVjBL+Klp010IYoJj4
         2wKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661379; x=1747266179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgtSyivanfJoltGbQqPmVVFicsFn6el5hIn8rUX6RjU=;
        b=cc6IWumouIoCD6kYQRACfDRGzaZqaFKgcJyZx4PYRBRico1hUnjPI7abZUMj7Zy4PF
         f8s5hTpEmFv46k/lYpvHNFeYEoKfIMOsLx0nB+n1LsuPPm5ZiUJlIUEXrDzN1MXlzs+Z
         vQX3foX2mxuHrQd2Cclsg3vc2xfy6xaG5MQDJBcRo0RPQorcJ7UX+/rYM4fhfrH4OZ/P
         qu0aAiTUVlDKpumkDqTdhlRIfAqmtK6lry0539vwJrEDEs/KAElxutZQ4jvUjZsiOeI2
         esvmNUfuBaxJpSNUPFsfVdzHwBX6t5KcqDDT/dw760COV1PNe+gO0wzxL2Ah1lXkB5JR
         w7Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXxcI3VDwKyJu/K83yESGY/jaaA0wrKQHufjabvfoVIL/rBP6wnTNKxgDCwi7yex5oUYI4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz34E+wzYKVAsItII4DHgphjx7lsLQcoHWlBtx5+FrYLFvw0tbJ
	Qf3pKbagPEwoT/7zSdlsCPELcv4de6YqluHPM9CiySnB8k2V1KaqafRKYU4a218=
X-Gm-Gg: ASbGncv6BpSf4vkmM6o1ypjI0vLHoBOX8XeDDxYstSEKpht0jmtFfwDOTV0MIgqY5ci
	QlLQfB9s3lrlju+gllgtJaxUDkWs1GSa/Q6cn3d+ffMyGBGnxoX5oqAfcpWLpcOggORLWTOdGPG
	F5k7Sno1IQaM0H1qNK7/CBaNg8n1gXcjE/Y5EyptcdFMHf6VjDky7p6n3nADLmBeBTD1bFnESrs
	k29BhnwnNcyiGpqOFGyhzvUeaPDCwF4QeV+4oG76Fdfbvgb0uC+V1Xvi0dj2vrvd39K7/szD4g5
	JvasVJin1yqTjOsxzSDbH4QaGb6bGqO7DIbTXXC1
X-Google-Smtp-Source: AGHT+IFZtlB2FlSxHJFsDXQB3WyDA4iBd5Ccf1T5vX11nbBzlbCtPEp6lNvox6Ap3RnU2n0tDbAJyA==
X-Received: by 2002:a17:902:d4cc:b0:223:325c:89de with SMTP id d9443c01a7336-22e856138c1mr20153195ad.1.1746661379102;
        Wed, 07 May 2025 16:42:59 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:58 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 18/49] target/arm/debug_helper: remove target_ulong
Date: Wed,  7 May 2025 16:42:09 -0700
Message-ID: <20250507234241.957746-19-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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


