Return-Path: <kvm+bounces-45364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B91AA8AC5
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:54:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83FD21644F0
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6661C1AB4;
	Mon,  5 May 2025 01:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WDyijaOi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FED1C3C1F
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409966; cv=none; b=Wjqgi3JaxHrLtZRCu5EoVX5x2cjsjLK6epyZi0zAwcuWv1KcoAgOZKT/JuuoavrKSiNAq3MZ8yNaQo6KAJzHUQykMe/8i/Oen723xzG++BJ9vHp9lj/fZHryMZrOwJEk5GMf2dPw1tAxAZU5SNRvBD4j2zRhM8c3TpgwMnF+/Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409966; c=relaxed/simple;
	bh=ml2TA0vrP9neaHTahuIEL5NgcIVEpZ1CGdXaGOWH+oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSW1Mm4//R17vErFNPfj1GG70U7PSq6/ocpqErLNk9erz4WBEZK8GDTWUIMyrk5oSywlP5RTAZNKBHmzEfUxj9rAPM96brRT63owX2bGmpOk37X7ejVEEQHmhiPvjYIp+xt1oOW1tWQDdmmw/nIQvQIn8AmsXzDXF/ZEDG37l/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WDyijaOi; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b041afe0ee1so3719884a12.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409964; x=1747014764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92Ra51BscJ7plqFLljDp4Imt4ck5QTPqHgH4Y/GteZ4=;
        b=WDyijaOizmGmXIncDjPd1P0LeHMLN+yhwhlTk4acqlFEMgaGKyTFiJaLdK028c8rBM
         1nGlhniTMM6scWmsB4zrBO42bLLzsa5YtttAicbsvnFjmSMpgwD+jJDOuNAUEGXdpx2z
         NtPnsaKbp5zAW620qYpXP81ReUPoU2xG8G4ElogMupbyhgna2U9yuah54dUKrKXExyqp
         7l6b8kVjl2eGTDpPUNUVIUgtL33bKEMEBIF1VZb9jt5/36uECI6azb8hHVHCU97UD80n
         F78qvr4ReMt9oMNTBCj5O74BtSu61//n/I6yihtg5lo0j77FdMww2PwhKWDTKUAMfVC8
         zZcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409964; x=1747014764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=92Ra51BscJ7plqFLljDp4Imt4ck5QTPqHgH4Y/GteZ4=;
        b=exrHlQKklZAlmroJ+0NcPNrrEMXq7qGdXJgkR5VCdqIfmNnHEYGO3kQtAHpem215zx
         A0SksnErFXLbdoq0dw9vAESiC6u92PbETkyb+PstFJD99cNCVtGP0FUHIoLw8H2UFzER
         MgngfFN4VO2lbfw0PPuCXpZcnpZ6pUlT9V5fxL2Wq6suBEU8XYyrW2DpCDysBuAwaKJX
         /GKiIP1TlOEBGAwBOi+sOZmChU4ooJfJrvb7Gv3jsxjnIRU2TMRcUTEeQSLx2jgZr1WL
         HsroKOd7Z61zaROgDDGalw8n76Vs7/kdzGnkdjW1LY3eZJJQ/GoOQP45Kj/mLGs7A4Yb
         hfIw==
X-Forwarded-Encrypted: i=1; AJvYcCXsBVBPbXK1l/6OAffV/4482pa59JbSv5ctcFqFUF5cqs22Ndtjr9fsXOZh+C7XRiSmqMI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyO8KBEuSqSstASZJSFDog9Nk1WPhgZ2F2/omXolyIywx6ZvMiM
	e/zz5ArK3IPbqyKUmFAxZBNSyPVLaSCZ7ePlghuaz5t5x3GeNXHscsEL5paisow=
X-Gm-Gg: ASbGnct5WZH3vRxxosJ8zODCx7zd8CIeHkxPefzTX4dKN1J0oiiaLNbSj4dI8OqikSE
	0oDYFx/TcTKMEKBsiEG9bOu671o+sySDhcNH6OQhZTYQqKiP70qiVGwgX8FN8sZzgsfhdAmqApL
	3VYLwKip7FSsNRX8VqB7Z/UFqM2p6+XR33tHxeySkZJzISVAHt0yAqC4x8xB0Vgiqm74AMgOAOD
	xEdAA4G2OYkbmkCZ3lUu8TkiLbZQriYdzsRWlaL5dyR8EEvFLhOwVabCRAhv9ZppdmuEIbQSCo5
	5C8WRPnUofynF3Y1z4cDKRXaQvJ+dwFUXQToULcg
X-Google-Smtp-Source: AGHT+IE9j2o3T7kEuRYqkKUfbrNoqBKSp9dkYQiKXtC9/BPBj/wfPB0ZC7uXMkUBNXaP91CXX8quKA==
X-Received: by 2002:a05:6a21:8dca:b0:1f5:87dc:a315 with SMTP id adf61e73a8af0-20e06436846mr10046422637.12.1746409964452;
        Sun, 04 May 2025 18:52:44 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:44 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 18/48] target/arm/debug_helper: only include common helpers
Date: Sun,  4 May 2025 18:51:53 -0700
Message-ID: <20250505015223.3895275-19-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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
index 473ee2af38e..357bc2141ae 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -12,10 +12,12 @@
 #include "cpu-features.h"
 #include "cpregs.h"
 #include "exec/exec-all.h"
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


