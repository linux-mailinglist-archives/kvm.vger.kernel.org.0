Return-Path: <kvm+bounces-12725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 968CD88CE80
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 21:27:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 522D832141A
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 20:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E4BF13D2B8;
	Tue, 26 Mar 2024 20:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mzcXedrf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1947B13E3F1
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 20:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711484658; cv=none; b=n9YLJtinJrb4oQG3r4JgJv2TfYJIf5lOypzxVjXYyJzRe2FmsxKWPR8gbchy2XZIMMogbQ7W6UJFIJ64TbIaiv159Fn+QXeIg4yn+N1VUBrj743TJ8ouKj7lrv0ldr4u4osPOk6kAgrkellmxLeYG4hbO8hUgJIdK0JvPK44UpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711484658; c=relaxed/simple;
	bh=nzJjr/3kzpVLtmrrfpAcGA4hmhn+rDCa4L/qGUurIR0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bpXZK4GH4oPWgwTz3ndF19B6lXWfQQhTMbr1UYa7tGVtNdkviBp9+kakk6tEMvF1HJx2CUoK/t9Cy0FbGfa/8IcLTR8A6HzFPf7zfDSy92K9UWHhleSTO1Gn7VaZL0I8k2U3hz7bS1KDszFRigxJl9VddTmldsQviCpY2KEHAAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mzcXedrf; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2d41d1bedc9so112332441fa.3
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 13:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711484654; x=1712089454; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kuScgEGC8UrWc0EoVLGgWCbv6tlfkdiLjT4dUhMOUcQ=;
        b=mzcXedrf2qOWSCbl+yETURtJp+o6JRoslZXK7YTOh5UODhKsX8a6vWEwHPaDc52jT/
         GeT9/FoY6v2wZGjy36dWD6m/jYMfOKDRzQZtnWXBYWZRh5CbZiWnkhvzGyWycQ7cG0oD
         fTQp6qnpHYFI1BmgcmSoraKgNcbDu6KU+8Dl/6quQ44veyB1Lns4oClToq8nirLhXvap
         SREtn9AjiKIsgGDcDb2KRtMi11TtGon7DjpXdPExM4LHCdxFEOgxBpgVOXlwBCvMKTMc
         v1Fl+Nmqperu2H8vqgFDRqnYxZt+29IAi0II995hax25ESRxSU3KGwA9Djs5sd9THx7y
         c5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711484654; x=1712089454;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kuScgEGC8UrWc0EoVLGgWCbv6tlfkdiLjT4dUhMOUcQ=;
        b=AOvhGrUC49EgS+cDiTnN9B0sB6YXjaVGOJUMJbySGFc7cwtVt/uyVgmnYmES/duBEQ
         YAxKeH1rRZhPPSNQ2n114S/oyo8L6ldc4DZZhlociYZfFdVhCZ1lqeqHTcQu/ABIrtX9
         Qd3es5LnIFxkel/bZCNg5bcypjrDD36/95CLJQV1Bb9P5kNZmzOJfBQ4xLsQ7mMLhV0x
         sPDjLY0jHPLkJKjuLahXOSm3D7MBExITo8ZHhd9f98r1VZB+2WzJzPKpi8N3tN9Y6xuQ
         qqaJtLIv1FSqyvkqcgmkCttE8B1SuMZdzaFQsDHuzDLig0QixSbEShMm5eKoWvB8mRgk
         Ye2g==
X-Forwarded-Encrypted: i=1; AJvYcCXqpvE1ejck97rIL91I/QJ1LN26EZMj+FIBz8cp0PsFkuj7lcSVU8A61Inq1hDt8KhAtW8bUCGGS6Kz2same6rsBOwV
X-Gm-Message-State: AOJu0YxNf7HWhbjt27p9hgM1Ttt/w+54LnRrmZO4wiZH7W5s/3Ybx+LV
	qgpQLiIcQ6nJiSn15vwyMOSE0QCZU51H54E5U57VtbFN6mLT1DFYfWr/ne/t+rg=
X-Google-Smtp-Source: AGHT+IGMXZVW5Ho8kmBDmP6Omvoj6jlGcOLG9xvCaAtMPcGWVxz3Ke5z/lSDDh+jhBaIsDnuGDukqg==
X-Received: by 2002:a2e:2403:0:b0:2d4:4ffa:9fa6 with SMTP id k3-20020a2e2403000000b002d44ffa9fa6mr548353ljk.52.1711484654090;
        Tue, 26 Mar 2024 13:24:14 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.222.44])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709062b4200b00a4725e4f53asm4584492ejg.40.2024.03.26.13.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 13:24:13 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Tue, 26 Mar 2024 21:23:37 +0100
Subject: [PATCH 07/19] coresight: replicator: drop owner assignment
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240326-module-owner-amba-v1-7-4517b091385b@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=793;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=nzJjr/3kzpVLtmrrfpAcGA4hmhn+rDCa4L/qGUurIR0=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmAy7RsBi9rHE6OerWYBGpsQMhaz7sDPU0K5tJt
 e5wrxjrm9aJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgMu0QAKCRDBN2bmhouD
 12TQD/91xpOZIgLBEENNHIqagJN55vDh9wP+g0KteobIrBUpfgDGbwLBHPdL2E8eV+ZDMeVIxBK
 /CYCJMyJ4f1Xt2NQ3EIE6pAZZmYG2zggbc6ZOK5kkxYxAUGqXj8tBB6WE8IHdZu/ztKl7bwb/iQ
 g/mzOYng7/+bi5ZLMUtD2QnISo+qIRHw231SZ1Ss9+rno95DhucOQw09sxTElgCvj8iF4FRTqHt
 2pVx8QTGVe7de68eNnqDWZ7M4i3e/SQ/UzfsXzKj0wnosMJmWapOuaoGMvrAuSBetrHAWG5A4kC
 2VkJy1CKGow3pRqbmBZWFuQvkgcLP/sOPkT5UAdUpcm3TdM21IjNwEkFOmaaXiqYwQ8kKfBquel
 xWyP5ugKPwZAvNmJP6kBLVFtBZ0fsLOdQbov4bfg4BJ2CkrwOXKlvoK3MPC2uitvcNS7lq4I8+Z
 bItTs5IN+EmNc0osQcar9g4oHqSjLEPFk//1+gF/HAP0zT0tVk5arvN2/l/VzeipqGn6UaOwCOy
 7t/sqEhDcgBOzfYuBuj96UuisdPH531LFP8sPyguoAmQj/jRHRKtptTLoX/C+6luAQYkPLs6DQu
 hDqzGvzZyZuu8GbRMn4umaNuj5g/ZS00l3b5jZx/qC3brSZ2D/PWeR53ESa29QZKSYJ7cnr/RUj
 514FcGu+Prar6ng==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Amba bus core already sets owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/hwtracing/coresight/coresight-replicator.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-replicator.c b/drivers/hwtracing/coresight/coresight-replicator.c
index 73452d9dc13b..2bb9ba66e3c0 100644
--- a/drivers/hwtracing/coresight/coresight-replicator.c
+++ b/drivers/hwtracing/coresight/coresight-replicator.c
@@ -406,7 +406,6 @@ static struct amba_driver dynamic_replicator_driver = {
 	.drv = {
 		.name	= "coresight-dynamic-replicator",
 		.pm	= &replicator_dev_pm_ops,
-		.owner	= THIS_MODULE,
 		.suppress_bind_attrs = true,
 	},
 	.probe		= dynamic_replicator_probe,

-- 
2.34.1


