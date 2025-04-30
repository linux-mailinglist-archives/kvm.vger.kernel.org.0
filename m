Return-Path: <kvm+bounces-44924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 377D6AA4F42
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:59:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1603D1B6233E
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 14:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B3525C708;
	Wed, 30 Apr 2025 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dHj/31c2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498651A5B84
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025135; cv=none; b=tcOScUlF2YNBekmw5Pnbk14a2pKQlLndxQo48v5FeEWxNtoVBC8SNtDGAFp6pdSf4R22LdsKwAbwO7A//lTWkLCQUJAJ3Qc7Bws9oPT0x2ukd25paE/ai6WG+bDhZhXJ8pBGg+rnt6HKAXEaJzVHupL0uZOA0WZv2gBkIWuuZyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025135; c=relaxed/simple;
	bh=OO602SGWB2SYNF/VZ1SMkbcCFj+GJzD0748UZUWZzKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eA3rVf2GV5KUilUTVE8U0c0aQTKg3XJrleL/xLmZyxZoNSZ2qSIzd1oO0QRLfsXyVEIUlcDARw8Vqm/VOuGSkNhN5g8xJ5OvGNB8uwc6TQdUvsdrfSH/u3tckx2mPoYPVaJOmYubNwrd/q2+yCAl66TMytomVdQVzw8PP8tyxOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dHj/31c2; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3014678689aso6238a91.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746025132; x=1746629932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fGiNi7KD9gyOgMyKCivUKJWXpCWPNSCcBCjqGbD2GJ8=;
        b=dHj/31c2Nf5Hs7c7cznwNG8uJVaul2sH8ksokFnk/EtrOcboXLBn9euYwWNITHFvQt
         S242/bIccsop+bWHnI4P2ccmLcxTk+njhAs5sWBuncZjabLhieWkHLAce6tJHJWrtX4s
         XKyqLCiHRbhtuNqLba7oQwM7HwoCxQr1Qk1n6HwO2CHGIJ+gzkJ/kC+t1bcvpoaFuqga
         Um/iy5x8ZXaiNBqzlNuy7OT+hFbuiBYQuhUtqk7C9ijZ/5vKTCg4yawgkBl2QxK990PW
         /7nwXdgbg+vAm9H1sWroTRDcgb/9DrtIYrZSlR48VS2fpWbinHAq28phQSUxl+YEXPxw
         HaKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746025132; x=1746629932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fGiNi7KD9gyOgMyKCivUKJWXpCWPNSCcBCjqGbD2GJ8=;
        b=CepWiO7AJ6J+FauZO9N2e6U8PuWnguG+WylZvW2WTFxIsozvp96Rhgyh9Q1q9dGJ5j
         kTm4LpYBWfSzrgDcM+0w+xA5vOoSUsm43jKsxTD/4y9NWlMlIb3gIThF7pbZkXd9QzQ/
         S7/SknrATwdetRpvfoZ7A9T6zfiHMlKEz/5g6v3nijRH4VTUeF+nXsrKQgvMrSyd7KEA
         u/WZt40MCKo/pD2bDemFKCJp1kFdHpX8bqUoe722SvgbwnVdbOA7DzQXb8ktvAdjvB9R
         frdHbycGqDpgQzIq9a5wzJA4LSKoePH2b7IzELkSNd6y9NNpfLC4qeFVzfuhnBAmspmC
         QbKw==
X-Forwarded-Encrypted: i=1; AJvYcCVh4+KsOVWD1DNowohhgCnGWz9GreuBHYKCSYA5xm5jI9aghpf63wL8u0VtGIybR31RTac=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEiuLWKO6XpvcOzHio6wurJV2HHrzGC/v6e78PcH9K8Jdwe4rX
	WghWMC1zZLHUJVN89cSQkzYwQ4NpXSx+m6qAn8vYGbE0twIl1i3nOLYLcxFCXUA=
X-Gm-Gg: ASbGncs7JEdjLuSWkG4smONFpAANK6mvJc7sEZtEQmvE596WsAYxzY3p9DBua+IvJbL
	oJpoffZaPMdV4q+6dEA7fJlgGuvt+EEK38SxSjAicLBn5W9+BLz26Z+EtmMM4fR2CsfZmYsm2s6
	edGQHjwSs2255ks+rkM/fR0Qnc85Ta3/R1Ooh6PtmvS5xe6qmiunjsvPllKs8zCoBDejLNiZBlR
	yrpdqPrr1YbzxYHfAQwTr0n7Dj4Ye0CP7YaEvcWjgBUa8BSGP8TKvtmmHF/w5r8Hgki6sq1P5aT
	AhuC2pfmpKZLMcTDxiDMgah+uy6lUGSlYq3+j2+8
X-Google-Smtp-Source: AGHT+IH+BLmMRNO1d2Il9lIsPzqV/zNMQYpfuEcaTVrwEpMBAGNrwX24xYIWCRPNN9NX2WqOLluU4w==
X-Received: by 2002:a17:90b:514c:b0:309:fffd:c15a with SMTP id 98e67ed59e1d1-30a343ecc28mr4110023a91.13.1746025132462;
        Wed, 30 Apr 2025 07:58:52 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5bd78sm1705652a91.42.2025.04.30.07.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:58:52 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	richard.henderson@linaro.org,
	anjo@rev.ng,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 02/12] include/system/hvf: missing vaddr include
Date: Wed, 30 Apr 2025 07:58:27 -0700
Message-ID: <20250430145838.1790471-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On MacOS x86_64:
In file included from ../target/i386/hvf/x86_task.c:13:
/Users/runner/work/qemu/qemu/include/system/hvf.h:42:5: error: unknown type name 'vaddr'
    vaddr pc;
    ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:43:5: error: unknown type name 'vaddr'
    vaddr saved_insn;
    ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:45:5: error: type name requires a specifier or qualifier
    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
    ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:45:18: error: a parameter list without types is only allowed in a function definition
    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
                 ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:45:36: error: expected ';' at end of declaration list
    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/hvf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/system/hvf.h b/include/system/hvf.h
index 730f927f034..356fced63e3 100644
--- a/include/system/hvf.h
+++ b/include/system/hvf.h
@@ -15,6 +15,7 @@
 
 #include "qemu/accel.h"
 #include "qom/object.h"
+#include "exec/vaddr.h"
 
 #ifdef COMPILING_PER_TARGET
 #include "cpu.h"
-- 
2.47.2


