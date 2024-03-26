Return-Path: <kvm+bounces-12732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5C8B88CEAE
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 21:29:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AA82327E6C
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 20:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9353E1411E2;
	Tue, 26 Mar 2024 20:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wFNCRvDG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF2613FD87
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 20:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711484671; cv=none; b=QKuCG2bbf3sVFDnTQDpigJ1+9Wmi9cn9HtGOAB6dvu3XF4KyuxdoeYffzoYCeqMS/nWEyAg+HoFoFlTgEAsnMVmIR4wARJ1RX5c/Sq1GBhtxpELpM/zTLus8THe4y8dH1pcu17KvmPL3p4azgMHD7JM3WTnvhgm+UYWu1H21Oh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711484671; c=relaxed/simple;
	bh=mzW83dKAeopOAlsaYSxUYRMWGIcV+pi1cfkK7J9iXH4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lpMC4u0+2fPp7gMzxGfdzZR9jki0kKkaxiRY5VFzb6bFIduJPwZLwXAc57g9i7E0taJFGUaJHbaWviNDfP6N/82sVEaqJbM/Oksqq6AdsUtGQpgpDYCdoUVltp8LBjThoPV+zW/shFOmmJZqA91OMjdMDaahN44X4lsd7R6Vok8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wFNCRvDG; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a4715991c32so724303366b.1
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 13:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711484666; x=1712089466; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FuVDaEvr2c6AAkjEaLK4iGtTvSGvFSYUkhrUiINQHVM=;
        b=wFNCRvDGA8XOTFNkRfPMM3BdPa33tbfUO+DGXWPvN4uUizzBYOLQB2YXxqNzDWqOxv
         6nNyBFfEM7qnhKnajT60ujS/C8ZCJIVP1yi/QV+iwqtzyXUcHZZB+iieh+vO6a8KWvzl
         SB2k7SfbLJ7afUAvZ0CjWrumUVemsP5vK2cDHftBi+PBn3jd8A/RB5Uw61Qef5nQ6J8f
         pRxfZBVEnguJbraIxj1Y3NIlizUYGSxno/G2fGgJFEkKUJ8w8YktY3hrsUErP00Q6X6t
         OU3rXJeIHyg2/9qUIslObvinFoaM4xJ7FUK6QPPOhTBU5OoIvPqxipBTwd1HzPWzzINo
         nV6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711484666; x=1712089466;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FuVDaEvr2c6AAkjEaLK4iGtTvSGvFSYUkhrUiINQHVM=;
        b=fUHxou7nY/SySUYx3PLMNeGr3HHYSnkmbPVlsz4inmQNzmn10jB4z+JcUwZdYRl0Bv
         JzXftUA29gde/1/pNTDOncZqUlNnYAt+oFJIqUvwh9m07hoJcqOEDVyVTSpirN9gvI8E
         JUMythiWERpdVWYZbH5VuYL0S7SvcnrOTkNNuvVFvRqEDVVjDiHwZkJ1Q4cEAikuLjtm
         hOTJ/jEmX8uXTPb3INAG6+yqeQfQ5YCh9D7Vn3ZJBenexBsXi06E21Z1HP/+3U3aqM1y
         RH7n21cOfmqT2SlFp1YQ/TL00QTtIgC11DihutvHuZw9DfcQtRqnXj+6NTrYDXguW53l
         qeqw==
X-Forwarded-Encrypted: i=1; AJvYcCUccN4xHO6IroyXvowcL8paUdeRjwGxCbWZa2nEYS5Q8BMh1PPWKjf+5OUO2JnK79RK0VdLVXkwuKSFal26s8YuBSsJ
X-Gm-Message-State: AOJu0YwSAxpi8wkC+Vg9jqsyFo/gImt3XZ2Pdnw5pB3U3BKRqxkUIAoH
	BHtuiguE2Fqkf0tshWb76oLrt9GCStRFWm1EtvHqJNLs1xJLJoXtevD1NGOyQOY=
X-Google-Smtp-Source: AGHT+IFHSER7YzYA9YStVg65zDciiNiGG7ueOSBINzUVaXu+ywI3HbB5wXjAk97hfb/FMIFSp663HA==
X-Received: by 2002:a17:907:86aa:b0:a4e:29d:c2cf with SMTP id qa42-20020a17090786aa00b00a4e029dc2cfmr30978ejc.29.1711484666718;
        Tue, 26 Mar 2024 13:24:26 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.222.44])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709062b4200b00a4725e4f53asm4584492ejg.40.2024.03.26.13.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 13:24:26 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Tue, 26 Mar 2024 21:23:43 +0100
Subject: [PATCH 13/19] coresight: tpiu: drop owner assignment
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240326-module-owner-amba-v1-13-4517b091385b@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=729;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=mzW83dKAeopOAlsaYSxUYRMWGIcV+pi1cfkK7J9iXH4=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmAy7WRhiBye4JPUDUabGW8d0YAo6h+snTYUYAO
 26UykPuFNiJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgMu1gAKCRDBN2bmhouD
 1yYjD/917HcS9h6P/anThHL1FhBJ6kR70Zqgi1NnZ/bUfxBkPtJjBAzS10+Phk7non4SmlFqodt
 ihWJzYjc8YDq/aARsJQDj/+4lkfPXoVcGOKaOr+io+biWFplarvo/LK1yWWgZENgcdNN0EeroN6
 agwwrSsX/qVKx3oVPx16kewExZzKKulFeio6Y9XJVfeNTOwJKpN0bgPT68hbtJ3lhb1meCz+uad
 qlgeu2stSdNg4qVFudy+ATp1ZdE3RloRzX1vg3rWgdE0tOV2ozr6cO/mzxuh/MDyJHAcAH5nHEe
 vSrVtFwPTQiyei7G7BmxQHcQInKudMTbbINpGY1FVZ2sgHlcmw+nmjcJHz4dosl+EmZn+m8Dstx
 DWYAKPNKL35sqjp5bXeoXYb+H1NTG0WICUqg271lqp9CwXvH2gQVkKw261M/xulaHWZMfajrKcb
 8EfddeWzVm5nNiRajXmiJ+zzA6xuxKUio9etRkwQAngG3UqFWo5raKYiRQIV/X4NwvPVbbT0eAu
 ZQJLTR0MhpSq0QBYZtXDpyOEPIi0T2IVanll6fix2jcGp/u4qjob/k8k1I/u8BlS5MfGwmlso4h
 8+c9SDFTcHyEGw8WH4UyRr91D7iZc1XHRcGmhZl9MnbR/Ca9GbU/Dy9AExmIFXnSJJTeTao9uVn
 g57cf3JmUqoNXCQ==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Amba bus core already sets owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/hwtracing/coresight/coresight-tpiu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-tpiu.c b/drivers/hwtracing/coresight/coresight-tpiu.c
index 29024f880fda..7dc9ea564bca 100644
--- a/drivers/hwtracing/coresight/coresight-tpiu.c
+++ b/drivers/hwtracing/coresight/coresight-tpiu.c
@@ -236,7 +236,6 @@ MODULE_DEVICE_TABLE(amba, tpiu_ids);
 static struct amba_driver tpiu_driver = {
 	.drv = {
 		.name	= "coresight-tpiu",
-		.owner	= THIS_MODULE,
 		.pm	= &tpiu_dev_pm_ops,
 		.suppress_bind_attrs = true,
 	},

-- 
2.34.1


