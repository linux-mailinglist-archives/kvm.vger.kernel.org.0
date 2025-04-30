Return-Path: <kvm+bounces-44929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57AD0AA4F4F
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 17:00:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82D5F9C5E00
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 14:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E88962609F9;
	Wed, 30 Apr 2025 14:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UaWPyRaL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7BC2609C4
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025140; cv=none; b=ZS/F2m0ClW2hlfV5lF34sfZKkneASAQZfas1nii/v7Wg7SeoXnkA4yy/WVNcm6uoOTnWtMeyYN6kBc7eZRTbD+4pjC3OVMi/DnHLKwXMgi+eLZdHRTQvX7lk1zQwpNAqRAj8HsmG+NQcb+wrNVNKPdnUGzWqUDNBzok8mL5vHlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025140; c=relaxed/simple;
	bh=wKzeAnWINdRaqA+GHAuV6auQ7ovQpaxnPaLPC9xnvQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3gcJ/sTY4cS7uw9hSf3jYqzQuRUC/wj8GH8zwJBr0ypNOpKeWZB66IQWKGM/mNc5uKnCz1GcHVvEz7VhRL22JpTNG2uVaam7V3IlZqh03BHQHI1kU5uJz//N6FQTYo7wHkhOYqrEMj5ec/AFK9GjKEDOCi/ZAEwBV8fOOhAGiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UaWPyRaL; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-301a4d5156aso10204354a91.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746025138; x=1746629938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79feuVbSA3OZXSuVa7NrT3EuBCFmbt5HBuWm1ioEXwU=;
        b=UaWPyRaLKlK6Nr7pSTBKhlNV+rJUbbB1c/e1pbqCCdSGHGztq9r3idCT5kXyhCnV03
         18Jmxi0QoekEjpJDwRrJJylaOGKsNjcWZ9BG1ULG9hKTMWbzCzaOXS8gZR1qiI9unQtO
         wrnyKfNfu90uG+O2n9khjOpx1yhHwTOUAUvdBG5A/5hVD7SSxloqfWdGYw+zA2xCzFQH
         UaB8V6xPks/VTaz7WpQXB16uXhFsQPeVO0BlFOe2zUw52KA13d2hYd3FfZAirjJvQgx/
         YYxBHhK0C1+mPof62JEMZ9lpKuvQv731FZ9b7jOjDnNi1rNAaMhaKnxZy0GCP2p+kdd1
         6+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746025138; x=1746629938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=79feuVbSA3OZXSuVa7NrT3EuBCFmbt5HBuWm1ioEXwU=;
        b=J7bsAA57VFwZWKxHFWTSL8vkwLs4HI4+Av2xHfLNNmjn00UDXzCwbEmCL86vX+rJfx
         DYDMNYyrvxGkYJaApQz8AYh3zVd/vVnnHnWCUzoxPNJamltHdO4ditpAh7uhC7w0yCI2
         5iM9ikPuydoPIPrm9k5PlibnXJOYWcGVwsyB0SNz306n2lH2qIQGa/7TfqKPeS3tTIGy
         PC7OzYuOD8P12lzjwbXcbSZ6nMOLQUhS4B4X65o1YziDDkizaUGnIkg29rzRdWurAGr9
         aWD7qqASaiaLnqPtFSz3TN6qapsjGAeLntqYZVERoyxj7oHtg+14Uh84dbl5v496u8Ga
         t4LA==
X-Forwarded-Encrypted: i=1; AJvYcCXVaf04ZTymbyY+Yd/0plzDf/rSZKTSqRSpfaac5he1ABzcliM6XNMFSFSFR0qCi05Iwa4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZX3V2q/9IQUG5fg6+gudxXqQUbiK69UVWAbAfzIW9c5Iwwib6
	dm8bFkB12hvacf694EheU1UCVzTH7AmrMTmbDWhCKmWwRwofH6ck285ShqelvYE=
X-Gm-Gg: ASbGnct5hpW0xv+Tl+YdPHaEgogLSXJZIVTeUJpyfv7G47m2VyYi4plhcEvugufdMA/
	tuyk6gHJ+DQzh0j8a/LhDJAkA3gZEzt0HcKlm2QI2FnSVqYM4iUJvQ0Ud7eDGIoIaBqo73CIIVN
	lzVgURI1Y+lSfgUKpOmJThLbgQnCCbDV3jNNei/OAqGWU59U3a2OsYadksoDE8sjwaq7T7zmsXv
	8eJT97/Nnv6fqDGUgDETbMl7yAKO9oORQWJsB0t5lSnwz9baQXb4h10YssgnB2yPqk1nurIG1vH
	jCfpwdvcAsI/wKmwMLCX+9bnWLcKq7GybvHGhHEI
X-Google-Smtp-Source: AGHT+IFcPSYMEawhY5AFhMcqnmC1qmJS+McSdrxVpFL+4NerpRE7eHPdIhkyAZPWxp5bRrr56/ggDw==
X-Received: by 2002:a17:90b:3c0b:b0:2fe:ba82:ca5 with SMTP id 98e67ed59e1d1-30a332e99e7mr5932263a91.11.1746025137624;
        Wed, 30 Apr 2025 07:58:57 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5bd78sm1705652a91.42.2025.04.30.07.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:58:57 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	richard.henderson@linaro.org,
	anjo@rev.ng,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 08/12] target/arm/cpu: remove TARGET_BIG_ENDIAN dependency
Date: Wed, 30 Apr 2025 07:58:33 -0700
Message-ID: <20250430145838.1790471-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 07f279fec8c..37b11e8866f 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -23,6 +23,7 @@
 #include "qemu/timer.h"
 #include "qemu/log.h"
 #include "exec/page-vary.h"
+#include "exec/tswap.h"
 #include "target/arm/idau.h"
 #include "qemu/module.h"
 #include "qapi/error.h"
@@ -1172,7 +1173,7 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 
     info->endian = BFD_ENDIAN_LITTLE;
     if (bswap_code(sctlr_b)) {
-        info->endian = TARGET_BIG_ENDIAN ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
+        info->endian = target_big_endian() ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
     }
     info->flags &= ~INSN_ARM_BE32;
 #ifndef CONFIG_USER_ONLY
-- 
2.47.2


