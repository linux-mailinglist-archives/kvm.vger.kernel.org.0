Return-Path: <kvm+bounces-12721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B94588CE68
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 21:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C7681F81BC0
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 20:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A32913DDC0;
	Tue, 26 Mar 2024 20:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lxx9VKCR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5FB13D88E
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 20:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711484650; cv=none; b=ksfw8oXyVe6fFRwVMFiQ99/1soSt0Jp+FqpbpzPPeq4n1LexAi6YyvhnCVK1NyZtGSRBIpkz/0cm0PLEGaYgZKQlNkoPbB8buRI4a5cYC98s9XpiuBm5UktSel/2th8eGr5JiIs/y3kzIyJ5GFQ1eXrCxYoCjGVidyc/RPCy6fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711484650; c=relaxed/simple;
	bh=0tCOGOTEtsk1MNOC81cBK1OFb61otkPtGFYTYNaDfAE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tTmLlHE9InU/HZCQx3pUstd6DFHY5GLdDhtIUpkFAMbsz03Sl+d9IaOvt/ggsHYoW/aryCPOUNlS2AzagahWnqVHQLu9LZJXacv32u5UvIDw3myaQzOgPkiHUYseS8WPls1rFZkcJl2R4A9TJYgne98cVmGrWYzRNyFjMte4EDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lxx9VKCR; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a44f2d894b7so734986566b.1
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 13:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711484645; x=1712089445; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iXiHjg9z5WjtRj7FyN981q22Cf3/qPHIvV7q8gsMVd8=;
        b=lxx9VKCRGgwF9I1MEO5grOEHwHjui9tggGBbRlcp+olyXB2bGDq/GmW89BRkgTBKim
         xoKwPCBjgKHXfC2eL3ZMd/GlDzeGwv4NM5C3Gkls37FOkvacMC3bJzw2pho2JR2Km5R3
         /44xsuJ2A1lLvA/RsuUyJfTAoDuXf+kuqAFql2LQhVQuVZ2u8pIgJgwN2JGyZ+nhx9aX
         2I2RboSgFkkdDxCHGWM8p7ckI0CBqKOKim2mj8P34wPCQJVErfo3FMVtrHDD6uO/rJg7
         XzfVHcFsZ6Nng/WdsG8QAfj0hKMJrX8lDRHB0YDL1xUcyFPH99npo7IFzveWojRTuBSt
         7D8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711484645; x=1712089445;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iXiHjg9z5WjtRj7FyN981q22Cf3/qPHIvV7q8gsMVd8=;
        b=i3Ax9Flvcbgcg+OmlN9AUj066Plh+DEVUAQ75NfwpASM/mokwgV/v0FPqGy6pxstzL
         hg15wCO7rrHmjfGn3wYFZlMA68REESsBaRvOW4FxTPDmO2rDOTk3euR6GBuKcc21On70
         JIB2Bm4ZAE2V+M1rBNEAIsI16hX2lpoCTKbCp2mESokxDY3cvuhfcQN7UdxOILITYWVK
         3yznV5cKWnYdI3L2SUQdvc+z31HytqfpaTlISg8+06SX2On3awm6OxK9x5/Mm+rasybY
         nYNv0VlHISU4w3mS8XJOaEgyWhegBMQvrP+ysbVHEM7VB04vFD6mTFIP1cPkiqrsChKG
         bZJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkhL1saNW1ScRZgUTyB4kl0PeVE7CqonlaRuTl//fz3x95clswlxC3/oDq8PC3Qs23Usv9eYtAu8sowdrhPj4mrjAH
X-Gm-Message-State: AOJu0Ywk688xH2HI3we+ya5jtiLTPz6mM+liT0Y7MIXktKeDYly9qY//
	HHIaqOTqiuVUh11hz/iVN0dAete8kKaN0hq7m1DxTrH+qXeIJnQ1aVPjfITSdf0=
