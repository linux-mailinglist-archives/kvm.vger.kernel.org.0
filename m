Return-Path: <kvm+bounces-45811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E354FAAEF91
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:47:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58C2F503FFB
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F9B2918CD;
	Wed,  7 May 2025 23:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rM4hKGMQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC98291875
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661618; cv=none; b=XSH/lhmBFnViMq0baRvCzdRnBvVmfW15SveU1bMZDiftgTSSpl9SAw+4smfD1ZCDJ9vcF7q3OgOSs/zGylM+ZsXXLjmAfTL+Obs9qGQR2J3GbmtJf8swmw9f0FR1syqpQ6JVfKEU52V04BCXwvg1aFp/Q4xymxMUKudc2HLeTpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661618; c=relaxed/simple;
	bh=klHAVfNryV0k23cWvtZlg3qSOnFFqbA0lqGW+gJPy48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCRqkDKIJnSTfjTbYiaTJpw+v60vKQf+dIUxHfn2xJVxmTHR2smyRXnm+ZPa3pPyNUf60ZN1tY6Mo19AIxeey17o85pbtHOI+t+YZsr03N5MxMwx3Fi30cp4lHxZk/KIxsJwR7CETlrarIEpMUu26Dt0wRNdTrRNEuQ3j62ced4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rM4hKGMQ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22e15aea506so4849905ad.1
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661616; x=1747266416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XN9bpcu/hK+eTVDHriw8+8GBLuzv6l51ao11Y0jPFbk=;
        b=rM4hKGMQYrvBnB89B0Vp4rdz1cf9223CGFn5NVJf6XrUPcihA7c39LwjzuF3JV4hjN
         Hp7IF50Y5DQFGBmvFQxrduBOknD52xzrPsQZLhTpMFuhWGv0y1HK7WSNx/DY7eeoYp1j
         d3wvrNDQcfWoMzp8nTVC8aS3jH0tKsV/oQLxVEJgbN3UYn/j2QgtlMFpPThbaCvCi+uE
         PG1jkAnteRD1mqyg54mCm3+JsK631s35KFruxBtAYvX+AJYuSNme7/D/OkIMXs0uk+Bx
         h91hWNPGvEAGtFw+P8nQt9hfNmSPMeKQheYoV75GNvcpigMDCz/an3ELTNNb1j+bvi1i
         A3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661616; x=1747266416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XN9bpcu/hK+eTVDHriw8+8GBLuzv6l51ao11Y0jPFbk=;
        b=DK29WJ05A+h9mSqf0JD7Ke6nKCDF8SShzu/iS4RFWWMA7Oo2zKM26GHBvNZnF7BLtJ
         N4uFDYTiuuAnh8HiBpHmI1PJ0TfZ4nvWJEBsLkjcLeSl3WQhjixiacleW0MORDENxJXR
         flToHYQxZqNEcczW0EIgS4r9yueyLR3zBEnk3gHuSc3GND1F+OXZCaVl/g2cTtatbkfF
         KFXjHifOp88LqteAmjeE0m+C1YFD+DspXL62g4xL0FgCnxUBb9ZQ94MtNlZFnHMHVhsH
         nrwUYAQD1r+fSkuWDRBazyZDoeQnX2qce6iqlqZhbnt7MiFCwX5Irory0P3mq9OHhoTF
         01Nw==
X-Forwarded-Encrypted: i=1; AJvYcCWPgoqCxrPXfgOypGx+ouT0mNSRgAr63GXv/KuEywei2vy9BJTBVqMYKthq7I7JvyC+/HQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDobwZJSlHMvJ3FP0hc4vZt0132MbBrR9zpCMOA6InCJP/fK50
	S9YHQIkvyuoSbTzVaz+9f/IC+QFSVKHbO8qNPd1kruC3KPzGXoUWmACDH4t33EA=
X-Gm-Gg: ASbGncvC8c9zC5aZbyG31qp4lvvOWXO9x9QN/OPvrWvFMh3txwUFqTJt3mwtorEQ3Wf
	vt6DXsvhM5ow0vYPrhBAiLgCTA5W+NKUledWL9fIJy5Okm7D8YPSrPTBwjXeD+xcjDW/YR/OAly
	AkwV8ilfc94yznb1MYgVdlxhqAQv1slQCrnbIgIL1TS+nP03kB+s3xzCRp9w1cyx0p02+7ZlTm7
	hB+IMHaAjQ1dtfc07UsXV1IprJ9ilTdoDRO6XFyQhg3gH2ucLPqp/xE9Bs1Ihh8K8qg/Au5d+Aw
	hvP0B12ytZIdUtE+LMyoRAFgM8NdkuEa6CB0H8dirngwHuF+qWw=
X-Google-Smtp-Source: AGHT+IFW315Q4I5LNTZ0KdNHko2uJjnjJeUb0CDoTdZF1UBuRUefk3FToK74LCS1f+jcPOOcm+QMCw==
X-Received: by 2002:a17:902:e80e:b0:22e:5a10:fc38 with SMTP id d9443c01a7336-22e8d7c843bmr19512495ad.41.1746661616140;
        Wed, 07 May 2025 16:46:56 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151e97absm100792435ad.62.2025.05.07.16.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:46:55 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 45/49] target/arm/tcg/tlb_helper: compile file twice (system, user)
Date: Wed,  7 May 2025 16:42:36 -0700
Message-ID: <20250507234241.957746-46-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/tlb_helper.c | 3 ++-
 target/arm/tcg/meson.build  | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/tlb_helper.c b/target/arm/tcg/tlb_helper.c
index d9e6c827d43..23c72a99f5c 100644
--- a/target/arm/tcg/tlb_helper.c
+++ b/target/arm/tcg/tlb_helper.c
@@ -9,8 +9,9 @@
 #include "cpu.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "exec/helper-proto.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
 
 /*
  * Returns true if the stage 1 translation regime is using LPAE format page
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index af786196d2f..49c8f4390a1 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -33,7 +33,6 @@ arm_ss.add(files(
   'm_helper.c',
   'mve_helper.c',
   'op_helper.c',
-  'tlb_helper.c',
   'vec_helper.c',
   'tlb-insns.c',
   'arith_helper.c',
@@ -68,9 +67,11 @@ arm_common_system_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
+  'tlb_helper.c',
 ))
 arm_user_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
+  'tlb_helper.c',
 ))
-- 
2.47.2


