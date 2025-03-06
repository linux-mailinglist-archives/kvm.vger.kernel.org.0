Return-Path: <kvm+bounces-40219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63195A542ED
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 07:42:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D350F7A7701
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 06:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6F061C6FF3;
	Thu,  6 Mar 2025 06:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gRC6X8Et"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5941A5BB8
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 06:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741243293; cv=none; b=iy2rsDEDa0n8l3EWD8uclZjbHPuTDHeoooiD0VmAg0AlxFfkRnN1BdkmiXkGd+gWDoO9CBVpGMlWEiAASmF/sNM2fGyviVd/PIpfSqGrf0Ossq0e02x5z3VNCTTyWC1jFdbaT9O/QzuIOuwwWwkQFPV+S9a5ju6eIbbpd6ubu6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741243293; c=relaxed/simple;
	bh=6096i1a/iI4fVwN8JNLyH4hy1/IKllXpUvVlpgVRDZE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lNnlVP7FOqksCEVQUC105PGszMjBO3JLG31sy74sRa1KtCR0P1r5md+J+nPA/fjNELcXJrDii2O9TZrsfRKKSG5R0AkBMwQ9C5qXStwEiPMP4it6p7Wgd44pAQdvwfwJerV6rGAWV8fwe9fj9mjKgNqtPd2J7AJEa7UnVRxO/lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gRC6X8Et; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22403cbb47fso4532985ad.0
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 22:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741243290; x=1741848090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8ypN9EJmJMZh7TFGUmek2PnxWXl5cKb09yiek0NZ2U=;
        b=gRC6X8EtCveI0uZVHcwVsGOjzjldduI0KK3mksvgA25B6d9ojZgflUNtsfJup7q2zP
         shpM26AyuvU5xzK9vp5sByUUxqSCTggQnVtujArYrT1swCb5NoOxTGpeLzviB5wT2Se6
         IVThYnuY83WNB6w2Zt1J62xG6pLo1vXebki+9vTWz0DRTflpHb91JRxhK2Cv0EvV08QG
         +IzHLBdYfDY4xuQIxZW6ETIdfrkJRlWX0k+oVS/wUJTvgOII/XGEG+bsBaHtzlH1Wq2J
         MFOSvkdpe14FONZ4YL8MyiX5clCifLyjj6qAs31dGxHN4kw6AsGYdp9f5exlca2Yf6KE
         LqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741243290; x=1741848090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u8ypN9EJmJMZh7TFGUmek2PnxWXl5cKb09yiek0NZ2U=;
        b=TIXHEaIjv1NGKev4U304LqgF6DT/n9Q665g4UwSg9LLsUitQZnNZpdCN/ztCEHtqax
         ravW9jfOO6lrI4kEsUxmwc9qZHdy6RJc8PEpfSRkEkvplf154Ntr/XGMoVx0QQhvgbgW
         ktt5bC3/svCxN/k/AEz4AsowyDo+JXt2e/w0TnWexerH7N3272aLoDaRMQUb//D7qFu3
         fuGNAtSrk3DU55/6fRNCTxsouZM6BhcV+Kp89bzPPtnAJtaJ5AHFwE0YZBM87dWUZ/iw
         6xp22TzSRfzrJmrB+lohZdSunCo8Vzz+81xuGLzVreYvGf1lwONyrpjb/z78BARsnuUq
         fzsg==
X-Gm-Message-State: AOJu0YwLKpMkNee3GnpA91lOsjP3QpeVVsgTtxCNAK5AbVOoyibBLT+H
	pGFiDZC+LYI22bs/SZR8cLLpZnvreeLS+Z1IMvk3EXBlNnAK8AIZw0erS5V/MFYjmNmfkeEoRAR
	y
