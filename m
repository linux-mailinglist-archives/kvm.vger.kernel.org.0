Return-Path: <kvm+bounces-12735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D7FD88CEC1
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 21:30:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FEBA1C632F0
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 20:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F171422D1;
	Tue, 26 Mar 2024 20:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZwI4caBg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741391419B5
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 20:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711484677; cv=none; b=KHEyoj3BEnZqMHRY/CNyltbfSrnDJVYOsfPmiWo1tpcVW9gIesrxYoG8kO3aELhnavvteDPA90szis4y//0VzX36gezHHNQrxgI9K9QfmDIFBSVZJtec0zoc3x+4Bdm3zQx8IpmR/KEoK7pcKcYem1hoHjhErtQijB37ztRH++E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711484677; c=relaxed/simple;
	bh=Am9mgtoHcGnWtdCizLM/7gnev7AKEoFyTXCt0w8OihU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tE8pSxUPiC+zS5F1h63uBdFboYDN68z2sMNPEf7RPLkJpHzA9tUMGroys8ItRl1DnHXyocJI/OyOgftktaEhM8zPCXh0MA8DrW288PjXPlG/KRiPK7KH4B1OMnp9LWOywsidPAzIy9ofUc1Xqwga5XTo2JfIYDnOtcwyeLQFBvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZwI4caBg; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a472f8c6a55so582751966b.0
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 13:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711484673; x=1712089473; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kPX/MFF6KoADKZHHbndNcATsgZ0auA5V8bT6Dm1+lpQ=;
        b=ZwI4caBgse+mqgC667cXqOhTVuVP5uEQejse4B6ejWSAelS6CNWgkq5jbsCXY6gklO
         kvd/vR+aUcRvhh8HSq85GthAFxn6L8QliPcuuvPJzl5TVz4AsdmLXiQcwtNas4AECKeG
         62RsjOJWgP9+nfbiwlgDDdh3gOb0IKNIdv1iC7/5wtHObtyaAcc1IGuRzTrT1pod04hu
         CwiTaErX0ojrgGWEgAUap1lfQZ6lwEhOKyYwpRRz4Q6P0RcBDuKa42MCA84GKUjyeWpR
         O1AGH2QrKtwW/AHwnfPBiRxSjpPBI2X12tiQ7O/YMTqaXvII0kmC4nx2Di8q2pZWilmD
         ID/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711484673; x=1712089473;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kPX/MFF6KoADKZHHbndNcATsgZ0auA5V8bT6Dm1+lpQ=;
        b=YUSJwIqveO5YWgd8NqH7UxL6XZzIDkIgda/dBPwIVZEsl3M81kvmiBW+KtHRBxP6Bd
         8u1MZU9jwVe8pdetUZ6zl3W+UdqumnAodiGjMxro3zt9TE4BtYbgqIUGYFTly9RXdHIk
         f7GhU9+5tkPdqAYyf/FwKEEbluEn2GZjE0Zkv3Mox2dJ22jFg2qQo87RMNBh1mgY08w/
         hdw4Qr1X/E6nAuWqXys0W2cbf1HfBRop8n1nnMB+6DCjhB6XqCAfXMuCvaFKbmN9IQSP
         bn2eOUudf3oO46atTE5o2Vr+Av5Gm5sC2zSJsiWA0tfwkAbHi//QbO96rBk3gqrFt6i4
         V6xw==
X-Forwarded-Encrypted: i=1; AJvYcCXcEGPzdJqv9ejKYc6KXeUY8P1o5ayJOsgZGurlk8rgj3FiThn4ZlfZJBDzTrDPdSkZRIh1PzBScZVO1uQVmKPlRJJH
X-Gm-Message-State: AOJu0Yw8tanIurRuIAuiIW2YBdMnIH6OgpvRNXM2a35lwdYWs0qKQ3jX
	i5NeUTMZslXxQtjNoiQfXr4tg45Icg1a4Z1N6KbWdD7A5NVVwIXfN8ALCmHJhBU=
X-Google-Smtp-Source: AGHT+IE5r/pwonCznGAPpl36QYFlcuHgl9B4GNv8DI8Hb4mkk/gPdMTw9O4OZrQ7z290iSGo3ctFmA==
X-Received: by 2002:a17:906:2c5b:b0:a47:5209:3781 with SMTP id f27-20020a1709062c5b00b00a4752093781mr484700ejh.55.1711484672833;
        Tue, 26 Mar 2024 13:24:32 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.222.44])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709062b4200b00a4725e4f53asm4584492ejg.40.2024.03.26.13.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 13:24:32 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Tue, 26 Mar 2024 21:23:46 +0100
Subject: [PATCH 16/19] dmaengine: pl330: drop owner assignment
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240326-module-owner-amba-v1-16-4517b091385b@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=605;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=Am9mgtoHcGnWtdCizLM/7gnev7AKEoFyTXCt0w8OihU=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmAy7ZiLh5VPnk/RMDsZGr8iCFWx+7m0xqeCSmY
 z3/P04bZaaJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgMu2QAKCRDBN2bmhouD
 1/r9D/9kvfKgDYg5nRKfG2JkKlSjbG1QwJvI9/ipoDbprS6mvTmLcoHaj1CviRt2lrY5IjFgSdP
 j61qJkOZk8Qbyt0xkrp8xZk9c/aVOr+a5y7S+7C55YHI1kuOZ5HvPTp2kaWlqrlbFzNLF+FagYG
 DvzvnjYjJAZH6gqGAN1mLP+M+7peyjv6bd7GqoTzz0QD3ca4oIGx1BsyWzV36RzCmDhwcL7eQG6
 kfTIPmG+yv+YUKWfOTBpQqnwXFtdPgIWZ+uOdw5xkCjIp9MSy39ixpzY6zvKzZree+jUeD/DmmF
 fm/XVF6ygl7GSDyxs0jtn/jWFoGxs9vtDtbZTwuHsr1+JYnNYVmetHZvXsytFRLkyEURM06N3cp
 7l7fHIdCfrb9l9uL1EoJvj3yAXS4y6iHKiFytXIiBNBmfGtkg4ksAw4q/30xAxvMtjm2RiZ3n0E
 9AaRRoDPmnvAhVG2AtIySJ5N37V/AiyVKR4l9Oa2Tqhqi1HEZmYU5WJuubfVte6YBbsAOg9WRMG
 Zyb6OY7oG7luImjoAjB1vYRNQ4WXFiD6W1alucifK0FpWURvpO+UTp9hTD1rKqet9sDkdcIsq+y
 q2B3AW0ewfLgxmbl6rqDCbDx5+dyTTUoacS+fe945Gv37sUmf2uFIecZt+HNxwGdobYHzS8Nz1Z
 4APs574QJUP7Oyw==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Amba bus core already sets owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on first amba patch.
---
 drivers/dma/pl330.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 5f6d7f1e095f..b37ef28bb417 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -3265,7 +3265,6 @@ MODULE_DEVICE_TABLE(amba, pl330_ids);
 
 static struct amba_driver pl330_driver = {
 	.drv = {
-		.owner = THIS_MODULE,
 		.name = "dma-pl330",
 		.pm = &pl330_pm,
 	},

-- 
2.34.1


