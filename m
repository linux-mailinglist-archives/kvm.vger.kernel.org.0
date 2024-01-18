Return-Path: <kvm+bounces-6443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FCA783202E
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0569428BDAF
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D883175F;
	Thu, 18 Jan 2024 20:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Dau29uyt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FA83174D
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608478; cv=none; b=M9zIxOn2BgnTGi8ce0NUTJTd0odAeJ7Dbd23IiInbA5wLLHYDIMHyqXivY5FyuYsK5Z0rqmlCdQOPVndUBrDTheeWe3Bu010HN4XKqb1kx23rVN/9TdlC1vy3gfgOCp3q6UCe+aEeq3f8PM3ON2DzdCMe3DnO27disWByiEnkG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608478; c=relaxed/simple;
	bh=P3ZEb1dFe1xTng6PU6o02S/lQbihTtvauu5ZyFe3BAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ON0vrXFTqBWP34G81m5GUHcYtCvqHbsWfen57ubtjGevf1DBdr8aBMKOWfrdFVvKO/EUULoqb/j2T5n8AcIJKtzfqiXNLfaEX0m37NsTV1ymB99VntBxonVHUJS97Wu7koQ/Bh5EzRKyKTM9EKdXH+h6L5HgwMKSELLxzdXre0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Dau29uyt; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40e913e3f03so225505e9.3
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608475; x=1706213275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NepvwILR8saXQ0DwpYtr1EjRADd2IuMlIDWFe0pCcHE=;
        b=Dau29uyttBk9HZNYuxYvUk/fnBtB4rArOdeZg49nWO+vm30dQz+Q9HbKuNmzwzcKet
         k2rnbGbVKslR10C9anIXMbOoQFsYYIiXqijDEB9t3oK3T99VNd9y6HmGopdlp3Yu0MTy
         dSLvFiVDHlFuIZck6BMnUO8WKQZvgjnEO5e1KLpUTpliHKu3ekCWACvM/pwIlIJotsCk
         xzUDKxlhizVzChN9427tLTscOQ9E/HAK69BcBE6pP2frRJEIQv4JwMEgZvvjxa2pb2Jn
         r6SbqtFXqfSi7e0OchD3aDWtMe5daPX5JoGn7yTc5FJ4I/Luwq/lmKcLjXhqs7gsUqfQ
         lyag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608475; x=1706213275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NepvwILR8saXQ0DwpYtr1EjRADd2IuMlIDWFe0pCcHE=;
        b=OElFiBB0Xwk5VXQeqrSOSVhAODMyJOWjkD2EYYKLkAKla+7ypewnb3rr6C9QTODyik
         fGGkzkD6vGYeDebEpA68AWdVHfCm8HCjEoeBN5bECBlWu+uIhWnNUFm6zJPgpS2WT2z8
         /1MsgB0mabCPE2nVLZNv6OD7HI/HKHghXTscZvw6+gfQQEu8MqamQjl+ZOeKJ5kWTDSG
         TfS28byXZA1TMu5w8VX1+Lm+fAkSl1cNRcG5fW8mis/mYoXNBxmKkNFt936EvQZq3cQ1
         sRlXjONKpiS76qEt9YHfJz0PP6J3mNC+X3APrGAro4DGk5KkjB9qPZQipvtJ40y0g4aX
         hfrA==
X-Gm-Message-State: AOJu0YyufW7JM4RUGUS84soZs2POBxuBwYOaJkHZ7PTbpEKhr9Ih81tg
	9SqT9tvvGbMpWZuQ6GFHtG09+BnxOGt/svY2ZoYMzivVYoaB03hQktc8sNrDFuU=
X-Google-Smtp-Source: AGHT+IE+ld0bkfXv4fXDZ190iTMfcnQekq4l51pi5JbBiv/Fbjiv1mhIml27/nvNDwrsDjw20ygyPg==
X-Received: by 2002:a1c:721a:0:b0:40e:85fe:b00d with SMTP id n26-20020a1c721a000000b0040e85feb00dmr911900wmc.97.1705608475040;
        Thu, 18 Jan 2024 12:07:55 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id iw7-20020a05600c54c700b0040d604dea3bsm26301559wmb.4.2024.01.18.12.07.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:07:54 -0800 (PST)
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
Subject: [PATCH 12/20] hw/cpu/a9mpcore: Build it only once
Date: Thu, 18 Jan 2024 21:06:33 +0100
Message-ID: <20240118200643.29037-13-philmd@linaro.org>
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

hw/cpu/a9mpcore.c doesn't require "cpu.h" anymore.
By removing it, the unit become target agnostic:
we can build it once. Update meson.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/cpu/a9mpcore.c  | 2 +-
 hw/cpu/meson.build | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/cpu/a9mpcore.c b/hw/cpu/a9mpcore.c
index d03f57e579..c30ef72c66 100644
--- a/hw/cpu/a9mpcore.c
+++ b/hw/cpu/a9mpcore.c
@@ -15,7 +15,7 @@
 #include "hw/irq.h"
 #include "hw/qdev-properties.h"
 #include "hw/core/cpu.h"
-#include "cpu.h"
+#include "target/arm/cpu-qom.h"
 
 #define A9_GIC_NUM_PRIORITY_BITS    5
 
diff --git a/hw/cpu/meson.build b/hw/cpu/meson.build
index 6d319947ca..38cdcfbe57 100644
--- a/hw/cpu/meson.build
+++ b/hw/cpu/meson.build
@@ -2,5 +2,5 @@ system_ss.add(files('core.c', 'cluster.c'))
 
 system_ss.add(when: 'CONFIG_ARM11MPCORE', if_true: files('arm11mpcore.c'))
 system_ss.add(when: 'CONFIG_REALVIEW', if_true: files('realview_mpcore.c'))
-specific_ss.add(when: 'CONFIG_A9MPCORE', if_true: files('a9mpcore.c'))
+system_ss.add(when: 'CONFIG_A9MPCORE', if_true: files('a9mpcore.c'))
 specific_ss.add(when: 'CONFIG_A15MPCORE', if_true: files('a15mpcore.c'))
-- 
2.41.0


