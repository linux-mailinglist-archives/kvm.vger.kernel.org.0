Return-Path: <kvm+bounces-46240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 759A5AB4272
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 497B67B6E06
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC6F2C1E17;
	Mon, 12 May 2025 18:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GRIBy7X0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45234297B8B
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073148; cv=none; b=d24ZWu10TqTtjf4QC/LbAbZ+YVE/mJquVE1GJxh+GCN2m8/4L81UdJivenKFe3wNxCrI6oTEBcDti4e+iVxG92/jCgocz5x6B8tF10O41uLeYKmWaIJGEXqPZFnoxPYTxoxTxauq3zjAazw7tPGhcWcX/VDh1MGDaGM7PnKIno8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073148; c=relaxed/simple;
	bh=+GsKxGDFi9LdBjiYYl4g3upDO0FWMo1rCOOSDcsVo1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tb40F5iu5UPTA+ky5MDNJEJOCvZh0jh7RheAfwQAoj8U/WO0CZwcRrWFnDLI5Bin0G1GZZu1D9SZIOEN+fMWzO7/ToGzGcqG3sVqAeJhUpcXXVVf0mdTg9yZ3g1YhwpQYQN90M9258lhMZ7+Q1/WeCe9JAewzgBU8l1iXnGqzQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GRIBy7X0; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22d95f0dda4so55844365ad.2
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073146; x=1747677946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IO5E5SNmIeDx8PW0b+RfMLgVUuAcPfL8utSgWSmdyqA=;
        b=GRIBy7X02Zupv0suWnlhkP1g4e91Hljj1P57DdpHxUw0wHIlY/0O+0TTsbUk4zaFjz
         vGeq2DNCG/Yx1KeDK88QfDy89OBpCiJ5OYUuJKPCLzLacuBRnD0z38OH2vDQaJl/4sPT
         wDoOfKzI9cImhCVCvmzt/mAJccO/jx07ECrL3PdJfTeZ1qQdV/lId1CcDgDOsa1XKxxX
         Efq/z/CAe2zITWZjMyJaLZK9wlvMPZfgVzDcO4xCiFlNm89ssDlvITrWVc4Taa/gczfX
         JpmWjk/yD63Z/AE9+t4w/xvT+BOyFgcP/J/zCPSVzsmwWTKy6vNlpyYIarMoYVrhK0bI
         74Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073146; x=1747677946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IO5E5SNmIeDx8PW0b+RfMLgVUuAcPfL8utSgWSmdyqA=;
        b=Ut4f7vGuL85Z83d4QezcYlBkiUO5MIk3RvntRXGRhYtf441Af4t6IbWskvhw+LQUcH
         23HgKwNKTsuLpvAWu9eZfWKYg9vC3g47c+S/N8Ot87zdhvcKTs+SMVbwBBNMA5YzxvfH
         WYxH4AkO4dEVxxzzwzwAbvnblo9FIFAL/x94oAjNOBiywkdL079roJ/3szXtce4GHBoX
         ZAm+7NpPKYiOEkZN+9k7akVf/iqzxOGtF5y44mZDbNMjQ8A+DwW6fTk38zh7xm3gf1WH
         Uissuv9vSeq/WuUZvyiWOqLnOfZxocnbSbQkL0Zc9NNLO/tFZrb9scvqd+iy4TzRAQWh
         Kilw==
X-Forwarded-Encrypted: i=1; AJvYcCUNiFkMj++hD4uouzIGFKOWkRxGCjEPZnfTncT2953D4vybexwBS2XN0F7U2EM0NPhBxOw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjnxOpkfUcFSgU8tW3A9cGnnMYP+v6rLSLKnq484eVnEEn+QVG
	yogFFKmi7sp8Url+DAyEnPOHlOXztvLgGrTYs9txa/2JF2GlAyzHqNXkPs3JaFs=
X-Gm-Gg: ASbGnctEEqjAZV/ysQu5FnFj2C5W35dS/J+WXAAMHrvoG2CFPXHKxGN3WIoj3ZLBj/V
	5+QLMSpyV9l0QPQF1QI3gDhGQoi60q/TzY3A9GSm/A9H8sGEf+cFOKLvrXks9N+9O77cNU1k3Cw
	ZcDZM+pBvMTRz/MwpcK//6CjkNuyDMQh7PJSMw15brkaac5py/jRs+PqjQgFvHZ5v5FDOIxcVWl
	SxHK6nSDNNtvLF1CY4Q6JlREM1ZFvJIf9M8m9oVc32efZYn3MBalOzZW5DepeV4Dy3u+m3o1PWt
	W5/fX5TDenx9/t3MM2nCcHDjY7t5kWzOS/UW06P3mCPTTTJFXpU=
X-Google-Smtp-Source: AGHT+IHj+ksKGYhPnHifXirA+gi4i431YFqKs1JUn41Q6PWik4/CLP03qf1Wl3GK9Z24iyTARgkJLg==
X-Received: by 2002:a17:903:2443:b0:22f:b6cc:421e with SMTP id d9443c01a7336-22fc8b592bamr200772745ad.26.1747073146460;
        Mon, 12 May 2025 11:05:46 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:46 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 39/48] target/arm/tcg/vec_internal: use forward declaration for CPUARMState
Date: Mon, 12 May 2025 11:04:53 -0700
Message-ID: <20250512180502.2395029-40-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Needed so this header can be included without requiring cpu.h.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/vec_internal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/tcg/vec_internal.h b/target/arm/tcg/vec_internal.h
index 6b93b5aeb94..c02f9c37f83 100644
--- a/target/arm/tcg/vec_internal.h
+++ b/target/arm/tcg/vec_internal.h
@@ -22,6 +22,8 @@
 
 #include "fpu/softfloat.h"
 
+typedef struct CPUArchState CPUARMState;
+
 /*
  * Note that vector data is stored in host-endian 64-bit chunks,
  * so addressing units smaller than that needs a host-endian fixup.
-- 
2.47.2


