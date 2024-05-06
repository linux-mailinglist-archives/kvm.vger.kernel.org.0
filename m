Return-Path: <kvm+bounces-16647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 781968BC6EF
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F5C2280DD7
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D73143871;
	Mon,  6 May 2024 05:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hpkyk/Ki"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A6414375B
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973495; cv=none; b=eUuG+Z5Piv+GtmwjCiWSHQYNH0VOYqyKkhrKLFNfEkWshiPa0lqP9zt3r5xn5bmh+N21X/EClbxFT2dizIRmkblDSwFv/WCfbHaGyT/dDBEHu83JpNGc0WgBtJEhsXWRw6/TP4epxbF/+LZKx6oAJHMO64maBZf0iadCnJ6Ssec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973495; c=relaxed/simple;
	bh=HD1onq+BM7vYR58gsYAJg5M2X2pNaaeWilUMXxocmNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RNh0uygNCPQzYkA7n49ggPzx/JAiPQ6pUzUUtE+DJm2GIKtM4eamqKxzvb9YxuwsjPGJvTzMjYiM7rLFDZVWuwE5kul0iYYmR0D7xVhvjDDoXsc4TmFc9BeWQWvZpvIVDGBBWUyzGBJmSeZf13m2Vb5AMqKzteQEbnTcWK+Fj+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hpkyk/Ki; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2b3f16d858bso2180751a91.2
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973493; x=1715578293; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=C0JCnLRPCbODnXYFpihmXgFKGkWQHr1nsLQGrDq6KcE=;
        b=hpkyk/KipJg+3wQDdc3C0XM3e7EAH3OGUXyPEcGK502/eIVJ/FmY7OFcIyuXEPCDdW
         4XQnBj9BBPVmU7LaZXxyiOdTSCMfmqFBZhIv33099Jv4A30QR9e7uN15egDSxJjOAacq
         lIAuus751yRHbwbE3uCctKoZVLHkA2c5xnesCV1hJuLEcMGF8JzLrj5m4E8X+IM+wS7s
         I+FodPgcmZx5Mi5xIl5V37Ai4/wJtydUTldpMp4dFukJKUT4yt2AITbHoRYG9io4kjv7
         7D3eQmNLfBrt2bXLmMBQLC3qdhDoyLsPTo0kJW75ZKzaiCf0zifZ/ZfR224MN9ROOqtN
         BxlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973493; x=1715578293;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C0JCnLRPCbODnXYFpihmXgFKGkWQHr1nsLQGrDq6KcE=;
        b=kCkINNkbbLbYdbNqOdczM5ODsjtW8zmfK2tEGK8vzyoe9cf0vn556JXtZ6+4slrywA
         JoqIvF2T4+M02jDjuaoB/WdU5V/ZJGrkamdwxSHZRyVbvOB4X9cqJbKxB1S7BrfntIrd
         IicCnNwb8e5hsUFBT224RIru9j1eO4zSnWxGVSoNXBj1f1Mtr15kL8uW9k6MGATw8PJI
         UFjM8jOsjeTmpkEyQzrxi6+b+AcKRFuQ7NjeT1xciMbVTQiYEnFgomIwxKt1en0eKqrN
         lr1idEUPHWvNcfNsawWW+54CgMxoGUIFDqEiSFWFrh6Sp75XhEV9STRdUvy/qe5XUVEC
         +SNw==
X-Forwarded-Encrypted: i=1; AJvYcCW03j5dZEKBIxsLo8fiXWxl7gYTbCiQYX07OhReq1kiW2tWoWc6o9/4fQnaN4Va+K/tmtHWeOvvaxmN6u5HDXiDOo5F
X-Gm-Message-State: AOJu0YxrP+FGGYxyqpDqNEpTpaWbB9dZkbJb8vHGtJzJE9sCj3HgCb2Y
	mow1IACj49kA5bLjq+slfdW1UuAJqCROCjlgoCrV6nZZfTzcCL8Utf32I6NvlKJBWVk2RrAwmLD
	7kio9FQ==
X-Google-Smtp-Source: AGHT+IFSTATZx92lr0Fqgyn401mL0nwJMHp0HmidDShAyEYFxJ7lIm81SMBUOz/vcz6u75ELYSoQV3OtBOLl
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:90a:f692:b0:2a3:8648:c8a4 with SMTP id
 cl18-20020a17090af69200b002a38648c8a4mr30515pjb.0.1714973493414; Sun, 05 May
 2024 22:31:33 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:00 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-36-mizhang@google.com>
Subject: [PATCH v2 35/54] KVM: x86/pmu: Exclude existing vLBR logic from the
 passthrough PMU
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

Excluding existing vLBR logic from the passthrough PMU because the it does
not support LBR related MSRs. So to avoid any side effect, do not call
vLBR related code in both vcpu_enter_guest() and pmi injection function.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 13 ++++++++-----
 arch/x86/kvm/vmx/vmx.c       |  2 +-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f0f99f5c21c5..6db759147896 100644
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
index c86b768743a9..b6ed3ccdf1af 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7525,7 +7525,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	pt_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
-	if (intel_pmu_lbr_is_enabled(vcpu))
+	if (!is_passthrough_pmu_enabled(&vmx->vcpu) && intel_pmu_lbr_is_enabled(vcpu))
 		vmx_passthrough_lbr_msrs(vcpu);
 
 	if (enable_preemption_timer)
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


