Return-Path: <kvm+bounces-45311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC11AA8403
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:31:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B13993A55D8
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC9719CC2E;
	Sun,  4 May 2025 05:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dSOvm2Qa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB2219D093
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336579; cv=none; b=nra8RRYSS3THCPqGvQOEs0ffn/QQc0Gkj9XRhVmEXhMaoDLlAAW1Aq7ctxBupeH15vtbk3kReqRslfx7b0Ny5L639UGlXWXOSSH4MvYVf+HrEvN0td0WEydOSnHZrUgygJjxfzw3o5UfLU9Pb4wDL6YobMeDazUcul/tL9LXp08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336579; c=relaxed/simple;
	bh=6eg1WWrFLrfY5Gs8TGczDifr0kodUvtUH3+j4IU8lnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IAQ/FCJqJQgRo+RAnOoqLONpPh1vj2zYX6E82ujsUMki3Mt19IvK13TyDiKf5yeSr4SZOOJcPg89KJN23UeMfVieFMlWoAJ4JqYeKmZwZuNxAfsMumUJ3SxJzC7mrCUv+5y1RIskpqifjBl/OB2K8li22cJg4Oq1RlIBirN+vNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dSOvm2Qa; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-73c17c770a7so4872021b3a.2
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336577; x=1746941377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgL5ekQCPVNJfHfcPabdFrIvM+ux1exN882JD3eB0JI=;
        b=dSOvm2QauEV/M8wokNJh/ARHWIqEIk0sPiIDleXo5FP62Lp+NxNKNwLfOU/wLCk/yU
         C4nhLHMT7u0zs3+XM5XG5CxZ5VDjdZdm705j2SUBlUH93NA/+fUm1eNRQBMBUsbeE4Cy
         W9PPuohOQ6bqrHXprapxDNCV4JLPvP/5nTHUnKwGS+VjqMEkMKgYoGsMakssgAnRjOFo
         BX7LhIikX/2q3PxQ/luiJ2qu0DnLQ7NJLPnR7WyqVMRSpT/eMaaOmV84mJuOp+yxUvYK
         8KG4T+2A+6SRHVEPEMxhY4hZzQ+VuQlhLXKMXo+xMnlp6HwoO2+fIEUiPzzAY+xjieFz
         HXSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336577; x=1746941377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgL5ekQCPVNJfHfcPabdFrIvM+ux1exN882JD3eB0JI=;
        b=LNLcDX+9SKKwzTaDyGZFyVwF/uWjQyxfHpy/yJjtxVr1EeAoZa/B9JNHoOPsujywFn
         NI1sa9f+57mUiI+o4avHvxGcIAVHTisVaqkbGOU/ZO8bJZgcJ6xQkKtWcRnssMzTFwWH
         oJXpxMWj9BBMGdCzR0GLeILh0BSNYwcdqIq+jdrpiIKiz1MpcERJ6+ev1JHnpGPUrEC/
         84YGQq8dJgsmqe63XLP+SsnceDXi3C01g0nHbnGqeqdIiYHpWSW5JSMiH3QcbSlzkZNz
         MrBCPTxiDMtHVey24+NpYH7NKpIiaQQcmgsXEEF/O/PtY+8aYENP6TObzvcDWy/CUHqj
         f1tg==
X-Forwarded-Encrypted: i=1; AJvYcCXEvJvkht4kyfFSiCjn84CNLW79BzTWL4ievZKiSLBRW6KDcFRgqrjt7ndLJxwmvOUj1cc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiZhaxYi2x8QOEtWFA5DegpgG8m7Z6GiSgw7NCdfdtZXzmmF6A
	XziTSs3d860hQQoq+IaydIBYM3VVl9OmmfDr+WbrIztB6LzbltEpAkrOzGzXOyo=
X-Gm-Gg: ASbGncvcsvdOYvEJ3aYsPDwph0i/jJaGY3ylDBcSfSKAlEorR0NE5NkKIFJOpOOdjiG
	lO+LI2NhO4MVOWXS2AE5B0NAw1VXDCYDwVmhYEw9aA3Fg9WsDfCxO5njRiPg5p6wC40Hrd/30bo
	rt0fZKFajVQTrKYpVycxtNH5g9aaezjROmQKBtnm348S1HcmZpleH38JEPh6ASxMb7B2ocBZcyE
	/qYu6+WdzOzaHrTWYPxTLSUpyAEifeiz4/l+A9cJRAcsMiUGiETPCuSbMnst5gm1pabwdjgCSd6
	Fp1vNltyUgJmDY57MGTOCse0s5lB23cDm9k+y8U/
X-Google-Smtp-Source: AGHT+IG0fiHww8wHentCcO+BRbRdEEXumZMr2eqE2gcWz+lyA3vsJ3lxTr49JaERvR9Gf/hYkM+otg==
X-Received: by 2002:a05:6a00:2987:b0:740:5927:bb8b with SMTP id d2e1a72fcca58-7406ed59ab5mr4309964b3a.0.1746336577027;
        Sat, 03 May 2025 22:29:37 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:36 -0700 (PDT)
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
Subject: [PATCH v4 19/40] target/arm/debug_helper: remove target_ulong
Date: Sat,  3 May 2025 22:28:53 -0700
Message-ID: <20250504052914.3525365-20-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
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
index 357bc2141ae..50ef5618f51 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -381,7 +381,7 @@ bool arm_debug_check_breakpoint(CPUState *cs)
 {
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
-    target_ulong pc;
+    vaddr pc;
     int n;
 
     /*
-- 
2.47.2


