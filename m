Return-Path: <kvm+bounces-40216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07EE3A542EA
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 07:41:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 140713AEAE2
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 06:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B04A1A0BFA;
	Thu,  6 Mar 2025 06:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Nv30tyQ2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87E21A238F
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 06:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741243290; cv=none; b=o7UiNTXpUaGlSMt/Mmk3YTgn7M6S+ZmuCQGnjZHh4LwTcyJtRrVGWBiKKFwOuMhOMPEcVBIOFUen/cBANRJQzBteiZ1otFFKeTEMoXjJZp6w0iOvSGvEOvoxwu7YexTGtol4IFIH00Tc0umHZ7T18pGH2dgEUaOCJ8UMMYKOGTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741243290; c=relaxed/simple;
	bh=/XpCnz1OMebVgDSh25ZupEgZ9N3/JKVcvUBHI1BUfVs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lyCe5sw4ppMu2YNcXfQ/NGFTEpSH3k2RH4GrzpPxf12OrTTOa9IT6/SCkSmx4QFOycxHH11g9qBMsZEU0GhfBb0HvZODCFY7cM1yvIJSnNUn3l5f/VO78utFQUFZbgloPMVcy+Q4DqO3Bk5E4Y3jbvp5qvr5oPQd/zt0yYQeq30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Nv30tyQ2; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-223a7065ff8so5844515ad.0
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 22:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741243288; x=1741848088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/2Cqyz5MzW0BJMcv6vHkDTQpGUU3r1TqAgpaR0U/jco=;
        b=Nv30tyQ2oSfTEOQVp8U5yBU0EmQTjmLzssOw6CMXGIT118r5+gqfqtk4ckoBgHoXJh
         DI6/uirM96rFpdyZqJ5FRbNA2YNjjh/e4BXZeqiApbbR5427PNQd2vVrZZRbMYtP9s76
         qYB742yo8cHafz9SsLEdNlKt78Qy1vqMw/XsoRmaL2Y6AKsw/QzMPULyZO0aSpfIsauX
         x4O+NJWtP3Bj8bI62mHsT2gXMxXcAk983sVq0mEYmENr8TdMZzvbFOY7Kh0I81DGLcSX
         ggv3pTbMBY2oflnWp72NuNFlUOKwg2WpMNHMuTjlB+tpLiKF7b64DKIxd17wc81fwYqj
         ZgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741243288; x=1741848088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/2Cqyz5MzW0BJMcv6vHkDTQpGUU3r1TqAgpaR0U/jco=;
        b=FMg5yUsv54Ktqv56RivwLafL1gBr6nhofbYGLUzlpAZCzLVrmReYDkVS2C1TRtlxS+
         jfPuGO8epP2GR2gkXVAIKbzz48/NItuVRKg0QJlK4vJ6PlBv+ccdb1RcYoYE/SputNeU
         a0IDeAVz+E3OJ6dbebSB3+UjhRDSoIXomuH2PzwsX3gMM1J+fEmhQMGFD8Va90KQxpgX
         l+lIoM4rbM5ltCo2dJxgc/ZOaC/B+1PMZZHhvLByeDcvybed98ABdGLaeqq/8Dc/t/rI
         +zt+Pqm61KjtFcjpmMIsXzFZTRz51OaMsKWlgS+S9YgHuzbmlZD8s3VWaIAww2rbo/F5
         8euw==
X-Gm-Message-State: AOJu0Yxa1Y/5Yh3OXEg7VMY8qTY2d9HU6EPIHBIL5neJayg5/EftblAq
	8IJ0GuX4X/wV+dzWmW9ZHVlgDM6vQZP4GiccK9VaRDIN1yUZrAWB2b/+GE0dXiA=
X-Gm-Gg: ASbGncssYzf7BfRvY56C1U3kZO5rRi+JFkyhdxnW65hfy27kLD61SEbthaNbVwWOAAw
	orZ7eHgS69RTZCMESAruQd/YbZ5yEYAy20LxZ13l3jqAw5TX5oUnV/DFcTD64zyNRRkzR+gS8Yx
	iib73Sor6OwcMrzvkLAFOLNzKqawnkktk6zLgrlhP2gdba9flmSW2GYHurtHzhYhwRQf9Kozddw
	TF9mmySNNeRnEfaegi85AvRShUCfaUs/ywIMuzE1DJ4kjmJ45Fc89qZa0JZWw8aJw0qA4/czCX4
	yw+L1nTr/GsG3nhWrQX2Tc3Pd6gykt9JpP8L1NTQXxQD
X-Google-Smtp-Source: AGHT+IEhtCs9J6dNUfTXZfoSz7KQgHmZ66yfg8KDNs+eagI9gyF0lZ1IhFG6M2GKXybBGTCI/9l/Mg==
X-Received: by 2002:a17:902:cec7:b0:21f:7a8b:d675 with SMTP id d9443c01a7336-223f1c7968amr102765835ad.4.1741243288018;
        Wed, 05 Mar 2025 22:41:28 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a91cffsm4769355ad.174.2025.03.05.22.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 22:41:27 -0800 (PST)
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
Subject: [PATCH 2/7] hw/hyperv/hyperv.h: header cleanup
Date: Wed,  5 Mar 2025 22:41:13 -0800
Message-Id: <20250306064118.3879213-3-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/hw/hyperv/hyperv.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/hw/hyperv/hyperv.h b/include/hw/hyperv/hyperv.h
index d717b4e13d4..c6f7039447f 100644
--- a/include/hw/hyperv/hyperv.h
+++ b/include/hw/hyperv/hyperv.h
@@ -10,7 +10,9 @@
 #ifndef HW_HYPERV_HYPERV_H
 #define HW_HYPERV_HYPERV_H
 
-#include "cpu-qom.h"
+#include "qemu/osdep.h"
+#include "exec/hwaddr.h"
+#include "hw/core/cpu.h"
 #include "hw/hyperv/hyperv-proto.h"
 
 typedef struct HvSintRoute HvSintRoute;
-- 
2.39.5


