Return-Path: <kvm+bounces-41614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5B0A6B0D3
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C0A34A0106
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E3022C33A;
	Thu, 20 Mar 2025 22:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fvWb7tbp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E08822C339
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509827; cv=none; b=IUiET/nclg5/49hTjrHRqNaUK3AF5dsTojg7tT+fQ/LKGZnGTwvoiZM37sLP+7CxfhB5nIsJ9JFW02iI0Vm0Nac8hO6qZrVs5WSXdZGONMpnhl1yFuTW7gMFdR5CMRSrnwitWjPFGs9s2pKw42u/96mcu43FAx0M6EThZxaYV9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509827; c=relaxed/simple;
	bh=VVfFlj7WHtwyAok9VQgfuRN1F5FCRFrWQt6kcBjnhkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R4JON1Y7A/Bpambd+3tvJ5KQ2OmJm/G+18w3ZM8zzNmQTtZzmH7VsRToGw1oeo5+5vwZkupusc4hr0MzodCPWT6zfT+Ru1esL4N1n0F7rgjn5Gr9idXmZb9UJ+9mL8GY0Trumh8pLAkvDdvWhFyzii3HV/TD8SmgEEvsWT51Sas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fvWb7tbp; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22548a28d0cso36158045ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509825; x=1743114625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pRpFizF/E4rJtnjS8JYR/AaD9jyyXl0WSOs/w63P0CI=;
        b=fvWb7tbpGnPTr21Cv5stSqrmCQISB0dhwCpXQXJGoxHFuqzx7IJ36vteZXYis/K2pb
         bA4hKpG5v/+a1iqBAJVfDFZKX/jBrQdXUpJCubjwKd/UlIegJ9ZRDXJhJlDRdGRaJbn8
         F6MOjZWRLzPGNKMgSp101mkqCJMCBdnBbf1s3KjQqXSlZ4sxvdvYdM4sR6PvyNI9Wc0V
         LPGPMGWlXgFw9zBueA134hLrxymsJX1aR6m18A62MfC9xEe1EJ0GuYJUmp6Q+1ZT0W8C
         SDADXsjRZZFNUPGnWYu3YjjCgwVKRQlHK47dtz7Lq9YWBHqPkQUsNpCtF9KFd+DAmMq6
         VIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509825; x=1743114625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pRpFizF/E4rJtnjS8JYR/AaD9jyyXl0WSOs/w63P0CI=;
        b=bDIPmaNcqB3EIDalHx9Mc/OOqNjVcJB5qR313Ix4YSdIWkplVmwGbKU721s0BGL1WJ
         95z3GcqxaXo1loKDzHSA0HUKof1l+2KDynBVusWg1dzGolgAmyZzQN3m1NcLTl3I0fUk
         ehNr2o8+QFG0Mzpn5Ce00+E+7EnQkFHFJeplKK5OOfRi1KQDv3EnZ6IMcHXmkJYL30aW
         OZZoYOAZyVYoTOnYwfKleeQhSdxV3nKTM+8FxU2qwQH9qFD0XLT9GFENeH7lU/ZAfk7b
         8pEMNLe4wygukFu3NTHYFyTRI38B5EsMPyd1OODgreV91ZMfsTOPp7Sahi1hx4netbOp
         d6hw==
X-Gm-Message-State: AOJu0YziFCy9SnyG/iPuo7zm2qYsbzhaJzIX1uzGL7DAh6DchbIVr5Ov
	zymCHt+mrx3y5Sg9iaCbSEIUzBHi+g85yvOMdONlmmGxkTBKwTvmOZ2Bq8GVPSk=
X-Gm-Gg: ASbGncv4sGDymC14LSeiErfsqP5Sdjn/FuT47zhQr6h+dtPiylOVWWjsI91wOGeauM/
	Ld3pEtKrV5105O8uZ0x0fiVZyiHOGW5U+YH1lZ+4/PRaf+OqIR88+BrZWb+qmubyLjJL6UV93NZ
	JkhvG9CgR+HtFbqiz9jGhiIWOxtVa4biNFyEe6+Bd7gDOgVdiSTONeJyDChs0IT44VvZdwgcdYt
	x9IuVcApErgLfZuceuFYDg/XjI7/Q6mwaz3HL96Ifzm3igwciH+LXNPFyif5yqGA+6mJEcTMIbN
	fsUm3lzLVY3Wbt9VBlsWKjoJ1g0TYQMjWu8uGLQNyD78
X-Google-Smtp-Source: AGHT+IH7BU2m16/sgWEFUPShLOXk9J0IKxzRbCfN3ZFlgtRMYkB/snGd7MYIM9wzSgKzXv734g5omA==
X-Received: by 2002:a17:903:2f47:b0:224:376:7a21 with SMTP id d9443c01a7336-22780e0969cmr15319855ad.42.1742509825033;
        Thu, 20 Mar 2025 15:30:25 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:24 -0700 (PDT)
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
Subject: [PATCH v2 12/30] accel/tcg: fix missing includes for TCG_GUEST_DEFAULT_MO
Date: Thu, 20 Mar 2025 15:29:44 -0700
Message-Id: <20250320223002.2915728-13-pierrick.bouvier@linaro.org>
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

We prepare to remove cpu.h from cpu-all.h, which will transitively
remove it from accel/tcg/tb-internal.h, and thus from most of tcg
compilation units.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 accel/tcg/internal-target.h | 1 +
 include/exec/poison.h       | 1 +
 accel/tcg/translate-all.c   | 1 +
 3 files changed, 3 insertions(+)

diff --git a/accel/tcg/internal-target.h b/accel/tcg/internal-target.h
index c88f007ffb7..05abaeb8e0e 100644
--- a/accel/tcg/internal-target.h
+++ b/accel/tcg/internal-target.h
@@ -9,6 +9,7 @@
 #ifndef ACCEL_TCG_INTERNAL_TARGET_H
 #define ACCEL_TCG_INTERNAL_TARGET_H
 
+#include "cpu-param.h"
 #include "exec/exec-all.h"
 #include "exec/translation-block.h"
 #include "tb-internal.h"
diff --git a/include/exec/poison.h b/include/exec/poison.h
index a6ffe4577fd..964cbd5081c 100644
--- a/include/exec/poison.h
+++ b/include/exec/poison.h
@@ -37,6 +37,7 @@
 #pragma GCC poison TARGET_NAME
 #pragma GCC poison TARGET_SUPPORTS_MTTCG
 #pragma GCC poison TARGET_BIG_ENDIAN
+#pragma GCC poison TCG_GUEST_DEFAULT_MO
 #pragma GCC poison BSWAP_NEEDED
 
 #pragma GCC poison TARGET_LONG_BITS
diff --git a/accel/tcg/translate-all.c b/accel/tcg/translate-all.c
index bb161ae61ad..8b8d9bb9a4a 100644
--- a/accel/tcg/translate-all.c
+++ b/accel/tcg/translate-all.c
@@ -43,6 +43,7 @@
 #include "system/ram_addr.h"
 #endif
 
+#include "cpu-param.h"
 #include "exec/cputlb.h"
 #include "exec/page-protection.h"
 #include "exec/mmap-lock.h"
-- 
2.39.5


