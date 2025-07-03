Return-Path: <kvm+bounces-51517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 335FFAF7F00
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E64C93A9C56
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30D72F0C70;
	Thu,  3 Jul 2025 17:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sYFJBCR0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D32288C9B
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564146; cv=none; b=MNhEbnLz49u0VPLGFDsJd+nUyX0WKpFek5Rz+Cv8mi1YMNXPWAUSsZ0xImqpiP5WrS1Yt3RqQCzgOzBW/ruZQ1wbiLB8P/wsUPZtJEzSiR9x0DQGKhB85keFbtGGmtp4EKaP01vLlwee0greqBtyb0cL99MBr892kJYuPb/Iwe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564146; c=relaxed/simple;
	bh=yxgbKrSeq1Rg6hvAahScCi3clVuT8UTdQQ42pKTpuac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DxnPZB31y13N+LKvJkO0p+e6Xb+GlHGYWP5Ptsf4iWDdzcC4ilW1DHFF96CMx9ThEBObIf1aSzGuVc5LwJKIeaM6JQ5m/BK8N+XBw3VLO3IENCv6aolPfkCKxxDWoNmKLsVJsHQ8mR6KN4uKAXYHEOuiMhPNSXeZO1y/SeWGTcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sYFJBCR0; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-451d7b50815so691555e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751564141; x=1752168941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjJ+lcNXcYC5f1FwLpKLJEf76e+ZyGqrMwDm/D97r7I=;
        b=sYFJBCR0EACiqDjPY+qrv543G30fbezcJdv52/Nay2SsWHbaLDMscdg/ibUXosMI4f
         UGTjl1mo5P7XY/ntyNyLKCfAmYA4av2mVPRXl7Bdv3w2Z8FvLBX96HVcA6n7mfzVJdWe
         xpcc1xBd/qJMi/A/dBjjM7WhsQ2CxkrKC0fTraKRkhO0HYh1BYZzBDSwDFcHA1NjfVM3
         l9Dz61z2Vdn43dK6MpaT6HgMJslr0bjisl+vQF3XfWb95Jg61ElpHZp7Uy6FgIazXH4W
         gLoCz9WAcIELyrkZdP9BFvOvIwCFsc4rOzTON+TYQuTgOiKw7lzFfLXiBmvnYTZHpXcY
         4+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564141; x=1752168941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjJ+lcNXcYC5f1FwLpKLJEf76e+ZyGqrMwDm/D97r7I=;
        b=tmDN8ETNX+eyu1BSZ7uIoUxrlFKbcYCdSqJUPeLiHRY+7KbGbNZI/nsqIbLsPwYkXc
         CMUjRSqaVPnWc76ug4YwkkrmpVisWGnnfgh2onpCqSvfggvghXrqcLyNwQkVfUIkWaZN
         7UN3An2BVUMTd6lcqkmqJglkZQVOqtMUG46McWTXO9LDo4iZVf5RIN5QqnNi3PZlMPG6
         +bX+O5V1+m8LFYiYIlTuLV8L5kjBhvvcBUDuEftyvEPecnlL4a1sIcoFowddWhyZ0zTa
         2umtD2sGA/5DpAEwgm6cpek603UUEV4ax4MM6jrOSbGtsGTkecLWvgUV3E2k+7OS/wkR
         vwEg==
X-Forwarded-Encrypted: i=1; AJvYcCX7FjNpmgP9qPTxSGmT0hBTd2By9bKXxgSeS3rTci4Pe3VBt9v0ENPtT5RwiHewnF9S7RA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrtMaq+wL2s9cjvXtmUBt5LLtDJ1V1cLXe0+0k+3zpmQzQabf/
	bkrGg7MJyDS9fg8kNGRy5hJlCsCJVkzVKiiTqjHJLEtKhbqLYnMDYyHW2j8UelpTazg=
X-Gm-Gg: ASbGnctRx1SCudM8wJgmRjI+DCMTSPLtw88RsuWviEpKPA449xuhQDVXdAbPuwLj2Nz
	C2HU2nM7mrMFaMu9GcVHafcQXCAhyJ+DhyfVlxSZAP43tJStAhZAeuOwW1xUI24gAm8nqpIhkRM
	Be41P3sOZcf2ywLVOxPZmo1CAA2L+rD/7AYhvm1fkiS1h6oQprEz9JVr/4Z+J+srSKTfWWKT9t2
	ZwXbnH4aLO3N4vvQFAphQVZiUO7/Prgq9a0emtm9ZLhrqfA1xN5D+UUNTZU9k56DGk8UTIAQZSo
	yT24n3Lqrt3WyqmoEtpz3Iykcth46Je6mMxHAeke+V1FUAkGTgWoSYOMXlRczXnGvIXPqynL8+z
	8Tr2oVK5fWfULxusKSgUjHmS3k4qhWZ+oggIo
X-Google-Smtp-Source: AGHT+IF3qpPPLYHCen/OvZ3c3kUwooh29DGaRG1oO4fn0b7UOW7ZJboMWSayZSJdRuauW6FDYFScEw==
X-Received: by 2002:a05:600c:c493:b0:43c:f513:9591 with SMTP id 5b1f17b1804b1-454a9c7fac5mr52499855e9.14.1751564140699;
        Thu, 03 Jul 2025 10:35:40 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47040161bsm337927f8f.4.2025.07.03.10.35.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 10:35:39 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v6 31/39] accel/kvm: Prefer local AccelState over global MachineState::accel
Date: Thu,  3 Jul 2025 19:32:37 +0200
Message-ID: <20250703173248.44995-32-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703173248.44995-1-philmd@linaro.org>
References: <20250703173248.44995-1-philmd@linaro.org>
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
index 1b6b7006470..a6ea2c7f614 100644
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


