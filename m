Return-Path: <kvm+bounces-22871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0414E944274
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D4F31F23781
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CBBB14F104;
	Thu,  1 Aug 2024 05:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BuGxJBF3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7BB14EC46
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488423; cv=none; b=rVALLT8oFfkOg8OmDBl+dgXgaVBR9W5hNBouU5pizJ2nj32Bz+Wsg1Zq+SbXtrgWfMIRVhfK2NGRzrTulmz0J+1BSKGofPyVOdVoUlSEcRClSDzl/tSybxFPNt8q5Ls4RxYZf0gV2IyBfND5i9IJNlE/MwxreBtUZAqy9k3E2x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488423; c=relaxed/simple;
	bh=uchEYIDNrqNFkFo5hYnWZA3xII4jFCfDZ+jnDG9DxfA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UC+zehEF7mB4K5FL1BCHw9U3RxwPygg2V/OHQTDGI8zIMFg1mHW5Z0jbepr0VwFnCTtHLWVcm2hIx49xg8J9OMCrNepmhpygKQMOxnAN3FikyRrg+qFGWPzUnJyxPkmhmTuElUOOSF0XxqAEHrkQYo3ZJSRCFK/FaJ7hCe8Erw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BuGxJBF3; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fd8a1a75e7so52008235ad.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488422; x=1723093222; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EzPwInoXw8r9R9/3N5pxZC1Jl8vARWmduDMAlNnpjFU=;
        b=BuGxJBF3Ukh+ThmtE8NZNed4/uKJ+k+jmyjVJSBuk3Y+ICLP5Sp6Fn5L64y3wb3XTR
         Fg1eE+5LtYbHU1W/z0hkKEm0aMNLygVkQQwk5igthxhpL9ZLAqjridEmpRUUjc8G98tq
         WMjjd5M/StoOofFfwprDIPmS9Aonf3Uzl0NlNbIPHUiqvtw4knEoF3wZR+Ccz+0DyXqi
         NaMjyk+ntxdAfodg3JWunPmkI1gwgqxJNiZCFTVsAI5R/nkERsuHwViy4rR0C/9U0jBt
         uNjhyo9Llonyg/kdM3cva3Pe24JUXAPcAHUKxOL84K36h2VtYP0300ymdoF8y17a2+Sn
         h//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488422; x=1723093222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EzPwInoXw8r9R9/3N5pxZC1Jl8vARWmduDMAlNnpjFU=;
        b=eHLTAiRLzv9n5EGw5HXK5JlxvnyLmcJrAoC8ho9U9+Vm2Yvmog3lNFSRwnT0LiCZAc
         3j5AM/FlzbxV1yjUvkSfftMH3/oyH9OwH8i4L0aucX9FmaixOk2O2JMFmgfNZr9mvsOv
         H0JVb55RuptHiqtjOqU8RQMz7oAMtcoOUEDS4P46RCLTEiKBi5KIfPxGAq81H5QzvxBu
         wcKMro6DJMA2XNh+XbxnbKPgpBzQ94fsRf1VzdpBtVk/SmrzwB9S9yjQEte8kD7xhewB
         WBRQz6PBO319z7xPGaturNdQrU/yGWZxU7CrxzwT0yo9MPGvskTmMUG8tkx33rmfUev2
         HA6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXwcq3WXUwlcnuwyGxrEKgZAmNrYuqSQ+p1ZeVqqJLhJO/6kekfNV0C5j520J940hpxUodpvKndauJXp3wgDMdTaI10
X-Gm-Message-State: AOJu0Yw9asVCMvAEMr61/4A51U4k8DlBAajL0XFWFKW15+cakFbZZOze
	knREwx4WN2mbKzumfgxX8dxyikJpf+cXsedfDj28+aHPb0Nd8XMlDWIsrfCk/D2Q0nzT4MklDiQ
	vhLugXg==
X-Google-Smtp-Source: AGHT+IHohXLG4T4Jt5qVEfQZjBK6DSuynxcBatU4fUbztWoehHb/r3igek7rZ7u8FLodPcj9Uxxqgk0dP+nQ
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:903:41d2:b0:1fb:1ae6:6aab with SMTP id
 d9443c01a7336-1ff4ce2a602mr1109605ad.2.1722488421540; Wed, 31 Jul 2024
 22:00:21 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:47 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-39-mizhang@google.com>
Subject: [RFC PATCH v3 38/58] KVM: x86/pmu: Exclude existing vLBR logic from
 the passthrough PMU
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Excluding existing vLBR logic from the passthrough PMU because the it does
not support LBR related MSRs. So to avoid any side effect, do not call
vLBR related code in both vcpu_enter_guest() and pmi injection function.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 13 ++++++++-----
 arch/x86/kvm/vmx/vmx.c       |  2 +-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index c61936266cbd..40c503cd263b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -660,13 +660,16 @@ static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
 
 static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
-	u8 version = vcpu_to_pmu(vcpu)->version;
+	u8 version;
 
-	if (!intel_pmu_lbr_is_enabled(vcpu))
-		return;
+	if (!is_passthrough_pmu_enabled(vcpu)) {
+		if (!intel_pmu_lbr_is_enabled(vcpu))
+			return;
 
-	if (version > 1 && version < 4)
-		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
+		version = vcpu_to_pmu(vcpu)->version;
+		if (version > 1 && version < 4)
+			intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
+	}
 }
 
 static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b126de6569c8..a4b2b0b69a68 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7561,7 +7561,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	pt_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
-	if (intel_pmu_lbr_is_enabled(vcpu))
+	if (!is_passthrough_pmu_enabled(&vmx->vcpu) && intel_pmu_lbr_is_enabled(vcpu))
 		vmx_passthrough_lbr_msrs(vcpu);
 
 	if (enable_preemption_timer)
-- 
2.46.0.rc1.232.g9752f9e123-goog


