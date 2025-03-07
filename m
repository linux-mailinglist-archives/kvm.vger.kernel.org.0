Return-Path: <kvm+bounces-40392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D734EA57123
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:10:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B06318958A9
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 283902417EC;
	Fri,  7 Mar 2025 19:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XFMaXFKC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C893924FBE2
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374616; cv=none; b=Zw6Qxe8zpSWJO9d+yyoh2BdfVJwimo3lLdIp7DrAzTG8Fv9UKbdzj54odsCFA8A+3t8FnqkEwD5YqaoqWG5KE1Gis0XZNnt+gLuEAseyjI4hpcji7J59xDWKErfh8HK6rKQgtUQlvu1scfl7f8wTneBnWSasBOQl+o+9BSTHhR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374616; c=relaxed/simple;
	bh=f6ywhfIHAeGjN6dW94oj9dG+w9FoBwMOqVbaNl3zrqA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CYV+dLI3LXUE0WwvY3mUwcrIK28Q6DsDozzwVHRRRJ5w8dLvWtiHJh/vP6Ex8MRKzz9gYPkZTRL1Hv5UakLA3BfWpPBz1GoWGfM7fi0y+SV8tgrEIWNXoRkQT7apUcxoO9xXZMjuUVH38CJmBjSGUYhUO7Ylxi80ZF7NTdpuPLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XFMaXFKC; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22359001f1aso56634115ad.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741374614; x=1741979414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xUvuEjETtAwgjY+HHVzD3fRoYrhNXj1rMDKPunM+tus=;
        b=XFMaXFKCKLGUMZk61mwLNCoQNY8ViVvVC1oy+ttFl9+E6uuUjGfCOSE+RI8SyZtkjR
         tmOR8MJONbXEMqKufE6G7lzv6EJ8Du+gZ7sXoOAVXQCNwwEHDRNOifW4LL5cCuhM3S+R
         eziBma2q1sdbie5apsxYJQenezFICVufM9Su4CTH6tHNQNyufLlxNeT0TghtdIC9y0Xf
         +tiQ+vud29ps3A2zhQc3PLylmKZBA0ZzrWjH2NYLjAu6UjYepiPIgc7z84QTGkAl2TOX
         dczjhKJ/2u5szukvwSqqzUj1N+k/0GzhATKEjKszC44qOTi5VqOPiSIwdlUTuLoe9RUb
         auaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741374614; x=1741979414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xUvuEjETtAwgjY+HHVzD3fRoYrhNXj1rMDKPunM+tus=;
        b=L6Tj38oWDf2VeCsj0b80nnzqR4Kgkez9NBLA6Fo9mewcfM6yEAYnJTnweU0cTahumP
         gFauBjNhLAjavG8ARSxqHI9MCshsoa1CWY2EX9ipGIqWoMFl2G9+rOXt+xBUJz0uHI5c
         JaOTB0VhvKigWLdyx5r+HnFCuS8wQEwVoW/4gioXqJ8cu3wfuHIpCXHYhKLgCshrXNeq
         uL1pzSCe3no6DA3ETk+jfUKE8SwlT3iEvEz20K6ORu6CfE3JC8IQATkFnPh8TBuO93Nn
         K7pE5wDhqsB9LJkCrSTniNrVRwNUHt2vbtZV9WDnanWS1i+w20i/Iof0VliiEZukxNu7
         hPHA==
X-Forwarded-Encrypted: i=1; AJvYcCXFohPMtCLjmjTwbhHs+dTWLFlUZv+upiOHAlNgpD3ThGVMRfohNgDRFKfHVhSObB1t5Qs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt/+SeB7tFZQFpc51Y/RqEi+ZT8ZBPgORUEQr9yI0+7LxLpUUN
	mcB5CidrzaimmzGosIYqj+4TQa5dmxdQquNnOUGXRvGc97UfYTFcUKn2JgIDfcY=
X-Gm-Gg: ASbGnctkTr/zXYRgtQ4GO2/KdY2bSquEW2fEW5wXRESOs1E0OoVnEpx/9EN77HkZmN7
	O1FIQMXe8m7lGa6ujTFzgHYTjwG4/1dt155xmM8lwm5BrsgdgOS02OsjbgZhbGbHzmXuAgALx8Y
	n84nemju8P1wpnCH4bSOYeOgoSNpN74YhH0RkIaUFa4UbZyQ4C0dELlW3EuIjiRBzIYimwfOgi/
	UIeAOWo5grPmbFQIHmnQ+NJLmIdzZFTcBqRFCVYrIS1wbVE8ZHBTCbFieSjd2zkMyFN8PM/cSva
	a31edoK8jKbnNf8hGy4WpCS+4LmoZ8Hd2MyhqJp88mci
X-Google-Smtp-Source: AGHT+IEbWI3ew4dnMWaB90EaFVDpeNVLWqjEG4CtmHYP2FlvgISb0XWr+8NvwuKEf/16oY50uVRpzg==
X-Received: by 2002:a05:6a00:2d90:b0:736:6268:9ec9 with SMTP id d2e1a72fcca58-736aaadf12bmr6908832b3a.16.1741374614354;
        Fri, 07 Mar 2025 11:10:14 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736b2da32c6sm1449895b3a.149.2025.03.07.11.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:10:13 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	pierrick.bouvier@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	richard.henderson@linaro.org,
	manos.pitsidianakis@linaro.org
Subject: [PATCH v2 4/7] hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
Date: Fri,  7 Mar 2025 11:10:00 -0800
Message-Id: <20250307191003.248950-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
References: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Allows them to be available for common compilation units.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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


