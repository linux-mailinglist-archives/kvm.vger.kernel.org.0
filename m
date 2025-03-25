Return-Path: <kvm+bounces-41908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B921A6E912
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:01:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9C897A612F
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB6DD1AAA2F;
	Tue, 25 Mar 2025 04:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jPfELkhx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F731F12E4
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878781; cv=none; b=O44YhViSwh+/Ga/PJDXmMDmAMK6kTvUz38Liai1HGtsep3Lf7g7B8VL5kmzW/UAJlEhoFqv4vUyggyHmzqez6DmndzQRcFt5R0P+1SoxhOk1zAAzWicpjxNNkXsoccdV51gQ5whpz0+Wa6IESkKIhzgQvZjVhdYXAqNlAXIastI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878781; c=relaxed/simple;
	bh=Xv7auBFHRD3OK+iqBmEUMROXzZu8x09HlF7wbv2221g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nuyMBWIHkdZKTgqLj1SS9Z1HhMTW1l4KR+MeqC06kfUzIcJUsXrlSuiWY3argOqRsFCihsXxrEo5jcFi9Ow60xOqTtE/I2QJvhookI8Hep/GA6eS6BZBw7gHxCShkZiJlAAi1+wW+e5ay2CLNP9/s2nLSVft4f1m2YRJERS1HhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jPfELkhx; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-300fefb8e06so9161111a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878779; x=1743483579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVYa7fx+hqBI4AoRMYooEEzjwHkUuA977fGAq/tYFYA=;
        b=jPfELkhx3Z/ssfTp3WOIm2gUROEFHWsXyt+HapSAGHWmAXNikmzNVhAdFQ5gb6BOT2
         pWbfayE2sVds7hhEUDU5keoa1cJP2UXzt3iqQi/ZhpKd/0xPDd81EVGrovJV9WKxdJEu
         QSPQdJ9MBrg1RXwFExEVTAsOrYZvlcDK3VV04nJqoMDrw7u61038mB88STaHeH6RVnKn
         YQjNSl3SGBctIxXbW4tAv7Y7IQJCezFOjOlFE/6NbsOXjWmW7mLa2ZdvwaksJCu4d/Yk
         KmP1u6x+iQvR5SvupOeHwuGonaObRtQYUbeT/qmGlpB4PajV0Oqjt37hYCT8NwHmchJL
         yLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878779; x=1743483579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wVYa7fx+hqBI4AoRMYooEEzjwHkUuA977fGAq/tYFYA=;
        b=qrk+abrJQPDhQesiBL5rLs8dEmxKgZFVli1rEE4WOZE2PhG8+R8Iggxy3XV0+hm3Al
         l4Z0cXeaR+K6E2AvYN1uuSN0ZYlKsC/EUC4w6Vl1p9fFzvEXMlwguVqKQylY1XWyvDRa
         93PM1qu6ewGvLRRG6bLPZrmwaXRQGuXu9DwuHK8kQknX4l1uN0tvZRclUTtGXUtifdYd
         DRHmR3btWVNExYiNCC3w6qKSJsZpdjB7CRe2NVjVDCIB644w0kNfkqrpbgTPFq+Lm/D9
         fAIARp8JEB4c09BzsksmtoHD2inZp0oiB3uggSj24wufORGwTdHfJOM+D2CnrWP4sAkP
         Eihw==
X-Forwarded-Encrypted: i=1; AJvYcCU7XdZGrPCmjBujzOFCqTO3cEnWVN/lYPVQNm873by8jO0RmkmU0OlLyz8LFlU1tzseKhU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAQj9YQrUUEFaaCGySa2nBXrU+DaCnOTRCe/yOncxAw4i3pcc6
	/JzOJ+7FywH7y/U1bKJNSBi5z29jH6t6k8AMN2hGa3A+9N5FNlJejDrv8FhkS9Q=
X-Gm-Gg: ASbGncuQysXH7XuB8tUDhEJjT9z0MNnPEMF3IDydXc/wG8jHgS98hepSVsP6QpaJcYx
	j2Gl1xDRdlFpnzkR3+DKjgbD3llPZeS70azPv+Zup/GWb9+t+E5NNQ0ZQOq99MeN5BWpaEqk1MT
	GLwUFgjPlnqgJINC7g1X2gtZD9MyPTdq+o9aY9fex3vUcPoP4aC8pvzC1U7ocjF7yegFqIU8gty
	nYwdSZGB4ZHEp7rpSiQVT7eyA72Hq1LgKFWUuWx9qZCvyXia3Pj06qv9T0uGuW8jFqWn14/YVuU
	eesqpM4oJ+s6zl/CsLRsW0PfPB4H+bgytXSja7sPTjtu
X-Google-Smtp-Source: AGHT+IFQAPoKluqA11lspPIcUM+K4oeubg7R44UKiLeIG8htmcgA7CTFmMh6CBhixpXbl9nw4lJFrA==
X-Received: by 2002:a17:90b:35c7:b0:2ee:6d08:7936 with SMTP id 98e67ed59e1d1-3030fea53b6mr23779109a91.20.1742878778703;
        Mon, 24 Mar 2025 21:59:38 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:38 -0700 (PDT)
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
Subject: [PATCH v3 18/29] exec/poison: KVM_HAVE_MCE_INJECTION can now be poisoned
Date: Mon, 24 Mar 2025 21:59:03 -0700
Message-Id: <20250325045915.994760-19-pierrick.bouvier@linaro.org>
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

We prevent common code to use this define by mistake.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/poison.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/exec/poison.h b/include/exec/poison.h
index f267da60838..a09e0c12631 100644
--- a/include/exec/poison.h
+++ b/include/exec/poison.h
@@ -73,4 +73,6 @@
 #pragma GCC poison CONFIG_SOFTMMU
 #endif
 
+#pragma GCC poison KVM_HAVE_MCE_INJECTION
+
 #endif
-- 
2.39.5


