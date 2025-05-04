Return-Path: <kvm+bounces-45299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B6EDAA83EF
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:30:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A34101793DB
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEBD118A6A9;
	Sun,  4 May 2025 05:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wmB5Mvnx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5B6140E5F
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336567; cv=none; b=WCvszcvnni5LdjAhKx+9wZwEkGbkN0qAssLh7O8CYRenpqTY1FYVitkEWyy0pP8rN+ugk3ww/pcK9s4mkHG7Ds49+/M2BrJqEOCU7LTsp3P+yhs9zd4+Ca3qeF0s7vRIFwFu6+VsilH3PRDfzVQ2kIGYC71rzM6i0X27EyWpXng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336567; c=relaxed/simple;
	bh=1hAGtngwcXI/K1ZVwOSxlRZCzxWzI2kpJ8rbj0YHGnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhDav7YCF4SUD+/Mq8kJTDN+4X2a3nn/XMS4STaMbiwJ8rPa8l0DeD9WfXLcTvWVbCXfTQoIrjzKgpci9oyeTzQvOgW94hUHSpwPJZFGYJwWWv3LII2HFfgRAA0ViB0oIpxINhadZ614E4xJYdRGSHck9td6VIGO8WaNoWYeQ4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wmB5Mvnx; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-736e52948ebso4468136b3a.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336566; x=1746941366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hckfD0sziqBh1sSWGP9c0OUCVTgvBeVKgVHtB7xMeJ4=;
        b=wmB5MvnxpAkNQkJxPKaW3VlxPhFEXaaO88FhQrQGScOvkrNz73D+MewXfQeoLbnzK+
         YYOyxaLgV6haTwSI87KvFltg52VyctjI88oDLKq5Zq+J5HPSjbxrwlRRNcfBe3ju5PMW
         AgGlaeGMCptR5KrNnyYTX2g3hCyLHooV8E8jjsWAwd9ZhhgBDqUlPMMjOe6O+Lv+v6XV
         M20kxt49OGxitfHMnJCbwk74fWrh9F9Zg1dB99hIh1MxddKX6BHkT+XjytruLrSyUvyd
         jxlDYf0QUsatN/aW1EOcHm2NUS894qutf9E+12j9JekUrNPJhwqDTDu6gx+Y4NeYcEOO
         S/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336566; x=1746941366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hckfD0sziqBh1sSWGP9c0OUCVTgvBeVKgVHtB7xMeJ4=;
        b=RX/KjuTCLSH0LnlIZAXZM/ok+0Qg763DZKAIQlBgDjqqjdQxkrSBDDXJ3l4rfLys41
         PYZoY3AEnq5goT97igZbnEyfd0V7ipPjgVqUMBtHBHRpqtLKadx1KvnEmhoeIhK1iXKW
         FEoA3zzi6bTITXpqisOSWwUj1KhEL7TXNxJT/6rwbyN3rndpBWAztZu3aFMJ64Pux6ME
         2r1dczALBPm2eKyvHxdiskiLtEoGX1Y/CCWeDaHRqN2n9tb+7HngwvBU9H/HEyRys/8Q
         Ufkdq7kKKCoAxfsVxVMSm1VlUMURn4xGfQQ+t/WLbdjEAnNW8LX80Htxuf8HsoYDnrvA
         TejQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCP+mvthx4KNhFw386hIkVHHVqEqEEprWAxz/Vdk5XPzUPA6C8+ljOUg7jy14c5htSJ5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHLNiSiAmbCqLvgNPmni2llgdSjXbinOBzzAz4i3k6N+mMNdDf
	DdI/PLJhRMCUuXmKSm5uMEL3XB8FOkq3KE4ItxDjqHngQ6UWeqLMtJbGIvC/jW4=
X-Gm-Gg: ASbGncsgOhPvh+mVNEfBjMs9ddz+ZXcbrW9IVu/LeHEUakV3Mnjv0ZLGKsAPxKNtHKG
	tkuzSQaqE7lbUGuHAq1Bsfhr5xX3RloES3YFaY8ELT87g1jwZc33E/+hsJQoE1y7Di170lnhhjp
	n7RzqNC/27iW4w+3lRen207tNJT/TAIhT2xoeISNcNnblWqLfqCc/WSdKEtDRufblAJMkazL0XF
	HA1kpCLq+UCgknGgLoDjFTW0rpcLxpZvs2d2jZnmHxeyThtZFqA/5wzyrtWC47YLq04xNWZJisK
	gpi8XtvX8Blv14jQ3DD1yVu3qRUe4z+MHERd5S6H
X-Google-Smtp-Source: AGHT+IH9DqCwqIyT/DBCwqtOTq25mvsgeqw9qLrc719PnyccXJW5Z6fI1bjRjbsEjGhKSkyNrtOGcQ==
X-Received: by 2002:a05:6a00:448a:b0:736:562b:9a9c with SMTP id d2e1a72fcca58-7406f18768bmr4045118b3a.18.1746336565824;
        Sat, 03 May 2025 22:29:25 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:25 -0700 (PDT)
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
Subject: [PATCH v4 06/40] target/arm/kvm-stub: add kvm_arm_reset_vcpu stub
Date: Sat,  3 May 2025 22:28:40 -0700
Message-ID: <20250504052914.3525365-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Needed in target/arm/cpu.c once kvm is possible.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm-stub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 2b73d0598c1..e34d3f5e6b4 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -99,3 +99,8 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
 {
     g_assert_not_reached();
 }
+
+void kvm_arm_reset_vcpu(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
-- 
2.47.2


