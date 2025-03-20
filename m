Return-Path: <kvm+bounces-41613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C0BDA6B0D6
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:32:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ED7E985AC0
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0961422A7E7;
	Thu, 20 Mar 2025 22:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WlCRT+ay"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97C122B8D5
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509826; cv=none; b=M5uMYMfvearqYf+cyiEpLyBaQowai1nWJSS+bqQnfjuTBkSe60GWPoLfiZ/5Qj89Uz596TBjenrLeVFnDl8Jg6ourWgG70HGBvSc3V75aU9AwWlE4pAbm2exiMgmQEj0vxUrMhokcM0UT5OKwPWdh3DWTSfGz1ryqEMrQMOSq1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509826; c=relaxed/simple;
	bh=eN4Vn2FO2qwJkHcwRYM6IWslOINY+IYZrRLEevKRNmY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WK/TJxIcsDn4WHrSe1WUUiXcGKqyw63iVQsUvER/3OzVHfecGsIS6NTgoAgeEtilUUJk03GIgZxBD/9aFAE/UeyOmy/G+3NI2O6iWIjoXGmcSLzyGCVYlPMMEgc2UyJ2X/gUSpe7wTyo6WXVcyZmA5Se6NAMoH7HbN0nXLOJ9oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WlCRT+ay; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22398e09e39so27776005ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509824; x=1743114624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eCoHq1TF4OuerztqGd91anfr0TMnNc3lHBgW4hpQzhU=;
        b=WlCRT+ay3xijM+2SLM528FKaYKSLyLdxMgf+6eiFnp6E9XIpaINTuMdMVWdLv+96Wf
         fZ4TANo+8fLB9X8bGXkE8nbGdCnZTOMPJFrPlXUdSBY/EvQ8lV1GfBWoEr+a/ZFlyB+X
         w9TbsNAgKVDZlPzM4H2tJTxDaBUz25d3RE9WMhf8Ji8xfmtgrHdapShKFJ1brNwRiR8/
         G7a46IpAm3nR2I5WAOhkJ5GThWcO4NkDrKbhV8hSu9TUpioVjZSlFoMOAR3s12Ke/9vk
         k6frxch8Yj22Hxlb0bxGcaegu7pBt5zIij2SOBRek7mGAATj6iHRLrw9MI29E0raHVV6
         uBsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509824; x=1743114624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eCoHq1TF4OuerztqGd91anfr0TMnNc3lHBgW4hpQzhU=;
        b=veOC7vvoxtVBFwHz6c/TatmUwxE6jdnJtFF9vuzEzus2tTMrptM4xY3haFmOqTbdjb
         6XOlN1A5TLjmgCnIq5nblsf15LUTQScfyn/UAUratjtZlGY87j052e01T1GARrmnXFJw
         K/+E9Ph1/bh6c1g6yX7iOVXvmVb/GTBU6lGfI/HDwJhwgIzxHk+LqDpiIc1ZE4jPe7oF
         lmYc5BdNO1rTvqHaeWwdKcKFyLnl+6VQ8j5dm8G+giV7ODYt+yMqfV/9+gZO4uXRbBbq
         2eH4HV3tNRFLomj2WVq9UNAt6wQ/za4r7tmfSZW8SEx1wh/+HT7mZMyu4Hwy9jcnNTV4
         Fj/A==
X-Gm-Message-State: AOJu0Yxx6vc/T6dCRCYK0G4nzxntjcLdEuZzHJFKSDlUgJwzB53NcslW
	cGgnRkrHqn7xJUhCh1KsMkkqto9rPmMBWbAbwWxCay6AKcdCNFkl9H+WO0eeFsI=
X-Gm-Gg: ASbGncve936FVb1rX0SlbeIFBAT7rurrgHA6ChOQrCppLAUUgjq6Kz7txnhEMOETlaR
	2DLRS52k1wyVwgWAsHjOlbTvj9AUvcRt0bxbnmzlVCywcRavBnJ3IeweJniXvLbp9Ke2rXCztXo
	//ifVj1K4qpXuOODB/uhSBZy0zwCWIlmHSYu5sDxLgPDoO8fa8zkYErD+019EEJJc9Jc7+QlqlX
	grR4nrOv4XdgkfgWL2ScMxHyW4JkUxxZkZ5m9ZEEca/s3G1Cia57ZiAlBvRiLoL9/nn3MsiqtwL
	S9CatzyAv9PBoQGiJqdxUMcCTU2zoeTtXA5Hy9YiLbIY
X-Google-Smtp-Source: AGHT+IGI4h055zkEpag1yC+Lf9SXKqGgcc//U54r/YtVGXHhgxJCu9SYna1AurwwJwuLFCO6BJkVVw==
X-Received: by 2002:a17:902:ecd0:b0:220:bcc5:2845 with SMTP id d9443c01a7336-22780c5350fmr15267505ad.7.1742509824135;
        Thu, 20 Mar 2025 15:30:24 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:23 -0700 (PDT)
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
Subject: [PATCH v2 11/30] exec/cpu-all: remove hw/core/cpu.h include
Date: Thu, 20 Mar 2025 15:29:43 -0700
Message-Id: <20250320223002.2915728-12-pierrick.bouvier@linaro.org>
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
index d4705210370..d4d05d82315 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -20,7 +20,6 @@
 #define CPU_ALL_H
 
 #include "exec/cpu-common.h"
-#include "hw/core/cpu.h"
 
 #include "cpu.h"
 
-- 
2.39.5


