Return-Path: <kvm+bounces-16651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E42CF8BC6F3
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:35:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DF481C21203
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68DBC143C46;
	Mon,  6 May 2024 05:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2unHDLWB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52968143891
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973503; cv=none; b=GtFpZWSBxWp8T4YqvvJVha6YdF9fiwrljuDRqin9FaDdN7PdF2ZRC8fgJdTgrWprz64fF4iOul7vj5gHcR3O/3UQcgkvMgLckvpVR76xmfru+xDKGwKJHUzluHsX1SJBBiPsRt15sqFmpnLe8PRuFEXCn6XaL4/kNGYUv0lbcaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973503; c=relaxed/simple;
	bh=5xoXXx7Xpex8DhqlHakrum/FpLO4xvulcSP3o1VPIH8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KLTvgc8PCWvgFDE886sxpPQFOjpvtvtk+qHFS7eU0vi+o+LthezT955w1CKEs5Lptxvxb8cQ+InWCiu3msxpo2qQX+Is+UarNaYlqudWc9K3Xpv85D3aKS+icJt11/Q8hxw54dbLunfcZdQE9igWUxxVbV20qwI8vRVLHlWtuFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2unHDLWB; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61bea0c36bbso37311657b3.2
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973501; x=1715578301; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=THi3gOlxQxAMXXgHRvCkfR5mjxmtrVYlP6M6JVvxmTs=;
        b=2unHDLWBxWqHDEKcNRYjWOoPDSQxnXJbmomZAkXRMZtyZjNu61oykReTlvVb30jsnF
         p78OK3JIJ6uK1Dpfnf9VbubzusAKBACnI87miCYCRGaolSz9pG+qCFQfjcvbV+1xlsED
         L1FWYyAYnce73lmxoBZ0W3OfoGDxGgqUrG+WbPHqzoC3SkMlmOGCiY8rnQXx/cChur3W
         WXKZlvNmNnCGvQujpAwinGXx9JcASqezEvG8Gdzc8+gkqFk/KEt1AJmcmu5WNpkK9q3K
         tGaGVMYgEM6sEezuDwkK2qmZ0CuhOJeYgqj0NjSUK+v7TnljZ5MjJNcKHUgLTv0XNxz2
         rohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973501; x=1715578301;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=THi3gOlxQxAMXXgHRvCkfR5mjxmtrVYlP6M6JVvxmTs=;
        b=CI86EZB2/dkAgczJK5V3MdG6PF+EO1cXnNou3E5W8mg9h5l2rEzk+3o51n4oaBXP0U
         tyuxZx6C2y6qCYxMdRuaROc6wedzqarfTWa0zNqnaBAKFDSGZLc8AJf8b6D1orYus+rc
         yZn1o9M6TrDsc62mESjmuouzrLPbOOhnH0i2wXamXSlMOIPV2o+kWaUGDpyHVs/BeBMk
         NDyW4jUvi0NXjuzwvOUJIZcWHPoLeZpi7z88tFlU+tzm9OJB3+CIIMctH4stbrdgE8GQ
         xcNp7mCCiVyznIPrB6TZUUMdnI+UWHVEjuJ1R5IFbcenrPa0W8B+C6TmQWoF8qr2HZ2j
         Pgag==
X-Forwarded-Encrypted: i=1; AJvYcCV6evcTr9uXzHFXydiR7Eb2du99jDS9vnnL/F6Sk7xG3ApjJkWVCsP4/VB22olZ03HRerNcRv1YAdkjfZSKU+k6Q54u
X-Gm-Message-State: AOJu0YygTx2leAvlxfcGnPPnweoOxyeUZdZ8GXLm9AOIVNuOTnTVZoY9
	nldPZobrYZ35siToue6om7l/km4WH4dSx/G7ukNspBVsZ4w/wneuAW1X9eNl6Khc0vb8WhI6sj8
	r08Ezuw==
X-Google-Smtp-Source: AGHT+IEYmggk2WwGell0TqnQ71miaUl2FhUZNaqsKuGzLTVYlU1EPwAFWGhsBJlBxcx0LtxoC1KIwD4hy2yP
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a81:52ca:0:b0:61b:e8a2:6f4b with SMTP id
 g193-20020a8152ca000000b0061be8a26f4bmr2546109ywb.1.1714973501433; Sun, 05
 May 2024 22:31:41 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:04 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-40-mizhang@google.com>
Subject: [PATCH v2 39/54] KVM: x86/pmu: Add support for PMU context switch at VM-exit/enter
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

Add correct PMU context switch at VM_entry/exit boundary.

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3152587eca5b..733c1acdc8c1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11009,6 +11009,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}
 
+	if (is_passthrough_pmu_enabled(vcpu))
+		kvm_pmu_restore_pmu_context(vcpu);
+
 	guest_timing_enter_irqoff();
 
 	for (;;) {
@@ -11037,6 +11040,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		++vcpu->stat.exits;
 	}
 
+	if (is_passthrough_pmu_enabled(vcpu))
+		kvm_pmu_save_pmu_context(vcpu);
+
 	/*
 	 * Do this here before restoring debug registers on the host.  And
 	 * since we do this before handling the vmexit, a DR access vmexit
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