X-Gm-Gg: ASbGncvZH8gIiuDHj8p2XoLBlD3YULzvXNPVVhQngKmK4Ng8iI2107rQww0NR/60QqO
	xR0RK3guuzJykmpZpx1MTBIX4Bx2uVhCWtGjlq+ofZ4NSLKGzBnrPJ1jc+TCKzaDXLp6dUsXj+D
	rRpXNXyHemRIzYPGIAFUbN4Mrpm329BhGV6Szj+Dx6xFPcmyqZsm+6NXyllwcHGOB2xjXmI63gE
	bGcwRupi3bX9kFwy33nsC0T+n4gBKleVoLWQKwyDpbg5BlsFZSyV6TeD6E6JAxNKVqNizKMaMGe
	uyOpDGiGZ5AHcfvKcJsqO6sPy1COBeTngGd5Pbj2FNPV
X-Google-Smtp-Source: AGHT+IGn4dWWM597zT6vcugXa0NyDMgvYpsWMNNAPMD1rOUygPXJy4ZLiCcv5xBAeUFD0Zu/7LztKQ==
X-Received: by 2002:a17:902:e752:b0:223:3bf6:7e64 with SMTP id d9443c01a7336-223f1c96f97mr108234575ad.24.1741243289884;
        Wed, 05 Mar 2025 22:41:29 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a91cffsm4769355ad.174.2025.03.05.22.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 22:41:29 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	manos.pitsidianakis@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org
Subject: [PATCH 4/7] hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
Date: Wed,  5 Mar 2025 22:41:15 -0800
Message-Id: <20250306064118.3879213-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allows them to be available for common compilation units.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/hw/hyperv/hyperv-proto.h | 12 ++++++++++++
 target/i386/kvm/hyperv-proto.h   | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/hw/hyperv/hyperv-proto.h b/include/hw/hyperv/hyperv-proto.h
index 4a2297307b0..fffc5ce342f 100644
--- a/include/hw/hyperv/hyperv-proto.h
+++ b/include/hw/hyperv/hyperv-proto.h
@@ -61,6 +61,18 @@
 #define HV_MESSAGE_X64_APIC_EOI               0x80010004
 #define HV_MESSAGE_X64_LEGACY_FP_ERROR        0x80010005
 
+/*
+ * Hyper-V Synthetic debug options MSR
+ */
+#define HV_X64_MSR_SYNDBG_CONTROL               0x400000F1
+#define HV_X64_MSR_SYNDBG_STATUS                0x400000F2
+#define HV_X64_MSR_SYNDBG_SEND_BUFFER           0x400000F3
+#define HV_X64_MSR_SYNDBG_RECV_BUFFER           0x400000F4
+#define HV_X64_MSR_SYNDBG_PENDING_BUFFER        0x400000F5
+#define HV_X64_MSR_SYNDBG_OPTIONS               0x400000FF
+
+#define HV_X64_SYNDBG_OPTION_USE_HCALLS         BIT(2)
+
 /*
  * Message flags
  */
diff --git a/target/i386/kvm/hyperv-proto.h b/target/i386/kvm/hyperv-proto.h
index 464fbf09e35..a9f056f2f3e 100644
--- a/target/i386/kvm/hyperv-proto.h
+++ b/target/i386/kvm/hyperv-proto.h
@@ -151,18 +151,6 @@
 #define HV_X64_MSR_STIMER3_CONFIG               0x400000B6
 #define HV_X64_MSR_STIMER3_COUNT                0x400000B7
 
-/*
- * Hyper-V Synthetic debug options MSR
- */
-#define HV_X64_MSR_SYNDBG_CONTROL               0x400000F1
-#define HV_X64_MSR_SYNDBG_STATUS                0x400000F2
-#define HV_X64_MSR_SYNDBG_SEND_BUFFER           0x400000F3
-#define HV_X64_MSR_SYNDBG_RECV_BUFFER           0x400000F4
-#define HV_X64_MSR_SYNDBG_PENDING_BUFFER        0x400000F5
-#define HV_X64_MSR_SYNDBG_OPTIONS               0x400000FF
-
-#define HV_X64_SYNDBG_OPTION_USE_HCALLS         BIT(2)
-
 /*
  * Guest crash notification MSRs
  */
-- 
2.39.5


