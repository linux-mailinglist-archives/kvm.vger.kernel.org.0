Return-Path: <kvm+bounces-51472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4777AF7175
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66B2116B093
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B7A2E5431;
	Thu,  3 Jul 2025 11:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MKnAU/pL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08002E54A8
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540512; cv=none; b=t2y4ceuo/wpH7Mdt44HN9Axc5zuUniMnJtfLHb9pARCd+Dd7T1W9u1Xjx2vEKBsChmZBvJs8pLsydWTPS3vAfHetUNeSq31eUx2Ys0CMzXZ5T7EbLg6SsR0PmgwCvwd7hlUl4DDgQmFq53WXodyCA2g5+lqbaDmIfYQMvQ2hX8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540512; c=relaxed/simple;
	bh=PMlWurEpyvI76NnWv9oCVuDyEkB6KfBERJn6r0u5pe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S/7oWQ4GxIvbivCN7iC1v8hX48ZaREgJ01R0p9CUVt9Tih5RddWqLQEd+cgMhUwJYj/i1gl32LDoaj3JqD29Lt34MCTCkYINAgQDuw5lz9I1V8ibCyfUzymdavpOmy+axZUmZDz+sF0wJyb48WL8siPIM2F1ksxN1E1BzfqdILc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MKnAU/pL; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a51481a598so3106756f8f.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540509; x=1752145309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y41c1z5FO9paKQb2OenF8sh2dtfozLKUoL5o/ucwscI=;
        b=MKnAU/pL4EOdAbQWQgzfbmyYRVMtzGx38tatOCoQCcQ1EU/WiO2XQRcpP5700aWx7Z
         SGfcVd7Qhdyw/lGAYWA9bN551IxO1hYrWNDShEYypDXqrWZtY2/UC5NAEaQHbNON1pqy
         DG0am0quKZATtOddAluv9xNrOSDkTSpe5/3NJ8wG6KSaFu8Lkjcdnq0l7dYIbw/jFBSC
         HqirDEyicTSvTxnp76wB9QmPSJilvn4Wi4T7aW3yMmCVCwKXCkTxSPInig9M5yy0Sxth
         w1t3Gjr76AefQw+5ftflKZRoiiF2W2s6/qHdRhWYGeDomLsgaQVhnGrsd3zjpKM+S6QI
         warA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540509; x=1752145309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y41c1z5FO9paKQb2OenF8sh2dtfozLKUoL5o/ucwscI=;
        b=m4OC/VtV6oQoDwVXJkkFn1vZO3K9ztsVk3SxZRRbsoZAnWLoxNLDgVlqcifK1ciFWa
         VxhUo9NzX+iXE98ySDqUC2RFEApdKQzR3wki2G/k3RaUbpwQ8MhvwYZcWuljnJRu5UKP
         7inQep30qp7/71l+a9S60T2Bh07NoS1nmMPUc78jvYNVDqZ8ua12ePzjJ/JUsvI2p4+U
         fp/RT+c1wq8lixREm0IB5dYtFnIyKVjGnJivaHeaDU/2nEMBJu6iBgiqVU++OnLmKTLe
         XFFkvGz5OXlPYegeJ4O6RtOse/p08pK92I5ofXwaUF9L832dMxueJHoW/jDuqO2RTaI2
         AnRA==
X-Forwarded-Encrypted: i=1; AJvYcCWk3L1UyniJS09FqWpPKWfDCjJ9GsZG7RD3MAbb9S0bUP2pR6NRMuHb8/g5421nCvk818Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTC4Hu74Xj5Oj7GyP7CclBZU05NTnh4JS3Ox0MtSaksrOH1QeZ
	le+5NG58EDeH6S8cWISlMmExIFh0BySj+eK7sMTiR7w4gcEMcrj6IxiTjCN9r0CvosM=
X-Gm-Gg: ASbGncsemD6F3fhTAWjuFR5PlAlI5o5s80D2MAIFyVsCCyrhq2xw565boWYy9ZjqGpq
	2KBoitpQix7JgTh+UatpQj4K58Ec1Z2IZBZDDvZoKrDC1hmPXzIHA/lnbHIEvKKGP50p/2DpecU
	3PbnPUH8dsdF44S2fQIufA5Nx9fVEg1Y8Ow8H2argR+dO/5c/angEKMHzI2offLGIkJNZ/2miN/
	nDsStIOmJ3DdrD3vZfBd0vSYnnzKdIcTC9LjLZ6TOxIPrO5bdQKrpIbA70SSSzlx0Zw0fJBrgtJ
	wL9YQOPnuuvYVUBKhrdrCzXv5Ukwyy5yCxliA0OiO2Gx+Q/QtfPWXzql4fX5lECkIutk/rIEMIR
	VoC1wnK09AeZHoQddPJAuig==
X-Google-Smtp-Source: AGHT+IGUzOWh1p66nPTXhGYrVXpNdG8Ig9SVmQbFWLOQ0lStUKfhlKtaElol00FmkiaFACVdWBtOjQ==
X-Received: by 2002:a05:6000:2dc3:b0:3a4:f900:21c4 with SMTP id ffacd0b85a97d-3b1ff714c02mr5425125f8f.26.1751540508802;
        Thu, 03 Jul 2025 04:01:48 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a999c632sm23683345e9.23.2025.07.03.04.01.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:01:47 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 69/69] accel/tcg: Unregister the RCU before exiting RR thread
Date: Thu,  3 Jul 2025 12:55:35 +0200
Message-ID: <20250703105540.67664-70-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Although unreachable, still unregister the RCU before exiting
the thread, as documented in "qemu/rcu.h":

 /*
  * Important !
  *
  * Each thread containing read-side critical sections must be registered
  * with rcu_register_thread() before calling rcu_read_lock().
  * rcu_unregister_thread() should be called before the thread exits.
  */

Unregister the RCU to be on par with what is done for other
accelerators.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Acked-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 accel/tcg/tcg-accel-ops-rr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/accel/tcg/tcg-accel-ops-rr.c b/accel/tcg/tcg-accel-ops-rr.c
index d976daa7319..0aa4ba393a4 100644
--- a/accel/tcg/tcg-accel-ops-rr.c
+++ b/accel/tcg/tcg-accel-ops-rr.c
@@ -313,6 +313,8 @@ static void *rr_cpu_thread_fn(void *arg)
         rr_deal_with_unplugged_cpus();
     }
 
+    rcu_unregister_thread();
+
     g_assert_not_reached();
 }
 
-- 
2.49.0


