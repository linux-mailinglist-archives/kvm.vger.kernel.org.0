Return-Path: <kvm+bounces-54532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F179BB22F0E
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:29:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5EE67B5571
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 17:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3011E2FDC34;
	Tue, 12 Aug 2025 17:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RYpY5W/4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6052FDC2B
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 17:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755019724; cv=none; b=OXKDC7o65ZBL9HHn/Xgi8rrL37+Jb/Eis47do9Cnwl04JG1dUmHpRvhzP0zO0iQOCIcmy0xnPetE6aAhvdGujdCP/zcKtYs8W0bhIbuHTAMg5//QPFrPVZNhEqa/hMG/XuO+oGNq6UZpWpd1Dz+WEq4Oyzc99uKjBCH269P4eBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755019724; c=relaxed/simple;
	bh=dPwuNKd+AlkfSsBP3RGgr6MUPWQ1CJpjZgvsqu1LKn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EIvPMayZVVbdzzmz8vIpw9SCXMpEbAuOZ64XJi86sAeG3kKwcWX2EBPW8MmokdSpfX6VcI3EhaxOQvJbw5U3kAbdJ79eg3UCZ3FUIiG5rxORxxIRaxvm0w0mempeDeZx9xFl1PKgNUnCHnVrbgHhDYQ0uhOjnVKSgb5CtGXYtoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RYpY5W/4; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b78d337dd9so3668857f8f.3
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 10:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755019721; x=1755624521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EYt3XWa5JdTgcAHas+NCLzX0AYSjTul5kKCxbeujNLY=;
        b=RYpY5W/4aslTUg+FUHUt6Nc7+SxEQToAn0c6JUThFoIplhw5XDs1ZWzjxz3GfilG8+
         cacbh/AqAO43stqlXyhSOb05mRPs2zhU0dIvUocB2mNPPjG+8RYx8cyppiKyALW0YRUB
         J4Z/V+bvQKo3HLfkPZsUJYIBXLRDdJX/wixKl/KwaZE9yeKwn0NV/NJtyJv/8FuPGW06
         s2Ue1lhJLAM3hqZLsMmQvMwXf9c7Tq80aQ1K0m5Ial2eOjl3rPXDbhNg3mKR+40UVQbw
         30ncyReja7z6bftftNEyPgYfY1y6/LmzTS7sgsPn2l7Aw3ronbwaMiFlD8JOF0BInNLN
         WRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755019721; x=1755624521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EYt3XWa5JdTgcAHas+NCLzX0AYSjTul5kKCxbeujNLY=;
        b=YEOzFPN8sKz5IxifiWDqV+NuWnaMvHrQcXDh54KiSvzB9HPB6p5ge8iAlEN16LHm02
         Xvcbo3GJ7byRIPFFmj0mXfqFnyCEGCuGoQQYYe1Olqy3BS57r/jaQLqZ2u75zZDnuo4X
         nNMAZo4Wn2fuebr0ItfXsFoHkmg273aBPAHJJEJtr1jagXZDiqjj9Lu/+omyZpB6bqQ6
         yLPpWTAPAJUls4z+mMmbQ6NRmfF3FURKify7eljCtCNqr5g+aSsD/8mlLL5DQJcx8wTz
         PLP4//LFMuVEZz0E0wTon+RhyqsJsYU9wymgt2dvEFfBHL7yLldu7/Q6UZCNpSXqo6Zn
         Tz5A==
X-Forwarded-Encrypted: i=1; AJvYcCXoeSYB+WVwZpz2yc9FaqPC7IUkye5dpptJfrFj1M5xXFUEcXQfX5WtAwgSuiPdCBJFMlg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGiub1SUoPHIhycjIos2BkkD65lmZ8s8GCduaMghk4+NZwKfp5
	4dZMuoNdvbK+N1ve+Sk9uQ+7JnNLf0YFI6oH6tGaUniCxK63GfNK6Cjjy9mVt49BE5k=
X-Gm-Gg: ASbGncuAlbnauo2p8Fj4h7MDNwl4qOtShvra1KrJPHYCyDOBOJ2xQ+2J/fRdTpM0B6O
	IsAOFHwVRviYf+Kt0kLeZjCYyXaA0y89geMwtEWD4qcMXmqntGxhmwMw23X54Pvgn7wohNzmJVO
	yY+A/51MrrxiwtrP8QUON0TEUTx5StGJIlUg9eWf7MVOUGKyul46pCPkNO7UAm3egwHd9qt1/b8
	WlVAC1uL3Qg6BwiM1ZNGhUGn8DjX65qGqhHpo/9XpOjukRi9I98ud9xKNtt+tNLj7VhkBLFF2gl
	ZLhS76k04sBM8Ps+o80HrxOJqT42lbnpFkynF3ARzlxf/Vr4iPJfBEAdedkTePFyZx/8buFBWJn
	CQs2uAlQ22RJXMyRcqKRovchUv3eZMx3jNvTxoRJ7lPKB5N/DGi4V9eMWzrjjOtFdj/5K3ZQk
X-Google-Smtp-Source: AGHT+IFKDzIxMpZiGj7vZDL7rXt0avmWUA3RyLwDmE7PF+XxnCDfzncjSb/8L6jk6S1QcyKG6JKIiw==
X-Received: by 2002:a05:6000:178d:b0:3b4:9721:2b32 with SMTP id ffacd0b85a97d-3b91724ec5fmr221527f8f.10.1755019720839;
        Tue, 12 Aug 2025 10:28:40 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac036sm44716290f8f.15.2025.08.12.10.28.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Aug 2025 10:28:40 -0700 (PDT)
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
Subject: [PATCH v2 03/10] target/arm: Restrict PMU to system mode
Date: Tue, 12 Aug 2025 19:28:15 +0200
Message-ID: <20250812172823.86329-4-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/cpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index d9a8f62934d..1dc2a8330d8 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1551,7 +1551,6 @@ static const Property arm_cpu_pmsav7_dregion_property =
             DEFINE_PROP_UNSIGNED_NODEFAULT("pmsav7-dregion", ARMCPU,
                                            pmsav7_dregion,
                                            qdev_prop_uint32, uint32_t);
-#endif
 
 static bool arm_get_pmu(Object *obj, Error **errp)
 {
@@ -1576,6 +1575,8 @@ static void arm_set_pmu(Object *obj, bool value, Error **errp)
     cpu->has_pmu = value;
 }
 
+#endif
+
 static bool aarch64_cpu_get_aarch64(Object *obj, Error **errp)
 {
     ARMCPU *cpu = ARM_CPU(obj);
@@ -1771,12 +1772,12 @@ static void arm_cpu_post_init(Object *obj)
     if (arm_feature(&cpu->env, ARM_FEATURE_EL2)) {
         qdev_property_add_static(DEVICE(obj), &arm_cpu_has_el2_property);
     }
-#endif
 
     if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
         cpu->has_pmu = true;
         object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
     }
+#endif
 
     /*
      * Allow user to turn off VFP and Neon support, but only for TCG --
-- 
2.49.0


