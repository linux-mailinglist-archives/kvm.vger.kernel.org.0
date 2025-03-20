Return-Path: <kvm+bounces-41631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94AF0A6B0E7
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:33:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4A62189388D
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D2F22DFB3;
	Thu, 20 Mar 2025 22:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sK5FeHOf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CE122E3E0
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509841; cv=none; b=POmluW9u3/pfB3i+rgSZ6MBPDGCT6isclKN9pZdp/OHyFhYFpDYaE12OZALT4dQt7J6xcS+4px2H6VHjMBG3mlU9wlkrg32gQDCX//Y/J6Lgxp8gmfyvbmpRe+k9KEYs8EkyJgBOvdQhvzyk38mJstlzTPTJvNyJm6HJNiYQSBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509841; c=relaxed/simple;
	bh=1hJWwDIwNSnUHPc5LIm6tXEA1hiSdJCt291iBfDac1E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c+3SXa7YYXUF0rQwJVIYBXDtx0k5Gyg+nqKv/D3P5BIBKcypuAfvScrtUN4jiruW336mzxVbKxJP0g0X7mYjLfZOIIZ3P2O3rIrsfuaOEHoWPN7k7yf1sw3yNao/F7OmBLwJqGRM9MTtHNOnMgS6P2eOOT6eAxSCEitHJlSxdtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sK5FeHOf; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2264aefc45dso37724275ad.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509839; x=1743114639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BPkLAbYv8e88J6hBjHHNYCWMiXvm0PwVbqQ15vaNtOE=;
        b=sK5FeHOfnsLVVxB9m42Gv1b/EjMSi4eVEYDUtnXqVucXtNn+UxZBm/yrdYeA480VSz
         yXZkSE9i9cbykEzigHIi1/Tk3xV1h/6n7rMtiWrtXXh6Umv5X56gB84Hyl2XrAUUrpOR
         0kJuToEBBbc5jMaoGdffB4xwWllV8ntTDl6R73bXfcpcROpDECcUFAWW7HrJSNSdTfyB
         F8ctH5VDN4IShN9nIf7lBzbtguAeFU/no0r4DxkkyaS0j+pLXB+H7M8bCFtfjH1jj2V0
         9qQnOtOo43ey568OKrisVA37BjDXb4tqaSJuyw+0FfxWgLVHojMCRTXOk7W3GcKRYAGV
         xn0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509839; x=1743114639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BPkLAbYv8e88J6hBjHHNYCWMiXvm0PwVbqQ15vaNtOE=;
        b=ORRCRPOEY/9xGjYvKjEXoBKdlI2CKXWF2+fSv1MiRNZ4sHCYNA/BPIqhNcoR/cBRDZ
         PO2lg0wLDk3Kaju2p7Hd9lBsKpga8E52z2VPu7DsLSJjkB5gzUSBN2TX8uZts//XuXJ2
         ahof37O9oaMv/QherfO4HFHAKQ12tmnd8UFUazj8MkHXBDgkj5ehcCUznCfNIw8QdPKX
         amnoaAeP40ZDeh7RjXK9ErCSMHqt5Qdr36+sZgZNLuEnfmMGpXV76yJVQHrHZni0w5TW
         MBlA5bdQRTPtI+jZQOZmO0vOfxTYQGCXwYraoDWYRu1w6GVQvQFFde8/pKRO5+O8e29C
         yxqQ==
X-Gm-Message-State: AOJu0Yx2j9wV+u1wLmcax2E854YIsiCHV3Fr4dwDOwPSoycXYOhtEdTu
	0M/nUNFF4uy+M8ZYUH2Gwg6gi6a9SCIMrqf+EX0k93cCXdsLNawqQPek43eItb/uNCpgmxeVUkT
	z
X-Gm-Gg: ASbGncsMpezBqsxpZbSU+1xSOwlWrwSSSzlP5uCug5BgTgGrNWP1yzH5BfZJG9xJ27q
	YrMCXOl+qHZyDSwOQRH1wXp3yQ2KRAO1eO2BZiWso3dJDieYHxtW0Uytaayz0xtONerbn9jQ4e8
	PyW+iC8KANKVfGXDmtlP4gvOgw2nHCh5d4bYIkF/j/ww430GpbZDTEZvnh3jqNXc03piArP8+kL
	i4gehRauqML7extxQHTQG9sYEaSGVkxlYNpkZ3/huLydtR72hcGklNRUjJQ2qmA8jae18rSPPwq
	IMKD+lGuR3e/vcRemJZ1ZJNK2LC61/gLGxLeNDW69W3C
X-Google-Smtp-Source: AGHT+IH1IZNZsqPktc71rFpZr7RFxZkc9846438DqvW/sf3mREIxsV0YuauOBbHxE1Q8R7m7oGcTUw==
X-Received: by 2002:a17:902:f709:b0:220:e5be:29c7 with SMTP id d9443c01a7336-22780e09686mr19861315ad.39.1742509838882;
        Thu, 20 Mar 2025 15:30:38 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:38 -0700 (PDT)
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
Subject: [PATCH v2 28/30] hw/arm/xlnx-zynqmp: prepare compilation unit to be common
Date: Thu, 20 Mar 2025 15:30:00 -0700
Message-Id: <20250320223002.2915728-29-pierrick.bouvier@linaro.org>
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
 hw/arm/xlnx-zynqmp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/hw/arm/xlnx-zynqmp.c b/hw/arm/xlnx-zynqmp.c
index d6022ff2d3d..ec2b3a41eda 100644
--- a/hw/arm/xlnx-zynqmp.c
+++ b/hw/arm/xlnx-zynqmp.c
@@ -22,9 +22,7 @@
 #include "hw/intc/arm_gic_common.h"
 #include "hw/misc/unimp.h"
 #include "hw/boards.h"
-#include "system/kvm.h"
 #include "system/system.h"
-#include "kvm_arm.h"
 #include "target/arm/cpu-qom.h"
 #include "target/arm/gtimer.h"
 
-- 
2.39.5


