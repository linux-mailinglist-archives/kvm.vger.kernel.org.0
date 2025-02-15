Return-Path: <kvm+bounces-38260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FABCA36B16
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 269FA16A7C5
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF3551422D4;
	Sat, 15 Feb 2025 01:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2eGyKYs7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F201547E9
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583410; cv=none; b=NFaVouLKuH108HuZhCJezekDfJFu5AjCq/rwlf6Q9AbctDaL3D1ECrc+dvE/VaQNmy9AA4dspyIFLat8ATmtBlm3m8usVOa5Qk4UvqRil/RyNiDsHxVxzupOqWZ/SxUpT4LX8Q2N0GvA6gg9jvv7dKg6i+Ad0wGNpT3FAzw45bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583410; c=relaxed/simple;
	bh=VNKTT+fzh++n9JD2anqgsJxIeo9Is1SdR53phHkpq30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EYe9sNzm/csQnZykICBIGE5jFeat02kcUADLp7QwRNfVVhGIdtIDjyQRyZObVyPYvVjvzw+D+/ha8Ya8YiGneDJJ8Somk8SWGV8dLXm+kszWQBZ6DgsCkBNWI52u5fJaqkDXfnde1ateQeXfj33OPcMbZzm+NA0y4xiiEUBM0hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2eGyKYs7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc17c3eeb5so4582286a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583408; x=1740188208; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pzm+K3t3KM00J7ScLd2XzYpWeApdhhI0i1mD2nIUk40=;
        b=2eGyKYs7P64qJThdXQUGLsO1h2Sc5PWtJWj5ROHI7Ed05Z+Y0WAPKaZcN8SZ3Dj59A
         SMbU9VsbTkjqlv4uaVgQCAnEOguGOJ/FdljeCokhv7AHeOLRaPvT04Lh79sutVCQK5dN
         qfA6DwJZ7P9wMBXicvagT/M9OCp0qLrx5F2wr2CiIAIVDx4NhzquIMbnBHnTkd9zkKVo
         SrdFWiqPxERi1ZazsrN4ailsBIPZQmobv8gYg260VSnDVz1Mnk7nYz1p9Utc0v02Gjsr
         ypPMTV9n3bK6XSJWtAMkoQJyTB0H+l0Ohp2iAsyYd+4a+zPAgzxiDUabryeV3LYdIFD9
         OkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583408; x=1740188208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pzm+K3t3KM00J7ScLd2XzYpWeApdhhI0i1mD2nIUk40=;
        b=JaR9cyD976L7rIo+Lu+QjZP22pHU4e+hzgxC1ixU3ExJ9Qiw+4bji6CEjnawuda0Yw
         wbT5DhtZfn940Yu/S2Nf8Fx5gMY4/nGOz3c17elRiOlqldmoMQcc+5/EKJ2zwTg2yKR1
         HMNuSPTiLbHXuvDDo50YJGKkcMP6EJtP8KyxI0KP7Z5s7SHt52i+8QKAW3kZBRs8fYIx
         WptiMQ11022N1PA5EeajH4OHRZAcSRw5pOz9lvIjHTpIS/KyNstGhTbyBxRM8j3pkfA/
         vd1CV2D05eORbWt071cFKBt8ZxK5v1OcRP2SCXRc3Y/nI2pzd4uK8sXAAVO6XoGv+BB0
         i6Zg==
X-Gm-Message-State: AOJu0YwoUnMIHy65QXj48Y1T9slRc5AAs4oaiWsh2MBm3ZIPvNDzoGC7
	Xi3rEI2IDwZxnhu8D31lIPejynkqmeRr53SYfSf0NwxwACPoKgAdn86Fo6O/DtDkaRX4hBMFugc
	D6Q==
X-Google-Smtp-Source: AGHT+IGjYcQoOam3MDlYAgmovE1bKlebhOwmwaxvkYn4o+aieAffL7bW2XGIMuBp7mnemsVBLhSLe3sh6Cw=
X-Received: from pjbqa9.prod.google.com ([2002:a17:90b:4fc9:b0:2ef:d136:17fc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7c3:b0:2ee:a6f0:f54
 with SMTP id 98e67ed59e1d1-2fc40f10a5dmr2039118a91.13.1739583408199; Fri, 14
 Feb 2025 17:36:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:23 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 06/18] x86: pmu: Print measured event count
 if test fails
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Print the measured event count if the test case fails. This helps users
quickly know why the test case fails.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index d3617c80..89197352 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -204,8 +204,12 @@ static noinline void __measure(pmu_counter_t *evt, uint64_t count)
 
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
-	// printf("%d <= %ld <= %d\n", e->min, count, e->max);
-	return count >= e->min && count <= e->max;
+	bool pass = count >= e->min && count <= e->max;
+
+	if (!pass)
+		printf("FAIL: %d <= %"PRId64" <= %d\n", e->min, count, e->max);
+
+	return pass;
 }
 
 static bool verify_counter(pmu_counter_t *cnt)
-- 
2.48.1.601.g30ceb7b040-goog


