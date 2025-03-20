Return-Path: <kvm+bounces-41612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7DE4A6B0D4
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:31:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A808987691
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A2922AE65;
	Thu, 20 Mar 2025 22:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nEQ2maCd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E49622B8B8
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509824; cv=none; b=dbYhMtnAIiix/LMtrc9+1s5WxqsKL2ja7wWv/rv58nhUfnBmsEO72jVOJXA0aKmuLz1kxn3S+iZ1GnXNMEJNZa01b4Opv2DMGi2tE6/aSGa+zdFMmYvDJ0oVsNkfldA995kmbMcEVmqYBtWZDDJvCjn+TJDpNVRNB6SgqpaU2FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509824; c=relaxed/simple;
	bh=viBJHPE5h24c9XLrElI0HqeRKp6IOIG8sEPLSz4WAfA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PcTgGbss2tlaD24v7czc7kXL3MwdJJP0kSDZgFQk16ITv8/Ae2wbb4wZjtmjETUPaDJai9LSPBQx/zZdlbWNJmoi9P0V2Y0J7VGa4Vew+MUqgu4G8KbJbIGJT3AORwnkM7d+LHhd8N+4FilgyG7UiDtjJdtOzV/n+ObZI+AXXcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nEQ2maCd; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22423adf751so27859325ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509822; x=1743114622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=purOXWOR3Fj7UU3csfI8HYdWZCzZY8lYxjlph8NWhiA=;
        b=nEQ2maCdSxFqlIxMRV81UHpe5M99SyRQtspjeB+5hCtPaAjWuqkVToYAI+nFbMIfPt
         IowF1lEPSyHK2LaEo1Z5JYpQZRD612xJ7caBCKqfd2e8gH49IPbsnzKRrYhfuxz69jOX
         JONMsQXuxKMc1iMYdjfWnvbf2htFowv4vLyF3adFsWIwC1W7h/w52KmybCYSANdVXpFF
         PL9GXf4tToJrCS+71jf5gfaLZRMMgwh0oNc7HE1ijKiHQjMWHLG76BYGFaoBT3JXWGUk
         /qclQgSVfIdQ/5eeQvgImOuknLLTaJq8dBtZb84pC4r0U1RWT1Vg4juXloIcxXMCpd0u
         Lclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509822; x=1743114622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=purOXWOR3Fj7UU3csfI8HYdWZCzZY8lYxjlph8NWhiA=;
        b=vdWZPmxI/rJx4eyiNNC71l3ZQGngC6o5c66XRN3UdnY06f41UEN5qLG5DDQACPPVLV
         bVrUhtm9e4WGhqLNm3HjCt/RYJx7PtDullgY9+9M1v5WgQGwsbBFLlSBNviinSSo2Zfr
         Fxy01inccfnp5VjeUWPT6+ZXeKnZYXxQq/HRuTbcTMrnIcR4UzUaBmpFCkH1C3Tt6UOV
         p9xcwKSDzZUMGaKwCB1xjtv1t2EUtsgTU/CDVPWQNQM93hd1mZf4Jg4cfWo8s/IF0RlI
         yLWW7rAiJITvnk+jrVxI74oy8A9mnE6qFLxseCct/QQwVF054I83aIUF8UczgTCeDWjD
         bAZQ==
X-Gm-Message-State: AOJu0Yy55HLdvpxvSPkHCVQm7aGH4vbeVq19vwd9tChPRcKPdmslkzgF
	Jtvz7o9JUneABvNFQNw5No34mS5Jx0ruCZD2k9p59OYbhoGrz0BocGnU1gkoiRQ=
X-Gm-Gg: ASbGncuXOGhE5p6MijVFrSGOKXd+9PwuW98nUNsBs37Z7nA4sOWdTotkIlU67ZvV5NN
	Fdb1FcpDds7PzwilYL/XZWti2gLPt/Bpu4/3eLN+pvS4k1EWOT7aJ+9BoPS5anQbo3hzZ27QI3Q
	0qXrs3yCRuLvg8xE8+JoiMukuiBjvGX4s6uCN5qyo4ehfc7COiPmtLm+eDxeAVOOhXCFnyHWplV
	1xM0awupqqtIQiWJoTIe1Ha9hrWs6OTG/kzjcqG20oio+NOaPUaLYiSzvL1PoisAy9+XOuAG/9L
	95w2d98jrlUE0QehuigueFmMA11D+Vl4bM23/R4Az7Sk
X-Google-Smtp-Source: AGHT+IHaNLh4H3nOX0n5FztI8RzThHS/Cd+JnSg5LqxEttWiRhXwEic0w9kPLtKsb41I99998VMKRg==
X-Received: by 2002:a17:902:d4c7:b0:221:7b4a:476c with SMTP id d9443c01a7336-22780d80176mr12012615ad.18.1742509822336;
        Thu, 20 Mar 2025 15:30:22 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:21 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 09/30] exec/cpu-all: remove exec/cpu-defs include
Date: Thu, 20 Mar 2025 15:29:41 -0700
Message-Id: <20250320223002.2915728-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index e5d852fbe2c..db44c0d3016 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -23,7 +23,6 @@
 #include "hw/core/cpu.h"
 
 /* page related stuff */
-#include "exec/cpu-defs.h"
 #include "exec/target_page.h"
 
 #include "cpu.h"
-- 
2.39.5


