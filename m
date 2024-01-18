Return-Path: <kvm+bounces-6432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F864832023
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:07:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 045F1B25EC8
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4072E650;
	Thu, 18 Jan 2024 20:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LdNYBMjU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A678E2E62A
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608416; cv=none; b=Up7lFfywJyda+ng1hxBEdGsSO4L9IWTvTyBQdVJU+pJD1pc+r2CZVClUC5nF82NsOXdzwfRMwQD6t+hQ2nrecqvGnnZAw9hOWnjo+zFVm99RLLINfaj3IT4q/n44rUeciI2mMdspixsNamWa1vJz3/CyFHEUIh5X3sVUNuQBObI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608416; c=relaxed/simple;
	bh=KTGDetcjBm2dpi4YJvKoAoiNmdmzwwhHqGb9S81FkyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HN0CWQfyMn/N5MeFQOLm2no9Wk1flFgDq+VDb0Ckd5sRw6lH1H15FD/26La/4BUwkCJP+7bWfW+AavnqORxZWWxRKnlZmRbWtqT6iUwCmNMKmDpqG6QO+NyyZfnaKmMaCx3H/E+SH65MMScs/ChgNCWdWHRB6hnu+3hodCtUbpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LdNYBMjU; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40e60e135a7so301875e9.0
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608413; x=1706213213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DiNAFYNzh60Xuezutbt6PuwpTTLS/OKWcI7qaHfDd9s=;
        b=LdNYBMjUhQzJa1vFRH8Ep1RCB6r6GVcMOPs+x8A2Z4v8Us2exg/mjcvlG4qGt0cmAk
         EkKqGWtHJ4v3/i0BEU2MDUiliXvHoJZQC3DSdHskrrMWJk6qFo9of+lUXgNdy8hK4Yv0
         SRDPzP39KULlm5NTz2AvHRfgFxSDKLUvkKBc/Apg4whcqRaLCKH0J7E5f6bTeVVXHjdS
         2vYN3ufqCpKyS01YtOoDOce2OW4rGxT/I4aLDGPFA0IeiLrqvHYA7O8p2ADS8/zzlTJb
         0XN8S4dHNWxNAFxBhWExEhQuUe9DMP8F/Gy+4oqn1cJstxPHbEMNSfSJUWnYYFQTQOio
         z1aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608413; x=1706213213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DiNAFYNzh60Xuezutbt6PuwpTTLS/OKWcI7qaHfDd9s=;
        b=Nw5BR6dnVJyMxVFneJlq29lrS9Bjv9cGGGJyyfZjbd6Jfhq2zJ6SPBRy5Rp2d8oF85
         mUTfbR3wZM3638m3gDwJl7JoHBvBKQR1/LmeLwTLnKoi0f3sKf51r5rPuWR1An5Wzz5v
         FVttqpzKOQ/pps1/5+um9g98J42pL1vGDO/MyBYiLKWVD7IBH/1L6hi6soPNetTeh5d4
         MAkx5D0BGnxWFejyv8BBRtNI2K31PHuBaJCoqSiOeEVvsTCIHY/aZCV/2C6VZq4E/dse
         qW6EfOSpzEvklIaH/aY5nNa4gf6mwhC915N42H0ovS/F5xA/GbNosIr+NOhRk3bHI2HT
         zjlw==
X-Gm-Message-State: AOJu0YyyBiRkjZKM7dGHSysHNVcYoeqTMTzzAvhhGPLhGRRkFkBLua6x
	ZYm1pUI2e0t+vRqmce3RPToVNu1+7/ijDwU+j3fOFrdL/0biNlZpbhReycqoakY=
X-Google-Smtp-Source: AGHT+IFCtGpPVhfA9Jwun0OeUACkeGdu+paDIrRm7jQFMh2yisqV6dFj3NRTrnHaxOVPKfMo4Nk5zg==
X-Received: by 2002:a05:600c:3317:b0:40e:85fe:af82 with SMTP id q23-20020a05600c331700b0040e85feaf82mr1044508wmp.24.1705608412751;
        Thu, 18 Jan 2024 12:06:52 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id je6-20020a05600c1f8600b0040d8d11bf63sm26933714wmb.41.2024.01.18.12.06.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:06:52 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Igor Mitsyanko <i.mitsyanko@gmail.com>,
	qemu-arm@nongnu.org,
	Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Eric Auger <eric.auger@redhat.com>,
	Niek Linnenbank <nieklinnenbank@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jan Kiszka <jan.kiszka@web.de>,
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Alistair Francis <alistair@alistair23.me>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Tyrone Ting <kfting@nuvoton.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	Alexander Graf <agraf@csgraf.de>,
	Leif Lindholm <quic_llindhol@quicinc.com>,
	Ani Sinha <anisinha@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Joel Stanley <joel@jms.id.au>,
	Hao Wu <wuhaotsh@google.com>,
	kvm@vger.kernel.org
Subject: [PATCH 01/20] hw/arm/exynos4210: Include missing 'exec/tswap.h' header
Date: Thu, 18 Jan 2024 21:06:22 +0100
Message-ID: <20240118200643.29037-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240118200643.29037-1-philmd@linaro.org>
References: <20240118200643.29037-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

hw/arm/exynos4210.c calls tswap32() which is declared
in "exec/tswap.h". Include it in order to avoid when
refactoring unrelated headers:

  hw/arm/exynos4210.c:499:22: error: call to undeclared function 'tswap32';
  ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
          smpboot[n] = tswap32(smpboot[n]);
                       ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/arm/exynos4210.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/arm/exynos4210.c b/hw/arm/exynos4210.c
index de39fb0ece..af511a153d 100644
--- a/hw/arm/exynos4210.c
+++ b/hw/arm/exynos4210.c
@@ -23,6 +23,7 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
+#include "exec/tswap.h"
 #include "cpu.h"
 #include "hw/cpu/a9mpcore.h"
 #include "hw/irq.h"
-- 
2.41.0


