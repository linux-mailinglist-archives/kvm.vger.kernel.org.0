Return-Path: <kvm+bounces-16648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7494E8BC6F0
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:35:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AA2A28175B
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96C014387F;
	Mon,  6 May 2024 05:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JwlXF4B/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFC2143876
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973497; cv=none; b=plsx7KgE0qEnG5+W14VYp5Ud9r38Ci4l29f9jts0PkYjyG68mi2jIKOWFH7V2rrvSWEWcSjTI9WE+i+WPZRshHoHFHzt+OvScGGrVjVgYjABC1LoJbo/ilF1LCmmfqVrmwICa0QFngNJO2RD4WnIQFJBAdJP+b+GzgPZglBOzUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973497; c=relaxed/simple;
	bh=31Z1OZcvDSu8c487A71d+TOh4+WdozUoAJ76NuUEixE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pQmLcFDgAWursqc5YW020fgiuWSc+fxTXW7AIm6QQuOCEztzmCWtmnB8RQllYsbJRoCAYu/ULoO2kaarQo9tMjDA0Qu096v9sfLySrdvIm9SltGuOIPK7qZKOMR/Vd4qYoARs2Ri2hZs01fN859wrnrCJc3lhC4u0rU1ogCmbfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JwlXF4B/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2b4330e5119so1374524a91.3
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973496; x=1715578296; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jvxmRNNzm0ialjJX5Kyuv9c+dTUZx8Ic7LeMSCgpNT0=;
        b=JwlXF4B/8KPUiFeneIr728i3JQF8Nu9iRbMpvTK5aSV0k9Nqa7an2V5V9HNi0VSkuJ
         XxoMM3vt07pY50mcbi5ZTaRrui2CY/l6lX48blRc2AVbjRd4TJEaZnADXbP7zWnqaDdK
         MeyZPKsgtGUhaU3A8694Ww5Ua/TJlTe8gFEIr2kDRpjSKg4i/AUBIP007CBuqCO97yvC
         MaiTbC6xGhUpKi/iidWu4EHTBbbbjMl284Sd14zr0LcOyGGD3Gl07tOd5xd/3nuh0k9p
         xz6VQQzoWNHJS0soaz7Vdw1nEw18d6ORDpRZnJBV1Fa8hjurami1P5qC2aUYMeNN9tiZ
         FnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973496; x=1715578296;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jvxmRNNzm0ialjJX5Kyuv9c+dTUZx8Ic7LeMSCgpNT0=;
        b=RazaKmj6b4sCxT7pPzlDMVurY05u79e1MrCTmaPqpFlTKR6uHBMkPVlQBS/MbZ/Yv7
         A2Fr8nSSgQgjaVXvYUOA08mpRgKqZ3L2b6V/2NpTWQeCsMiAN14cR1rrpgR2impDl/ks
         E3+KFlk9Cv9HL30E4mhaoRmzEP1mCxg7pv4y2ohYqXWx80jTpIaHFPHJB7iPUYif7IUv
         jH0W2/w1BGzOMz8IJ9bJPyfMfcrHacfvmOSvVL61flTvcDgaKP/uhoxwfDXDRbPtE2Bc
         Yw5dZznWFBYJ6c2ZE86q6CK8DNJ89iVqnVW9qko5W2UppZAohMxkKskUw3bXKL1ukucP
         ze4A==
X-Forwarded-Encrypted: i=1; AJvYcCUKPT2sJwXVOntQrpoNhFHRKFFQkMZcB1XMSzW/a0Sv9y833PHDXwpDOet5NERFy5CSx57bubRAKtCVISfAo8qUgtRk
X-Gm-Message-State: AOJu0Yyy+8Zt+RxEexBf4w8T6k9gOiI4QFaIhb/GKZqSBvhTf7xS9Fb1
	LndivTPrLPaOcCJ4nJ84UMOdUDiCy7DAYo6X1eYxJqg0HUR0XcJvqZtQMXLKjWuXDuPe8mosFXP
	a75Vhbw==
X-Google-Smtp-Source: AGHT+IH/mxinAZrdz3Klst7c4dV90NWXmunIvbcDxzTOCTvEO16RxUWtLqzAlW0j4Xl1ImWkT0Ah5CH55iWI
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:90b:8d6:b0:2b3:5eb5:6a76 with SMTP id
 ds22-20020a17090b08d600b002b35eb56a76mr25362pjb.3.1714973495401; Sun, 05 May
 2024 22:31:35 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:01 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-37-mizhang@google.com>
Subject: [PATCH v2 36/54] KVM: x86/pmu: Switch PMI handler at KVM context
 switch boundary
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

Switch PMI handler at KVM context switch boundary because KVM uses a
separate maskable interrupt vector other than the NMI handler for the host
PMU to process its own PMIs.  So invoke the perf API that allows
registration of the PMI handler.

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/pmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 2ad71020a2c0..a12012a00c11 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1097,6 +1097,8 @@ void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu)
 		if (pmc->counter)
 			wrmsrl(pmc->msr_counter, 0);
 	}
+
+	x86_perf_guest_exit();
 }
 
 void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
@@ -1107,6 +1109,8 @@ void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
 
 	lockdep_assert_irqs_disabled();
 
+	x86_perf_guest_enter(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
+
 	static_call_cond(kvm_x86_pmu_restore_pmu_context)(vcpu);
 
 	/*
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


