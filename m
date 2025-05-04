Return-Path: <kvm+bounces-45315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCF41AA8409
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8DFC3B2B22
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28AC11A3172;
	Sun,  4 May 2025 05:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FsWBZ5Dm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229D419F11E
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336582; cv=none; b=ALgPCwoHwjaVwNtXjO+rPt6GcL4Ri+TGDVNR4k596mFUrYMy8e5rmEPm4e2TGSM/auVijgJSkhWKTKDIYRKBsTZzWDxssxH/yLZnVzJBG5PQHbaGUhYFCV2tD95PTPuerviQiEBswNO/M4JoZOobjw9rDSmAWX862wVI1k0ZtiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336582; c=relaxed/simple;
	bh=sF4iJy+apLR8twJx7Q7SP3iBtrXXvvgLe9tCDur070s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gg98GT4ztu6CONPblKPPZ5ZnqqyOi7IiXhleBPc1LRuU433ihUv3yEOPrNlV9ewWqEHXMtGZ77/JrfhBMnRxWQyfA0ToGkUj663qmCy3bJefkpSR+YVTTn/4n3fV+Dk7nr9L+iHGa4UGbyekTKpyhxG0G+ammiq5uotZ47swpfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FsWBZ5Dm; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-736c1138ae5so3461143b3a.3
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336579; x=1746941379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zr91VyD7KzMDPFf4g5hvijagOJ2GOeFDSpZ2RGMEaGY=;
        b=FsWBZ5DmRg6N287Se/V01BFppE7yRVHVDBH/HLJLhXm9DyhFbm+h7MDE+i3FwRlyd6
         Bl782f0kaF3I51KKKuUDhh5pe9R5+d97iwKoBfqeOONl6l+hgOp/pZzNF3qPhLS5Mg/x
         /vzOvg8m5xn4wjb0PKJjH9z92lCS95ZTDt3wXtJwNYd+P3VYSWEdTPmAMiX9Kw5anzeR
         0BhO7SXWW5Pgo2+T7f4bK9HnVwaJXh+dx1Au4VQP5ZhQznTQimYm3v0gw5Q0Dnwf3dP6
         SOgW/nOEb6A2V4iZzBOMlzHKbbVTS40dKYGqK0BFB43t80BLwGe/Ut215+fdd+/v6vmA
         dpqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336579; x=1746941379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zr91VyD7KzMDPFf4g5hvijagOJ2GOeFDSpZ2RGMEaGY=;
        b=WySK8ZuklLF2mJqW15HWLOk/ZLc8E4aVtfArKO7Cip7Ru7oH9zS4x6n0urg0aCNr6q
         g8hMNvEKAYRqf2a12FdKBYq3dOIu4UbR+QrAHGWzgMFdQ4EmZaVHLLmrHLqCFpT072tS
         mPUE5PCP0vnMlouwkTlNUdzO2fdyGc7tfOA9ybQ4KAzfUwkmuOwsDJ5Ky0BqwoeMxkSQ
         G1zaebZ2mIefLa2xyL40RBJ0cDm4s/wbC8cQrmAXzsSdV4Fzn5V2/hLt5wBbAEOk+XTD
         Gr9m2Ls3U0PKH7B4knRV+fsLtJZIpmzyoZvye2USo+qts0/f8YgZwRVuuprwI14NawlM
         R6xw==
X-Forwarded-Encrypted: i=1; AJvYcCUiunnJ6pVaxmxviJJCa8TKqf4ornA9EhAM6rLksmP1adir3XmpfCoYYWWH5e9QWwjSGIo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBlC3dB0fUA+efkK6LdE6eeZuh9Nx2VPFva/6XLESsEzLpjjWx
	kOFHtboaXJPDUEoQTk7NcYEJPqtRMPgu5NxbICDpiIeKgzG1Bkeg3byGhc9z2dg=
X-Gm-Gg: ASbGncvN3zMnX/6RqDCfHHElXQ7TJjNG6iqCoB45nUrT4zTkk1My58dltFYDAkXTSyG
	blIh3K/uclNPKaERFv9uI8Cdxbg6eJc1RwupnvzNfRnBlglMcvIhgOxlgy06G2HEJk0DfwYqqru
	c/0EblJSdyiwWG51H1ZqqPR8uQ7rH1oOBzG96e/+5707tdH6jcgpaIkTYPpGzymglYuNbNE28fw
	SiJkwe5vyiDvNwPel+vZnlno8uM1V19PFR7oZx5SDQ+9DPCkVLAzwU0JGr/6U2uBbX+WCcT6ney
	PvIOVdwiC4nyRfFlSQPW2MVmxl9rOQSxRWpwwpnl
X-Google-Smtp-Source: AGHT+IFfySvOFkf5D+3E2z0KECvBrvExxDrnmyJ78lgoj5cX04fSE4cePI6QTcx4mVf5frJYla1Urw==
X-Received: by 2002:a05:6a00:1d0a:b0:736:46b4:bef2 with SMTP id d2e1a72fcca58-7406f09cfb1mr3647809b3a.6.1746336579517;
        Sat, 03 May 2025 22:29:39 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:39 -0700 (PDT)
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
Subject: [PATCH v4 22/40] target/arm/helper: replace target_ulong by vaddr
Date: Sat,  3 May 2025 22:28:56 -0700
Message-ID: <20250504052914.3525365-23-pierrick.bouvier@linaro.org>
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
 target/arm/helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 085c1656027..595d9334977 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -10641,7 +10641,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
     unsigned int new_el = env->exception.target_el;
-    target_ulong addr = env->cp15.vbar_el[new_el];
+    vaddr addr = env->cp15.vbar_el[new_el];
     unsigned int new_mode = aarch64_pstate_mode(new_el, true);
     unsigned int old_mode;
     unsigned int cur_el = arm_current_el(env);
-- 
2.47.2


