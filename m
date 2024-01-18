Return-Path: <kvm+bounces-6437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E1913832028
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:07:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9942328706D
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CEA42E84A;
	Thu, 18 Jan 2024 20:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uFofhk10"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D668E2E824
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608444; cv=none; b=YD8BVnSLpztDH3yYYJ/i+6MCJWsGzxLy9MKVsPnynfYWqpaDwTLz/zcZIs84Nx6SAS4WM64Yhr849Vyh073LGuPWcd7DnuxvYXjg+ISf1X5lnOG9KokCHu4b3c049bjUfgD23CUgJCJyQpP1bSS6id2ZSQzXS7RPZ05+9L/mxkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608444; c=relaxed/simple;
	bh=3ouHomaillduDwcGMpxSqif73Lm7IJIhVMNNi5jJd3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U9s/am/ahM/kHEHOE4opSkdg+rVJQElXZewZsH64WkuiRKYBMWbJjrXJOCqi1uWuqpns6YTnth5VV1P/G/PVbjV83SopaP0h8NLsRiNXrNqkiv2QWSJvduzcUl2JlhRN8aIBQ4b8AjX85rGO4OphnI6TcpTUpgMZSSv5d2+IOj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uFofhk10; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40e779f030aso523475e9.0
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608441; x=1706213241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nPG2WfDmNMhkMT4jWeTVRmIkZRsis0mgcrg/P3hE0Ws=;
        b=uFofhk10NEV9MlfAl7bR0+4XKHegtlnmbN3aWFgv9N5iYuYvf3ABFUsdpHNbd54DkL
         XZdUxthCFj/YULU3cPozc4aOieTkjkBX/qy4aDmqY1TtiUSIgXLBAg/abz25DBKyZXK2
         uWWfLsFoR+q9SJJdoGsEAwqmS7xUpKcYkzLjYs5LNNtVsjJ5fpA702J9szB01P9Pfc1Q
         vuObFnzSLUjMh3kLv5VoYQT9Jd0LNbSny8D3f5ppN9KBZnDAI7s+r8pkGnOvffd58nXN
         YPnckFrxasSxaHfiawAnOxNLkaxeHJn1iPXTe4PuYS4RDHemFpREInbptEjO6Da3AXvV
         u9Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608441; x=1706213241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nPG2WfDmNMhkMT4jWeTVRmIkZRsis0mgcrg/P3hE0Ws=;
        b=vpxitIYwOwafJrvKgO87VaYZ5DHAKwaQjVEXd/hDOpvHEFhWWxRfM1W9miE2/9dd1K
         OKmFhaYDNC03/9e1sti8VcYRfj5O8sO60lw+q1LfHsZ5RUPDWCTOWAuHewNM5Fp2lUBK
         CG8ardleNEZR6eBRDeksQH2TNhxdDsfEXaiFvI+2ySiFWYsklJLOe0J8YkbxceZdisc6
         jvMqgZNP2+x7W9UCLR/IHLnQ+dWIVX8FLSoRv8YVv+jfAq2KjZjfHO+OIu022bmxmbEc
         lNtnoLOZjF2sYT5k8uQJEfsPZfw/HNe5d5fMJzuPuA28erVOGeUHsjKtm6xmyU43SSS/
         PozA==
X-Gm-Message-State: AOJu0Yz4EJqSmxvCvGnO4bze/guW8UN0gEaCIE6b5TI+Z4cBUc/YXd0o
	HoIpcLtP54ZHrWbf+eL9ZuxtTFba7W07h6MvucSe/FsCAGZoj/zfxEpBSV1MxxQ=
X-Google-Smtp-Source: AGHT+IFEMMya0qNkyh3kGalH8tBAMi4ftYlBVKyLBVVyK/sNll0fXqEHx9nz0kVM2qwAhHGsyVuw5w==
X-Received: by 2002:a7b:ce16:0:b0:40e:861a:c106 with SMTP id m22-20020a7bce16000000b0040e861ac106mr819142wmc.107.1705608441172;
        Thu, 18 Jan 2024 12:07:21 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id fc11-20020a05600c524b00b0040e86fbd772sm8045600wmb.38.2024.01.18.12.07.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:07:20 -0800 (PST)
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
Subject: [PATCH 06/20] target/arm/cpregs: Include missing 'hw/registerfields.h' header
Date: Thu, 18 Jan 2024 21:06:27 +0100
Message-ID: <20240118200643.29037-7-philmd@linaro.org>
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

target/arm/cpregs.h uses the FIELD() macro defined in
"hw/registerfields.h". Include it in order to avoid when
refactoring unrelated headers:

  target/arm/cpregs.h:347:30: error: expected identifier
  FIELD(HFGRTR_EL2, AFSR0_EL1, 0, 1)
                               ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpregs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/cpregs.h b/target/arm/cpregs.h
index b6fdd0f3eb..ca2d6006ce 100644
--- a/target/arm/cpregs.h
+++ b/target/arm/cpregs.h
@@ -21,6 +21,8 @@
 #ifndef TARGET_ARM_CPREGS_H
 #define TARGET_ARM_CPREGS_H
 
+#include "hw/registerfields.h"
+
 /*
  * ARMCPRegInfo type field bits:
  */
-- 
2.41.0


