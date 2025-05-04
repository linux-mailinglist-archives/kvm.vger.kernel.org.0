Return-Path: <kvm+bounces-45302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B7FBAA83F2
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:30:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8AEE179F37
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59FE7191F89;
	Sun,  4 May 2025 05:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PJibUj63"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0830018C322
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336570; cv=none; b=YhM1uitXpaVV6C81ooGgCs8faUNAquUqn994lf+PSrzbKOvvu1bEWKXVF/0GfSPjfWpevq0M76pkQ8qXDlTG7KFxvQCm9RuoooibD8ZnLfZ9poOKlGZmsY1zapaLH1/Kc5rdSzN0FWtFIzWUUCcSvd0lGXWHJhrFnshP5zZCueY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336570; c=relaxed/simple;
	bh=5dU8sJ1mvPjlcT7KWlYDwmydA4O5OvIDqk1Hw4oaHAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggtmz5ADPb8y203sceGwKi6FjhnWb5hHBFoHX66DvLPwiVrDwSe21m+fxlJ8GpQMMHiLlxBxZH0PQG+HqZBh3uZqLQNg9PnaZMRHawFa0oA8RHfpYOInzVNxadV6nrxSGpUzmfsHSnHwGD7uhINoErYAmD/8Lzoc0KxrZl8JAKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PJibUj63; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-736b0c68092so3043384b3a.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336568; x=1746941368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LuLpPX6X06+NE7HHzhZQmUoQgosCpwXTe/wCgu+rNqA=;
        b=PJibUj638QAfnNeYJc0IbaKupsS+5UDVYuXQf6cdvj4F1h3A1VpmfeNGPLHUeUd/s4
         EsUclw3Xw5YU7t3djzMTrxBFeJcNYwSsvFrJac3yWe6jEY7LdXA1t/uqwViuXC3D3MPu
         DNBAXVb7iLPrlE9yWlBpFVJ/4mT5jVZ41oudEZmc8eHvCy3AU5TiLjxrvD8aXV0N2moY
         vW9+n4HLS8Nw+q9KUuUTQLvxIbBrOeforcB4qPqN/nFW58MmxwCbCqcrbo8eN2/i7JGj
         ZW0NSIYqGga41exE/jTuxH66TCXCizHmnC6gwoBiH4/mZfzmWF34vr5O4CL3wJafVwyH
         C5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336568; x=1746941368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LuLpPX6X06+NE7HHzhZQmUoQgosCpwXTe/wCgu+rNqA=;
        b=bpcE6O7jlcDxiRYp6Pw3HKWXiuNq1viyQbP+fImW8/W/BHKpyxUCOMSdx8MRzC5Nks
         WAqka17NEKZgULEaoAm0ZGgCzSjRl9zOPQtFZD06UCUQdaYaUYMo4vRbsWOPk3nHtLsr
         j5XgvSnEfqb8ZQiW4PVy+z5rGInuowLtfmOU1f8a+n/MSWfXNIfqba2RAwitjY4onkuG
         MetTIsoMPFbnLRqvmnW+HtHpOsZ0wlMa5g03c+fNm6RsOX6MGY2M37rTbhAQ2+OSoA0s
         kUdDEUsr6lxCKil1cYt2s88kqwsGLCNzTykT2SQ1+b78Vii64OEKKCCbfh8pj/z3ohfP
         7Ofw==
X-Forwarded-Encrypted: i=1; AJvYcCUONB64CdkIUFZ/2/64TY8iQweoMlqcMD0CsUcX/eZbZM3ap1Da2VXrqNH0SwuzYrDf0Nw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsnzGOW1eN/eurJ/rwJtFSBsflUoE5pv+crt1FPacuMzwLIUIW
	JTFB0pMVKEnzpTP1iTqMwmR9HGv7KbF5g+tjRBlS5+wVnGwV9IeIN+iwISMjTDA=
X-Gm-Gg: ASbGncug1ea79pKq6Pm1nKT9Q9Q36Rkp8zxbULaWU6ESiopE6Bf0RjacaPfQvGEFYVV
	5YKsrB2A7JZi2IHiqXymaKwpKrUzTFtM/ZJDPKsrsFEgaObJBMrz+5dSsdCdTfCcG4/9oDk+Hh4
	z5Uig0JC+OEL6jsh7HrKDZvcOH3mHnsTPhP5RMk3adw/p0S7UyGpkmKgdMLwXah6wMB/29HyJ6Q
	mK+yE+3Ix1qaqjX8NdAbggG2nXU1K1/qsPoNEv04l7GknEWh3ismIc5YXtZaImu1sf/KH5dcB3U
	jyTd2wuawUNxphgSv72ICBornOehPrqIaGwNEo4Q
X-Google-Smtp-Source: AGHT+IGu15PBf2rG0jV3bfDUJnP/9reL3xvY3YvbbIU6AzYvR6V/RBuTvzsbzlIgf0athadGHRLk8A==
X-Received: by 2002:a05:6300:218a:b0:1ee:c7c8:ca4 with SMTP id adf61e73a8af0-20ce04e699cmr13507222637.36.1746336568319;
        Sat, 03 May 2025 22:29:28 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:27 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 09/40] target/arm/cpu: remove TARGET_BIG_ENDIAN dependency
Date: Sat,  3 May 2025 22:28:43 -0700
Message-ID: <20250504052914.3525365-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Anton Johansson <anjo@rev.ng>
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


