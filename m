Return-Path: <kvm+bounces-45386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B57AA8AE3
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D58781893DDD
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B311FBC92;
	Mon,  5 May 2025 01:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WuC5Q9Q1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530F01F5425
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409986; cv=none; b=RnMWVcJIxqvuzIWqck3mP50R50MePk7IoqPUaSVzJk+OkoRXOLNn4vLZ3WUcF3T98wE/zLuGWYJkbqi0nCkCXPOLBambotRitEHofGyUMNndtpSTM5VTx7ka5u0/Ov6ta7GN6LF/XlsAa0CF3QNAwd3TL1M43Y0lazFFeqm2JFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409986; c=relaxed/simple;
	bh=xkc01XmwPbQQqW2DLbPjrYSssEz2ZnunsGIPKKJvDsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n87csG9xctt9ENpMVk7dtKH3HRX89MwkKYEC5kDTTFu11yRqmA6bsdmfDdKENTzeIR1Nuaaf/D1emdGttlQZ7+BlU4/SC/BkAM2xy23kxyXGDaiKQEBdtqZBpUIlvK28k7XclN//Wh9MvWXKFi6pMgbXvngSFYinM2U6FiJflc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WuC5Q9Q1; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-af548cb1f83so3810087a12.3
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409984; x=1747014784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjvN9GkUlSXmzEXtUb9+tptKE6zBbBhkZRx0p6n3iY0=;
        b=WuC5Q9Q1uuqz8iqsHeb3GaKgKgsataj4ZZorTIi2MGUOjEbAm4vvSDwNGYClqthxVq
         OryAL+xBZSqj1gGpV/9nTHc/AKvM+aBpX3w/axHqvCRpFTfCd1WMxENPIbRrn4V0afbw
         VUfilg1gtmg7d023AbBJVnBG3jRrvYDQ+PYJes9/vO9b9awR9gRtX8Zss69BSZmKSEmI
         i82YKPU/Utg3Yq5zcDwhvojxQny+kyHs/q+zfGS+vkU84RjBtX5jQ3j3C9H+vBejXeHj
         vnLBs/3RprC20cAaSXVTrXc0u6DIGbnDTLXWSwCrH8WPg3N7li9rAfNIkXOWp9w62XNr
         VDZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409984; x=1747014784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjvN9GkUlSXmzEXtUb9+tptKE6zBbBhkZRx0p6n3iY0=;
        b=XPTEMFbX8sAqNBd8ZiIJYsi9gsW2PruosQrcLEfWyZKYH8qMb9XIW+89bFEwOyaDvq
         v18FD/JFzncvnra4KnUC4GqwcGmkW6dm59O8QSQN+ZrPOFyZGoFiNFXfRg4dhO0r5U6g
         xD+Bz+33nZbaNb8vfC2BlVH7OoB/yhI9211M+6yzwoh7Fdje/mpfOoMJBOQEODzq2pBg
         3fBe2aEi9cfKr0lMegszzyufu2V6L1oPRfkkJ5oQo5SgjSOsOePRVXkk21DDNZ/22CLU
         CkYvH/nYbKzrWTFNu/RWTwMbnTbc4KJr8lo5eAzHTfXxt0jmcLx/gpV6aovud580ecvj
         mWKg==
X-Forwarded-Encrypted: i=1; AJvYcCXqe2llq0nq1/QR4HFCF1k9mKdW3S8tSO4HoTbMOHK6+M2124Lf2Qm5Aak2E+fwSPnO6X4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGfe8dc27zMNbSObw3EeEixRSzmKhbj6ivOvgdmsx5Csn+zu1F
	dfdOhzR1Aplmhxc0BfATD9ODf4kzJeIa70qiP3spPDPocSk+mUFYsQy4Si8HCUI=
X-Gm-Gg: ASbGncuvUTCwE2nGTjuOJspprCMclWKtNDSSg0oEN/B/2eybEoIdKOGfE/USeWJ3S3K
	IvcKLQl0WEd7SLUMn3BfhAJxYJV3rfyOAfeJSkX+sE42zAXgIW564eZMxbXA4r+Ni4+p+CyJpLP
	GWI+QL/sSznAChskJg5JtVNFdqxmfJ3E5uBlDJMGEW5IUitOmDdJ9YCVb2t2qnem62YEet4BKer
	sl324ClYabRSI11oWmwAlc8UQYQw+rYDb3xgKw1R7fIu2G5t9PyBOTSfQh5nqvnLC2po0QuSvEd
	hnioy1mdOWiQrnhhImlFfPnv8d5T/k28dDIPONQF
X-Google-Smtp-Source: AGHT+IHdz4XoM+G4ZSlVLLLI9T3NP/Z5hYlsd9kBRP8xO98/byZhhHtRa3EcBoUSJs9k3C7RjNhANw==
X-Received: by 2002:a05:6a21:9186:b0:1f5:874c:c987 with SMTP id adf61e73a8af0-20e96605740mr8115462637.15.1746409984740;
        Sun, 04 May 2025 18:53:04 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:53:04 -0700 (PDT)
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
Subject: [PATCH v5 39/48] target/arm/kvm-stub: add missing stubs
Date: Sun,  4 May 2025 18:52:14 -0700
Message-ID: <20250505015223.3895275-40-pierrick.bouvier@linaro.org>
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

Those become needed once kvm_enabled can't be known at compile time.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm-stub.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 4806365cdc5..34e57fab011 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -109,3 +109,13 @@ void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level)
 {
     g_assert_not_reached();
 }
+
+void kvm_arm_cpu_pre_save(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
+
+bool kvm_arm_cpu_post_load(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
-- 
2.47.2


