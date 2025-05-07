Return-Path: <kvm+bounces-45768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D952AAEF5A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:43:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F07487B69E7
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2285629186F;
	Wed,  7 May 2025 23:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FkkoevmT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38D7231C9C
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661368; cv=none; b=QMnwiZs5nqwJpeXmsAXJHWyeAgxauABbETskMg8TTyrCi1IMwQgeq5wg/111GpmvVMSocT4mws5RzPI2JWykrB3x+yh9OBg59jKJlNxfvHaGClEdnc5bgfMViDG7PW9RHMJ5nAWu8Ss32fnoLETHNO3uxbymVtIihdxZqnRqzJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661368; c=relaxed/simple;
	bh=vpF3aqJ8G1Nzy1z4/D/QO4/GNb59/siAKHys0N7ei/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GOKwrSmueil7+28v3AVFSKQY/SnhgQATuHz8pnYFnMwnUw1w9rfg9EnVawQDvAYz06mnJX+7LyFf0zKgYiF5nsBLPaNaM8vPIG9Xwt1Im+YwlZNKYLXfiEEof/Kf0r4Aki7uVDtc/j3+RyvSazT9tPXfi+dt/itlVlWXgrnLVJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FkkoevmT; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-227d6b530d8so4592625ad.3
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661365; x=1747266165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PFP3MpqDIAT/Xkpc6JOppR3V5lexoIXt45Qw9vGPUlk=;
        b=FkkoevmTrRxCqV9DO3+NR11abQLbRa6AWFE5aulAz1KnD81a92P1WbRy2wDa7nEAuO
         URHUJyqKpjua0ViVcmZ2cnEwlyewJf9c7SAa3ER3XZCh1TDj+uUW7MLCwasaJNqCCMOu
         GREQBM1icwFiuuyRkWouE0SkjIbhuEUcOk7zkVcwYqQM862G9xPQqr4Wf3eNXznUV3Oi
         /9vwFinvomTKefRXA6YQJ2QkRA+cB4L9383s5qJLpWi93hDLGWDDTibECg45rfiRHDlM
         YkNnwEz2TP1GiBixXm/zESCVfGiVldOWuovbujWxfLGePLwgb7jLqgeVnZCjTzMF1rbR
         d7Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661365; x=1747266165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFP3MpqDIAT/Xkpc6JOppR3V5lexoIXt45Qw9vGPUlk=;
        b=eeZG7eiEg+8kZj5jayAFoEbz90wcJS32H2Jdz34z3TpzJ3eESZjhlYIKiuWf/lBW6d
         EE7xST/DKYO/ZZtEdCIfrxBrS5HzXoWKN1nMNiGEfKDlT2IhJll51Zijlvw7o/scHSsQ
         SIlHVULfAGNAQJe4B/wz+Y8xorwTVSaWapLsXh8SMY0SnsXBh+2IWvV1bJGfbTR1XTLA
         d5L+RdwIV1loV4J7LRT/82LTaxhNmga08fV/bSoVkIHab4pylHosYsQ/DfxfmYocMnTw
         Ej/g0YakGvcLd+4CNFrcaRq9X99sp2W/8+M3iLqvyTjyjE+LzG87HJ6jP9PIVwQpNhVA
         Wi+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUTn46vaSpCnudtSBo5Mue19husZNgyXelQnBBN/H9ssaU3Nzp3wxK2DHelnBWViGcB9h8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZuQBfxcFI7RfJUJvVUTlNB5wf9u1hi6YagaTiv2/LQfLfB8V3
	tFTzO+IbYzwBaChuLlvOgi71xUv9la2rDuSlLN7J0g5h8ElLFXwlCo05f3eQ+ls=
X-Gm-Gg: ASbGnctMmcIHMp6TI44lm4tOPTeVSbE1RPV9yrrKpNdOsOjcSK/uFEqlv3FfQKEvaMP
	idTUdpHYRRtS39YJLU9yhZ+5rihGWZwPTvFHMPgNdbWFixT8TgTEykAfGtnhDaCXssjMNgbkhMs
	Rpn9FEvFY2yKEr4ccPUpFgf+gvk4iHWZrTDmNvjDUAxJDvM0nKqU2eOjoJZZmon4fM+3ewGorMz
	k7OEjL7Dk/TcIq6692A0ipP3U0iooDPiHcdfurjzND+q+ZF6VXXP2RxW9S9O0G5Mf81/0aR9sQh
	WvT4J8v/BwHVue4ucSSaJZRzMSsyOfK+p6l3Pl7a
X-Google-Smtp-Source: AGHT+IFRElYU/KSdQj6gvksHfb5N/L/kOA91LoLgQhb0WTU6VTAxYcNOCkcgNdJ7NYvydi9yp0l9og==
X-Received: by 2002:a17:903:19c7:b0:220:eade:d77e with SMTP id d9443c01a7336-22e5eddc7c8mr85104195ad.40.1746661365302;
        Wed, 07 May 2025 16:42:45 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:44 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 02/49] include/system/hvf: missing vaddr include
Date: Wed,  7 May 2025 16:41:53 -0700
Message-ID: <20250507234241.957746-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


