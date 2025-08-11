Return-Path: <kvm+bounces-54422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 183A2B212CE
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 19:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFFAE190810D
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509D52D3A7B;
	Mon, 11 Aug 2025 17:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wrc8r7uA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88CE2C21D0
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754931999; cv=none; b=Z3fMmxlbcSjBjdNK6a0krmwPBoUxk4i3fdXOFuce57x65I8BDVnF8Hnam52fagYBOEqzcb8oLo8b+0ijo9siZr7ukMVPO/zG3v87C+e1hHg/WcYHtpUwdcF/WwlyWx88bc1XOu/yP5MDW7STl4Gz1Gh5UxrvQ7jVwHnwEjcwwx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754931999; c=relaxed/simple;
	bh=oIVsziKIbKRXI2U/Vwp58co384XlSUQ9Z6B6Y++memQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WebHW5M0S06PNzKTNURAsaGiMooOmIT+bN5GQzgD3xx3G5gb8pAi9Guay0DJJ41PpETfBIV8aaIddd8T1KswKyab8oDUJ8xUjDu+nnZQ8qPvNFActZIwnrIH4wwmyYTEBU96aV2Yf8lb9uQeYTUUQ4cctkn0qyOa/7KMIk7OK48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wrc8r7uA; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b77b8750acso2802711f8f.0
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 10:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754931996; x=1755536796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kCcMKgJsUFQdM/mVU8Sb2r9KycdWMl/tLnBwMf6U/Q=;
        b=wrc8r7uADCY+wEILCocBFO3Dkf5fQseV3Oz/Tp7pGikFEZpVyF35iY3/1d0wSbqoLD
         bOsPJiB6xkEsA1YnHqNkZmNPqBfLBrXT+sOSBD6xRjsuJ0xZQDL244vxDGR19St1LF0W
         YI4km7HBcPVFvsN2TsJizZdA0Bdm1nfPD7CVG/EPs/8hO3FMUCPCrz3xcV1S1hJNHGxn
         E2a6fwOB2aknvdr8x207sbwJZgDpaNifYP97iXK2ci5eP5ElJ8m5fjybn6T/tdBKSbF1
         eSYv+ZgM6v9EtvRXZKsRBeaGG3BI5Nd7q3qBKv21eiCkGtPsgVvThRlAd8+eTOZ7QsAR
         qp4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754931996; x=1755536796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4kCcMKgJsUFQdM/mVU8Sb2r9KycdWMl/tLnBwMf6U/Q=;
        b=Edyd0JmSlESvoBJE+18QTfgn9czGyNNfy5nIqFToZzOA/LrdHmCYYqdirIJapQYya1
         /EbPq8G8ef6u87uXFmFdkhymUiwb4WNT1zrbwF90uCg2txh08FrIDNpFYnb2Y2nluBpZ
         /2Ul7fld4UxtNv5AAChH1jiTe5u0i8R/AJQKYDPm4B6hRgem7TwOCVR3q3qW2tM7OVDf
         SWdFEqQVryahzk6HKGMZi52E54y65YXJ7rDpn3DRYkxA+o/eKfxQx7/LXoQLNGZdR0Lh
         1TSJZaxx0USNhvtRU2y4s7RoyzQ47VN/ZR+aCFw7B8NCwSbJWQhfweUl+5d6cGssLgrp
         tKzg==
X-Forwarded-Encrypted: i=1; AJvYcCWmXBU+BtHkfNloK5peUWp53cje3dKuNne0FNQvs9HTU6TaHUmAMB64FMBrgK7l5kGvvTo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc+uvj5pAf6g2Md7zmlK3yYfmLosE011i3FISOv74cow9qYwlK
	hE3BYvfBTv6nXk3T2HPREPEkAD4wd+x6t6XQfTZ0BZ2n8niCYz9LNIaNcUBkU+6Ogeg=
X-Gm-Gg: ASbGnctWOygtUR0zaYTzft4kQ6PvOh4lYyGV4pcyBaDwDB7tnQXYdQnjGJarN0MKn1l
	aJnSzhgro2kGcDun0y7Ux2eWvoSyKC/Fss5GMWwNhjd1UvFKLLmYnCa2JfXYaVIC0vDL2IFxQqP
	wWhsp6V9Up6N0iiSnXbcEQqfC03lv5BjD09hovGN6d60ev0J0D+O5rZ66HecL36z1jPOtpWAgMf
	LwFjftcejxTZ4kcb8/tV/I67qUG38mC0YxmhrKXTSL9YDOtVXPA1HYgYv/0gQ4NVUCSDZ+H4lR7
	VABESkYf20OGv41tRuKvANTgtkbFfh//aAVUhLGuUqa1El9/Sk41qZOoEQyOXhPJbDpz6VscOXi
	eoMJ7aA4g1XWg/zetsJJKQq7bvoOebC6oMuX1eV5iD8d4J65G5bl4cl5iOfqr8k9a7IUj5YKx
X-Google-Smtp-Source: AGHT+IH0cwxj5ttg7X/SuYwtZcuM0ETCatH/wcruBaxy12H3LRe2v4MWcJy+yEUAgit00aPOKJauoQ==
X-Received: by 2002:a5d:5f53:0:b0:3b8:de54:6e64 with SMTP id ffacd0b85a97d-3b9111b5fb8mr312079f8f.26.1754931995845;
        Mon, 11 Aug 2025 10:06:35 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8e0846777sm31486669f8f.48.2025.08.11.10.06.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:06:35 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Miguel Luis <miguel.luis@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Haibo Xu <haibo.xu@linaro.org>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Alexander Graf <agraf@csgraf.de>,
	Claudio Fontana <cfontana@suse.de>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Mads Ynddal <mads@ynddal.dk>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-arm@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [RFC PATCH 04/11] target/arm: Factor hvf_psci_get_target_el() out
Date: Mon, 11 Aug 2025 19:06:04 +0200
Message-ID: <20250811170611.37482-5-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250811170611.37482-1-philmd@linaro.org>
References: <20250811170611.37482-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mohamed Mediouni <mohamed@unpredictable.fr>

Factor hvf_psci_get_target_el() out so it will be easier
to allow switching to other EL later.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/hvf/hvf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 47b0cd3a351..81dc4df686d 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1107,6 +1107,10 @@ static void hvf_psci_cpu_off(ARMCPU *arm_cpu)
     assert(ret == QEMU_ARM_POWERCTL_RET_SUCCESS);
 }
 
+static int hvf_psci_get_target_el(void)
+{
+    return 1;
+}
 /*
  * Handle a PSCI call.
  *
@@ -1128,7 +1132,6 @@ static bool hvf_handle_psci_call(CPUState *cpu)
     CPUState *target_cpu_state;
     ARMCPU *target_cpu;
     target_ulong entry;
-    int target_el = 1;
     int32_t ret = 0;
 
     trace_hvf_psci_call(param[0], param[1], param[2], param[3],
@@ -1182,7 +1185,7 @@ static bool hvf_handle_psci_call(CPUState *cpu)
         entry = param[2];
         context_id = param[3];
         ret = arm_set_cpu_on(mpidr, entry, context_id,
-                             target_el, target_aarch64);
+                             hvf_psci_get_target_el(), target_aarch64);
         break;
     case QEMU_PSCI_0_1_FN_CPU_OFF:
     case QEMU_PSCI_0_2_FN_CPU_OFF:
-- 
2.49.0


