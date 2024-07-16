Return-Path: <kvm+bounces-21690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9430F9321CA
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 10:28:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5F6F1C21B57
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 08:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9823F58210;
	Tue, 16 Jul 2024 08:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="bKDwSxnO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FEA56B8C
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 08:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721118513; cv=none; b=MGexvGf2+q57JoAlcswj1A6tmZrVHIH9BIRcXP3VIWKryg04j7NSjhgAHiB92v0VAI9+ffz5PeofKdQsCfnj9M7g+BW4RRQKESE5We79jgBbd+pfQs4c1hY2OdgSu/WJI1O2UApgkjbEiMThoOlqES/c/yzM34M3MR5l8kYDjnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721118513; c=relaxed/simple;
	bh=40OgbpTySEQ6YEs03MghFUDuwn3oADg13liRJNSUy2s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uNWmPpFp7sq+yoRis47uhqx/VEhtkHRfhIBPxd6OGGfs6BHrEljAtcsqannvgdzvZxpnphS8/ijjup/wuVe9j88CzXvDrzhXCwj3tKLwdwG9askAehQ8M3K3q3pnzZjxMvaAIzCfu/yzX/cEqLSa9IFMumw414gNA3vIKg3n8Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=bKDwSxnO; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7669d62b5bfso3033881a12.1
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 01:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721118512; x=1721723312; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UCgdSp5pdNZ1XKq3c5okiNiCxhoyMDPUd6RYSX/QMYw=;
        b=bKDwSxnO7pBs8qP2A26wb//ZHswgIhiP0tABEaDqj+meNY2fSsVpNEyUSrmhLp66IW
         KRuHAlG3QUJxP83L41zhjDLqWmSskhu7eSqfiCmy6XShAv0uIsgd7e9sPkDPWLrRZQ5y
         PvzMI6dCyec56H6pGrOAcq4K0t8CFH+oUyI4bQUdlcd4NHZRFf97WZiZMco7HJZzOlRG
         AetRq8DdspDMsibAaM2tngZywHdHo+Oqt1iDzOble1xHH/Y5h91MnX4D7SuI5D6QfG72
         ZdFYJ4LSnvsqzF2ehwiIRUPSw5KypKMuXdHYLOeVzGa4LfQGlL0rT1PMZWhfgHYs6jBk
         sMEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721118512; x=1721723312;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UCgdSp5pdNZ1XKq3c5okiNiCxhoyMDPUd6RYSX/QMYw=;
        b=MxPQnuCfPCH4akR/9ErKgXLysfC0AQrWd+uggZB2JZ7rGwLd+n7F9g4feqXTCaqiwV
         Yt9J2KU0oWk/CWNLGgSwQedExB6J9dxRGHeHFITyNCcv3HYsDTqfb6kCt7eFgXOyYs5z
         7P9qmjnCP/YjqXk/PEPSUEhIcT8yfSMSxh+gSc3t3y/7qBpHCFOSi3VJE9WmhSs3QN5Z
         2y3qeCU1+sVQmbmi9U+7WPLXjvlR8UehldM5Abt+SLcq5F39icOr8sv5Yn01KlAeMKqc
         Yev7dYEKX365eyNOurclG4u8cAZZfUsUw5SdVbd8B3YT6uanNHUK6XrFVbaXAbVBa1nB
         Nz+w==
X-Forwarded-Encrypted: i=1; AJvYcCX1Ux1SagYgJsoGb6F9xDWLXWrcl7ruFkd3d4VAHcuwDKn/4nHhe5f+oYZfpNYaTuGVyRI7HIv0B1xf6alKK3gVlVV8
X-Gm-Message-State: AOJu0YwoobmRH8d3FXkB740QQz3zGCwjyaiHyiA+EkEWc25po8TIpIg7
	XwZ//owP+VBYTfYGN6YOaSAKUdGkPkdhdpM9Qd9SJthD8c8KpyBS9mPRjstO5xI=
X-Google-Smtp-Source: AGHT+IG8ytNrN8j4Va7eZKqyNgFYDSFIbUseO3QJ7+TSFiRHQD01HvT+TL46FEhGt6SylN1T0a/n4g==
X-Received: by 2002:a05:6a21:99a5:b0:1c2:88ad:b26d with SMTP id adf61e73a8af0-1c3f129e50bmr1720884637.48.1721118512001;
        Tue, 16 Jul 2024 01:28:32 -0700 (PDT)
Received: from localhost ([157.82.128.7])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2caedbdb745sm5712692a91.7.2024.07.16.01.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 01:28:31 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Tue, 16 Jul 2024 17:28:15 +0900
Subject: [PATCH v2 3/5] target/arm: Do not allow setting 'pmu' for hvf
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240716-pmu-v2-3-f3e3e4b2d3d5@daynix.com>
References: <20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com>
In-Reply-To: <20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

hvf currently does not support PMU.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/cpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 8c180c679ce2..9e1d15701468 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1603,6 +1603,10 @@ static void arm_set_pmu(Object *obj, bool value, Error **errp)
     }
 
     if (value) {
+        if (hvf_enabled()) {
+            error_setg(errp, "'pmu' feature not suported by hvf");
+            return;
+        }
         if (kvm_enabled() && !kvm_arm_pmu_supported()) {
             error_setg(errp, "'pmu' feature not supported by KVM on this host");
             return;

-- 
2.45.2


