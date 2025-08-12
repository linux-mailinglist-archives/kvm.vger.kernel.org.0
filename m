Return-Path: <kvm+bounces-54533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A7E3B22F0D
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:29:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4741E1A23A69
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 17:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6191D2FD1D5;
	Tue, 12 Aug 2025 17:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MJvCgveK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEF92FDC26
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 17:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755019729; cv=none; b=jwkehvI0R68wRIa3SfiiGbfqonnDTtfnW6wdWKeSia1zgrJ5jJgScWEtNLeef6r71zUvb8EQhRqq0HEw4ETqfuREHiUbfJLW5k6NIit9WMEapr7ynzgqDSrxABPlF5WrLDNMsg8avT1E0pfWDWboMoWKVpzSJs6rDh8+53877OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755019729; c=relaxed/simple;
	bh=m7YpY/PCmdZhmLFKbpmZaWaGBGd2vtU0GO3oXWIyetQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=duEgwRIOP0U6BiWAYe9UNBrVWVg6cIREIa0narjfAJsywOx7ncegffyexrYfXt+BI+8D6/aUqECKOjMHobzFqA41s22BRMBsDVpxol4szGePNSDlfxNe7ucy9TI1EkTQuakYnwEUZLEyh4pLclUi1bfkGMDaFIDyvzNUUnIxWRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MJvCgveK; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-459d62184c9so34374835e9.1
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 10:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755019726; x=1755624526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Gx01KlGJnh6U0DX4MaOA7JQNq9Sq+XdhCp2GXJJ2aM=;
        b=MJvCgveKrMTy5jLl1FF0OM73tGQ669nGhsYSk0j8CNqVhUUhUtM58CI88hMHhI7don
         Dvjv8pJVllC8Vu8jC3k/w2gSNsLPXMYRYGhDNxEnsTuWDg3i5wm67lIkD9R8GOr4UY39
         CHs0j7XflAHdSfwvo3tRZbqVf5wnDbOwRbTKgqZgqeXs0msiloNgaJAueYLXSX/12SWR
         PgPel7iGxF1BY0JreVa8lUddtpq76UeykLl8+yJS/iEX/c072KdXoe6rdNC4v9V/xYk3
         ukMsj+NduQjlKaocNwb7qgsxsuSahgguugzwt2bo786AVFNq3K75Xl4Hij0m6/lHJjUc
         cttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755019726; x=1755624526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Gx01KlGJnh6U0DX4MaOA7JQNq9Sq+XdhCp2GXJJ2aM=;
        b=XJ8ZGGp4/eW8um1cAC9O0wTVPeef0AeQDLkKQKEr860fiTUbjXkcwb9xYlcLVtS6nw
         NIwRGi5EWJ4jC4HFlALRUKTYFzMGBpWTuI3C7Q9sYToL84/NoNeRqapmKdk1pBoMwPrm
         XeVIaKeuizmWgh2D/hqYI7CGvzn6M1aP/gT41m2yKpHscc5jofKOL5a+xRnug0u3OHQT
         118d90/ywKIARW6cCnxd39MR86Kk6991chOfnzgTiX7Nfe+96wkFKt0VOj2jEOlhIarl
         8mI8mRF4sN97XOsM7R3jSmcx8wNpINkefB71HXmccRNDvREUF66Oc4B9lUKlw/NIEgu6
         q8Lg==
X-Forwarded-Encrypted: i=1; AJvYcCVURVUxfGFv27hY303Mu8cEpMuHNklpHaQBjJ8KP9xYdGdVR0Fd4ICxs5Te9uigEFsv3XY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhvfiqP+I5LSEfoBztJX/8akcuBytyTvLQKgrGEvV5RFmMJGdL
	iAI3XCjo+j+TXVQHyoWZWoT/pFjX93mhnAtSfIW87PiP9OjiHwmyhw9qovfPoEHHmdo=
X-Gm-Gg: ASbGncv39iROwZNUU43zUhDCURDb6Id46eBwKzLuAAQkg/CKFVvMrJFNwz7Tjf5yjFK
	oSQDZLjOLMBut5rkOdPX7kWJFFOecTFBawFMZcoAGO0laz6Kotuszdq+LYEhf8tGkVkz6DaCDc5
	sGeuBlCmUzmjW0T8co8kRdorS+BHrAKiYfQo0RTg4tMNLkP+MxUnF6TfP93Evjj7pkfAB7w6A5s
	GxjQwkvE1qcu7vK6PzEyIhs7I7Z2FblYn9zLznqYOZnJTyXq0WAzZddh+NMK/G5BnqrV52hUuen
	UvpnoOu8XhytGzUhZe1ALXH1yUFKKM4JdYQ4gfsOhi8DOeQF7w7q1hL6xEmOrrvt6UI37tOXyzd
	ZjFMkpWFq8K7thV2TZ8JqCvxpKH1Z7p9yxLloCsydI/jsuT4zCs1mZIYy1Z9yiVBeFJBwf1hN
X-Google-Smtp-Source: AGHT+IEZ2BdB+DDDUDUmqAGCaLdS1J0twMRD6GrR7y46Lkn0qIPsngqJjPbgGbfbHEgD6hhro3LQXw==
X-Received: by 2002:a05:600c:548f:b0:458:bfe1:4a82 with SMTP id 5b1f17b1804b1-45a165e430fmr31995e9.16.1755019726154;
        Tue, 12 Aug 2025 10:28:46 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b9163ae600sm918558f8f.5.2025.08.12.10.28.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Aug 2025 10:28:45 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Claudio Fontana <cfontana@suse.de>,
	Cameron Esfahani <dirty@apple.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Alexander Graf <agraf@csgraf.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	qemu-arm@nongnu.org,
	Mads Ynddal <mads@ynddal.dk>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Miguel Luis <miguel.luis@oracle.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 04/10] target/arm: Factor hvf_psci_get_target_el() out
Date: Tue, 12 Aug 2025 19:28:16 +0200
Message-ID: <20250812172823.86329-5-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250812172823.86329-1-philmd@linaro.org>
References: <20250812172823.86329-1-philmd@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/hvf/hvf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 47b0cd3a351..48e86e62945 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1107,6 +1107,10 @@ static void hvf_psci_cpu_off(ARMCPU *arm_cpu)
     assert(ret == QEMU_ARM_POWERCTL_RET_SUCCESS);
 }
 
+static int hvf_psci_get_target_el(CPUARMState *env)
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
+                             hvf_psci_get_target_el(env), target_aarch64);
         break;
     case QEMU_PSCI_0_1_FN_CPU_OFF:
     case QEMU_PSCI_0_2_FN_CPU_OFF:
-- 
2.49.0


