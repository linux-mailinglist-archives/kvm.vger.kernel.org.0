Return-Path: <kvm+bounces-45782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2572AAEF68
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:44:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB6321BA7EAB
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACD32920B7;
	Wed,  7 May 2025 23:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UBOBBMye"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEFC2920A4
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661380; cv=none; b=c+W0NSUY1qA7P6/M2uu1O0sbZAemQM3pjlAnjBZZm2A0ruZbSoTJWTbjhA1EtqumN9UJ+29WLxwNszdRoAVoIj1VPcxPG2jNBNkNsgP0aKC36cbCVkki6vVivUau/87cteKWtldNxCQCvY+W4l0cIRhAABpCHHtDsFEDIoEtGsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661380; c=relaxed/simple;
	bh=E9jacJWcyZhRxtvgQxT+RUKTpQhm1PIlSntRw9cKGQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S208B4fxq20qAHdl5PavdpcUoTprutfHcQQpGYkWqoQWDL6ij4/TWjCsx2ZrrnsiXCSigoLAAedCB9SFoB/NNW1DR8rWGkWiolbad2rXUawODmLesDlcaLPo1AxKDd1A3Ilul8BqZLkLN1miUMbZeX4xB+XePwzUVPpHqUdIDhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UBOBBMye; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22e5df32197so5421075ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661378; x=1747266178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kfHS+52V3f05Qs2m5d7Nh2wTK+yUmoJBcA8DI59GOAc=;
        b=UBOBBMye4ZspDpguaVaAeH3YeJ1+1f/XCYuuZcj7Hkoni8qV+bxADt5UTlYNR5GHNX
         yEidxroqy2skHAaQCLRcmcLMbK2sqd49NCjMcO5OAQywUulRsJVjsJfN8CJJNURKHUgy
         wrx79AFU08t2crDoUFG9J6BnLxtKt2rXa24kmS0tA8nCBMkbVbqjbArzirkFh/z2w4iz
         vYAUha62/Ekjmq21tI6lsTUw3zHRFewiDaB+ros9VtNa/jrhUxmDLWt+M3WjSWyy0ssD
         km77SOS1sND1T+EZIq/+OZ/YHum378Jf8remfEWa3mjSfOmOENjDoInhmDxPZKcIiwm+
         euSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661378; x=1747266178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kfHS+52V3f05Qs2m5d7Nh2wTK+yUmoJBcA8DI59GOAc=;
        b=cvQ6QuaxMDkbZFJ4UNCHuP/WdlFo3tmeOOnTHFZ14Ik4f1yG6PcXPBwHpjD27zG1HF
         bdDjyTj/QiS8WWGPqjufmIkFgB+e0DgFBWVgivMsbD5QLVeKhMcqlzReqT+/HOJfzsms
         ucsg+iGPT8LkUxfXV71sPRpvr/AwAilJx6QCV9A9G/ytBNmYVITcxphx1HfDH70Swzu6
         nzO5MjtgEICrzmAabOTqUFLMeE/zZkQn6yiZn5eGfeNeU3G3BvURjLbeVQqqD9HjtfFR
         434rucetX9570KhtvNWnQMi3n8DMCtiy4VMwQIAP06NGCIWetoozTtvQ22Ar6M3TIEc0
         Squg==
X-Forwarded-Encrypted: i=1; AJvYcCUhG8XTfFMEeWe/+l2JZiaqoONBcUB1bo5diQ1xmGdnwLMdK+9ynDs8rRzYhQyeEVGF3sM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEIzvAl9AckmHCk+ukQ5b2tRMECobCrITQB1MoXBTEYTQ0YYQx
	lO8Rjxy0ktzNUEYo97/6mEqrMJdRiZ7BUBdBPzWXu9K0shTNul/T9iZyrQe5XbM=
X-Gm-Gg: ASbGncvTCt7NzH0AyLVKu0Ka3HnhuT4U7o+wVnfd+dt5td0mh+CKeXKUtfeM+zgVdrl
	HJxGdRP4pFl5HbtZ+aUqgmGO2/CkDfQ3zwTweOYzQuFyQIrwEZfCj3K+ui57PDiHG1fz9ENLrX3
	iAMX3u+ddNvBd+vIvqz5Iwk3BGx9jcOvMacIeRmPEUPuFblRpuFpLk4/y87Cvp9uS4LtTzrkfAj
	6X5rZGlwO4Gmm0YJe4OxoDRfCLYkjFChPF1umUb/dFYXbmi6b246BQtsrXsKsd8lmqdiCiepsun
	VroclWUw+gZMA4saV+toDDV+0gxsOxx9CmBXPQ8q
X-Google-Smtp-Source: AGHT+IF5WHMO+sfOiJN417KLtIfjhMlhi0917mmBZyVSE98LhaqjrSLXneiDiqyGA1xeA3w742aXrQ==
X-Received: by 2002:a17:903:40cf:b0:229:1717:882a with SMTP id d9443c01a7336-22e798bc50emr38640465ad.4.1746661378306;
        Wed, 07 May 2025 16:42:58 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:57 -0700 (PDT)
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
Subject: [PATCH v7 17/49] target/arm/debug_helper: only include common helpers
Date: Wed,  7 May 2025 16:42:08 -0700
Message-ID: <20250507234241.957746-18-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid pulling helper.h which contains TARGET_AARCH64.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/debug_helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
index de7999f6a94..cad0a5db707 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -11,10 +11,12 @@
 #include "internals.h"
 #include "cpu-features.h"
 #include "cpregs.h"
-#include "exec/helper-proto.h"
 #include "exec/watchpoint.h"
 #include "system/tcg.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 #ifdef CONFIG_TCG
 /* Return the Exception Level targeted by debug exceptions. */
 static int arm_debug_target_el(CPUARMState *env)
-- 
2.47.2


