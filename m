Return-Path: <kvm+bounces-41632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 47274A6B0E4
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:32:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B0C07A5295
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08BC1E9B1D;
	Thu, 20 Mar 2025 22:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FRuP+mNm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A59622E3E9
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509841; cv=none; b=PF4C0vS3DNF7lnENnvrp9PSuNiXdHTctlni0xLREqiX2W30jX+5lDKoLlJr4oxdT77iY14m1xVWQeWbuVTElvPB8oKUpTOopdprABObyaqvpvYHo6n2nTsvrqI9DWon7UnkKfQyh7ecPL4tOb5RKtPH8rkn8Ct4tzE22Wg+vMaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509841; c=relaxed/simple;
	bh=wRhtU1WV7HmtyW5YAMKzExYVvQlkpmnEbWkrVCAu5JQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FDbg8CYgjorXzSbDZDBWGIbxdKZRX2CdJEchWRnfgXKOvvG5BNhFQNb5EINSpvCVy5rOzaGLF8BueH97Z08jHPp1DPq8dyk/KLya0MD3gE6ot6yMB+FwtsK/lbAZVEQWklKnJ2GHVzuSDOlqjIhRpePmQD2IrTZzWnh8/B5DUVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FRuP+mNm; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22423adf751so27863695ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509840; x=1743114640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHEF58QYUX/sH/f2D4AiJ/KV1+OKbOaRN8ddf0N58IU=;
        b=FRuP+mNm5/Fw3XJwadZiM/2qHo9UaniPwaLDQdE16ZwrlIwZdLcwE/+WTxu+Kr0YF0
         63YG+UVEVIaSPR+m/fl4ZMxV+VO7IO4ZjmZZuAwxhVQGLGdW307EwSaadTex1o1nX6Zv
         hn4Xx0Dc6HCKszWGmOijmca4LsbU6f23foieTJT20JYuzP6OvreyaTvWfnZL2ePVtOcm
         HTemVB5P8hNkofttYZXM1HNRz+FemFTlPa3klDEJlaP+3Oaa0i+8w/rrkt/g00m7QLOw
         bfvq9bZ+pe+KpR9TzAkzVKz4NHoqP5lUWZkeD0hDdFXKzJAdrvZe55pmMKPJH1N4frxj
         weXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509840; x=1743114640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jHEF58QYUX/sH/f2D4AiJ/KV1+OKbOaRN8ddf0N58IU=;
        b=U4AYoJUt19EYEHF0aBxpnDUuzBj58oU5s5fLPXkCqCHZlE7kr2DLfzqAEN7mwsd8Oe
         J519gdfCu7hdkEFsAiOshmMcZFBhOBLzMRyYUWQklBZr92GGOowDLexg6Og3ih7TDJa0
         zML845tKmnJlkIc3VCrE4aOmWzHkUW5PPPnEkXV+LQRWeBhxJ6KzqRtsx9L+I8YJO3Ea
         qywA3wIIpA+6KG/1rHvfTXdS1UWQJQz9JDleW3MyV4YmviQOPzwV6hIlLKx4roqLzio6
         PzppVa7vkOKKe+adoDFnrfMlciQGzFTpRvuwykcO/5hR7rTpbdp1dtPDT41GNcPLNrkZ
         ThUQ==
X-Gm-Message-State: AOJu0YzuJO5O2AQ8RrCOGvJet0u4xWGsxr5JkKMtVB20EUuykg4iMkRB
	3+/v3t1sSoC9R5WcOC0k99kK69TL4JUi07gscxhFVsg9Mhul7Cqs9dWNGqddZBM=
X-Gm-Gg: ASbGncvrG6bhO/BW42ar7WQKZU54XQXucQmZyOAgg7luVClRBUEOjrK/ofLs0+7RgZO
	uDa1bPMFEWl5YmCK7EQj6brqwsahZlLiXCMpUCt9N8Cdt6z/hV06ffEmxPsVKu80Ywrf7sOzA1a
	UdrckVpeVooakWpKYC8BKq2ciRMVGdNqTwAzg7OO/P2xdbGs2QYQDc1sTNP7chG4lpgaBUsJMLM
	Gi41ha2T5VGm/xemqzc1xGl2D3980y72kZEQerPGfaGg1B6+nYQtjzMC0lWUsokXv66UIRBf7/8
	dIXfcW5nxa8dN2zCWhtZ8aaK1/HbruQjjkuCY65lMlGX
X-Google-Smtp-Source: AGHT+IGSwMvnVIjoOPD494sxH4RGx3NXLi4VEGe0c2kLzhohOrnkSN5SNch8m4i9VjXaZXHDGWWEXQ==
X-Received: by 2002:a17:902:cec4:b0:219:e4b0:4286 with SMTP id d9443c01a7336-22780db462fmr15563735ad.29.1742509839708;
        Thu, 20 Mar 2025 15:30:39 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:39 -0700 (PDT)
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
Subject: [PATCH v2 29/30] hw/arm/xlnx-versal: prepare compilation unit to be common
Date: Thu, 20 Mar 2025 15:30:01 -0700
Message-Id: <20250320223002.2915728-30-pierrick.bouvier@linaro.org>
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
 hw/arm/xlnx-versal.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/hw/arm/xlnx-versal.c b/hw/arm/xlnx-versal.c
index 278545a3f7b..f0b383b29ee 100644
--- a/hw/arm/xlnx-versal.c
+++ b/hw/arm/xlnx-versal.c
@@ -17,9 +17,7 @@
 #include "hw/sysbus.h"
 #include "net/net.h"
 #include "system/system.h"
-#include "system/kvm.h"
 #include "hw/arm/boot.h"
-#include "kvm_arm.h"
 #include "hw/misc/unimp.h"
 #include "hw/arm/xlnx-versal.h"
 #include "qemu/log.h"
-- 
2.39.5


