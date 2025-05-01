Return-Path: <kvm+bounces-45037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 81A8EAA5ACC
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:24:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 067421BA7235
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 802AC276042;
	Thu,  1 May 2025 06:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a7UojSjJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD142609F5
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080640; cv=none; b=Orj7nuvW00z8XYT9vbHd1YiJmmO7qcEwNlaqw61ZSHyfQgRaHX9QvMylw1RsFDIWlBPesRAeULrfpMjCRjYF9i+sZV+27lC7HpBga7mRMjDWTT+/IB4QJBSw7gQEYlkZrecht+ea0mz6ELzUgZNdvc5uD7GkysBNj4EI4Z1cJlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080640; c=relaxed/simple;
	bh=5dU8sJ1mvPjlcT7KWlYDwmydA4O5OvIDqk1Hw4oaHAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZVzrN3cMzJlYzplWNx/tA7SGu0WJbqAoT1AmxALfhbion9iBER86Y65brFr4wSVMgv0jgoq9dwYHQAoyDNjNSvUlvibUPAFbG5KxG1SELXYupnHWNuekWbWOL6YPYUNqH6R/gA3+EIEdrxpv5aNCLC7YZcWwsBSprPVoF7xP7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=a7UojSjJ; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-736a7e126c7so601547b3a.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080638; x=1746685438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LuLpPX6X06+NE7HHzhZQmUoQgosCpwXTe/wCgu+rNqA=;
        b=a7UojSjJUx7XPTVvoBEy2gSWYMcNV98FISlMg3jkpinV0a+Qwwsf93+lguE1fe3iJv
         Wk0QYvrS79M3ys9Xc4wbYjh9sqavOhMm7mM7sj+gYwjVrBdkWYiN4RsJhFQEsJyLzZAs
         hvA+GGLkU0uL0qAer90hRRRG2eMl/hmYJbs3hds22h37IcDqtBEe2lCQLfzfs7OrUnFy
         kv/7K96+jH2e2CiCci8fpYXjBJMd+xYsepIvYWK4Tc+Lq1ckhl3DP2jvTFPGd7PFHt2D
         7GFHe5806bSQpZ4UJkyVZEdUXuGErRjtcaWnLcEFSM24n8P0rFXo8S/rKkdl3uUCXZTd
         Nopg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080638; x=1746685438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LuLpPX6X06+NE7HHzhZQmUoQgosCpwXTe/wCgu+rNqA=;
        b=Ja3kpPCHcOwm1SQGH2n8cQa9ukInmV8sJh6lzftxgoQYFv22+U85+QfO3i/7yTBXXW
         ECNNpLrOdFvEtPxIABfeiikGBR2aLhcE0UqaA/QPaADvEeXHUF43oxp6URPM6TXX3tME
         +1NsOA9Kq4cItxIsxPbo/UIcvw2032vfESbspIQXXoyFA9dtJfaQQFNDz+KtoMQ+zUnj
         NdzLG5S//wef4aEKLWTmyyD+lVjNjkrQY9lMYJgHmVI4zBT65CXzZZFQ5OWU+1NRpyWd
         O6MuSgmT0he4L0ylYh+3D3LBWVYKEYjBxWVnQ5gI3WlHotm1/bSQzlREvKtJv+gv7t6N
         jEUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVD4gpckumNBU8w854CCfIkeR69cta4mlEgEm5m8sNioUn9eRWJ4GVgOtCZ43W26xVzblc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1gWyDiy2CwCrKIn4f2X4weWKo/pQR3uBTCQMVaz24NkF44SXT
	SX4O+jfwpX601iqQz/BgIuyGae9e+oFIIeb9JexZfN/Ttc/rb5PCej2XjPfvRMU=
X-Gm-Gg: ASbGncvPX7eByKYSEtUfZyd7nfUwKU50tDv0Bt8BD63X67sCv4TozV4MQmHhDkqgYa4
	TsemBNEghFWgwHlrxQOu6Y/3GbHQucyaQ7EK3BskHpjjSrr3I9mYfDglMfnhpONLw59pqE7BwZl
	BbDnyeOBYSL8+8txSrtlp+HLe2QcxItlFS7YHCtPKGA0oZGhvDK10B9dAYz4j8qY313/gKxLTjj
	V4OOXG/272isjN3xK7zikxfVQb5e9NJKJEN/parqH+WuCZUiaMPe/FSSDp0SZbsLNNVejtXVDlv
	y/iZHI74s0hPiabxOwa3V1oLmwq2SXDqcqSN0NCr
X-Google-Smtp-Source: AGHT+IH613J6jBPOj6ZjFX3LRjtYIvyadYMSVvpnBOyMYotPgpUzTvOi4tNvNr+D57Mb3NRqdNtA3g==
X-Received: by 2002:a05:6a00:21c3:b0:736:2d84:74da with SMTP id d2e1a72fcca58-7403a77d3b8mr7327701b3a.10.1746080638522;
        Wed, 30 Apr 2025 23:23:58 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:23:58 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 08/33] target/arm/cpu: remove TARGET_BIG_ENDIAN dependency
Date: Wed, 30 Apr 2025 23:23:19 -0700
Message-ID: <20250501062344.2526061-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
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


