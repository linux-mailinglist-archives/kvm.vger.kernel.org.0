Return-Path: <kvm+bounces-37738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5D8A2FC3C
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47FBD166E86
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 21:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93CA32512E0;
	Mon, 10 Feb 2025 21:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Zv2LhLjy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4112505A5
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 21:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739223373; cv=none; b=Dxdcde8xIuvp9JvRSzMef2YYYA8sOIkdr5ruTkXNP11Vvh2Hl5rYWFrJPhJcIZHaD10PsPp6HKrAhNnyNhIaSpmUM0PM09vAZXeXo3WmBFNKNSMZXmJ5HCnR+lq7uB72gShGIyxhQfq+WqHwFo5m4kVRXOfmUT8ru6kbgWhF3+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739223373; c=relaxed/simple;
	bh=xTCgvoJ3M6PEdl0c4FHPJfLCd4JS4VwrygYqNk3pK44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I8mCBEar1eEtmKpAaca0jvmhamC/2BJKStSvovcDpL0wIpiF8AozHybqCh7+FfcWykT9M/nHrvndF5TKOzsA4vY3q7Lvg2u1A/d3CiyVreuhOQRllwv9uLkN5oHF1yxG+jA/qDm6pi9fIHe7Qy7gFJ+Wc0fK94OXrg6FNNJHwMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Zv2LhLjy; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4361b0ec57aso48665565e9.0
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 13:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739223369; x=1739828169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8KnDLY3kffZnCGFmPEexJUKlO/NVt183lUvBn/SEPO0=;
        b=Zv2LhLjy5DAB037KYpl74pELKR5wTjg5ENN3HT1W+gGDXFx7OCfG7HPhKEf6XSXSPR
         Vfu2bnfs4qylZjpMWp5LOmcReuKpeZlliX1s/+He0EfXpPBCdYPR0VKv/7vlRO73Qtxw
         fUwtiklYFaT6npCYnUeAVubZEwg4ncJjHGfjPT1VcpE+v6kSfSpusxsINFiv47wOEP2v
         vA6VlnsHSw621d9Qy2icftkD843LTtslRnaVJ6bIAzbwOupblO9v5fuwJ44gntnqkqkh
         d8C5K23FshLqMfl/e+RfgCxBHGLtuO89EOcZE5jfsPYEw34TMnev5kH/7+wiCI9cDFHg
         scWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739223369; x=1739828169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8KnDLY3kffZnCGFmPEexJUKlO/NVt183lUvBn/SEPO0=;
        b=r3/PUc1UMHhX/KMJkz2zp1WHwl5/7bbnONfpM+qSaZYgdqBqjWYKlhbb7r4CjCvI5I
         2LpdwFyMiTsAXkB7ZjpmY/7VQrWmhfKNOjsiC60oSXnd13EjrZZLwon/iuUstRmQ6n3t
         oSLqNVtXz+l8judfJUIDe8wP3X5vNKO0ocjMVysIOI9dBGtPwdY3i79smG5NbMvpg3Lv
         xoSOtMpmFyi6WbLRli+B3wHs+Oc1/hnjT5o3bFbB6YD6mAMZI3SNGxyDUHqu/cMeOP+k
         DqMDz68zcdgvEDoz6mK4Oulo3Hegs9dx+d6iSJ5PH06+vg/mMbQTIH2hgNlM20mVeLYI
         swlA==
X-Forwarded-Encrypted: i=1; AJvYcCXl80YUaU8MPVDHZcfs/pUzzxgqbf9utvOoXtnuxAebUkqkWDyoZYjAr/i1EjhwxXKTtns=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYVgONmVp1e0ZEf+jiwCAK//cgzlXldiJAIl7FCI5v/C7KJueu
	HA2h+WxCKtkoPxg1DXC9eLmsTrVQ707ULgThFDRKzas2T+aUuuTcYv2JVjMpNnk=
X-Gm-Gg: ASbGncuJrNIH9T/yJ+jEkiOt8i2r9QJTtQ3xS6Ucb3hoih1MsuR2mFgR7onzYSAWo51
	TYpBIGEPhSOcZNXqn9OBPkFDlACWv3zeRu/mh1Lc0qx090Gv6YR5AXys4St21RxnVxb2NQjHk+7
	R0VKB/90AUzZc4rrNXFhkKldf+fwnzzld+FcgF64/gL2H7A7DbQi5M1827KaEWta3bTNsMddocz
	59hjIUhuyaaxgu2TjJQLX9QVLuBPZODoErW/triGM8h/cg2NxmDyx3s/IMXDWWDjBvW3B+flMZJ
	47EHdTuEPyHmrWgD
X-Google-Smtp-Source: AGHT+IEE/P9vsQR8DRZBtCxEbVJartmy037BYwcdFf30+Y++Re0XNH996Xl3DeOOL//RGxNKuAEJ9g==
X-Received: by 2002:a05:6000:1562:b0:38d:da11:df3c with SMTP id ffacd0b85a97d-38dda11e134mr7050032f8f.48.1739223368915;
        Mon, 10 Feb 2025 13:36:08 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4394376118esm47541515e9.40.2025.02.10.13.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 13:36:08 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 04/15] riscv: misaligned: use correct CONFIG_ ifdef for misaligned_access_speed
Date: Mon, 10 Feb 2025 22:35:37 +0100
Message-ID: <20250210213549.1867704-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250210213549.1867704-1-cleger@rivosinc.com>
References: <20250210213549.1867704-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

misaligned_access_speed is defined under CONFIG_RISCV_SCALAR_MISALIGNED
but was used under CONFIG_RISCV_PROBE_UNALIGNED_ACCESS. Fix that by
using the correct config option.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/traps_misaligned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index eb9157e3af73..57ded7e74dd8 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -362,7 +362,7 @@ static int handle_scalar_misaligned_load(struct pt_regs *regs)
 
 	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, addr);
 
-#ifdef CONFIG_RISCV_PROBE_UNALIGNED_ACCESS
+#ifdef CONFIG_RISCV_SCALAR_MISALIGNED
 	*this_cpu_ptr(&misaligned_access_speed) = RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED;
 #endif
 
-- 
2.47.2


