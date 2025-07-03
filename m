Return-Path: <kvm+bounces-51414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3888AF7116
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:57:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF81F5271DF
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE4E2E2F17;
	Thu,  3 Jul 2025 10:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Lphpp4Cg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FF22E2F03
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540203; cv=none; b=HMjFEy9VfnebwtaM2meGkY4pe4lSojZUiJ1rOZqA5i5AhJjkG+tylQnsRWDotQLhopOQZ9iIvw8RmOVqtxA4fPzXE6SMLAJS/RRszDWS8DevLTCnKDt6xb2doSjr96EWR788+fkZROAo6cBjFa80b/b/FgV4x9kElATGl5A0bEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540203; c=relaxed/simple;
	bh=oBM9B9UkFXMOXzsE0OgqYMIcYmx7Cri6OEx5/ZpgJGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MGkKSC9tTQLk29hcmYqrFw5zB3Ekvqn41mx4az7+Ne2L81snuET/rd5zGr226Ft/9stqOIAcfkfqODohf+lxi4mG166atCANRuYTmIHeLorXquFePxBtPohDMPkHVI6pVJkjoIFqPBO/SOsmaLkLyDNkiQ3U0IRtmNGmg3siuQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Lphpp4Cg; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a365a6804eso4215753f8f.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540200; x=1752145000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7agq2/z/dMVKZ8AYrQE6GIlp8fdEIwRrjWbdb+ua6k=;
        b=Lphpp4Cg+HSuV/Bms6WZ1Kx7+2ec7aq7nZfqiC6DuXOtzBdFvLCuNp7IvWyk4cM9FY
         xhrnOpOjF7avDnHIHI7Vn8qdqQ3wDsu8tZAB4qW2ZgC648tmO1ve6/RnSBwz6DAm4YZh
         Wwk2OMo3OY5ealvMgD05p+Si2p2VAKO7B/5Qs3mhaxASfD6zme6TuHO9ffT3GpBrrw3G
         9ytTMHCnkw6BVI4R4PlBuL/iqYc2HTO2l8zIWV7BnvycbcwUigndm9XivyFx1Gpt8QoP
         jTkcEcLT6JPDjFAYXnYeuQzD6vJT8LXX6Wx6gU9qq0WtXTfx7ewQgifDDKV+BOkIwpd4
         bqxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540200; x=1752145000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K7agq2/z/dMVKZ8AYrQE6GIlp8fdEIwRrjWbdb+ua6k=;
        b=fc7nSKf5+Ia/pFIea6zGgdbLc2R89VHZwAVOG3YMEk8Lc35qIbU/zWYy09BeH4pTo8
         rl3m3lOjaIbGbv+SVEiPvS75lKrr+9vswUS1pDxcpD3c8mPJoNe9AolX4IuX810yetHa
         IBmWDuwMTN9vU9gCIaJIipcUDoTPZ7O+/HtnUqon5G9o1UhOy/VL08iLS7bUosTaQFuR
         YD2K1ifM6QlI/sVRWkqwOjRZHy8i7Hex0/pzm3/yclqukmrj5UZMD6g7nIm/7UC2PZ+o
         qbTQr/vLq32OtAZqz73WMSM0UPo/hpJKR9R7tjteWhtVBGCLypxTEYAyI106Cex4KcEi
         +05Q==
X-Forwarded-Encrypted: i=1; AJvYcCVivxYXOsILwCJVx4yb5LPhaXrW8P7NKf3wWtp3vUuYlTP4bfSSqIBJlkXDEuELiIgm8I8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgQseT+fYnH2ib7XbRp4kiI725nTAr2Hurl4o5fCwnPRBljqgf
	tzNofcR1+u78mI429Jpq0wHVkpyd4lMRo5CMk4qaKrqZgr3fuwHQW/Tj2nD9EpLhHik=
X-Gm-Gg: ASbGncuehBqSLwWHMvAxV0wpD3V9AizWQM2kroAT3IDXAZy3zHAkiib9yIhbyexMyHn
	HOunPJPiZLlzUTR1aqVw1XT/x9kwaOIXzveBZMXsKIwt0pcm8hJlR4XBM0WVHJacdVAh+pr7jI+
	3/ANOYRdctr4hMkFn+Z7K07GebcnCW3i87wP4VFe4QyGczx0y7WdeADqQeoXbwQj1iKEOp02vzH
	dlENFtqSEUMAy4ZNq1vss3alurdMNjlABk4bRkdsAiShi+aKXbdFoicylwkKt1E3ae1Wyl4JhqM
	6EzLAjmx8N1h6NQ4G3INcKFMWU5wHDxVWbN2XvTukZ+GI1kzrDdp+hBvJRwj/QK/1oX/BdLITjb
	BPb9oI9PwqhLWZcwfOlHOdQ==
X-Google-Smtp-Source: AGHT+IHy4W2SuuO+zy9xHO+kTkw3zE4vw5kmWtlB6VNsrS7nzuVM6IdbSgdtrT0YjiMzG2J3cn28YQ==
X-Received: by 2002:a5d:5c81:0:b0:3a3:621a:d3c5 with SMTP id ffacd0b85a97d-3b1fe1e66cemr3890751f8f.19.1751540200502;
        Thu, 03 Jul 2025 03:56:40 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e5f923sm17945567f8f.89.2025.07.03.03.56.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:56:40 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 11/69] accel/kvm: Prefer local AccelState over global MachineState::accel
Date: Thu,  3 Jul 2025 12:54:37 +0200
Message-ID: <20250703105540.67664-12-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/kvm/kvm-all.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 264f288dc64..72fba12d9fa 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2588,15 +2588,13 @@ static int kvm_init(AccelState *as, MachineState *ms)
         { /* end of list */ }
     }, *nc = num_cpus;
     int soft_vcpus_limit, hard_vcpus_limit;
-    KVMState *s;
+    KVMState *s = KVM_STATE(as);
     const KVMCapabilityInfo *missing_cap;
     int ret;
     int type;
 
     qemu_mutex_init(&kml_slots_lock);
 
-    s = KVM_STATE(ms->accelerator);
-
     /*
      * On systems where the kernel can support different base page
      * sizes, host page size may be different from TARGET_PAGE_SIZE,
-- 
2.49.0


