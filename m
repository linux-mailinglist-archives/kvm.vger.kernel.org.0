Return-Path: <kvm+bounces-6436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 894DC832027
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:07:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA575B26497
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D4D2E83A;
	Thu, 18 Jan 2024 20:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L8fY6bxa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429F72E824
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608438; cv=none; b=YNri08H1OG4ku2IrDaQAgQ8Y0dPwyrJn/dilrWs4ox4x8CcIdFghxmlTeh2dC2Vkk7O9XJmYWSD4xFg+hRIZZXV+mIfh0PeEhFTLKAoWlJTBkGstYCAx6W5GwsZM/UkS6Gzswb+qe+2mGiRZ66F5ayJ7JytoL0a8eceARZmyRWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608438; c=relaxed/simple;
	bh=ydoy/JHqOdFhNvTqtN+7tFtlR5hRLv61QMMcsKw/GO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lltCcdH1u9P8cPj6mQetltBSLJlpatYtoKPcGcSPusK84S6RJgnlqfYGdrYpp13mYuUzubjwCi0ZxRb4xjvU2pzZpbXU+jdxCfRol1fMhZ2inncaYfboBQoKnxkMa7njlvXqx1s+cMkPmisjnyyfmJhP6AwPMg567OpmaY1Q9Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L8fY6bxa; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-40e884de7b9so491895e9.0
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608435; x=1706213235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IqI4tMz2yzskRPvxs8gc/s3cCgtxYk3v0bTB1NWtJzM=;
        b=L8fY6bxapyPIa/XHv6R20xItl3GXbRvgoeL0eCUfPr4prgvkOL/DQjZB3nPVmIdjGs
         LzjcfDeX81Dc4xvfGor+QRVCV/sr2orCG16BYvJYQBsoWiIBOK7aRrE5bGbzGiNjE450
         WDVBXG0ShLwRl04cvwXDAnqt1D4u+yZLI3tVG5yKjr68kl9lB9DpS33BcvykMLT3Qv56
         s0FcDXIzbj8Ah+rYr+qiMHwUf9UF9xo48tGJmKDLC/2JIwECn3S3lvroEe1n9H5RmIDb
         zC4slQXCzo86BXgy0dFA+ZaNmPDWMUASnephhqjoN0SqSzBJdws2zeFGmbW1MQvl6zqD
         yGsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608435; x=1706213235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IqI4tMz2yzskRPvxs8gc/s3cCgtxYk3v0bTB1NWtJzM=;
        b=CKANX9i7fHCJI9EnaRRCDkGkJT25JrdRhnJ/Ancsfzip4YLjrKDvZx8t/+J5mQNXnD
         dgo7vA1qbBJdb2tDnwx6TsqGMeLVQWgndqf9NFxDzuRi+c6+R/5gV9jptOQUznPF/eoD
         IEORjEWQVr48iaGEkPZwU6TQm2b8rjk4R7bVzBp6ktv82zTNYMjhCvLBCxa85mD7mLoU
         DzzM0oc6hkX2MNuHPdD4BOjkla2LEBU7a0tmEfJTQFlko6tDavrzj7oqkKTaa/BinJFB
         BBDFnYO7vwSaacepBItiEXZC5L1SUtyuwRSDoef3f558JbuCE2zW+az7fLjGDXvf3ztp
         wp3Q==
X-Gm-Message-State: AOJu0YwjEJXvr9FKTuCVoYr2SvmUiJLRygNoiWWNqi5xMBWZtz1gZkAZ
	NRaDYphO/USgPJW5aSORMaPsQaFWyMbqMYQFtyJJz8M6jiujYi6nBoCAEOmSrKI=
X-Google-Smtp-Source: AGHT+IEJjVKFjOhUte3h+FN6s3BlfHWp+z5dcQ4uANgPU3TjG5YMaIqdzX+BYpMSKDVsuoEyDNtojQ==
X-Received: by 2002:a05:600c:22c6:b0:40d:88cb:ac7b with SMTP id 6-20020a05600c22c600b0040d88cbac7bmr786225wmg.183.1705608435599;
        Thu, 18 Jan 2024 12:07:15 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id o31-20020a05600c511f00b0040e703ad630sm18018088wms.22.2024.01.18.12.07.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:07:15 -0800 (PST)
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
Subject: [PATCH 05/20] target/arm/cpu-features: Include missing 'hw/registerfields.h' header
Date: Thu, 18 Jan 2024 21:06:26 +0100
Message-ID: <20240118200643.29037-6-philmd@linaro.org>
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

target/arm/cpu-features.h uses the FIELD_EX32() macro
defined in "hw/registerfields.h". Include it in order
to avoid when refactoring unrelated headers:

  target/arm/cpu-features.h:44:12: error: call to undeclared function 'FIELD_EX32';
  ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      return FIELD_EX32(id->id_isar0, ID_ISAR0, DIVIDE) != 0;
             ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu-features.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index 7a590c824c..028795ff23 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -20,6 +20,8 @@
 #ifndef TARGET_ARM_FEATURES_H
 #define TARGET_ARM_FEATURES_H
 
+#include "hw/registerfields.h"
+
 /*
  * Naming convention for isar_feature functions:
  * Functions which test 32-bit ID registers should have _aa32_ in
-- 
2.41.0


