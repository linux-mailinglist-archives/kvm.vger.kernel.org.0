Return-Path: <kvm+bounces-51404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 359DFAF7109
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:56:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCBC33A86B3
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 592962E3360;
	Thu,  3 Jul 2025 10:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ic44t8IG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCB129C335
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540151; cv=none; b=pb1z5PRrotH4P4sBtg8sHLKuRt4g/WX3xz0CJIeSxuP2YGDLOsY/dStL41iKOf6omw+Y/QgdSYZ5qePtbJGj98eRThiOJBp13sWjVmZfbDG4n4Vhc0yPnQuK3qQWWgFxl+yoU2No2MhcWfq56b7urazW7waCJkeHmZpxODKIVFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540151; c=relaxed/simple;
	bh=HHeX6q8xWi8eK9Xj6eZaKBeno5z2eLXc8O0gZ2d9jwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YhPdE4DvzpIN4sA6odA/KZIwkNxJbIojFMXFiV1GGDFbao/BsO7qiWZnlPBKNzCsDwHfLHqsDBQnelPLCTWiu4Vq9w16qBDubpXb8PolFFTSv8+0H6j7PPKyiuoDhbJQG9Jnm59G5sVADkXeCcXdpm1VtrlgQ4hjMeH+ccuncYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ic44t8IG; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-453647147c6so83835835e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540148; x=1752144948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zSMALvjOcbwDFxdBZhQQT9TGvgwhtr1LjNKTHw1swdk=;
        b=ic44t8IGjDe13F4lYmIg4+ACj7Detn1wDfUPITnSOUTqVbFAoJAPz9XwmLWJmkoiUi
         OkNLRjhDhHY7SeVp8sAfX95vrfm6VDftMB/Ut3xXJK7k1hmrnWFiUmXV/RWx8k/3hogd
         huLSeoOFOTGNxopFOX+an2SZRFgFD7nUk5VLlLwkVdKk+RvZV9EiQK68KFfbOZAWWE5g
         sTer71yoA1njiYPoWEzQfTzKta91UXder5Dq5VQ9U8nbr3K60sGR7uvkxpIWVGUjDX91
         FkQ4rb68G83Y5atb4NnQ8364rQyvq7Yd6JYrAxr21/43qlqEi/1IIPYhxj4eGsUw0r7d
         YuoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540148; x=1752144948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zSMALvjOcbwDFxdBZhQQT9TGvgwhtr1LjNKTHw1swdk=;
        b=PozmQGKXo3SOKoajKZ/7EcGrZsQcY5yZQaleBQ5x+mFDgn+zCh3f1eh5tA1qCKl6Wy
         bRgPfHiYl4Tcy5cXfxq+LuERw+6XLakVP44ysFh3foq8pNGgofDIGSzwUFA/8MzyOmPr
         JJBYm+tCCtTR/EXUDTXM1WZzahuGXizxAqM6UvoBZwRSoRVhsJhz6XExiFcRDVvN4fDL
         8GcXwyFDhX216yGlSw+UOLRabQnS7D2kcatuhxeTVsn7hi0FnGecPVkVYGGU6uIjKHO1
         1zX2davzCyQcDqElgJQ+zNP1TowNvPiBydYZFTtuVeS92csoXaXYa2sBPVwx54L6MM1v
         JTsw==
X-Forwarded-Encrypted: i=1; AJvYcCVTqILIzggrFAOpgilIiuqzepJAP+fnkk2bSuupEdIooHTQCEj5TTrk/irl86xpjeF2W00=@vger.kernel.org
X-Gm-Message-State: AOJu0YwM1RT+MMuIXu8TEhIjv/blk+9FJsZhPM5Imnq6b4NfQgkoszak
	7uyELDRecw6tcPgPb19RtKiLfIgnDSIkfgt9sBPnyOl+zS/8S1ThoahbSZ9UN7TR/40qwVjZ/VX
	DwW3w5f0=
X-Gm-Gg: ASbGncsCeOd6aNsnV2JwNBzAzFnEeExPywD3gciNA45PBIMOOJkHxagkjqS/QIjQ4aS
	o41RaGPSPNpcRbzo4XHlmHypMJ94lLM/FZGg4hp9UhUokBF34jaJM573x69d4sA1sOP4dgpOL0J
	R01C3feR+8kWqKAUzRKl9JVelSiloqBLOj+BiO2MiyFRgH6uzvQcNiuGex8u5vBuIsQ3DrUE+dO
	sZEiT7/0FqAjjGU2EGq6uPnehrWA3lmPFcuga7WHaPaTo+fY7Jw9bKZPyPtwbdhM+mEMv89Qj15
	VnyJv/KwaXmWehbuyMO4+lP218/NUGB+/+eVUHCyJcMnPFA87JinVSug5py8fCO9pjOn/Lc8kPr
	yrbpbuyhKuBE=
X-Google-Smtp-Source: AGHT+IHsgLTYJuE3+vBF70Bo7sHjatYYUMFJS63YQEPTiYpJlKzOhW/uNLJUerhl3hURkYIrdf6sNw==
X-Received: by 2002:a05:600c:3b15:b0:453:608:a18b with SMTP id 5b1f17b1804b1-454a36e5a0fmr80144165e9.9.1751540147866;
        Thu, 03 Jul 2025 03:55:47 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a99878acsm23317615e9.17.2025.07.03.03.55.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:55:47 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v5 01/69] system/memory: Restrict eventfd dispatch_write() to emulators
Date: Thu,  3 Jul 2025 12:54:27 +0200
Message-ID: <20250703105540.67664-2-philmd@linaro.org>
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

Commit 8c56c1a592b ("memory: emulate ioeventfd") added a !KVM
check because the only accelerator available back then were TCG,
QTest and KVM. Then commit 126e7f78036 ("kvm: require
KVM_CAP_IOEVENTFD and KVM_CAP_IOEVENTFD_ANY_LENGTH") suggested
'!KVM' check should be '(TCG || QTest)'. Later more accelerator
were added. Implement the suggestion as a safety measure, not
dispatching to eventfd when hardware accelerator is used.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 system/memory.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/system/memory.c b/system/memory.c
index 76b44b8220f..4f713889a8e 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -25,7 +25,7 @@
 #include "qom/object.h"
 #include "trace.h"
 #include "system/ram_addr.h"
-#include "system/kvm.h"
+#include "system/qtest.h"
 #include "system/runstate.h"
 #include "system/tcg.h"
 #include "qemu/accel.h"
@@ -1530,12 +1530,7 @@ MemTxResult memory_region_dispatch_write(MemoryRegion *mr,
 
     adjust_endianness(mr, &data, op);
 
-    /*
-     * FIXME: it's not clear why under KVM the write would be processed
-     * directly, instead of going through eventfd.  This probably should
-     * test "tcg_enabled() || qtest_enabled()", or should just go away.
-     */
-    if (!kvm_enabled() &&
+    if ((tcg_enabled() || qtest_enabled()) &&
         memory_region_dispatch_write_eventfds(mr, addr, data, size, attrs)) {
         return MEMTX_OK;
     }
-- 
2.49.0


