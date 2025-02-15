Return-Path: <kvm+bounces-38259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB7CDA36B1C
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:37:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08FFC3B29A3
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CEFB155342;
	Sat, 15 Feb 2025 01:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LFGiJwN/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89D27DA62
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583408; cv=none; b=KsOTDEiaNvy36WRo6209CRtkRtMIeduHTxCFd8HhuX3Hu9q5p4WbK6dmGqAI6EbhnBjHYV2p4XvQhvW5vXrcIqRqGIboIgyKKiGTfu93tF/n1QeEyu76dSV90WuWb3qLV6unRePaT6H7IHxXMbA0e3RSgWK0SX/xZUqdBJGkfQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583408; c=relaxed/simple;
	bh=EYTckVRt+SrW5O9vIbjGQ/1lw9cTUuWQgFpLZZIOBTA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fRUTNfESilyU4QJ1qJZbPAabVVE6oL7+GNcE0P0UF+J4r7vR5oBqN5uqaZ12Ocv7OmxSiWi9ZvlhCksKKJSpAFSrI8JDRNNAyxaLF/S8Z/iRaHkwJmEsA8wcowZnDbP19Am3rOYuV3JB5Bz7tnfCvBzajLEVAtUmZNLckHduc+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LFGiJwN/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa228b4151so5507014a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583406; x=1740188206; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PD8Ukpndw/UK5PDUhEvF/Z4fIk6c8X0Z0o+NT+/BGPQ=;
        b=LFGiJwN/3fdDNkEkWMifGGkL+wMw3zi10Vc4DTaolO2GjpP37rqL/rAfOukJ2X6k2W
         vnSoUSU/lqDKNxB3NMf1qDO7tUS9cA17cXteALwljuISnfPWFY0fiTuUzfooc8FJ+W3r
         Pyai+4LeX+DglC3A7giilpeJSQNCJPZk6ahibc9u4u3Baf3onx1yB6Y89lx8spUIpdeV
         JFoe1c43vsd0CcOH4cVqpB3/21JswdweZfcLplAdv+lKTE4Y2gXuFdlIpq6vDNPIFgh0
         fI9mtMloQCqGrIcoHiymXH55QAdXLUgiIO1/YS4IwV+NSPgjCVZW9G9E/P1r11LzVtQ0
         +YJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583406; x=1740188206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PD8Ukpndw/UK5PDUhEvF/Z4fIk6c8X0Z0o+NT+/BGPQ=;
        b=BYKln/yzUtdkb61AjO17q7kaq5Drx3df9/Ffdm6L92V8fhnpAZq0fec/HoiUwxCVJS
         RmO25yvLOebVnKPZ5pSoHG2raikeKdsUHGAXjA+a8yq2iE9rHVE90Iq6ih3dDhnGOfYa
         kgBBQGs/nj5Ykao7w4abrM1+031cpg1X2v9jyXk+tNqETmZCWuap7QEdQNBSgBng6QA9
         OoNLmeZGE16CdyLciN0LKmp+zMHOFZwEA+lM3CyaUcHTU5hbIgIvcqcplsTQX6hK5i74
         ZwyrdkkAJkZXZs2TvCypUsDyUf8Dzrwrlv3Xh366UTpN9bt9Onm7PJ/nJ9d8BQpTuRe9
         Mr9g==
X-Gm-Message-State: AOJu0Yw1EpIZSfNuo1m2J1Q67hDHbilTD35RaFes3Sg6jYet0wDt57AE
	9lvid+koGM02tNKpsNzthh2T7MTnp2LcOesYJ9lTu3ZgBlIeDGBSWHIo3GKHjsSxNbGDJuvWIh4
	+GQ==
X-Google-Smtp-Source: AGHT+IESySHo4uvziOIyZofrIIauA4/+/j4D1daJs/4nL719YnpkGYiVAi4EGZ7B+C3Ke3tP8f7ITPXudE8=
X-Received: from pjbeu15.prod.google.com ([2002:a17:90a:f94f:b0:2fc:1eb0:5743])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b4a:b0:2ee:bc1d:f98b
 with SMTP id 98e67ed59e1d1-2fc41153d79mr1765654a91.31.1739583406465; Fri, 14
 Feb 2025 17:36:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:22 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 05/18] x86: pmu: Enlarge cnt[] length to 48
 in check_counters_many()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Considering there are already 8 GP counters and 4 fixed counters on
latest Intel processors, like Sapphire Rapids. The original cnt[] array
length 10 is definitely not enough to cover all supported PMU counters on
these new processors even through currently KVM only supports 3 fixed
counters at most. This would cause out of bound memory access and may trigger
false alarm on PMU counter validation

It's probably more and more GP and fixed counters are introduced in the
future and then directly extends the cnt[] array length to 48 once and
for all. Base on the layout of IA32_PERF_GLOBAL_CTRL and
IA32_PERF_GLOBAL_STATUS, 48 looks enough in near feature.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
[sean: assert() on the size]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index a0268db8..d3617c80 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -255,7 +255,7 @@ static void check_fixed_counters(void)
 
 static void check_counters_many(void)
 {
-	pmu_counter_t cnt[10];
+	pmu_counter_t cnt[48];
 	int i, n;
 
 	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
@@ -273,6 +273,7 @@ static void check_counters_many(void)
 		n++;
 	}
 
+	assert(n <= ARRAY_SIZE(cnt));
 	measure_many(cnt, n);
 
 	for (i = 0; i < n; i++)
-- 
2.48.1.601.g30ceb7b040-goog


