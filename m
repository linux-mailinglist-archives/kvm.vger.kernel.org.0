Return-Path: <kvm+bounces-12723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F68F88CE73
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 21:26:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A39E2C7F74
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 20:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7CA13D537;
	Tue, 26 Mar 2024 20:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="msmNa5+W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20FD13DDC7
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 20:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711484654; cv=none; b=EttWgFTb+3uKg0sFYBm5zfSOqXSTNhGfXJEdmTYAiPYiFhWBYxUz685/3ZDp9cETCcDMXxsp32/v6Fu59l/f5s8h4jxyfcH/50888SGwUxgrGqBxBkcuXA8mdzLfF1i6pXkUhurrtD9Kq6+wfxwk7XTdec4bGxKfcVl6FY5Yizo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711484654; c=relaxed/simple;
	bh=dLMLqJMRutmhpAj9QPWjvHyuzryPfsbXssGz64hwg7s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jUjITn3/8nn+RUkgk5Yp/sd3/wd5oK8Ly9qbT71A927R23Em3sKTb/utka3esKSFEMeY9uk7eiXOIguKwL2q8c+0FjZF9JB8DwHyc8XgaC9A556b1Pf6lb+DnznhTVvs4WKyJwpCcK7tcW5hk6tavnRfOBYOsFWlhPAOQJgfmFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=msmNa5+W; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a46ba938de0so803395866b.3
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 13:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711484650; x=1712089450; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MUoAEonqbq6mZXdrDqe4h4/X1Y47oOMjA1M1PU77dgA=;
        b=msmNa5+W1XY79AFfcKzvMG7gD8ab5FVtVAGSi8KXKAn2eBLpQDF/8X/1LJuOXkPYHo
         ic7tzv/JC/GpLeeCKaAmB6RyovFa65q8RqerqijZTGoQQhugk9oMPo/CiHyGJvnPE5Ok
         nDfbV7j7IFRjG1waaewVtOp2IUUNX6Ar8UlkwHQdplNtjjHSiRbWwbU1oVu1SdRioAX0
         0lfPXfTVZPmDgy1I5eDbX6M56umJRvMF44F0LuuwC7/20z0ZmhEmxl08nflcdBEzpWaS
         KkEbOkT/wRiD7cIjpD5Lm0y9GuVCxSXxspBqnIMyKSyIwl00rjs82e7OSoxHbpYr13UD
         8Gpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711484650; x=1712089450;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MUoAEonqbq6mZXdrDqe4h4/X1Y47oOMjA1M1PU77dgA=;
        b=APGNfxNB7dG3mq6UZztck8VKOS/aabdXT2CHf8mADHANo6V1+98FdFNQr8WaeAAzTC
         x+nbt+REO1noWtj6yIUHkDV5I/r43M+GHvslP4OCMCde/0sRRr4poPM5vqqS2vt6p8iN
         t22a7pNV6GOyytIBkIdPLk07aLOE9TPk63eiaDPxjrUVndIE60VqntWvN2IxFODQTDft
         GiMlTtqsxLxEe1P+526VzhYku3ztg/U4CFcfBiKoNRiKmSAuoSA6+LE5ltOtxwL20Q1W
         VeIxBrOc1wpNzQoTynSqtl70chIngXaJmDKI9jxmI80qFZkzL/Ltf/Mn7LNkgiBr361j
         Y/Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWLWcxbbs/NAg+k5Rymwbi56yKV3Mvp2QogkzxHurcPz3UElma++Rk4DA6J0gMbsbGBiNm564EMffWsNl9UorFtCM6N
X-Gm-Message-State: AOJu0Ywtbn+y+FYNOuavS3VA7w5gWQyoxTPlSTTwREaW1h7XW+c8EJ53
	tfAGBb2OB4p3M3q5uUdT7JmVhk8TiSsfsksMwq63INMbDv5QI0n3cGj5pyo37qQ=
X-Google-Smtp-Source: AGHT+IFktIMOuGQr83iXCOXqE8Qfk01qdlT5fhCvZP9F6Upy1Aunb2VLAuZdlUWX1tsm3QMok6//tw==
X-Received: by 2002:a17:907:868d:b0:a47:5351:e8a8 with SMTP id qa13-20020a170907868d00b00a475351e8a8mr3611593ejc.33.1711484649819;
        Tue, 26 Mar 2024 13:24:09 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.222.44])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709062b4200b00a4725e4f53asm4584492ejg.40.2024.03.26.13.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 13:24:09 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Tue, 26 Mar 2024 21:23:35 +0100
Subject: [PATCH 05/19] coresight: etm4x: drop owner assignment
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240326-module-owner-amba-v1-5-4517b091385b@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=773;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=dLMLqJMRutmhpAj9QPWjvHyuzryPfsbXssGz64hwg7s=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmAy7PqZxAqSLMTcZ+iIF2WgxJbOdjAERugmhHY
 Ri9uz+X3quJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgMuzwAKCRDBN2bmhouD
 11YBEACKdHpjBts0bi85xrrB+V5bm9+C4a6btkKtB6exqkvpm4CJ6/J1wcZaqXuGclO7BcdfjMl
 Wfw+1cBXtd0NrHO0VdsLJe6YLD9lvVPx2MufQK9ZxVODxsQ/DONPj4t7bhOG4f+Q4yspNCN2a6m
 rdIx3+WzHtym438cEFWjgJuGtbFIDXHwWXPlo0Po+q3EHnvj21GGEO6yFP4zQGUTmKajdk1IASV
 FZVy5GpeKJ1K2KV8l8rCd+tYMsK32cWOgIUQGvExNx75N2Pm5Ac7zoUmbYpfL2ELwwXacdnw15N
 YkMnKu/VoXvsQ4gPjqyrviCQiifoPEV5O45ywNGJA2AjmEFdU9CMzJsxhoSa2OKchbgpy3sLjhB
 dvD9oBigcYn1nmkv93lRanSpS/lvGIOHbf2JWd/jblCUX3TVFUCibn6bicchBLObQH6VWD2+TPc
 Y0+nGtp5BdsRosXAMD3STQy8PZ+qo0K+JJ7tHHreyDspmRbCuel9ZlJ+Rj7htk4toMx5Nx3YPJE
 TvqW5MMDyOtqGWsSzuzvFG3tgcSiWZSwKRNt7jYKyfmMQKSQmFs7j6dp5iMNGqtlmGh9LP+SAa+
 aT6QiowSX4npz2oDHTUwakI4hcjbRDz1lt9HcvbvjBeabKhZcLb/SAsuX7VuWZxNygOkk51wrXG
 vYYXvPCZhk/EFLg==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Amba bus core already sets owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index c2ca4a02dfce..e6cd9705596c 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -2344,7 +2344,6 @@ MODULE_DEVICE_TABLE(amba, etm4_ids);
 static struct amba_driver etm4x_amba_driver = {
 	.drv = {
 		.name   = "coresight-etm4x",
-		.owner  = THIS_MODULE,
 		.suppress_bind_attrs = true,
 	},
 	.probe		= etm4_probe_amba,

-- 
2.34.1


