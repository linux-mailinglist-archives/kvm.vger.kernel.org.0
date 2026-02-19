Return-Path: <kvm+bounces-71310-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cFUFNUmLlmm+hAIAu9opvQ
	(envelope-from <kvm+bounces-71310-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F3E6615BEDF
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 52788300AD5D
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 04:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9563727B4E1;
	Thu, 19 Feb 2026 04:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SjmOgplS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDA22116E0
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 04:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473732; cv=none; b=WO83YUkj9sOIkcnPT2QeQcsLPq7i7FpvxdKkU//SbF3y0F++jG5c5cMbk/M5Vy/nRvPOnVBmQPORINP2p01RvqbZi/bNeh6R4pYtjdhK/0mm0mwNvDQN/mhRrL/3bUNMUH+lcC5uHBcRZApCvBgTxqw3yKeSdwaPvjnjH09TqvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473732; c=relaxed/simple;
	bh=QDskWK0kFXVCA78wM2Bxyx80frm8xdqaolOOsKUlfTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GAqzqTbZQC5KyI2tBqXJ4GHFNn4CQrX8RNLyj+W3c5p+nJYcQYhk8j63XQveLojElLnM8/RFIZh7KSEYGn77FzRZoirBcrYtxzWsDYTw99iJN9PJj2kpUNskKzWXhXOSr07awWRVPh/OXAGRrrZjx+3fMgyj2kOd8RX48MUsk68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SjmOgplS; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a9296b3926so3220395ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771473731; x=1772078531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+EWQStl3OxtO/agizp2TzeqNHuyOddWzArd5felHRI=;
        b=SjmOgplSXDqcR7jKL0KjCVWzJekCDv0thuNslTcU8q6SmpgwvysmuIl5Z0zdAu73GQ
         jiFrQvSgO+7ETIzxkmufEsAPsDlK+tUfigNWrrRkk/to/p122syAHyQqTYKWZ3ghoMAk
         nihT4iGmpmuVxmkDbZxzGahp9ADgYvcLI5rXv+Big6s/aYNm34OWXnubXZYmcQN4eiJI
         18isoJEETJ3sLkR7kiayjEMqhjL5gmNL2HbntCOqW6UHzqn3YdpPtYsTq9iHK8tmE9Fz
         8+eKvQ1eEhSqjxC649fvz9CgAuHiBJx9ifCwyovUnAAtF7iDmnf+JKDxlzX44MmOTDZ6
         8N1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771473731; x=1772078531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X+EWQStl3OxtO/agizp2TzeqNHuyOddWzArd5felHRI=;
        b=K2mVr3Nu8rUKxS9abtNSL+6TKhBsdXoMMQChdiQFf5bqj438AIe6HvboxdoPDMQO4t
         K1UdG9DxlrOPBZ88yC8o9DW/yVDfq6j/wDCzX7JL4basKsuUjP1GShZICXN50SrWedyl
         M4LNfFwKb7/AzS3KJZFLr8w31LjMK44HnfSQUXgFFQpK1RpuiqeYdy05Dqy73LfcFPGH
         Terec7nAlfYPssGJzV3EWYXA3lrcQnCooBicZGHW4J+9WEOmLADYH+4wlaaWq2BULb/X
         KcokQUauzjXnPYhWYf+bq43NBisE2EFmmWlC1vO31jp8CJJ4Oa+vLRKRT+fTrnl0yhE6
         giMg==
X-Forwarded-Encrypted: i=1; AJvYcCXHIXA2/uMhDTBeT2lvH46+yo/JKFHTc0hEOzdmTBzu0gviIDdIMjixjApecMCV2+ooCeo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNX6XmCKkXDrvU/JPArxWQ3eaN9j5njh2wuM9jVVQnfqMz72sV
	ylxXt6k/BkY4UkeustjHGs4eLX9zflI0wRFUVccPeVmuY94RAWDy+SJGAYJuV+x2d6Y=
X-Gm-Gg: AZuq6aJVM+ioIGkgSEoEBHTeTCt37UA+9XVfxxaKdiBlppk53T7P1GJ3aXePfx+toZh
	07l1LBgs+kExMrWBufXnw2iFUzlXCWIDnKmqqy0c4T7aMl/Ih4Qb5JhsmHu/x0AP+H1zP3GzgMa
	T/FeHmG9x21Oq9IP5893xsAxIIFg/lAg1B/pUB0lq0SsdIhV9TtaQXn1g9UoM8pQ+nh/OUQIjbA
	r+w/k9CSL/vZQKHCGE3JDI2RNgSyBxQhwRLCOFUKcHC7IoEYYrr+38O7z/XYwTrFFJnn6gjCoJk
	9Blglan0q2nyayGzT9Me3CmdG/tw0HM+CTorCxwvSCt+4XOfryWz65QCvrAhwbTUJxbsiRf1AHD
	rnf4q44UjWTSSzmNPTuDTC2Y9hUytxf4LI/pbbGDxx6nxHntBLx5ta/ppUWx9h7cIRBpye8lYyq
	de13pm0UlbPYl4LJE3LeWvhsdg9qeRSADVBT59mbSb5mPfu3rNdqp8qYLsA4JsY7IYb+lOM58Vm
	ur1
X-Received: by 2002:a17:903:32c7:b0:2aa:d60c:d48a with SMTP id d9443c01a7336-2ad50e77664mr37975015ad.7.1771473730975;
        Wed, 18 Feb 2026 20:02:10 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm147636225ad.36.2026.02.18.20.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:02:10 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Jim MacArthur <jim.macarthur@linaro.org>
Subject: [PATCH v4 02/14] target/arm: Don't require helper prototypes in helper.c
Date: Wed, 18 Feb 2026 20:01:38 -0800
Message-ID: <20260219040150.2098396-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
References: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71310-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: F3E6615BEDF
X-Rspamd-Action: no action

From: Peter Maydell <peter.maydell@linaro.org>

In arm_cpu_do_interrupt_aarch64() we call the TCG helper function
helper_rebuild_hflags_a64(), which requires helper.c to include the
TCG helper function prototypes even when this file is being compiled
with TCG disabled.

We don't actually need to do this -- because we have already written
the new EL into pstate and updated env->aarch64, we can call
aarch64_rebuild_hflags() to achieve the same effect. This is the
function we use everywhere else in this file to update hflags.

Switch to aarch64_rebuild_hflags() and drop the include of the
TCG helper headers.

Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 8c5769477cf..033baf7e715 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -36,9 +36,6 @@
 #include "target/arm/gtimer.h"
 #include "qemu/plugin.h"
 
-#define HELPER_H "tcg/helper.h"
-#include "exec/helper-proto.h.inc"
-
 static void switch_mode(CPUARMState *env, int mode);
 
 int compare_u64(const void *a, const void *b)
@@ -9473,7 +9470,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
     aarch64_restore_sp(env, new_el);
 
     if (tcg_enabled()) {
-        helper_rebuild_hflags_a64(env, new_el);
+        arm_rebuild_hflags(env);
     }
 
     env->pc = addr;
-- 
2.47.3