X-Google-Smtp-Source: AGHT+IEfy9gjsew9ETjHc7FFOuJT2jM+L2jQiDOYJkSH4p0nwSV/DeAW7YcWUd59qggx/U12Voj5nQ==
X-Received: by 2002:a17:906:15c2:b0:a47:35c6:910c with SMTP id l2-20020a17090615c200b00a4735c6910cmr2699146ejd.22.1711484645499;
        Tue, 26 Mar 2024 13:24:05 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.222.44])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709062b4200b00a4725e4f53asm4584492ejg.40.2024.03.26.13.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 13:24:05 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Tue, 26 Mar 2024 21:23:33 +0100
Subject: [PATCH 03/19] coresight: catu: drop owner assignment
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240326-module-owner-amba-v1-3-4517b091385b@linaro.org>
References: <20240326-module-owner-amba-v1-0-4517b091385b@linaro.org>
In-Reply-To: <20240326-module-owner-amba-v1-0-4517b091385b@linaro.org>
To: Russell King <linux@armlinux.org.uk>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Mike Leach <mike.leach@linaro.org>, James Clark <james.clark@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
 Alexandre Torgue <alexandre.torgue@foss.st.com>, 
 Linus Walleij <linus.walleij@linaro.org>, 
 Andi Shyti <andi.shyti@kernel.org>, Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Vinod Koul <vkoul@kernel.org>, 
 Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
 Miquel Raynal <miquel.raynal@bootlin.com>, 
 Michal Simek <michal.simek@amd.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, 
 Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, coresight@lists.linaro.org, 
 linux-arm-kernel@lists.infradead.org, 
 linux-stm32@st-md-mailman.stormreply.com, linux-i2c@vger.kernel.org, 
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org, 
 linux-input@vger.kernel.org, kvm@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=732;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=0tCOGOTEtsk1MNOC81cBK1OFb61otkPtGFYTYNaDfAE=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmAy7Ow6S6gU7K4xDsl5z8ZYW2obxkxWcKgTa9z
 D8mHyRiajqJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgMuzgAKCRDBN2bmhouD
 14LtD/9FUnFagmEFO7sKZPZnAcq1cBTmy/uTlAtbqeDP6H4YewQ8W9uGOFTYp8fC8IUnU7uyY2Q
 8ZnWnr1zDTQ5IHHMNTOCR0Achdhw9VSQQOSPwH5J0Ao9g7XB52Y2st0OMpx1UJfFUFkBVQsyqti
 gEQ24BTObJeM1nnLCARdwUTLjhYrZjV1cpBkR2revehYTsFJMckEWO9F0mhkw96si1zGX1B7YiM
 +BBbIK647s16FHygeAFUSNHtoJs/Ln2mhayP/40EwBbmfx2mZL4mHsMoNzHKzqHRbAkBQCk4GH6
 pTAIThqPv2TnYrVAjNKWHlOe35c+oSID75/EXe0HY9M4PADM9nWzucSCVtQk22IVJ77okKqkHmd
 Ef+xUKR2Mtw2yRT268Pyp5emSM2wXId/BDxoqwrvQJfxfrJJBDCVRAzlmjB8yz5Hq+ZnXgfASmz
 lhWJo32QM06Pb8dtzaWO4J0OGeOHu/bvLKNCUS996msar7BNqnTV862YrclcjvslGAVq3k4Ufrg
 tI+qt228BBRKLgbw96RP1WU4lrXpXrQZUWAjgGIr74ojyuYR8/w+kTXVD80ydtgKGdI5Qc46TXW
 9IcpF7erQW3bWFrfSb7yJKJUPe1Q8o+s0n0Ml+8eNJUaqi2ivyRh1dXiixULJSEfdkA4EnBW792
 sPlFZr2NZ9dt+VA==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Amba bus core already sets owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/hwtracing/coresight/coresight-catu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-catu.c b/drivers/hwtracing/coresight/coresight-catu.c
index 3949ded0d4fa..375bd0d89b0c 100644
--- a/drivers/hwtracing/coresight/coresight-catu.c
+++ b/drivers/hwtracing/coresight/coresight-catu.c
@@ -590,7 +590,6 @@ MODULE_DEVICE_TABLE(amba, catu_ids);
 static struct amba_driver catu_driver = {
 	.drv = {
 		.name			= "coresight-catu",
-		.owner			= THIS_MODULE,
 		.suppress_bind_attrs	= true,
 	},
 	.probe				= catu_probe,

-- 
2.34.1


