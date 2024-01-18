Return-Path: <kvm+bounces-6435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3080832026
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:07:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 72B4BB261FF
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E39E2E655;
	Thu, 18 Jan 2024 20:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L3K2BjtN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6992E633
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608433; cv=none; b=jGgoU2+Tg6I12YSLUY5OMtt7g/1SUVCv9OyNkOHLNUm3+EYn9r5oGXmel/ClxB7ht4Aj6zxWHlCK33o8/oEQyKuN5CzBvA8+/Ey3oBx7eh3tXVDGsU/BIAyWwOzHWVJks6KPq9fIsnExsVNGW/ZKle6s98uHZOL/6VGa2vWfbJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608433; c=relaxed/simple;
	bh=uJiCGVQfPzC0uQRXyTmZuYLATcpGFEmTM5iXbRIpAXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r9FCVHfBo6cKx/Jg17X0PYRECVUz3JkXFWTwk7Uy276QTwirccAr8+Fjgq5SgRPYl63AyfH6GDaYIb8s9TeKChQzysFC4ltNsTfikIQbNpWcVqjm5tQN0jPNfyb1n+BULuUmLLIMMHkYL7i63ygud2jD1LdS1eSX1K73n8IqGC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L3K2BjtN; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-337ae00f39dso3915912f8f.2
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608430; x=1706213230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eSJ61VYdXLhvSCoYWTAbZrzxB1wnfwdSWkLcd4JmNGA=;
        b=L3K2BjtNuYFrUbaOaTWPGIEVsxEAViHuEXNikFaJv8KVLscKEMatQfEmXaoUpbZPUs
         vsEZSCfTLsVJGBmqB1LVbnqBTXRJSbKLkp+2bVFf2BYOVjsjUbypZO+yKAXibdjA6N9N
         C2MklhrVJcrxHy0ilct5tOu/YbhptPHMooUd22M+ANJ8UFHK63I1712ybK2r/pQBKD/q
         3Y0bYgZcp5knMviNaKNZGviHz97yWvx6Akwmvnf7szevNDfk6vDb1d58JtihjfO+jI60
         tnFfuO4OIMZ8QI/n4/qELku5rZw45F+VlNam6CW5wTlgOVU/HS64Yxq8bv8BvrTDrCYS
         4HhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608430; x=1706213230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eSJ61VYdXLhvSCoYWTAbZrzxB1wnfwdSWkLcd4JmNGA=;
        b=TnMXlnnTZKzNl5ZZqA8DqmCp/Xad1KiCtKzst0Bk6LREh5ZQK9YqNvY30TDAO7rGV0
         Ktq3KZrufWjvnjqBEO03WJoLSWdgfsUUyfREbFNPyLudklIlrmfDnYXNcfxpcaCH6ct4
         3S1OESqQHXulA0lUaQ4rgEeWeLRxcMB93RotRh+vwQKi/SdszFLt482NUIp4I9RBtYo2
         S0KAbE2llTpY/rZEDqF6gHXJ8qnaVLKFLLNCdK2hoc0xLR7sEJofmzX9uvKfQHnYYF67
         tcQJLKO91cXVg7Ulxi1uIBsnOFvFfZF8uZJvhDJORxDlzo6VbSggoWmz9MmGMVsCJQPR
         VPPA==
X-Gm-Message-State: AOJu0YyqIaIdOnrldCIEISH7Sunf5GtIOTMLKJcWZm6NYWW8GQx9PN15
	E4xzs0YLv72Yjr/0vEnxI0W3udusQ8mQ19OYFWs61lFKgG9iwAdSIuYTMCdsuiA=
X-Google-Smtp-Source: AGHT+IETSTGRNXlFpF1x/zcbUs5V3o4QwqncYxMR7NZ7TvBtPQk41EnWndQyks5m9I+o909cn/g4Pg==
X-Received: by 2002:a5d:6c6e:0:b0:336:c3c7:75e8 with SMTP id r14-20020a5d6c6e000000b00336c3c775e8mr1223627wrz.45.1705608429954;
        Thu, 18 Jan 2024 12:07:09 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id q10-20020adf9dca000000b0033342338a24sm4766596wre.6.2024.01.18.12.07.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:07:09 -0800 (PST)
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
Subject: [PATCH 04/20] hw/arm/xlnx-versal: Include missing 'cpu.h' header
Date: Thu, 18 Jan 2024 21:06:25 +0100
Message-ID: <20240118200643.29037-5-philmd@linaro.org>
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

include/hw/arm/xlnx-versal.h uses the ARMCPU structure which
is defined in the "target/arm/cpu.h" header. Include it in
order to avoid when refactoring unrelated headers:

  In file included from hw/arm/xlnx-versal-virt.c:20:
  include/hw/arm/xlnx-versal.h:62:23: error: array has incomplete element type 'ARMCPU' (aka 'struct ArchCPU')
              ARMCPU cpu[XLNX_VERSAL_NR_ACPUS];
                        ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/arm/xlnx-versal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/hw/arm/xlnx-versal.h b/include/hw/arm/xlnx-versal.h
index b24fa64557..025beb5532 100644
--- a/include/hw/arm/xlnx-versal.h
+++ b/include/hw/arm/xlnx-versal.h
@@ -34,6 +34,7 @@
 #include "hw/net/xlnx-versal-canfd.h"
 #include "hw/misc/xlnx-versal-cfu.h"
 #include "hw/misc/xlnx-versal-cframe-reg.h"
+#include "target/arm/cpu.h"
 
 #define TYPE_XLNX_VERSAL "xlnx-versal"
 OBJECT_DECLARE_SIMPLE_TYPE(Versal, XLNX_VERSAL)
-- 
2.41.0


