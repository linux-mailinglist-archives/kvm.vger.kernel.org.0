Return-Path: <kvm+bounces-6444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CF1883202F
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:08:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB3FA1F24979
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FB631A89;
	Thu, 18 Jan 2024 20:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yjf92Dw4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B51B31A73
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608483; cv=none; b=QDj4nQuxL5knh4fE9DKWvnAOWEG1/OUbodg2KJpVjAzkZ90cOTd4Nr2cuZY93aKvJ0PF3kveMmKIt+HdRO64Dd5BkHT4cXWn09npTUaSnaTNwHzHydSKONjWOEN1lrRzloiYDLPVdYyWeYp9RUAbCjSDJ5Wd11E5qbUVcOWBxsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608483; c=relaxed/simple;
	bh=1GWzJA2hXX8z2G9I3aCH1yJ7z0+NgAdv2RboAlgWSUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FdEZu4clAzw8cWH2GFzjUn5DCwOhS/xwEFNXwyt6TlBijVv+mH1AnDesy7CsYRTA914ja1FWRK9CXzd9zNwqunHWgX1XrN1Dj8j9tAoXqYkttBRNlA8fC2qww3bDCWbvpzMmdx1zFhZa+1VbaORjLvMACljCW5hFIPkcjJU/rP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yjf92Dw4; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3366e78d872so12448700f8f.3
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608480; x=1706213280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o0rOeZxLobaeC+GA5Yjm4BlTG768XBMgHhLq69UHP94=;
        b=yjf92Dw4hg8PM+T0arUNwZUKCzY6XQRWoYpvZl7wmcV+nl/nPKQiC5oydWx4KG3fqN
         /XYhzRGktC3Adt5q7iWbBqml5ma4TMHL39eKP8gBTN5SJPaICfvPuiLyPAT5psxOYq12
         DMg9dRk4MPN4lb8FGjhgvRTuZSzx3f87M3C5Aecupl5Ptn3+/Nr2fOYizj//tT8TFgau
         9Od55Jdstypj+Ym/sIPHcr9rVFSkhDrV16tddLMoNEUUHK+uMySH9C72sd0N4DxKYP/n
         2ExkEJ/TuEkBG95YSLn/PLhmXl/2y9GunXvguUNSxDlDVJft2wpq7C/BCgKS6osiXTfz
         mJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608480; x=1706213280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o0rOeZxLobaeC+GA5Yjm4BlTG768XBMgHhLq69UHP94=;
        b=HMZiDHsKpu8CUDj8pl8c6V9mbFj94f1lfh8npcdlx8on6f1ZEgPQmTZod6u7p3WCTT
         wi6TwUom9tKSvyotDzK8bqdBkWG1vieB/9FKLXiNPm/WrpCb2sCLHZWE94WxH33s9p2L
         syODE2A1PHqB04MCV8+IRDNZgndBvCWzxnfZOG3mCCyZGGjLOQeHuBH6SWg7Y4B7OPax
         OcUU5sMC7h/HqG5eGPSSPi3BUELUvhKjaLIPa6B4eQERcwXjvkSH1M2UdcN3Dy0yY2XU
         8bOUH55lSLDiU3WZx6ojyJL/8ZWrL0Sp782k/kLvf661HdTPUL9tlJ1Ds7dkaEpD+AMP
         rfiw==
X-Gm-Message-State: AOJu0YyBFUmQhbZ0hQXstlm5vGsNo+j7GLOx2H9ykCzc2InCga7PQb3R
	gCPZuhpjtLjLujJfwyiHfCcCQM4I5QMYuu/eBpZJGQ2SPlQGh0PJvEfPp5BnvpY=
X-Google-Smtp-Source: AGHT+IG1NAQIyrQe5pBXYsFsuXHLRNDmJDK8Q6CLF/Mb6tUVdicirciB4E9QrAoXLgL7l3NvgakNmg==
X-Received: by 2002:a05:6000:186a:b0:337:ac2c:cfd9 with SMTP id d10-20020a056000186a00b00337ac2ccfd9mr389531wri.196.1705608480329;
        Thu, 18 Jan 2024 12:08:00 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id p13-20020adf9d8d000000b00337bcae5eb1sm4764752wre.72.2024.01.18.12.07.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:08:00 -0800 (PST)
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
Subject: [PATCH 13/20] hw/misc/xlnx-versal-crl: Include generic 'cpu-qom.h' instead of 'cpu.h'
Date: Thu, 18 Jan 2024 21:06:34 +0100
Message-ID: <20240118200643.29037-14-philmd@linaro.org>
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

"target/arm/cpu.h" is target specific, any file including it
becomes target specific too, thus this is the same for any file
including "hw/misc/xlnx-versal-crl.h".

"hw/misc/xlnx-versal-crl.h" doesn't require any target specific
definition however, only the target-agnostic QOM definitions
from "target/arm/cpu-qom.h". Include the latter header to avoid
tainting unnecessary objects as target-specific.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/misc/xlnx-versal-crl.h | 2 +-
 hw/misc/xlnx-versal-crl.c         | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/hw/misc/xlnx-versal-crl.h b/include/hw/misc/xlnx-versal-crl.h
index dfb8dff197..dba6d3585d 100644
--- a/include/hw/misc/xlnx-versal-crl.h
+++ b/include/hw/misc/xlnx-versal-crl.h
@@ -11,7 +11,7 @@
 
 #include "hw/sysbus.h"
 #include "hw/register.h"
-#include "target/arm/cpu.h"
+#include "target/arm/cpu-qom.h"
 
 #define TYPE_XLNX_VERSAL_CRL "xlnx-versal-crl"
 OBJECT_DECLARE_SIMPLE_TYPE(XlnxVersalCRL, XLNX_VERSAL_CRL)
diff --git a/hw/misc/xlnx-versal-crl.c b/hw/misc/xlnx-versal-crl.c
index 1f1762ef16..1a596f1cf5 100644
--- a/hw/misc/xlnx-versal-crl.c
+++ b/hw/misc/xlnx-versal-crl.c
@@ -18,6 +18,7 @@
 #include "hw/register.h"
 #include "hw/resettable.h"
 
+#include "target/arm/cpu.h"
 #include "target/arm/arm-powerctl.h"
 #include "target/arm/multiprocessing.h"
 #include "hw/misc/xlnx-versal-crl.h"
-- 
2.41.0


