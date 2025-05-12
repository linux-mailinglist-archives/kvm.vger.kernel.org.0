Return-Path: <kvm+bounces-46232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51729AB426B
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48B973A867F
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FCE12C0859;
	Mon, 12 May 2025 18:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e64oKVOh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDFD2C033B
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073142; cv=none; b=lAuhuAaU1geHTNIMaOcMp4IQLff1YcjEkstrGEbuG73feXOeZ/ddIthGipjnKJFmXAQvbKnID1MRp2a4SY+1OAbJXt/FpCzIer62cPaDDSEx0MUeNdL9kCdql5NYHk+gDf22L2bAhabjO2Hb7Fw/2seltyKCUZwag0ao6PRGIVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073142; c=relaxed/simple;
	bh=ENP2hN0JkLSGgU+MLNHwU2T/tGgXwB94KuX7uaX3DAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1UIm3575xtgTHnk4UiseoQyEIoMhSQbCZ9/dulonbqmGct74FjbLFzYxaIz6eV2OfgFK8NeEjHNQEM0c3Vac3nFCBWLCHM+wD3fK/CODGfwOYuw8wPhb9dcx8eH0dNpYVNMMVaxnVbAyhKsrvJQsyPNCXyNmLLCPW6a1uRigYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e64oKVOh; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22e70a9c6bdso66817785ad.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073139; x=1747677939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E27VnLHwdjjgu7+qzkSpdD6sP1u8J5fzfB0GITxze0s=;
        b=e64oKVOhPBq4IqKFH1baORhO1MT1mHaSaUDYThfxNNNsvEtZEiSMYzzG9BKIAwKo6y
         81pDzTrakg8gEXKiqoIvFiYoNCs61jG961hluaQb5fOfXdmvyf+tN3VLdlgfzFiPWjTz
         dBfPZoM+0Aj+G9IUImUYfEEIp3lr+LrOMdPVj6wmWziDNcA2MMe6ADhdbVR4Bcf2m8If
         KtVq8ZNUerlr8WC6kYwtCVWjYxEbIPtvYnmBUPfllILvoFadBzP7fUov1+/H79+L+zyK
         Sg3KDFmwvH0e8JxoH+m9Z3+RpasdiQAymjontZgF0M+ItfGIfrym0NKdyaaBhb6jdtfX
         hCEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073139; x=1747677939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E27VnLHwdjjgu7+qzkSpdD6sP1u8J5fzfB0GITxze0s=;
        b=D9cK7tdMDhOmQb7BzP3xFDGZS+RUiVjL8U9Iv7vx0zAL90P8S0KIBgh2QNHON4uCf1
         IEhASAsMkzrRZFkEzRHIxSliWIbVc4MzKB8nVGtCm31K0HpkqINkzfo4OV4geQwjVF50
         VaBjfVeGidL7BsKKe7KNpDDLZR+YOVBjrUaiLqSLyqzjbT0kzDzkCEJAwHBGsBB8+wlM
         BL/EdujsODIPqgzg4CBxpTCrjgyR9IhSbAhMCIbUij46r/Yqxra4gBEXGaNliDp/jOeI
         ptcBqKnTjTG0aDutXXf1K9me2oTpvM/GvLcDwVR4OgLRyAQQz2KMgquKsLImLK+ZVNQ4
         HAbg==
X-Forwarded-Encrypted: i=1; AJvYcCX2QdNPQX/0468wooSsC9/TcEWc2NOAyXp6tckErWiRdfxw0tDZ1+OfKqWGTyfLSPV79CA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKZDoJ/FBL9QawIjykCAVGC5wFRi4ss7/hrMYpAotrMyZ38eu8
	jZtOXl8RY6c6xz6XJhHxh+xEqfxHZJOweFD9/yKdDNBqsHbMeXTgty1/GQaE/Do=
X-Gm-Gg: ASbGncstexxMaYDRGX/92FJddONtGqTLHzz/09wOQD/3/jq7NBhcQyTdf4qbm0Lacf9
	/5mnnpyk0EGZahpLoIQOmYypa5rQL/zS5gWvm8jNvzz49buXsztkIX/hOutEhTaRsJXtJcFnYG2
	eMzD62MtEPbygmluI1liAEo3BFxMh0DnEq52LmT+zMzN5Ye+3/ZURkKq1K4p+4da8sybkX6CkXj
	IjWEv/qjLE1qJ2ttWI5OjWXvsXvdykRcmNJmlQ0BykXPwrMNkLaBb4HRBrE7OckWVrebM7NRpkA
	bjrGRD3rYwL6HRBAerOXbREPiMmdmAPTJUvF56Ooly6YdJMQYXc=
X-Google-Smtp-Source: AGHT+IGDbYE3NZddHMNtkgUSWM+p6EAgBZsVoXhpxs4UoNfVW5VcAewVjNOY1zxjElB4McK2iuAKUw==
X-Received: by 2002:a17:903:98c:b0:22f:9f6a:7cf with SMTP id d9443c01a7336-22fc91a8c92mr188938405ad.52.1747073139445;
        Mon, 12 May 2025 11:05:39 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:39 -0700 (PDT)
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
Subject: [PATCH v8 31/48] target/arm/ptw: compile file once (system)
Date: Mon, 12 May 2025 11:04:45 -0700
Message-ID: <20250512180502.2395029-32-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 6e0327b6f5b..151184da71c 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -17,7 +17,6 @@ arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
-  'ptw.c',
 ))
 
 arm_user_ss = ss.source_set()
@@ -40,6 +39,7 @@ arm_common_system_ss.add(files(
   'cortex-regs.c',
   'debug_helper.c',
   'helper.c',
+  'ptw.c',
   'vfp_fpscr.c',
 ))
 
-- 
2.47.2


