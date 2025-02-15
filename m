Return-Path: <kvm+bounces-38262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 060C1A36B18
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:37:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65DBC7A3334
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1B115A850;
	Sat, 15 Feb 2025 01:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cyo5wAnM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA29156F44
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583415; cv=none; b=rB9RsNpdmSFJY4wdXWm+Y1F5E4XptBWYAd9Np4HG74EsGSkPQx4cMVuZeY1kOEvrGVEQH9Br9+dmusNiD6pCjWAOMr2eNX7MbuuicdSfE5kfwV0RJ7QQbDeQjDiXdnpvDdBB2UcurUZJfYrlaFbSYHf2VGjYejB407qXM95IZTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583415; c=relaxed/simple;
	bh=heUNsR7O2oJmARCK5a9rDX4QUcsxloKKOM3pTSe69YA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YL2dWZm1WumqiLfF7/W3TDG8gXAjcDB2qbsCtqupcOdEzOztI10JnLUvUtm1FiXWmStoWlMFNtDmUlINX60s9OliZO7xCq7CK6VWr2Qwrsw2weqAUyPX6eoJqEkpRBM+vNbpkdU1BPT4ARxWkryRNz8ZbyksF1H2Hh8FbepyFUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cyo5wAnM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc2b258e82so3106484a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583412; x=1740188212; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=u4eIK5GYRC3vU5hQex9Sd/VmwsqD31JoX2XJtktxhXE=;
        b=cyo5wAnMUkAnH2H2BHOSuyCu32/SGPfMiVvCUqA2nqUC1W2w3tlmHh4fvkNL3WIWQL
         KYLZLH5waYBrMvkE4OIb8roTA3crCjRcwpVZ8jEUEJDIBO68gMUpyOyNZUoKf0yg1p9H
         Hjs80aGYRg6NF9Wq0+IKG3XYXIFntmxmZl6+EgaezsNtzSV+s+L6oNn5Qdvkvgqda/ep
         7PSf6pIwUEXuRmJRD3f3RY8nDrq3LxTjm8ILecE01EPeYVuUpgfturMFTrDlNUWhTxWh
         qMeAtXYtXkaIoGXgoGHmL+Um31oRtUOtzvIBVvXQRTYhYfiKwTuP/sxe2n6Yu0g4NWEz
         I/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583412; x=1740188212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u4eIK5GYRC3vU5hQex9Sd/VmwsqD31JoX2XJtktxhXE=;
        b=fp3Q917BOBwNjN46oVNmRwdvqVg4nqWm2nZKnPQVC1p1FO8HVHKjq6AiscK9CxOY2w
         kaS16UPsZZIyORfitZc9XoLImcItHkN7TYo1PZ6TpMUCOqrMrY8Xkkgy/qYg5/v3lBw9
         F+NhUCtNlzuNF8fwyimnUwyh4qNboQgJP1OGMDWFVdAdhs7Q/A6n7ITIfyEjjxhGX4T2
         h8ygEpr26F0Va0ZB+VgfCa4WY3LcEiUqcklOGfNJY0EhNje88ALsMmGS01KhHD695Ayt
         0XwCNHjgc5/NEWYjrQL9ltZF20ZOueaoVOJhrGRn44qM9jc8orVDHxG90HMX1lSmj+pr
         jKgQ==
X-Gm-Message-State: AOJu0YzxkHrFFMuHeSfhTIhR1L32GVxSCpbCehOzEY0zmne2uK9pJL3L
	RdgaDldMdARBO9oQj6sh6KdhXMd4v9npvuMblIFfpLPLdYWBIEm/dmGSfkA0V5ZV2AigSAybSaz
	axg==
X-Google-Smtp-Source: AGHT+IFIXWCFY/0NnOqfgay1QRWDMr/mYoZDPPhaohi9WHk7ocn1hlK1qE31P1uYU65aJkV3l7P2NWx58WE=
X-Received: from pfbgj13.prod.google.com ([2002:a05:6a00:840d:b0:730:7d23:bc34])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4311:b0:1e1:9f57:eab4
 with SMTP id adf61e73a8af0-1ee8cb4f0a7mr2476498637.16.1739583411856; Fri, 14
 Feb 2025 17:36:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:25 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-9-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 08/18] x86: pmu: Fix cycles event validation failure
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

When running pmu test on SPR, sometimes the following failure is
reported.

PMU version:         2
GP counters:         8
GP counter width:    48
Mask length:         8
Fixed counters:      3
Fixed counter width: 48
1000000 <= 55109398 <= 50000000
FAIL: Intel: core cycles-0
1000000 <= 18279571 <= 50000000
PASS: Intel: core cycles-1
1000000 <= 12238092 <= 50000000
PASS: Intel: core cycles-2
1000000 <= 7981727 <= 50000000
PASS: Intel: core cycles-3
1000000 <= 6984711 <= 50000000
PASS: Intel: core cycles-4
1000000 <= 6773673 <= 50000000
PASS: Intel: core cycles-5
1000000 <= 6697842 <= 50000000
PASS: Intel: core cycles-6
1000000 <= 6747947 <= 50000000
PASS: Intel: core cycles-7

The count of the "core cycles" on first counter would exceed the upper
boundary and leads to a failure, and then the "core cycles" count would
drop gradually and reach a stable state.

That looks reasonable. The "core cycles" event is defined as the 1st
event in xxx_gp_events[] array and it is always verified at first.
when the program loop() is executed at the first time it needs to warm
up the pipeline and cache, such as it has to wait for cache is filled.
All these warm-up work leads to a quite large core cycles count which
may exceeds the verification range.

To avoid the false positive of cycles event caused by warm-up,
explicitly introduce a warm-up state before really starting
verification.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
[sean: use a for loop and an more obviously arbitrary number]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 4353d1da..e672b540 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -603,11 +603,27 @@ static void check_tsx_cycles(void)
 	report_prefix_pop();
 }
 
+static void warm_up(void)
+{
+	int i;
+
+	/*
+	 * Since cycles event is always run as the first event, there would be
+	 * a warm-up state to warm up the cache, it leads to the measured cycles
+	 * value may exceed the pre-defined cycles upper boundary and cause
+	 * false positive. To avoid this, introduce an warm-up state before
+	 * the real verification.
+	 */
+	for (i = 0; i < 10; i++)
+		loop();
+}
+
 static void check_counters(void)
 {
 	if (is_fep_available())
 		check_emulated_instr();
 
+	warm_up();
 	check_gp_counters();
 	check_fixed_counters();
 	check_rdpmc();
-- 
2.48.1.601.g30ceb7b040-goog


