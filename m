Return-Path: <kvm+bounces-41605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D1D9A6B0CB
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:31:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91DF3982C0D
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1655B22AE5E;
	Thu, 20 Mar 2025 22:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dBOOI2GB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBB0221F03
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509819; cv=none; b=WeTjVrhRlSvrM6ykD0fWS+S1PEvdJSC1KqHrL8I5y9IIUJQiqmOiYrn4YE18he+7q9Vx4LFJT2tGnl7LOSnKs55VWKhPil/e93b7vD2BsY8mPm9xTll9PF8rnNcvO6dp+qqG7BhqiPxchMU3PGxIpX6U8SvbNQhmwxvgzv1H1Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509819; c=relaxed/simple;
	bh=9zNj2XkRkHrT06K/ZUvnQVsysdZQvAtd1j8xN57g5Vc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RrWkOzkwTSzZa0wWLuMchfzh6uYKjBHqwTsK8frgY29uInTJ9cXQulcdVzvbh9DMDayMIydVeq69kX+mcR/+WpuRzqXhwzhC2j94SIelFrXMvGm2GKFYp6gyaGPDAAzHh3MvGGxZYLMFwmhChNVOFkVA41hCMWXRslT5Rkk+aCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dBOOI2GB; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22580c9ee0aso28032295ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509817; x=1743114617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WS56+yaDx7XPqQTsxGbqAzPgp+EeucvCf5WClfPP9c4=;
        b=dBOOI2GBfEVYwo7tyD8zqbnsPFAcxRV0frYC3gX/EuE5CE9kWrC6DTjuOnTpTMr4Hu
         K9y552KgR+s4kmntztIyWE7MvYYeV5psZJ7LZpOE4PCzxdcvGhZPQ11+M5q/5+Vut4nI
         rZ96Vz1HC+/ci20mi1CvohmCMVQPKK+39uqTKrakGeojMaSc0jSjro8asS3qVYVQxhRj
         b2/UVB7CuSZtJLos0QxI3fezl256Kj/HvgcSk8C8DjTV9mHH7At6be39Rx+9knZZo6Of
         CrO/RwHDiNl0zpMQEsryPUxkK19g0k7oAfYnI/C0a3yRLeWzMpy0ibCzdiRj1u4NWu0V
         /5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509817; x=1743114617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WS56+yaDx7XPqQTsxGbqAzPgp+EeucvCf5WClfPP9c4=;
        b=h3ea6ctyDUdLGOuwayCTUu7H2osq03asbtEOz9lpP/m/Zph/KUJGxhMHCiFXEwSyIq
         noWMlLi0Tm5trg8eB9YUQk+yV8uNBriL7SBwMOsOeCq9M3mMZNPriZkps1Yeq0rI9FRn
         Xq0SSvKolgajGkVjv7vKM1/B2ARJ7+6wS1A0aPePcsKcxy1LjSn9U8XBDMIdDm2ddNs7
         lFDYosGDN7EWYYfV3Dg0bhvMAO+9pNxmYVa5LlYUArmoRtNZ9SqSditp5mlwifZRAxjq
         FTPX4sWlhKBwLxXwZt2P4eZjSIDf/iEqiCTO2TeACM5pGiI1Oii4USa4Ypox7ZPpNd/l
         sglg==
X-Gm-Message-State: AOJu0YwxeGgkt5NvPTkR/kMvXd42tZCynVqMzednB2SLZwMyAcAgb2n5
	AulfO+XWB5ARBoNBEsIGP9GU7mvZDW3R1WCIDqxt24rjLfqyI5Ju8RsKSp5ul3Y=
X-Gm-Gg: ASbGncvkgMMQqgLo7HTLBpNuVQfT0SgzdmKn3U96nF2pcacUvnjXZCXBL9fU6Qgpdo/
	+vCBl+H7iIISLccApdj14YjVVEsTc/+qUs6blp4/SdalpvW4bxHnEBo2pu4BMefmqdzLOWlizTN
	G43LJTgKwLlPJWNbxamqub/XStm077oZDxpllzlkwjKo/B0DmywvMbcDM8riTzn4579ZyqV5B+j
	/0lir8+tT3HhAw0qlYpTSjXl5Bk87hggO6G4ELjXg1uIBI+1Xx1QOKNCLZvNfiAgBFbXcPxl0wP
	KX6pyf09ymsP70mujonnLXnqVxa7dGU9nRUb9GO3ptsh
X-Google-Smtp-Source: AGHT+IG0vzDaHZgnC6rKOEx/scdI1YP63Fg9bCy7lK0T8agjJCI/Ay2Ce96All1W1vTYmlDF4RvBEw==
X-Received: by 2002:a17:903:41ce:b0:223:f9a4:3f99 with SMTP id d9443c01a7336-22780dacaedmr15783575ad.29.1742509817000;
        Thu, 20 Mar 2025 15:30:17 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:16 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 03/30] exec/cpu-all: move cpu_copy to linux-user/qemu.h
Date: Thu, 20 Mar 2025 15:29:35 -0700
Message-Id: <20250320223002.2915728-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 2 --
 linux-user/qemu.h      | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index d2895fb55b1..74017a5ce7c 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -32,8 +32,6 @@
 #include "exec/cpu-defs.h"
 #include "exec/target_page.h"
 
-CPUArchState *cpu_copy(CPUArchState *env);
-
 #include "cpu.h"
 
 /* Validate correct placement of CPUArchState. */
diff --git a/linux-user/qemu.h b/linux-user/qemu.h
index 5f007501518..948de8431a5 100644
--- a/linux-user/qemu.h
+++ b/linux-user/qemu.h
@@ -362,4 +362,7 @@ void *lock_user_string(abi_ulong guest_addr);
 #define unlock_user_struct(host_ptr, guest_addr, copy)		\
     unlock_user(host_ptr, guest_addr, (copy) ? sizeof(*host_ptr) : 0)
 
+/* Clone cpu state */
+CPUArchState *cpu_copy(CPUArchState *env);
+
 #endif /* QEMU_H */
-- 
2.39.5


