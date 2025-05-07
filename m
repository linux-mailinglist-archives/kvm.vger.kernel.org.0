Return-Path: <kvm+bounces-45801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 47552AAEF92
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:47:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 083B8B204D1
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1FE29187A;
	Wed,  7 May 2025 23:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xwox9BT/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB5B293B78
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661395; cv=none; b=ot5/u249Ln/yW/B76+Q7dKeiEzW/JGwa9kb2pimH24SWhaDZqvmcilpk5OZNR+ghqN60ZxzJYzejVpn7UciTJX3yq68EBFQibb0O5cSdtvjE1Cjs7yXH4vro4n3yWeelvcIy8mWymSWkReKTn4m5fjazBfyUy881MswyUxPGpmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661395; c=relaxed/simple;
	bh=jmUdrboFzyga4mrTnDHClA3zNyFy9mK8dkNEdQa4KPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ek2WBQxEk3HHXqUgjZ5T+yMv9IyxVGZGondK0rYFsL84OvQmRoT5kYhBOjeoLTGWhuI4Kos+tCPvfG3++ncO2fo5ctftz+ZWBXGi+SQBN2fFq/ZJynBNcsY321bA2D36gEWDJlYQ2qEflXDwNgUk3FN9bQ3Ioea/GBlgE67Y+wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Xwox9BT/; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22c33677183so4681615ad.2
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661393; x=1747266193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oONThx//EO5WSiuREF023HuwIIuJ5yNwT7cwhGAiXZE=;
        b=Xwox9BT/PaZhhBRoTF2VmtW1v9m8Gb2cI1ol7OEOA/JWTZyxjRQB3qvTZNel5Nvwz/
         zKWpJrp17si6t2Da+70d/yhMAENfIxCQ63/FnchPjMEltIukG7A2x/7oUnLYfhJ2GVeo
         bmkHx2dfBduAIg5RQE7u00ri8ImS2ERLPSgoMjMKxPDQM7O0g3AVAY5OK7G8r2FmNPuc
         L+fvdI/HV9hTFdPNzHEtTJIlOrla4Ez/t3LEdEC/sKSrMLRyLGqwk/M6Hro74v3E58wd
         0xskJLIozj7sCRJxlJrxgz2A1Iy9bJYDP2umBnILM/j5imf3p2sUPB/c0zVfgDQ37KQv
         GPTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661393; x=1747266193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oONThx//EO5WSiuREF023HuwIIuJ5yNwT7cwhGAiXZE=;
        b=uhyFlRcJOWijqqL1b8GSUwWJxIyy2b+ltBKgvB6zVJephd5gdG48IhH8OWqKos84pr
         hMDgQm3eJMNuJeaRUy+7zr4BiCZRBSAiIHb5vilQ/VxXFW2LD1lp3smZ0KuQEXH2BZTq
         kdqMNxjVX9OepbDIOCXj3NBgk4fR2YOKi+5Ta5XbnnkLq93QRCXQ9PqdHOXTkFGhUiPO
         pKMbzPyXZir0cc3K8CSijd4Z40+gAxB7Nic69seS5KlKVgEoN1KhO/HnNKvSOZjeEmM7
         mgC+1+AH/GSk6/rOONWPHmsz9gOTpzA1m+nUug7Gp1Y21+7ujX63OMkqQ4abcggl3WYR
         KYHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkNsb2fEE4G9rq/LcIjIBIDwwJUdHitKpNcxPovo8boNotb8joHXoDvBAeadD7pjOGk1M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjgjXabbfD8kLclT+p5dqVYnSzv8DlRwTfsg6QmVOZfZgvy1nT
	xKnuOnnhPlsiWC4aUGqhBtRNdIg5i9ip3cFk39Yj/G1jkgymezzUjkV4TyMMELM=
X-Gm-Gg: ASbGnctxYZFFhFv/0zM6+mLArhJ+RRyZWL9Z1k8L5SRK8Y1D9edGHIyMo8gSkbe+QFm
	hk0r7vg/eL3Gm3Duxsah5c7V93DY1kjJ02iInPf5L17F2CHbpqb2PesA8HtwSHp643GOSBlj9zH
	4TOMd48jPYH8ZUxP0dHIrga8GzdPsfc50IdV87oOoAar0kVX5Nua46JDwLjkKHu5a1P5yV8ABOS
	xFj2urFwopM4d/vKStI49p5Cbfygi2gayKYQ9DYVxeXdCQbbyhd7G8hejBR8m83UapEZ2c/iyAq
	+T0iBChAsqAzTIVkNjcHD5WMI8zxv0mLT3GJ3EG/
X-Google-Smtp-Source: AGHT+IEITMKovnAbZDNWcvLBKoaDhbNrpqSwM3KB7CHEJv8zt/wd/TnrW9sZ9exZAx7o97xXo3VB+Q==
X-Received: by 2002:a17:903:40cf:b0:22e:4cae:5965 with SMTP id d9443c01a7336-22e5ea8cd1fmr77512185ad.29.1746661393321;
        Wed, 07 May 2025 16:43:13 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:12 -0700 (PDT)
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
Subject: [PATCH v7 35/49] target/arm/machine: reduce migration include to avoid target specific definitions
Date: Wed,  7 May 2025 16:42:26 -0700
Message-ID: <20250507234241.957746-36-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/machine.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/machine.c b/target/arm/machine.c
index 978249fb71b..f7956898fa1 100644
--- a/target/arm/machine.c
+++ b/target/arm/machine.c
@@ -6,7 +6,8 @@
 #include "kvm_arm.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "migration/cpu.h"
+#include "migration/qemu-file-types.h"
+#include "migration/vmstate.h"
 #include "target/arm/gtimer.h"
 
 static bool vfp_needed(void *opaque)
-- 
2.47.2


