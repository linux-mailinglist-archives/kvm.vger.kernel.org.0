Return-Path: <kvm+bounces-45394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 163DBAA8AF4
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:57:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB0C61893DE0
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 305421A8F82;
	Mon,  5 May 2025 01:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Eovlzo3r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20301A2632
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746410192; cv=none; b=IciJfq7iBB1oDXGNOlJsVLojgZ1VJz4KTa2nqYSvxYVL3EyG31AUm8GNLNxCMXMNgMm+AIQpakjUoS1LnGJGGYEUQd3gALB1cNzbmcm9yjmZnBCOo3KYh8CAl/UEtoEcSfoJrLo+oxWJBcbRyAQr9DYzoV8NDdLeqwfw1WMvG+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746410192; c=relaxed/simple;
	bh=RToyGiC3TvoyRDiW/mQfhHfNlzhXxdP0XsvppCc3AdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYb1xJNEjo3ymqlYLlJLmVm4FPmg88pVO2nbSBmT+dEhfurGWb5z34w29wWFM4hoMO2/x2WJFPFrDIhrOrc7EAG++d3Hgs0hR97i3JJjRh8iA0bQR9gvQKz600wZXJhcUDPdxxQVJpa+/Yg+vwXbE1knpgwrE/9+upjYCT8Up0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Eovlzo3r; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-ae727e87c26so2353915a12.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746410190; x=1747014990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TH/D4KCEFHBYkSCcvDFfFBdITHDf8vFzzXvCaqLo6XY=;
        b=Eovlzo3rMZJ7cO32jZhOJ422oIpvUCRIrYmDBabO3746ohMyIUnv4GneSnbRQsa6WF
         MfiUdgyX8L//x0Bf+oYLTNxt7NTriW0t3HhVVhkiXwRRXNYU0OaLZVOiW51hH0CJ1aZD
         eljVuEYCdJVkKDA8/9lFh1ZiGguxZpKdZw1AGE3KFmEJ0xai1A2jxXIq81+vVbCyOtkT
         6u7NbK/UIBK5NGQ4wnfFNLdBd7HMlIsuaHDMZuMlwd62WngE/NK3MNd8ne7zxNGQTmT/
         7nkMn44b/WaF/+r8rnxhOevklWm1J6n+/IPVSj4qzCFC0QTxaCV17IQRhL/U8+aJRdiJ
         XbiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746410190; x=1747014990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TH/D4KCEFHBYkSCcvDFfFBdITHDf8vFzzXvCaqLo6XY=;
        b=ew33znTrkWszyXr5uMP1xMEhotwlzxb30huvpa6Tb9Anz1WBsvg3UDHE6LfW5RtdBN
         BggB+XLKOhJHmSL1wcjLFoTgoKlqAgpUpiIOvFWHZfo8gXvnNL7EG5PnmkeLSnpaXYF6
         0iY4hyB+o8yqrlMC3vENB2bfwOMKb1+Ldjc9YbY5RUgMc1zZpc85Q7P85zYIm4/4/3Hc
         W90d5C3+MAKaHPcBinxd21CnZxe04wgIK5TIsRyyj/4F2+zKr2k/xG4xLwRg9w81hJZ3
         s5MN67KD+EiEI10eX3NIbiipywQnxclm1E3MT6GUwGuXwk8sDwTzgzJo2dNdrlW0BKoQ
         ROog==
X-Forwarded-Encrypted: i=1; AJvYcCXO3NOBCJcR0bNXnwI6JkUbuLfZgPU4SiLEF/cjKIaUC2Zw0XS2TyPkbhYVtufriu7Zs+E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzwoCpMXEdZrdYmRd2STorTpZWwcMacg6bnFNK4hPTCJxGQY/4
	owiu2EgY9Vx2aDNvahtKd+wDXq6D+vh5A1lHW20xz+9C1QMmDYF1vw0NyxOlqSNB4JwH325Lr+V
	yU20=
X-Gm-Gg: ASbGncu0x1BdTn3z55+3C8C62UuL8+6oxMCrvoeNi/cqX8Ogq2v8ejsKDfB2M9KX8OU
	0Qe7HAJfPD68y2Nm50KzH7VA2s2LZCB1sgknj4hHa+0iLn1nrI9XsihKqxsBo8C03yJXjpmVUh5
	NuW691l+reOkO19YslHI/4JUBwPk2f1Mwfi2lcvi/IDW+4/N5nQFd6WWB036D6wO0sjZ5JBHpgO
	59f+KnaWOocnhnb/LSrzwiWiy9X/+vSDOY55WFtJ+ah/xIpa+ny+7MEt+limHfxiYgcXa+OBqz8
	BdIU1DfmHk3uvkeqdMMUjWDVCFJIQFZOyh/2lhpp
X-Google-Smtp-Source: AGHT+IF0Ds40ZHzk08K/DrLbhYF01+YRnck2UbWKHsPrY2Ni7NasWl6bG7xvvtKEwRf6w0IbqqPYqg==
X-Received: by 2002:a17:90b:5704:b0:2fc:3264:3666 with SMTP id 98e67ed59e1d1-30a4e6914cemr16806185a91.30.1746410190151;
        Sun, 04 May 2025 18:56:30 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a47640279sm7516495a91.44.2025.05.04.18.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:56:29 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 47/48] target/arm/tcg/arith_helper: compile file twice (system, user)
Date: Sun,  4 May 2025 18:52:22 -0700
Message-ID: <20250505015223.3895275-48-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/arith_helper.c | 4 +++-
 target/arm/tcg/meson.build    | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/arith_helper.c b/target/arm/tcg/arith_helper.c
index 9a555c7966c..bc3c78c5011 100644
--- a/target/arm/tcg/arith_helper.c
+++ b/target/arm/tcg/arith_helper.c
@@ -7,10 +7,12 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/helper-proto.h"
 #include "qemu/crc32c.h"
 #include <zlib.h> /* for crc32 */
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 /*
  * Note that signed overflow is undefined in C.  The following routines are
  * careful to use unsigned types where modulo arithmetic is required.
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index a5fcf0e7b88..ad306f73eff 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -34,7 +34,6 @@ arm_ss.add(files(
   'mve_helper.c',
   'op_helper.c',
   'vec_helper.c',
-  'arith_helper.c',
   'vfp_helper.c',
 ))
 
@@ -59,6 +58,7 @@ arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
 arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
 
 arm_common_system_ss.add(files(
+  'arith_helper.c',
   'crypto_helper.c',
   'hflags.c',
   'iwmmxt_helper.c',
@@ -67,6 +67,7 @@ arm_common_system_ss.add(files(
   'tlb-insns.c',
 ))
 arm_user_ss.add(files(
+  'arith_helper.c',
   'crypto_helper.c',
   'hflags.c',
   'iwmmxt_helper.c',
-- 
2.47.2


